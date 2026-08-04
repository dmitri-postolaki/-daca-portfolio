Week 4 SQL Aggregation

  KODUTÖÖ
  
GROUP BY harjutused

Osa 1: GROUP BY — Andmete Grupeerimise Loogika

Harjutus 1A: Shu — järgi malli 
-- Müük kuude kaupa 2024. aastal

  SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS kuu,
    COUNT(*) AS tellimusi,
    SUM(total_price) AS käive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY kuu;

--Tulemus

| kuu     | tellimusi | käive     | keskmine_tellimus |
| ------- | --------- | --------- | ----------------- |
| 2024-01 | 312       | 85618.65  | 274.42            |
| 2024-02 | 334       | 90181.83  | 270.01            |
| 2024-03 | 412       | 109559.98 | 265.92            |
| 2024-04 | 411       | 113838.38 | 276.98            |
| 2024-05 | 413       | 116843.02 | 282.91            |
| 2024-06 | 509       | 144558.18 | 284.00            |
| 2024-07 | 510       | 146800.80 | 287.84            |
| 2024-08 | 511       | 144870.17 | 283.50            |
| 2024-09 | 392       | 109267.47 | 278.74            |
| 2024-10 | 391       | 127622.32 | 326.40            |
| 2024-11 | 392       | 110573.94 | 282.08            |
| 2024-12 | 550       | 170623.28 | 310.22            |
| 2025-01 | 328       | 99416.87  | 303.10            |
| 2025-02 | 347       | 95778.25  | 276.02            |
| 2025-12 | 16        | 4773.57   | 298.35            |
| 2026-01 | 3         | 1192.01   | 397.34            |
| 2026-02 | 1         | 84.41     | 84.41             |
| 2026-03 | 4         | 1128.83   | 282.21            |
| 2026-04 | 2         | 200.80    | 100.40            |
| 2026-05 | 1         | 77.60     | 77.60             |
| 2026-06 | 5         | 1408.72   | 281.74            |


Harjutus 1B: Ha — rakenda uues kontekstis
Kirjuta ise päring, mis näitab müüki linnade kaupa.

SELECT 
    c.city,
    COUNT(*) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive,
    AVG(s.total_price) AS keskmine_tellimus
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogukäive DESC;

--Tulemus

| city       | tellimuste_arv | kogukäive  | keskmine_tellimus    |
| ---------- | -------------- | ---------- | -------------------- |
| Tallinn    | 3601           | 1006252.88 | 279.4370674812552069 |
| Tartu      | 1764           | 523286.64  | 296.6477551020408163 |
| Pärnu      | 1231           | 374005.86  | 303.8227944760357433 |
| Narva      | 438            | 122226.14  | 279.0551141552511416 |
| Viljandi   | 359            | 102314.94  | 284.9998328690807799 |
| Rakvere    | 338            | 93379.03   | 276.2693195266272189 |
| Jõhvi      | 290            | 77601.15   | 267.5901724137931034 |
| Kuressaare | 256            | 76509.61   | 298.8656640625000000 |
| Haapsalu   | 252            | 73492.83   | 291.6382142857142857 |
| Võru       | 216            | 60983.07   | 282.3290277777777778 |
| Valga      | 216            | 59530.76   | 275.6053703703703704 |
| Paide      | 169            | 53148.87   | 314.4903550295857988 |


Rakendus — oma analüüs
Ülesanne: Mõtle äriküsimusele, millele GROUP BY aitab vastata. 
Kirjuta päring ja analüüsi tulemust.

SELECT 
    TO_CHAR(s.sale_date, 'Day') AS nädalapäev,
    COUNT(*) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive,
    ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
FROM sales s
GROUP BY TO_CHAR(s.sale_date, 'Day'), EXTRACT(DOW FROM s.sale_date)
ORDER BY EXTRACT(DOW FROM s.sale_date);

--Tulemus

| nädalapäev | tellimuste_arv | kogukäive | keskmine_tellimus |
| ---------- | -------------- | --------- | ----------------- |
| Sunday     | 1444           | 437716.54 | 303.13            |
| Monday     | 1467           | 427352.75 | 291.31            |
| Tuesday    | 1481           | 408714.58 | 275.97            |
| Wednesday  | 1400           | 405979.45 | 289.99            |
| Thursday   | 1455           | 424681.25 | 291.88            |
| Friday     | 1436           | 396475.16 | 276.10            |
| Saturday   | 1435           | 408258.25 | 284.50            |


Osa 2: HAVING ja Agregaatfunktsioonid — Filtreerimine Pärast Grupeerimist

Concrete Practice: HAVING harjutused 

 --leia kliendid, kes on ostnud üle 500€
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    COUNT(s.sale_id) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_price) > 500
ORDER BY kogukäive DESC;

  
  --Tulemused

| customer_id | nimi           | tellimuste_arv | kogukäive |
| ----------- | -------------- | -------------- | --------- |
| 3618        | Tiina Pärn     | 73             | 27668.02  |
| 3350        | Priit Rand     | 76             | 26286.10  |
| 2997        | Kevin Org      | 78             | 23467.13  |
| 2889        | Laura Tammik   | 74             | 23385.82  |
| 3648        | Erkki Ilves    | 72             | 22942.42  |
| 3605        | Anu Kuusik     | 77             | 21626.10  |
| 4206        | Kersti Lill    | 71             | 21137.47  |
| 2221        | Riina Lill     | 67             | 20972.33  |
| 2154        | Annika Saar    | 66             | 20726.79  |
| 3722        | Ago Kull       | 64             | 20124.61  |
| 4949        | Marika Sepp    | 66             | 19078.20  |
| 4178        | Ago Lõoke      | 70             | 19010.85  |
| 3556        | Merike Vaher   | 69             | 18332.28  |
| 3810        | Pille Sepp     | 56             | 18080.99  |
| 4018        | Terje Kukk     | 61             | 16145.97  |
| 4334        | Priit Järv     | 33             | 8302.14   |
| 2775        | Ants Paju      | 27             | 7923.54   |
| 2495        | Urmas Kask     | 25             | 5684.81   |
| 2955        | Tiina Laas     | 13             | 5417.71   |
| 3699        | Marko Pihl     | 10             | 4522.92   |
| 2196        | Marika Must    | 11             | 4480.32   |
| 4076        | Merike Kangur  | 10             | 4471.93   |
| 2961        | Siim Männik    | 6              | 4419.27   |
| 2874        | Annika Valk    | 5              | 4091.60   |
| 2629        | Sandra Paas    | 6              | 3990.98   |
| 4024        | Reet Kõiv      | 12             | 3842.30   |
| 4286        | Anna Org       | 7              | 3708.37   |
| 2913        | Aili Hurt      | 11             | 3655.60   |
| 3643        | Mart Liiv      | 7              | 3559.90   |
| 4160        | Ülle Vaher     | 7              | 3559.39   |
| 2707        | Külli Sild     | 4              | 3477.28   |
| 4229        | Maris Luik     | 7              | 3434.64   |
| 3206        | Indrek Laas    | 5              | 3427.36   |
| 4396        | Maie Tammik    | 5              | 3306.10   |
| 3692        | Väino Sild     | 8              | 3293.95   |
| 2684        | Andres Sild    | 6              | 3287.93   |
| 4585        | Lauri Männik   | 6              | 3287.58   |
| 3843        | Rein Must      | 7              | 3266.78   |
| 4862        | Erkki Liiv     | 6              | 3186.64   |
| 3035        | Grete Tamm     | 6              | 3185.20   |
| 3470        | Raivo Nurk     | 5              | 3166.25   |
| 2318        | Anu Teder      | 11             | 3148.80   |
| 2343        | Tarmo Nõmm     | 7              | 3118.45   |
| 4687        | Sirje Rand     | 7              | 3116.43   |
| 3696        | Tiina Järv     | 5              | 2980.90   |
| 4783        | Lauri Kukk     | 4              | 2935.81   |
| 2285        | Maie Pärn      | 5              | 2925.69   |
| 2652        | Heino Mitt     | 6              | 2920.53   |
| 2712        | Väino Rosin    | 7              | 2902.95   |
| 4701        | Enn Rebane     | 7              | 2874.92   |
| 3057        | Priit Lõoke    | 7              | 2860.92   |
| 3166        | Terje Lill     | 6              | 2859.45   |
| 4678        | Kati Põld      | 7              | 2850.45   |
| 3545        | Merike Rosin   | 6              | 2850.30   |
| 2713        | Kristiina Raud | 9              | 2848.88   |
| 2397        | Kalev Puusepp  | 4              | 2847.68   |
| 4584        | Katrin Salu    | 5              | 2834.74   |
| 4176        | Triin Tammik   | 6              | 2828.68   |
| 2826        | Ants Lõoke     | 7              | 2788.18   |
| 4712        | Tarmo Rosin    | 5              | 2788.10   |
| 4779        | Merike Kõiv    | 5              | 2784.51   |
| 2849        | Kersti Põld    | 7              | 2748.10   |
| 4851        | Aivar Orav     | 7              | 2747.85   |
| 3852        | Nele Kivi      | 7              | 2740.79   |
| 2558        | Hille Mets     | 11             | 2733.29   |
| 2192        | Marit Talvik   | 8              | 2695.53   |
| 4886        | Indrek Veski   | 6              | 2688.30   |
| 2279        | Ants Puusepp   | 5              | 2683.86   |
| 3732        | Olev Sild      | 5              | 2681.42   |
| 2770        | Toomas Lõhmus  | 5              | 2662.20   |
| 3001        | Toomas Lepp    | 4              | 2657.02   |
| 3899        | Laura Mets     | 8              | 2655.03   |
| 4533        | Hille Roots    | 4              | 2647.00   |
| 4454        | Indrek Männik  | 10             | 2644.44   |
| 2952        | Sandra Sild    | 7              | 2632.69   |
| 2832        | Merike Laas    | 2              | 2625.52   |
| 4528        | Aivar Mets     | 5              | 2609.63   |
| 3957        | Margus Lepp    | 6              | 2598.19   |
| 4255        | Liis Mägi      | 4              | 2594.27   |
| 3228        | Liis Kask      | 5              | 2581.17   |
| 4767        | Kersti Lõoke   | 4              | 2578.12   |
| 3302        | Siim Toom      | 6              | 2567.91   |
| 4451        | Katrin Värk    | 8              | 2560.35   |
| 3048        | Liina Org      | 6              | 2558.87   |
| 2863        | Maris Paas     | 7              | 2557.43   |
| 2687        | Meelis Mets    | 4              | 2554.02   |
| 4259        | Annika Paas    | 10             | 2546.41   |
| 2163        | Kadri Kull     | 5              | 2542.08   |
| 4418        | Margus Nõmm    | 7              | 2532.13   |
| 4205        | Kristi Aas     | 7              | 2524.59   |
| 4115        | Siim Aas       | 7              | 2521.85   |
| 4519        | Külli Rand     | 4              | 2508.65   |
| 3305        | Urmas Raid     | 7              | 2502.82   |
| 3608        | Tarmo Sepp     | 4              | 2496.09   |
| 3582        | Peeter Valk    | 8              | 2494.25   |
| 3268        | Rain Puusepp   | 8              | 2490.68   |
| 2270        | Hille Sepp     | 7              | 2488.45   |
| 2744        | Piret Kull     | 5              | 2480.73   |
| 3617        | Jaak Kull      | 6              | 2477.50   |
| 3432        | Ülle Nurk      | 5              | 2475.63   |

Liisi varude audit 
Kirjuta päring, mis leiab tooted, kus kategoorias on müüdud üle [vali ise piir] ühiku.

SELECT 
    p.category,
    SUM(s.quantity) AS müüdud_kogus,
    ROUND(AVG(p.retail_price), 2) AS keskmine_hind,
    COUNT(DISTINCT p.product_id) AS toodete_arv
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 100
ORDER BY müüdud_kogus DESC;


  -- Tulemus

  | category      | müüdud_kogus | keskmine_hind | toodete_arv |
| ------------- | ------------ | ------------- | ----------- |
| meeste_riided | 4121         | 188.61        | 81          |
| jalanõusid    | 3737         | 213.26        | 71          |
| laste_riided  | 3686         | 84.70         | 68          |
| naiste_riided | 3604         | 195.55        | 68          |
| aksessuaarid  | 3231         | 122.88        | 62          |

 Rakendus — WHERE + HAVING koos
Kirjuta päring, mis kasutab NII WHERE-d KUI KA HAVING-ut koos. 
    Mõtle äriküsimusele, kus sul on vaja filtreerida nii üksikuid ridu kui ka gruppe.
Näide äriküsimusest: "Näita ainult 2024. aasta Q1 tellimused (WHERE), grupeerituna kuu kaupa, kus käive on üle 5000€ (HAVING)."

SELECT 
    TO_CHAR(s.sale_date, 'YYYY-MM') AS kuu,
    COUNT(*) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive,
    ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
FROM sales s
WHERE s.sale_date >= '2024-01-01' 
  AND s.sale_date < '2024-04-01'          -- WHERE = rea-taseme filter (ainult Q1 2024)
GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
HAVING SUM(s.total_price) > 5000           -- HAVING = grupi-taseme filter (ainult kuud üle 5000 €)
ORDER BY kuu;

--Tulemus

| kuu     | tellimuste_arv | kogukäive | keskmine_tellimus |
| ------- | -------------- | --------- | ----------------- |
| 2024-01 | 312            | 85618.65  | 274.42            |
| 2024-02 | 334            | 90181.83  | 270.01            |
| 2024-03 | 412            | 109559.98 | 265.92            |


Osa 3: CTE-d ja Window Functions — Keerukamate Päringute Struktuur

CTE ja Window Functions harjutused
 Kopeeri ja käivita järgmine CTE päring, mis arvutab kuu käive ja kasvu:

WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS käive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    kuu,
    käive,
    LAG(käive) OVER (ORDER BY kuu) AS eelmine_kuu,
    käive - LAG(käive) OVER (ORDER BY kuu) AS kasv,
    ROUND(
        100.0 * (käive - LAG(käive) OVER (ORDER BY kuu))
        / LAG(käive) OVER (ORDER BY kuu), 1
    ) AS kasv_protsent
FROM kuu_myyk
ORDER BY kuu;

--Tulemus

| kuu                 | käive     | eelmine_kuu | kasv      | kasv_protsent |
| ------------------- | --------- | ----------- | --------- | ------------- |
| 2024-01-01 00:00:00 | 85618.65  | null        | null      | null          |
| 2024-02-01 00:00:00 | 90181.83  | 85618.65    | 4563.18   | 5.3           |
| 2024-03-01 00:00:00 | 109559.98 | 90181.83    | 19378.15  | 21.5          |
| 2024-04-01 00:00:00 | 113838.38 | 109559.98   | 4278.40   | 3.9           |
| 2024-05-01 00:00:00 | 116843.02 | 113838.38   | 3004.64   | 2.6           |
| 2024-06-01 00:00:00 | 144558.18 | 116843.02   | 27715.16  | 23.7          |
| 2024-07-01 00:00:00 | 146800.80 | 144558.18   | 2242.62   | 1.6           |
| 2024-08-01 00:00:00 | 144870.17 | 146800.80   | -1930.63  | -1.3          |
| 2024-09-01 00:00:00 | 109267.47 | 144870.17   | -35602.70 | -24.6         |
| 2024-10-01 00:00:00 | 127622.32 | 109267.47   | 18354.85  | 16.8          |
| 2024-11-01 00:00:00 | 110573.94 | 127622.32   | -17048.38 | -13.4         |
| 2024-12-01 00:00:00 | 170623.28 | 110573.94   | 60049.34  | 54.3          |
| 2025-01-01 00:00:00 | 99416.87  | 170623.28   | -71206.41 | -41.7         |
| 2025-02-01 00:00:00 | 95778.25  | 99416.87    | -3638.62  | -3.7          |
| 2025-12-01 00:00:00 | 4773.57   | 95778.25    | -91004.68 | -95.0         |
| 2026-01-01 00:00:00 | 1192.01   | 4773.57     | -3581.56  | -75.0         |
| 2026-02-01 00:00:00 | 84.41     | 1192.01     | -1107.60  | -92.9         |
| 2026-03-01 00:00:00 | 1128.83   | 84.41       | 1044.42   | 1237.3        |
| 2026-04-01 00:00:00 | 200.80    | 1128.83     | -928.03   | -82.2         |
| 2026-05-01 00:00:00 | 77.60     | 200.80      | -123.20   | -61.4         |
| 2026-06-01 00:00:00 | 1408.72   | 77.60       | 1331.12   | 1715.4        |


 3B: Ha — kliendianalüüs CTE-ga
Kirjuta ise CTE-põhine päring, mis segmenteerib kliendid VIP / Aktiivne / Tavaline tasemetesse.

  WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(s.sale_id) AS tellimuste_arv,
        SUM(s.total_price) AS kogukaive
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT
    nimi,
    city,
    tellimuste_arv,
    kogukaive,
    CASE
        WHEN kogukaive > 1000 THEN 'VIP'        -- üle 1000 € → VIP
        WHEN kogukaive > 300 THEN 'Aktiivne'    -- 301–1000 € → Aktiivne
        ELSE 'Tavaline'                         -- ≤ 300 € → Tavaline
    END AS segment
FROM kliendi_kokkuvote
ORDER BY kogukaive DESC;

--Tulemus

