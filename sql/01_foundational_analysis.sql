-- =========================================================
-- Module 1: Foundational Analysis
-- =========================================================

-- Task 1: Top customers by revenue

WITH customer_revenue AS (
    SELECT
        c.custId, c.companyName,
        SUM((od.unitPrice * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM salesorder so
    LEFT JOIN customer c
        ON so.custId = c.custId
    LEFT JOIN orderdetail od
        ON so.orderId = od.orderId
    GROUP BY
        c.custId, c.companyName
),
ranked_customers AS (
    SELECT
        custId, companyName, total_revenue,
        DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM customer_revenue
)
SELECT
    custId, companyName, total_revenue, revenue_rank
FROM ranked_customers
WHERE revenue_rank <= 5
ORDER BY total_revenue DESC;

-- Task 2: Products never ordered

SELECT p.productId
FROM product AS p
WHERE NOT EXISTS (
    SELECT *
    FROM orderdetail AS sod
    WHERE sod.productId = p.productId
);

-- Task 3: Inactive customers (120+ days)

WITH last_order AS (
    SELECT custId, MAX(orderDate) AS latest_order_date
    FROM salesorder
    GROUP BY custId
),
inactive_customers AS (
    SELECT
        custId, latest_order_date,
        TIMESTAMPDIFF(DAY, latest_order_date, CURRENT_DATE()) AS days_since_last_order
    FROM last_order
)
SELECT custId, latest_order_date, days_since_last_order
FROM inactive_customers
WHERE days_since_last_order > 120
ORDER BY days_since_last_order DESC;

-- Task 4: Average vs median order value


-- Task 5: Top product category per customer
