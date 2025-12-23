-- =========================================================
-- Module 7: Stored Procedures
-- =========================================================

-- Task 1: GetCustomerOrders(cust_code) – list orders for a customer
-- comment: Useful for customer-service portals and account summaries

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
-- comment: A simple stored procedure for quick top-product lookups per market