| nimi              | city       | tellimuste_arv | kogukaive | segment  |
| ----------------- | ---------- | -------------- | --------- | -------- |
| Tiina Pärn        | Tartu      | 73             | 27668.02  | VIP      |
| Priit Rand        | Pärnu      | 76             | 26286.10  | VIP      |
| Kevin Org         | Tallinn    | 78             | 23467.13  | VIP      |
| Laura Tammik      | Pärnu      | 74             | 23385.82  | VIP      |
| Erkki Ilves       | Tartu      | 72             | 22942.42  | VIP      |
| Anu Kuusik        | Tallinn    | 77             | 21626.10  | VIP      |
| Kersti Lill       | Tallinn    | 71             | 21137.47  | VIP      |
| Riina Lill        | Pärnu      | 67             | 20972.33  | VIP      |
| Annika Saar       | Viljandi   | 66             | 20726.79  | VIP      |
| Ago Kull          | Pärnu      | 64             | 20124.61  | VIP      |
| Marika Sepp       | Tallinn    | 66             | 19078.20  | VIP      |
| Ago Lõoke         | Jõhvi      | 70             | 19010.85  | VIP      |
| Merike Vaher      | Tallinn    | 69             | 18332.28  | VIP      |
| Pille Sepp        | Pärnu      | 56             | 18080.99  | VIP      |
| Terje Kukk        | Rakvere    | 61             | 16145.97  | VIP      |
| Priit Järv        | Tallinn    | 33             | 8302.14   | VIP      |
| Ants Paju         | Pärnu      | 27             | 7923.54   | VIP      |
| Urmas Kask        | Tallinn    | 25             | 5684.81   | VIP      |
| Tiina Laas        | Tallinn    | 13             | 5417.71   | VIP      |
| Marko Pihl        | Tartu      | 10             | 4522.92   | VIP      |
| Marika Must       | Pärnu      | 11             | 4480.32   | VIP      |
| Merike Kangur     | Tartu      | 10             | 4471.93   | VIP      |
| Siim Männik       | Tallinn    | 6              | 4419.27   | VIP      |
| Annika Valk       | Paide      | 5              | 4091.60   | VIP      |
| Sandra Paas       | Viljandi   | 6              | 3990.98   | VIP      |
| Reet Kõiv         | Tallinn    | 12             | 3842.30   | VIP      |
| Anna Org          | Tartu      | 7              | 3708.37   | VIP      |
| Aili Hurt         | Tallinn    | 11             | 3655.60   | VIP      |
| Mart Liiv         | Tallinn    | 7              | 3559.90   | VIP      |
| Ülle Vaher        | Tallinn    | 7              | 3559.39   | VIP      |
| Külli Sild        | Tartu      | 4              | 3477.28   | VIP      |
| Maris Luik        | Kuressaare | 7              | 3434.64   | VIP      |
| Indrek Laas       | Tallinn    | 5              | 3427.36   | VIP      |
| Maie Tammik       | Tallinn    | 5              | 3306.10   | VIP      |
| Väino Sild        | Tallinn    | 8              | 3293.95   | VIP      |
| Andres Sild       | Pärnu      | 6              | 3287.93   | VIP      |
| Lauri Männik      | Paide      | 6              | 3287.58   | VIP      |
| Rein Must         | Tallinn    | 7              | 3266.78   | VIP      |
| Erkki Liiv        | Tallinn    | 6              | 3186.64   | VIP      |
| Grete Tamm        | Haapsalu   | 6              | 3185.20   | VIP      |
| Raivo Nurk        | Jõhvi      | 5              | 3166.25   | VIP      |
| Anu Teder         | Tartu      | 11             | 3148.80   | VIP      |
| Tarmo Nõmm        | Jõhvi      | 7              | 3118.45   | VIP      |
| Sirje Rand        | Viljandi   | 7              | 3116.43   | VIP      |
| Tiina Järv        | Tallinn    | 5              | 2980.90   | VIP      |
| Lauri Kukk        | Tartu      | 4              | 2935.81   | VIP      |
| Maie Pärn         | Pärnu      | 5              | 2925.69   | VIP      |
| Heino Mitt        | Tallinn    | 6              | 2920.53   | VIP      |
| Väino Rosin       | Tallinn    | 7              | 2902.95   | VIP      |
| Enn Rebane        | Tartu      | 7              | 2874.92   | VIP      |
| Priit Lõoke       | Pärnu      | 7              | 2860.92   | VIP      |
| Terje Lill        | Narva      | 6              | 2859.45   | VIP      |
| Kati Põld         | Tartu      | 7              | 2850.45   | VIP      |
| Merike Rosin      | Tartu      | 6              | 2850.30   | VIP      |
| Kristiina Raud    | Tallinn    | 9              | 2848.88   | VIP      |
| Kalev Puusepp     | Rakvere    | 4              | 2847.68   | VIP      |
| Katrin Salu       | Tartu      | 5              | 2834.74   | VIP      |
| Triin Tammik      | Pärnu      | 6              | 2828.68   | VIP      |
| Ants Lõoke        | Tartu      | 7              | 2788.18   | VIP      |
| Tarmo Rosin       | Pärnu      | 5              | 2788.10   | VIP      |
| Merike Kõiv       | Tallinn    | 5              | 2784.51   | VIP      |
| Kersti Põld       | Pärnu      | 7              | 2748.10   | VIP      |
| Aivar Orav        | Tallinn    | 7              | 2747.85   | VIP      |
| Nele Kivi         | Võru       | 7              | 2740.79   | VIP      |
| Hille Mets        | Kuressaare | 11             | 2733.29   | VIP      |
| Marit Talvik      | Kuressaare | 8              | 2695.53   | VIP      |
| Indrek Veski      | Pärnu      | 6              | 2688.30   | VIP      |
| Ants Puusepp      | Tartu      | 5              | 2683.86   | VIP      |
| Olev Sild         | Pärnu      | 5              | 2681.42   | VIP      |
| Toomas Lõhmus     | Kuressaare | 5              | 2662.20   | VIP      |
| Toomas Lepp       | Tallinn    | 4              | 2657.02   | VIP      |
| Laura Mets        | Tartu      | 8              | 2655.03   | VIP      |
| Hille Roots       | Tallinn    | 4              | 2647.00   | VIP      |
| Indrek Männik     | Tallinn    | 10             | 2644.44   | VIP      |
| Sandra Sild       | Valga      | 7              | 2632.69   | VIP      |
| Merike Laas       | Tartu      | 2              | 2625.52   | VIP      |
| Aivar Mets        | Tartu      | 5              | 2609.63   | VIP      |
| Margus Lepp       | Tartu      | 6              | 2598.19   | VIP      |
| Liis Mägi         | Rakvere    | 4              | 2594.27   | VIP      |
| Liis Kask         | Tallinn    | 5              | 2581.17   | VIP      |
| Kersti Lõoke      | Tartu      | 4              | 2578.12   | VIP      |
| Siim Toom         | Võru       | 6              | 2567.91   | VIP      |
| Katrin Värk       | Haapsalu   | 8              | 2560.35   | VIP      |
| Liina Org         | Pärnu      | 6              | 2558.87   | VIP      |
| Maris Paas        | Võru       | 7              | 2557.43   | VIP      |
| Meelis Mets       | Tartu      | 4              | 2554.02   | VIP      |
| Annika Paas       | Pärnu      | 10             | 2546.41   | VIP      |
| Kadri Kull        | Viljandi   | 5              | 2542.08   | VIP      |
| Margus Nõmm       | Kuressaare | 7              | 2532.13   | VIP      |
| Kristi Aas        | Võru       | 7              | 2524.59   | VIP      |
| Siim Aas          | Tartu      | 7              | 2521.85   | VIP      |
| Külli Rand        | Tallinn    | 4              | 2508.65   | VIP      |
| Urmas Raid        | Narva      | 7              | 2502.82   | VIP      |
| Tarmo Sepp        | Haapsalu   | 4              | 2496.09   | VIP      |
| Peeter Valk       | Tallinn    | 8              | 2494.25   | VIP      |
| Rain Puusepp      | Tartu      | 8              | 2490.68   | VIP      |
| Hille Sepp        | Tallinn    | 7              | 2488.45   | VIP      |
| Piret Kull        | Rakvere    | 5              | 2480.73   | VIP      |
| Jaak Kull         | Tallinn    | 6              | 2477.50   | VIP      |
| Ülle Nurk         | Tartu      | 5              | 2475.63   | VIP      |
| Mihkel Sild       | Tartu      | 7              | 2464.95   | VIP      |
| Kevin Raud        | Võru       | 5              | 2458.06   | VIP      |
| Urmas Põld        | Pärnu      | 5              | 2433.85   | VIP      |
| Kersti Lõoke      | Tallinn    | 4              | 2431.92   | VIP      |
| Katrin Raud       | Pärnu      | 5              | 2426.18   | VIP      |
| Elis Veski        | Tallinn    | 7              | 2426.08   | VIP      |
| Enn Teder         | Pärnu      | 5              | 2422.90   | VIP      |
| Sandra Lõoke      | Tartu      | 7              | 2421.05   | VIP      |
| Siim Lill         | Tallinn    | 7              | 2405.24   | VIP      |
| Väino Kuusk       | Tallinn    | 7              | 2402.05   | VIP      |
| Tõnu Mägi         | Tartu      | 5              | 2399.30   | VIP      |
| Rein Lill         | Tartu      | 2              | 2391.13   | VIP      |
| Tarmo Rosin       | Tallinn    | 6              | 2389.74   | VIP      |
| Lea Lill          | Tallinn    | 5              | 2387.34   | VIP      |
| Kevin Rand        | Tartu      | 6              | 2384.69   | VIP      |
| Meelis Põld       | Rakvere    | 6              | 2380.65   | VIP      |
| Peeter Põld       | Viljandi   | 5              | 2372.29   | VIP      |
| Arvo Pärn         | Tallinn    | 7              | 2369.11   | VIP      |
| Tõnu Arro         | Tallinn    | 7              | 2364.86   | VIP      |
| Kristiina Sepp    | Haapsalu   | 4              | 2350.16   | VIP      |
| Rasmus Rebane     | Tallinn    | 4              | 2348.36   | VIP      |
| Grete Tamm        | Paide      | 6              | 2343.75   | VIP      |
| Enn Oja           | Paide      | 7              | 2340.85   | VIP      |
| Indrek Raid       | Pärnu      | 8              | 2331.12   | VIP      |
| Lauri Männik      | Pärnu      | 6              | 2328.05   | VIP      |
| Tarmo Paju        | Pärnu      | 3              | 2322.40   | VIP      |
| Kristi Kuusik     | Tallinn    | 5              | 2317.91   | VIP      |
| Kristjan Ilves    | Viljandi   | 7              | 2317.38   | VIP      |
| Anu Sild          | Rakvere    | 5              | 2306.84   | VIP      |
| Jüri Sild         | Narva      | 7              | 2305.84   | VIP      |
| Liina Teder       | Tallinn    | 5              | 2302.81   | VIP      |
| Sander Sepp       | Rakvere    | 7              | 2294.85   | VIP      |
| Jaak Sild         | Pärnu      | 11             | 2287.75   | VIP      |
| Piret Kask        | Jõhvi      | 3              | 2285.22   | VIP      |
| Arvo Arro         | Tallinn    | 4              | 2282.28   | VIP      |
| Margus Kull       | Tallinn    | 8              | 2281.66   | VIP      |
| Ülle Org          | Narva      | 5              | 2264.34   | VIP      |
| Ago Kukk          | Tartu      | 6              | 2257.99   | VIP      |
| Madis Mitt        | Narva      | 3              | 2255.21   | VIP      |
| Sirje Värk        | Tallinn    | 4              | 2250.12   | VIP      |
| Merike Nõmm       | Jõhvi      | 5              | 2241.70   | VIP      |
| Madis Roots       | Valga      | 2              | 2233.70   | VIP      |
| Tiina Kukk        | Tallinn    | 5              | 2231.57   | VIP      |
| Sandra Nõmm       | Valga      | 4              | 2231.40   | VIP      |
| Merle Lepp        | Võru       | 5              | 2226.05   | VIP      |
| Mart Kuusik       | Tartu      | 4              | 2216.37   | VIP      |
| Merike Koppel     | Tallinn    | 4              | 2215.73   | VIP      |
| Terje Lepp        | Tartu      | 7              | 2215.52   | VIP      |
| Elis Sild         | Tallinn    | 6              | 2214.42   | VIP      |
| Väino Kuusik      | Narva      | 6              | 2211.61   | VIP      |
| Sigrid Paas       | Tartu      | 7              | 2197.05   | VIP      |
| Siim Kivi         | Tartu      | 6              | 2194.25   | VIP      |
| Andres Mägi       | Tallinn    | 6              | 2185.90   | VIP      |
| Sander Talvik     | Narva      | 6              | 2185.55   | VIP      |
| Väino Nurk        | Tartu      | 6              | 2169.41   | VIP      |
| Ene Rebane        | Tartu      | 3              | 2169.01   | VIP      |
| Eha Raid          | Valga      | 6              | 2166.71   | VIP      |
| Katrin Järv       | Tartu      | 7              | 2165.37   | VIP      |
| Grete Puusepp     | Tallinn    | 5              | 2158.81   | VIP      |
| Piret Lepik       | Rakvere    | 5              | 2153.00   | VIP      |
| Enn Kaalep        | Tallinn    | 3              | 2148.65   | VIP      |
| Madis Liiv        | Pärnu      | 4              | 2142.65   | VIP      |
| Pille Raud        | Haapsalu   | 5              | 2142.56   | VIP      |
| Kevin Puusepp     | Tallinn    | 7              | 2139.47   | VIP      |
| Aivar Kangur      | Tartu      | 5              | 2136.75   | VIP      |
| Lauri Kangur      | Viljandi   | 7              | 2131.86   | VIP      |
| Anu Kukk          | Valga      | 6              | 2130.74   | VIP      |
| Urmas Tammik      | Tartu      | 5              | 2127.16   | VIP      |
| Eha Kask          | Viljandi   | 6              | 2124.85   | VIP      |
| Taavi Tammik      | Tallinn    | 2              | 2123.64   | VIP      |
| Nele Talvik       | Tallinn    | 6              | 2121.13   | VIP      |
| Liina Kask        | Tallinn    | 6              | 2116.89   | VIP      |
| Indrek Kuusk      | Pärnu      | 5              | 2115.43   | VIP      |
| Merle Koppel      | Pärnu      | 4              | 2110.65   | VIP      |
| Rasmus Arro       | Tallinn    | 6              | 2108.35   | VIP      |
| Sandra Aas        | Tallinn    | 6              | 2105.10   | VIP      |
| Kristjan Roots    | Haapsalu   | 4              | 2101.39   | VIP      |
| Indrek Aas        | Kuressaare | 7              | 2097.78   | VIP      |
| Meelis Tammik     | Tartu      | 5              | 2096.50   | VIP      |
| Liis Must         | Tallinn    | 5              | 2096.27   | VIP      |
| Pille Koppel      | Tallinn    | 4              | 2087.25   | VIP      |
| Nele Nurk         | Haapsalu   | 6              | 2084.28   | VIP      |
| Kadri Must        | Tallinn    | 6              | 2079.90   | VIP      |
| Ants Kaalep       | Tallinn    | 5              | 2077.06   | VIP      |
| Kersti Laas       | Pärnu      | 3              | 2066.42   | VIP      |
| Anna Paas         | Narva      | 4              | 2063.73   | VIP      |
| Ants Kangur       | Narva      | 6              | 2052.05   | VIP      |
| Sander Toom       | Pärnu      | 7              | 2050.61   | VIP      |
| Kevin Hurt        | Haapsalu   | 4              | 2048.32   | VIP      |
| Rain Oja          | Tallinn    | 3              | 2045.54   | VIP      |
| Jüri Liiv         | Tartu      | 4              | 2041.63   | VIP      |
| Erkki Aas         | Narva      | 6              | 2038.16   | VIP      |
| Kati Teder        | Tallinn    | 3              | 2037.11   | VIP      |
| Tiit Järv         | Pärnu      | 5              | 2035.46   | VIP      |
| Taavi Kuusik      | Tallinn    | 2              | 2033.34   | VIP      |
| Ants Kaalep       | Tallinn    | 5              | 2032.91   | VIP      |
| Kalev Pärn        | Tallinn    | 4              | 2025.48   | VIP      |
| Reet Kuusik       | Tallinn    | 5              | 2021.99   | VIP      |
| Reet Mitt         | Tartu      | 5              | 2021.71   | VIP      |
| Kersti Värk       | Viljandi   | 6              | 2021.61   | VIP      |
| Annika Rosin      | Pärnu      | 4              | 2020.64   | VIP      |
| Grete Nurk        | Tallinn    | 5              | 2020.05   | VIP      |
| Peeter Lill       | Paide      | 6              | 2018.52   | VIP      |
| Tiit Arro         | Tallinn    | 2              | 2015.75   | VIP      |
| Priit Lill        | Tartu      | 3              | 2013.40   | VIP      |
| Aivar Pihl        | Tallinn    | 4              | 2000.92   | VIP      |
| Urmas Laas        | Tartu      | 5              | 1998.45   | VIP      |
| Toomas Sild       | Tartu      | 3              | 1997.61   | VIP      |
| Väino Raud        | Tallinn    | 5              | 1988.06   | VIP      |
| Kadri Männik      | Tartu      | 5              | 1983.92   | VIP      |
| Merike Raid       | Pärnu      | 5              | 1980.01   | VIP      |
| Kadri Kukk        | Tallinn    | 6              | 1970.42   | VIP      |
| Indrek Kallas     | Tartu      | 3              | 1959.43   | VIP      |
| Grete Kallas      | Tallinn    | 6              | 1957.31   | VIP      |
| Liis Sepp         | Tallinn    | 3              | 1955.72   | VIP      |
| Arvo Lill         | Pärnu      | 7              | 1953.47   | VIP      |
| Siim Toom         | Narva      | 6              | 1947.42   | VIP      |
| Kati Kuusik       | Kuressaare | 6              | 1946.21   | VIP      |
| Kristjan Tamm     | Valga      | 5              | 1946.02   | VIP      |
| Anna Liiv         | Rakvere    | 8              | 1944.37   | VIP      |
| Marko Lepp        | Haapsalu   | 7              | 1939.43   | VIP      |
| Piret Oja         | Tallinn    | 5              | 1939.28   | VIP      |
| Ago Toom          | Võru       | 7              | 1938.78   | VIP      |
| Meelis Lass       | Pärnu      | 5              | 1938.32   | VIP      |
| Kati Mitt         | Tallinn    | 7              | 1933.66   | VIP      |
| Ene Rebane        | Jõhvi      | 5              | 1932.51   | VIP      |
| Siim Toom         | Haapsalu   | 7              | 1927.38   | VIP      |
| Merle Tamm        | Valga      | 5              | 1925.86   | VIP      |
| Urmas Rand        | Kuressaare | 3              | 1918.08   | VIP      |
| Rasmus Rand       | Tallinn    | 7              | 1913.86   | VIP      |
| Elis Talvik       | Narva      | 6              | 1906.42   | VIP      |
| Ragnar Raid       | Tallinn    | 6              | 1905.14   | VIP      |
| Heino Aas         | Narva      | 6              | 1899.01   | VIP      |
| Mihkel Mägi       | Tartu      | 5              | 1898.02   | VIP      |
| Kristi Teder      | Tallinn    | 7              | 1895.35   | VIP      |
| Kaido Kaalep      | Tallinn    | 5              | 1893.77   | VIP      |
| Laura Must        | Haapsalu   | 5              | 1891.34   | VIP      |
| Kaido Oja         | Tartu      | 6              | 1889.90   | VIP      |
| Heli Kangur       | Pärnu      | 4              | 1888.48   | VIP      |
| Meelis Lill       | Kuressaare | 3              | 1888.06   | VIP      |
| Arvo Pärn         | Tallinn    | 3              | 1880.98   | VIP      |
| Meelis Sild       | Kuressaare | 7              | 1880.24   | VIP      |
| Karin Oja         | Tallinn    | 5              | 1878.14   | VIP      |
| Merle Koppel      | Tallinn    | 6              | 1875.41   | VIP      |
| Mart Kallas       | Narva      | 6              | 1873.04   | VIP      |
| Taavi Põld        | Võru       | 3              | 1872.52   | VIP      |
| Tõnu Rosin        | Tallinn    | 5              | 1871.99   | VIP      |
| Hille Kask        | Tallinn    | 4              | 1871.32   | VIP      |
| Toomas Puusepp    | Paide      | 6              | 1869.02   | VIP      |
| Lea Lill          | Tartu      | 4              | 1866.42   | VIP      |
| Henri Lepik       | Tallinn    | 4              | 1865.70   | VIP      |
| Erkki Lepik       | Tallinn    | 3              | 1864.32   | VIP      |
| Nele Paas         | Tallinn    | 5              | 1859.09   | VIP      |
| Henri Kull        | Tallinn    | 4              | 1858.98   | VIP      |
| Tõnu Tamm         | Tallinn    | 5              | 1857.31   | VIP      |
| Erkki Veski       | Tallinn    | 3              | 1855.50   | VIP      |
| Marika Rebane     | Tallinn    | 6              | 1844.10   | VIP      |
| Sirje Rand        | Pärnu      | 7              | 1842.45   | VIP      |
| Jüri Kuusk        | Narva      | 5              | 1837.80   | VIP      |
| Hille Lepik       | Pärnu      | 7              | 1834.43   | VIP      |
| Sirje Ilves       | Pärnu      | 4              | 1834.12   | VIP      |
| Kristiina Lill    | Tallinn    | 3              | 1829.20   | VIP      |
| Erkki Hurt        | Tallinn    | 8              | 1828.48   | VIP      |
| Elis Kukk         | Pärnu      | 5              | 1821.35   | VIP      |
| Margus Orav       | Tallinn    | 7              | 1816.41   | VIP      |
| Tõnu Nurk         | Tallinn    | 3              | 1813.65   | VIP      |
| Piret Roots       | Tartu      | 4              | 1813.57   | VIP      |
| Anna Kuusk        | Tallinn    | 5              | 1812.36   | VIP      |
| Kadri Rebane      | Tallinn    | 4              | 1808.53   | VIP      |
| Mihkel Kask       | Viljandi   | 7              | 1806.37   | VIP      |
| Sigrid Paas       | Paide      | 6              | 1806.17   | VIP      |
| Tiina Mägi        | Viljandi   | 6              | 1805.58   | VIP      |
| Grete Lepik       | Tallinn    | 3              | 1805.53   | VIP      |
| Väino Lepik       | Tallinn    | 6              | 1804.79   | VIP      |
| Ragnar Kukk       | Paide      | 4              | 1804.30   | VIP      |
| Olev Lõoke        | Valga      | 4              | 1801.08   | VIP      |
| Merike Rebane     | Kuressaare | 5              | 1797.99   | VIP      |
| Tõnu Orav         | Tallinn    | 5              | 1796.63   | VIP      |
| Annika Saar       | Pärnu      | 3              | 1795.17   | VIP      |
| Peeter Sild       | Tallinn    | 5              | 1794.10   | VIP      |
| Tõnu Kivi         | Narva      | 6              | 1793.45   | VIP      |
| Rasmus Hurt       | Tartu      | 5              | 1792.58   | VIP      |
| Sigrid Tamm       | Tallinn    | 6              | 1790.84   | VIP      |
| Merle Talvik      | Võru       | 3              | 1785.93   | VIP      |
| Kati Sild         | Tallinn    | 7              | 1783.97   | VIP      |
| Kati Pihl         | Tartu      | 4              | 1783.84   | VIP      |
| Piret Nõmm        | Narva      | 8              | 1781.82   | VIP      |
| Jüri Salu         | Tartu      | 5              | 1781.36   | VIP      |
| Ago Lepp          | Võru       | 8              | 1781.05   | VIP      |
| Piret Kivi        | Tartu      | 5              | 1779.11   | VIP      |
| Sigrid Puusepp    | Tallinn    | 5              | 1779.09   | VIP      |
| Tarmo Kukk        | Tartu      | 4              | 1778.05   | VIP      |
| Sander Lill       | Tartu      | 7              | 1776.78   | VIP      |
| Kevin Kõiv        | Rakvere    | 6              | 1773.32   | VIP      |
| Sirje Lepp        | Tartu      | 5              | 1771.64   | VIP      |
| Tiina Pihl        | Jõhvi      | 3              | 1770.79   | VIP      |
| Urmas Valk        | Tallinn    | 6              | 1770.78   | VIP      |
| Toomas Luik       | Võru       | 7              | 1770.13   | VIP      |
| Rein Roots        | Viljandi   | 7              | 1768.32   | VIP      |
| Kevin Must        | Tallinn    | 5              | 1766.75   | VIP      |
| Kristjan Lõhmus   | Jõhvi      | 6              | 1766.00   | VIP      |
| Triin Kaalep      | Tallinn    | 3              | 1758.18   | VIP      |
| Indrek Raud       | Pärnu      | 4              | 1756.15   | VIP      |
| Erkki Järv        | Tartu      | 4              | 1756.05   | VIP      |
| Kevin Ilves       | Tallinn    | 4              | 1754.03   | VIP      |
| Arvo Paju         | Tartu      | 2              | 1752.72   | VIP      |
| Maie Mitt         | Tallinn    | 5              | 1752.62   | VIP      |
| Triin Lõhmus      | Tartu      | 7              | 1751.33   | VIP      |
| Urmas Raid        | Tartu      | 7              | 1750.51   | VIP      |
| Andres Aas        | Pärnu      | 3              | 1750.35   | VIP      |
| Sirje Teder       | Tallinn    | 4              | 1747.21   | VIP      |
| Eha Ilves         | Tallinn    | 3              | 1745.16   | VIP      |
| Eha Paas          | Valga      | 5              | 1742.40   | VIP      |
| Pille Rebane      | Haapsalu   | 5              | 1741.54   | VIP      |
| Kristiina Lill    | Tallinn    | 2              | 1732.25   | VIP      |
| Piret Rand        | Pärnu      | 5              | 1729.71   | VIP      |
| Margus Liiv       | Tartu      | 3              | 1727.42   | VIP      |
| Hille Nõmm        | Tallinn    | 5              | 1726.59   | VIP      |
| Siim Tamm         | Pärnu      | 4              | 1724.16   | VIP      |
| Kevin Liiv        | Tallinn    | 5              | 1724.15   | VIP      |
| Jüri Valk         | Tartu      | 4              | 1719.52   | VIP      |
| Sander Põld       | Tartu      | 4              | 1717.25   | VIP      |
| Tiina Kaalep      | Paide      | 4              | 1716.38   | VIP      |
| Tiina Nurk        | Haapsalu   | 4              | 1710.83   | VIP      |
| Hille Männik      | Pärnu      | 6              | 1710.57   | VIP      |
| Lea Roots         | Tartu      | 4              | 1702.97   | VIP      |
| Maie Koppel       | Tallinn    | 7              | 1697.56   | VIP      |
| Aili Paas         | Pärnu      | 5              | 1696.74   | VIP      |
| Ene Kull          | Tartu      | 5              | 1695.49   | VIP      |
| Sander Mägi       | Pärnu      | 4              | 1683.88   | VIP      |
| Maie Mägi         | Tartu      | 3              | 1680.93   | VIP      |
| Ülle Toom         | Tallinn    | 6              | 1680.43   | VIP      |
| Liina Lill        | Tallinn    | 5              | 1680.19   | VIP      |
| Ants Tamm         | Tallinn    | 4              | 1680.11   | VIP      |
| Kadri Mets        | Narva      | 5              | 1679.42   | VIP      |
| Annika Raid       | Tallinn    | 4              | 1679.28   | VIP      |
| Kevin Paas        | Narva      | 6              | 1678.40   | VIP      |
| Sander Org        | Narva      | 6              | 1678.29   | VIP      |
| Mihkel Talvik     | Tartu      | 7              | 1677.21   | VIP      |
| Väino Mitt        | Pärnu      | 5              | 1676.13   | VIP      |
| Lauri Sepp        | Tallinn    | 5              | 1675.45   | VIP      |
| Kadri Toom        | Tallinn    | 3              | 1674.44   | VIP      |
| Peeter Pärn       | Tallinn    | 4              | 1673.47   | VIP      |
| Ene Kangur        | Tallinn    | 4              | 1671.24   | VIP      |
| Heli Põld         | Tartu      | 7              | 1669.56   | VIP      |
| Siim Põld         | Tallinn    | 3              | 1666.48   | VIP      |
| Kersti Liiv       | Tartu      | 4              | 1662.94   | VIP      |
| Tiina Luik        | Tallinn    | 3              | 1661.37   | VIP      |
| Jüri Kallas       | Tartu      | 5              | 1659.27   | VIP      |
| Ragnar Kaalep     | Tallinn    | 4              | 1658.96   | VIP      |
| Heino Tammik      | Tallinn    | 5              | 1653.15   | VIP      |
| Ragnar Ilves      | Tallinn    | 5              | 1647.94   | VIP      |
| Sandra Lõhmus     | Tallinn    | 5              | 1645.34   | VIP      |
| Tarmo Kask        | Tallinn    | 6              | 1640.12   | VIP      |
| Aivar Kivi        | Tallinn    | 3              | 1636.68   | VIP      |
| Tiina Kukk        | Pärnu      | 7              | 1636.61   | VIP      |
| Anu Sild          | Haapsalu   | 6              | 1635.44   | VIP      |
| Eha Orav          | Paide      | 1              | 1635.35   | VIP      |
| Kristjan Paas     | Tallinn    | 3              | 1634.12   | VIP      |
| Karin Mitt        | Narva      | 3              | 1632.08   | VIP      |
| Siim Must         | Tallinn    | 4              | 1632.05   | VIP      |
| Lea Nurk          | Tallinn    | 5              | 1625.96   | VIP      |
| Laura Lõhmus      | Rakvere    | 7              | 1620.64   | VIP      |
| Heli Lepp         | Pärnu      | 3              | 1618.98   | VIP      |
| Rasmus Org        | Tartu      | 5              | 1618.86   | VIP      |
| Terje Pihl        | Tartu      | 5              | 1618.10   | VIP      |
| Mart Teder        | Narva      | 3              | 1615.88   | VIP      |
| Rain Kivi         | Tartu      | 5              | 1615.75   | VIP      |
| Piret Lass        | Tallinn    | 4              | 1615.41   | VIP      |
| Karin Kaalep      | Tallinn    | 4              | 1613.45   | VIP      |
| Reet Aas          | Tallinn    | 6              | 1612.76   | VIP      |
| Urmas Kukk        | Võru       | 4              | 1611.69   | VIP      |
| Katrin Org        | Tallinn    | 8              | 1607.33   | VIP      |
| Merle Põld        | Tartu      | 7              | 1606.22   | VIP      |
| Anna Valk         | Narva      | 5              | 1606.04   | VIP      |
| Urmas Lass        | Tallinn    | 6              | 1603.35   | VIP      |
| Kersti Laas       | Tartu      | 5              | 1602.87   | VIP      |
| Tõnu Männik       | Valga      | 4              | 1600.21   | VIP      |
| Kristjan Paas     | Pärnu      | 7              | 1599.60   | VIP      |
| Arvo Talvik       | Pärnu      | 3              | 1596.90   | VIP      |
| Sirje Kukk        | Pärnu      | 6              | 1594.74   | VIP      |
| Tõnu Roots        | Tartu      | 3              | 1587.90   | VIP      |
| Kristi Rand       | Tallinn    | 3              | 1585.63   | VIP      |
| Meelis Pärn       | Pärnu      | 4              | 1580.72   | VIP      |
| Sigrid Hurt       | Tallinn    | 5              | 1580.61   | VIP      |
| Anna Puusepp      | Haapsalu   | 5              | 1579.77   | VIP      |
| Anu Lõhmus        | Kuressaare | 5              | 1579.59   | VIP      |
| Katrin Koppel     | Rakvere    | 4              | 1575.58   | VIP      |
| Taavi Pihl        | Võru       | 7              | 1574.51   | VIP      |
| Heli Kull         | Viljandi   | 5              | 1573.61   | VIP      |
| Enn Põld          | Tartu      | 5              | 1569.08   | VIP      |
| Jüri Rosin        | Tartu      | 5              | 1568.46   | VIP      |
| Marko Kangur      | Tallinn    | 3              | 1566.40   | VIP      |
| Heino Roots       | Tallinn    | 3              | 1564.98   | VIP      |
| Marit Pihl        | Tallinn    | 5              | 1564.31   | VIP      |
| Kati Kaalep       | Kuressaare | 5              | 1561.03   | VIP      |
| Tarmo Luik        | Haapsalu   | 8              | 1558.16   | VIP      |
| Karin Rand        | Valga      | 5              | 1557.57   | VIP      |
| Kati Rebane       | Rakvere    | 5              | 1557.54   | VIP      |
| Indrek Mets       | Pärnu      | 4              | 1556.09   | VIP      |
| Anna Roots        | Tallinn    | 5              | 1554.46   | VIP      |
| Rasmus Valk       | Tartu      | 4              | 1554.03   | VIP      |
| Marika Tamm       | Tartu      | 4              | 1549.80   | VIP      |
| Liis Kangur       | Pärnu      | 5              | 1549.67   | VIP      |
| Maris Kaalep      | Pärnu      | 4              | 1547.46   | VIP      |
| Marko Nõmm        | Tallinn    | 4              | 1545.27   | VIP      |
| Tarmo Puusepp     | Pärnu      | 6              | 1540.42   | VIP      |
| Jüri Paas         | Kuressaare | 6              | 1538.92   | VIP      |
| Maris Paas        | Tartu      | 3              | 1538.52   | VIP      |
| Kaido Orav        | Tallinn    | 5              | 1537.58   | VIP      |
| Karin Kaalep      | Tallinn    | 6              | 1537.23   | VIP      |
| Rasmus Must       | Tallinn    | 4              | 1536.61   | VIP      |
| Taavi Liiv        | Haapsalu   | 7              | 1534.16   | VIP      |
| Ants Kull         | Tartu      | 6              | 1531.35   | VIP      |
| Riina Luik        | Võru       | 4              | 1527.95   | VIP      |
| Piret Luik        | Tartu      | 5              | 1526.28   | VIP      |
| Riina Paju        | Tallinn    | 3              | 1523.18   | VIP      |
| Liina Kask        | Tallinn    | 6              | 1520.03   | VIP      |
| Eha Sepp          | Tartu      | 5              | 1519.76   | VIP      |
| Kristi Ilves      | Tallinn    | 7              | 1519.02   | VIP      |
| Olev Kangur       | Tallinn    | 3              | 1516.90   | VIP      |
| Kadri Sild        | Narva      | 5              | 1516.87   | VIP      |
| Marit Kivi        | Tartu      | 6              | 1516.83   | VIP      |
| Toomas Org        | Tallinn    | 3              | 1514.81   | VIP      |
| Henri Arro        | Tallinn    | 6              | 1513.26   | VIP      |
| Kristjan Järv     | Pärnu      | 3              | 1513.16   | VIP      |
| Olev Pihl         | Narva      | 4              | 1511.45   | VIP      |
| Merike Luik       | Tartu      | 4              | 1511.21   | VIP      |
| Lea Lepp          | Tallinn    | 4              | 1507.99   | VIP      |
| Ago Kukk          | Tallinn    | 4              | 1507.59   | VIP      |
| Meelis Raud       | Tallinn    | 5              | 1506.42   | VIP      |
| Elis Kuusk        | Tallinn    | 3              | 1505.40   | VIP      |
| Maie Tammik       | Tallinn    | 5              | 1504.64   | VIP      |
| Indrek Mets       | Tartu      | 5              | 1504.33   | VIP      |
| Mihkel Talvik     | Pärnu      | 5              | 1503.62   | VIP      |
| Indrek Tammik     | Narva      | 2              | 1502.95   | VIP      |
| Sander Kangur     | Tartu      | 3              | 1497.64   | VIP      |
| Tiina Kallas      | Paide      | 2              | 1496.63   | VIP      |
| Liina Kõiv        | Tartu      | 2              | 1495.79   | VIP      |
| Anu Kuusik        | Narva      | 3              | 1493.96   | VIP      |
| Kristiina Lepp    | Pärnu      | 6              | 1492.46   | VIP      |
| Kati Sepp         | Tartu      | 2              | 1490.94   | VIP      |
| Henri Aas         | Pärnu      | 5              | 1487.40   | VIP      |
| Raivo Kõiv        | Tallinn    | 5              | 1485.01   | VIP      |
| Jüri Kask         | Narva      | 1              | 1484.20   | VIP      |
| Rein Tammik       | Pärnu      | 1              | 1482.90   | VIP      |
| Erkki Valk        | Tallinn    | 4              | 1482.36   | VIP      |
| Mihkel Pärn       | Viljandi   | 3              | 1481.19   | VIP      |
| Heli Hurt         | Tallinn    | 4              | 1479.59   | VIP      |
| Meelis Kuusik     | Tartu      | 6              | 1475.97   | VIP      |
| Lauri Männik      | Tartu      | 3              | 1475.39   | VIP      |
| Kristjan Sild     | Jõhvi      | 7              | 1475.29   | VIP      |
| Lea Mets          | Rakvere    | 4              | 1474.67   | VIP      |
| Pille Must        | Tallinn    | 5              | 1473.03   | VIP      |
| Annika Lepp       | Tartu      | 4              | 1472.59   | VIP      |
| Madis Hurt        | Narva      | 4              | 1471.66   | VIP      |
| Maie Raud         | Tallinn    | 4              | 1470.68   | VIP      |
| Terje Kivi        | Rakvere    | 2              | 1469.26   | VIP      |
| Piret Sild        | Tallinn    | 4              | 1469.23   | VIP      |
| Kristjan Paas     | Tallinn    | 4              | 1468.35   | VIP      |
| Väino Rand        | Tallinn    | 2              | 1467.97   | VIP      |
| Erkki Kull        | Tallinn    | 6              | 1466.90   | VIP      |
| Marit Talvik      | Tallinn    | 6              | 1463.41   | VIP      |
| Peeter Järv       | Pärnu      | 3              | 1460.31   | VIP      |
| Tõnu Luik         | Pärnu      | 4              | 1460.03   | VIP      |
| Arvo Lepik        | Viljandi   | 3              | 1458.65   | VIP      |
| Meelis Tammik     | Tallinn    | 1              | 1458.60   | VIP      |
| Piret Raid        | Pärnu      | 3              | 1455.86   | VIP      |
| Toomas Valk       | Tartu      | 5              | 1455.83   | VIP      |
| Ene Liiv          | Tallinn    | 6              | 1455.31   | VIP      |
| Ragnar Luik       | Tartu      | 3              | 1455.31   | VIP      |
| Karin Nurk        | Viljandi   | 4              | 1452.90   | VIP      |
| Sirje Kangur      | Rakvere    | 2              | 1451.98   | VIP      |
| Piret Saar        | Paide      | 2              | 1451.88   | VIP      |
| Henri Lill        | Haapsalu   | 4              | 1450.05   | VIP      |
| Reet Valk         | Paide      | 3              | 1449.14   | VIP      |
| Erkki Saar        | Pärnu      | 5              | 1448.96   | VIP      |
| Terje Koppel      | Narva      | 3              | 1446.73   | VIP      |
| Kalev Saar        | Tallinn    | 8              | 1446.04   | VIP      |
| Maris Toom        | Pärnu      | 3              | 1443.91   | VIP      |
| Pille Põld        | Tallinn    | 5              | 1443.54   | VIP      |
| Hille Lepik       | Tartu      | 4              | 1441.99   | VIP      |
| Ragnar Tamm       | Tartu      | 3              | 1441.93   | VIP      |
| Ragnar Laas       | Tallinn    | 4              | 1441.35   | VIP      |
| Kadri Kuusk       | Rakvere    | 5              | 1439.63   | VIP      |
| Kalev Toom        | Kuressaare | 5              | 1439.35   | VIP      |
| Kati Org          | Rakvere    | 4              | 1437.18   | VIP      |
| Andres Sepp       | Tallinn    | 6              | 1437.11   | VIP      |
| Rain Pihl         | Viljandi   | 3              | 1432.91   | VIP      |
| Meelis Kask       | Tartu      | 5              | 1432.55   | VIP      |
| Marika Puusepp    | Haapsalu   | 3              | 1432.38   | VIP      |
| Pille Lepik       | Tallinn    | 5              | 1431.18   | VIP      |
| Meelis Toom       | Tallinn    | 5              | 1431.06   | VIP      |
| Anu Orav          | Tartu      | 3              | 1429.10   | VIP      |
| Nele Pihl         | Pärnu      | 5              | 1426.60   | VIP      |
| Heli Ilves        | Tallinn    | 5              | 1426.33   | VIP      |
| Liina Lõhmus      | Tallinn    | 2              | 1426.28   | VIP      |
| Külli Laas        | Pärnu      | 4              | 1425.54   | VIP      |
| Ene Männik        | Tallinn    | 4              | 1425.02   | VIP      |
| Külli Pihl        | Kuressaare | 2              | 1423.93   | VIP      |
| Sandra Lill       | Tartu      | 3              | 1422.89   | VIP      |
| Henri Lepik       | Tartu      | 7              | 1422.57   | VIP      |
| Reet Talvik       | Tallinn    | 6              | 1419.96   | VIP      |
| Marika Kask       | Tallinn    | 5              | 1418.79   | VIP      |
| Annika Kaalep     | Tartu      | 4              | 1418.59   | VIP      |
| Katrin Rosin      | Tallinn    | 3              | 1414.93   | VIP      |
| Elis Lõhmus       | Tartu      | 5              | 1414.81   | VIP      |
| Kadri Nurk        | Tartu      | 4              | 1412.76   | VIP      |
| Jaak Rand         | Narva      | 2              | 1412.25   | VIP      |
| Pille Roots       | Pärnu      | 3              | 1411.55   | VIP      |
| Jaak Värk         | Tallinn    | 5              | 1411.02   | VIP      |
| Ago Toom          | Tallinn    | 6              | 1409.11   | VIP      |
| Madis Hurt        | Jõhvi      | 4              | 1407.79   | VIP      |
| Margus Rosin      | Tallinn    | 4              | 1405.85   | VIP      |
| Toomas Veski      | Tartu      | 4              | 1405.79   | VIP      |
| Aivar Järv        | Tallinn    | 3              | 1404.42   | VIP      |
| Erkki Orav        | Narva      | 6              | 1399.30   | VIP      |
| Aili Lõhmus       | Kuressaare | 6              | 1398.92   | VIP      |
| Aivar Rand        | Pärnu      | 6              | 1394.41   | VIP      |
| Liina Roots       | Tallinn    | 6              | 1393.79   | VIP      |
| Väino Lõoke       | Narva      | 3              | 1391.22   | VIP      |
| Elis Mitt         | Tallinn    | 4              | 1388.12   | VIP      |
| Elis Laas         | Tallinn    | 3              | 1388.06   | VIP      |
| Laura Kõiv        | Viljandi   | 4              | 1387.41   | VIP      |
| Kristi Koppel     | Tartu      | 5              | 1387.40   | VIP      |
| Sandra Koppel     | Pärnu      | 5              | 1386.42   | VIP      |
| Mart Oja          | Viljandi   | 3              | 1385.83   | VIP      |
| Elis Oja          | Narva      | 5              | 1385.43   | VIP      |
| Grete Toom        | Tartu      | 4              | 1385.10   | VIP      |
| Jaak Liiv         | Kuressaare | 2              | 1383.06   | VIP      |
| Reet Laas         | Tallinn    | 4              | 1381.27   | VIP      |
| Kersti Orav       | Tallinn    | 5              | 1380.38   | VIP      |
| Henri Mets        | Tallinn    | 2              | 1380.00   | VIP      |
| Peeter Org        | Jõhvi      | 7              | 1378.77   | VIP      |
| Ragnar Tamm       | Pärnu      | 5              | 1378.72   | VIP      |
| Lauri Nõmm        | Tartu      | 5              | 1378.50   | VIP      |
| Heli Sepp         | Tallinn    | 5              | 1374.84   | VIP      |
| Sirje Männik      | Tallinn    | 1              | 1374.35   | VIP      |
| Piret Must        | Tartu      | 4              | 1374.26   | VIP      |
| Riina Lepp        | Paide      | 4              | 1374.10   | VIP      |
| Ants Koppel       | Kuressaare | 3              | 1373.64   | VIP      |
| Enn Lõhmus        | Tartu      | 5              | 1372.16   | VIP      |
| Priit Lõoke       | Tartu      | 3              | 1370.78   | VIP      |
| Urmas Ilves       | Tallinn    | 5              | 1370.66   | VIP      |
| Annika Toom       | Võru       | 5              | 1366.35   | VIP      |
| Aili Lass         | Tartu      | 4              | 1365.73   | VIP      |
| Anu Kuusk         | Tallinn    | 5              | 1365.10   | VIP      |
| Raivo Salu        | Haapsalu   | 4              | 1364.73   | VIP      |
| Kevin Paju        | Tallinn    | 4              | 1363.81   | VIP      |
| Tarmo Kõiv        | Tartu      | 3              | 1361.59   | VIP      |
| Sander Männik     | Tallinn    | 5              | 1361.25   | VIP      |
| Kaido Arro        | Viljandi   | 4              | 1360.62   | VIP      |
| Tarmo Nõmm        | Tallinn    | 4              | 1359.95   | VIP      |
| Kristiina Kangur  | Tartu      | 2              | 1357.61   | VIP      |
| Henri Orav        | Tallinn    | 4              | 1357.46   | VIP      |
| Hille Liiv        | Võru       | 4              | 1357.41   | VIP      |
| Heli Laas         | Tallinn    | 4              | 1357.05   | VIP      |
| Pille Pärn        | Valga      | 3              | 1356.83   | VIP      |
| Kersti Must       | Tallinn    | 8              | 1355.89   | VIP      |
| Aili Kuusik       | Rakvere    | 4              | 1355.17   | VIP      |
| Liis Paju         | Tallinn    | 4              | 1353.11   | VIP      |
| Jaak Liiv         | Tallinn    | 6              | 1351.18   | VIP      |
| Lea Mets          | Kuressaare | 2              | 1350.01   | VIP      |
| Kersti Veski      | Tallinn    | 6              | 1349.91   | VIP      |
| Piret Lass        | Tallinn    | 3              | 1347.86   | VIP      |
| Laura Sild        | Tallinn    | 4              | 1346.50   | VIP      |
| Marika Toom       | Tartu      | 4              | 1345.91   | VIP      |
| Peeter Salu       | Pärnu      | 6              | 1345.75   | VIP      |
| Laura Mets        | Jõhvi      | 4              | 1342.81   | VIP      |
| Olev Kull         | Valga      | 6              | 1342.40   | VIP      |
| Siim Kask         | Paide      | 4              | 1341.84   | VIP      |
| Siim Järv         | Tallinn    | 4              | 1341.42   | VIP      |
| Maie Aas          | Tallinn    | 5              | 1339.74   | VIP      |
| Rasmus Kallas     | Pärnu      | 3              | 1338.96   | VIP      |
| Tiit Oja          | Narva      | 2              | 1336.55   | VIP      |
| Triin Lill        | Tartu      | 5              | 1336.33   | VIP      |
| Tiit Põld         | Tallinn    | 2              | 1336.10   | VIP      |
| Ene Kallas        | Jõhvi      | 6              | 1333.93   | VIP      |
| Kati Lõoke        | Kuressaare | 3              | 1333.62   | VIP      |
| Tarmo Org         | Tallinn    | 2              | 1332.42   | VIP      |
| Rein Männik       | Tallinn    | 6              | 1330.83   | VIP      |
| Mihkel Roots      | Tartu      | 4              | 1330.54   | VIP      |
| Meelis Sepp       | Pärnu      | 2              | 1329.40   | VIP      |
| Ülle Arro         | Tallinn    | 5              | 1329.36   | VIP      |
| Madis Pihl        | Kuressaare | 2              | 1327.98   | VIP      |
| Maris Org         | Tallinn    | 2              | 1323.46   | VIP      |
| Kevin Orav        | Rakvere    | 7              | 1321.25   | VIP      |
| Sander Männik     | Tallinn    | 4              | 1319.84   | VIP      |
| Marika Koppel     | Tallinn    | 4              | 1319.67   | VIP      |
| Marit Arro        | Tallinn    | 3              | 1317.55   | VIP      |
| Lea Oja           | Tallinn    | 2              | 1317.18   | VIP      |
| Kristjan Orav     | Narva      | 3              | 1315.65   | VIP      |
| Aivar Nurk        | Jõhvi      | 3              | 1315.64   | VIP      |
| Erkki Kallas      | Tallinn    | 5              | 1315.27   | VIP      |
| Taavi Rebane      | Tallinn    | 5              | 1314.56   | VIP      |
| Karin Veski       | Tallinn    | 5              | 1313.50   | VIP      |
| Rain Lepp         | Tallinn    | 4              | 1312.27   | VIP      |
| Merle Vaher       | Tallinn    | 6              | 1311.62   | VIP      |
| Erkki Luik        | Paide      | 4              | 1310.02   | VIP      |
| Marko Nõmm        | Tallinn    | 6              | 1309.96   | VIP      |
| Henri Mets        | Tallinn    | 3              | 1309.14   | VIP      |
| Karin Vaher       | Pärnu      | 2              | 1308.86   | VIP      |
| Lea Põld          | Tallinn    | 4              | 1308.42   | VIP      |
| Heino Laas        | Haapsalu   | 5              | 1307.73   | VIP      |
| Raivo Lass        | Tartu      | 4              | 1305.22   | VIP      |
| Maris Lõhmus      | Tartu      | 3              | 1304.52   | VIP      |
| Urmas Salu        | Tallinn    | 4              | 1304.26   | VIP      |
| Tõnu Valk         | Viljandi   | 4              | 1303.41   | VIP      |
| Jüri Paju         | Tallinn    | 3              | 1301.82   | VIP      |
| Marko Kallas      | Tartu      | 5              | 1301.72   | VIP      |
| Toomas Kull       | Tallinn    | 4              | 1300.29   | VIP      |
| Urmas Kangur      | Tallinn    | 4              | 1300.22   | VIP      |
| Grete Männik      | Tartu      | 3              | 1298.94   | VIP      |
| Väino Pihl        | Tallinn    | 3              | 1298.75   | VIP      |
| Kaido Kask        | Pärnu      | 3              | 1298.43   | VIP      |
| Sandra Raid       | Tallinn    | 3              | 1296.53   | VIP      |
| Katrin Saar       | Tallinn    | 5              | 1295.99   | VIP      |
| Tarmo Kukk        | Pärnu      | 6              | 1295.54   | VIP      |
| Külli Paas        | Tartu      | 5              | 1294.32   | VIP      |
| Anu Paju          | Tallinn    | 7              | 1294.08   | VIP      |
| Jaak Värk         | Viljandi   | 5              | 1291.43   | VIP      |
| Kersti Kuusk      | Kuressaare | 3              | 1289.71   | VIP      |
| Andres Veski      | Tallinn    | 7              | 1289.28   | VIP      |
| Eha Järv          | Tallinn    | 4              | 1288.79   | VIP      |
| Karin Valk        | Tartu      | 4              | 1288.22   | VIP      |
| Ago Talvik        | Tartu      | 3              | 1286.71   | VIP      |
| Sandra Lass       | Tallinn    | 4              | 1285.72   | VIP      |
| Tõnu Lõoke        | Haapsalu   | 5              | 1281.23   | VIP      |
| Marika Nurk       | Paide      | 3              | 1281.17   | VIP      |
| Anu Sild          | Tallinn    | 4              | 1280.74   | VIP      |
| Merike Mägi       | Paide      | 4              | 1280.26   | VIP      |
| Taavi Koppel      | Kuressaare | 4              | 1279.59   | VIP      |
| Tarmo Lepp        | Tallinn    | 5              | 1279.10   | VIP      |
| Siim Hurt         | Haapsalu   | 4              | 1279.01   | VIP      |
| Katrin Kõiv       | Tartu      | 6              | 1278.49   | VIP      |
| Marika Toom       | Pärnu      | 3              | 1278.22   | VIP      |
| Margus Pihl       | Tartu      | 4              | 1277.92   | VIP      |
| Mihkel Rosin      | Viljandi   | 4              | 1275.29   | VIP      |
| Riina Roots       | Tallinn    | 2              | 1275.25   | VIP      |
| Meelis Kaalep     | Tallinn    | 2              | 1273.31   | VIP      |
| Urmas Kukk        | Jõhvi      | 4              | 1270.60   | VIP      |
| Hille Saar        | Tallinn    | 3              | 1264.56   | VIP      |
| Triin Ilves       | Haapsalu   | 4              | 1264.53   | VIP      |
| Aili Teder        | Tallinn    | 3              | 1264.42   | VIP      |
| Priit Kallas      | Tartu      | 5              | 1262.82   | VIP      |
| Sigrid Mägi       | Võru       | 3              | 1262.66   | VIP      |
| Triin Puusepp     | Tallinn    | 6              | 1261.55   | VIP      |
| Peeter Lepp       | Tallinn    | 5              | 1258.45   | VIP      |
| Heino Vaher       | Tartu      | 3              | 1258.03   | VIP      |
| Annika Mets       | Tartu      | 4              | 1256.58   | VIP      |
| Toomas Kivi       | Tallinn    | 3              | 1255.26   | VIP      |
| Kaido Mägi        | Tartu      | 2              | 1254.67   | VIP      |
| Piret Lepp        | Tallinn    | 2              | 1253.93   | VIP      |
| Andres Nõmm       | Jõhvi      | 4              | 1253.86   | VIP      |
| Külli Org         | Pärnu      | 4              | 1249.75   | VIP      |
| Grete Tamm        | Tallinn    | 2              | 1247.44   | VIP      |
| Indrek Arro       | Tartu      | 3              | 1247.37   | VIP      |
| Mihkel Tammik     | Tallinn    | 5              | 1246.99   | VIP      |
| Raivo Pihl        | Võru       | 6              | 1245.85   | VIP      |
| Kadri Kuusk       | Viljandi   | 4              | 1243.03   | VIP      |
| Kalev Mägi        | Tartu      | 4              | 1241.49   | VIP      |
| Tõnu Kallas       | Tallinn    | 3              | 1241.13   | VIP      |
| Terje Tamm        | Tartu      | 3              | 1240.48   | VIP      |
| Annika Mets       | Tartu      | 6              | 1238.29   | VIP      |
| Riina Aas         | Tallinn    | 3              | 1238.23   | VIP      |
| Tõnu Lepp         | Tartu      | 6              | 1235.12   | VIP      |
| Rasmus Mitt       | Tallinn    | 6              | 1234.00   | VIP      |
| Kalev Raud        | Tartu      | 3              | 1231.97   | VIP      |
| Taavi Koppel      | Tallinn    | 4              | 1226.60   | VIP      |
| Kadri Vaher       | Tallinn    | 4              | 1225.80   | VIP      |
| Katrin Paas       | Tallinn    | 4              | 1222.27   | VIP      |
| Henri Aas         | Narva      | 4              | 1221.68   | VIP      |
| Heli Mägi         | Narva      | 4              | 1220.67   | VIP      |
| Kati Kask         | Pärnu      | 2              | 1220.18   | VIP      |
| Urmas Lass        | Narva      | 5              | 1218.77   | VIP      |
| Liis Veski        | Tallinn    | 6              | 1217.61   | VIP      |
| Kristiina Liiv    | Tallinn    | 3              | 1217.47   | VIP      |
| Rasmus Mägi       | Pärnu      | 2              | 1216.95   | VIP      |
| Peeter Koppel     | Tallinn    | 5              | 1216.13   | VIP      |
| Marika Raid       | Tallinn    | 3              | 1216.02   | VIP      |
| Priit Lill        | Tallinn    | 6              | 1215.88   | VIP      |
| Katrin Kivi       | Tallinn    | 6              | 1215.71   | VIP      |
| Liina Mitt        | Tallinn    | 4              | 1214.71   | VIP      |
| Rain Kuusik       | Narva      | 4              | 1213.60   | VIP      |
| Ragnar Lill       | Tallinn    | 6              | 1212.02   | VIP      |
| Ants Org          | Tallinn    | 3              | 1211.70   | VIP      |
| Piret Must        | Haapsalu   | 5              | 1210.99   | VIP      |
| Lea Raud          | Kuressaare | 5              | 1209.04   | VIP      |
| Annika Lass       | Tallinn    | 3              | 1207.37   | VIP      |
| Rein Kull         | Haapsalu   | 2              | 1207.22   | VIP      |
| Taavi Aas         | Tartu      | 6              | 1206.67   | VIP      |
| Pille Saar        | Tartu      | 5              | 1206.47   | VIP      |
| Rein Must         | Narva      | 5              | 1205.61   | VIP      |
| Enn Värk          | Tartu      | 2              | 1205.43   | VIP      |
| Meelis Nurk       | Tartu      | 3              | 1204.87   | VIP      |
| Merike Pihl       | Valga      | 2              | 1202.74   | VIP      |
| Aivar Lõoke       | Tallinn    | 4              | 1202.21   | VIP      |
| Madis Toom        | Kuressaare | 5              | 1199.12   | VIP      |
| Külli Rand        | Pärnu      | 4              | 1198.80   | VIP      |
| Sigrid Vaher      | Tallinn    | 4              | 1198.62   | VIP      |
| Jaak Talvik       | Tallinn    | 2              | 1198.56   | VIP      |
| Mart Kull         | Tartu      | 2              | 1198.47   | VIP      |
| Taavi Pihl        | Võru       | 3              | 1197.24   | VIP      |
| Marko Tamm        | Rakvere    | 4              | 1196.89   | VIP      |
| Kristi Järv       | Tallinn    | 6              | 1194.87   | VIP      |
| Külli Nõmm        | Tallinn    | 3              | 1192.41   | VIP      |
| Olev Teder        | Tallinn    | 5              | 1191.77   | VIP      |
| Meelis Laas       | Tallinn    | 6              | 1191.38   | VIP      |
| Jaak Rand         | Tallinn    | 2              | 1189.47   | VIP      |
| Marit Kuusk       | Tallinn    | 5              | 1188.26   | VIP      |
| Marko Hurt        | Tartu      | 6              | 1187.99   | VIP      |
| Mihkel Lepp       | Tallinn    | 2              | 1187.57   | VIP      |
| Hille Kask        | Tartu      | 4              | 1183.26   | VIP      |
| Meelis Saar       | Tartu      | 6              | 1182.64   | VIP      |
| Ragnar Kuusik     | Tartu      | 5              | 1181.59   | VIP      |
| Marit Aas         | Tallinn    | 4              | 1180.41   | VIP      |
| Marit Koppel      | Valga      | 3              | 1179.84   | VIP      |
| Tarmo Vaher       | Tallinn    | 4              | 1179.22   | VIP      |
| Kadri Roots       | Tartu      | 5              | 1178.89   | VIP      |
| Liina Tamm        | Tallinn    | 5              | 1178.58   | VIP      |
| Anna Pärn         | Haapsalu   | 4              | 1178.00   | VIP      |
| Anna Järv         | Tartu      | 5              | 1177.32   | VIP      |
| Liis Kask         | Haapsalu   | 4              | 1176.92   | VIP      |
| Aili Paas         | Narva      | 5              | 1175.46   | VIP      |
| Kristi Oja        | Tartu      | 7              | 1175.39   | VIP      |
| Merike Lõhmus     | Rakvere    | 3              | 1175.08   | VIP      |
| Jüri Nõmm         | Tallinn    | 4              | 1173.66   | VIP      |
| Marika Rosin      | Pärnu      | 3              | 1171.64   | VIP      |
| Annika Pihl       | Tallinn    | 5              | 1171.29   | VIP      |
| Sigrid Pihl       | Pärnu      | 6              | 1171.22   | VIP      |
| Aivar Paas        | Tallinn    | 5              | 1171.04   | VIP      |
| Raivo Koppel      | Tallinn    | 3              | 1171.03   | VIP      |
| Anu Paas          | Tallinn    | 4              | 1170.95   | VIP      |
| Lauri Roots       | Tallinn    | 3              | 1170.05   | VIP      |
| Madis Lass        | Tartu      | 3              | 1168.29   | VIP      |
| Ago Kuusk         | Tallinn    | 4              | 1167.75   | VIP      |
| Marko Lass        | Tallinn    | 4              | 1167.54   | VIP      |
| Tiit Arro         | Pärnu      | 2              | 1166.67   | VIP      |
| Merike Mets       | Haapsalu   | 3              | 1166.58   | VIP      |
| Ago Mets          | Tallinn    | 3              | 1166.26   | VIP      |
| Kadri Pihl        | Võru       | 6              | 1166.13   | VIP      |
| Ene Liiv          | Valga      | 2              | 1165.86   | VIP      |
| Kaido Laas        | Tartu      | 5              | 1163.17   | VIP      |
| Kalev Järv        | Tallinn    | 4              | 1163.14   | VIP      |
| Tiit Rosin        | Tallinn    | 4              | 1160.54   | VIP      |
| Ene Kuusk         | Tartu      | 4              | 1160.20   | VIP      |
| Kevin Rand        | Tallinn    | 3              | 1158.97   | VIP      |
| Merle Luik        | Narva      | 3              | 1158.13   | VIP      |
| Heli Lõoke        | Pärnu      | 5              | 1156.10   | VIP      |
| Arvo Kuusik       | Narva      | 3              | 1156.05   | VIP      |
| Kristiina Kull    | Tallinn    | 5              | 1154.51   | VIP      |
| Pille Tammik      | Tallinn    | 2              | 1153.65   | VIP      |
| Indrek Oja        | Tallinn    | 8              | 1149.08   | VIP      |
| Maris Kuusik      | Tartu      | 5              | 1148.76   | VIP      |
| Maris Rosin       | Tartu      | 4              | 1148.62   | VIP      |
| Triin Mitt        | Tallinn    | 4              | 1147.79   | VIP      |
| Rasmus Mets       | Narva      | 3              | 1147.73   | VIP      |
| Merle Toom        | Viljandi   | 6              | 1147.49   | VIP      |
| Rasmus Veski      | Tallinn    | 3              | 1146.99   | VIP      |
| Jaak Kukk         | Tartu      | 5              | 1141.70   | VIP      |
| Rein Luik         | Tallinn    | 3              | 1141.25   | VIP      |
| Kadri Tamm        | Pärnu      | 3              | 1140.94   | VIP      |
| Triin Pihl        | Pärnu      | 3              | 1138.22   | VIP      |
| Laura Kull        | Narva      | 5              | 1137.60   | VIP      |
| Madis Rand        | Tartu      | 2              | 1136.38   | VIP      |
| Ants Talvik       | Tallinn    | 4              | 1133.42   | VIP      |
| Tarmo Kaalep      | Tartu      | 3              | 1133.38   | VIP      |
| Anu Mets          | Kuressaare | 8              | 1131.71   | VIP      |
| Raivo Salu        | Tartu      | 2              | 1131.46   | VIP      |
| Jaak Nõmm         | Rakvere    | 7              | 1129.48   | VIP      |
| Olev Kuusk        | Pärnu      | 2              | 1129.28   | VIP      |
| Mart Kõiv         | Pärnu      | 1              | 1129.05   | VIP      |
| Kaido Must        | Viljandi   | 1              | 1128.99   | VIP      |
| Marika Kaalep     | Tallinn    | 2              | 1128.40   | VIP      |
| Liina Kivi        | Tallinn    | 3              | 1127.92   | VIP      |
| Aivar Koppel      | Rakvere    | 3              | 1126.08   | VIP      |
| Aili Sepp         | Tallinn    | 5              | 1125.27   | VIP      |
| Raivo Kask        | Rakvere    | 5              | 1124.67   | VIP      |
| Meelis Kuusik     | Tartu      | 3              | 1122.68   | VIP      |
| Madis Värk        | Tartu      | 5              | 1122.14   | VIP      |
| Merike Järv       | Tallinn    | 3              | 1121.33   | VIP      |
| Meelis Kaalep     | Tallinn    | 3              | 1119.83   | VIP      |
| Merle Puusepp     | Tallinn    | 4              | 1117.21   | VIP      |
| Reet Lill         | Jõhvi      | 2              | 1115.91   | VIP      |
| Külli Lõhmus      | Haapsalu   | 3              | 1110.80   | VIP      |
| Karin Põld        | Tartu      | 5              | 1108.15   | VIP      |
| Anna Nõmm         | Tallinn    | 3              | 1107.31   | VIP      |
| Ragnar Talvik     | Tallinn    | 5              | 1107.18   | VIP      |
| Anna Mets         | Tallinn    | 5              | 1107.04   | VIP      |
| Tiit Roots        | Võru       | 5              | 1106.47   | VIP      |
| Pille Rosin       | Narva      | 4              | 1106.45   | VIP      |
| Riina Kull        | Tartu      | 5              | 1106.21   | VIP      |
| Ragnar Orav       | Tallinn    | 1              | 1106.01   | VIP      |
| Ülle Laas         | Jõhvi      | 5              | 1105.79   | VIP      |
| Ene Tammik        | Pärnu      | 4              | 1105.70   | VIP      |
| Hille Mitt        | Paide      | 5              | 1104.57   | VIP      |
| Väino Arro        | Valga      | 2              | 1103.48   | VIP      |
| Jüri Lõhmus       | Tallinn    | 2              | 1103.13   | VIP      |
| Hille Nõmm        | Tallinn    | 2              | 1102.95   | VIP      |
| Aivar Kuusk       | Tallinn    | 3              | 1102.87   | VIP      |
| Sigrid Mitt       | Rakvere    | 5              | 1101.40   | VIP      |
| Rein Rand         | Tartu      | 2              | 1098.67   | VIP      |
| Karin Paas        | Valga      | 4              | 1096.84   | VIP      |
| Indrek Org        | Tallinn    | 5              | 1096.64   | VIP      |
| Hille Kangur      | Tartu      | 3              | 1095.83   | VIP      |
| Anna Lepik        | Haapsalu   | 4              | 1095.65   | VIP      |
| Riina Laas        | Tartu      | 3              | 1095.17   | VIP      |
| Enn Kull          | Võru       | 1              | 1094.95   | VIP      |
| Toomas Toom       | Tallinn    | 2              | 1093.44   | VIP      |
| Eha Puusepp       | Narva      | 2              | 1091.64   | VIP      |
| Tiit Talvik       | Pärnu      | 2              | 1091.42   | VIP      |
| Külli Paas        | Tallinn    | 4              | 1090.82   | VIP      |
| Priit Männik      | Rakvere    | 3              | 1089.45   | VIP      |
| Liina Valk        | Pärnu      | 2              | 1088.92   | VIP      |
| Olev Paju         | Narva      | 2              | 1088.20   | VIP      |
| Jüri Talvik       | Tallinn    | 6              | 1087.12   | VIP      |
| Tarmo Kuusik      | Valga      | 2              | 1085.90   | VIP      |
| Enn Lõhmus        | Tallinn    | 3              | 1085.73   | VIP      |
| Olev Saar         | Tartu      | 4              | 1084.91   | VIP      |
| Peeter Tammik     | Pärnu      | 4              | 1083.49   | VIP      |
| Sandra Sepp       | Jõhvi      | 5              | 1082.72   | VIP      |
| Henri Saar        | Tartu      | 3              | 1082.65   | VIP      |
| Tiina Must        | Rakvere    | 3              | 1082.30   | VIP      |
| Heli Mitt         | Tallinn    | 5              | 1081.45   | VIP      |
| Siim Koppel       | Tartu      | 3              | 1080.45   | VIP      |
| Sandra Kaalep     | Tallinn    | 3              | 1078.32   | VIP      |
| Ene Oja           | Tartu      | 3              | 1078.16   | VIP      |
| Peeter Kangur     | Pärnu      | 3              | 1075.24   | VIP      |
| Aivar Pihl        | Narva      | 4              | 1074.93   | VIP      |
| Jüri Vaher        | Kuressaare | 3              | 1074.57   | VIP      |
| Sirje Lepik       | Tartu      | 5              | 1074.10   | VIP      |
| Kati Paas         | Tallinn    | 3              | 1074.03   | VIP      |
| Sander Kull       | Pärnu      | 4              | 1073.26   | VIP      |
| Annika Järv       | Tartu      | 3              | 1073.25   | VIP      |
| Liis Kivi         | Tallinn    | 2              | 1072.94   | VIP      |
| Indrek Laas       | Kuressaare | 4              | 1071.67   | VIP      |
| Enn Raid          | Tallinn    | 3              | 1071.04   | VIP      |
| Margus Veski      | Tallinn    | 4              | 1070.68   | VIP      |
| Rein Luik         | Kuressaare | 2              | 1070.58   | VIP      |
| Ene Kivi          | Tallinn    | 3              | 1070.57   | VIP      |
| Liis Liiv         | Tallinn    | 6              | 1070.03   | VIP      |
| Kadri Lõoke       | Tartu      | 5              | 1069.36   | VIP      |
| Urmas Toom        | Tallinn    | 3              | 1066.29   | VIP      |
| Rain Kivi         | Pärnu      | 5              | 1066.15   | VIP      |
| Kati Puusepp      | Tallinn    | 5              | 1065.74   | VIP      |
| Maris Raid        | Tartu      | 3              | 1064.95   | VIP      |
| Arvo Nurk         | Tartu      | 3              | 1064.87   | VIP      |
| Meelis Raid       | Tallinn    | 4              | 1063.92   | VIP      |
| Ants Paas         | Tallinn    | 6              | 1063.81   | VIP      |
| Kaido Roots       | Pärnu      | 6              | 1063.21   | VIP      |
| Tiina Kangur      | Tartu      | 3              | 1063.20   | VIP      |
| Rain Lepp         | Pärnu      | 4              | 1062.87   | VIP      |
| Kati Ilves        | Tallinn    | 5              | 1062.09   | VIP      |
| Katrin Kivi       | Pärnu      | 4              | 1060.04   | VIP      |
| Madis Kõiv        | Tartu      | 4              | 1059.47   | VIP      |
| Kristiina Põld    | Pärnu      | 3              | 1058.61   | VIP      |
| Kristiina Oja     | Viljandi   | 4              | 1058.10   | VIP      |
| Andres Rebane     | Tartu      | 2              | 1057.95   | VIP      |
| Ene Lepp          | Tallinn    | 4              | 1057.90   | VIP      |
| Madis Lill        | Kuressaare | 5              | 1055.76   | VIP      |
| Ene Vaher         | Tallinn    | 3              | 1054.88   | VIP      |
| Erkki Mets        | Võru       | 3              | 1054.00   | VIP      |
| Lea Lill          | Tartu      | 1              | 1053.99   | VIP      |
| Piret Saar        | Tallinn    | 6              | 1053.59   | VIP      |
| Terje Laas        | Tartu      | 6              | 1052.41   | VIP      |
| Siim Mägi         | Tallinn    | 5              | 1052.07   | VIP      |
| Annika Must       | Tallinn    | 4              | 1051.13   | VIP      |
| Mihkel Sepp       | Tartu      | 4              | 1048.93   | VIP      |
| Rain Sild         | Tallinn    | 3              | 1048.65   | VIP      |
| Pille Veski       | Rakvere    | 3              | 1046.18   | VIP      |
| Kersti Puusepp    | Tallinn    | 3              | 1045.73   | VIP      |
| Tiina Järv        | Tallinn    | 4              | 1044.97   | VIP      |
| Eha Kask          | Narva      | 3              | 1044.56   | VIP      |
| Meelis Tamm       | Tallinn    | 5              | 1044.45   | VIP      |
| Mihkel Teder      | Viljandi   | 3              | 1044.12   | VIP      |
| Triin Lill        | Tallinn    | 5              | 1043.67   | VIP      |
| Arvo Roots        | Tartu      | 5              | 1042.96   | VIP      |
| Marko Kask        | Tartu      | 4              | 1042.30   | VIP      |
| Kristjan Lepik    | Tartu      | 3              | 1042.22   | VIP      |
| Hille Lõoke       | Tartu      | 4              | 1041.73   | VIP      |
| Piret Rebane      | Tallinn    | 4              | 1041.03   | VIP      |
| Sander Roots      | Paide      | 4              | 1040.80   | VIP      |
| Mihkel Rosin      | Narva      | 4              | 1040.72   | VIP      |
| Marika Orav       | Tallinn    | 3              | 1040.38   | VIP      |
| Margus Kuusik     | Rakvere    | 4              | 1040.09   | VIP      |
| Enn Hurt          | Tallinn    | 5              | 1037.91   | VIP      |
| Tõnu Paas         | Tallinn    | 3              | 1037.38   | VIP      |
| Kristi Lill       | Narva      | 3              | 1037.37   | VIP      |
| Ülle Raid         | Tallinn    | 4              | 1036.57   | VIP      |
| Kersti Kõiv       | Tartu      | 6              | 1036.42   | VIP      |
| Arvo Pihl         | Tallinn    | 3              | 1034.97   | VIP      |
| Ülle Pihl         | Kuressaare | 4              | 1034.58   | VIP      |
| Aivar Rosin       | Viljandi   | 4              | 1033.76   | VIP      |
| Kevin Lass        | Võru       | 2              | 1033.62   | VIP      |
| Kristiina Lill    | Tallinn    | 2              | 1033.56   | VIP      |
| Kristiina Liiv    | Rakvere    | 6              | 1033.40   | VIP      |
| Marika Lepp       | Tartu      | 6              | 1031.41   | VIP      |
| Henri Pärn        | Tallinn    | 2              | 1030.51   | VIP      |
| Aivar Talvik      | Haapsalu   | 4              | 1030.08   | VIP      |
| Rasmus Kallas     | Tallinn    | 4              | 1028.18   | VIP      |
| Merle Salu        | Tallinn    | 2              | 1026.64   | VIP      |
| Grete Kukk        | Tartu      | 3              | 1025.57   | VIP      |
| Laura Sild        | Valga      | 5              | 1025.09   | VIP      |
| Rasmus Lill       | Valga      | 3              | 1021.44   | VIP      |
| Siim Pihl         | Rakvere    | 3              | 1020.56   | VIP      |
| Tiit Puusepp      | Tartu      | 3              | 1020.40   | VIP      |
| Väino Aas         | Tallinn    | 3              | 1018.09   | VIP      |
| Anna Veski        | Pärnu      | 4              | 1018.03   | VIP      |
| Rain Kull         | Tartu      | 4              | 1016.75   | VIP      |
| Meelis Lepp       | Narva      | 3              | 1016.62   | VIP      |
| Olev Valk         | Tallinn    | 3              | 1016.21   | VIP      |
| Aivar Laas        | Tartu      | 2              | 1013.86   | VIP      |
| Laura Oja         | Haapsalu   | 5              | 1013.22   | VIP      |
| Kersti Nurk       | Tallinn    | 3              | 1009.28   | VIP      |
| Meelis Nurk       | Tallinn    | 2              | 1009.02   | VIP      |
| Külli Mets        | Pärnu      | 2              | 1008.69   | VIP      |
| Külli Lõoke       | Tallinn    | 3              | 1008.65   | VIP      |
| Sirje Liiv        | Tallinn    | 4              | 1008.27   | VIP      |
| Nele Laas         | Kuressaare | 4              | 1007.98   | VIP      |
| Lauri Talvik      | Tallinn    | 4              | 1007.31   | VIP      |
| Kristjan Sepp     | Tartu      | 6              | 1006.52   | VIP      |
| Külli Pihl        | Jõhvi      | 3              | 1006.41   | VIP      |
| Kristjan Sild     | Tallinn    | 4              | 1005.95   | VIP      |
| Reet Roots        | Viljandi   | 3              | 1005.56   | VIP      |
| Kristiina Ilves   | Tallinn    | 3              | 1005.33   | VIP      |
| Rain Lepik        | Tallinn    | 3              | 1005.10   | VIP      |
| Maris Männik      | Tartu      | 4              | 1004.08   | VIP      |
| Väino Lepik       | Tallinn    | 2              | 1002.95   | VIP      |
| Anu Mägi          | Pärnu      | 3              | 1002.91   | VIP      |
| Anna Veski        | Pärnu      | 2              | 1002.53   | VIP      |
| Lea Ilves         | Tallinn    | 6              | 1001.68   | VIP      |
| Tõnu Saar         | Tallinn    | 3              | 1001.56   | VIP      |
| Reet Laas         | Viljandi   | 4              | 1000.87   | VIP      |
| Toomas Puusepp    | Narva      | 2              | 1000.36   | VIP      |
| Kadri Talvik      | Narva      | 5              | 1000.18   | VIP      |
| Terje Männik      | Tallinn    | 3              | 1000.06   | VIP      |
| Marit Sild        | Tartu      | 3              | 999.71    | Aktiivne |
| Karin Raud        | Jõhvi      | 3              | 999.29    | Aktiivne |
| Mihkel Raud       | Tallinn    | 5              | 998.20    | Aktiivne |
| Heino Rosin       | Tallinn    | 3              | 997.64    | Aktiivne |
| Nele Koppel       | Tallinn    | 5              | 997.52    | Aktiivne |
| Mihkel Lõhmus     | Tartu      | 2              | 996.84    | Aktiivne |
| Tiit Koppel       | Tallinn    | 2              | 996.81    | Aktiivne |
| Kati Lass         | Tartu      | 2              | 996.40    | Aktiivne |
| Kaido Roots       | Tallinn    | 3              | 996.37    | Aktiivne |
| Kersti Ilves      | Tallinn    | 3              | 995.64    | Aktiivne |
| Peeter Nurk       | Tallinn    | 6              | 994.52    | Aktiivne |
| Külli Kivi        | Kuressaare | 5              | 994.21    | Aktiivne |
| Toomas Ilves      | Viljandi   | 2              | 993.95    | Aktiivne |
| Kevin Raid        | Tallinn    | 3              | 993.72    | Aktiivne |
| Tarmo Laas        | Tallinn    | 5              | 993.57    | Aktiivne |
| Aili Toom         | Pärnu      | 2              | 992.20    | Aktiivne |
| Jüri Salu         | Tallinn    | 4              | 991.99    | Aktiivne |
| Eha Rosin         | Valga      | 6              | 991.69    | Aktiivne |
| Maris Tamm        | Jõhvi      | 4              | 991.07    | Aktiivne |
| Laura Toom        | Tallinn    | 2              | 990.16    | Aktiivne |
| Andres Laas       | Tallinn    | 1              | 989.97    | Aktiivne |
| Merle Kivi        | Pärnu      | 2              | 989.18    | Aktiivne |
| Kristjan Paas     | Tartu      | 3              | 988.88    | Aktiivne |
| Toomas Laas       | Viljandi   | 3              | 988.51    | Aktiivne |
| Reet Oja          | Rakvere    | 2              | 987.75    | Aktiivne |
| Liis Kukk         | Pärnu      | 2              | 986.24    | Aktiivne |
| Anna Rosin        | Kuressaare | 2              | 985.14    | Aktiivne |
| Arvo Järv         | Tallinn    | 4              | 984.33    | Aktiivne |
| Peeter Veski      | Tallinn    | 3              | 983.67    | Aktiivne |
| Merle Kuusk       | Tallinn    | 4              | 983.39    | Aktiivne |
| Jaak Rosin        | Rakvere    | 5              | 983.13    | Aktiivne |
| Andres Kukk       | Jõhvi      | 3              | 981.43    | Aktiivne |
| Sigrid Kõiv       | Pärnu      | 3              | 980.51    | Aktiivne |
| Priit Raid        | Tallinn    | 3              | 979.87    | Aktiivne |
| Peeter Veski      | Tallinn    | 2              | 978.99    | Aktiivne |
| Terje Kukk        | Tallinn    | 4              | 978.93    | Aktiivne |
| Andres Kask       | Kuressaare | 2              | 978.77    | Aktiivne |
| Kevin Kivi        | Rakvere    | 3              | 977.57    | Aktiivne |
| Raivo Roots       | Tallinn    | 3              | 977.53    | Aktiivne |
| Kaido Teder       | Rakvere    | 3              | 975.59    | Aktiivne |
| Heli Hurt         | Tallinn    | 4              | 975.28    | Aktiivne |
| Peeter Raud       | Tallinn    | 3              | 973.53    | Aktiivne |
| Kati Kaalep       | Tartu      | 2              | 973.35    | Aktiivne |
| Kersti Kaalep     | Valga      | 4              | 972.75    | Aktiivne |
| Raivo Paju        | Tallinn    | 3              | 970.74    | Aktiivne |
| Eha Liiv          | Jõhvi      | 3              | 970.67    | Aktiivne |
| Väino Kull        | Jõhvi      | 3              | 969.66    | Aktiivne |
| Eha Raid          | Jõhvi      | 5              | 969.05    | Aktiivne |
| Siim Oja          | Tartu      | 3              | 969.03    | Aktiivne |
| Meelis Ilves      | Tallinn    | 7              | 968.31    | Aktiivne |
| Aili Vaher        | Viljandi   | 2              | 967.83    | Aktiivne |
| Toomas Saar       | Tartu      | 3              | 967.29    | Aktiivne |
| Sandra Värk       | Tallinn    | 4              | 965.98    | Aktiivne |
| Rain Lõhmus       | Tallinn    | 2              | 963.02    | Aktiivne |
| Raivo Koppel      | Tallinn    | 4              | 959.60    | Aktiivne |
| Külli Toom        | Tallinn    | 3              | 958.16    | Aktiivne |
| Maie Mets         | Tallinn    | 4              | 957.55    | Aktiivne |
| Ene Arro          | Tallinn    | 3              | 956.89    | Aktiivne |
| Siim Kivi         | Tallinn    | 3              | 956.39    | Aktiivne |
| Erkki Roots       | Viljandi   | 5              | 955.93    | Aktiivne |
| Pille Pärn        | Rakvere    | 4              | 954.93    | Aktiivne |
| Rein Oja          | Tallinn    | 4              | 953.32    | Aktiivne |
| Merle Puusepp     | Tallinn    | 4              | 952.61    | Aktiivne |
| Tarmo Luik        | Tallinn    | 3              | 951.23    | Aktiivne |
| Jaak Ilves        | Tallinn    | 2              | 951.15    | Aktiivne |
| Reet Kuusik       | Tartu      | 2              | 950.71    | Aktiivne |
| Lea Salu          | Võru       | 5              | 950.21    | Aktiivne |
| Rein Teder        | Tallinn    | 3              | 950.18    | Aktiivne |
| Marko Ilves       | Tartu      | 3              | 949.14    | Aktiivne |
| Karin Sepp        | Tallinn    | 4              | 947.22    | Aktiivne |
| Marika Orav       | Tallinn    | 5              | 947.20    | Aktiivne |
| Kristiina Mitt    | Jõhvi      | 7              | 945.54    | Aktiivne |
| Madis Hurt        | Tartu      | 5              | 945.42    | Aktiivne |
| Rasmus Männik     | Tallinn    | 4              | 944.63    | Aktiivne |
| Maris Kuusik      | Tartu      | 3              | 944.20    | Aktiivne |
| Kersti Lill       | Narva      | 6              | 943.97    | Aktiivne |
| Anu Toom          | Tartu      | 3              | 942.25    | Aktiivne |
| Kadri Mets        | Tartu      | 4              | 942.17    | Aktiivne |
| Väino Mitt        | Tartu      | 2              | 942.11    | Aktiivne |
| Marko Kaalep      | Tallinn    | 3              | 941.07    | Aktiivne |
| Katrin Lill       | Viljandi   | 3              | 940.88    | Aktiivne |
| Annika Lill       | Paide      | 3              | 940.87    | Aktiivne |
| Toomas Raid       | Tartu      | 4              | 940.48    | Aktiivne |
| Merike Org        | Kuressaare | 4              | 940.05    | Aktiivne |
| Kalev Mägi        | Viljandi   | 3              | 939.46    | Aktiivne |
| Nele Koppel       | Tallinn    | 2              | 938.40    | Aktiivne |
| Taavi Salu        | Tallinn    | 3              | 937.94    | Aktiivne |
| Annika Kuusk      | Tartu      | 4              | 937.55    | Aktiivne |
| Jüri Raid         | Tartu      | 2              | 937.33    | Aktiivne |
| Kati Lill         | Tartu      | 5              | 937.25    | Aktiivne |
| Taavi Sepp        | Tallinn    | 3              | 936.18    | Aktiivne |
| Taavi Koppel      | Tartu      | 3              | 935.06    | Aktiivne |
| Rasmus Mägi       | Tallinn    | 4              | 935.05    | Aktiivne |
| Heli Salu         | Tartu      | 3              | 934.78    | Aktiivne |
| Terje Lõhmus      | Paide      | 3              | 933.59    | Aktiivne |
| Maie Männik       | Tartu      | 2              | 932.46    | Aktiivne |
| Tarmo Hurt        | Tallinn    | 3              | 932.31    | Aktiivne |
| Karin Lepp        | Pärnu      | 3              | 931.48    | Aktiivne |
| Kevin Aas         | Valga      | 3              | 929.31    | Aktiivne |
| Mihkel Raid       | Tartu      | 3              | 928.61    | Aktiivne |
| Priit Lass        | Tartu      | 2              | 927.11    | Aktiivne |
| Kati Kõiv         | Viljandi   | 4              | 926.56    | Aktiivne |
| Kristi Lõoke      | Võru       | 2              | 926.20    | Aktiivne |
| Marko Paju        | Tallinn    | 4              | 926.10    | Aktiivne |
| Ago Kukk          | Pärnu      | 3              | 925.97    | Aktiivne |
| Olev Lepp         | Tallinn    | 3              | 925.32    | Aktiivne |
| Marika Männik     | Tartu      | 4              | 925.08    | Aktiivne |
| Heli Tammik       | Tartu      | 3              | 924.89    | Aktiivne |
| Maris Mägi        | Tallinn    | 3              | 924.58    | Aktiivne |
| Mihkel Pihl       | Tallinn    | 4              | 924.33    | Aktiivne |
| Heli Pärn         | Paide      | 3              | 923.90    | Aktiivne |
| Aili Orav         | Tartu      | 4              | 923.79    | Aktiivne |
| Nele Valk         | Pärnu      | 4              | 922.89    | Aktiivne |
| Laura Aas         | Tartu      | 4              | 922.79    | Aktiivne |
| Margus Paas       | Haapsalu   | 2              | 922.02    | Aktiivne |
| Siim Lass         | Pärnu      | 2              | 920.69    | Aktiivne |
| Henri Roots       | Pärnu      | 3              | 918.91    | Aktiivne |
| Mihkel Lõoke      | Tallinn    | 2              | 918.50    | Aktiivne |
| Margus Luik       | Jõhvi      | 4              | 918.16    | Aktiivne |
| Elis Tamm         | Pärnu      | 4              | 917.83    | Aktiivne |
| Külli Mitt        | Tartu      | 4              | 917.08    | Aktiivne |
| Kristi Vaher      | Tallinn    | 2              | 915.75    | Aktiivne |
| Merike Raud       | Tallinn    | 3              | 914.60    | Aktiivne |
| Ants Lõhmus       | Tallinn    | 3              | 914.31    | Aktiivne |
| Aili Veski        | Pärnu      | 4              | 913.91    | Aktiivne |
| Karin Järv        | Paide      | 7              | 913.64    | Aktiivne |
| Ragnar Raid       | Tartu      | 2              | 913.14    | Aktiivne |
| Kristiina Tamm    | Võru       | 3              | 912.90    | Aktiivne |
| Indrek Männik     | Tallinn    | 4              | 912.51    | Aktiivne |
| Piret Orav        | Paide      | 4              | 912.02    | Aktiivne |
| Liis Nõmm         | Tallinn    | 4              | 911.47    | Aktiivne |
| Indrek Rand       | Valga      | 4              | 910.96    | Aktiivne |
| Kristiina Oja     | Tallinn    | 6              | 910.91    | Aktiivne |
| Karin Paas        | Tallinn    | 3              | 908.85    | Aktiivne |
| Kadri Vaher       | Viljandi   | 4              | 904.65    | Aktiivne |
| Tiit Paju         | Pärnu      | 4              | 904.38    | Aktiivne |
| Mart Mägi         | Pärnu      | 4              | 904.22    | Aktiivne |
| Toomas Lepp       | Tallinn    | 5              | 903.87    | Aktiivne |
| Enn Veski         | Tallinn    | 6              | 903.18    | Aktiivne |
| Rain Luik         | Tartu      | 3              | 902.90    | Aktiivne |
| Eha Kuusk         | Haapsalu   | 4              | 901.24    | Aktiivne |
| Ene Kuusik        | Tallinn    | 4              | 901.07    | Aktiivne |
| Väino Kuusik      | Tartu      | 4              | 900.95    | Aktiivne |
| Anna Arro         | Tartu      | 3              | 900.62    | Aktiivne |
| Siim Värk         | Tallinn    | 2              | 900.60    | Aktiivne |
| Anu Tamm          | Tartu      | 3              | 899.33    | Aktiivne |
| Heli Puusepp      | Tallinn    | 3              | 899.26    | Aktiivne |
| Karin Mitt        | Jõhvi      | 5              | 899.12    | Aktiivne |
| Peeter Pihl       | Valga      | 3              | 899.00    | Aktiivne |
| Merle Põld        | Pärnu      | 5              | 898.86    | Aktiivne |
| Lea Teder         | Pärnu      | 3              | 898.75    | Aktiivne |
| Urmas Värk        | Narva      | 2              | 898.37    | Aktiivne |
| Tõnu Valk         | Tallinn    | 4              | 897.82    | Aktiivne |
| Annika Teder      | Pärnu      | 3              | 896.82    | Aktiivne |
| Ants Salu         | Paide      | 3              | 896.46    | Aktiivne |
| Merike Roots      | Tallinn    | 3              | 896.40    | Aktiivne |
| Ene Kõiv          | Tallinn    | 3              | 896.15    | Aktiivne |
| Arvo Laas         | Tallinn    | 5              | 895.96    | Aktiivne |
| Ülle Org          | Tartu      | 2              | 894.25    | Aktiivne |
| Katrin Kull       | Tallinn    | 3              | 894.12    | Aktiivne |
| Lea Veski         | Tartu      | 3              | 893.30    | Aktiivne |
| Priit Kivi        | Tallinn    | 3              | 892.41    | Aktiivne |
| Reet Rosin        | Pärnu      | 3              | 892.39    | Aktiivne |
| Ragnar Tamm       | Jõhvi      | 2              | 889.56    | Aktiivne |
| Tõnu Nurk         | Tartu      | 3              | 889.21    | Aktiivne |
| Annika Lõhmus     | Tallinn    | 2              | 888.68    | Aktiivne |
| Margus Mets       | Tallinn    | 3              | 888.66    | Aktiivne |
| Aivar Järv        | Tallinn    | 2              | 888.49    | Aktiivne |
| Anna Kangur       | Viljandi   | 4              | 888.18    | Aktiivne |
| Külli Mitt        | Jõhvi      | 5              | 887.86    | Aktiivne |
| Liina Kukk        | Rakvere    | 4              | 887.60    | Aktiivne |
| Kristjan Rand     | Tallinn    | 3              | 887.48    | Aktiivne |
| Ants Teder        | Tallinn    | 4              | 886.15    | Aktiivne |
| Piret Toom        | Pärnu      | 4              | 885.97    | Aktiivne |
| Sandra Org        | Pärnu      | 3              | 885.42    | Aktiivne |
| Reet Nõmm         | Narva      | 2              | 885.07    | Aktiivne |
| Reet Laas         | Haapsalu   | 1              | 884.76    | Aktiivne |
| Merle Raud        | Pärnu      | 2              | 884.20    | Aktiivne |
| Enn Liiv          | Tallinn    | 5              | 883.77    | Aktiivne |
| Väino Pärn        | Tartu      | 3              | 883.77    | Aktiivne |
| Toomas Mitt       | Tallinn    | 3              | 882.62    | Aktiivne |
| Eha Pärn          | Pärnu      | 2              | 882.58    | Aktiivne |
| Nele Paju         | Tallinn    | 2              | 882.54    | Aktiivne |
| Priit Luik        | Tallinn    | 3              | 881.22    | Aktiivne |
| Liina Saar        | Tallinn    | 5              | 881.04    | Aktiivne |
| Sandra Puusepp    | Kuressaare | 2              | 880.94    | Aktiivne |
| Nele Ilves        | Jõhvi      | 2              | 880.48    | Aktiivne |
| Andres Saar       | Pärnu      | 3              | 880.46    | Aktiivne |
| Maris Orav        | Narva      | 3              | 879.08    | Aktiivne |
| Piret Kaalep      | Tartu      | 5              | 878.82    | Aktiivne |
| Kevin Raid        | Pärnu      | 4              | 878.56    | Aktiivne |
| Väino Lõoke       | Tallinn    | 3              | 875.74    | Aktiivne |
| Anna Kuusk        | Haapsalu   | 5              | 873.86    | Aktiivne |
| Ülle Teder        | Tallinn    | 4              | 873.33    | Aktiivne |
| Hille Paju        | Tallinn    | 3              | 871.94    | Aktiivne |
| Kevin Tammik      | Tallinn    | 2              | 870.82    | Aktiivne |
| Kristiina Valk    | Tartu      | 4              | 870.08    | Aktiivne |
| Sigrid Järv       | Tallinn    | 4              | 868.85    | Aktiivne |
| Kristjan Ilves    | Tallinn    | 2              | 866.84    | Aktiivne |
| Karin Mets        | Tallinn    | 4              | 864.93    | Aktiivne |
| Riina Koppel      | Tartu      | 6              | 864.75    | Aktiivne |
| Mihkel Koppel     | Tallinn    | 3              | 862.86    | Aktiivne |
| Maie Kõiv         | Valga      | 3              | 862.57    | Aktiivne |
| Eha Org           | Tallinn    | 4              | 862.50    | Aktiivne |
| Merike Männik     | Tallinn    | 3              | 861.40    | Aktiivne |
| Lea Orav          | Rakvere    | 2              | 861.12    | Aktiivne |
| Tarmo Toom        | Rakvere    | 3              | 859.12    | Aktiivne |
| Andres Lepp       | Tartu      | 2              | 859.08    | Aktiivne |
| Sirje Järv        | Tallinn    | 3              | 858.98    | Aktiivne |
| Rein Valk         | Valga      | 2              | 857.97    | Aktiivne |
| Tõnu Must         | Tallinn    | 5              | 857.21    | Aktiivne |
| Ülle Teder        | Tartu      | 5              | 857.14    | Aktiivne |
| Ragnar Raud       | Tallinn    | 3              | 857.03    | Aktiivne |
| Eha Pärn          | Narva      | 5              | 856.03    | Aktiivne |
| Aili Nõmm         | Pärnu      | 3              | 853.62    | Aktiivne |
| Sirje Sepp        | Tallinn    | 5              | 853.25    | Aktiivne |
| Aivar Ilves       | Rakvere    | 4              | 852.81    | Aktiivne |
| Jaak Talvik       | Tartu      | 2              | 852.45    | Aktiivne |
| Grete Salu        | Tallinn    | 2              | 852.17    | Aktiivne |
| Elis Tammik       | Tartu      | 3              | 852.16    | Aktiivne |
| Lea Kull          | Haapsalu   | 4              | 851.03    | Aktiivne |
| Mart Lass         | Tartu      | 2              | 850.91    | Aktiivne |
| Hille Pihl        | Tartu      | 4              | 850.83    | Aktiivne |
| Aili Mägi         | Viljandi   | 4              | 850.11    | Aktiivne |
| Sander Sild       | Tallinn    | 4              | 850.00    | Aktiivne |
| Enn Orav          | Tallinn    | 4              | 849.14    | Aktiivne |
| Aili Liiv         | Tartu      | 5              | 848.92    | Aktiivne |
| Kristjan Roots    | Tallinn    | 1              | 848.85    | Aktiivne |
| Ene Sepp          | Tallinn    | 4              | 848.46    | Aktiivne |
| Rain Nurk         | Tallinn    | 4              | 848.06    | Aktiivne |
| Henri Järv        | Pärnu      | 4              | 846.67    | Aktiivne |
| Jüri Mets         | Tallinn    | 3              | 845.08    | Aktiivne |
| Sandra Org        | Tallinn    | 2              | 844.86    | Aktiivne |
| Reet Lõhmus       | Tallinn    | 2              | 844.08    | Aktiivne |
| Tiina Nõmm        | Tallinn    | 3              | 843.20    | Aktiivne |
| Raivo Rebane      | Tallinn    | 3              | 842.59    | Aktiivne |
| Kadri Kõiv        | Tallinn    | 6              | 842.46    | Aktiivne |
| Mihkel Talvik     | Tartu      | 3              | 842.39    | Aktiivne |
| Merle Kukk        | Võru       | 3              | 841.50    | Aktiivne |
| Kristiina Veski   | Kuressaare | 2              | 840.36    | Aktiivne |
| Peeter Liiv       | Tallinn    | 2              | 840.32    | Aktiivne |
| Marko Mägi        | Võru       | 5              | 840.29    | Aktiivne |
| Maris Sild        | Tallinn    | 2              | 839.56    | Aktiivne |
| Piret Vaher       | Tallinn    | 3              | 838.56    | Aktiivne |
| Marit Järv        | Tallinn    | 4              | 836.82    | Aktiivne |
| Kati Paas         | Valga      | 2              | 835.75    | Aktiivne |
| Ülle Saar         | Pärnu      | 7              | 835.43    | Aktiivne |
| Sandra Sepp       | Valga      | 4              | 835.34    | Aktiivne |
| Toomas Puusepp    | Tallinn    | 3              | 834.11    | Aktiivne |
| Mihkel Talvik     | Tartu      | 4              | 833.60    | Aktiivne |
| Heli Roots        | Tartu      | 4              | 831.40    | Aktiivne |
| Indrek Teder      | Tallinn    | 1              | 831.35    | Aktiivne |
| Meelis Mets       | Tallinn    | 3              | 831.13    | Aktiivne |
| Jüri Kõiv         | Tartu      | 4              | 829.18    | Aktiivne |
| Urmas Pihl        | Tallinn    | 1              | 828.60    | Aktiivne |
| Rain Lepik        | Tartu      | 4              | 828.28    | Aktiivne |
| Rein Paas         | Tallinn    | 3              | 827.12    | Aktiivne |
| Henri Roots       | Tallinn    | 4              | 826.72    | Aktiivne |
| Taavi Puusepp     | Tallinn    | 2              | 826.63    | Aktiivne |
| Rein Kuusk        | Tallinn    | 3              | 824.35    | Aktiivne |
| Margus Ilves      | Tallinn    | 3              | 823.33    | Aktiivne |
| Jaak Kull         | Tartu      | 2              | 822.76    | Aktiivne |
| Heino Puusepp     | Tartu      | 3              | 821.59    | Aktiivne |
| Madis Kull        | Võru       | 4              | 821.24    | Aktiivne |
| Kevin Lõhmus      | Tallinn    | 4              | 820.46    | Aktiivne |
| Madis Salu        | Haapsalu   | 3              | 820.42    | Aktiivne |
| Margus Arro       | Tartu      | 3              | 817.76    | Aktiivne |
| Katrin Kaalep     | Tallinn    | 3              | 816.89    | Aktiivne |
| Ragnar Lepik      | Tartu      | 4              | 815.77    | Aktiivne |
| Jüri Veski        | Tallinn    | 4              | 814.97    | Aktiivne |
| Katrin Kaalep     | Pärnu      | 2              | 814.85    | Aktiivne |
| Liina Mägi        | Rakvere    | 5              | 814.17    | Aktiivne |
| Ago Toom          | Viljandi   | 4              | 814.17    | Aktiivne |
| Marika Lass       | Pärnu      | 5              | 813.20    | Aktiivne |
| Sigrid Kuusik     | Kuressaare | 3              | 812.32    | Aktiivne |
| Mihkel Pihl       | Pärnu      | 6              | 811.55    | Aktiivne |
| Rein Saar         | Jõhvi      | 4              | 810.53    | Aktiivne |
| Ants Nurk         | Rakvere    | 3              | 808.96    | Aktiivne |
| Maie Koppel       | Tallinn    | 4              | 807.98    | Aktiivne |
| Laura Kallas      | Rakvere    | 2              | 806.50    | Aktiivne |
| Rasmus Rosin      | Tallinn    | 6              | 805.53    | Aktiivne |
| Henri Põld        | Narva      | 4              | 805.41    | Aktiivne |
| Grete Kukk        | Valga      | 3              | 805.13    | Aktiivne |
| Annika Vaher      | Pärnu      | 2              | 803.56    | Aktiivne |
| Kati Tammik       | Valga      | 6              | 802.88    | Aktiivne |
| Kati Rand         | Tallinn    | 5              | 802.45    | Aktiivne |
| Tiina Teder       | Narva      | 4              | 802.21    | Aktiivne |
| Mart Pihl         | Tallinn    | 2              | 802.16    | Aktiivne |
| Merike Sild       | Tallinn    | 4              | 801.99    | Aktiivne |
| Merike Kivi       | Tallinn    | 2              | 801.38    | Aktiivne |
| Kristi Kuusk      | Tartu      | 3              | 800.32    | Aktiivne |
| Annika Lõoke      | Tartu      | 3              | 800.08    | Aktiivne |
| Marika Paas       | Valga      | 3              | 799.35    | Aktiivne |
| Andres Toom       | Jõhvi      | 2              | 798.67    | Aktiivne |
| Margus Kõiv       | Tartu      | 2              | 797.38    | Aktiivne |
| Marko Arro        | Tallinn    | 3              | 797.23    | Aktiivne |
| Madis Lass        | Narva      | 5              | 796.61    | Aktiivne |
| Taavi Vaher       | Pärnu      | 3              | 796.53    | Aktiivne |
| Katrin Nurk       | Tallinn    | 4              | 795.57    | Aktiivne |
| Marit Toom        | Tallinn    | 3              | 795.54    | Aktiivne |
| Annika Roots      | Tallinn    | 5              | 794.34    | Aktiivne |
| Toomas Luik       | Tartu      | 2              | 794.14    | Aktiivne |
| Merike Sild       | Tallinn    | 4              | 793.86    | Aktiivne |
| Kaido Lass        | Tartu      | 3              | 792.99    | Aktiivne |
| Sigrid Kivi       | Narva      | 3              | 792.49    | Aktiivne |
| Hille Tamm        | Pärnu      | 3              | 792.44    | Aktiivne |
| Ene Paju          | Valga      | 4              | 792.25    | Aktiivne |
| Maie Orav         | Rakvere    | 2              | 791.02    | Aktiivne |
| Terje Männik      | Kuressaare | 1              | 789.39    | Aktiivne |
| Marko Lõhmus      | Tartu      | 1              | 789.39    | Aktiivne |
| Heli Rebane       | Võru       | 3              | 789.36    | Aktiivne |
| Mihkel Värk       | Tallinn    | 6              | 788.53    | Aktiivne |
| Henri Kangur      | Narva      | 3              | 786.07    | Aktiivne |
| Nele Männik       | Tallinn    | 4              | 784.36    | Aktiivne |
| Meelis Kivi       | Tartu      | 3              | 784.34    | Aktiivne |
| Sandra Tammik     | Tartu      | 2              | 784.25    | Aktiivne |
| Ülle Valk         | Pärnu      | 4              | 783.78    | Aktiivne |
| Jüri Pärn         | Pärnu      | 3              | 783.74    | Aktiivne |
| Aili Kukk         | Pärnu      | 3              | 783.44    | Aktiivne |
| Kristiina Tammik  | Rakvere    | 3              | 782.91    | Aktiivne |
| Marit Tammik      | Jõhvi      | 4              | 782.71    | Aktiivne |
| Mihkel Arro       | Tallinn    | 5              | 782.38    | Aktiivne |
| Kristi Nõmm       | Narva      | 5              | 782.03    | Aktiivne |
| Ants Roots        | Võru       | 3              | 777.38    | Aktiivne |
| Sandra Pihl       | Haapsalu   | 3              | 777.00    | Aktiivne |
| Rein Rand         | Tallinn    | 3              | 776.53    | Aktiivne |
| Erkki Pihl        | Haapsalu   | 5              | 774.86    | Aktiivne |
| Kadri Tammik      | Tallinn    | 2              | 774.34    | Aktiivne |
| Priit Org         | Tallinn    | 1              | 773.55    | Aktiivne |
| Kevin Lill        | Tallinn    | 4              | 772.92    | Aktiivne |
| Piret Puusepp     | Tallinn    | 3              | 770.39    | Aktiivne |
| Merle Luik        | Tallinn    | 3              | 769.74    | Aktiivne |
| Tõnu Kõiv         | Viljandi   | 2              | 768.33    | Aktiivne |
| Lauri Kõiv        | Tartu      | 2              | 767.01    | Aktiivne |
| Mihkel Kallas     | Tallinn    | 3              | 765.19    | Aktiivne |
| Lea Nõmm          | Tallinn    | 5              | 763.36    | Aktiivne |
| Ülle Kangur       | Pärnu      | 1              | 761.40    | Aktiivne |
| Priit Teder       | Tallinn    | 3              | 761.28    | Aktiivne |
| Aivar Lill        | Tartu      | 2              | 760.46    | Aktiivne |
| Kevin Pihl        | Tallinn    | 3              | 760.31    | Aktiivne |
| Merle Järv        | Tartu      | 3              | 759.37    | Aktiivne |
| Arvo Paas         | Tartu      | 5              | 759.27    | Aktiivne |
| Nele Lepp         | Tallinn    | 4              | 757.84    | Aktiivne |
| Kadri Kull        | Kuressaare | 2              | 757.46    | Aktiivne |
| Merle Must        | Tallinn    | 2              | 757.19    | Aktiivne |
| Tõnu Paju         | Tallinn    | 1              | 756.99    | Aktiivne |
| Liina Pärn        | Haapsalu   | 4              | 756.99    | Aktiivne |
| Kadri Mitt        | Pärnu      | 2              | 756.64    | Aktiivne |
| Madis Kask        | Tallinn    | 1              | 756.30    | Aktiivne |
| Katrin Kull       | Tallinn    | 3              | 756.30    | Aktiivne |
| Liis Laas         | Tallinn    | 3              | 756.25    | Aktiivne |
| Kadri Tammik      | Pärnu      | 3              | 755.46    | Aktiivne |
| Riina Rosin       | Tallinn    | 5              | 755.35    | Aktiivne |
| Ants Hurt         | Tallinn    | 3              | 755.17    | Aktiivne |
| Kristjan Mets     | Tartu      | 3              | 754.90    | Aktiivne |
| Tiit Mets         | Tartu      | 4              | 754.85    | Aktiivne |
| Kalev Arro        | Tallinn    | 4              | 754.06    | Aktiivne |
| Külli Kuusik      | Tallinn    | 4              | 754.00    | Aktiivne |
| Taavi Järv        | Tartu      | 6              | 753.47    | Aktiivne |
| Siim Toom         | Pärnu      | 2              | 752.47    | Aktiivne |
| Annika Kangur     | Rakvere    | 4              | 750.70    | Aktiivne |
| Sandra Saar       | Tallinn    | 1              | 750.68    | Aktiivne |
| Laura Lõoke       | Tallinn    | 3              | 750.28    | Aktiivne |
| Terje Roots       | Tartu      | 4              | 749.68    | Aktiivne |
| Kati Järv         | Viljandi   | 3              | 749.32    | Aktiivne |
| Siim Sepp         | Tallinn    | 3              | 748.95    | Aktiivne |
| Sandra Raud       | Tartu      | 4              | 748.68    | Aktiivne |
| Nele Kivi         | Pärnu      | 4              | 748.66    | Aktiivne |
| Tiina Kukk        | Tartu      | 3              | 747.37    | Aktiivne |
| Ago Nurk          | Pärnu      | 2              | 747.26    | Aktiivne |
| Eha Kivi          | Tallinn    | 2              | 746.53    | Aktiivne |
| Jüri Toom         | Tartu      | 4              | 745.69    | Aktiivne |
| Marko Mägi        | Pärnu      | 5              | 745.13    | Aktiivne |
| Maie Tammik       | Pärnu      | 2              | 744.80    | Aktiivne |
| Henri Mets        | Tallinn    | 2              | 744.42    | Aktiivne |
| Nele Talvik       | Tartu      | 3              | 743.75    | Aktiivne |
| Triin Mitt        | Narva      | 4              | 743.11    | Aktiivne |
| Jaak Nurk         | Kuressaare | 3              | 742.41    | Aktiivne |
| Sandra Roots      | Tallinn    | 2              | 742.18    | Aktiivne |
| Mihkel Saar       | Viljandi   | 3              | 741.72    | Aktiivne |
| Eha Hurt          | Tallinn    | 5              | 741.12    | Aktiivne |
| Lauri Roots       | Tallinn    | 3              | 740.83    | Aktiivne |
| Kristjan Raid     | Jõhvi      | 6              | 740.53    | Aktiivne |
| Katrin Teder      | Tallinn    | 6              | 740.08    | Aktiivne |
| Sandra Veski      | Tallinn    | 2              | 738.96    | Aktiivne |
| Urmas Kuusk       | Kuressaare | 5              | 737.71    | Aktiivne |
| Tarmo Sild        | Narva      | 1              | 737.34    | Aktiivne |
| Pille Rand        | Tartu      | 5              | 737.18    | Aktiivne |
| Rasmus Männik     | Tallinn    | 3              | 734.03    | Aktiivne |
| Ants Roots        | Tartu      | 5              | 733.90    | Aktiivne |
| Väino Mägi        | Tallinn    | 3              | 733.09    | Aktiivne |
| Margus Pärn       | Paide      | 3              | 732.34    | Aktiivne |
| Aivar Põld        | Tallinn    | 4              | 731.83    | Aktiivne |
| Ants Saar         | Tallinn    | 2              | 731.37    | Aktiivne |
| Liis Salu         | Pärnu      | 4              | 731.08    | Aktiivne |
| Elis Kaalep       | Tallinn    | 3              | 730.82    | Aktiivne |
| Pille Aas         | Haapsalu   | 3              | 729.79    | Aktiivne |
| Jüri Laas         | Tallinn    | 3              | 727.73    | Aktiivne |
| Jüri Salu         | Tartu      | 1              | 727.29    | Aktiivne |
| Triin Rand        | Rakvere    | 2              | 725.58    | Aktiivne |
| Mart Nõmm         | Paide      | 2              | 724.08    | Aktiivne |
| Rasmus Teder      | Valga      | 1              | 723.39    | Aktiivne |
| Ülle Kaalep       | Valga      | 2              | 723.33    | Aktiivne |
| Enn Paas          | Tallinn    | 3              | 722.87    | Aktiivne |
| Reet Lepp         | Rakvere    | 3              | 722.73    | Aktiivne |
| Hille Järv        | Pärnu      | 3              | 722.29    | Aktiivne |
| Kalev Must        | Tartu      | 4              | 722.23    | Aktiivne |
| Ragnar Lill       | Tartu      | 3              | 722.07    | Aktiivne |
| Ago Kuusk         | Jõhvi      | 2              | 721.58    | Aktiivne |
| Kersti Kuusik     | Valga      | 3              | 721.17    | Aktiivne |
| Katrin Luik       | Tallinn    | 3              | 720.85    | Aktiivne |
| Enn Sild          | Rakvere    | 4              | 720.69    | Aktiivne |
| Kaido Hurt        | Viljandi   | 2              | 720.30    | Aktiivne |
| Arvo Kull         | Tartu      | 4              | 718.98    | Aktiivne |
| Rein Orav         | Tallinn    | 3              | 718.16    | Aktiivne |
| Jüri Kukk         | Kuressaare | 4              | 718.13    | Aktiivne |
| Marika Arro       | Tallinn    | 3              | 715.90    | Aktiivne |
| Kati Aas          | Valga      | 5              | 715.54    | Aktiivne |
| Rasmus Kull       | Tartu      | 6              | 715.35    | Aktiivne |
| Madis Pärn        | Tallinn    | 2              | 714.62    | Aktiivne |
| Annika Aas        | Võru       | 1              | 713.14    | Aktiivne |
| Tiit Tamm         | Tallinn    | 1              | 713.14    | Aktiivne |
| Kevin Rosin       | Haapsalu   | 2              | 712.84    | Aktiivne |
| Tarmo Kaalep      | Võru       | 4              | 712.53    | Aktiivne |
| Kristi Luik       | Tartu      | 3              | 711.60    | Aktiivne |
| Olev Oja          | Narva      | 3              | 710.66    | Aktiivne |
| Sirje Arro        | Tartu      | 4              | 710.54    | Aktiivne |
| Marko Pärn        | Rakvere    | 3              | 709.47    | Aktiivne |
| Piret Kallas      | Tallinn    | 5              | 708.18    | Aktiivne |
| Andres Vaher      | Tartu      | 2              | 707.12    | Aktiivne |
| Laura Mitt        | Pärnu      | 4              | 706.78    | Aktiivne |
| Anu Puusepp       | Tartu      | 2              | 706.70    | Aktiivne |
| Liina Kuusk       | Tartu      | 1              | 706.60    | Aktiivne |
| Lea Ilves         | Narva      | 4              | 705.60    | Aktiivne |
| Taavi Raud        | Pärnu      | 3              | 703.03    | Aktiivne |
| Meelis Roots      | Pärnu      | 3              | 702.22    | Aktiivne |
| Olev Arro         | Jõhvi      | 4              | 702.00    | Aktiivne |
| Andres Arro       | Viljandi   | 3              | 701.48    | Aktiivne |
| Ants Kuusk        | Tallinn    | 3              | 701.40    | Aktiivne |
| Taavi Hurt        | Tallinn    | 2              | 701.22    | Aktiivne |
| Ago Kallas        | Tartu      | 3              | 700.87    | Aktiivne |
| Mart Lepp         | Tallinn    | 4              | 700.49    | Aktiivne |
| Aivar Järv        | Tartu      | 3              | 699.21    | Aktiivne |
| Ülle Lass         | Tallinn    | 3              | 699.16    | Aktiivne |
| Ene Rosin         | Pärnu      | 4              | 698.89    | Aktiivne |
| Madis Männik      | Viljandi   | 3              | 698.22    | Aktiivne |
| Elis Põld         | Tallinn    | 4              | 697.72    | Aktiivne |
| Sandra Kukk       | Tallinn    | 4              | 696.94    | Aktiivne |
| Margus Kukk       | Tallinn    | 4              | 695.92    | Aktiivne |
| Erkki Arro        | Tallinn    | 1              | 695.68    | Aktiivne |
| Triin Koppel      | Tallinn    | 2              | 694.66    | Aktiivne |
| Tiit Kaalep       | Tartu      | 1              | 693.40    | Aktiivne |
| Kalev Kukk        | Tartu      | 2              | 693.00    | Aktiivne |
| Taavi Kõiv        | Tallinn    | 3              | 692.42    | Aktiivne |
| Arvo Kull         | Jõhvi      | 3              | 692.29    | Aktiivne |
| Ülle Kuusik       | Jõhvi      | 3              | 691.10    | Aktiivne |
| Eha Lepik         | Tartu      | 3              | 690.89    | Aktiivne |
| Maris Lepp        | Tartu      | 3              | 689.85    | Aktiivne |
| Piret Raud        | Tallinn    | 3              | 689.77    | Aktiivne |
| Eha Värk          | Viljandi   | 4              | 688.28    | Aktiivne |
| Heli Kõiv         | Tallinn    | 5              | 686.03    | Aktiivne |
| Grete Koppel      | Narva      | 2              | 685.86    | Aktiivne |
| Maie Laas         | Tartu      | 3              | 685.79    | Aktiivne |
| Siim Liiv         | Pärnu      | 1              | 685.32    | Aktiivne |
| Katrin Männik     | Tallinn    | 3              | 684.41    | Aktiivne |
| Kristiina Puusepp | Tartu      | 3              | 683.99    | Aktiivne |
| Elis Kivi         | Tallinn    | 3              | 683.80    | Aktiivne |
| Grete Oja         | Tallinn    | 2              | 683.55    | Aktiivne |
| Tarmo Kallas      | Viljandi   | 3              | 683.38    | Aktiivne |
| Urmas Kõiv        | Tallinn    | 3              | 681.98    | Aktiivne |
| Jaak Kuusik       | Tallinn    | 3              | 681.97    | Aktiivne |
| Väino Paju        | Tartu      | 7              | 681.73    | Aktiivne |
| Indrek Puusepp    | Tallinn    | 3              | 681.02    | Aktiivne |
| Margus Veski      | Tallinn    | 3              | 680.26    | Aktiivne |
| Maris Nurk        | Tartu      | 3              | 679.95    | Aktiivne |
| Meelis Kaalep     | Kuressaare | 3              | 679.77    | Aktiivne |
| Raivo Lepp        | Tartu      | 3              | 679.60    | Aktiivne |
| Terje Kallas      | Tallinn    | 4              | 679.32    | Aktiivne |
| Liina Rand        | Tallinn    | 4              | 678.83    | Aktiivne |
| Aivar Lepik       | Kuressaare | 3              | 678.09    | Aktiivne |
| Maie Rosin        | Paide      | 4              | 677.93    | Aktiivne |
| Aivar Raud        | Tallinn    | 4              | 677.78    | Aktiivne |
| Kadri Koppel      | Tartu      | 2              | 677.11    | Aktiivne |
| Kristiina Rosin   | Tallinn    | 2              | 676.32    | Aktiivne |
| Jaak Raud         | Tallinn    | 3              | 675.94    | Aktiivne |
| Laura Männik      | Tallinn    | 3              | 675.81    | Aktiivne |
| Meelis Tamm       | Pärnu      | 4              | 675.25    | Aktiivne |
| Rein Pihl         | Tallinn    | 4              | 674.45    | Aktiivne |
| Margus Kallas     | Tartu      | 3              | 674.30    | Aktiivne |
| Erkki Tammik      | Tallinn    | 3              | 673.16    | Aktiivne |
| Kristjan Hurt     | Rakvere    | 3              | 670.36    | Aktiivne |
| Triin Talvik      | Tallinn    | 2              | 670.14    | Aktiivne |
| Indrek Mägi       | Viljandi   | 2              | 669.38    | Aktiivne |
| Andres Männik     | Tartu      | 4              | 668.22    | Aktiivne |
| Sander Lass       | Tallinn    | 4              | 667.76    | Aktiivne |
| Taavi Teder       | Tartu      | 3              | 667.14    | Aktiivne |
| Marika Kõiv       | Tallinn    | 6              | 665.55    | Aktiivne |
| Margus Vaher      | Narva      | 1              | 665.10    | Aktiivne |
| Merle Saar        | Kuressaare | 2              | 664.51    | Aktiivne |
| Heino Kaalep      | Tartu      | 2              | 664.41    | Aktiivne |
| Marika Lill       | Tartu      | 1              | 664.26    | Aktiivne |
| Erkki Mitt        | Tartu      | 1              | 664.26    | Aktiivne |
| Merike Ilves      | Tallinn    | 3              | 664.11    | Aktiivne |
| Toomas Arro       | Tallinn    | 4              | 662.86    | Aktiivne |
| Kadri Ilves       | Tallinn    | 4              | 662.60    | Aktiivne |
| Erkki Oja         | Viljandi   | 2              | 662.48    | Aktiivne |
| Kaido Orav        | Narva      | 3              | 662.36    | Aktiivne |
| Meelis Aas        | Tartu      | 4              | 661.82    | Aktiivne |
| Hille Raid        | Pärnu      | 3              | 661.73    | Aktiivne |
| Margus Lass       | Kuressaare | 2              | 661.17    | Aktiivne |
| Eha Vaher         | Tartu      | 2              | 661.00    | Aktiivne |
| Väino Roots       | Tartu      | 2              | 660.08    | Aktiivne |
| Raivo Talvik      | Tartu      | 4              | 660.00    | Aktiivne |
| Terje Järv        | Tallinn    | 2              | 659.59    | Aktiivne |
| Kadri Liiv        | Tallinn    | 2              | 659.57    | Aktiivne |
| Grete Org         | Pärnu      | 1              | 659.49    | Aktiivne |
| Aili Paas         | Tallinn    | 3              | 659.35    | Aktiivne |
| Tarmo Paas        | Tallinn    | 2              | 658.49    | Aktiivne |
| Väino Orav        | Haapsalu   | 2              | 657.83    | Aktiivne |
| Siim Nõmm         | Tartu      | 3              | 657.58    | Aktiivne |
| Siim Toom         | Tallinn    | 4              | 654.24    | Aktiivne |
| Taavi Pihl        | Tartu      | 1              | 654.14    | Aktiivne |
| Ülle Org          | Tartu      | 1              | 654.14    | Aktiivne |
| Eha Lepik         | Tartu      | 2              | 652.84    | Aktiivne |
| Külli Talvik      | Paide      | 6              | 652.41    | Aktiivne |
| Riina Liiv        | Tartu      | 4              | 651.23    | Aktiivne |
| Heino Pihl        | Tartu      | 3              | 650.55    | Aktiivne |
| Külli Must        | Tartu      | 2              | 649.21    | Aktiivne |
| Aili Saar         | Tartu      | 5              | 648.02    | Aktiivne |
| Katrin Paju       | Pärnu      | 5              | 647.90    | Aktiivne |
| Piret Paju        | Tallinn    | 2              | 647.83    | Aktiivne |
| Liis Ilves        | Tallinn    | 2              | 647.62    | Aktiivne |
| Reet Sild         | Pärnu      | 2              | 647.44    | Aktiivne |
| Jüri Valk         | Rakvere    | 3              | 647.03    | Aktiivne |
| Marko Hurt        | Tartu      | 2              | 647.02    | Aktiivne |
| Ants Ilves        | Tallinn    | 3              | 646.84    | Aktiivne |
| Margus Laas       | Pärnu      | 3              | 646.35    | Aktiivne |
| Lea Must          | Tallinn    | 3              | 645.47    | Aktiivne |
| Annika Sild       | Tartu      | 3              | 644.88    | Aktiivne |
| Piret Kivi        | Tallinn    | 1              | 642.84    | Aktiivne |
| Maris Kask        | Narva      | 3              | 642.23    | Aktiivne |
| Indrek Tamm       | Tallinn    | 1              | 642.20    | Aktiivne |
| Riina Sepp        | Pärnu      | 3              | 641.73    | Aktiivne |
| Heino Sild        | Tallinn    | 3              | 641.60    | Aktiivne |
| Kristi Järv       | Valga      | 6              | 638.36    | Aktiivne |
| Rasmus Must       | Tartu      | 4              | 637.64    | Aktiivne |
| Karin Paas        | Pärnu      | 3              | 636.96    | Aktiivne |
| Tarmo Hurt        | Võru       | 2              | 636.47    | Aktiivne |
| Heino Lõhmus      | Tallinn    | 4              | 636.19    | Aktiivne |
| Kalev Pärn        | Haapsalu   | 3              | 635.80    | Aktiivne |
| Andres Kask       | Tartu      | 2              | 635.62    | Aktiivne |
| Kersti Mets       | Tallinn    | 2              | 635.51    | Aktiivne |
| Väino Paju        | Kuressaare | 2              | 632.70    | Aktiivne |
| Reet Männik       | Valga      | 2              | 632.67    | Aktiivne |
| Kersti Järv       | Viljandi   | 3              | 632.27    | Aktiivne |
| Heino Nõmm        | Jõhvi      | 4              | 631.71    | Aktiivne |
| Mihkel Kallas     | Haapsalu   | 2              | 630.57    | Aktiivne |
| Aili Kangur       | Pärnu      | 4              | 630.11    | Aktiivne |
| Kristiina Toom    | Tartu      | 2              | 629.84    | Aktiivne |
| Ago Lõoke         | Viljandi   | 5              | 628.34    | Aktiivne |
| Ragnar Kull       | Pärnu      | 2              | 627.97    | Aktiivne |
| Kristjan Lepp     | Tartu      | 3              | 626.94    | Aktiivne |
| Kaido Lõoke       | Viljandi   | 3              | 626.71    | Aktiivne |
| Sigrid Nurk       | Võru       | 2              | 626.58    | Aktiivne |
| Mart Kuusk        | Tallinn    | 2              | 626.36    | Aktiivne |
| Madis Sepp        | Pärnu      | 3              | 626.30    | Aktiivne |
| Arvo Salu         | Tallinn    | 1              | 626.16    | Aktiivne |
| Maie Veski        | Tartu      | 2              | 625.50    | Aktiivne |
| Meelis Org        | Tartu      | 2              | 625.50    | Aktiivne |
| Kalev Kallas      | Kuressaare | 3              | 625.00    | Aktiivne |
| Kristi Kivi       | Viljandi   | 1              | 624.82    | Aktiivne |
| Tõnu Värk         | Tallinn    | 5              | 623.80    | Aktiivne |
| Maie Mägi         | Tallinn    | 4              | 621.21    | Aktiivne |
| Liis Lõoke        | Tartu      | 3              | 620.43    | Aktiivne |
| Taavi Pihl        | Haapsalu   | 8              | 619.58    | Aktiivne |
| Karin Kask        | Tallinn    | 1              | 617.68    | Aktiivne |
| Kaido Tammik      | Haapsalu   | 2              | 617.62    | Aktiivne |
| Kaido Rosin       | Tallinn    | 2              | 617.28    | Aktiivne |
| Sirje Lepp        | Pärnu      | 3              | 616.87    | Aktiivne |
| Kadri Aas         | Tallinn    | 4              | 616.85    | Aktiivne |
| Väino Kukk        | Kuressaare | 2              | 616.51    | Aktiivne |
| Kristjan Pärn     | Pärnu      | 4              | 616.49    | Aktiivne |
| Hille Sild        | Tallinn    | 1              | 615.66    | Aktiivne |
| Rein Raid         | Jõhvi      | 2              | 614.92    | Aktiivne |
| Eha Luik          | Viljandi   | 3              | 614.64    | Aktiivne |
| Kadri Luik        | Pärnu      | 1              | 614.61    | Aktiivne |
| Lea Mets          | Pärnu      | 3              | 612.84    | Aktiivne |
| Rasmus Sepp       | Tallinn    | 3              | 611.11    | Aktiivne |
| Margus Kask       | Tallinn    | 4              | 610.82    | Aktiivne |
| Külli Tamm        | Tallinn    | 4              | 610.07    | Aktiivne |
| Lea Aas           | Pärnu      | 4              | 610.02    | Aktiivne |
| Taavi Kuusk       | Tallinn    | 3              | 609.19    | Aktiivne |
| Elis Pärn         | Jõhvi      | 2              | 608.00    | Aktiivne |
| Henri Lill        | Tartu      | 4              | 606.26    | Aktiivne |
| Tiit Lõoke        | Tartu      | 4              | 606.08    | Aktiivne |
| Pille Nõmm        | Tartu      | 1              | 605.72    | Aktiivne |
| Madis Tammik      | Tallinn    | 1              | 605.72    | Aktiivne |
| Hille Kallas      | Tallinn    | 1              | 605.72    | Aktiivne |
| Heino Kuusk       | Valga      | 2              | 605.69    | Aktiivne |
| Priit Valk        | Võru       | 2              | 603.76    | Aktiivne |
| Enn Järv          | Tallinn    | 3              | 603.74    | Aktiivne |
| Väino Mägi        | Tallinn    | 3              | 602.40    | Aktiivne |
| Väino Tamm        | Paide      | 1              | 602.31    | Aktiivne |
| Karin Mägi        | Pärnu      | 2              | 601.46    | Aktiivne |
| Maie Rosin        | Tartu      | 5              | 600.80    | Aktiivne |
| Peeter Järv       | Viljandi   | 5              | 600.33    | Aktiivne |
| Siim Kask         | Tartu      | 2              | 599.86    | Aktiivne |
| Meelis Paas       | Valga      | 2              | 599.82    | Aktiivne |
| Sirje Valk        | Tallinn    | 4              | 599.65    | Aktiivne |
| Rein Sild         | Haapsalu   | 2              | 598.43    | Aktiivne |
| Riina Järv        | Narva      | 1              | 594.87    | Aktiivne |
| Sandra Mägi       | Tallinn    | 2              | 593.99    | Aktiivne |
| Ene Saar          | Narva      | 1              | 593.16    | Aktiivne |
| Liis Liiv         | Tallinn    | 1              | 592.80    | Aktiivne |
| Hille Mägi        | Tallinn    | 2              | 592.39    | Aktiivne |
| Heino Nõmm        | Tallinn    | 4              | 591.85    | Aktiivne |
| Tiina Toom        | Paide      | 3              | 591.24    | Aktiivne |
| Ago Järv          | Tartu      | 2              | 591.19    | Aktiivne |
| Kalev Lill        | Tallinn    | 2              | 590.73    | Aktiivne |
| Karin Kivi        | Valga      | 1              | 590.73    | Aktiivne |
| Jüri Org          | Rakvere    | 2              | 590.70    | Aktiivne |
| Henri Puusepp     | Tartu      | 2              | 588.85    | Aktiivne |
| Urmas Mägi        | Pärnu      | 2              | 588.63    | Aktiivne |
| Tiina Talvik      | Pärnu      | 2              | 588.61    | Aktiivne |
| Elis Liiv         | Narva      | 2              | 588.18    | Aktiivne |
| Rain Laas         | Tallinn    | 2              | 585.72    | Aktiivne |
| Ene Lass          | Tartu      | 2              | 585.43    | Aktiivne |
| Margus Mets       | Rakvere    | 1              | 585.22    | Aktiivne |
| Väino Tammik      | Tartu      | 3              | 584.85    | Aktiivne |
| Väino Hurt        | Tartu      | 2              | 584.06    | Aktiivne |
| Tiina Toom        | Võru       | 3              | 583.78    | Aktiivne |
| Reet Kivi         | Tallinn    | 1              | 583.71    | Aktiivne |
| Enn Kuusk         | Tallinn    | 1              | 583.44    | Aktiivne |
| Aili Org          | Tallinn    | 1              | 583.44    | Aktiivne |
| Peeter Puusepp    | Tartu      | 1              | 583.44    | Aktiivne |
| Olev Kangur       | Valga      | 3              | 583.40    | Aktiivne |
| Ago Koppel        | Tallinn    | 2              | 582.76    | Aktiivne |
| Siim Arro         | Tallinn    | 4              | 582.55    | Aktiivne |
| Heino Tammik      | Tallinn    | 3              | 581.88    | Aktiivne |
| Enn Org           | Tallinn    | 2              | 581.70    | Aktiivne |
| Piret Lõoke       | Kuressaare | 3              | 581.54    | Aktiivne |
| Aivar Teder       | Tallinn    | 2              | 581.20    | Aktiivne |
| Siim Lõoke        | Tartu      | 1              | 581.10    | Aktiivne |
| Maie Veski        | Tartu      | 3              | 579.91    | Aktiivne |
| Eha Järv          | Tallinn    | 2              | 579.80    | Aktiivne |
| Ene Tamm          | Tallinn    | 5              | 578.70    | Aktiivne |
| Priit Kõiv        | Haapsalu   | 3              | 577.87    | Aktiivne |
| Marika Aas        | Viljandi   | 3              | 577.83    | Aktiivne |
| Nele Rebane       | Tallinn    | 3              | 577.66    | Aktiivne |
| Külli Koppel      | Võru       | 4              | 577.39    | Aktiivne |
| Marit Puusepp     | Tartu      | 4              | 575.24    | Aktiivne |
| Maie Oja          | Valga      | 1              | 574.44    | Aktiivne |
| Maris Lepp        | Võru       | 1              | 574.44    | Aktiivne |
| Heino Luik        | Narva      | 2              | 574.12    | Aktiivne |
| Kalev Järv        | Tartu      | 3              | 573.73    | Aktiivne |
| Peeter Rebane     | Tartu      | 1              | 573.68    | Aktiivne |
| Grete Arro        | Pärnu      | 4              | 573.15    | Aktiivne |
| Henri Mitt        | Tartu      | 4              | 572.59    | Aktiivne |
| Ragnar Lõoke      | Tallinn    | 4              | 572.10    | Aktiivne |
| Sigrid Põld       | Tartu      | 2              | 571.48    | Aktiivne |
| Triin Valk        | Rakvere    | 2              | 571.41    | Aktiivne |
| Väino Rebane      | Tartu      | 3              | 569.36    | Aktiivne |
| Ants Orav         | Tartu      | 3              | 569.29    | Aktiivne |
| Anu Kivi          | Valga      | 3              | 568.51    | Aktiivne |
| Terje Teder       | Tallinn    | 2              | 568.46    | Aktiivne |
| Rein Kallas       | Jõhvi      | 1              | 566.48    | Aktiivne |
| Anna Pihl         | Tartu      | 1              | 566.48    | Aktiivne |
| Rein Kallas       | Jõhvi      | 2              | 565.53    | Aktiivne |
| Arvo Ilves        | Viljandi   | 1              | 564.58    | Aktiivne |
| Toomas Vaher      | Tallinn    | 3              | 564.29    | Aktiivne |
| Nele Teder        | Pärnu      | 2              | 563.99    | Aktiivne |
| Liina Veski       | Paide      | 2              | 563.80    | Aktiivne |
| Andres Paas       | Tallinn    | 3              | 562.58    | Aktiivne |
| Andres Rebane     | Haapsalu   | 2              | 562.43    | Aktiivne |
| Madis Rosin       | Võru       | 1              | 562.38    | Aktiivne |
| Maie Arro         | Narva      | 2              | 562.20    | Aktiivne |
| Rain Kaalep       | Tallinn    | 2              | 561.77    | Aktiivne |
| Jaak Sild         | Tallinn    | 2              | 561.69    | Aktiivne |
| Andres Oja        | Tallinn    | 3              | 561.19    | Aktiivne |
| Aili Teder        | Tallinn    | 1              | 560.31    | Aktiivne |
| Ülle Kuusk        | Narva      | 1              | 560.04    | Aktiivne |
| Hille Kuusk       | Narva      | 2              | 559.08    | Aktiivne |
| Tiina Tamm        | Viljandi   | 2              | 559.00    | Aktiivne |
| Priit Roots       | Tallinn    | 4              | 557.84    | Aktiivne |
| Andres Kuusik     | Tallinn    | 2              | 557.38    | Aktiivne |
| Liis Kuusik       | Tallinn    | 3              | 556.95    | Aktiivne |
| Liina Liiv        | Tallinn    | 3              | 556.67    | Aktiivne |
| Ene Lill          | Pärnu      | 3              | 556.09    | Aktiivne |
| Indrek Aas        | Tartu      | 3              | 555.75    | Aktiivne |
| Maris Luik        | Viljandi   | 2              | 555.01    | Aktiivne |
| Kevin Koppel      | Tallinn    | 3              | 554.21    | Aktiivne |
| Ragnar Kõiv       | Valga      | 2              | 553.85    | Aktiivne |
| Ragnar Kuusik     | Tallinn    | 3              | 553.72    | Aktiivne |
| Kadri Mitt        | Jõhvi      | 2              | 553.04    | Aktiivne |
| Raivo Kuusk       | Tallinn    | 4              | 552.89    | Aktiivne |
| Margus Lõoke      | Jõhvi      | 1              | 552.40    | Aktiivne |
| Taavi Kangur      | Rakvere    | 1              | 552.40    | Aktiivne |
| Maie Kaalep       | Pärnu      | 1              | 552.40    | Aktiivne |
| Heli Rebane       | Tallinn    | 6              | 551.07    | Aktiivne |
| Andres Rand       | Tartu      | 1              | 550.20    | Aktiivne |
| Sigrid Sild       | Tallinn    | 2              | 549.02    | Aktiivne |
| Arvo Lass         | Tallinn    | 3              | 548.84    | Aktiivne |
| Arvo Paju         | Võru       | 4              | 548.43    | Aktiivne |
| Jüri Lill         | Valga      | 2              | 547.36    | Aktiivne |
| Maris Kuusik      | Rakvere    | 2              | 546.62    | Aktiivne |
| Terje Arro        | Pärnu      | 5              | 544.51    | Aktiivne |
| Ago Rand          | Pärnu      | 2              | 543.76    | Aktiivne |
| Sandra Lill       | Tallinn    | 3              | 543.00    | Aktiivne |
| Ants Lass         | Võru       | 4              | 542.88    | Aktiivne |
| Urmas Nõmm        | Tallinn    | 1              | 542.70    | Aktiivne |
| Kaido Liiv        | Tartu      | 1              | 541.98    | Aktiivne |
| Heino Tammik      | Tallinn    | 2              | 541.34    | Aktiivne |
| Rein Järv         | Tallinn    | 2              | 541.07    | Aktiivne |
| Sigrid Veski      | Tallinn    | 2              | 540.66    | Aktiivne |
| Margus Mitt       | Pärnu      | 4              | 540.62    | Aktiivne |
| Taavi Oja         | Tartu      | 4              | 539.24    | Aktiivne |
| Margus Kõiv       | Tartu      | 2              | 539.19    | Aktiivne |
| Karin Paas        | Tallinn    | 4              | 536.90    | Aktiivne |
| Grete Ilves       | Narva      | 5              | 536.73    | Aktiivne |
| Arvo Paas         | Rakvere    | 4              | 536.40    | Aktiivne |
| Nele Orav         | Tallinn    | 1              | 536.30    | Aktiivne |
| Terje Luik        | Tartu      | 3              | 535.86    | Aktiivne |
| Triin Nurk        | Tallinn    | 4              | 535.61    | Aktiivne |
| Indrek Kuusk      | Paide      | 2              | 535.48    | Aktiivne |
| Aivar Kuusik      | Tallinn    | 2              | 535.47    | Aktiivne |
| Kadri Koppel      | Tallinn    | 4              | 535.01    | Aktiivne |
| Terje Nurk        | Tartu      | 2              | 534.54    | Aktiivne |
| Margus Tammik     | Pärnu      | 2              | 534.32    | Aktiivne |
| Karin Org         | Tallinn    | 2              | 534.09    | Aktiivne |
| Grete Koppel      | Kuressaare | 2              | 534.03    | Aktiivne |
| Madis Sild        | Haapsalu   | 3              | 532.15    | Aktiivne |
| Raivo Raid        | Jõhvi      | 2              | 532.05    | Aktiivne |
| Enn Liiv          | Tallinn    | 2              | 532.04    | Aktiivne |
| Külli Mägi        | Tallinn    | 2              | 531.77    | Aktiivne |
| Kevin Paas        | Tallinn    | 4              | 531.27    | Aktiivne |
| Ago Lõoke         | Pärnu      | 1              | 531.05    | Aktiivne |
| Terje Rebane      | Tallinn    | 2              | 530.69    | Aktiivne |
| Liina Kukk        | Tallinn    | 3              | 530.46    | Aktiivne |
| Maie Lõhmus       | Viljandi   | 3              | 530.40    | Aktiivne |
| Ragnar Org        | Tartu      | 1              | 529.95    | Aktiivne |
| Kalev Põld        | Tallinn    | 3              | 529.61    | Aktiivne |
| Katrin Laas       | Pärnu      | 5              | 528.28    | Aktiivne |
| Ago Kukk          | Tartu      | 3              | 527.48    | Aktiivne |
| Marko Tamm        | Paide      | 3              | 527.05    | Aktiivne |
| Taavi Liiv        | Valga      | 2              | 524.57    | Aktiivne |
| Tõnu Kõiv         | Tartu      | 2              | 524.37    | Aktiivne |
| Kersti Mets       | Tallinn    | 3              | 523.79    | Aktiivne |
| Eha Paju          | Tallinn    | 3              | 523.21    | Aktiivne |
| Ragnar Luik       | Tallinn    | 4              | 523.21    | Aktiivne |
| Annika Luik       | Tallinn    | 2              | 522.52    | Aktiivne |
| Kadri Tammik      | Viljandi   | 3              | 522.51    | Aktiivne |
| Ülle Liiv         | Tallinn    | 2              | 522.22    | Aktiivne |
| Ülle Tamm         | Tallinn    | 1              | 520.86    | Aktiivne |
| Kristi Rebane     | Võru       | 2              | 520.61    | Aktiivne |
| Kristiina Lill    | Pärnu      | 3              | 520.16    | Aktiivne |
| Margus Kivi       | Haapsalu   | 1              | 519.38    | Aktiivne |
| Toomas Kangur     | Pärnu      | 2              | 518.63    | Aktiivne |
| Sander Nõmm       | Tallinn    | 2              | 518.50    | Aktiivne |
| Ants Põld         | Pärnu      | 3              | 518.44    | Aktiivne |
| Jaak Rosin        | Tartu      | 2              | 517.66    | Aktiivne |
| Madis Puusepp     | Tallinn    | 3              | 516.60    | Aktiivne |
| Triin Kaalep      | Rakvere    | 3              | 515.64    | Aktiivne |
| Mihkel Tamm       | Tallinn    | 3              | 515.59    | Aktiivne |
| Lea Raid          | Paide      | 2              | 515.08    | Aktiivne |
| Marko Arro        | Tallinn    | 2              | 513.08    | Aktiivne |
| Annika Mägi       | Tartu      | 3              | 512.77    | Aktiivne |
| Hille Rosin       | Pärnu      | 5              | 512.59    | Aktiivne |
| Meelis Oja        | Tallinn    | 2              | 511.63    | Aktiivne |
| Elis Toom         | Pärnu      | 3              | 511.55    | Aktiivne |
| Henri Valk        | Tartu      | 1              | 509.85    | Aktiivne |
| Väino Kallas      | Tartu      | 3              | 509.42    | Aktiivne |
| Kristiina Kuusk   | Tallinn    | 2              | 508.98    | Aktiivne |
| Arvo Orav         | Pärnu      | 3              | 506.56    | Aktiivne |
| Kristi Valk       | Tallinn    | 2              | 506.50    | Aktiivne |
| Priit Paas        | Tartu      | 3              | 505.89    | Aktiivne |
| Mart Lepik        | Narva      | 1              | 505.02    | Aktiivne |
| Merike Must       | Tallinn    | 2              | 504.93    | Aktiivne |
| Kristi Mets       | Pärnu      | 3              | 504.03    | Aktiivne |
| Aili Lill         | Rakvere    | 2              | 503.48    | Aktiivne |
| Grete Rand        | Tallinn    | 1              | 503.04    | Aktiivne |
| Maie Tamm         | Tallinn    | 1              | 501.69    | Aktiivne |
| Ragnar Rosin      | Tallinn    | 1              | 501.69    | Aktiivne |
| Andres Nurk       | Tallinn    | 3              | 501.31    | Aktiivne |
| Olev Teder        | Tallinn    | 4              | 501.06    | Aktiivne |
| Merike Kask       | Tallinn    | 4              | 501.04    | Aktiivne |
| Tiit Värk         | Tartu      | 2              | 500.26    | Aktiivne |
| Ene Pärn          | Tallinn    | 2              | 499.88    | Aktiivne |
| Tiina Pihl        | Paide      | 2              | 498.87    | Aktiivne |
| Olev Kask         | Tallinn    | 3              | 498.46    | Aktiivne |
| Indrek Arro       | Tallinn    | 3              | 497.29    | Aktiivne |
| Tiina Saar        | Tallinn    | 3              | 496.83    | Aktiivne |
| Tarmo Kull        | Võru       | 2              | 496.80    | Aktiivne |
| Anu Kallas        | Tallinn    | 3              | 496.20    | Aktiivne |
| Aivar Rebane      | Tartu      | 1              | 495.28    | Aktiivne |
| Grete Paas        | Tallinn    | 4              | 495.07    | Aktiivne |
| Ragnar Järv       | Haapsalu   | 2              | 494.84    | Aktiivne |
| Liina Lass        | Tallinn    | 2              | 494.82    | Aktiivne |
| Rain Salu         | Jõhvi      | 2              | 494.63    | Aktiivne |
| Piret Tammik      | Tartu      | 1              | 493.94    | Aktiivne |
| Terje Salu        | Tallinn    | 5              | 493.79    | Aktiivne |
| Tarmo Põld        | Tartu      | 5              | 493.20    | Aktiivne |
| Henri Toom        | Tartu      | 3              | 492.92    | Aktiivne |
| Arvo Vaher        | Valga      | 3              | 492.55    | Aktiivne |
| Marko Raud        | Tallinn    | 3              | 491.92    | Aktiivne |
| Triin Mitt        | Valga      | 3              | 490.39    | Aktiivne |
| Riina Kask        | Tallinn    | 2              | 490.16    | Aktiivne |
| Liina Tamm        | Tallinn    | 3              | 490.09    | Aktiivne |
| Laura Ilves       | Tartu      | 4              | 489.48    | Aktiivne |
| Kalev Nurk        | Pärnu      | 4              | 489.33    | Aktiivne |
| Kristi Hurt       | Tartu      | 3              | 487.25    | Aktiivne |
| Toomas Mets       | Viljandi   | 1              | 486.04    | Aktiivne |
| Ants Talvik       | Tallinn    | 3              | 485.98    | Aktiivne |
| Riina Rand        | Paide      | 3              | 485.12    | Aktiivne |
| Lauri Raid        | Tallinn    | 3              | 484.22    | Aktiivne |
| Raivo Lõoke       | Tartu      | 2              | 484.12    | Aktiivne |
| Kaido Aas         | Kuressaare | 2              | 482.93    | Aktiivne |
| Katrin Kuusk      | Tartu      | 1              | 482.26    | Aktiivne |
| Sigrid Kõiv       | Tallinn    | 1              | 482.26    | Aktiivne |
| Henri Veski       | Tallinn    | 2              | 481.91    | Aktiivne |
| Peeter Orav       | Rakvere    | 4              | 480.93    | Aktiivne |
| Elis Lepp         | Paide      | 3              | 480.00    | Aktiivne |
| Sander Rosin      | Tallinn    | 2              | 479.31    | Aktiivne |
| Laura Paas        | Tartu      | 2              | 478.47    | Aktiivne |
| Karin Mägi        | Jõhvi      | 3              | 478.31    | Aktiivne |
| Rasmus Männik     | Tallinn    | 3              | 478.03    | Aktiivne |
| Terje Vaher       | Tallinn    | 5              | 477.39    | Aktiivne |
| Kristiina Talvik  | Kuressaare | 2              | 475.54    | Aktiivne |
| Urmas Kivi        | Tallinn    | 2              | 475.27    | Aktiivne |
| Meelis Ilves      | Tartu      | 3              | 475.26    | Aktiivne |
| Anu Liiv          | Tallinn    | 3              | 474.64    | Aktiivne |
| Kati Mägi         | Viljandi   | 2              | 474.25    | Aktiivne |
| Maie Sepp         | Tallinn    | 2              | 473.74    | Aktiivne |
| Henri Pärn        | Tallinn    | 2              | 473.52    | Aktiivne |
| Urmas Pärn        | Võru       | 3              | 473.48    | Aktiivne |
| Pille Kallas      | Tartu      | 2              | 473.28    | Aktiivne |
| Liis Koppel       | Pärnu      | 2              | 472.33    | Aktiivne |
| Nele Lõoke        | Tartu      | 2              | 471.84    | Aktiivne |
| Väino Kuusik      | Rakvere    | 2              | 471.65    | Aktiivne |
| Jaak Veski        | Valga      | 3              | 471.63    | Aktiivne |
| Jüri Lepik        | Võru       | 3              | 470.30    | Aktiivne |
| Grete Kallas      | Tallinn    | 5              | 468.42    | Aktiivne |
| Siim Kask         | Valga      | 4              | 468.20    | Aktiivne |
| Madis Raid        | Jõhvi      | 2              | 468.06    | Aktiivne |
| Marit Ilves       | Tallinn    | 3              | 465.48    | Aktiivne |
| Meelis Põld       | Pärnu      | 3              | 464.66    | Aktiivne |
| Priit Valk        | Tartu      | 3              | 464.16    | Aktiivne |
| Laura Kull        | Tallinn    | 2              | 464.01    | Aktiivne |
| Nele Rebane       | Tallinn    | 2              | 463.69    | Aktiivne |
| Marit Lill        | Kuressaare | 4              | 463.04    | Aktiivne |
| Elis Laas         | Tallinn    | 3              | 462.85    | Aktiivne |
| Tõnu Sepp         | Narva      | 2              | 462.79    | Aktiivne |
| Kristjan Puusepp  | Tallinn    | 2              | 462.10    | Aktiivne |
| Margus Hurt       | Tallinn    | 3              | 461.24    | Aktiivne |
| Tarmo Puusepp     | Pärnu      | 2              | 459.89    | Aktiivne |
| Kadri Värk        | Tallinn    | 1              | 459.76    | Aktiivne |
| Ants Kask         | Tallinn    | 3              | 459.60    | Aktiivne |
| Peeter Paju       | Tallinn    | 3              | 458.67    | Aktiivne |
| Ülle Nõmm         | Viljandi   | 2              | 458.60    | Aktiivne |
| Tõnu Nõmm         | Narva      | 2              | 458.26    | Aktiivne |
| Ülle Põld         | Tallinn    | 1              | 458.02    | Aktiivne |
| Liina Lepp        | Pärnu      | 3              | 453.54    | Aktiivne |
| Kristi Mets       | Võru       | 3              | 453.27    | Aktiivne |
| Annika Aas        | Tallinn    | 2              | 452.13    | Aktiivne |
| Ants Kangur       | Tallinn    | 2              | 451.82    | Aktiivne |
| Henri Salu        | Tartu      | 1              | 451.62    | Aktiivne |
| Taavi Teder       | Paide      | 2              | 450.69    | Aktiivne |
| Siim Mitt         | Tallinn    | 3              | 450.56    | Aktiivne |
| Grete Org         | Tallinn    | 3              | 449.93    | Aktiivne |
| Jüri Must         | Pärnu      | 4              | 449.86    | Aktiivne |
| Aili Kull         | Tallinn    | 2              | 448.54    | Aktiivne |
| Tõnu Kull         | Rakvere    | 2              | 447.66    | Aktiivne |
| Madis Lepp        | Tallinn    | 3              | 447.08    | Aktiivne |
| Tõnu Valk         | Pärnu      | 1              | 446.95    | Aktiivne |
| Katrin Arro       | Tartu      | 3              | 446.72    | Aktiivne |
| Rasmus Värk       | Tartu      | 2              | 446.72    | Aktiivne |
| Aili Pihl         | Narva      | 5              | 446.27    | Aktiivne |
| Eha Saar          | Viljandi   | 1              | 444.20    | Aktiivne |
| Priit Lass        | Tallinn    | 4              | 444.17    | Aktiivne |
| Enn Mägi          | Pärnu      | 3              | 443.95    | Aktiivne |
| Kati Rosin        | Pärnu      | 1              | 443.78    | Aktiivne |
| Nele Oja          | Pärnu      | 1              | 443.76    | Aktiivne |
| Aili Raud         | Tallinn    | 3              | 443.51    | Aktiivne |
| Marko Paju        | Tartu      | 2              | 443.45    | Aktiivne |
| Henri Pihl        | Tallinn    | 2              | 443.11    | Aktiivne |
| Kalev Oja         | Paide      | 3              | 442.42    | Aktiivne |
| Heli Orav         | Haapsalu   | 1              | 442.12    | Aktiivne |
| Siim Paas         | Tallinn    | 2              | 441.73    | Aktiivne |
| Taavi Vaher       | Tallinn    | 2              | 441.27    | Aktiivne |
| Hille Kukk        | Tartu      | 3              | 440.43    | Aktiivne |
| Pille Paas        | Tartu      | 1              | 439.66    | Aktiivne |
| Kaido Kukk        | Haapsalu   | 2              | 438.65    | Aktiivne |
| Toomas Paas       | Pärnu      | 2              | 438.38    | Aktiivne |
| Tiina Kõiv        | Kuressaare | 1              | 437.98    | Aktiivne |
| Madis Tammik      | Valga      | 1              | 437.98    | Aktiivne |
| Mihkel Saar       | Tallinn    | 1              | 437.68    | Aktiivne |
| Kristi Must       | Tartu      | 4              | 437.58    | Aktiivne |
| Pille Mets        | Narva      | 2              | 437.29    | Aktiivne |
| Heino Lõoke       | Võru       | 1              | 437.16    | Aktiivne |
| Aili Kangur       | Tallinn    | 2              | 436.15    | Aktiivne |
| Anu Lepp          | Narva      | 1              | 434.08    | Aktiivne |
| Rasmus Toom       | Tartu      | 5              | 433.04    | Aktiivne |
| Kalev Orav        | Tallinn    | 1              | 432.36    | Aktiivne |
| Hille Luik        | Pärnu      | 2              | 431.54    | Aktiivne |
| Kalev Raud        | Tallinn    | 1              | 431.16    | Aktiivne |
| Enn Kuusk         | Kuressaare | 1              | 430.26    | Aktiivne |
| Tarmo Kask        | Tallinn    | 2              | 429.89    | Aktiivne |
| Anna Luik         | Tartu      | 2              | 429.15    | Aktiivne |
| Kristiina Kuusk   | Tallinn    | 2              | 428.57    | Aktiivne |
| Heino Talvik      | Tartu      | 2              | 427.71    | Aktiivne |
| Grete Salu        | Tallinn    | 2              | 427.51    | Aktiivne |
| Raivo Org         | Narva      | 2              | 426.44    | Aktiivne |
| Indrek Pihl       | Valga      | 3              | 425.91    | Aktiivne |
| Grete Raud        | Pärnu      | 3              | 423.51    | Aktiivne |
| Anu Nurk          | Tartu      | 2              | 422.51    | Aktiivne |
| Liis Kuusik       | Tallinn    | 4              | 422.30    | Aktiivne |
| Ants Liiv         | Tallinn    | 4              | 421.73    | Aktiivne |
| Marko Roots       | Narva      | 1              | 421.52    | Aktiivne |
| Laura Kangur      | Tallinn    | 2              | 421.18    | Aktiivne |
| Indrek Värk       | Tallinn    | 1              | 420.72    | Aktiivne |
| Sander Mägi       | Paide      | 1              | 420.72    | Aktiivne |
| Marko Kuusk       | Tallinn    | 3              | 420.61    | Aktiivne |
| Anu Kuusk         | Paide      | 2              | 420.52    | Aktiivne |
| Ene Saar          | Tallinn    | 2              | 420.34    | Aktiivne |
| Lauri Aas         | Tallinn    | 3              | 419.37    | Aktiivne |
| Kristiina Lill    | Tallinn    | 2              | 418.10    | Aktiivne |
| Rasmus Aas        | Tartu      | 1              | 418.10    | Aktiivne |
| Madis Lepik       | Tallinn    | 2              | 417.82    | Aktiivne |
| Maris Teder       | Tartu      | 2              | 417.69    | Aktiivne |
| Siim Vaher        | Tartu      | 1              | 417.66    | Aktiivne |
| Taavi Põld        | Narva      | 3              | 417.49    | Aktiivne |
| Grete Mets        | Tartu      | 3              | 417.47    | Aktiivne |
| Marit Mägi        | Tallinn    | 1              | 417.44    | Aktiivne |
| Marika Tamm       | Tallinn    | 3              | 416.74    | Aktiivne |
| Kristiina Oja     | Tallinn    | 1              | 416.70    | Aktiivne |
| Piret Nõmm        | Tallinn    | 2              | 416.48    | Aktiivne |
| Kristiina Pärn    | Tartu      | 2              | 415.28    | Aktiivne |
| Siim Liiv         | Tallinn    | 3              | 415.17    | Aktiivne |
| Sigrid Teder      | Tallinn    | 3              | 414.25    | Aktiivne |
| Triin Rosin       | Narva      | 1              | 411.78    | Aktiivne |
| Madis Lass        | Rakvere    | 1              | 411.78    | Aktiivne |
| Katrin Kaalep     | Narva      | 2              | 411.47    | Aktiivne |
| Urmas Värk        | Tartu      | 3              | 411.44    | Aktiivne |
| Ülle Koppel       | Pärnu      | 2              | 410.38    | Aktiivne |
| Lauri Kukk        | Pärnu      | 2              | 410.20    | Aktiivne |
| Ago Luik          | Narva      | 2              | 410.10    | Aktiivne |
| Aili Mets         | Tallinn    | 1              | 410.00    | Aktiivne |
| Kaido Mitt        | Rakvere    | 3              | 409.75    | Aktiivne |
| Ants Mets         | Tartu      | 1              | 408.90    | Aktiivne |
| Peeter Veski      | Tartu      | 3              | 408.32    | Aktiivne |
| Laura Rebane      | Jõhvi      | 3              | 408.00    | Aktiivne |
| Marko Liiv        | Jõhvi      | 4              | 407.75    | Aktiivne |
| Siim Toom         | Tallinn    | 2              | 407.64    | Aktiivne |
| Sandra Oja        | Pärnu      | 1              | 407.40    | Aktiivne |
| Sandra Aas        | Tallinn    | 3              | 407.13    | Aktiivne |
| Sander Rosin      | Tartu      | 3              | 407.07    | Aktiivne |
| Priit Saar        | Narva      | 2              | 406.26    | Aktiivne |
| Enn Kangur        | Tartu      | 2              | 405.96    | Aktiivne |
| Riina Veski       | Tartu      | 2              | 405.96    | Aktiivne |
| Eha Aas           | Narva      | 3              | 405.76    | Aktiivne |
| Aivar Kivi        | Narva      | 2              | 405.62    | Aktiivne |
| Grete Arro        | Tallinn    | 1              | 405.14    | Aktiivne |
| Kristi Talvik     | Tartu      | 4              | 405.04    | Aktiivne |
| Ene Pihl          | Tartu      | 1              | 405.04    | Aktiivne |
| Ragnar Pärn       | Tallinn    | 3              | 404.83    | Aktiivne |
| Merle Saar        | Pärnu      | 2              | 404.39    | Aktiivne |
| Priit Kull        | Tallinn    | 2              | 403.77    | Aktiivne |
| Liina Sepp        | Tallinn    | 1              | 402.62    | Aktiivne |
| Jüri Kuusk        | Pärnu      | 1              | 401.60    | Aktiivne |
| Kevin Roots       | Viljandi   | 2              | 399.36    | Aktiivne |
| Peeter Hurt       | Tallinn    | 2              | 398.87    | Aktiivne |
| Maie Roots        | Pärnu      | 2              | 397.71    | Aktiivne |
| Kevin Lõhmus      | Tallinn    | 3              | 397.55    | Aktiivne |
| Terje Rosin       | Tallinn    | 2              | 397.38    | Aktiivne |
| Mart Paju         | Tallinn    | 2              | 397.30    | Aktiivne |
| Kaido Laas        | Tartu      | 3              | 396.05    | Aktiivne |
| Laura Mets        | Tallinn    | 3              | 394.86    | Aktiivne |
| Marika Raid       | Pärnu      | 3              | 394.81    | Aktiivne |
| Meelis Rand       | Pärnu      | 2              | 394.61    | Aktiivne |
| Enn Ilves         | Tallinn    | 2              | 394.03    | Aktiivne |
| Urmas Järv        | Võru       | 2              | 393.52    | Aktiivne |
| Pille Lõoke       | Tallinn    | 2              | 392.32    | Aktiivne |
| Heino Kuusk       | Kuressaare | 2              | 390.94    | Aktiivne |
| Urmas Teder       | Kuressaare | 2              | 390.78    | Aktiivne |
| Marko Rand        | Tallinn    | 4              | 390.59    | Aktiivne |
| Sander Oja        | Jõhvi      | 2              | 389.56    | Aktiivne |
| Hille Lill        | Tallinn    | 1              | 388.92    | Aktiivne |
| Külli Lõhmus      | Tallinn    | 1              | 388.92    | Aktiivne |
| Kaido Pärn        | Pärnu      | 2              | 388.53    | Aktiivne |
| Terje Pärn        | Tartu      | 2              | 388.42    | Aktiivne |
| Margus Luik       | Tallinn    | 2              | 387.83    | Aktiivne |
| Triin Lill        | Viljandi   | 2              | 387.70    | Aktiivne |
| Ragnar Pärn       | Võru       | 2              | 386.68    | Aktiivne |
| Lauri Kukk        | Tallinn    | 2              | 386.51    | Aktiivne |
| Arvo Kaalep       | Tallinn    | 1              | 385.32    | Aktiivne |
| Tõnu Kaalep       | Tartu      | 2              | 385.16    | Aktiivne |
| Sander Org        | Haapsalu   | 1              | 385.11    | Aktiivne |
| Riina Pärn        | Pärnu      | 2              | 383.87    | Aktiivne |
| Kristjan Rand     | Kuressaare | 3              | 382.69    | Aktiivne |
| Riina Rebane      | Tallinn    | 3              | 382.18    | Aktiivne |
| Kristiina Veski   | Tallinn    | 2              | 382.02    | Aktiivne |
| Merle Mets        | Jõhvi      | 2              | 381.60    | Aktiivne |
| Tõnu Mitt         | Tallinn    | 2              | 380.61    | Aktiivne |
| Kristi Pihl       | Tartu      | 2              | 379.75    | Aktiivne |
| Taavi Hurt        | Tartu      | 1              | 377.82    | Aktiivne |
| Aivar Luik        | Võru       | 2              | 377.45    | Aktiivne |
| Andres Valk       | Tallinn    | 2              | 376.41    | Aktiivne |
| Mart Nõmm         | Tallinn    | 3              | 374.73    | Aktiivne |
| Margus Kukk       | Tallinn    | 3              | 374.72    | Aktiivne |
| Lea Hurt          | Tallinn    | 3              | 374.60    | Aktiivne |
| Külli Rebane      | Tallinn    | 2              | 374.43    | Aktiivne |
| Anu Liiv          | Valga      | 4              | 374.34    | Aktiivne |
| Kati Rosin        | Kuressaare | 1              | 374.32    | Aktiivne |
| Maie Kuusk        | Narva      | 1              | 374.32    | Aktiivne |
| Margus Puusepp    | Rakvere    | 3              | 373.79    | Aktiivne |
| Margus Roots      | Pärnu      | 2              | 373.44    | Aktiivne |
| Kalev Kukk        | Tallinn    | 3              | 373.31    | Aktiivne |
| Indrek Sepp       | Tallinn    | 2              | 372.80    | Aktiivne |
| Kalev Valk        | Jõhvi      | 2              | 372.23    | Aktiivne |
| Toomas Kivi       | Pärnu      | 2              | 371.47    | Aktiivne |
| Kristiina Roots   | Tallinn    | 1              | 371.05    | Aktiivne |
| Aivar Koppel      | Tallinn    | 2              | 370.93    | Aktiivne |
| Ülle Paju         | Rakvere    | 2              | 369.31    | Aktiivne |
| Lea Kukk          | Tallinn    | 2              | 369.30    | Aktiivne |
| Mihkel Toom       | Võru       | 2              | 369.03    | Aktiivne |
| Kevin Pärn        | Tallinn    | 2              | 368.82    | Aktiivne |
| Kevin Koppel      | Haapsalu   | 2              | 368.75    | Aktiivne |
| Liis Lepp         | Tallinn    | 3              | 368.20    | Aktiivne |
| Terje Laas        | Rakvere    | 1              | 368.14    | Aktiivne |
| Tõnu Koppel       | Rakvere    | 1              | 368.14    | Aktiivne |
| Margus Raud       | Narva      | 2              | 366.84    | Aktiivne |
| Aili Lõoke        | Narva      | 1              | 366.62    | Aktiivne |
| Eha Puusepp       | Tallinn    | 2              | 366.61    | Aktiivne |
| Liina Kõiv        | Viljandi   | 3              | 366.59    | Aktiivne |
| Jaak Nõmm         | Tartu      | 2              | 366.51    | Aktiivne |
| Arvo Lass         | Pärnu      | 3              | 366.49    | Aktiivne |
| Hille Aas         | Võru       | 3              | 366.47    | Aktiivne |
| Piret Talvik      | Tallinn    | 2              | 366.05    | Aktiivne |
| Katrin Nurk       | Tartu      | 2              | 365.19    | Aktiivne |
| Grete Koppel      | Tallinn    | 3              | 364.41    | Aktiivne |
| Kaido Mitt        | Tallinn    | 2              | 364.24    | Aktiivne |
| Elis Oja          | Pärnu      | 2              | 364.20    | Aktiivne |
| Mart Rebane       | Tallinn    | 2              | 363.28    | Aktiivne |
| Erkki Rand        | Tallinn    | 2              | 362.97    | Aktiivne |
| Madis Paas        | Tallinn    | 4              | 362.22    | Aktiivne |
| Reet Rosin        | Tallinn    | 1              | 361.77    | Aktiivne |
| Kevin Kaalep      | Tartu      | 2              | 361.25    | Aktiivne |
| Priit Veski       | Tartu      | 1              | 360.28    | Aktiivne |
| Katrin Kukk       | Tartu      | 2              | 359.78    | Aktiivne |
| Kati Tamm         | Tallinn    | 2              | 358.16    | Aktiivne |
| Anna Põld         | Tartu      | 1              | 356.57    | Aktiivne |
| Marika Kuusk      | Tallinn    | 2              | 355.21    | Aktiivne |
| Lea Mets          | Tartu      | 2              | 354.71    | Aktiivne |
| Tarmo Tammik      | Tallinn    | 2              | 352.50    | Aktiivne |
| Lauri Paju        | Valga      | 2              | 351.95    | Aktiivne |
| Reet Rand         | Pärnu      | 1              | 351.62    | Aktiivne |
| Terje Nurk        | Kuressaare | 1              | 351.62    | Aktiivne |
| Erkki Lill        | Tallinn    | 2              | 351.60    | Aktiivne |
| Tõnu Tammik       | Haapsalu   | 1              | 351.33    | Aktiivne |
| Margus Roots      | Tallinn    | 2              | 350.75    | Aktiivne |
| Aivar Mitt        | Tallinn    | 3              | 349.97    | Aktiivne |
| Sander Lass       | Tartu      | 2              | 349.34    | Aktiivne |
| Peeter Kukk       | Tartu      | 1              | 348.60    | Aktiivne |
| Taavi Pihl        | Tallinn    | 2              | 347.96    | Aktiivne |
| Triin Must        | Pärnu      | 1              | 347.84    | Aktiivne |
| Karin Koppel      | Tallinn    | 3              | 347.43    | Aktiivne |
| Peeter Kask       | Tartu      | 1              | 347.16    | Aktiivne |
| Riina Luik        | Pärnu      | 1              | 347.16    | Aktiivne |
| Tarmo Kukk        | Tartu      | 1              | 347.16    | Aktiivne |
| Karin Raud        | Tallinn    | 2              | 346.48    | Aktiivne |
| Tiit Arro         | Tartu      | 2              | 346.36    | Aktiivne |
| Kadri Salu        | Rakvere    | 3              | 346.07    | Aktiivne |
| Rain Lõhmus       | Valga      | 2              | 345.93    | Aktiivne |
| Mihkel Lõhmus     | Tallinn    | 2              | 345.79    | Aktiivne |
| Maris Kuusk       | Tartu      | 2              | 345.32    | Aktiivne |
| Grete Rosin       | Tartu      | 2              | 345.24    | Aktiivne |
| Priit Mitt        | Pärnu      | 2              | 345.10    | Aktiivne |
| Enn Kull          | Tallinn    | 2              | 344.72    | Aktiivne |
| Grete Raid        | Pärnu      | 2              | 342.68    | Aktiivne |
| Madis Paju        | Tallinn    | 3              | 342.48    | Aktiivne |
| Mihkel Org        | Pärnu      | 2              | 341.60    | Aktiivne |
| Triin Roots       | Jõhvi      | 5              | 341.45    | Aktiivne |
| Henri Pärn        | Tallinn    | 1              | 339.21    | Aktiivne |
| Tõnu Kaalep       | Narva      | 3              | 338.60    | Aktiivne |
| Piret Ilves       | Pärnu      | 1              | 338.04    | Aktiivne |
| Urmas Männik      | Tallinn    | 2              | 337.79    | Aktiivne |
| Terje Rebane      | Tallinn    | 1              | 337.64    | Aktiivne |
| Pille Rosin       | Tallinn    | 3              | 337.41    | Aktiivne |
| Elis Kallas       | Pärnu      | 3              | 334.75    | Aktiivne |
| Liina Mägi        | Tallinn    | 3              | 334.70    | Aktiivne |
| Karin Männik      | Tallinn    | 1              | 334.46    | Aktiivne |
| Riina Lõhmus      | Tallinn    | 2              | 334.30    | Aktiivne |
| Aili Rosin        | Tartu      | 2              | 333.19    | Aktiivne |
| Aili Lass         | Tallinn    | 2              | 332.77    | Aktiivne |
| Raivo Kuusk       | Tallinn    | 2              | 332.69    | Aktiivne |
| Jüri Liiv         | Kuressaare | 1              | 332.54    | Aktiivne |
| Meelis Mitt       | Viljandi   | 2              | 332.28    | Aktiivne |
| Aivar Toom        | Haapsalu   | 3              | 331.66    | Aktiivne |
| Külli Põld        | Tallinn    | 1              | 331.59    | Aktiivne |
| Katrin Arro       | Tartu      | 1              | 331.59    | Aktiivne |
| Indrek Lepik      | Narva      | 4              | 331.07    | Aktiivne |
| Kristiina Järv    | Tallinn    | 5              | 330.28    | Aktiivne |
| Rein Valk         | Kuressaare | 2              | 330.24    | Aktiivne |
| Kevin Kull        | Tartu      | 1              | 329.99    | Aktiivne |
| Kristjan Nurk     | Viljandi   | 2              | 329.28    | Aktiivne |
| Rain Männik       | Tallinn    | 1              | 328.86    | Aktiivne |
| Ants Rosin        | Narva      | 2              | 328.35    | Aktiivne |
| Väino Põld        | Jõhvi      | 1              | 327.28    | Aktiivne |
| Rein Mitt         | Narva      | 1              | 327.28    | Aktiivne |
| Meelis Männik     | Tallinn    | 1              | 327.07    | Aktiivne |
| Aili Must         | Pärnu      | 1              | 327.06    | Aktiivne |
| Ants Järv         | Tartu      | 1              | 327.06    | Aktiivne |
| Liis Arro         | Tallinn    | 4              | 326.55    | Aktiivne |
| Kevin Toom        | Tallinn    | 2              | 325.90    | Aktiivne |
| Taavi Värk        | Narva      | 2              | 325.42    | Aktiivne |
| Madis Arro        | Tallinn    | 2              | 325.13    | Aktiivne |
| Kadri Pihl        | Tallinn    | 3              | 324.40    | Aktiivne |
| Hille Mägi        | Tallinn    | 2              | 324.03    | Aktiivne |
| Eha Ilves         | Tartu      | 2              | 323.98    | Aktiivne |
| Madis Must        | Tallinn    | 2              | 322.68    | Aktiivne |
| Arvo Pihl         | Tallinn    | 1              | 321.42    | Aktiivne |
| Ragnar Männik     | Pärnu      | 1              | 318.63    | Aktiivne |
| Liina Must        | Tallinn    | 1              | 318.50    | Aktiivne |
| Peeter Rosin      | Tallinn    | 1              | 317.88    | Aktiivne |
| Karin Org         | Tallinn    | 2              | 317.53    | Aktiivne |
| Triin Järv        | Rakvere    | 3              | 316.79    | Aktiivne |
| Kristi Kull       | Tartu      | 2              | 316.69    | Aktiivne |
| Merike Paas       | Tallinn    | 3              | 316.42    | Aktiivne |
| Tiit Mets         | Tallinn    | 2              | 315.80    | Aktiivne |
| Olev Lõhmus       | Tallinn    | 2              | 315.49    | Aktiivne |
| Lea Salu          | Tallinn    | 3              | 315.49    | Aktiivne |
| Külli Lass        | Tartu      | 4              | 314.65    | Aktiivne |
| Liis Kuusik       | Tallinn    | 1              | 314.55    | Aktiivne |
| Priit Arro        | Tallinn    | 2              | 313.98    | Aktiivne |
| Liis Kuusk        | Valga      | 1              | 312.41    | Aktiivne |
| Kadri Kivi        | Tallinn    | 2              | 312.33    | Aktiivne |
| Laura Vaher       | Tartu      | 1              | 312.26    | Aktiivne |
| Anu Järv          | Tartu      | 6              | 311.82    | Aktiivne |
| Terje Kuusk       | Tallinn    | 1              | 311.68    | Aktiivne |
| Külli Raid        | Tartu      | 2              | 311.30    | Aktiivne |
| Mart Sild         | Pärnu      | 1              | 310.90    | Aktiivne |
| Erkki Arro        | Pärnu      | 1              | 310.90    | Aktiivne |
| Olev Orav         | Rakvere    | 2              | 309.48    | Aktiivne |
| Maris Kangur      | Tartu      | 2              | 309.34    | Aktiivne |
| Anna Kõiv         | Narva      | 4              | 308.45    | Aktiivne |
| Ragnar Tammik     | Tallinn    | 1              | 307.83    | Aktiivne |
| Erkki Pihl        | Tallinn    | 1              | 307.27    | Aktiivne |
| Grete Paju        | Tallinn    | 1              | 307.24    | Aktiivne |
| Kati Luik         | Tallinn    | 1              | 307.24    | Aktiivne |
| Rasmus Luik       | Pärnu      | 2              | 306.39    | Aktiivne |
| Jüri Rebane       | Viljandi   | 2              | 305.34    | Aktiivne |
| Riina Valk        | Tartu      | 2              | 304.61    | Aktiivne |
| Siim Kull         | Paide      | 2              | 304.59    | Aktiivne |
| Raivo Valk        | Tallinn    | 1              | 304.26    | Aktiivne |
| Merle Kaalep      | Tallinn    | 1              | 302.86    | Aktiivne |
| Katrin Roots      | Tallinn    | 2              | 302.84    | Aktiivne |
| Grete Põld        | Viljandi   | 1              | 302.79    | Aktiivne |
| Tarmo Sild        | Rakvere    | 2              | 302.76    | Aktiivne |
| Meelis Org        | Tallinn    | 1              | 301.97    | Aktiivne |
| Pille Kivi        | Valga      | 3              | 301.51    | Aktiivne |
| Arvo Ilves        | Tallinn    | 1              | 301.20    | Aktiivne |
| Mart Teder        | Tallinn    | 3              | 299.73    | Tavaline |
| Andres Männik     | Tallinn    | 2              | 299.55    | Tavaline |
| Maie Järv         | Tallinn    | 2              | 299.31    | Tavaline |
| Jüri Kallas       | Võru       | 1              | 299.10    | Tavaline |
| Kalev Salu        | Paide      | 1              | 298.94    | Tavaline |
| Ago Kõiv          | Tallinn    | 2              | 297.86    | Tavaline |
| Olev Lill         | Narva      | 3              | 297.80    | Tavaline |
| Peeter Mägi       | Narva      | 2              | 296.73    | Tavaline |
| Ants Kaalep       | Tallinn    | 1              | 296.58    | Tavaline |
| Sandra Sild       | Viljandi   | 2              | 296.58    | Tavaline |
| Ene Rand          | Narva      | 1              | 296.40    | Tavaline |
| Väino Aas         | Tallinn    | 2              | 296.30    | Tavaline |
| Ago Tammik        | Tallinn    | 2              | 294.27    | Tavaline |
| Nele Kuusik       | Kuressaare | 1              | 292.61    | Tavaline |
| Sandra Lõoke      | Narva      | 3              | 292.57    | Tavaline |
| Annika Nõmm       | Jõhvi      | 2              | 292.35    | Tavaline |
| Sandra Liiv       | Tartu      | 2              | 291.91    | Tavaline |
| Triin Veski       | Pärnu      | 1              | 291.72    | Tavaline |
| Kristiina Lepp    | Tartu      | 1              | 290.32    | Tavaline |
| Nele Kukk         | Tartu      | 2              | 288.27    | Tavaline |
| Mart Mägi         | Tallinn    | 2              | 288.00    | Tavaline |
| Ago Oja           | Kuressaare | 2              | 286.20    | Tavaline |
| Liina Kuusk       | Tallinn    | 1              | 286.17    | Tavaline |
| Marika Saar       | Tartu      | 2              | 285.56    | Tavaline |
| Väino Kaalep      | Narva      | 3              | 285.11    | Tavaline |
| Hille Lass        | Tartu      | 2              | 284.83    | Tavaline |
| Maie Saar         | Tartu      | 3              | 284.28    | Tavaline |
| Grete Luik        | Rakvere    | 2              | 284.13    | Tavaline |
| Meelis Kangur     | Rakvere    | 3              | 283.67    | Tavaline |
| Jüri Mitt         | Tartu      | 2              | 283.45    | Tavaline |
| Henri Rosin       | Tallinn    | 1              | 282.95    | Tavaline |
| Sirje Koppel      | Rakvere    | 1              | 282.95    | Tavaline |
| Anu Liiv          | Tartu      | 1              | 282.95    | Tavaline |
| Kristi Toom       | Tallinn    | 1              | 282.29    | Tavaline |
| Erkki Raid        | Kuressaare | 1              | 282.10    | Tavaline |
| Jüri Vaher        | Tartu      | 2              | 281.39    | Tavaline |
| Aivar Lill        | Pärnu      | 3              | 281.36    | Tavaline |
| Ülle Talvik       | Narva      | 1              | 281.19    | Tavaline |
| Annika Must       | Viljandi   | 2              | 280.56    | Tavaline |
| Margus Lill       | Haapsalu   | 2              | 280.09    | Tavaline |
| Annika Kõiv       | Narva      | 1              | 279.43    | Tavaline |
| Sandra Kask       | Tartu      | 1              | 279.43    | Tavaline |
| Aivar Salu        | Tallinn    | 1              | 279.43    | Tavaline |
| Toomas Nõmm       | Võru       | 1              | 278.59    | Tavaline |
| Andres Pihl       | Narva      | 2              | 276.98    | Tavaline |
| Mihkel Raid       | Haapsalu   | 1              | 276.26    | Tavaline |
| Katrin Kallas     | Viljandi   | 1              | 276.20    | Tavaline |
| Katrin Kivi       | Tallinn    | 2              | 275.73    | Tavaline |
| Aivar Hurt        | Tartu      | 1              | 274.78    | Tavaline |
| Marit Kõiv        | Pärnu      | 1              | 274.50    | Tavaline |
| Piret Vaher       | Viljandi   | 1              | 274.37    | Tavaline |
| Siim Arro         | Tallinn    | 2              | 273.22    | Tavaline |
| Katrin Kuusk      | Tallinn    | 2              | 273.10    | Tavaline |
| Merle Nurk        | Tartu      | 2              | 273.09    | Tavaline |
| Anna Raud         | Tallinn    | 1              | 273.06    | Tavaline |
| Kersti Rosin      | Pärnu      | 1              | 273.06    | Tavaline |
| Liis Järv         | Tallinn    | 1              | 272.60    | Tavaline |
| Toomas Lill       | Tartu      | 1              | 271.98    | Tavaline |
| Kristi Tammik     | Narva      | 1              | 271.35    | Tavaline |
| Annika Sepp       | Tartu      | 1              | 270.69    | Tavaline |
| Siim Kuusik       | Tallinn    | 1              | 269.88    | Tavaline |
| Heli Org          | Viljandi   | 1              | 269.88    | Tavaline |
| Ants Teder        | Tallinn    | 1              | 269.85    | Tavaline |
| Ene Veski         | Tallinn    | 1              | 269.85    | Tavaline |
| Heino Kivi        | Kuressaare | 2              | 269.54    | Tavaline |
| Taavi Paju        | Pärnu      | 2              | 268.57    | Tavaline |
| Ülle Valk         | Tartu      | 2              | 267.54    | Tavaline |
| Mart Mets         | Tartu      | 2              | 264.74    | Tavaline |
| Terje Kangur      | Pärnu      | 2              | 263.86    | Tavaline |
| Rasmus Värk       | Narva      | 2              | 263.34    | Tavaline |
| Meelis Must       | Haapsalu   | 1              | 263.13    | Tavaline |
| Tarmo Mets        | Narva      | 3              | 261.80    | Tavaline |
| Liis Sepp         | Haapsalu   | 1              | 261.46    | Tavaline |
| Maie Mitt         | Tallinn    | 1              | 260.72    | Tavaline |
| Liina Kangur      | Tallinn    | 3              | 260.47    | Tavaline |
| Hille Kukk        | Tallinn    | 1              | 260.04    | Tavaline |
| Rein Teder        | Tallinn    | 1              | 260.00    | Tavaline |
| Kristiina Männik  | Võru       | 2              | 259.76    | Tavaline |
| Anna Liiv         | Jõhvi      | 1              | 259.23    | Tavaline |
| Merike Raid       | Viljandi   | 4              | 258.11    | Tavaline |
| Arvo Raid         | Rakvere    | 2              | 257.97    | Tavaline |
| Rein Kõiv         | Tallinn    | 1              | 257.32    | Tavaline |
| Elis Rand         | Tallinn    | 1              | 257.32    | Tavaline |
| Nele Orav         | Tartu      | 1              | 254.85    | Tavaline |
| Henri Kuusik      | Tallinn    | 1              | 254.76    | Tavaline |
| Ants Lõhmus       | Tallinn    | 2              | 254.72    | Tavaline |
| Reet Saar         | Tallinn    | 2              | 254.12    | Tavaline |
| Rasmus Kask       | Pärnu      | 1              | 253.80    | Tavaline |
| Liis Nurk         | Pärnu      | 1              | 253.23    | Tavaline |
| Meelis Arro       | Jõhvi      | 2              | 252.25    | Tavaline |
| Kadri Sild        | Tallinn    | 1              | 251.96    | Tavaline |
| Kristiina Kull    | Tallinn    | 3              | 251.67    | Tavaline |
| Ragnar Paju       | Tartu      | 1              | 250.72    | Tavaline |
| Tõnu Sild         | Tallinn    | 3              | 250.10    | Tavaline |
| Grete Paju        | Tartu      | 2              | 250.00    | Tavaline |
| Maris Lepp        | Tallinn    | 2              | 249.30    | Tavaline |
| Triin Liiv        | Pärnu      | 2              | 248.97    | Tavaline |
| Maie Paju         | Pärnu      | 2              | 248.67    | Tavaline |
| Pille Tamm        | Haapsalu   | 2              | 248.31    | Tavaline |
| Madis Kivi        | Viljandi   | 1              | 247.28    | Tavaline |
| Piret Paas        | Paide      | 1              | 246.97    | Tavaline |
| Anu Luik          | Tallinn    | 1              | 246.97    | Tavaline |
| Lauri Hurt        | Tartu      | 2              | 246.84    | Tavaline |
| Anna Sepp         | Tallinn    | 2              | 246.11    | Tavaline |
| Kadri Kallas      | Tallinn    | 1              | 245.55    | Tavaline |
| Rein Nõmm         | Haapsalu   | 2              | 245.24    | Tavaline |
| Eha Tamm          | Tartu      | 1              | 243.96    | Tavaline |
| Raivo Tammik      | Narva      | 2              | 241.73    | Tavaline |
| Peeter Lass       | Tallinn    | 2              | 241.30    | Tavaline |
| Tiina Oja         | Pärnu      | 1              | 241.18    | Tavaline |
| Terje Männik      | Tallinn    | 1              | 241.13    | Tavaline |
| Triin Tamm        | Tallinn    | 2              | 240.06    | Tavaline |
| Marit Värk        | Paide      | 2              | 238.35    | Tavaline |
| Ants Lõhmus       | Valga      | 5              | 237.18    | Tavaline |
| Rasmus Veski      | Paide      | 2              | 235.49    | Tavaline |
| Kadri Lill        | Tallinn    | 1              | 234.99    | Tavaline |
| Rasmus Lass       | Tallinn    | 2              | 234.63    | Tavaline |
| Katrin Rebane     | Tallinn    | 1              | 234.10    | Tavaline |
| Enn Mets          | Kuressaare | 2              | 233.79    | Tavaline |
| Annika Kukk       | Tallinn    | 4              | 233.11    | Tavaline |
| Rein Paju         | Pärnu      | 2              | 233.06    | Tavaline |
| Indrek Järv       | Tartu      | 1              | 232.61    | Tavaline |
| Liis Põld         | Pärnu      | 1              | 231.13    | Tavaline |
| Katrin Liiv       | Tartu      | 1              | 231.13    | Tavaline |
| Külli Talvik      | Paide      | 1              | 229.55    | Tavaline |
| Hille Värk        | Tallinn    | 3              | 229.41    | Tavaline |
| Anna Männik       | Narva      | 2              | 229.17    | Tavaline |
| Maris Aas         | Tallinn    | 3              | 228.55    | Tavaline |
| Grete Must        | Tallinn    | 3              | 228.27    | Tavaline |
| Marit Kuusik      | Tallinn    | 4              | 227.34    | Tavaline |
| Hille Kull        | Narva      | 3              | 226.03    | Tavaline |
| Karin Rebane      | Tallinn    | 1              | 225.36    | Tavaline |
| Karin Tammik      | Tartu      | 1              | 225.28    | Tavaline |
| Heli Kuusk        | Tallinn    | 3              | 222.23    | Tavaline |
| Eha Hurt          | Narva      | 2              | 222.20    | Tavaline |
| Heli Puusepp      | Tartu      | 1              | 222.10    | Tavaline |
| Liis Salu         | Viljandi   | 2              | 222.07    | Tavaline |
| Triin Puusepp     | Tallinn    | 1              | 221.89    | Tavaline |
| Priit Rand        | Tartu      | 1              | 221.89    | Tavaline |
| Marika Aas        | Tallinn    | 1              | 221.42    | Tavaline |
| Maris Oja         | Tartu      | 1              | 221.40    | Tavaline |
| Piret Oja         | Tartu      | 1              | 221.19    | Tavaline |
| Tõnu Luik         | Tartu      | 1              | 219.38    | Tavaline |
| Väino Põld        | Tallinn    | 1              | 219.19    | Tavaline |
| Kati Mägi         | Tallinn    | 1              | 218.99    | Tavaline |
| Ago Roots         | Tartu      | 1              | 218.84    | Tavaline |
| Kristiina Kask    | Tallinn    | 1              | 218.54    | Tavaline |
| Külli Liiv        | Rakvere    | 1              | 218.54    | Tavaline |
| Kristi Kuusk      | Jõhvi      | 2              | 217.36    | Tavaline |
| Ago Kivi          | Kuressaare | 1              | 216.18    | Tavaline |
| Tiit Toom         | Tallinn    | 1              | 215.58    | Tavaline |
| Hille Paas        | Tartu      | 1              | 215.58    | Tavaline |
| Sigrid Rosin      | Tartu      | 1              | 214.72    | Tavaline |
| Aili Sepp         | Pärnu      | 2              | 212.82    | Tavaline |
| Raivo Kask        | Tallinn    | 2              | 212.54    | Tavaline |
| Sirje Must        | Tartu      | 4              | 211.77    | Tavaline |
| Priit Orav        | Narva      | 1              | 210.76    | Tavaline |
| Liis Järv         | Tallinn    | 1              | 210.36    | Tavaline |
| Triin Kuusik      | Pärnu      | 1              | 210.18    | Tavaline |
| Marika Kuusik     | Jõhvi      | 1              | 209.70    | Tavaline |
| Sander Kallas     | Tartu      | 1              | 209.05    | Tavaline |
| Liina Lepp        | Tallinn    | 1              | 208.15    | Tavaline |
| Terje Rosin       | Tartu      | 1              | 208.11    | Tavaline |
| Reet Lass         | Tartu      | 1              | 207.23    | Tavaline |
| Lauri Toom        | Tallinn    | 1              | 206.34    | Tavaline |
| Ülle Valk         | Tartu      | 1              | 205.89    | Tavaline |
| Urmas Tammik      | Kuressaare | 1              | 205.89    | Tavaline |
| Rain Rebane       | Pärnu      | 2              | 205.14    | Tavaline |
| Kadri Saar        | Narva      | 1              | 205.00    | Tavaline |
| Kati Valk         | Tartu      | 1              | 205.00    | Tavaline |
| Marko Rosin       | Tallinn    | 1              | 204.87    | Tavaline |
| Marko Oja         | Tartu      | 1              | 204.87    | Tavaline |
| Eha Aas           | Tallinn    | 2              | 203.92    | Tavaline |
| Nele Aas          | Tallinn    | 5              | 203.92    | Tavaline |
| Maie Kuusk        | Tallinn    | 2              | 202.80    | Tavaline |
| Priit Teder       | Narva      | 4              | 202.26    | Tavaline |
| Liina Kuusk       | Rakvere    | 1              | 201.86    | Tavaline |
| Kristiina Lass    | Tartu      | 1              | 201.14    | Tavaline |
| Maie Paju         | Tallinn    | 1              | 201.14    | Tavaline |
| Ants Raid         | Haapsalu   | 2              | 201.04    | Tavaline |
| Jüri Talvik       | Tallinn    | 1              | 200.77    | Tavaline |
| Kadri Kukk        | Narva      | 3              | 200.71    | Tavaline |
| Terje Raud        | Tartu      | 2              | 198.38    | Tavaline |
| Indrek Puusepp    | Rakvere    | 1              | 198.29    | Tavaline |
| Lauri Mets        | Tallinn    | 3              | 198.12    | Tavaline |
| Anu Oja           | Tallinn    | 2              | 197.70    | Tavaline |
| Ants Lepp         | Tallinn    | 1              | 196.91    | Tavaline |
| Arvo Vaher        | Võru       | 2              | 196.47    | Tavaline |
| Hille Kuusk       | Tallinn    | 2              | 196.13    | Tavaline |
| Rasmus Lepp       | Tallinn    | 2              | 193.75    | Tavaline |
| Arvo Lepik        | Tallinn    | 2              | 192.53    | Tavaline |
| Sigrid Luik       | Rakvere    | 1              | 192.22    | Tavaline |
| Laura Kallas      | Tartu      | 2              | 191.68    | Tavaline |
| Meelis Kuusik     | Pärnu      | 1              | 191.48    | Tavaline |
| Erkki Mets        | Tartu      | 1              | 190.86    | Tavaline |
| Heino Lõoke       | Tallinn    | 1              | 190.78    | Tavaline |
| Tarmo Tammik      | Tallinn    | 3              | 189.26    | Tavaline |
| Anu Lepp          | Tallinn    | 3              | 188.90    | Tavaline |
| Ants Nurk         | Tallinn    | 6              | 187.78    | Tavaline |
| Tiit Talvik       | Tartu      | 2              | 187.21    | Tavaline |
| Sirje Aas         | Pärnu      | 2              | 184.81    | Tavaline |
| Annika Männik     | Tartu      | 1              | 184.15    | Tavaline |
| Maie Saar         | Tartu      | 1              | 184.07    | Tavaline |
| Sander Ilves      | Tallinn    | 1              | 184.07    | Tavaline |
| Eha Kangur        | Haapsalu   | 1              | 183.40    | Tavaline |
| Nele Vaher        | Rakvere    | 1              | 183.31    | Tavaline |
| Indrek Raid       | Tartu      | 1              | 183.31    | Tavaline |
| Kadri Männik      | Pärnu      | 1              | 183.31    | Tavaline |
| Aili Kuusk        | Tallinn    | 2              | 182.84    | Tavaline |
| Kristjan Liiv     | Tallinn    | 1              | 182.77    | Tavaline |
| Piret Aas         | Narva      | 2              | 182.40    | Tavaline |
| Urmas Põld        | Tallinn    | 1              | 181.68    | Tavaline |
| Arvo Tammik       | Narva      | 1              | 181.11    | Tavaline |
| Raivo Rebane      | Tartu      | 2              | 178.75    | Tavaline |
| Triin Koppel      | Narva      | 1              | 178.58    | Tavaline |
| Merle Lass        | Viljandi   | 2              | 177.60    | Tavaline |
| Aili Mägi         | Valga      | 3              | 177.58    | Tavaline |
| Margus Vaher      | Tartu      | 1              | 176.65    | Tavaline |
| Kalev Kask        | Tallinn    | 1              | 176.65    | Tavaline |
| Tõnu Laas         | Pärnu      | 2              | 174.38    | Tavaline |
| Katrin Liiv       | Tallinn    | 2              | 172.84    | Tavaline |
| Kevin Pihl        | Tartu      | 2              | 172.52    | Tavaline |
| Anu Värk          | Tallinn    | 1              | 172.28    | Tavaline |
| Lauri Ilves       | Kuressaare | 1              | 171.33    | Tavaline |
| Urmas Lepp        | Viljandi   | 1              | 171.33    | Tavaline |
| Sandra Tamm       | Pärnu      | 2              | 171.13    | Tavaline |
| Raivo Toom        | Paide      | 1              | 169.90    | Tavaline |
| Arvo Mägi         | Võru       | 1              | 169.08    | Tavaline |
| Kristjan Kangur   | Pärnu      | 2              | 168.61    | Tavaline |
| Ene Kull          | Võru       | 2              | 168.08    | Tavaline |
| Grete Rand        | Narva      | 1              | 167.94    | Tavaline |
| Kristiina Talvik  | Paide      | 1              | 167.23    | Tavaline |
| Olev Kuusik       | Tallinn    | 1              | 166.52    | Tavaline |
| Toomas Orav       | Tallinn    | 1              | 166.27    | Tavaline |
| Olev Talvik       | Tallinn    | 1              | 166.27    | Tavaline |
| Sandra Kukk       | Jõhvi      | 1              | 166.27    | Tavaline |
| Olev Mägi         | Pärnu      | 1              | 166.27    | Tavaline |
| Ene Org           | Tartu      | 1              | 166.27    | Tavaline |
| Heli Kangur       | Pärnu      | 1              | 164.43    | Tavaline |
| Laura Org         | Tallinn    | 1              | 164.30    | Tavaline |
| Jüri Lepik        | Pärnu      | 2              | 164.07    | Tavaline |
| Meelis Toom       | Valga      | 1              | 163.64    | Tavaline |
| Pille Oja         | Tallinn    | 2              | 163.37    | Tavaline |
| Kristi Talvik     | Tallinn    | 2              | 163.34    | Tavaline |
| Pille Laas        | Narva      | 1              | 160.91    | Tavaline |
| Kersti Raid       | Tallinn    | 1              | 160.21    | Tavaline |
| Ene Raud          | Viljandi   | 1              | 159.25    | Tavaline |
| Jaak Vaher        | Rakvere    | 1              | 158.94    | Tavaline |
| Rain Raid         | Narva      | 1              | 158.94    | Tavaline |
| Heino Roots       | Tallinn    | 2              | 158.21    | Tavaline |
| Nele Lass         | Tartu      | 3              | 157.91    | Tavaline |
| Kaido Luik        | Tartu      | 1              | 157.49    | Tavaline |
| Sandra Lepik      | Tallinn    | 2              | 157.42    | Tavaline |
| Ülle Puusepp      | Haapsalu   | 1              | 154.71    | Tavaline |
| Kadri Orav        | Tallinn    | 1              | 154.71    | Tavaline |
| Elis Liiv         | Narva      | 1              | 154.71    | Tavaline |
| Erkki Mitt        | Kuressaare | 2              | 153.74    | Tavaline |
| Nele Kask         | Narva      | 1              | 153.62    | Tavaline |
| Reet Puusepp      | Tallinn    | 1              | 153.62    | Tavaline |
| Rein Koppel       | Narva      | 1              | 153.40    | Tavaline |
| Tiina Hurt        | Tallinn    | 1              | 153.11    | Tavaline |
| Arvo Valk         | Tallinn    | 1              | 152.85    | Tavaline |
| Sandra Kuusk      | Tartu      | 1              | 152.13    | Tavaline |
| Terje Org         | Tallinn    | 1              | 152.13    | Tavaline |
| Heli Rosin        | Tallinn    | 1              | 151.08    | Tavaline |
| Meelis Veski      | Jõhvi      | 1              | 149.62    | Tavaline |
| Madis Liiv        | Jõhvi      | 1              | 147.80    | Tavaline |
| Tarmo Saar        | Paide      | 1              | 147.58    | Tavaline |
| Reet Puusepp      | Tallinn    | 1              | 147.16    | Tavaline |
| Merike Laas       | Tartu      | 2              | 147.00    | Tavaline |
| Merike Kuusk      | Tallinn    | 1              | 145.46    | Tavaline |
| Külli Järv        | Tartu      | 1              | 145.46    | Tavaline |
| Triin Toom        | Tallinn    | 1              | 145.16    | Tavaline |
| Mart Värk         | Tallinn    | 1              | 145.16    | Tavaline |
| Annika Talvik     | Tallinn    | 1              | 142.57    | Tavaline |
| Ene Nõmm          | Tallinn    | 1              | 141.05    | Tavaline |
| Reet Liiv         | Pärnu      | 1              | 141.05    | Tavaline |
| Sigrid Nõmm       | Tartu      | 1              | 140.02    | Tavaline |
| Külli Järv        | Tartu      | 1              | 140.02    | Tavaline |
| Grete Kukk        | Tallinn    | 2              | 140.02    | Tavaline |
| Enn Lõhmus        | Tallinn    | 1              | 139.74    | Tavaline |
| Ants Valk         | Pärnu      | 1              | 139.74    | Tavaline |
| Hille Männik      | Tallinn    | 2              | 139.27    | Tavaline |
| Reet Rebane       | Viljandi   | 1              | 138.90    | Tavaline |
| Pille Talvik      | Tallinn    | 1              | 138.90    | Tavaline |
| Tõnu Must         | Tartu      | 1              | 138.78    | Tavaline |
| Jaak Lõoke        | Tallinn    | 1              | 138.13    | Tavaline |
| Riina Lepp        | Tartu      | 1              | 138.13    | Tavaline |
| Triin Lill        | Tallinn    | 1              | 138.13    | Tavaline |
| Kalev Pärn        | Valga      | 1              | 136.30    | Tavaline |
| Annika Raid       | Tallinn    | 1              | 135.99    | Tavaline |
| Margus Kallas     | Pärnu      | 3              | 135.96    | Tavaline |
| Anu Salu          | Tallinn    | 2              | 135.51    | Tavaline |
| Margus Toom       | Pärnu      | 1              | 134.58    | Tavaline |
| Liina Kangur      | Tartu      | 2              | 133.47    | Tavaline |
| Piret Hurt        | Tallinn    | 1              | 130.73    | Tavaline |
| Jüri Nõmm         | Tartu      | 1              | 130.73    | Tavaline |
| Jaak Põld         | Tallinn    | 1              | 130.36    | Tavaline |
| Merle Lepik       | Tartu      | 1              | 130.02    | Tavaline |
| Ene Oja           | Tallinn    | 1              | 130.02    | Tavaline |
| Ene Org           | Tallinn    | 1              | 127.92    | Tavaline |
| Anna Must         | Pärnu      | 1              | 127.24    | Tavaline |
| Erkki Rand        | Narva      | 1              | 126.42    | Tavaline |
| Kadri Nurk        | Paide      | 2              | 126.08    | Tavaline |
| Laura Pihl        | Pärnu      | 1              | 125.98    | Tavaline |
| Kevin Tamm        | Tallinn    | 1              | 124.35    | Tavaline |
| Triin Liiv        | Pärnu      | 1              | 123.64    | Tavaline |
| Sander Vaher      | Tallinn    | 2              | 122.81    | Tavaline |
| Kristi Koppel     | Tartu      | 2              | 122.24    | Tavaline |
| Indrek Rand       | Tartu      | 1              | 121.98    | Tavaline |
| Arvo Kull         | Narva      | 1              | 121.51    | Tavaline |
| Jaak Rebane       | Tartu      | 1              | 121.51    | Tavaline |
| Toomas Männik     | Tallinn    | 1              | 121.51    | Tavaline |
| Kersti Männik     | Tartu      | 2              | 118.54    | Tavaline |
| Ülle Raud         | Tallinn    | 3              | 118.44    | Tavaline |
| Sander Nurk       | Viljandi   | 1              | 116.98    | Tavaline |
| Sander Liiv       | Võru       | 1              | 116.20    | Tavaline |
| Külli Kallas      | Pärnu      | 1              | 116.10    | Tavaline |
| Aivar Laas        | Viljandi   | 1              | 114.16    | Tavaline |
| Toomas Koppel     | Jõhvi      | 1              | 110.70    | Tavaline |
| Kalev Kuusik      | Tallinn    | 1              | 110.53    | Tavaline |
| Liis Aas          | Tartu      | 1              | 110.02    | Tavaline |
| Tarmo Kaalep      | Tallinn    | 2              | 108.18    | Tavaline |
| Väino Raid        | Tallinn    | 1              | 107.67    | Tavaline |
| Heli Värk         | Tallinn    | 2              | 107.63    | Tavaline |
| Aivar Toom        | Rakvere    | 1              | 107.36    | Tavaline |
| Priit Aas         | Narva      | 1              | 106.82    | Tavaline |
| Urmas Arro        | Tallinn    | 1              | 106.82    | Tavaline |
| Triin Veski       | Tartu      | 1              | 106.69    | Tavaline |
| Liis Hurt         | Rakvere    | 1              | 106.69    | Tavaline |
| Olev Kask         | Tallinn    | 1              | 106.69    | Tavaline |
| Jaak Paas         | Tallinn    | 1              | 106.69    | Tavaline |
| Ragnar Kuusik     | Tallinn    | 1              | 105.09    | Tavaline |
| Laura Pihl        | Tallinn    | 1              | 104.85    | Tavaline |
| Marko Oja         | Tallinn    | 2              | 104.35    | Tavaline |
| Raivo Koppel      | Tallinn    | 1              | 104.27    | Tavaline |
| Liis Männik       | Tallinn    | 4              | 104.08    | Tavaline |
| Erkki Tammik      | Tartu      | 2              | 102.51    | Tavaline |
| Henri Vaher       | Narva      | 2              | 102.29    | Tavaline |
| Kalev Teder       | Narva      | 1              | 101.26    | Tavaline |
| Lauri Tamm        | Võru       | 2              | 97.11     | Tavaline |
| Riina Kuusk       | Tartu      | 1              | 95.87     | Tavaline |
| Jüri Männik       | Tallinn    | 1              | 94.76     | Tavaline |
| Sandra Lill       | Tallinn    | 1              | 90.80     | Tavaline |
| Marko Aas         | Haapsalu   | 1              | 86.14     | Tavaline |
| Heino Hurt        | Tartu      | 1              | 84.95     | Tavaline |
| Aili Lass         | Tartu      | 1              | 84.54     | Tavaline |
| Rasmus Mägi       | Tartu      | 1              | 83.97     | Tavaline |
| Erkki Veski       | Võru       | 1              | 83.10     | Tavaline |
| Merle Koppel      | Tartu      | 1              | 81.48     | Tavaline |
| Jüri Roots        | Tallinn    | 1              | 81.48     | Tavaline |
| Rein Arro         | Tartu      | 1              | 80.39     | Tavaline |
| Sigrid Mets       | Võru       | 2              | 79.76     | Tavaline |
| Jaak Raud         | Valga      | 2              | 78.97     | Tavaline |
| Marika Kask       | Viljandi   | 1              | 77.78     | Tavaline |
| Annika Raud       | Tallinn    | 1              | 74.81     | Tavaline |
| Ene Aas           | Jõhvi      | 1              | 74.70     | Tavaline |
| Sander Kuusik     | Tallinn    | 1              | 72.73     | Tavaline |
| Merike Lass       | Pärnu      | 1              | 70.01     | Tavaline |
| Kaido Kuusik      | Tallinn    | 1              | 68.08     | Tavaline |
| Katrin Rebane     | Võru       | 1              | 67.75     | Tavaline |
| Elis Saar         | Tartu      | 1              | 67.75     | Tavaline |
| Henri Oja         | Tallinn    | 1              | 67.75     | Tavaline |
| Kevin Valk        | Valga      | 1              | 65.60     | Tavaline |
| Anna Lill         | Jõhvi      | 1              | 65.60     | Tavaline |
| Sander Saar       | Tallinn    | 1              | 63.95     | Tavaline |
| Kersti Lepik      | Tartu      | 1              | 63.30     | Tavaline |
| Taavi Lill        | Kuressaare | 1              | 62.56     | Tavaline |
| Lea Rand          | Pärnu      | 1              | 62.56     | Tavaline |
| Henri Kull        | Võru       | 1              | 60.37     | Tavaline |
| Marika Mitt       | Tallinn    | 3              | 59.38     | Tavaline |
| Hille Kangur      | Tallinn    | 1              | 58.96     | Tavaline |
| Kalev Must        | Tartu      | 1              | 58.49     | Tavaline |
| Mihkel Liiv       | Viljandi   | 1              | 58.49     | Tavaline |
| Ülle Kuusik       | Haapsalu   | 2              | 57.91     | Tavaline |
| Toomas Rosin      | Paide      | 1              | 57.08     | Tavaline |
| Jaak Kask         | Tartu      | 1              | 57.08     | Tavaline |
| Triin Rosin       | Tartu      | 1              | 55.04     | Tavaline |
| Heli Lass         | Tartu      | 1              | 55.04     | Tavaline |
| Mart Värk         | Valga      | 1              | 55.04     | Tavaline |
| Tarmo Oja         | Tartu      | 1              | 54.95     | Tavaline |
| Erkki Hurt        | Pärnu      | 1              | 53.58     | Tavaline |
| Lea Kukk          | Tartu      | 1              | 53.24     | Tavaline |
| Sigrid Oja        | Tartu      | 1              | 53.24     | Tavaline |
| Henri Kangur      | Tallinn    | 1              | 53.01     | Tavaline |
| Külli Männik      | Tartu      | 1              | 53.01     | Tavaline |
| Tiit Pihl         | Narva      | 1              | 53.01     | Tavaline |
| Jaak Tammik       | Tallinn    | 1              | 51.58     | Tavaline |
| Heli Männik       | Tallinn    | 1              | 51.58     | Tavaline |
| Arvo Laas         | Tartu      | 1              | 51.58     | Tavaline |
| Piret Kuusik      | Kuressaare | 1              | 51.50     | Tavaline |
| Raivo Laas        | Pärnu      | 1              | 50.85     | Tavaline |
| Meelis Saar       | Rakvere    | 1              | 50.85     | Tavaline |
| Liis Puusepp      | Tartu      | 1              | 50.85     | Tavaline |
| Sirje Roots       | Tartu      | 1              | 50.77     | Tavaline |
| Ülle Teder        | Pärnu      | 1              | 49.08     | Tavaline |
| Enn Salu          | Narva      | 1              | 48.85     | Tavaline |
| Tarmo Luik        | Tallinn    | 1              | 48.85     | Tavaline |
| Kristjan Valk     | Tallinn    | 1              | 48.58     | Tavaline |
| Arvo Lepp         | Tallinn    | 1              | 47.88     | Tavaline |
| Tõnu Must         | Tallinn    | 1              | 47.38     | Tavaline |
| Henri Aas         | Tallinn    | 1              | 47.36     | Tavaline |
| Riina Mägi        | Tallinn    | 1              | 47.36     | Tavaline |
| Priit Tammik      | Tallinn    | 1              | 45.21     | Tavaline |
| Mihkel Raid       | Tallinn    | 1              | 44.08     | Tavaline |
| Sigrid Arro       | Jõhvi      | 1              | 42.64     | Tavaline |
| Enn Teder         | Paide      | 1              | 42.64     | Tavaline |
| Maris Kallas      | Rakvere    | 1              | 41.79     | Tavaline |
| Reet Arro         | Valga      | 1              | 41.63     | Tavaline |
| Annika Toom       | Tartu      | 1              | 41.63     | Tavaline |
| Aivar Puusepp     | Kuressaare | 1              | 35.94     | Tavaline |
| Elis Nurk         | Pärnu      | 1              | 31.65     | Tavaline |
| Mart Lõoke        | Tallinn    | 2              | 30.82     | Tavaline |
| Kati Kask         | Rakvere    | 1              | 29.48     | Tavaline |
| Reet Rosin        | Tartu      | 1              | 29.48     | Tavaline |
| Jaak Kallas       | Tallinn    | 1              | 26.79     | Tavaline |
| Katrin Kuusik     | Tartu      | 1              | 26.79     | Tavaline |
| Madis Teder       | Tartu      | 1              | 26.62     | Tavaline |
| Meelis Kuusk      | Tallinn    | 4              | 25.10     | Tavaline |
| Heino Aas         | Narva      | 1              | 23.45     | Tavaline |
| Marika Lill       | Pärnu      | 1              | 17.97     | Tavaline |
| Urmas Valk        | Tartu      | 1              | 16.62     | Tavaline |
| Sander Nõmm       | Tartu      | 1              | 16.62     | Tavaline |
| Enn Saar          | Tartu      | 1              | 15.09     | Tavaline |
| Lea Aas           | Pärnu      | 2              | 14.92     | Tavaline |
| Karin Rosin       | Tallinn    | 2              | -0.17     | Tavaline |
| Anu Pihl          | Viljandi   | 4              | -10.42    | Tavaline |
| Pille Põld        | Tallinn    | 2              | -16.13    | Tavaline |
| Merle Valk        | Viljandi   | 3              | -24.64    | Tavaline |
| Aili Kask         | Tallinn    | 2              | -38.78    | Tavaline |
| Raivo Lepp        | Valga      | 3              | -44.56    | Tavaline |
| Ants Hurt         | Kuressaare | 2              | -48.05    | Tavaline |
| Mart Lõhmus       | Narva      | 5              | -74.81    | Tavaline |
| Kalev Liiv        | Tallinn    | 3              | -85.85    | Tavaline |
| Ülle Nõmm         | Tallinn    | 2              | -94.63    | Tavaline |
| Siim Kangur       | Tallinn    | 1              | -112.68   | Tavaline |
| Toomas Oja        | Kuressaare | 2              | -117.32   | Tavaline |
| Margus Nurk       | Viljandi   | 4              | -155.24   | Tavaline |
| Kevin Kangur      | Tartu      | 3              | -176.40   | Tavaline |
| Lea Kangur        | Tallinn    | 3              | -181.97   | Tavaline |
| Tõnu Toom         | Tartu      | 1              | -184.02   | Tavaline |
| Merike Lepp       | Tartu      | 3              | -203.83   | Tavaline |
| Siim Rosin        | Tallinn    | 1              | -243.93   | Tavaline |
| Rasmus Rebane     | Tallinn    | 4              | -255.63   | Tavaline |
| Heino Pärn        | Tartu      | 1              | -279.48   | Tavaline |
| Tiina Tamm        | Narva      | 1              | -282.29   | Tavaline |
| Marika Kõiv       | Tallinn    | 1              | -307.27   | Tavaline |
| Heli Põld         | Pärnu      | 5              | -401.39   | Tavaline |
| Merike Tamm       | Tartu      | 1              | -453.24   | Tavaline |
| Andres Hurt       | Haapsalu   | 2              | -589.31   | Tavaline |
| Sirje Tammik      | Rakvere    | 2              | -677.04   | Tavaline |
| Sigrid Paas       | Jõhvi      | 1              | -702.66   | Tavaline |
| Marko Mägi        | Tallinn    | 2              | -715.66   | Tavaline |
| Kristjan Laas     | Tallinn    | 1              | -939.64   | Tavaline |
| Marko Liiv        | Tallinn    | 2              | -1354.47  | Tavaline |

