
-- =========================================================
-- Module 3: Conditional Logic & Pivoting
-- =========================================================

-- Task 1: CASE Conditional Logic – Order Classification

WITH order_revenue AS (
    SELECT od.orderId,
           SUM((od.unitPrice * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM salesorder so
    LEFT JOIN orderdetail od ON so.orderId = od.orderId
    GROUP BY od.orderId
)
SELECT orderId,
       ROUND(total_revenue, 2) AS total_revenue,
       CASE
           WHEN total_revenue < 100 THEN 'Small'
           WHEN total_revenue <= 500 THEN 'Medium'
           ELSE 'Large'
       END AS order_size
FROM order_revenue;

-- Task 2: Order status / operational labeling with CASE


-- Task 3: Pivot: revenue by category (conditional aggregation)


-- Task 4: Pivot: monthly revenue by selected categories


-- Task 5: Top-N within groups using window functions + filtering
