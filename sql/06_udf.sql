-- =========================================================
-- Module 6: User-Defined Functions (UDF)
-- =========================================================

-- Task 1: order_age(order_date) – days since order
-- comment: Handy for computing order age directly in queries and for SLA checks

DELIMITER $$
CREATE FUNCTION order_age(order_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), order_date);
END $$
DELIMITER ;

SELECT orderId, orderDate, order_age(orderDate) AS days_since_order
FROM salesorder

-- Task 2: discount(price, discount) – compute discounted price
-- comment: Encapsulating discount calculation ensures consistency across reports
    
DELIMITER $$
CREATE FUNCTION discounted_price(price DECIMAL(10,2), disc DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(price *(1 - disc), 2);
END $$
DELIMITER ;

SELECT orderId, unitPrice, discount, 
       discounted_price(unitPrice, discount) AS final_price
FROM orderdetail

-- Task 3: revenue(unit_price, quantity, discount) – revenue after discount
-- comment: Simplifies revenue calculations in queries and improves readability
    
DELIMITER $$

CREATE FUNCTION Revenue(unit_price DECIMAL(10,2), quantity INT, discount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND((unit_price * quantity) * (1 - discount), 2);
END $$

DELIMITER ;

SELECT o.orderId,
       SUM(Revenue(o.unitPrice, o.quantity, o.discount)) AS total_rev
FROM orderdetail o
GROUP BY o.orderId;

