
USE music;

-- 9.	Create a store procedure for the search function with the name search that displays EmployeeName,
-- Address, Phone, Gender. This function will search all the columns according to the input. (CREATE PROCEDURE, LIKE, CONCAT)

DELIMITER $$

CREATE PROCEDURE search(IN input VARCHAR(255)) -- Parameter / Argument
BEGIN
    SELECT EmployeeName, Address, Phone, Gender 
    FROM MsEmployee 
    WHERE EmployeeName LIKE CONCAT('%', input, '%') -- 
      OR Address LIKE CONCAT('%', input, '%') 
      OR Phone LIKE CONCAT('%', input, '%') 
      OR Gender LIKE CONCAT('%', input, '%');
END$$

DELIMITER ;

SELECT * FROM MSEMPLOYEE;

CALL search("Ma");

-- 10.	Create a Stored Procedure named ‘Check_Transaction’ that displays CustomerName,
-- EmployeeName, BranchName, MusicIns, Price based on the TransactionID inputted.

DELIMITER $$

CREATE PROCEDURE Check_Transaction(IN input VARCHAR(255))
BEGIN
    SELECT CustomerName, EmployeeName, BranchName, MusicIns, Price 
    FROM HeaderTransaction AS a 
    JOIN MsEmployee AS b ON a.EmployeeID = b.EmployeeID 
    JOIN MsBranch AS c ON b.BranchID = c.BranchID 
    JOIN DetailTransaction AS d ON a.TransactionID = d.TransactionID 
    JOIN MsMusicIns AS e ON d.MusicInsID = e.MusicInsID 
    WHERE a.TransactionID LIKE input;
END$$

DELIMITER ;

SELECT * FROM headertransaction;

CALL Check_Transaction("TR001");

-- 11.	Display data that shows details of the number of musicins transactions per employee
-- Jumlah Transaksi, EmployeeName

SELECT COUNT(a.TransactionID) AS JumlahTransaksi, EmployeeName 
FROM HeaderTransaction AS a 
-- JOIN DetailTransaction AS b ON a.TransactionID = b.TransactionID 
JOIN MsEmployee AS c ON a.EmployeeID = c.EmployeeID 
GROUP BY EmployeeName;

-- 12.	Create a Stored Procedure with the name "Add_Stock_MusicIns" to add MusicIns stock.
-- If the inputted stock is less than or equal to 0, a message will be displayed.
-- "The input stock must be greater than 0"

DELIMITER $$

CREATE PROCEDURE Add_Stock_MusicIns(IN inputID VARCHAR(255), IN inputStock INT)
BEGIN
	IF EXISTS (SELECT * FROM MsMusicIns WHERE MusicInsID = inputID) THEN
		IF inputStock <= 0 THEN
			SELECT 'Stok yang di input harus lebih besar dari 0';
		ELSE
			UPDATE MsMusicIns SET Stock = Stock + inputStock WHERE MusicInsID = inputID;
		END IF;
	ELSE
		SELECT 'Data tidak ditemukan / Kode yang dimasukan salah';
	END IF;
END$$

DELIMITER ;

SELECT * FROM msmusicins;

CALL Add_Stock_MusicIns("MI001", 2);

-- 13. Create a Stored Procedure with the name ‘Check_Sale’ to see what MusicInsType
-- what was sold in a particular month and the amount sold.

DELIMITER $$

CREATE PROCEDURE Check_Sale(IN input VARCHAR(255))
BEGIN
	SELECT a.MusicInsType, SUM(c.Qty) AS Qty
	FROM MsMusicInsType a
	JOIN MsMusicIns b ON a.MusicInsTypeID = b.MusicInsTypeID
	JOIN DetailTransaction c ON b.MusicInsID = c.MusicInsID
	JOIN HeaderTransaction d ON c.TransactionID = d.TransactionID
	WHERE MONTHNAME(TransactionDate) = input
	GROUP BY a.MusicInsType;
END$$

DELIMITER ;


-- Aggregation -> SUM, COUNT, MAX, MIN, AVG
-- Guitar 10
-- Guitar 5

-- Guitar 15

CALL Check_Sale("December");

-- 14.	Create a Stored Procedure named ‘Check_Employee’
-- which functions to provide employeename, address, phone,
-- DateOfBirth, and BranchName based on the TransactionID. If the TransactionID
-- is not entered, it will display all existing employee data.

DELIMITER $$

CREATE PROCEDURE Check_Employee(IN input VARCHAR(255))
BEGIN
	IF input != '' THEN
		SELECT a.EmployeeName, a.Address, a.Phone, DATE_FORMAT(a.DateOfBirth, '%d %M %Y') AS DateOfBirth, b.BranchName
		FROM MsEmployee a
		JOIN MsBranch b ON a.BranchID = b.BranchID
		JOIN HeaderTransaction c ON a.EmployeeID = c.EmployeeID
		WHERE c.TransactionID = input;
	ELSE
		SELECT a.EmployeeName, a.Address, a.Phone, DATE_FORMAT(a.DateOfBirth, '%d %M %Y') AS DateOfBirth, b.BranchName
		FROM MsEmployee a
		JOIN MsBranch b ON a.BranchID = b.BranchID;
	END IF;
END$$

DELIMITER ;

CALL Check_Employee("TR001");

-- Procedure Report