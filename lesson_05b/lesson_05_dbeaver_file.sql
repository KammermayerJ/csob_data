
-- T-SQL
SELECT 
	TOP 20 PERCENT
	name,
	provider_type
FROM healthcare_provider hp;


-- pouze pro SQL
SELECT 
	name,
	provider_type
FROM healthcare_provider hp 
LIMIT 20;



SELECT 
	provider_id,
	region_code,
	name,
	provider_type
FROM healthcare_provider hp
ORDER BY region_code ASC, district_code DESC;



SELECT 
    *
FROM healthcare_provider
WHERE 
    region_code = 'CZ010'
    OR region_code = 'CZ020';
   
   
SELECT 
    name,
    LOWER(name) AS lower_name,
    UPPER(name) AS upper_name
FROM healthcare_provider 
WHERE LOWER(name) LIKE '%nemocnic_'; 


SELECT *
FROM czechia_district;



SELECT
    name, 
    municipality, 
    district_code
FROM healthcare_provider
WHERE 
    district_code IN ('CZ0425', 'CZ0421');

   
SELECT
    name, 
    municipality, 
    district_code
FROM healthcare_provider
WHERE 
    district_code = 'CZ0425'
   	OR district_code = 'CZ0421';
   
   
SELECT
    category_code,
    COUNT(id) AS rows_in_category,
    COUNT(1) AS rows_in_category,
    SUM(value) AS value_sum,
    MAX(value) AS value_max,
    MIN(value) AS value_min
FROM czechia_price
GROUP BY category_code
HAVING COUNT(id) > 4000;



SELECT CONCAT('Hi, ', 'Engeto lektor here! ', 6);
   


SELECT 
	name,
    SUBSTRING(name, 1, 2) AS prefix,
    REVERSE(SUBSTRING(REVERSE(name), 1, 2)) AS suffix,
    LEN(name)         
FROM czechia_price_category;
   
   
-- SQL
SELECT name,
    SUBSTRING(name, 1, 2) AS prefix,
    SUBSTRING(name, -2, 2) AS suffix, 
    LEN(name)         
FROM czechia_price_category;



SELECT
    *,
    CASE
        WHEN region_code = 'CZ010' THEN 1  
        WHEN region_code = 'CZ020' THEN 1        
        ELSE 0
    END AS is_from_prague
FROM healthcare_provider;


-- komentar

/*
 * JOIN
 */



SELECT 
	cp.id,
	cpc.name,
	cp.value 
FROM czechia_price cp 
JOIN czechia_price_category cpc 
	ON cpc.code = cp.category_code;



-- 101k
SELECT 
	 COUNT(1) AS total_number_rows 
FROM czechia_price cp 
JOIN czechia_region cr 
	ON cp.region_code = cr.code;



-- 108
SELECT 
	 COUNT(1) AS total_number_rows 
FROM czechia_price cp 
LEFT JOIN czechia_region cr 
	ON cp.region_code = cr.code;



SELECT
    cp.*, cr.name
FROM czechia_price AS cp
LEFT JOIN czechia_region AS cr
    ON cp.region_code = cr.code;
      
SELECT
    cp.*, cr.name
FROM czechia_region AS cr
RIGHT JOIN czechia_price AS cp
    ON cp.region_code = cr.code;
   
   
SELECT *
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cpc.code = cp.calculation_code 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cp.industry_branch_code 
LEFT JOIN czechia_payroll_unit cpu 
	ON cpu.code = cp.unit_code 
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cpvt.code = cp.value_type_code;


SELECT 
	code, 
	name AS name_new, 
	'region' AS country_part
FROM czechia_region cr 
UNION ALL
SELECT 
	code, 
	name, 
	'district'
FROM czechia_district cd;



/*
 * VIEW
 */


CREATE VIEW v_healthcare_provider_subset AS 
	SELECT
		provider_id, name, municipality, district_code 
	FROM healthcare_provider hp
	WHERE municipality IN ('Brno', 'Praha', 'Ostrava');


SELECT * FROM v_healthcare_provider_subset;


DROP VIEW IF EXISTS v_healthcare_provider_subset;



IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='t_resume_lektor_engeto' and xtype='U')
CREATE TABLE t_resume_lektor_engeto (
	date_start date,
	date_end date,
	education varchar(255),
	job varchar(255)
);


-- T-SQL
IF OBJECT_ID(N't_resume_lektor_engeto', N'U') IS NULL
CREATE TABLE t_resume_lektor_engeto (
	date_start date,
	date_end date,
	education varchar(255),
	job varchar(255)
);



-- T-SQL
SELECT 
	TOP 10 *
INTO t_providers_south_moravia_engeto_lektor
FROM healthcare_provider hp 
WHERE region_code = 'CZ064';


-- SQL
CREATE TABLE t_providers_south_moravia_engeto_lektor AS
	SELECT 
		TOP 10 *
	FROM healthcare_provider hp 
	WHERE region_code = 'CZ064';


-- TEMP tabulky
-- T-SQL
SELECT 
	TOP 10 *
INTO #t_providers_south_moravia_engeto_lektor
FROM healthcare_provider hp 
WHERE region_code = 'CZ064';


SELECT * FROM #t_providers_south_moravia_engeto_lektor;


DROP TABLE #t_providers_south_moravia_engeto_lektor;



IF OBJECT_ID(N't_resume_lektor_engeto', N'U') IS NULL
CREATE TABLE t_resume_lektor_engeto (
	date_start date,
	date_end date,
	education varchar(255),
	job varchar(255)
);


INSERT INTO t_resume_lektor_engeto 
VALUES ('2022-05-01', '2023-06-26', 'VUT', 'Engeto lektor');


SELECT * FROM t_resume_lektor_engeto;


INSERT INTO t_resume_lektor_engeto 
VALUES ('2022-05-01', '2023-06-26', 'VUT', null);



INSERT INTO t_resume_lektor_engeto (date_start, education)
VALUES ('2022-05-01', 'data analyst');


INSERT INTO t_resume_lektor_engeto (date_start, education)
VALUES ('2022-06-01', 'data analyst'),
('2022-07-01', 'data analyst'),
('2022-07-01', 'data analyst'),
('2022-07-01', 'data analyst'),
('2022-07-01', 'data analyst'),
('2022-07-01', 'data analyst');


ALTER TABLE t_resume_lektor_engeto ADD institution VARCHAR(255);


SELECT * FROM t_resume_lektor_engeto;


UPDATE t_resume_lektor_engeto
SET institution = 'Engeto academy'
WHERE date_start = '2022-07-01';


DELETE FROM t_resume_lektor_engeto 
WHERE date_start = '2022-05-01';



ALTER TABLE t_resume_lektor_engeto DROP COLUMN job;


-- T-SQL
EXEC sp_rename 't_resume_lektor_engeto.education', 'new_education', 'COLUMN';


-- SQL
ALTER TABLE t_resume_lektor_engeto RENAME COLUMN education TO new_education;


DROP TABLE IF EXISTS t_resume_lektor_engeto;
DROP TABLE IF EXISTS t_providers_south_moravia_engeto_lektor;






