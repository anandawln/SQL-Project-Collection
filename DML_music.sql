USE music;

-- 1.	Show top 2 of EmployeeID, EmployeeName, Gender where Gender is 'F'  
-- (LIMIT)

SELECT EmployeeID, EmployeeName, Gender
FROM MsEmployee
WHERE Gender = 'F'
LIMIT 2;


-- 2. 	Display the MsEmployee table where the last digit of Phone is a multiple of 5 and
-- salary is greater than 4000000 (RIGHT)

SELECT *
FROM MsEmployee
WHERE Salary > 4000000 AND RIGHT(Phone,1) % 5 = 0; -- 12345 -> 35 % 5 = 35 - 35 = 0


-- 3.	Create a view with the name view_1 then display the MsMusicIns table where price
-- between 5000000 and 10000000, with MusicIns prefixed by the word Yamaha.
-- Display the view and create syntax to delete the view
-- (CREATE VIEW, BETWEEN, LIKE) 

CREATE VIEW view_1 AS
SELECT *
FROM MsMusicIns
WHERE Price BETWEEN 5000000 AND 10000000 AND MusicIns LIKE 'Yamaha%'; -- Wildcard -> Yamaha PX500 / Yamah CX1000

SELECT *
FROM view_1;
	
-- 4.	Show BranchEmployee (obtained from employeename and first name of employeename replaced with branchID)
-- where employeename has at least 3 words. (REPLACE, CONCAT, SUBSTRING, LOCATE, LIKE)

-- Concatenate -> BR001 
SELECT CONCAT(BranchID, ' ', SUBSTRING(EmployeeName, LOCATE(' ', EmployeeName)+1)) AS BranchEmployee -- ALIAS
FROM MsEmployee
WHERE CHAR_LENGTH(EmployeeName) - CHAR_LENGTH(REPLACE(EmployeeName, ' ', '')) >= 2;
-- WHERE EmployeeName LIKE '% % %'; --(alternative)


-- 5.	Show Brand (obtained from the first word of MusicIns), Price (obtained from price added the word 'Rp. ' in front of it),
-- Stock, Instrument Type(obtained from MusicInsType) (SUBSTRING_INDEX,CONCAT, JOIN)

SELECT 
SUBSTRING_INDEX(MusicIns, ' ', 1) AS Brand,
CONCAT('Rp. ', Price) AS Price, 
Stock, 
MusicInsType
FROM MsMusicInsType
JOIN MsMusicIns ON  MsMusicInsType.MusicInsTypeID = MsMusicIns.MusicInsTypeID ;

-- 6.	Display EmployeeName, Employee Gender (obtained from gender), Date in dd mm yyyy format,
-- CustomerName where Gender is 'Male' and EmployeeName has 2 or more words.
-- (CASE WHEN, DATE_FORMAT, JOIN, LIKE, ORDER BY)
SELECT EmployeeName, 
       CASE WHEN Gender = 'M' THEN 'Male' ELSE 'Female' END AS EmployeeGender,
       DATE_FORMAT(TransactionDate, '%d %M %Y') AS TransactionDate, 
       CustomerName 
FROM MsEmployee AS a 
JOIN HeaderTransaction AS b ON a.EmployeeID = b.EmployeeID 
WHERE EmployeeName LIKE '% %' 
  AND Gender = 'M' 
ORDER BY EmployeeName DESC;

-- 7.	Display EmployeeID, EmployeeName, DateOfBirth in the format dd mm yyyy, CustomerName, Transactiondate where
-- DateOfBirth is the month ‘December’ and TransactionDate is the 16th. (DATE_FORMAT, JOIN, MONTHNAME, DAYOFMONTH) 

SELECT a.EmployeeID, 
       EmployeeName, 
       DATE_FORMAT(DateOfBirth, '%d-%m-%Y') AS DateOfBirth, 
       CustomerName, 
       DATE_FORMAT(TransactionDate, '%d %m %Y') AS TransactionDate 
FROM MsEmployee AS a 
JOIN HeaderTransaction AS b ON a.EmployeeID = b.EmployeeID 
WHERE MONTHNAME(DateOfBirth) = 'December' 
  AND DAYOFMONTH(TransactionDate) = 16;


-- 8.	Show BranchName,EmployeeName where the transaction occurred in October and Qty is more than equal to 5.
-- (EXISTS, JOIN, MONTHNAME) 

-- Subquery
SELECT BranchName, EmployeeName 
FROM MsEmployee AS a 
JOIN MsBranch AS b ON a.BranchID = b.BranchID 
WHERE EXISTS (
    SELECT * 
    FROM HeaderTransaction AS x 
    JOIN DetailTransaction AS y ON x.TransactionID = y.TransactionID 
    WHERE MONTHNAME(TransactionDate) = 'October' 
      AND Qty >= 5 
      AND a.EmployeeID = x.EmployeeID
);

SELECT BranchName, EmployeeName 
FROM MsEmployee AS a 
JOIN MsBranch AS b ON a.BranchID = b.BranchID 
JOIN HeaderTransaction AS x ON a.EmployeeID = x.EmployeeID
JOIN DetailTransaction AS y ON x.TransactionID = y.TransactionID 
WHERE MONTHNAME(TransactionDate) = 'October' 
AND Qty >= 5 ;

-- DML REPORT