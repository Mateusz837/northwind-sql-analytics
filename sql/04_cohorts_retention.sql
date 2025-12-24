-- =========================================================
-- Module 4: Cohorts & Retention Analysis
-- =========================================================

-- Task 1: Identifying Date of First Purchase 
-- Assign each customer to the month of their first purchase to enable cohort tracking 

SELECT
    s.custId, c.companyName,
    MIN(DATE_FORMAT(s.orderDate, '%Y-%m-01')) AS cohort_mnth,
    MIN(DATE(s.orderDate)) AS first_purchase
FROM salesorder s
LEFT JOIN customer c ON s.custId = c.custId
GROUP BY s.custId, c.companyName
ORDER BY cohort_mnth;

-- Task 2: Number of Returning Customers Month-by-Month
-- Track how many customers from each cohort return in subsequent months to measure loyalty

WITH cohort AS (
    SELECT s.custId, c.companyName,
           MIN(DATE_FORMAT(s.orderDate, '%Y-%m-01')) AS cohort_mnth,
           MIN(DATE(s.orderDate)) AS first_purchase
    FROM salesorder s
    LEFT JOIN customer c ON s.custId = c.custId
    GROUP BY s.custId, c.companyName
)
SELECT ch.cohort_mnth,
       DATE_FORMAT(s.orderDate, '%Y-%m-01') AS order_month,
       COUNT(DISTINCT s.custId) AS active_customers
FROM cohort ch
INNER JOIN salesorder s ON ch.custId = s.custId
GROUP BY ch.cohort_mnth, order_month
ORDER BY ch.cohort_mnth, order_month;

-- Task 3: Calculating Month-on-Month Retention Rate
-- Express retention as a percentage of the cohort to normalize across cohort sizes

 WITH cohort AS (
    SELECT s.custId, c.companyName,
           MIN(DATE_FORMAT(s.orderDate, '%Y-%m-01')) AS cohort_mnth,
           MIN(DATE(s.orderDate)) AS first_purchase
    FROM salesorder s
    LEFT JOIN customer c ON s.custId = c.custId
    GROUP BY s.custId, c.companyName
),
active_customers AS (
    SELECT ch.cohort_mnth,
           DATE_FORMAT(s.orderDate, '%Y-%m-01') AS order_month,
           COUNT(DISTINCT s.custId) AS active_customers
    FROM cohort ch
    INNER JOIN salesorder s ON ch.custId = s.custId
    GROUP BY ch.cohort_mnth, order_month
)
SELECT cohort_mnth, order_month, active_customers,
       TIMESTAMPDIFF(MONTH, cohort_mnth, order_month) AS month_index,
       ROUND(active_customers / MAX(active_customers) OVER (PARTITION BY cohort_mnth) * 100, 2) AS retention_rate
FROM active_customers
ORDER BY cohort_mnth, order_month;

-- Task 4: Return Analysis – Time to Repurchase (Days Between Orders)
-- Understand typical time between purchases to time marketing and replenishment triggers.

WITH customer_orders AS (
    SELECT s.custId, DATE(s.orderDate) AS order_date
    FROM salesorder s
    LEFT JOIN customer c ON s.custId = c.custId
    GROUP BY s.custId, DATE(s.orderDate)
),
orders_with_prev AS (
    SELECT custId, order_date,
           LAG(order_date) OVER (PARTITION BY custId ORDER BY order_date) AS prev_date
    FROM customer_orders
),
order_gaps AS (
    SELECT custId, order_date, prev_date,
           TIMESTAMPDIFF(DAY, prev_date, order_date) AS diff_dates
    FROM orders_with_prev
)
SELECT DISTINCT custId,
       ROUND(AVG(diff_dates) OVER (PARTITION BY custId)) AS avg_days_between_orders
FROM order_gaps
WHERE diff_dates IS NOT NULL;



