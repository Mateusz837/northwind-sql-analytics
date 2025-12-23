-- =========================================================
-- Module 4: Cohorts & Retention Analysis
-- =========================================================

-- Task 1: Identifying Date of First Purchase 

SELECT
    s.custId, c.companyName,
    MIN(DATE_FORMAT(s.orderDate, '%Y-%m-01')) AS cohort_mnth,
    MIN(DATE(s.orderDate)) AS first_purchase
FROM salesorder s
LEFT JOIN customer c ON s.custId = c.custId
GROUP BY s.custId, c.companyName
ORDER BY cohort_mnth;


-- Task 2: Number of Returning Customers Month-by-Month


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



-- Task 3: Retention rate by cohort (percentage of active customers)


-- Task 4: Cohort revenue over time (optional: if included in your Word version)


-- Task 5: Cohort-level KPIs (e.g., avg order value, orders per customer)

