--PHIEU GIAO BAI TAP 1--
--Cau 1
USE MASTER
GO
CREATE DATABASE QLTHUCTAP

ON PRIMARY(
	NAME = QLTT_DAT,
	FILENAME = 'D:\HQTCSDL\Tuan3\QLTTDAT.mdf',
	SIZE = 5MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = QLTT_LOG,
	FILENAME = 'D:\HQTCSDL\Tuan3\QLTTLOG.ldf',
	SIZE = 5MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 1MB
)

GO
USE QLTHUCTAP
GO

CREATE TABLE Khoa(
	makhoa char(10) NOT NULL PRIMARY KEY,
	tenkhoa char(30),
	dienthoai char(10)
)

CREATE TABLE GiangVien(
	magv int NOT NULL PRIMARY KEY,
	hotengv char(30),
	luong decimal(5,2),
	makhoa char(10) NOT NULL,
	CONSTRAINT FK_GV_K FOREIGN KEY(makhoa) REFERENCES Khoa(makhoa)
)

CREATE TABLE SinhVien(
	masv int NOT NULL PRIMARY KEY,
	hotensv char(30),
	makhoa char(10) NOT NULL,
	namsinh int,
	quequan char(30),
	CONSTRAINT FK_SV_K FOREIGN KEY(makhoa) REFERENCES Khoa(makhoa)
)

CREATE TABLE DeTai(
	madt char(10) NOT NULL PRIMARY KEY,
	tendt char(30),
	kinhphi int,
	NoiThucTap char(30)
)

CREATE TABLE HuongDan(
	masv int NOT NULL,
	madt char(10) NOT NULL,
	magv int NOT NULL,
	ketqua decimal(5,2),
	CONSTRAINT PK_HD PRIMARY KEY(masv, magv),
	CONSTRAINT FK_HD_SV FOREIGN KEY(masv) REFERENCES SinhVien(masv),
	CONSTRAINT FK_HD_DT FOREIGN KEY(madt) REFERENCES DeTai(madt),
	CONSTRAINT FK_HD_GV FOREIGN KEY(magv) REFERENCES GiangVien(magv)
)

DROP TABLE HuongDan
DROP TABLE DeTai
DROP TABLE SinhVien
DROP TABLE GiangVien
DROP TABLE Khoa

--Cau 2
--1. Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên

SELECT magv, hotengv, tenkhoa
FROM GiangVien
INNER JOIN Khoa
ON Khoa.makhoa = GiangVien.makhoa

--2. Đưa ra thông tin gồm mã số, họ tênvà tên khoa của các giảng viên của khoa
--‘DIA LY va QLTN’

SELECT magv, hotengv, tenkhoa
FROM GiangVien
INNER JOIN Khoa
ON Khoa.makhoa = GiangVien.makhoa
WHERE tenkhoa = 'DIA LY va QLTN'

--3. Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’

SELECT Khoa.makhoa, tenkhoa, COUNT(masv) as N'Số sinh viên khoa CONG NGHE SINH HOC'
FROM SinhVien
INNER JOIN Khoa
ON SinhVien.makhoa = Khoa.makhoa
WHERE tenkhoa = 'CONG NGHE SINH HOC'
GROUP BY Khoa.makhoa, tenkhoa

--4. Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa ‘TOAN’

SELECT masv, hotensv, tuoi = YEAR(GETDATE()) - namsinh
FROM SinhVien
INNER JOIN Khoa
ON Khoa.makhoa = SinhVien.makhoa
WHERE tenkhoa = 'TOAN'

--5. Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’

SELECT COUNT(magv) as N'Số giảng viên khoa CONG NGHE SINH HOC'
FROM GiangVien
INNER JOIN Khoa
ON Khoa.makhoa = GiangVien.makhoa
WHERE tenkhoa = 'CONG NGHE SINH HOC'

--6. Cho biết thông tin về sinh viên không tham gia thực tập

SELECT *
FROM SINHVIEN
WHERE masv NOT IN (SELECT masv 
				   FROM DeTai
				   INNER JOIN HuongDan
				   ON HuongDan.madt = DeTai.madt)

--7. Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa

SELECT khoa.makhoa, tenkhoa, COUNT(magv) as N'Tổng giảng viên của mỗi khoa'
FROM khoa
INNER JOIN GiangVien
ON Khoa.makhoa = GiangVien.makhoa
GROUP BY khoa.makhoa, tenkhoa

--8. Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học

SELECT tenkhoa, dienthoai
FROM Khoa
INNER JOIN Sinhvien
ON Khoa.makhoa = SinhVien.makhoa
WHERE hotensv = 'Le van son'

