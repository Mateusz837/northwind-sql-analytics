
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

SELECT c.custId, c.companyName, COUNT(DISTINCT s.orderId) AS total_orders,
       SUM(CASE WHEN s.shippedDate IS NULL THEN 1 ELSE 0 END) AS pending_orders,
       SUM(CASE WHEN s.shippedDate IS NOT NULL THEN 1 ELSE 0 END) AS fully_delivered,
       CASE WHEN SUM(CASE WHEN s.shippedDate IS NULL THEN 1 ELSE 0 END) = 0
            THEN 'Fully_Delivered'
            ELSE 'Pending_Orders'
       END AS delivery_status
FROM salesorder s
LEFT JOIN customer c ON s.custId = c.custId
GROUP BY c.custId, c.companyName;


-- Task 3: Pivot: revenue by category (conditional aggregation)


-- Task 4: Pivot: monthly revenue by selected categories


-- Task 5: Top-N within groups using window functions + filtering
