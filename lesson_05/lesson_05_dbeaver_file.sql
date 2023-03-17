


SELECT 
	d.id AS doctor_id,
	d.name,
	d.surname,
	a.street,
	a.street_number 
FROM doctor d 
LEFT JOIN address a 
	ON a.id = d.address_id;
	

SELECT * FROM medicament m;

SELECT 
	p.name,
	p.surname,
	m.name AS medicament_name,
	SUM(lom.amount) AS amount,
	m.unit 
FROM patient p 
LEFT JOIN prescription pr 
	ON pr.patient_id = p.id
LEFT JOIN list_of_medicaments lom 
	ON lom.prescription_id = pr.id 
LEFT JOIN medicament m 
	ON m.id = lom.medicament_id 
GROUP BY p.name, p.surname, m.name, m.unit 
ORDER BY p.name, p.surname;


SELECT * FROM patient p;

INSERT INTO patient (name, surname, address_id, insurance_company)
VALUES ('Jan', 'Nezname', NULL, 'Statni pojistovna');



SELECT * 
FROM patient p
LEFT JOIN address a 
	ON a.id = p.address_id;


SELECT * 
FROM patient p
JOIN address a 
	ON a.id = p.address_id;


SELECT name, surname, 'doctor' AS personal_position
FROM doctor d 
UNION
SELECT name, surname, 'patient' AS personal_position
FROM patient p; 



SELECT name, surname
FROM doctor d 
UNION ALL
SELECT name, surname
FROM patient p; 



-- 127.0.0.1 -> 155968595

SELECT 
	*,
	id % 2,
	ip % 2
FROM patient p
WHERE country = 'US'; 



SELECT 123456789874 % 11;

SELECT 
	*,
	id % 2 AS modulo
FROM patient p
WHERE id % 2 = 0; 



/*
 * DISTINCT
 */

SELECT municipality 
FROM healthcare_provider hp;


SELECT municipality 
FROM healthcare_provider hp 
GROUP BY municipality;



SELECT DISTINCT municipality 
FROM healthcare_provider hp;



SELECT COUNT(DISTINCT municipality) 
FROM healthcare_provider hp;




SELECT 
	municipality,
	COUNT(1) AS counter
FROM healthcare_provider hp 
GROUP BY municipality;


SELECT 
	DISTINCT 
	cr.name,
	cd.name 
FROM healthcare_provider hp 
LEFT JOIN czechia_region cr ON cr.code = hp.region_code 
LEFT JOIN czechia_district cd ON cd.code = hp.district_code;



/*
 * CTE - WITH
 */


WITH high_price AS (
	SELECT DISTINCT category_code AS code
	FROM czechia_price cp 
	WHERE value > 150
)
SELECT cpc.name  
FROM high_price hp
JOIN czechia_price_category cpc ON cpc.code = hp.code;






WITH not_completed_provider_info_district AS (
	SELECT DISTINCT district_code 
	FROM healthcare_provider hp 
	WHERE 
		phone IS NULL 
		AND email IS NULL 
		AND fax IS NULL 
		AND provider_type = 'Samost. ordinace všeob. prakt. lékaře'
)
SELECT *
FROM czechia_district
WHERE code NOT IN (
	SELECT * 
	FROM not_completed_provider_info_district
);


WITH large_gdp_area AS (
	SELECT *
	FROM economies e 
	WHERE GDP > 70000000000
)
SELECT 
	ROUND(AVG(taxes), 2)
FROM large_gdp_area;




WITH large_gdp_area AS (
	SELECT *
	FROM economies e 
	WHERE GDP > 70000000000
),
large_gdp_area_2 AS (
	SELECT *
	FROM large_gdp_area e 
	WHERE GDP > 100000000000
)
SELECT 
	ROUND(AVG(taxes), 2)
FROM large_gdp_area_2;


/*
 * Window functions
 */


