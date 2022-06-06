use master
go

create database DeptEmp
on primary(
	name = 'DeptEmp_dat',
	filename = 'D:\Data\DeptEmp.mdf',
	size = 5MB, maxsize = 20MB, filegrowth = 20%
)
log on(
	name = 'DeptEmp_log',
	filename = 'D:\Data\DeptEmp.ldf',
	size = 1MB, maxsize = 5MB, filegrowth = 1MB
)
go
use DeptEmp
go
create table Department(
	DepartmentNo int not null primary key,
	DepartmentName char(25) not null,
	Locations char(25) not null
)

create table Employee(
	EmpNo int not null primary key,
	FName varchar(15) not null,
	LName varchar(25) not null,
	Job varchar(25) not null,
	HireDate datetime not null,
	Salary numeric not null,
	Commision numeric ,
	DepartmentNo int,
	constraint fk_Employee foreign key(DepartmentNo)
		references Department(DepartmentNo)
)

insert into Department values(10, 'Accounting', 'Melbourne'),
							 (20, 'Research', 'Adealide'),
							 (30, 'Sales', ' Sydney'),
							 (40, 'Operations', ' Perth')

insert into Employee values(1, 'John', 'Smith','Clerk', '12-17-1980', 800, null , 20),
							(2, 'Peter', 'Allen','Salesman', '11-20-1981', 1600, 300, 30),
							(3, 'Kate','Ward', 'Salesman', '11-22-1981',1250, 500, 30),
							(4, 'Jack','Jones', 'Manager', '07-02-1981',2975, null, 20),
							(5, 'Joe','Mảtin', 'Salesman', '09-28-1981',1250, 1400, 30)
--1
select*from Department
--2
select*from Employee
--3
select EmpNo, Fname, LName
from Employee
where Fname = 'Kate' 
--4
select 'Fullname' = Fname + ' ' + Lname , Salary ,Salary + Salary*10/100
FROM Employee