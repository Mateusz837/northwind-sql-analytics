-- =========================================================
-- Module 2: Temporal & Statistical Analysis
-- =========================================================

-- Task 1: Top 3 products by revenue per country

WITH product_revenue_by_country AS (
    SELECT
        c.country, p.productName,
        SUM((od.unitPrice * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM salesorder s
    LEFT JOIN customer c ON s.custId = c.custId
    LEFT JOIN orderdetail od ON s.orderId = od.orderId
    LEFT JOIN product p ON od.productId = p.productId
    GROUP BY c.country, p.productName
),
ranked_products AS (
    SELECT
        country, productName, total_revenue,
        DENSE_RANK() OVER (PARTITION BY country ORDER BY total_revenue DESC) AS product_rank
    FROM product_revenue_by_country
)
SELECT
    country, productName, total_revenue, product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY country, product_rank;

-- Task 2: Month-over-month revenue change

WITH monthly_revenue AS (
    SELECT DATE_FORMAT(s.orderDate, '%Y-%m-01') AS month_start,
           SUM((od.unitPrice * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM salesorder s
    LEFT JOIN orderdetail od ON s.orderId = od.orderId
    GROUP BY DATE_FORMAT(s.orderDate, '%Y-%m-01')
)
SELECT month_start,
       ROUND(total_revenue, 2) AS revenue,
       ROUND(LAG(total_revenue) OVER (ORDER BY month_start), 2) AS prev_month_revenue,
       ROUND(total_revenue - LAG(total_revenue) OVER (ORDER BY month_start), 2) AS revenue_delta
FROM monthly_revenue
ORDER BY month_start;


-- Task 3: Product share within an order


-- Task 4: Order value quartiles


-- Task 5: Mean, median, and standard deviation of order values


-- Task 6: Cumulative revenue over time


-- Task 7: Month-over-month seasonality ratio


-- Task 8: Revenue trend approximation (rolling average)