WITH sales_data AS (
    SELECT '2023-03-01' AS date, 'product 1' AS product, 40 AS sales
    UNION ALL
    SELECT '2023-03-02' AS date, 'product 1' AS product, 66 AS sales
    UNION ALL
    SELECT '2023-03-03' AS date, 'product 1' AS product, 50 AS sales
    UNION ALL
    SELECT '2023-03-03' AS date, 'product 1' AS product, 50 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 1' AS product, 9 AS sales
    UNION ALL
    SELECT '2023-03-06' AS date, 'product 1' AS product, 55 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 2' AS product, 15 AS sales
)
SELECT 
	*,
	SUM(sales) OVER (PARTITION BY product ORDER BY date) AS value_cumulative_sum_default,
	SUM(sales) OVER (PARTITION BY product ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS value_cumulative_sum,
	SUM(sales) OVER (PARTITION BY product ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS value_cumulative_sum_last_2,
	SUM(sales) OVER (PARTITION BY product ORDER BY date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS value_cumulative_sum_last_1_next_1
FROM sales_data;





WITH sales_data AS (
    SELECT '2023-03-01' AS date, 'product 1' AS product, 40 AS sales
    UNION ALL
    SELECT '2023-03-02' AS date, 'product 1' AS product, 66 AS sales
    UNION ALL
    SELECT '2023-03-03' AS date, 'product 1' AS product, 50 AS sales
    UNION ALL
    SELECT '2023-03-03' AS date, 'product 1' AS product, 50 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 1' AS product, 9 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 2' AS product, 15 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 3' AS product, 77 AS sales
)
SELECT
	*,
	RANK() OVER(PARTITION BY product ORDER BY date) AS value_rank,
	DENSE_RANK() OVER(PARTITION BY product ORDER BY date) AS value_dense_rank,
	ROW_NUMBER() OVER(PARTITION BY product ORDER BY date) AS value_dense_row_number
FROM sales_data;




WITH sales_data AS (
    SELECT '2023-03-01' AS date, 'product 1' AS product, 40 AS sales
    UNION ALL
    SELECT '2023-03-02' AS date, 'product 1' AS product, 66 AS sales
    UNION ALL
    SELECT '2023-03-03' AS date, 'product 1' AS product, 50 AS sales
    UNION ALL
    SELECT '2023-03-03' AS date, 'product 1' AS product, 50 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 1' AS product, 9 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 2' AS product, 15 AS sales
    UNION ALL
    SELECT '2023-03-05' AS date, 'product 3' AS product, 77 AS sales
)
SELECT
	*,
	LAG(sales, 2, 0) OVER(PARTITION BY product ORDER BY date) AS value_lag,
	LEAD(sales, 2, 0) OVER(PARTITION BY product ORDER BY date) AS value_lead,
	LAST_VALUE(sales) OVER(PARTITION BY product ORDER BY product) AS value_last_value,
	FIRST_VALUE(sales) OVER(PARTITION BY product ORDER BY product) AS value_first_value
FROM sales_data;



/*
 * HAVING
*/


-- nefunkcni
SELECT 
    industry_branch_code,
    AVG(value) AS total_sum
FROM
	czechia_payroll cp
WHERE
    payroll_year = 2018
    AND value_type_code = 316
    AND value IS NOT NULL
    AND AVG(value) > 100
GROUP BY
	  industry_branch_code;
	 
	
SELECT 
    industry_branch_code,
    AVG(value) AS total_sum
FROM
	czechia_payroll cp
WHERE
    payroll_year = 2018
    AND value_type_code = 316
    AND value IS NOT NULL
GROUP BY
	  industry_branch_code
HAVING AVG(value) > 50;
	 


/*
 * PIVOT
 */


WITH sales_data AS (
    SELECT 2023 AS year, 01 AS month, 'product 1' AS product, 490 AS sales
    UNION
    SELECT 2023 AS year, 01 AS month, 'product 2' AS product, 66 AS sales
    UNION
    SELECT 2023 AS year, 02 AS month, 'product 1' AS product, 50 AS sales
    UNION
    SELECT 2023 AS year, 01 AS month, 'product 1' AS product, 50 AS sales
    UNION
    SELECT 2023 AS [year], 01 AS month, 'product 1' AS product, 9 AS sales
    UNION
    SELECT 2022 AS [year], 01 AS month, 'product 1' AS product, 9 AS sales
)
SELECT * 
FROM sales_data
PIVOT (
	SUM(sales)
	FOR YEAR IN ([2023], [2022])
) AS pivot_table;
	 





	 