Lisa teine CTE, mis loeb klientide arvu segmendi kaupa:

WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(s.sale_id) AS tellimuste_arv,
        SUM(s.total_price) AS kogukaive
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
),
segmenteeritud AS (
    SELECT
        nimi,
        city,
        tellimuste_arv,
        kogukaive,
        CASE
            WHEN kogukaive > 1000 THEN 'VIP'
            WHEN kogukaive > 300 THEN 'Aktiivne'
            ELSE 'Tavaline'
        END AS segment
    FROM kliendi_kokkuvote
)
SELECT 
    segment,
    COUNT(*) AS klientide_arv,
    ROUND(AVG(kogukaive), 2) AS keskmine_käive,
    SUM(kogukaive) AS kogukäive_segmendis
FROM segmenteeritud
GROUP BY segment
ORDER BY 
    CASE segment 
        WHEN 'VIP' THEN 1 
        WHEN 'Aktiivne' THEN 2 
        ELSE 3 
    END;

--Tulemus

| segment  | klientide_arv | keskmine_käive | kogukäive_segmendis |
| -------- | ------------- | -------------- | ------------------- |
| VIP      | 936           | 1952.63        | 1827664.43          |
| Aktiivne | 1160          | 629.11         | 729773.10           |
| Tavaline | 455           | 143.50         | 65294.25            |


