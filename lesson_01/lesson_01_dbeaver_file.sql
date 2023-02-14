use SKOLENI_DT;
GO

SELECT *
FROM dbo.healthcare_provider;



SELECT 
	name,
	provider_type 
FROM healthcare_provider hp;


-- T-SQL
SELECT 
	TOP 20
	name,
	provider_type 
FROM healthcare_provider hp;

-- SQL
SELECT 
	name,
	provider_type 
FROM healthcare_provider hp
LIMIT 20;


-- line coment

/*

block comment

*/


SELECT *
FROM healthcare_provider hp 
ORDER BY region_code ASC; -- sestupne DESC


SELECT 
	TOP 500
	name,
	region_code,
	district_code
FROM healthcare_provider hp 
ORDER BY district_code DESC;

-- T-SQL
SELECT 
	name,
	region_code,
	district_code
FROM healthcare_provider hp 
ORDER BY district_code DESC
OFFSET 5 ROWS 
FETCH NEXT 10 ROWS ONLY;

-- SQL mysql, posgre
SELECT 
	name,
	region_code,
	district_code
FROM healthcare_provider hp 
ORDER BY district_code DESC
LIMIT 10 OFFSET 5;



-- tohle nefunguje
SELECT 
	TOP 10
	name,
	region_code,
	district_code
FROM healthcare_provider hp 
ORDER BY district_code DESC
OFFSET 5 ROWS;


-- vypise opuze prvni 1 procento zaznamu

SELECT 
	TOP 1 PERCENT
	name,
	region_code,
	district_code
FROM healthcare_provider hp 


/**
 * WHERE 
 */

SELECT 
	*
FROM healthcare_provider hp 
WHERE 
	region_code = 'CZ010';



SELECT 
	name,
	phone,
	fax,
	email,
	website,
	region_code
FROM healthcare_provider hp
WHERE 
	region_code != 'CZ010';

-- ekvivalentni dotazy
SELECT 
	name,
	phone,
	fax,
	email,
	website,
	region_code
FROM healthcare_provider hp
WHERE 
	region_code <> 'CZ010';


SELECT 
	name,
	region_code,
	residence_region_code 
FROM healthcare_provider hp
WHERE region_code = residence_region_code;


SELECT 
	name,
	phone
FROM healthcare_provider hp 
WHERE 
	phone IS NOT NULL;


SELECT *
FROM czechia_district cd;

SELECT 
	name,
	district_code 
FROM healthcare_provider hp
WHERE 
	district_code = 'CZ0201'
	OR district_code = 'CZ0202'
ORDER BY district_code ASC
;


-- T-SQL

SELECT 
	TOP 10
	*
INTO t_providers_south_moravia_engeto_lektor
FROM healthcare_provider hp 
WHERE 
	region_code = 'CZ064';

SELECT *
FROM t_providers_south_moravia_engeto_lektor;


/**
 * CREATE TABLE
 */


-- SQL - mysql, postgre

CREATE TABLE t_providers_south_moravia_engeto_lektor AS 
	SELECT 
		*
	FROM healthcare_provider hp 
	WHERE 
		region_code = 'CZ064';

	

CREATE TABLE t_resume_lektor_engeto (
	date_start date,
	date_end date,
	education varchar(255),
	job  varchar(255)
);


CREATE TABLE t_resume_02 (
	date_start date,
	date_end date,
	education varchar(255),
	job  varchar(255)
);


SELECT *
FROM t_resume_lektor_engeto;


-- YYYY-MM-DD
INSERT INTO t_resume_lektor_engeto 
VALUES ('2020-05-01', '2022-04-20', 'VUT', 'Engeto lektor');


INSERT INTO t_resume_lektor_engeto (date_start, education)
VALUES ('2020-05-01', 'Engeto lektor');

INSERT INTO t_resume_lektor_engeto (education, date_start)
VALUES ('Engeto lektor', '2020-05-01');

INSERT INTO t_resume_lektor_engeto VALUES 
('2020-05-01', '2022-04-20', 'VUT', null),
('2020-05-01', '2022-04-20', 'VUT', 'Developer')
;



ALTER TABLE t_resume_lektor_engeto ADD institution VARCHAR(255);


UPDATE t_resume_lektor_engeto 
SET institution = 'Engeto Academy'
WHERE date_end IS NULL;



SELECT *
FROM t_resume_lektor_engeto;


EXEC sp_rename 't_resume_lektor_engeto.institution', 'institution_new', 'COLUMN';


-- SQL mysql, postgre

ALTER TABLE t_resume_lektor_engeto RENAME COLUMN institution TO institution_new;


ALTER TABLE t_resume_lektor_engeto DROP COLUMN institution_new;


DROP TABLE IF EXISTS t_resume_lektor_engeto;
DROP TABLE IF EXISTS t_providers_south_moravia_engeto_lektor;



