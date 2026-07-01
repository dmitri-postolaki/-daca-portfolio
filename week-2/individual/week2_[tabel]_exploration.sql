Ristvalideerimine ja Kvaliteedikontroll

-- Orbid müügid — kas on customer_id, mida pole customers tabelis?
SELECT COUNT(*) AS orb_klient
FROM sales s
LEFT JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL AND s.customer_id IS NOT NULL;

-- Orbid kliendid 0

-- Orbid müügid — kas on product_id, mida pole products tabelis?
SELECT COUNT(*) AS orb_toode
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL AND s.product_id IS NOT NULL;

-- Orbid tooted 0

-- Hindade kooskõla — kas müügihind ja tootehind klapivad?
SELECT 
    s.sale_id, 
    s.total_price, 
    p.retail_price AS tootehind, 
    s.quantity,
    s.total_price - (p.retail_price * s.quantity) AS erinevus
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE ABS(s.total_price - (p.retail_price * s.quantity)) > 1
ORDER BY ABS(s.total_price - (p.retail_price * s.quantity)) DESC
LIMIT 20;
-- Hinna ebakõlad 20

-- Kas on kliente, kes pole kunagi ostnud
SELECT COUNT(*) AS vaimkliendid
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;
-- Vaimkliendid 592, Klient ei ole kunagi ostnud 

-- Kas on tooteid, mida pole kunagi müüdud
SELECT COUNT(*) AS vaimtooted
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;
-- Vaimtooted 12

-- JOIN näitab ka need read, kus vastet EI leita
SELECT COUNT(*) FROM sales s
LEFT JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
-- count 1487

--Hinna-kooskõla kontroll — kas müügihind klapib tootehinnaga? 
SELECT 
    s.sale_id,
    s.total_price,
    p.retail_price AS tootehind,
    s.quantity,
    s.total_price - (p.retail_price * s.quantity) AS erinevus,
    ROUND(
        100.0 * (s.total_price - (p.retail_price * s.quantity)) 
        / NULLIF(p.retail_price * s.quantity, 0), 
    2) AS protsent_erinevus
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE ABS(s.total_price - (p.retail_price * s.quantity)) > 1
ORDER BY ABS(s.total_price - (p.retail_price * s.quantity)) DESC
LIMIT 20;
-- vähemalt 20 müüki, kus hind ei klapi tootehinnaga


-- Millistel tootel on suurimad hinnaerinevused?
SELECT 
    p.product_name, 
    p.category, 
    p.retail_price AS list_hind,
    AVG(s.total_price / NULLIF(s.quantity, 0)) AS kesk_muugihind,
    p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0)) AS erinevus
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.retail_price
HAVING ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) > 5
ORDER BY ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) DESC
LIMIT 10;
-- Miks võivad hinnad erineda? (allahindlused, hulgiost, andmeviga?)
Enamasti müüakse odavamalt → viitab allahindlustele.
Mõnel tootel müüakse kallimalt → see on tõenäoliselt andmeviga.
Suurimad erinevused on naiste riietel ja jalanõudel.


    Soovitus Toomasele: Kõige kriitilisem probleem

    Võttes arvesse auditi tulemusi, on Toomase jaoks kõige kriitilisem probleem vaimklientide suur hulk (592).
    See viitab kas ebaefektiivsele kliendihaldusele või vigasele registreerimisprotsessile, kus suur hulk potentsiaalseid kliente ei jõua tehinguni.
    Teisejärgulise, kuid kohest sekkumist vajava probleemina tuleb käsitleda hinnahälbeid (20 juhtu), 
    eriti neid, kus müügihind on tootehinnast kõrgem, kuna see viitab selgetele andmevigadele, mis moonutavad müügistatistikat.
