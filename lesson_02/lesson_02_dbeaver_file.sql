

SELECT 
	name,
	provider_type 
FROM healthcare_provider
ORDER BY name ASC;



SELECT 
	name,
	provider_type 
FROM healthcare_provider
ORDER BY TRIM(name) ASC;


SELECT TRIM('   aaaaa ') AS nazev;

SELECT LTRIM('   aaaaa ') AS nazev;

SELECT RTRIM('   aaaaa ') AS nazev;

SELECT TRIM('-' FROM '--aaaaa ') AS nazev;


SELECT    
	name, 
	provider_type 
FROM healthcare_provider
ORDER BY RTRIM(LTRIM(name));



SELECT  
	provider_id,  
	name, 
	provider_type,
	region_code, 
	district_code 
FROM healthcare_provider
ORDER BY region_code, district_code; 



SELECT 
	*
FROM czechia_district
ORDER BY code DESC;




SELECT 
	TOP 5 
	*
FROM czechia_region 
ORDER BY name DESC;


SELECT 
	*
FROM (
	SELECT 
		TOP 5 
		*
	FROM czechia_region cr
	ORDER BY name DESC	
) AS rt
ORDER BY rt.name;


SELECT 
	name,
	provider_type 
FROM healthcare_provider 
ORDER BY provider_type ASC, name DESC;



/*
 * CASE
 */


SELECT 
	*,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_prague	
FROM healthcare_provider;



SELECT 
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_prague,
	name,
	provider_id 
FROM healthcare_provider;



SELECT 
	*,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_prague	
FROM healthcare_provider
WHERE region_code = 'CZ010';


SELECT 
	*,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_prague	
FROM healthcare_provider
WHERE is_from_prague = 1;


SELECT 
	*
FROM (
	SELECT 
		*,
		CASE
			WHEN region_code = 'CZ010' THEN 1
			ELSE 0
		END AS is_from_prague	
	FROM healthcare_provider
) hp
WHERE hp.is_from_prague = 1;


SELECT 
	*,
	CASE
		WHEN region_code = 'CZ010' OR region_code = 'CZ020' THEN 1
		WHEN region_code = 'CZ063' THEN 4
		WHEN region_code = 'CZ080' THEN 5
		-- ELSE 0
	END AS is_from_prague	
FROM healthcare_provider;

/*
 * 
 * nejmene 12
 * nejvice 18
 * 
 */

SELECT 
	longitude 
FROM healthcare_provider
WHERE longitude IS NOT NULL
ORDER BY longitude DESC;


SELECT 
	 MAX(longitude) AS max_val,
	 MIN(longitude) AS min_val
FROM healthcare_provider
WHERE longitude IS NOT NULL
;



SELECT 
	name,
	municipality,
	longitude,
	CASE 
		WHEN longitude < 14 THEN 'nejvice na zapade'
		WHEN longitude < 16 THEN 'mene na zapade'
		WHEN longitude < 18 THEN 'vice na vychode'
		ELSE 'nejvice na vychode'
	END AS cze_position	
FROM healthcare_provider;


SELECT 
	name,
	provider_type,
	CASE 
		WHEN provider_type = 'Lékárna' THEN 1
		WHEN provider_type = 'Výdejna zdravotnických prostředků' THEN 1
		ELSE 0
	END AS is_desire_type	
FROM healthcare_provider;


-- ekvivaletni dotazy
SELECT 
	name,
	provider_type,
	CASE 
		WHEN provider_type = 'Lékárna' OR provider_type = 'Výdejna zdravotnických prostředků' THEN 1
		ELSE 0
	END AS is_desire_type	
FROM healthcare_provider;


-- ekvivaletni dotazy
SELECT 
	name,
	provider_type,
	CASE 
		WHEN provider_type IN ('Lékárna', 'Výdejna zdravotnických prostředků', '....') THEN 1
		ELSE 0
	END AS is_desire_type	
