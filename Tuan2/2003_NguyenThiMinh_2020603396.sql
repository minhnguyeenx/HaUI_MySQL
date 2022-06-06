USE MASTER
GO
--a. Hãy tạo/xóa/đọc thông tin CSDL quản lý bán hàng.
CREATE DATABASE QLBANHANG4
ON PRIMARY(
	NAME = 'QLSV_DAT',
	FILENAME = 'D:\HQTCSDL\Tuan2\QLBHDAT.mdf',
	SIZE = 5MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = 'QLSV_LOG',
	FILENAME = 'D:\HQTCSDL\Tuan2\QLBHLOG.ldf',
	SIZE = 5MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 1MB
)


--b. Tạo các bảng dữ liệu, Đưa ra lược đồ quan hệ (Database Diagrams). 
GO
USE QLBANHANG4
GO

CREATE TABLE HangSX(
	MaHangSX nchar(10) NOT NULL PRIMARY KEY,
	TenHang nvarchar(20),
	DiChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30)
)

CREATE TABLE NhanVien(
	MaNV nchar(10) NOT NULL PRIMARY KEY, 
	TenNV nvarchar(20), 
	GioiTinh nvarchar(10), 
	DiaChi nvarchar(30), 
	SoDT nvarchar(20), 
	Email nvarchar(30), 
	TenPhong nvarchar(30)
)

CREATE TABLE SanPham(
	MaSP nchar(10) NOT NULL PRIMARY KEY, 
	MaHangSX nchar(10) NOT NULL, 
	TenSP nvarchar(20), 
	SoLuong int, 
	MauSac nvarchar(10), 
	GiaBan money, 
	DonViTinh nchar(10), 
	MoTa ntext,
	CONSTRAINT FK_SP_HSX FOREIGN KEY(MaHangSX) REFERENCES HangSX(MaHangSX)
)

CREATE TABLE PNhap(
	SoHDN nchar(10) NOT NULL PRIMARY KEY,
	NgayNhap date,
	MaNV nchar(10) NOT NULL,
	CONSTRAINT FK_PN_NV FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV)
)


CREATE TABLE Nhap(
	SoHDN nchar(10) NOT NULL, 
	MaSP nchar(10) NOT NULL, 
	SoLuongN int, 
	DonGiaN money,
	CONSTRAINT PK_Nhap PRIMARY KEY(SoHDN, MaSP),
	CONSTRAINT FK_HDN_PN FOREIGN KEY(SoHDN) REFERENCES PNhap(SoHDN),
	CONSTRAINT FK_HDN_SP FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
)

CREATE TABLE PXuat(
	SoHDX nchar(10) NOT NULL PRIMARY KEY,
	NgayXuat date,
	MaNV nchar(10) NOT NULL,
	CONSTRAINT FK_PX_NV FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV)
)

CREATE TABLE Xuat(
	SoHDX nchar(10) NOT NULL, 
	MaSP nchar(10) NOT NULL, 
	SoLuongX int,
	CONSTRAINT PK_Xuat PRIMARY KEY(SoHDX, MaSP),
	CONSTRAINT FK_HDX_PX FOREIGN KEY(SoHDX) REFERENCES PXuat(SoHDX),
	CONSTRAINT FK_HDX_SP FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
)

DROP TABLE Xuat
DROP TABLE Nhap
DROP TABLE PNhap
DROP TABLE PXuat
DROP TABLE SanPham
DROP TABLE NhanVien
DROP TABLE HangSX


--c. Nhập dữ liệu cho các bảng trên.
INSERT INTO HangSX VALUES ('H01', N'SamSung', N'Korea', '011-08271717', 'ss@gmail.com.kr'),
						  ('H02', N'OPPO', N'China', '081-08626262', 'oppo@gmail.com.cn'),
						  ('H03', N'Vinfone', N'Việt Nam', '084-098262626', 'vf@gmail.com.vn')
						 
INSERT INTO NhanVien VALUES('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
						   ('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư'),
						   ('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388', 'hb@gmail.com', N'Kế toán')

INSERT INTO SanPham VALUES('SP01', 'H02', N'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
						  ('SP02', 'H01', N'Galaxy Note 11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
						  ('SP03', 'H02', N'F3 Lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
						  ('SP04', 'H03', N'Vjoy3', 200, N'Xám', 1500000 , N'Chiếc', N'Hàng phổ thông'),
						  ('SP05', 'H01', N'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')
INSERT INTO PNhap VALUES('N01', '2019-02-05', 'NV01'),
						('N02', '2020-04-07', 'NV02'),
						('N03', '2020-05-17', 'NV02'),
						('N04', '2020-03-22', 'NV03'),
						('N05', '2020-07-07', 'NV01')

INSERT INTO Nhap VALUES('N01', 'SP02', 10, 17000000),
					   ('N02', 'SP01', 30, 6000000),
					   ('N03', 'SP04', 20, 1200000),
					   ('N04', 'SP01', 10, 6200000),
					   ('N05', 'SP05', 20, 7000000)

INSERT INTO PXuat VALUES('X01', '2020-06-14', 'NV02'),
						('X02', '2019-03-05', 'NV02'),
						('X03', '2020-12-12', 'NV02'),
						('X04', '2020-06-02', 'NV02'),
						('X05', '2020-05-18', 'NV02')

INSERT INTO Xuat VALUES('X01', 'SP03', 5),
					   ('X02', 'SP01', 3),
					   ('X03', 'SP02', 1),
					   ('X04', 'SP03', 2),
					   ('X05', 'SP05', 1)

--d. Đưa ra dữ liệu vừa nhập
SELECT * FROM HangSX
SELECT * FROM NhanVien
SELECT * FROM SanPham
SELECT * FROM PNhap
SELECT * FROM Nhap
SELECT * FROM PXuat
SELECT * FROM Xuat


