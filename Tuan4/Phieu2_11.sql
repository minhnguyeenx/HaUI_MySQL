use master
go

create database MarkManagement
on primary(
	name = 'MarkManagement_dat',
	filename = 'D:\Data\MarkManagement.mdf',
	size = 5MB, maxsize = 20MB, filegrowth = 20%
)
log on(
	name = 'MarkManagement_log',
	filename = 'D:\Data\MarkManagement.ldf',
	size = 1MB, maxsize = 5MB, filegrowth = 1MB
)
go
use MarkManagement
go

create table Students(
	StudentID nvarchar(12) not null primary key,
	StudentName nvarchar(25) not null,
	DateOfBirth datetime,
	Email nvarchar(40),
	Phone nvarchar(12),
	class nvarchar(10)
)

create table Subjects(
	SubjectID nvarchar(10) not null primary key,
	SubjectName nvarchar(25) not null
)

create table Marks(
	StudentID nvarchar(12) not null,
	SubjectID nvarchar(10) not null,
	Date datetime,
	Theory tinyint,
	Practical tinyint,
	constraint PK_Marks primary key(StudentID, SubjectID),
	constraint fk_Mark_Student foreign key(StudentID)
		references Students(StudentID),
	constraint fk_Marks_Subject foreign key(SubjectID)
		references Subjects(SubjectID)
)

insert into Students values ('AV0807005',N'Mai Trung Hiếu', '10-11-1989' , 'trunghieu@yahoo.com', '0904115116','AV1'),
							('AV0807006',N'Nguyễn Quý Hùng', '12-02-1988' , 'quyhung@yahoo.com', '0955667787','AV2'),
							('AV0807007',N'Đỗ Đắc Huỳnh', '02-01-1989' , 'dachuynh@yahoo.com', '0988574747','AV2'),
							('AV0807009',N'An Đăng Khuê', '03-06-1989' , 'dangkhue@yahoo.com', '0986757463','AV1'),
							('AV0807010',N'Nguyễn Thị Tuyết Lan', '07-12-1989' , 'tuyetlan@yahoo.com', '0983310432','AV2'),
							('AV0807011',N'Đinh Phụng Long', '12-02-1989' , 'phunglong@yahoo.com','' ,'AV1'),
							('AV0807012',N'Nguyên Tuấn Nam', '02-03-1989' , 'tuannam@yahoo.com', '','AV1')

insert into Subjects values('S001','SQL'),
						   ('S002','Java Simplefield'),
						   ('S003','Active Sever Page')

insert into Marks values('AV0807005','S001', '05-06-2008',8, 25),
						('AV0807006','S002', '05-06-2008', 16, 30),
						('AV0807007','S001', '05-06-2008', 10, 25),
						('AV0807009','S003', '05-06-2008', 7, 13),
						('AV0807010','S003', '05-06-2008', 9, 16),
						('AV0807011','S002', '05-06-2008', 8, 30),
						('AV0807012','S001', '05-06-2008', 7, 31),
						('AV0807005','S002', '06-06-2008', 12, 11),
						('AV0807010','S001', '06-06-2008', 7, 6)

select*from Students
select*from Subjects
select*from Marks