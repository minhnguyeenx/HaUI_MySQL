USE MASTER
GO
-- tạo/xóa/đọc thông tin CSDL quản lý bán hàng.
CREATE DATABASE QLBANHANG5
ON PRIMARY(
	NAME = 'QLBH5_DAT',
	FILENAME = 'D:\HQTCSDL\Tuan4\QLBH5DAT.mdf',
	SIZE = 5MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = 'QLBH5_LOG',
	FILENAME = 'D:\HQTCSDL\Tuan4\QLBH5LOG.ldf',
	SIZE = 5MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
)


-- Tạo các bảng dữ liệu, Đưa ra lược đồ quan hệ (Database Diagrams). 
GO
USE QLBANHANG5
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


-- Nhập dữ liệu cho các bảng trên.
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

-- Đưa ra dữ liệu vừa nhập
SELECT * FROM HangSX
SELECT * FROM NhanVien
SELECT * FROM SanPham
SELECT * FROM PNhap
SELECT * FROM Nhap
SELECT * FROM PXuat
SELECT * FROM Xuat

--BÀI 1
--a. Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020, gồm:
--SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.

SELECT Nhap.SoHDN, SanPham.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
FROM Nhap
INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN PNhap ON Nhap.SoHDN=PNhap.SoHDN
INNER JOIN NhanVien ON PNhap.MaNV = NhanVien.MaNVINNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
WHERE TenHang = 'Samsung' AND YEAR(NgayNhap) = 2017
 
--b. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2020, sắp xếp theo
--chiều giảm dần của SoLuongX.

SELECT TOP 10 Xuat.SoHDX, NgayXuat, SoLuongX
FROM XUAT
INNER JOIN PXuat ON Xuat.SoHDX=PXuat.SoHDX
WHERE YEAR(NgayXuat) = 2020
ORDER BY SoluongX DESC

--c. Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cữa hàng, theo chiều giảm dần
--giá bán.

SELECT TOP 10 MaSP, TenSP, Giaban
FROM SanPham
ORDER BY GiaBan DESC

--d. Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng Samsung.

SELECT MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
FROM SanPham
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
WHERE TenHang = ‘Samsung’ AND GiaBan BETWEEN 100.000 AND 500.000

--e. Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung.

SELECT Sum(SoLuongN*DonGiaN) AS N'Tổng tiền nhập'
FROM Nhap 
INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
INNER JOIN PNhap ON Nhap.SoHDN=PNhap.SoHDN
WHERE YEAR(NgayNhap)=2020 AND TenHang = 'Samsung'

--f. Thống kê tổng tiền đã xuất trong ngày 14/06/2020.

SELECT  SUM(SoLuongX*GiaBan) As N'Tổng tiền xuất'
FROM Xuat
INNER JOIN SanPham on Xuat.MaSP = SanPham.MaSP
INNER JOIN PXuat on Xuat.SoHDX=PXuat.SoHDX
WHERE NgayXuat = '06/14/2020'

--g. Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020

SELECT Nhap.SoHDN,NgayNhap
FROM Nhap 
INNER JOIN PNhap ON Nhap.SoHDN=PNhap.SoHDN
WHERE Year(NgayNhap)=2020 And SoLuongN*DonGiaN =(SELECT MAX(SoLuongN*DonGiaN)
												FROM Nhap INNER JOIN PNhap ON
												Nhap.SoHDN=PNhap.SoHDN
												WHERE YEAR(NgayNhap)=2020
												)

--BÀI 2

--a. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm

SELECT HangSX.MaHangSX, TenHang, COUNT(*) AS N'Số lượng sp'
From SanPham 
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
GROUP BY HangSX.MaHangSX, TenHang

--b. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.

SELECT SanPham.MaSP,TenSP, sum(SoLuongN*DonGiaN) AS N'Tổng tiền nhập'
FROM Nhap 
INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN PNhap ON PNhap.SoHDN=Nhap.SoHDN
WHERE YEAR(NgayNhap)=2020
GROUP BY SanPham.MaSP,TenSP

--c. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản
--phẩm của hãng Samsung.

SELECT SanPham.MaSP,TenSP,SUM(SoLuongX) AS N'Tổng xuất'
FROM Xuat 
INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
INNER JOIN HangSX ON HangSX.MaHangSX = SanPham.MaHangSX
INNER JOIN PXuat ON Xuat.SoHDX=PXuat.SoHDX
WHERE YEAR(NgayXuat)=2018 AND TenHang = 'Samsung'
GROUP BY SanPham.MaSP,TenSP
HAVING SUM(SoLuongX) >=10000

--d. Thống kê số lượng nhân viên Nam của mỗi phòng ban.

SELECT TenPhong, COUNT(MaNV) AS 'Số lượng nhân viên Nam'
FROM NhanVien
GROUP BY TenPhong

--e. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.

SELECT TenHang, SUM(SoLuongN) AS 'Tổng số lượng nhập'
FROM HangSX
INNER JOIN SanPham ON HangSX.MaHangSX = SanPham.MaHangSX
INNER JOIN Nhap ON SanPham.MaSP = Nhap.MaSP
INNER JOIN PNhap ON PNhap.SoHDN = Nhap.SoHDN
WHERE YEAR(NgayNhap) = 2018
GROUP BY TenHang

--f. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao
--nhiêu.SELECT TenNV, SUM(SoLuongX*GiaBan) AS 'Tổng lượng tiền xuất'
FROM PXuat 
INNER JOIN Xuat ON PXuat.SoHDX = Xuat.SoHDX
INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
INNER JOIN NhanVien ON NhanVien.MaNV = PXuat.MaNV
WHERE YEAR(NgayXuat) = 2018
GROUP BY TenNV
