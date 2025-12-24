-- =========================================================
-- Module 7: Stored Procedures
-- =========================================================

-- Task 1: GetCustomerOrders(cust_code) – list orders for a customer
-- Useful for customer-service portals and account summaries

DELIMITER $$

CREATE PROCEDURE GetCustomerOrders (IN cust_code INT)
BEGIN
    SELECT s.orderId,
           s.orderDate,
           s.shipCountry,
           SUM(o.quantity * o.unitPrice) AS total_value
    FROM salesorder s
    LEFT JOIN orderdetail o ON s.orderId = o.orderId
    WHERE s.custId = cust_code
    GROUP BY s.orderId, s.orderDate, s.shipCountry
    ORDER BY s.orderDate;
END $$

DELIMITER ;

CALL GetCustomerOrders(34);

-- Task 2: Product_Country(country) – top products by country
-- A simple stored procedure for quick top-product lookups per market

DELIMITER $$

CREATE PROCEDURE Product_Country(IN country VARCHAR(20))
BEGIN
    SELECT productName,
           total_sold,
           DENSE_RANK() OVER (ORDER BY total_sold DESC) AS rnk
    FROM (
        SELECT p.productName,
               SUM(od.quantity) AS total_sold
        FROM salesorder s
        LEFT JOIN orderdetail od ON s.orderId = od.orderId
        LEFT JOIN product p ON p.productId = od.productId
        WHERE s.shipCountry = country
        GROUP BY p.productName
    ) tab1
    WHERE total_sold IS NOT NULL
    ORDER BY total_sold DESC
    LIMIT 5;
END $$

DELIMITER ;

CALL Product_Country('Germany');
