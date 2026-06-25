SELECT COUNT(*) AS klientide_arv FROM customers;
SELECT * FROM customers LIMIT 10; 

SELECT * FROM customers    WHERE city = 'Tallinn'    ORDER BY last_name ASC    LIMIT 15; 
SELECT MIN(registration_date) AS vanim,           MAX(registration_date) AS uusim    FROM customers;
SELECT COUNT(*) - COUNT(first_name) AS puuduvad_eesnimed    FROM customers;
SELECT COUNT(*) - COUNT(email) AS puuduvad_emailid    FROM customers; 
SELECT DISTINCT city FROM customers; 
SELECT COUNT(*) AS kokku_emaile, COUNT(DISTINCT email) AS unikaalseid_emaile   FROM customers;   -- Vahe = duplikaadid!   
SELECT city, COUNT(*) AS klientide_arv   FROM customers   GROUP BY city   ORDER BY klientide_arv DESC; 
SELECT * FROM customers   WHERE registration_date >= '2024-07-01'   ORDER BY registration_date DESC; 
