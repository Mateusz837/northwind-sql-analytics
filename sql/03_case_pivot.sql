
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

WITH yearly_category_revenue AS (
    SELECT YEAR(s.orderDate) AS YR,
           ce.categoryName,
           ROUND(SUM((o.unitPrice * o.quantity) * (1 - o.discount)), 2) AS total_revenue
    FROM salesorder s
    LEFT JOIN orderdetail o ON s.orderId = o.orderId
    LEFT JOIN product p ON o.productId = p.productId
    LEFT JOIN category ce ON p.categoryId = ce.categoryId
    GROUP BY YEAR(s.orderDate), ce.categoryName
)
SELECT YR,
       SUM(CASE WHEN categoryName = 'Beverages' THEN total_revenue ELSE 0 END) AS Beverages,
       SUM(CASE WHEN categoryName = 'Condiments' THEN total_revenue ELSE 0 END) AS Condiments,
       SUM(CASE WHEN categoryName = 'Confections' THEN total_revenue ELSE 0 END) AS Confections,
       SUM(CASE WHEN categoryName = 'Dairy Products' THEN total_revenue ELSE 0 END) AS `Dairy Products`,
       SUM(CASE WHEN categoryName = 'Grains/Cereals' THEN total_revenue ELSE 0 END) AS `Grains/Cereals`,
       SUM(CASE WHEN categoryName = 'Meat/Poultry' THEN total_revenue ELSE 0 END) AS `Meat/Poultry`,
       SUM(CASE WHEN categoryName = 'Produce' THEN total_revenue ELSE 0 END) AS Produce,
       SUM(CASE WHEN categoryName = 'Seafood' THEN total_revenue ELSE 0 END) AS Seafood
FROM yearly_category_revenue
GROUP BY YR;


-- Task 4: Rolling Average + CASE – Trend Analysis

WITH monthly_revenue AS (
    SELECT DATE_FORMAT(s.orderDate, '%Y-%m-01') AS mnth,
           ROUND(SUM((o.unitPrice * o.quantity) * (1 - o.discount)), 2) AS total_revenue
    FROM salesorder s
    LEFT JOIN orderdetail o ON s.orderId = o.orderId
    GROUP BY DATE_FORMAT(s.orderDate, '%Y-%m-01')
),
moving_average AS (
    SELECT mnth, total_revenue,
           ROUND(AVG(total_revenue) OVER (ORDER BY mnth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS three_month_avg
    FROM monthly_revenue
)
SELECT mnth, total_revenue, three_month_avg,
       CASE
           WHEN total_revenue < three_month_avg THEN 'Below Trend'
           WHEN total_revenue = three_month_avg THEN 'Within Trend'
           ELSE 'Above Trend'
       END AS trend_status
FROM moving_average
ORDER BY mnth;


