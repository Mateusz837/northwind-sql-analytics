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

WITH TAB1 AS (
    SELECT custId, MAX(orderDate) AS latest_order_date
    FROM salesorder
    GROUP BY 1
)
SELECT *, TIMESTAMPDIFF(DAY, latest_order_date, CURRENT_DATE()) AS date_diff
FROM TAB1
WHERE TIMESTAMPDIFF(DAY, latest_order_date, CURRENT_DATE()) > 120;



-- Task 4: Average vs median order value


-- Task 5: Top product category per customer
