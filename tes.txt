
USE music;

-- 1.	Tampilkan top 2 dari EmployeeID, EmployeeName, Gender dimana Gender adalah 'F' 
-- (LIMIT)

SELECT EmployeeID, EmployeeName, Gender
FROM MsEmployee
WHERE Gender = 'F'
LIMIT 2;


-- 2. 	Tampilkan tabel MsEmployee dimana digit terakhir dari Phone adalah kelipatan 5 dan 
-- salary lebih besar dari 4000000 (RIGHT)

SELECT *
FROM MsEmployee
WHERE Salary > 4000000 AND RIGHT(Phone,1) % 5 = 0; -- 12345 -> 35 % 5 = 35 - 35 = 0


-- 3.	Buatlah view dengan nama view_1 lalu tampilkan tabel MsMusicIns dimana price
-- antara 5000000 dan 10000000, dengan MusicIns diawali dengan kata Yamaha.
-- Tampilkan view tersebut dan buat syntax untuk menghapus view tersebut
-- (CREATE VIEW, BETWEEN, LIKE) 

CREATE VIEW view_1 AS
SELECT *
FROM MsMusicIns
WHERE Price BETWEEN 5000000 AND 10000000 AND MusicIns LIKE 'Yamaha%'; -- Wildcard -> Yamaha PX500 / Yamah CX1000

SELECT *
FROM view_1;
	
-- 4.	Tampilkan BranchEmployee ( didapat dari employeename dan nama depan employeename diganti dengan branchID )
-- dimana employeename memiliki minimal 3 kata. (REPLACE, CONCAT, SUBSTRING, LOCATE, LIKE)

-- Concatenate -> BR001 
SELECT CONCAT(BranchID, ' ', SUBSTRING(EmployeeName, LOCATE(' ', EmployeeName)+1)) AS BranchEmployee -- ALIAS
FROM MsEmployee
WHERE CHAR_LENGTH(EmployeeName) - CHAR_LENGTH(REPLACE(EmployeeName, ' ', '')) >= 2;
-- WHERE EmployeeName LIKE '% % %';

-- Hansen Tanjaya Wilfridus-> HansenTanjayaWilfridus

-- 5.	Tampilkan Brand (didapat dari kata pertama MusicIns), Price (didapat dari price ditambahkan kata 'Rp. ' didepannya),
-- Stock, Instrument Type(didapat dari MusicInsType) (SUBSTRING_INDEX,CONCAT, JOIN)

SELECT 
SUBSTRING_INDEX(MusicIns, ' ', 1) AS Brand,
CONCAT('Rp. ', Price) AS Price, 
Stock, 
MusicInsType
FROM MsMusicInsType
JOIN MsMusicIns ON  MsMusicInsType.MusicInsTypeID = MsMusicIns.MusicInsTypeID ;

-- 6.	Tampilkan EmployeeName, Employee Gender(didapat dari gender), Tanggal dengan format dd mm yyyy,
-- CustomerName dimana Gender merupakan 'Male' dan EmployeeName memiliki 2 kata atau lebih.
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

-- 7.	Tampilkan EmployeeID, EmployeeName, DateofBirth dengan format dd mm yyyy, CustomerName, Transactiondate dimana
-- DateOfBirth adalah bulan ‘December’ dan TransactionDate adalah tanggal 16. (DATE_FORMAT, JOIN, MONTHNAME, DAYOFMONTH) 

SELECT a.EmployeeID, 
       EmployeeName, 
       DATE_FORMAT(DateOfBirth, '%d-%m-%Y') AS DateOfBirth, 
       CustomerName, 
       DATE_FORMAT(TransactionDate, '%d %m %Y') AS TransactionDate 
FROM MsEmployee AS a 
JOIN HeaderTransaction AS b ON a.EmployeeID = b.EmployeeID 
WHERE MONTHNAME(DateOfBirth) = 'December' 
  AND DAYOFMONTH(TransactionDate) = 16;


-- 8.	Tampilkan BranchName,EmployeeName dimana transaksi terjadi bulan Oktober dan Qty lebih dari sama dengan 5.
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
Chapter 6.sql
Displaying Chapter 6.sql.