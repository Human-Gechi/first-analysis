-- 1. What is the gender breakdown of employees in the company?
use projects;
SELECT gender ,count(*) AS gender_count
FROM hr
WHERE Age >= 18 AND termdate = '' -- this condition exist to check current staff and staff whose ages are>= 18 because some birthdates were incorrect'
GROUP BY gender;
-- 2. What is the race/ethnicity breakdown of employeees in the company?
SELECT race ,count(*) AS race_count
FROM hr
WHERE Age >= 18 AND termdate = '' -- this condition exist to check current staff and staff whose ages are>= 18 because some birthdates were incorrect'
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees
select
	MIN(Age) as youngest,
    MAX(Age) as oldest -- to know the age range
FROM hr
WHERE Age>= 18 AND termdate = '';

SELECT 
    CASE 
        WHEN Age >= 18 AND Age <= 24 THEN '18-24'
        WHEN Age >= 25 AND Age <= 34 THEN '25-34'
        WHEN Age >= 35 AND Age <= 44 THEN '35-44'
        WHEN Age >= 45 AND Age <= 54 THEN '45-54'
        WHEN Age >= 55 AND Age <= 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,gender,
    COUNT(*) AS age_count
FROM hr
WHERE Age >= 18 AND (termdate IS NULL OR termdate = '' OR termdate = '0000-00-00')
GROUP BY age_group,gender
ORDER BY age_group,gender DESC;

-- 4. How many employees work at the headquaters versus remote locations
SELECT location , count(*) AS count
FROM hr
WHERE Age >= 18 AND (termdate IS NULL OR termdate = '' OR termdate = '0000-00-00')
GROUP BY location;

-- 5. Average lenght of employment for employees who have been terminated
SELECT 
    ROUND(AVG(DATEDIFF(termdate, hire_date)) / 365, 0) AS avg_termination
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND Age >= 18;
-- 6 Gender distributon across departments and jobtitles
SELECT department,gender,count(*) AS count
from hr
WHERE Age >= 18 AND (termdate IS NULL OR termdate = '' OR termdate = '0000-00-00')
GROUP BY department,gender
ORDER BY department;

-- 7. What is the distribution of jobtitles across the company
SELECT jobtitle ,count(*) as count
FROM hr
WHERE Age >= 18 AND (termdate IS NULL OR termdate = '' OR termdate = '0000-00-00')
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8.Which department has the highest turnover rate ?
SELECT department,
    total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
FROM (
    SELECT department,
        count(*) as total_count,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr 
    WHERE Age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;
-- 9 What is the distribution of employees across locationsa nd cities
SELECT location_state, count(*) as count
FROM hr
  WHERE Age >= 18 AND (termdate IS NULL OR termdate = '' OR termdate = '0000-00-00')
GROUP BY location_state
ORDER BY count DESC;
-- 10. How has the company's employee count changed overtime based on hire nad term dates?
SELECT 
 YEAR,
 hires,
 terminations,
 hires-terminations AS net_change,
 round((hires-terminations)/hires*100,2) AS percent_net_change
 FROM(
 SELECT 
 YEAR(hire_date) AS year,
 count(*) as hires,
 SUM(CASE when termdate <>'' AND termdate <= curdate() then 1 else 0 END) as terminations
FROM hr
 WHERE Age >= 18
 GROUP BY YEAR(hire_date)
 )AS subquery
 ORDER BY year ASC;
 -- 11. tenure dates in departments
SELECT department, ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS average
FROM HR
WHERE Age >= 18 
  AND termdate <= CURDATE()
  AND termdate <> '0000-00-00'
GROUP BY department;