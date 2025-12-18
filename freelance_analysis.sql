DROP TABLE IF EXISTS freelance_skill_clean;
CREATE TABLE freelance_skill_clean AS
SELECT
    `Job Title` AS job_title,
    `EX_level_demand` AS experience_level,
    `Category_1` AS category,
    `Client_Country` AS country,
    `Payment_type` AS payment_type,

    -- Clean numeric fields
    CAST(TRIM(REPLACE(REPLACE(`Job_Cost`, '$', ''), ',', '')) AS DECIMAL(10,2)) AS job_cost,
    CAST(TRIM(REPLACE(REPLACE(`Start_rate`, '$', ''), ',', '')) AS DECIMAL(10,2)) AS start_rate,
    CAST(TRIM(REPLACE(REPLACE(`End_rate`, '$', ''), ',', '')) AS DECIMAL(10,2)) AS end_rate,

    -- Ratings & feedback
    CAST(TRIM(`Rating`) AS DECIMAL(4,2)) AS rating,
    CAST(TRIM(`Feedback_Num`) AS SIGNED) AS feedbacks

FROM freelance_skill_raw;

# Total number of projects
SELECT COUNT(*) AS total_projects
FROM freelance_skill_clean;
 
# To Experience level demand, which skill level clients prefer.
SELECT 
      experience_level,
      COUNT(*) AS total_jobs
FROM freelance_skill_clean
WHERE experience_level IS NOT NULL
GROUP BY experience_level
ORDER BY total_jobs DESC;

# Top 10 most in-demand categories, to show what skills are most needed.
SELECT
      category,
      COUNT(*) AS total_projects
FROM freelance_skill_clean
GROUP BY category
ORDER BY total_projects DESC
LIMIT 10;

# Rate segmentation within categories(CASE WHEN)
SELECT
	category,
    CASE
       WHEN end_rate < 20 THEN 'Low'
       WHEN end_rate BETWEEN 20 AND 50 THEN 'Medium'
       ELSE 'High'
	END AS rate_bucket,
    COUNT(*) AS total_projects
FROM freelance_skill_clean
WHERE end_rate >0
GROUP BY category, rate_bucket
ORDER BY category, total_projects DESC;


# Which client countries posting the most jobs
SELECT
	  country,
      COUNT(*) AS total_jobs
FROM freelance_skill_clean
GROUP BY country
ORDER BY total_jobs DESC
LIMIT 10;

# Hourly vs Fixed price distribution
SELECT
	  payment_type,
      COUNT(*) AS total_projects
FROM freelance_skill_clean
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY total_projects DESC;

# Average hourly rates (start & end)
SELECT
      ROUND(AVG(start_rate), 2) AS avg_start_rate,
      ROUND(AVG(end_rate), 2) AS avg_end_rate 
FROM freelance_skill_clean
WHERE start_rate > 0 AND end_rate >0;

# Highest paying categories (hourly)
SELECT
      category,
      ROUND(AVG(end_rate),2) AS avg_hourly_rate,
      COUNT(*) AS total_projects
FROM freelance_skill_clean
WHERE end_rate > 0
GROUP BY category
HAVING COUNT(*) > 20
ORDER BY avg_hourly_rate DESC
LIMIT 10;
      
# Average fixed job cost
SELECT
      ROUND(AVG(job_cost),2) AS avg_fixed_job_cost,
      MIN(job_cost) AS min_cost,
      MAX(job_cost) AS max_cost
FROM freelance_skill_clean
WHERE job_cost >0;

# Highest paying fixed-price categories
SELECT
      category,
      ROUND(AVG(job_cost),2) AS avg_job_cost,
      COUNT(*) AS total_projects
FROM freelance_skill_clean
WHERE job_cost > 0
GROUP BY category
HAVING COUNT(*) > 20
ORDER BY avg_job_cost DESC
LIMIT 10;

-- =====================================================
-- JOIN-BASED ANALYSIS (Relational SQL)
-- =====================================================

## Creating Dimension Tables

# Category dimension table
DROP TABLE IF EXISTS dim_category;
CREATE TABLE dim_category AS
SELECT DISTINCT 
       category
FROM freelance_skill_clean
WHERE category IS NOT NULL;

#Country dimension table
DROP TABLE IF EXISTS dim_country;
CREATE TABLE dim_country AS
SELECT DISTINCT 
       country
FROM freelance_skill_clean
WHERE country IS NOT NULL;

# Top categories using INNER JOIN
SELECT
	c.category,
    COUNT(*) AS total_projects
FROM freelance_skill_clean f
JOIN dim_category c
    ON f.category = c.category
GROUP BY c.category
ORDER BY total_projects DESC
LIMIT 10;

# Top client countries using INNER JOIN
SELECT
     d.country,
     COUNT(*) AS total_jobs
FROM freelance_skill_clean f 
JOIN dim_country d
     ON f.country = d.country
GROUP BY d.country
ORDER BY total_jobs DESC
LIMIT 10;

# Highest-Paying Freelance Skills by Country (Hourly Rates)
SELECT
    category,
    country,
    ROUND(AVG(end_rate),2) AS avg_hourly_rate,
    COUNT(*) AS total_projects
FROM freelance_skill_clean
WHERE end_rate > 0
GROUP BY category, country
HAVING COUNT(*) >=10
ORDER BY avg_hourly_rate DESC
LIMIT 15;
