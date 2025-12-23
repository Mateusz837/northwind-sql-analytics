-- =========================================================
-- Module 1: Foundational Analysis
-- =========================================================

-- Task 1: Top 5 customers by revenue

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

-- Task 3: Customers with last order > 120 days ago

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

WITH order_revenue AS (
    SELECT od.orderId,
           SUM((od.unitPrice * od.quantity) * (1 - od.discount)) AS total_revenue
    FROM salesorder so
    LEFT JOIN orderdetail od ON so.orderId = od.orderId
    GROUP BY od.orderId
),
revenue_ranked AS (
    SELECT orderId, total_revenue,
           ROW_NUMBER() OVER (ORDER BY total_revenue) AS rn,
           COUNT(*) OVER () AS total_count
    FROM order_revenue
),
median_calc AS (
    SELECT AVG(total_revenue) AS median_value
    FROM revenue_ranked
    WHERE rn IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
),
average_calc AS (
    SELECT AVG(total_revenue) AS average_value
    FROM revenue_ranked
)
SELECT ROUND(median_value, 2) AS median,
       ROUND(average_value, 2) AS average
FROM median_calc, average_calc;

-- Task 5: Top product category per customer

WITH customer_category_qty AS (
    SELECT
        s.custId, c.companyName, cat.categoryName,
        SUM(od.quantity) AS total_qty
    FROM salesorder s
    LEFT JOIN customer c ON s.custId = c.custId
    LEFT JOIN orderdetail od ON s.orderId = od.orderId
    LEFT JOIN product p ON od.productId = p.productId
    LEFT JOIN category cat ON p.categoryId = cat.categoryId
    GROUP BY
        s.custId,c.companyName,cat.categoryName
),
ranked_categories AS (
    SELECT
        custId, companyName, categoryName, total_qty,
        DENSE_RANK() OVER (PARTITION BY custId ORDER BY total_qty DESC) AS category_rank
    FROM customer_category_qty
)
SELECT
    custId, companyName, categoryName, total_qty, category_rank
FROM ranked_categories
WHERE category_rank <= 5
ORDER BY custId, category_rank, categoryName;




