FROM healthcare_provider;


/*
 * WHERE - LIKE a IN
 *  
 */


SELECT 
	name
FROM healthcare_provider
WHERE LOWER(name) LIKE '%nemocnice%';


SELECT 
	name,
	LOWER(name) AS name_lower,
	UPPER(name) AS name_upper
FROM healthcare_provider
WHERE name LIKE '%nemocnice';


SELECT 
	name,
	CASE
		WHEN name LIKE 'lékárna%' THEN 1
		ELSE 0
	END AS starts_with_seached_name	
FROM healthcare_provider
WHERE name LIKE '%lékárna%';


/*
 * '_' = 1 znak v LIKE
 */

SELECT 
	name,
	municipality 
FROM healthcare_provider
WHERE municipality LIKE '____';




SELECT 
	name,
	municipality 
FROM healthcare_provider
WHERE municipality LIKE 'B_n_';




SELECT 	
	DISTINCT 
	municipality,
	LEN(municipality)
FROM healthcare_provider
WHERE LEN(municipality) = 4;



SELECT *
FROM czechia_district
ORDER BY name;


SELECT 
	name,
	municipality,
	district_code 
FROM healthcare_provider
WHERE 
	municipality IN ('Brno', 'Praha', 'Ostrava')
	OR district_code IN ('CZ0421', 'CZ0425')
	;


SELECT *
FROM czechia_district
WHERE name IN ('Most', 'Děčín');


SELECT 
	name,
	municipality,
	district_code 
FROM healthcare_provider
WHERE 
	municipality IN ('Brno', 'Praha', 'Ostrava')
	OR district_code IN (
		SELECT 
			code
		FROM czechia_district
		WHERE name IN ('Most', 'Děčín')
	);





SELECT 
	provider_id,
	name,
	region_code 
FROM healthcare_provider
WHERE region_code IN (
	SELECT 
		code
	FROM czechia_region
	WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj')
);


SELECT 
	code
FROM czechia_region
WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj');

-- ekvivalentni
SELECT 
	code
FROM czechia_region
WHERE
	name = 'Jihomoravský kraj'
	OR name = 'Středočeský kraj';





SELECT 
	*
FROM czechia_region
WHERE name LIKE 'Jihomoravský%';


SELECT 
	*
FROM czechia_region
WHERE
	name = 'Jihomoravský kraj';



SELECT *
FROM czechia_district
WHERE code IN (
	SELECT 
		district_code 
	FROM healthcare_provider 
	WHERE municipality LIKE '____'
);



/**
 * VIEW
 */


CREATE VIEW v_healthcare_provider_subset_XX AS
	SELECT
		provider_id,
		name,
		region_code,
		CASE
			WHEN name LIKE 'lékárna%' THEN 1
			ELSE 0
		END AS starts_with_seached_name	
	FROM healthcare_provider
	WHERE 
		municipality IN ('Brno', 'Praha', 'Ostrava')
;
	

SELECT * 
FROM v_healthcare_provider_subset_XX;


SELECT 
	*
FROM healthcare_provider
WHERE provider_id NOT IN (
	SELECT 
		provider_id 
	FROM v_healthcare_provider_subset_XX
);


DROP VIEW IF EXISTS v_healthcare_provider_subset_XX;


SELECT 
	CASE 
		WHEN ss.num = 5 THEN 1
		WHEN ss.num < 5 THEN 2
		ELSE 0
	END AS is_case_exp,
	IIF(ss.num = 5, 1, 0) AS if_exp
FROM (
	SELECT 5 AS num
	UNION ALL
	SELECT 4 AS num
) ss;


-- SQL IF(ss.num = 5, 1, 0) AS if_exp vs T-SQL IIF


SELECT COALESCE(NULL, NULL, '123', NULL);

SELECT ISNULL(ss.num, 'aaaa')
FROM (
	SELECT NULL AS num
) ss;



SELECT NULLIF(25, 25);






