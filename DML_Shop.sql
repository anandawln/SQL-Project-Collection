
USE shop;

/* NUMBER 1: Show 2 most expensive items */

SELECT * FROM MsProduct ORDER BY Price DESC LIMIT 2;

/* NUMBER 2 : Show details of stores that have been officially sorted from the name of the largest store owner [A - Z]
			Note: 1. Not allowed to use isOfficial column
				   2. Use the last digit of IDShop column
							Y : Official
							N : Not official */
                            
SELECT * FROM trShop WHERE RIGHT(IDShop,1) = 'Y' ORDER BY Owner ASC;

/* NUMBER 3 : Create a view named ‘vw_CreditCardDoneTransaction’, displaying the details of the transaction
			that has been completed using Credit Card */
CREATE VIEW vw_CreditCardDoneTransaction
AS
SELECT * FROM trTransaction WHERE PaymentMethod = 'Credit Card' AND Done = 1;

SELECT * FROM vw_CreditCardDoneTransaction;

/* NUMBER 4 : Show the OFFICIAL shop owner's name with the format [shop code + shop owner's last name] */
SELECT CONCAT(IDShop, ' ', SUBSTR(Owner, LOCATE(' ', Owner), LENGTH(Owner))) AS 'Owner Name' FROM trShop WHERE isOfficial = 1;

/* NUMBER 5 : Display product code, product name, product stock, price with the format ['Rp. ’ + Price] 
			of products that have stock more than 50 */
SELECT IDProduct, Name, Stock, CONCAT('Rp. ', Price) AS Price FROM MsProduct WHERE Stock > 50;


/* NUMBER 6 : Show shop code, shop name with the format shopname + official/non-official, 
			owner, address that has price more than 100000 */
SELECT DISTINCT a.IDShop, CONCAT(a.Name, CASE WHEN isOfficial = 1 THEN ' (Official)' ELSE ' (Non-Official)' END) AS Name, Owner
FROM trShop a
JOIN MsProduct b ON a.IDShop = b.IDShop
WHERE Price > 100000;

/* NUMBER 7 : Display transaction code, product code, customer code, transaction date in the format dd mm yyyy,
			qty, total price, payment method of transactions that occurred in September and November. */
SELECT IDTransaction, IDProduct, IDCustomer, DATE_FORMAT(TransactionDate, '%d %M %Y') AS "Transaction Date", qty, totalprice, paymentmethod
FROM TrTransaction
WHERE MONTH(TransactionDate) IN (9, 11);
-- WHERE  MONTH(TransactionDate) = 9 OR MONTH(TransactionDate) = 11

/* NUMBER 8 : Show the name of the transaction method, the number of transactions using the method
			debit method (Payment Count) from stores that are already official */
SELECT PaymentMethod, COUNT(IDTransaction) AS 'Payment Count'
FROM TrTransaction
JOIN MsProduct ON TrTransaction.IDProduct = MsProduct.IDProduct
JOIN TrShop ON MsProduct.IDShop = TrShop.IDShop
WHERE isOfficial = 1 AND PaymentMethod = 'Debit'
GROUP BY PaymentMethod;

/* QUERY FOR CHECK NUMBER 8 */
SELECT * 
FROM TrTransaction a
JOIN MsProduct b ON a.IDProduct = b.IDProduct
JOIN trshop c ON b.IDShop = c.IDShop
WHERE PaymentMethod = 'Debit';
/* ============================ */

SELECT * FROM trcustomer;

/* NUMBER 9 : Display customer code, customer name, PhoneNumber, and email
			that has a name with at least 3 words*/
SELECT IDCustomer, Name, PhoneNumber, Email
FROM TrCustomer
WHERE Name LIKE '% % %';

/* NUMBER 10 : Create a Stored Procedure named ‘Search_Product’ that accepts the input/parameter
			 item name, and displays the name of the store that sells the item, item code,
			 item name, stock, price
			  */			  
DELIMITER $$
CREATE PROCEDURE Search_Product(IN Input_param VARCHAR(255))
BEGIN
    SELECT b.Name as 'Shop Name', a.IDProduct as 'Product ID', a.Name as 'Product Name', a.Stock, a.Price
    FROM MsProduct a
    JOIN TrShop b ON a.idshop = b.IDShop
    WHERE a.Name = Input_param;
END $$
DELIMITER ;

CALL Search_Product('Tooth brush');

/* NUMBER 11 : Create a Stored Procedure called ‘GetAverageReviewByProductName’ that accepts inputs/parameters
			 product name, which functions to display the product name, average review star from the
			 the inputted product name */
