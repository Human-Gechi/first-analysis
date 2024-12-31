CREATE DATABASE Projects;
use projects;

SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id varchar(20); -- changing the first column name for easy identification

SELECT birthdate from hr;

SET SQL_SAFE_UPDATES =0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
		WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'), '%Y-%m-%d') -- changing the date fromat to the satndard date format year month day
    ELSE NULL
END;
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT * FROM hr;
UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')) -- converting the date if it doesn't confrom to the appropriate date time fromat then extract just the date from the timestamp
WHERE termdate IS NOT NULL AND TRIM(termdate) != '';

ALTER TABLE hr
ADD COLUMN Age INT; -- Adding a new column to calculate the age of employees

UPDATE hr
SET Age = timestampdiff(YEAR,birthdate, curdate());

SELECT
	MIN(Age) as youngest,
    MAX(Age) as oldest
FROM hr;
SELECT COUNT(*) FROM hr
	WHERE Age <=18;