Harjutus 3C: Rakendus — Window Function (15 min)
Ülesanne: Kasuta ROW_NUMBER() funktsiooni, et leida iga kategooria TOP 3 toodet müüdud koguse järgi.

WITH toodete_myyk AS (
    SELECT
        p.category,
        p.product_name,
        SUM(s.quantity) AS müüdud_kogus,
        ROW_NUMBER() OVER (
            PARTITION BY p.category 
            ORDER BY SUM(s.quantity) DESC
        ) AS koht
    FROM products p
    JOIN sales s ON p.product_id = s.product_id
    GROUP BY p.category, p.product_name
)
SELECT
    category,
    product_name,
    müüdud_kogus,
    koht
FROM toodete_myyk
WHERE koht <= 3
ORDER BY category, koht;

--Tulemus

| category      | product_name                               | müüdud_kogus | koht |
| ------------- | ------------------------------------------ | ------------ | ---- |
| aksessuaarid  | Stiilne puust müts                         | 78           | 1    |
| aksessuaarid  | Praktiline nahkne sõrmus                   | 75           | 2    |
| aksessuaarid  | Boheemlaslik kangast kangasvöö             | 70           | 3    |
| jalanõusid    | Moodne seemisnahkne oxfordid               | 83           | 1    |
| jalanõusid    | Õhuline sünteetiline kõrge kontsaga kingad | 79           | 2    |
| jalanõusid    | Minimalistlik seemisnahkne chelsea botased | 71           | 3    |
| laste_riided  | Minimalistlik villane pühapäevakleit       | 81           | 1    |
| laste_riided  | Luksuslik softshell komplekt               | 80           | 2    |
| laste_riided  | Vintage villane püksid                     | 73           | 3    |
| meeste_riided | Elegantne flanellne cargo püksid           | 73           | 1    |
| meeste_riided | Luksuslik puuvillane linane särk           | 73           | 2    |
| meeste_riided | Praktiline puuvillane ülikond              | 72           | 3    |
| naiste_riided | Sportlik siidine cargo püksid              | 77           | 1    |
| naiste_riided | Soe džersii cargo püksid                   | 74           | 2    |
| naiste_riided | Minimalistlik džersii chino püksid         | 72           | 3    |


