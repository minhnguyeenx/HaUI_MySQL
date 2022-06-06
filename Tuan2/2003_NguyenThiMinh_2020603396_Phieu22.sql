USE MASTER
GO
CREATE DATABASE DeptEmp
ON PRIMARY(
	NAME = 'DeptEmp_DAT',
	FILENAME = 'D:\HQTCSDL\Tuan2\DeptEmpDAT.mdf',
	SIZE = 2MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = 'DeptEmp_LOG',
	FILENAME = 'D:\HQTCSDL\Tuan2\DeptEmpLOG.ldf',
	SIZE = 2MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 1MB
)

GO
USE DeptEmp
GO

CREATE TABLE Department(
	DepartmentNo Integer NOT NULL PRIMARY KEY,
	DepartmentName Char(25) NOT NULL,
	Location Char(25) NOT NULL
)

CREATE TABLE Employee(
	EmpNo Integer NOT NULL PRIMARY KEY,
	Fname Varchar(15) NOT NULL,
	Lname Varchar(15) NOT NULL,
	Job Varchar(25) NOT NULL,
	HireDate Datetime NOT NULL,
	Salary Numeric NOT NULL,
	Commision Numeric,
	DepartmentNo Integer,
	CONSTRAINT FK_Emp_Dept FOREIGN KEY(DepartmentNo) REFERENCES  Department(DepartmentNo)
)

DROP TABLE Department
DROP TABLE Employee

INSERT INTO Department VALUES (10, 'Accounting', 'Melbourne'),
							  (20, 'Research ', 'Adealide'),
							  (30, 'Sales', 'Sydney'),
							  (40, 'Operations', 'Perth')

INSERT INTO Employee VALUES (1, 'John', 'Smith', 'Cleck', '1980-Dec-17', 800,NULL, 20),
							  (2, 'Peter', 'Allen', 'Salesman', '1980-Dec-17', 1600,300, 30),
							  (3, 'Kate', 'Ward', 'Salesman', '1980-Dec-17', 1250,500, 30),
							  (4, 'Jack', 'Jones', 'Manager', '1980-Dec-17', 2975,NUll, 20),
							  (5, 'Joe', 'Martin', 'Salesman', '1980-Dec-17', 1250,1400, 30)

SELECT * FROM Department
SELECT * FROM Employee

