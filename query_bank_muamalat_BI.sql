# TASK 1: DESCRIBE THE PRIMARY KEY
# Customers Table
SELECT CustomerID, COUNT(*) AS jumlah
FROM `sales_dataset.Customers`
GROUP BY CustomerID
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_count
FROM `sales_dataset.Customers`
WHERE CustomerID IS NULL;

#Orders Table
SELECT OrderID, COUNT(*) AS jumlah
FROM `sales_dataset.Orders`
GROUP BY OrderID
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_count
FROM `sales_dataset.Orders`
WHERE OrderID IS NULL;

#Products Table
SELECT ProdNumber, COUNT(*) AS jumlah
FROM `sales_dataset.Products`
GROUP BY ProdNumber
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_count
FROM `sales_dataset.Products`
WHERE ProdNumber IS NULL;

# ProductCategory Table
SELECT CategoryID, COUNT(*) AS jumlah
FROM `sales_dataset.ProductCategory`
GROUP BY CategoryID
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_count
FROM `sales_dataset.ProductCategory`
WHERE CategoryID IS NULL;

# TASK 2: RELATIONSHIP BETWEEN TABLE
#Verify the relationship between Customers and Orders (Foreign Key: CustomerID)
SELECT o.CustomerID
FROM `sales_dataset.Orders` o
LEFT JOIN `sales_dataset.Customers` c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL AND o.CustomerID IS NOT NULL;

# Verify the relationship between Orders and Products (Foreign Key: ProdNumber)
SELECT o.ProdNumber
FROM `sales_dataset.Orders` o
LEFT JOIN `sales_dataset.Products` p ON o.ProdNumber = p.ProdNumber
WHERE p.ProdNumber IS NULL AND o.ProdNumber IS NOT NULL;

# Verify the relationship between Products and ProductCategory (Foreign Key: Category)
SELECT p.Category
FROM `sales_dataset.Products` p
LEFT JOIN `sales_dataset.ProductCategory` pc ON p.Category = pc.CategoryID
WHERE pc.CategoryID IS NULL AND p.Category IS NOT NULL;

# Creating Relationship (Relationship Logic)
SELECT 
    c.CustomerID, c.FirstName, o.OrderID, o.Quantity, p.ProdName, pc.CategoryName
FROM `sales_dataset.Customers` c
JOIN `sales_dataset.Orders` o ON c.CustomerID = o.CustomerID
JOIN `sales_dataset.Products` p ON o.ProdNumber = p.ProdNumber
JOIN `sales_dataset.ProductCategory` pc ON p.Category = pc.CategoryID
LIMIT 10;

#TASK 3: CREATE A MASTER TABLE
CREATE TABLE `sales_dataset.MasterTable` AS
SELECT 
    o.Date AS order_date,
    pc.CategoryName AS category_name,
    p.ProdName AS product_name,
    p.Price AS product_price,
    o.Quantity AS order_qty,
    (o.Quantity * p.Price) AS total_sales,
    c.CustomerEmail AS cust_email,
    c.CustomerCity AS cust_city
FROM `sales_dataset.Orders` o
JOIN `sales_dataset.Customers` c ON o.CustomerID = c.CustomerID
JOIN `sales_dataset.Products` p ON o.ProdNumber = p.ProdNumber
JOIN `sales_dataset.ProductCategory` pc ON p.Category = pc.CategoryID
ORDER BY o.Date ASC;