Integreeriv harjutus — CEO Raport
Ülesanne: Kirjuta üks CTE-põhine päring, mis annab Kristile ülevaate TOP 5 linnast koos igakuise trendiga.

WITH linna_myyk AS (
    -- CTE 1: iga linna kogumüük (2024)
    SELECT
        c.city AS linn,
        COUNT(DISTINCT s.sale_id) AS tellimusi,
        SUM(s.total_price) AS kogukaive,
        ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    WHERE s.sale_date >= '2024-01-01'
    GROUP BY c.city
    HAVING COUNT(DISTINCT s.sale_id) > 5
),
linna_jarjestus AS (
    -- CTE 2: lisa järjestus
    SELECT
        linn,
        tellimusi,
        kogukaive,
        keskmine_tellimus,
        ROW_NUMBER() OVER (ORDER BY kogukaive DESC) AS koht
    FROM linna_myyk
),
kogu_kaive AS (
    -- CTE 3: kogu käive (osakaalu arvutamiseks)
    SELECT SUM(kogukaive) AS total_kaive
    FROM linna_myyk
),
viimase_kuu_myyk AS (
    -- CTE 4: viimase kuu käive linna kaupa
    SELECT
        c.city AS linn,
        SUM(s.total_price) AS viimase_kuu_kaive
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    WHERE s.sale_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
      AND s.sale_date < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY c.city
)
SELECT 
    j.koht,
    j.linn,
    j.tellimusi,
    j.kogukaive,
    j.keskmine_tellimus,
    ROUND(100.0 * j.kogukaive / k.total_kaive, 1) AS osakaal_protsentides,
    COALESCE(v.viimase_kuu_kaive, 0) AS viimase_kuu_kaive,
    ROUND(j.kogukaive / 12.0, 2) AS kuu_keskmine_kaive,  -- lihtsustatud (kogu aasta / 12)
    ROUND(
        COALESCE(v.viimase_kuu_kaive, 0) - (j.kogukaive / 12.0), 
        2
    ) AS erinevus_keskmisest