DELIMITER $$
CREATE PROCEDURE GetAverageReviewByProductName(IN Input_param VARCHAR(255))
BEGIN
    SELECT b.Name as 'Product Name', AVG(a.Star) as 'Average Review Star'
    FROM TrReview a
    JOIN MsProduct b ON a.IDProduct = b.IDProduct
    WHERE b.Name = Input_param
    GROUP BY b.Name;
END $$
DELIMITER ;

CALL GetAverageReviewByProductName ('Fidget Box');

SELECT * FROM msproduct;
SELECT * FROM trreview WHERE idproduct = 2;

/* NUMBER 12 : Create a Stored Procedure named ‘Search_Shop’, accepting the input/parameter
			 store name OR owner name which functions to display store data according to the
			 the inputted shop/owner */
DELIMITER $$
CREATE PROCEDURE Search_Shop(IN Input_param VARCHAR(255))
BEGIN
    SELECT * FROM TrShop
    WHERE Name LIKE concat('%', Input_param, '%') OR 
    Owner LIKE concat('%', Input_param, '%');
END $$
DELIMITER ;

CALL Search_Shop ('Nao');

/* NUMBER 13 : Create a Stored Procedure named ‘GetTotalStockAndSoldProduct’, which accepts no inputs/parameters.
			 which functions to display all product details and 
			 [Total Stock + Sold] = total product stock + the number of products that have been sold*/
DELIMITER $$
CREATE PROCEDURE GetTotalStockAndSoldProduct()
BEGIN
    SELECT b.IDProduct, b.IDShop, b.Name, b.Price, (b.Stock + a.TotalQty) AS 'Total Stock + Sold'
    FROM (
        SELECT IDProduct, COALESCE(SUM(Qty), 0) AS TotalQty -- NULL
        FROM TrTransaction
        GROUP BY IDProduct
    ) a
    JOIN MsProduct b ON a.IDProduct = b.IDProduct;
END $$
DELIMITER ;

CALL GetTotalStockAndSoldProduct();

/* NUMBER 14 : Create a Stored Procedure named ‘CountProductInCustomerCart’ that accepts the parameters
			 product name, which serves to display the product name and [Count Customer] = the number of
			 customers who store the product in the customer's cart */
DELIMITER $$
CREATE PROCEDURE CountProductInCustomerCart(IN Name VARCHAR(255))
BEGIN
    SELECT b.Name, COALESCE(a.CountCustomer, 0) AS 'Count Customer'
    FROM (
        SELECT IDProduct, COUNT(IDCustomer) AS CountCustomer
        FROM TrCart
        GROUP BY IDProduct
    ) a
    RIGHT JOIN MsProduct b ON a.IDProduct = b.IDProduct
    WHERE b.Name = Name;
END $$
DELIMITER ;

CALL CountProductInCustomerCart('Door');

SELECT * FROM msproduct WHERE idproduct = 25;

SELECT idproduct, COUNT(idproduct)
FROM trcart
GROUP BY idproduct
ORDER BY COUNT(idproduct) DESC;

/* NUMBER 15 : Create a Stored Procedure named ‘CalculateCustomerPoint’ that accepts input/parameter
			 the customer's name, which functions to give points to customers who have 
			 spent money for shopping with the following conditions
			 Note: 1. if the customer spends < Rp. 100,000 -> gets 0 points
					2. if the customer spends Rp. 100,000 - Rp. 499,000 -> gets 20 points
					3. if the customer spends Rp. 500,000 - Rp. 999,000 -> gets 50 points
					4. if the customer spends > Rp. 1,000,000-> gets 100 points */
DELIMITER $$
CREATE PROCEDURE CalculateCustomerPoint(IN Customer_Name VARCHAR(255))
BEGIN
DECLARE Total_Spending BIGINT;

SET Total_Spending = (SELECT SUM(TotalPrice) FROM TrTransaction a JOIN TrCustomer b ON a.IDCustomer = b.IDCustomer 
WHERE Name = Customer_Name GROUP BY a.IDCustomer);

SELECT CASE
  WHEN Total_Spending < 100000 OR Total_Spending IS NULL THEN 0
  WHEN Total_Spending >= 100000 AND Total_Spending < 500000 THEN 20
  WHEN Total_Spending >= 500000 AND Total_Spending < 1000000 THEN 50 -- <= 999999
  ELSE 100
END AS Point;
END$$
DELIMITER ;

SELECT * FROM trcustomer;

CALL CalculateCustomerPoint('Christiana Willis Cockle');

/* QUERY FOR TESTING */
SELECT SUM(TotalPrice)
FROM TrCustomer a
JOIN TrTransaction b ON a.IDCustomer = b.IDCustomer
WHERE Name = 'Christiana Willis Cockle'
GROUP BY Name;

/* ================= */

SELECT * FROM TrTransaction;
SELECT * FROM TrCustomer;


-- DML for Shop database