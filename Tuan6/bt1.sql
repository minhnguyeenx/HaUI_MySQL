USE MASTER
GO

CREATE DATABASE QLLUONG
ON PRIMARY(
	NAME = 'QLLUONGDAT',
	FILENAME = 'D:\SQL\QLLUONGDAT.mdf',
	SIZE = 15MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
LOG ON(
	NAME = 'QLLUONGLOG',
	FILENAME = 'D:\SQL\QLLUONGLOG.ldf',
	SIZE = 15MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 10%
)

USE QLLUONG
GO

CREATE TABLE Donvi(
	madv char(10) NOT NULL PRIMARY KEY,
	tendonvi nvarchar(30),
	dienthoai char(12)
)

CREATE TABLE Chucvu(
	macv char(10) NOT NULL PRIMARY KEY,
	tencv nvarchar(30),
	phucap money
)

CREATE TABLE Nhanvien(
	manv char(10) NOT NULL PRIMARY KEY,
	hoten nvarchar(30),
	ngaysinh date,
	gioitinh bit,
	hsluong float,
	trinhdo nvarchar(20),
	madv char(10) NOT NULL,
	macv char(10) NOT NULL,
	CONSTRAINT FK_NV_DV FOREIGN KEY(madv) REFERENCES Donvi(madv),
	CONSTRAINT FK_NV_CV FOREIGN KEY(macv) REFERENCES Chucvu(macv)
)

INSERT INTO Donvi VALUES('DV001', N'Vận chuyển', '098732234'),
					   ('DV002', N'Viao hàng', '098732234'),
					   ('DV003', N'Đóng gói', '098732234')

INSERT INTO Chucvu VALUES('CV001',N'Kế toán', 100),
						 ('CV002',N'Giáo viên', 200),
						 ('CV003',N'Kế toán', 300)

INSERT INTO Nhanvien VALUES('NV001', N'Nguyễn Thị A', '2002-01-01', 0, 2.3, N'Cử nhân', 'DV001', 'CV002'),
						 ('NV002', N'Nguyễn Văn B', '1997-01-28', 1, 2.4, N'Cử nhân', 'DV002', 'CV001'),
						 ('NV003', N'Nguyễn Thị C', '2001-04-28', 0, 2.5, N'Tiến sĩ', 'DV003', 'CV002'),
						 ('NV004', N'Nguyễn Văn D', '2003-10-01', 1, 2.6, N'Cử nhân', 'DV001', 'CV003')

--1
SELECT manv, hoten, ngaysinh,hsluong, luong = hsluong*830000+phucap
FROM Nhanvien
INNER JOIN Chucvu ON Chucvu.macv = Nhanvien.macv

--2
SELECT manv, hoten, CASE 
					WHEN gioitinh = 1 THEN N'Nam'
					ELSE N'Nữ'
					END AS gioitinh, hsluong, trinhdo, tendonvi
FROM Nhanvien
INNER JOIN Donvi ON Donvi.madv = Nhanvien.madv
WHERE trinhdo = N'Cử nhân'
ORDER BY hsluong DESC

--3
SELECT MaNV, Hoten, Tuoi = DATEDIFF(YY, ngaysinh, GETDATE()) INTO NV_NU
FROM nhanvien
WHERE gioitinh = 0

SELECT * FROM NV_NU 

--4
SELECT 	manv,hoten,ngaysinh,gioitinh,hsluong,trinhdo,madv,macv
FROM Nhanvien
WHERE hoten LIKE '%Anh'
	  AND hsluong >= 2.67
	  and hsluong <= 8.0

--5
SELECT manv,hoten
FROM Nhanvien
WHERE (gioitinh = 1 AND DATEDIFF(YY, ngaysinh, GETDATE()) >= 60) 
	  OR (gioitinh = 0 AND DATEDIFF(YY, ngaysinh, GETDATE()) >= 55)

--6
SELECT Donvi.madv, tendonvi, COUNT(Nhanvien.manv) as N'Số người'
FROM Donvi
INNER JOIN Nhanvien ON Nhanvien.madv = Donvi.madv
GROUP BY Donvi.madv, tendonvi

--7
SELECT Donvi.madv, tendonvi, SUM(Hsluong*830000+Phucap) as N'Tổng lương'
FROM Donvi
INNER JOIN Nhanvien ON Nhanvien.madv = Donvi.madv
INNER JOIN Chucvu ON Nhanvien.macv = Chucvu.macv
GROUP BY Donvi.madv, tendonvi

--8
SELECT 	manv,hoten,ngaysinh,gioitinh,hsluong,trinhdo,madv,macv
FROM Nhanvien
WHERE DAY(ngaysinh) = (SELECT DAY(ngaysinh)
						FROM Nhanvien
						WHERE MaNV = 'NV0012')

--9
SELECT manv, hoten, Hsluong*830000+Phucap
FROM Nhanvien
INNER JOIN Chucvu ON Nhanvien.macv = Chucvu.macv
WHERE Hsluong*830000+Phucap = (SELECT MAX(Hsluong*830000+Phucap)
							   FROM Nhanvien
							   INNER JOIN Chucvu ON Nhanvien.macv = Chucvu.macv)

--10
SELECT AVG(DATEDIFF(YY, ngaysinh, GETDATE())) AS N'Tuổi tb'
FROM Nhanvien
INNER JOIN ChucVu ON Nhanvien.macv = Chucvu.macv
WHERE tencv = N'Trưởng phòng'

--11
SELECT Donvi.madv, Tendonvi, Dienthoai, Songuoi = COUNT(*)
FROM Nhanvien
INNER JOIN Donvi ON Nhanvien.madv = Donvi.madv
GROUP BY Donvi.madv, Tendonvi, Dienthoai
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM Nhanvien
					   GROUP BY madv)

--12
SELECT Donvi.madv, Tendonvi, Dienthoai, SUM(hsluong*8300000+phucap)
FROM Nhanvien
INNER JOIN Donvi ON Nhanvien.madv = Donvi.madv
INNER JOIN Chucvu ON Nhanvien.macv = Chucvu.macv
GROUP BY Donvi.madv, Tendonvi, Dienthoai
HAVING SUM(hsluong*8300000+phucap) >= ALL(SELECT SUM(hsluong*8300000+phucap)
										  FROM Nhanvien
										  INNER JOIN Chucvu ON Nhanvien.macv = Chucvu.macv
										  GROUP BY madv)

--13
DELETE FROM Donvi
WHERE madv NOT IN (SELECT madv FROM Nhanvien)

--14
UPDATE Chucvu
SET phucap = CASE trinhdo
					WHEN N'trung cấp' THEN phucap
					WHEN N'cao đẳng' THEN phucap*1.1
					WHEN N'đại học' THEN phucap*1.2
					ELSE phucap*1.3 
			 END
FROM nhanvien
WHERE Nhanvien.macv = Chucvu.macv
