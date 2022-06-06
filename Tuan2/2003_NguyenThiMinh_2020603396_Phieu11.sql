USE MASTER
GO
CREATE DATABASE MarkManagement
ON PRIMARY(
	NAME = 'QLSV3_DAT',
	FILENAME = 'D:\HQTCSDL\Tuan2\QLSV3DAT.mdf',
	SIZE = 2MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = 'QLSV_LOG',
	FILENAME = 'D:\HQTCSDL\Tuan2\QLSV3LOG.ldf',
	SIZE = 2MB,
	MAXSIZE = 15MB,
	FILEGROWTH = 1MB
)

GO
USE MarkManagement
GO

CREATE TABLE Students(
	StudentID Nvarchar(12) NOT NULL PRIMARY KEY ,
	StudentName Nvarchar(25) NOT NULL,
	DateofBirth Datetime NOT NULL,
	Email Nvarchar(40),
	Phone Nvarchar(12),
	Class Nvarchar(10)
)

CREATE TABLE Subjects(
	SubjectID Nvarchar(10) NOT NULL PRIMARY KEY,
	SubjectName Nvarchar(25) NOT NULL
)

CREATE TABLE Mark(
	StudentID Nvarchar(12) NOT NULL,
	SubjectID Nvarchar(10) NOT NULL,
	Theory Tinyint,
	Practical Tinyint,
	Date Datetime,
	CONSTRAINT PK_Mark PRIMARY KEY(StudentID, SubjectID),
	CONSTRAINT FK_Mark_Student FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
	CONSTRAINT FK_Mark_Subjects FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)
)

DROP TABLE Mark
DROP TABLE Subjects
DROP TABLE Students

INSERT INTO Students VALUES('AV0807005', N'Mail Trung Hiếu', '1989-10-11', 'trunghieu@yahoo.com', '0904115116 ', 'AV1'),
						   ('AV0807006', N'Nguyễn Quý Hùng', '1988-12-2', 'quyhung@yahoo.com', '0904115116 ', 'AV2'),
						   ('AV0807007', N'Đỗ Đắc Huỳnh', '1990-1-2', 'dachuynh@yahoo.com', '0904115116 ', 'A2'),
						   ('AV0807009', N'An Đăng Khuê', '1986-6-3', 'dangkhue@yahoo.com', '0904115116 ', 'AV1'),
						   ('AV0807010', N'Nguyễn T. Tuyết Lan', '1989-7-12', 'tuyetlan@gmail.com', '0904115116 ', 'AV2'),
						   ('AV0807011', N'Đinh Phụng Long', '1990-12-2', 'phunglong@yahoo.com','', 'AV1'),
						   ('AV0807012', N'Nguyễn Tuấn Nam', '1990-3-2', 'tuannam@yahoo.com','', 'AV1')

INSERT INTO Subjects VALUES ('S001', N'SQL'),
						    ('S002', N'Java Simplefield'),
							('S003', N'Active Server Page')

INSERT INTO Mark VALUES ('AV0807005', 'S001', 8, 25, '2008-5-6'),
						('AV0807006', 'S002', 16, 30, '2008-5-6'),
						('AV0807007', 'S001', 10, 25, '2008-5-6'),
						('AV0807009', 'S003', 7, 13, '2008-5-6'),
						('AV0807010', 'S003', 9, 16, '2008-5-6'),
						('AV0807011', 'S002', 8, 30, '2008-5-6'),
						('AV0807012', 'S001', 7, 31, '2008-5-6'),
						('AV0807005', 'S002', 12, 11, '2008-6-6'),
						('AV0807010', 'S001', 7, 6, '2008-6-6')

SELECT * FROM Students	
SELECT * FROM Subjects	
SELECT * FROM Mark
