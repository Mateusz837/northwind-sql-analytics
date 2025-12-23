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

CREATE FUNCTION discounted_price(price DECIMAL(10,2), disc DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(price * (1 - disc), 2);
END

-- Task 3: revenue(unit_price, quantity, discount) – revenue after discount

