
CREATE DATABASE shop;
USE shop;

-- DROP DATABASE shop;

CREATE TABLE TrCustomer(
	IDCustomer INT AUTO_INCREMENT,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(20),
	Email VARCHAR(50),
    PRIMARY KEY(IDCustomer)
);

CREATE TABLE TrShop(
	IDShop VARCHAR(6),
	Name VARCHAR(50) NOT NULL,
	Owner VARCHAR(50) NOT NULL,
	isOfficial INT NOT NULL, -- BIT
	Address VARCHAR(50),
    PRIMARY KEY(IDShop)
);

CREATE TABLE MsProduct(
	IDProduct INT AUTO_INCREMENT,
	IDShop VARCHAR(6),
	Name VARCHAR(50) NOT NULL,
	Stock INT NOT NULL,
	Price INT NOT NULL,
	PRIMARY KEY(IDProduct),
    FOREIGN KEY(IDShop) REFERENCES TrShop(IDShop)
);

CREATE TABLE TrTransaction(
	IDTransaction VARCHAR(5),
	IDProduct INT,
	IDCustomer INT,
	TransactionDate DATETIME,
	Qty INT NOT NULL,
	TotalPrice BIGINT NOT NULL,
	Done BIT NOT NULL,
	PaymentMethod VARCHAR(50) NOT NULL,
    PRIMARY KEY(IDTransaction),
    FOREIGN KEY(IDProduct) REFERENCES MsProduct(IDProduct),
	FOREIGN KEY(IDCustomer) REFERENCES TrCustomer(IDCustomer)
);

CREATE TABLE TrReview(
	IDReview INT AUTO_INCREMENT,
	IDProduct INT,
	Comment VARCHAR(50),
	Star INT NOT NULL,
	CONSTRAINT checkStar CHECK (Star >= 1 and Star <= 5), -- STAR BETWEEN 1 AND 5
    PRIMARY KEY(IDReview),
    FOREIGN KEY(IDProduct) REFERENCES MsProduct(IDProduct)
);

CREATE TABLE TrCart(
	IDCart INT AUTO_INCREMENT,
	IDProduct INT,
	IDCustomer INT,
    PRIMARY KEY(IDCart),
    FOREIGN KEY(IDProduct) REFERENCES MsProduct(IDProduct),
    FOREIGN KEY(IDCustomer) REFERENCES TrCustomer(IDCustomer)
);

-- INSERT DATA
INSERT INTO trCustomer(Name, PhoneNumber, Email)
VALUES -- DONE
('Christiana Willis Cockle','202-555-0106','christiana@email.com'),
('James Butterscotch','202-555-0174','james@email.com'),
('Suzanne Jones Greenway','202-555-0102','suzanne@email.com'),
('Morwenna Doop','202-555-0170','morwenna@email.com'),
('Beth Giantbulb Barlow','202-555-0140','beth@email.com'),
('Morwenna Doop','202-555-0160','morwenna@email.com'),
('Jeff Ferguson Platt','202-555-0120','jeff@email.com'),
('Jenna Thornhill','202-555-01900','jenna@email.com'),
('Charlotte Donaldson Hemingway','202-555-0270','charlotte@email.com'),
('Steven Smith','202-555-0820','steven@email.com');

INSERT INTO trShop(IDShop, Name, Owner, isOfficial, Address)
VALUES -- DONE
('SH145N','Fortune Shop','Clarke Platt',0,'204 Peed Smith Rd, Hamilton, GA, 31811'),
('SH223Y','Jaya Shop','Fred Wilson',1,'4932 Reuter St, Dearborn, MI, 48126'),
('SH359Y','Surya Shop','Naomi Rockatansky',1,'4971 Good Luck Rd, Aynor, SC, 29511'),
('SH483N','Sinar Shop','Jenna Vader',0,'5401 A Tech Cir, Moorpark, CA, 93021'),
('SH592Y','Terang Shop','Mary Parkes',1,'7120 Crestwood Ave, Jenison, MI, 49428'),
('SH673N','Parlor Shop','Sophia Willis',0,'185 Red Maple Dr, Hampton, GA, 30228'),
('SH778N','Inn Shop','Suzanne Ball',0,'106 Southwind Dr, Pleasant Hill, CA, 94523'),
('SH832N','Deli Shop','Alex Barker',0,'2337 School House Rd, Fairmont, WV, 26554'),
('SH912Y','Buzz Shop','Sandie Doop',1,'5544 East Torino, Port Saint Lucie, FL, 34986'),
('SH102Y','Fushion Shop','Alex Fish',1,'89068 Fir Butte Rd, Eugene, OR, 97402');