FROM linna_jarjestus j
CROSS JOIN kogu_kaive k
LEFT JOIN viimase_kuu_myyk v ON j.linn = v.linn
WHERE j.koht <= 5
ORDER BY j.koht;

Mis juurde tuli

osakaal_protsentides – kui suure osa kogu käibest see linn moodustab
viimase_kuu_kaive – eelmise kalendrikuu käive
kuu_keskmine_kaive – lihtsustatud aasta keskmine
erinevus_keskmisest – kas viimane kuu oli keskmisest parem või kehvem

--Tulemus

| koht | linn     | tellimusi | kogukaive | keskmine_tellimus | osakaal_protsentides | viimase_kuu_kaive | kuu_keskmine_kaive | erinevus_keskmisest |
| ---- | -------- | --------- | --------- | ----------------- | -------------------- | ----------------- | ------------------ | ------------------- |
| 1    | Tallinn  | 2062      | 571649.39 | 277.23            | 37.9                 | -128.44           | 47637.45           | -47765.89           |
| 2    | Tartu    | 1011      | 292500.31 | 289.32            | 19.4                 | 0                 | 24375.03           | -24375.03           |
| 3    | Pärnu    | 755       | 226008.72 | 299.35            | 15.0                 | 953.72            | 18834.06           | -17880.34           |
| 4    | Narva    | 233       | 67458.67  | 289.52            | 4.5                  | 0                 | 5621.56            | -5621.56            |
| 5    | Viljandi | 215       | 60339.62  | 280.65            | 4.0                  | 0                 | 5028.30            | -5028.30            |

