-- =========================================================
-- Module 5: Date Dimension & Daily Activity
-- =========================================================

-- Task 1: Create dim_date (date table without gaps)

CREATE TABLE dim_date AS
WITH RECURSIVE date_range AS (
    SELECT DATE(MIN(orderDate)) AS start_date, DATE(MAX(orderDate)) AS end_date
    FROM salesorder
),
dates AS (
    SELECT start_date AS date_value, end_date FROM date_range
    UNION ALL
    SELECT DATE_ADD(date_value, INTERVAL 1 DAY), end_date FROM dates WHERE date_value < end_date
)
SELECT date_value,
       YEAR(date_value) AS year,
       MONTH(date_value) AS month,
       DAY(date_value) AS day,
       DAYNAME(date_value) AS day_name,
       WEEK(date_value) AS week_num
FROM dates;


-- Task 2: Days without orders (daily activity)















-- Task 3: Days without sales per month