INSERT INTO MsProduct(IDShop, Name, Stock, Price)
VALUES -- DONE
-- SHOP 1
('SH145N', 'Fidget Spinner', 110, 49000),
('SH145N', 'Fidget Box', 78, 39000),
('SH145N', 'Slime', 40, 12000),
('SH145N', 'Lego', 103, 56000),
('SH145N', 'Gundam Master Grade', 5, 405000),
-- SHOP 2
('SH223Y', 'Computer', 5, 5000000),
('SH223Y', 'VGA', 26, 1000000),
('SH223Y', 'Mouse', 98, 340000),
('SH223Y', 'Keyboard', 63, 760000),
('SH223Y', 'Earphone', 120, 120000),
-- SHOP 3
('SH359Y', 'Soap', 50, 5000),
('SH359Y', 'Shampoo', 45, 21000),
('SH359Y', 'Tooth Brush', 81, 140000),
('SH359Y', 'Tooth Paste', 20, 21000),
('SH359Y', 'Hair Conditioner', 30, 58000),
-- SHOP 4
('SH483N', 'Guitar', 70, 550000),
('SH483N', 'Violin', 30, 450000),
('SH483N', 'Piano', 8, 1250000),
('SH483N', 'Drum', 5, 2600000),
('SH483N', 'Flute', 120, 55000),
-- SHOP 5
('SH592Y', 'Chair', 25, 800000),
('SH592Y', 'Table', 14, 975000),
('SH592Y', 'Cupboard', 10, 1300000),
('SH592Y', 'Trash Can', 43, 23000),
('SH592Y', 'Door', 18, 600000),
-- SHOP 6
('SH673N', 'Book', 30, 5000),
('SH673N', 'Paper', 100, 1000),
('SH673N', 'Pen', 20, 3000),
('SH673N', 'Pencil', 27, 2500),
('SH673N', 'Eraser', 25, 7500),
-- SHOP 7
('SH778N', 'Racket', 15, 540000),
('SH778N', 'Jersey', 55, 450000),
('SH778N', 'Headband', 30, 35000),
('SH778N', 'Shoes', 7, 510000),
('SH778N', 'Socks', 12, 10000),
-- SHOP 8
('SH832N', 'T-Shirt', 8, 340000),
('SH832N', 'Shirt', 15, 185000),
('SH832N', 'Trousers', 7, 380000),
('SH832N', 'Tie', 19, 60000),
('SH832N', 'Jacket', 5, 280000),
-- SHOP 9
('SH912Y', 'Plate', 38, 40000),
('SH912Y', 'Fork', 60, 4000),
('SH912Y', 'Spoon', 54, 4500),
('SH912Y', 'Bowl', 25, 34000),
('SH912Y', 'Chopsticks', 56, 4000),
-- SHOP 10
('SH102Y', 'Doll', 20, 140000),
('SH102Y', 'Balloon', 23, 9000),
('SH102Y', 'Key Chain', 50, 12000),
('SH102Y', 'Hand Bouquet', 35, 89000),
('SH102Y', 'Pillow', 43, 67000);

INSERT INTO TrTransaction(IDTransaction, IDProduct, IDCustomer, TransactionDate, Qty, TotalPrice, Done, PaymentMethod)
VALUES -- DONE
('TR001',1,1,'2018-03-12 12:23:01',2,98000,0,'Credit Card'),
('TR002',2,2,'2018-05-01 07:21:01',1,39000,1,'Debit'),
('TR003',3,3,'2018-02-23 20:45:56',1,12000,1,'Credit Card'),
('TR004',4,4,'2018-09-15 17:38:59',1,56000,1,'Credit Card'),
('TR005',5,5,'2018-08-05 10:11:01',2,105000,0,'Debit'),

('TR006',6,1,'2018-01-23 12:23:31',1,5000000,0,'Debit'),
('TR007',7,2,'2018-02-10 17:38:41',2,2000000,1,'Debit'),
('TR008',8,3,'2018-03-22 20:23:17',3,1020000,0,'Debit'),
('TR009',9,4,'2018-08-27 01:38:12',1,760000,1,'Credit Card'),
('TR010',10,5,'2018-10-01 10:01:51',2,24000,0,'Debit'),

('TR011',31,6,'2018-12-01 18:43:56',2,1080000,1,'Credit Card'),
('TR012',32,7,'2018-11-25 07:26:41',5,2250000,0,'Debit'),
('TR013',33,8,'2018-10-17 23:25:26',2,70000,0,'Debit'),
('TR014',34,9,'2018-09-12 21:37:59',1,510000,1,'Credit Card'),
('TR015',35,6,'2018-08-08 14:31:39',3,30000,0,'Debit'),
	 
('TR016',36,6,'2018-07-24 15:24:21',2,680000,1,'Credit Card'),
('TR017',37,7,'2018-05-12 18:11:51',3,555000,1,'Debit'),
('TR018',38,8,'2018-03-11 11:35:26',4,1520000,1,'Credit Card'),
('TR019',39,9,'2018-01-29 19:37:19',2,120000,1,'Debit'),
('TR020',40,7,'2018-11-30 23:18:23',1,280000,0,'Debit');

