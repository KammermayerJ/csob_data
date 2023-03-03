


SELECT *
FROM czechia_price
JOIN czechia_price_category
	ON czechia_price.category_code = czechia_price_category.code;




SELECT 
	cp.id,
	cpc.name,
	cp.value 
FROM czechia_price cp 
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code;





SELECT 
	COUNT(1) AS total_row_count
FROM czechia_price cp 
LEFT JOIN czechia_region cr 
	ON cp.region_code = cr.code;


SELECT 
	COUNT(1) AS total_row_count
FROM czechia_price cp 
JOIN czechia_region cr 
	ON cp.region_code = cr.code;


SELECT 
	cp.*,
	cr.name 
FROM czechia_price cp 
LEFT JOIN czechia_region cr 
	ON cr.code = cp.region_code;

-- ekvivaletni dotazy
SELECT 
	cp.*,
	cr.name 
FROM czechia_region cr 
RIGHT JOIN czechia_price cp 
	ON cp.region_code = cr.code;




SELECT *
FROM czechia_payroll cp 
JOIN czechia_payroll_calculation cpc 
	ON cpc.code = cp.calculation_code 
JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cp.industry_branch_code 
JOIN czechia_payroll_unit cpu 
	ON cpu.code = cp.unit_code 
JOIN czechia_payroll_value_type cpvt 
	ON cpvt.code = cp.value_type_code;


SELECT
    *
FROM czechia_payroll_industry_branch
WHERE code IN (
    SELECT
        industry_branch_code
    FROM czechia_payroll
    WHERE value IN (
        SELECT
            MAX(value)
        FROM czechia_payroll
        WHERE value_type_code = 5958
    )
);


SELECT 
	TOP 1 cpib.*
FROM czechia_payroll_industry_branch cpib 
JOIN czechia_payroll cp 
	ON cp.industry_branch_code = cpib.code
WHERE 
	cp.value_type_code = 5958
ORDER BY cp.value DESC; 



SELECT 
	cpc.name AS food_category,
	cp.value AS price,
	cpib.name AS industry,
	cpay.value AS average_wages,
	cp.date_from,
	FORMAT(cp.date_from, 'dd.MM.yyyy'),
	FORMAT(cp.date_from, 'dddd, MMMM, yyyy', 'cs-cz'),
	cpay.payroll_year 
FROM czechia_price cp 
JOIN czechia_payroll cpay
	ON YEAR(cp.date_from) = cpay.payroll_year 
	AND cpay.value_type_code = 5958
	AND cp.region_code IS NULL
JOIN czechia_price_category cpc 
	ON cpc.code = cp.category_code 
JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cpay.industry_branch_code;




SELECT *
FROM healthcare_provider hp 
WHERE hp.district_code IS NULL;




SELECT 
	hp.name,
	cr.name AS region_name,
	cr2.name AS residence_region_name,
	cd.name AS district_name,
	cd2.name AS residence_district_name
FROM healthcare_provider hp
LEFT JOIN czechia_region cr 
	ON cr.code = hp.region_code
LEFT JOIN czechia_region cr2
	ON cr2.code = hp.residence_region_code 
LEFT JOIN czechia_district cd 
	ON cd.code = hp.district_code 
LEFT JOIN czechia_district cd2 
	ON cd2.code = hp.residence_district_code;




SELECT 
	hp.name,
	cr.name AS region_name,
	cr2.name AS residence_region_name,
	cd.name AS district_name,
	cd2.name AS residence_district_name
FROM healthcare_provider hp
LEFT JOIN czechia_region cr 
	ON cr.code = hp.region_code
LEFT JOIN czechia_region cr2
	ON cr2.code = hp.residence_region_code 
LEFT JOIN czechia_district cd 
	ON cd.code = hp.district_code 
LEFT JOIN czechia_district cd2 
	ON cd2.code = hp.residence_district_code
WHERE 
	hp.region_code != hp.residence_region_code 
	AND hp.district_code != hp.residence_district_code;



/**
 * 
 * Kartezsky soucin
 */


SELECT *
FROM czechia_price cp, czechia_price_category cpc
WHERE cp.category_code = cpc.code;



SELECT *
FROM czechia_price cp
CROSS JOIN czechia_price_category cpc 
WHERE cp.category_code = cpc.code;



SELECT 
	cr.name AS first_region,
	cr2.name AS second_region
FROM czechia_region cr 
CROSS JOIN czechia_region cr2
WHERE cr.code != cr2.code;


/**
 * 
 * Mnozinove operace
 */




SELECT category_code, value
FROM czechia_price
WHERE region_code IN ('CZ064', 'CZ010');


SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION ALL
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';


SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';


SELECT *
FROM (
	SELECT 
		code, name, 'region' AS country_part
	FROM czechia_region cr 
	UNION
	SELECT 
		code, name, 'district' AS country_part
	FROM czechia_district cd  
) country_parts
ORDER BY code;




SELECT 
	category_code, 
	value 
FROM czechia_price cp 
WHERE region_code = 'CZ064'
INTERSECT 
SELECT 
	category_code, 
	value 
FROM czechia_price cp 
WHERE region_code = 'CZ010';




SELECT 
	cpib.*,
	cp.id,
	cp.value 
FROM czechia_payroll cp 
JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cp.industry_branch_code
WHERE value IN (
	SELECT value
	FROM czechia_payroll cp 
	WHERE industry_branch_code = 'A'
	INTERSECT 
	SELECT value
	FROM czechia_payroll cp 
	WHERE industry_branch_code = 'B'
);


SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ064'
EXCEPT 
SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ010';


SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ010'
EXCEPT 
SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ064';




(SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ064'
EXCEPT 
SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ010')
INTERSECT 
(SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ010'
EXCEPT 
SELECT category_code, value 
FROM czechia_price cp 
WHERE region_code = 'CZ064');






