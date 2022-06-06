--PHIEU GIAO BAI TAP 11--
--a, b
CREATE DATABASE QLBANHANG2

ON PRIMARY(
	NAME = QLBH_DAT,
	FILENAME = 'D:\HQTCSDL\Tuan1\QLBHDAT.mdf',
	SIZE = 20MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = QLBH_LOG,
	FILENAME = 'D:\HQTCSDL\Tuan1\QLBHLOG.ldf',
	SIZE = 10MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 1MB
)

GO
USE QLBANHANG2
GO

CREATE TABLE CongTy(
	MaCT char(10) NOT NULL PRIMARY KEY,
	TenCT nvarchar(40) NOT NULL,
	TrangThai nvarchar(10),
	ThanhPho nvarchar(30),
)

CREATE TABLE SanPham(
	MaSP char(10) NOT NULL PRIMARY KEY,
	TenSP nvarchar(10) NOT NULL,
	MauSac nvarchar(10) DEFAULT N'ĐỎ',
	Gia money,
	SoLuongCo int,
	CONSTRAINT UNIQUE_TENSP UNIQUE(TenSP)
)

CREATE TABLE CungUng(
	MaCT char(10) NOT NULL,
	MaSP char(10) NOT NULL,
	SoLuongBan int,
	CONSTRAINT PK_CungUng PRIMARY KEY(MaCT, MaSP),
	CONSTRAINT CHK_SL CHECK(SoLuongBan > 0),
	CONSTRAINT FK_CU_CT FOREIGN KEY(MaCT) REFERENCES CongTy(MaCT),
	CONSTRAINT FK_CU_SP FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
)

DROP TABLE CungUng
DROP TABLE CongTy
DROP TABLE SanPham

--c
INSERT INTO CongTy VALUES ('CT01',N'Công ty 1', N'BT', N'Hà Nội'),
						  ('CT02',N'Công ty 2', N'BT', N'Phú Thọ'),
						  ('CT03',N'Công ty 3', N'BT', N'Hà Nội')

INSERT INTO SanPham VALUES ('SP01', N'Điều hòa', N'Trắng', 1000, 200),
						   ('SP02', N'Tủ lạnh', N'Đen', 2000, 20),
						   ('SP03', N'Ti vi', N'Trắng', 1000, 15)

INSERT INTO CungUng VALUES ('CT01', 'SP01', 1),
						   ('CT01', 'SP02', 2),
						   ('CT01', 'SP03', 4),
						   ('CT02', 'SP01', 3),
						   ('CT02', 'SP02', 6),
						   ('CT03', 'SP01', 5)

--d
SELECT * FROM CongTy
SELECT * FROM Sanpham
SELECT * FROM CungUng