INSERT INTO TrReview(IDProduct, Comment, Star)
VALUES
-- DONE
(1,'Good',5),
(1,'Nice',4),
(2,'I dont like it',2),
(2,'Best product',5),
(3,'Not really..',3),
(3,'Never buy this item again',1),
(4,'Good job',5),
(4,'Awesome',5),
(5,'Terrible',2),
(5,'OK',3),
(6,'Good',5),
(6,'Nice',4),
(7,'Best product',5),
(7,'Not really..',3),
(8,'Never buy this item again',1),
(8,'Good job',5),
(9,'Awesome',5),
(9,'Terrible',2),
(10,'OK',3),
(10,'Nice',4),
-- DONE
(11,'Never buy this item again',1),
(11,'Nice',3),
(12,'Never buy this item again',5),
(12,'Good job',1),
(13,'Not really..',3),
(13,'est product',5),
(14,'Not really..',3),
(14,'Awesome',4),
(15,'Terrible',1),
(15,'OK',3),
(16,'Good',5),
(16,'Nice',3),
(17,'Best product',3),
(17,'Not really..',3),
(18,'Awesome',4),
(18,'Good job',5),
(19,'Bad',1),
(19,'Terrible',2),
(20,'Best',5),
(20,'Nice',4),
-- DONE
(21,'Terrible',1),
(21,'Bad',2),
(22,'I dont like it',3),
(22,'Thank you',5),
(23,'Nice',5),
(23,'Best Product',5),
(24,'Not Really...',2),
(24,'OK',3),
(25,'Best',4),
(25,'OK',4),
(26,'So Bad',1),
(26,'Bad',2),
(27,'Best product',5),
(27,'OK',4),
(28,'Terrible',2),
(28,'OK',3),
(29,'Awesome',5),
(29,'Good',4),
(30,'OK',3),
(30,'Nice',4),
-- DONE
(31,'Terrible',1),
(31,'Terrible',2),
(32,'Good',3),
(32,'Best product',5),
(33,'Nice',4),
(33,'Terrible',2),
(34,'Good job',4),
(34,'Awesome',1),
(35,'Terrible',2),
(35,'Terrible',2),
(36,'Good',3),
(36,'Nice',4),
(37,'Best product',5),
(37,'Not really..',3),
(38,'Never buy this item again',1),
(38,'Good job',4),
(39,'Best product',5),
(39,'Good',3),
(40,'OK',3),
(40,'Nice',4),
-- DONE
(41,'Nice',4),
(41,'Nice',4),
(42,'Best product',5),
(42,'Best product',5),
(43,'Terrible',1),
(43,'Never buy this item again',2),
(44,'Not really..',3),
(44,'Terrible',1),
(45,'Nice',4),
(45,'Good',5),
(46,'Good',5),
(46,'Nice',4),
(47,'Nice',4),
(47,'Not really..',3),
(48,'Never buy this item again',2),
(48,'Good job',5),
(49,'Awesome',4),
(49,'Never buy this item again',2),
(50,'Never buy this item again',2),
(50,'Nice',4);


INSERT INTO trCart(IDProduct, IDCustomer)
VALUES
-- CUSTOMER 1
(1,1),
(3,1),
(4,1),
(5,1),
(7,1),
(12,1),
(33,1),
(44,1),
(25,1),
(17,1),
-- CUSTOMER 2
(21,2),
(33,2),
(45,2),
(50,2),
(37,2),
(31,2),
(32,2),
(45,2),
(50,2),
(37,2),
-- CUSTOMER 3
(23,3),
(13,3),
(25,3),
(40,3),
(36,3),
(21,3),
(33,3),
(45,3),
(50,3),
(37,3),
-- CUSTOMER 4
(25,4),
(38,4),
(47,4),
(50,4),
(32,4),
(21,4),
(31,4),
(41,4),
(45,4),
(33,4),
-- CUSTOMER 5
(1,5),
(13,5),
(25,5),
(30,5),
(47,5),
(50,5),
(23,5),
(15,5),
(10,5),
(17,5),
-- CUSTOMER 6
(11,6),
(23,6),
(35,6),
(40,6),
(50,6),
(29,6),
(38,6),
(47,6),
(16,6),
(31,6),
-- CUSTOMER 7
(11,7),
(12,7),
(13,7),
(14,7),
(15,7),
(16,7),
(17,7),
(18,7),
(19,7),
(20,7),
-- CUSTOMER 8
(21,8),
(33,8),
(25,8),
(30,8),
(47,8),
(11,8),
(23,8),
(15,8),
(10,8),
(27,8),
-- CUSTOMER 9
(21,9),
(22,9),
(23,9),
(24,9),
(25,9),
(26,9),
(27,9),
(28,9),
(29,9),
(30,9),
-- CUSTOMER 10
(31,10),
(32,10),
(33,10),
(34,10),
(35,10),
(36,10),
(37,10),
(38,10),
(39,10),
(40,10);

SELECT * FROM trCustomer;

SELECT * FROM trShop;

SELECT * FROM MsProduct;

SELECT * FROM trTransaction;

SELECT * FROM TrReview;

SELECT * FROM TrCart;

-- DDL PART 2 