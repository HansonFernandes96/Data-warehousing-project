--Task -2
-- Calculate total revenue for each product
SELECT 
    P.ProductID,
    P.Name AS ProductName,
    SUM(O.Quantity * O.TotalPrice) AS TotalRevenue
FROM 
    Orders O
INNER JOIN 
    Products P ON O.ProductID = P.ProductID
GROUP BY 
    P.ProductID, P.Name
ORDER BY 
    TotalRevenue DESC
LIMIT 5;

-- Identify repeat customers (customers with more than one order)
SELECT 
    C.CustomerID,
    C.Name AS CustomerName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders
FROM 
    Customers C
INNER JOIN 
    Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.CustomerID, C.Name
HAVING 
    COUNT(DISTINCT O.OrderID) > 1
ORDER BY 
    TotalOrders DESC;

-- Show all products and their orders (including products with no orders)
SELECT 
    P.ProductID,
    P.Name AS ProductName,
    SUM(O.Quantity) AS TotalOrdered
FROM 
    Products P
LEFT JOIN 
    Orders O ON P.ProductID = O.ProductID
GROUP BY 
    P.ProductID, P.Name;


-- Filter orders where the status is 'Complete'
SELECT 
    O.OrderID,
    C.Name AS CustomerName,
    O.Status
FROM 
    Orders O
INNER JOIN 
    Customers C ON O.CustomerID = C.CustomerID
WHERE 
    O.Status = 'Complete';

-- Find the average price of products by category
SELECT 
    Category,
    AVG(Price) AS AvgPrice
FROM 
    Products
GROUP BY 
    Category;
-- Find orders with status lengths (ENUM values)
SELECT 
    O.OrderID,
    O.Status,
    LENGTH(O.Status) AS StatusLength
FROM 
    Orders O;
-- Find customers who made orders in both statuses: 'Complete' and 'Incomplete'
(SELECT DISTINCT CustomerID FROM Orders WHERE Status = 'Complete')
INTERSECT
(SELECT DISTINCT CustomerID FROM Orders WHERE Status = 'Incomplete');
-- Rank products by total revenue
SELECT 
    P.ProductID,
    P.Name AS ProductName,
    SUM(O.TotalPrice) AS TotalRevenue,
    RANK() OVER (ORDER BY SUM(O.TotalPrice) DESC) AS RevenueRank
FROM 
    Orders O
INNER JOIN 
    Products P ON O.ProductID = P.ProductID
GROUP BY 
    P.ProductID, P.Name;


--task 3
DELIMITER $$

CREATE PROCEDURE monthly_report(IN report_month VARCHAR(7))
BEGIN
    -- Calculate total revenue, total costs, and profit for the month
    SELECT 
        DATE_FORMAT(OrderDate, '%Y-%m') AS ReportMonth,
        SUM(O.TotalPrice) AS TotalRevenue,
        (SUM(O.TotalPrice) * 0.2) AS TotalCosts, -- Assuming 20% commission cost
        (SUM(O.TotalPrice) - (SUM(O.TotalPrice) * 0.2)) AS Profit
    FROM 
        Orders O
    WHERE 
        DATE_FORMAT(O.OrderDate, '%Y-%m') = report_month
    GROUP BY 
        ReportMonth;
END $$

DELIMITER ;
