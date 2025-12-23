-- =========================================================
-- Module 5: Date Dimension & Daily Activity
-- =========================================================

-- Task 1: Create dim_date (date table without gaps)
-- comment: a robust dim_date allows consistent joins and prevents missing-date issues in aggregations.

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

-- Task 2. Days without orders (daily activity)
-- comment: Identify days with zero orders to spot anomalies or expected closures.

SELECT d.date_value, COUNT(DISTINCT s.orderId) AS order_count
FROM dim_date d
LEFT JOIN salesorder s ON DATE(s.orderDate) = d.date_value
GROUP BY d.date_value
HAVING COUNT(DISTINCT s.orderId) = 0;


-- Task 3: Days without sales per month
-- comment: Use to monitor operational days missed per month and to investigate causes.

SELECT d.year, d.month,
       SUM(CASE WHEN s.orderId IS NULL THEN 1 ELSE 0 END) AS no_sales_days
FROM dim_date d
LEFT JOIN salesorder s ON DATE(s.orderDate) = d.date_value
GROUP BY d.year, d.month
ORDER BY d.year, d.month;


