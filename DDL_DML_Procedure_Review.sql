
CREATE DATABASE review;
USE review;

DROP DATABASE review;

CREATE TABLE Mahasiswa (
	NIM CHAR(10) PRIMARY KEY,
	Nama VARCHAR(100),
	Alamat VARCHAR(150),
	Gender char(1)
	CONSTRAINT CheckGender CHECK(Gender = 'L' OR Gender = 'P')
);

SELECT * FROM Mahasiswa;

ALTER TABLE Mahasiswa 
ADD Email VARCHAR(100);

DROP TABLE Mahasiswa;

INSERT INTO Mahasiswa(NIM, Nama, Gender, Alamat)
VALUES ('2001541876', 'Budi', 'L', 'Jalan Panjang');

INSERT INTO Mahasiswa 
VALUES ('2001541871', 'Andi', 'Jalan Panjang 2', 'L');

SELECT NIM, Nama AS 'Nama Saya' FROM Mahasiswa;

SELECT * FROM Mahasiswa
WHERE NIM = '2001541876';

START TRANSACTION;

UPDATE Mahasiswa 
SET Nama = 'abc'
WHERE NIM = '2001541876';

ROLLBACK;
COMMIT;

UPDATE Mahasiswa 
SET Nama = 'Jacky',
Alamat = 'Jalan pendek'
WHERE NIM = '2001541876';

DELETE FROM Mahasiswa
WHERE NIM = '2001541876';

CREATE TABLE Sks (
	ID INT NOT NULL AUTO_INCREMENT,
	NIM CHAR(10),
	JumlahSks INT,
    PRIMARY KEY(ID),
    FOREIGN KEY(NIM) REFERENCES Mahasiswa(NIM)
);

select * from Sks;
select * from Mahasiswa;

-- INSERT INTO Sks VALUES('2001541876', 20);

INSERT INTO Sks(NIM, JumlahSks) VALUES('2001541876', 20);
INSERT INTO Sks(NIM, JumlahSks) VALUES('2001541871', 10);

SELECT a.NIM, Nama, JumlahSks
FROM Mahasiswa a JOIN Sks b ON a.NIM = b.NIM;

select Mahasiswa.NIM, Nama, JumlahSks
from Mahasiswa, Sks
where Mahasiswa.NIM = Sks.NIM;

CREATE VIEW vw_mahasiswa_sks
AS
SELECT a.NIM, Nama, JumlahSks
FROM Mahasiswa a JOIN Sks b ON a.NIM = b.NIM;

select * from Mahasiswa;

select * from vw_mahasiswa_sks;

drop view vw_mahasiswa_sks;

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER //
CREATE FUNCTION returnInteger()
RETURNS INT
BEGIN
	RETURN 10;
END; //

DELIMITER ;

SELECT returnInteger();

DELIMITER //
CREATE FUNCTION returnWord()
RETURNS VARCHAR(10)
BEGIN
	RETURN 'HELLO';
END; //
DELIMITER ;

SELECT returnWord() ;

DELIMITER //
CREATE FUNCTION sksKurang(Jumlah INT) -- Jumlah
RETURNS INT
BEGIN
	RETURN (Jumlah - 10);
END; //
DELIMITER ;

select sksKurang(20);
select * from sks;

select NIM, sksKurang(JumlahSks)
from Sks;

SELECT * FROM Sks;

insert into Sks(NIM, JumlahSks) VALUES ('2001541871', 30);

select avg(JumlahSks) as 'Rata-rata'
from Sks;

select nim, sum(JumlahSks) as 'Total SKS'
from Sks
group by NIM
having sum(JumlahSks) > 10; -- Where + Aggregation = Having

DELIMITER //
CREATE PROCEDURE update_dan_select(p_nim  CHAR(10))
BEGIN
	update Sks
	set JumlahSks = sksKurang(JumlahSks) -- JumlahSks + 10
	WHERE NIM = p_nim ;
    
	select * from Sks WHERE NIM = p_nim ;
END; //
DELIMITER ;

DROP PROCEDURE update_dan_select;

SELECT * FROM sks;
CALL update_dan_select('2001541871');

-- Database: Review