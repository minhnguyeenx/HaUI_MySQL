﻿--PHIEU GIAO BAI TAP 11--
--a, b
CREATE DATABASE QLSINHVIEN2

ON PRIMARY(
	NAME = QLSV_DAT,
	FILENAME = 'D:\HQTCSDL\Tuan1\QLSVDAT.mdf',
	SIZE = 15MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = QLSV_LOG,
	FILENAME = 'D:\HQTCSDL\Tuan1\QLSVLOG.ldf',
	SIZE = 5MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 1MB)

GO
USE QLSINHVIEN2
GO

CREATE TABLE SV(
	MaSV char(10) NOT NULL PRIMARY KEY,
	TenSV nvarchar(30) NOT NULL,
	QUE nvarchar(30)
)

CREATE TABLE MON(
	MaMH char(10) NOT NULL PRIMARY KEY,
	TenMH nvarchar(30) NOT NULL,
	SoTC int DEFAULT 3,
	CONSTRAINT UNIQUE_TenMH UNIQUE(TenMH)
)

CREATE TABLE KQ(
	MaSV char(10) NOT NULL,
	MaMH char(10) NOT NULL,
	Diem float
	CONSTRAINT PK_KQ PRIMARY KEY(MaSV, MaMH),
	CONSTRAINT CHK_DIEM CHECK(Diem >= 0 AND Diem <= 10),
	CONSTRAINT FK_KQ_SV FOREIGN KEY(MaSV) REFERENCES SV(MaSV),
	CONSTRAINT FK_KQ_MON FOREIGN KEY(MaMH) REFERENCES MON(MaMH),
)

--c
INSERT SV VALUES ('0001', N'Nguyễn Văn A', N'Hà Nội'),
			     ('0002', N'Nguyễn Văn B', N'Hải Phòng'),
			     ('0003', N'Nguyễn Văn C', N'Hà Nội')

INSERT INTO MON VALUES ('M1', N'HQTCSDL', 4),
					   ('M2', N'CSDL', 2)
INSERT INTO MON(MaMH, TenMH) VALUES('M3', N'Toán cao cấp')


INSERT INTO KQ VALUES ('0001', 'M1', 5.5),
					  ('0001', 'M2', 10),
					  ('0002', 'M1', 9),
					  ('0001', 'M3', 10),
					  ('0002', 'M2', 8),
					  ('0002', 'M3', 9.5)

--d
SELECT * FROM SV
SELECT * FROM MON
SELECT * FROM KQ
