
SELECT COUNT(1)
FROM czechia_price; 


SELECT COUNT(id) AS row_count
FROM czechia_payroll cp;


SELECT COUNT(1) AS row_count
FROM czechia_payroll cp;


SELECT COUNT(value) AS row_count
FROM czechia_payroll cp;



SELECT 
	COUNT(id) AS rows_of_known_employees
FROM czechia_payroll cp
WHERE value_type_code = 316
	AND value IS NOT NULL;


SELECT 
	category_code,
	COUNT(id) AS rows_in_category
FROM czechia_price cp
GROUP BY category_code;

SELECT 
	date_from,
	YEAR(date_from) AS year_of_entry
FROM czechia_price cp




SELECT 
	category_code,
	YEAR(date_from) AS year_of_entry,
	COUNT(id) AS rows_in_category
FROM czechia_price cp
GROUP BY 
	category_code, 
	YEAR(date_from)
ORDER BY 
	category_code, 
	YEAR(date_from)
;

-- ekvivalentni
SELECT 
	category_code,
	YEAR(date_from) AS year_of_entry,
	COUNT(id) AS rows_in_category
FROM czechia_price cp
GROUP BY 
	category_code, 
	YEAR(date_from)
ORDER BY 
	category_code, 
	year_of_entry
;



SELECT GETDATE();

SELECT DATEPART(YEAR, '2023-02-24 10:26:51.067');

SELECT FORMAT(GETDATE(), 'yyyy-MM');

SELECT FORMAT(CAST('2023-02-24 10:26:51.067' AS datetime), 'yyyy-MM');

SELECT CAST('2023-02-24 10:26:51.067' AS datetime);

/**
 * SUM ()
 */


SELECT SUM(value) AS value_sum
FROM czechia_payroll cp
WHERE value_type_code = 316;



SELECT *
FROM czechia_region cr;


SELECT 
	category_code,
	SUM(value) AS sum_of_average_prices
FROM czechia_price cp
WHERE region_code = 'CZ064'
GROUP BY category_code;


SELECT 
	SUM(value) AS sum_of_average_prices
FROM czechia_price cp
WHERE date_from = '2018-01-15';


SELECT 
	SUM(value) AS sum_of_average_prices
FROM czechia_price cp
WHERE date_from = CAST('2018-01-15' AS date);


SELECT 
	category_code,
	COUNT(1) AS row_count, 
	SUM(value) AS sum_of_average_prices
FROM czechia_price cp
WHERE YEAR(date_from) = 2018
GROUP BY category_code;


SELECT *
FROM czechia_price cp
WHERE category_code = 2000001
	AND YEAR(date_from) = 2018;


/**
 * dalsi agregacni funkce
 */


SELECT 
	MAX(value)
FROM czechia_payroll cp 
WHERE value_type_code = 5958;


SELECT 
	category_code,
	MIN(value)
FROM czechia_price cp 
WHERE YEAR(date_from) BETWEEN 2015 AND 2017
GROUP BY category_code;



SELECT 
	industry_branch_code 
FROM czechia_payroll cp
WHERE value IN (
	SELECT 
		MAX(value)
	FROM czechia_payroll cp 
	WHERE value_type_code = 5958
);


SELECT 
	*
FROM czechia_payroll_industry_branch cpib 
WHERE code IN (
	SELECT 
		industry_branch_code 
	FROM czechia_payroll cp
	WHERE value IN (
		SELECT 
			MAX(value)
		FROM czechia_payroll cp 
		WHERE value_type_code = 5958
	)
);


-- CTRL + SHIFT + F = formatovani sql dotazu
SELECT 	* 
FROM czechia_payroll_industry_branch cpib 
WHERE code IN ( 	SELECT 		industry_branch_code 
	FROM czechia_payroll cp	WHERE value IN (		SELECT 			MAX(value)
		FROM czechia_payroll cp 		WHERE value_type_code = 5958
	));



SELECT 
	category_code,
	MIN(value) AS min_val,
	MAX(value) AS max_val,
	MAX(value) - MIN(value) AS diff,
	CASE 
		WHEN MAX(value) - MIN(value) < 10 THEN 'rozdil do 10 kc'
		WHEN MAX(value) - MIN(value) < 40 THEN 'rozdil do 40 kc'
		ELSE 'rozdil nad 40 kc'
	END	AS diffence
FROM czechia_price cp 
GROUP BY category_code
ORDER BY MAX(value) - MIN(value);


SELECT 
	category_code,
	MIN(value) AS min_val,
	MAX(value) AS max_val,
	ROUND(AVG(value), 3) AS average 
FROM czechia_price cp 
GROUP BY category_code;


SELECT 
	category_code,
	region_code,
	MIN(value) AS min_val,
	MAX(value) AS max_val,
	ROUND(AVG(value), 3) AS average 
FROM czechia_price cp 
GROUP BY category_code, region_code
ORDER BY average DESC;


SELECT SQRT(-16); -- error
SELECT 10/0;
SELECT FLOOR(1.56);
SELECT FLOOR(-1.56);
SELECT CEILING(1.56);   -- T-SQL CEILING vs SQL CEIL
SELECT CEILING(-1.56);
SELECT ROUND(1.56, 0);
SELECT ROUND(-1.56, 0);


SELECT FLOOR(123.45), FLOOR(-123.45), FLOOR($123.45);  


SELECT 
	category_code,
	ROUND(AVG(value), 2) AS average_avg_fce,
	ROUND(SUM(value) / COUNT(value), 2)  AS average_avg
FROM czechia_price cp 
GROUP BY category_code;


SELECT 1;
SELECT 1.0;
SELECT 1 + 1;
SELECT 1 + 1.0 + 0.5;
SELECT 1 + '1';
SELECT 1 + 'a';
SELECT 1 + '12tatata';


SELECT CONCAT('ahoj', ' jak', ' se mas?'); -- 'ahoj jak se mas?'

--SELECT CONCAT(name, ' ', surname);


SELECT CONCAT('Mame ', COUNT(DISTINCT category_code) , ' pocet kategorii') AS info 
FROM czechia_price cp;


-- SUBSTRING(string, start, length)

SELECT 
	name,
	SUBSTRING(name, 1, 2) AS prefix,
	SUBSTRING(name, -2, 2) AS suffix, -- takhle ne
	REVERSE(name) AS reverse_str,
	REVERSE(SUBSTRING(REVERSE(name), 1, 2)) AS suffix,
	LEN(name)
FROM czechia_price_category cpc;




