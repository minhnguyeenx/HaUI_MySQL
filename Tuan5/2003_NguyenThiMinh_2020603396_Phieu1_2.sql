use master
go

create database TRUONGHOC
on primary(
	name = 'THDAT',
	filename = 'D:\HQTCSDL\Tuan5\TH_DAT.mdf',
	size = 8MB,
	maxsize = 20MB,
	filegrowth = 20%
)
log on(
	name = 'THLOG',
	filename = 'D:\HQTCSDL\Tuan5\TH_LOG.ldf',
	size = 8MB,
	maxsize = 20MB,
	filegrowth = 1MB
)

drop database truonghoc

use truonghoc
go

create table HOCSINH(
	mahs char(5) not null primary key,
	ten nvarchar(30),
	nam bit,
	ngaysinh datetime,
	diachi nvarchar(20),
	diemtb float
)

create table GIAOVIEN(
	magv char(5) not null primary key,
	ten nvarchar(30),
	nam bit,
	ngaysinh datetime,
	diachi nvarchar(20),
	luong money
)

create table LOPHOC(
	malop char(5) not null primary key,
	tenlop nvarchar(30),
	soluong int
)

--Them du lieu
--insert 1 dòng
insert into HOCSINH values ('hs1', 'nguyen van a', 1, 2020-05-06, 'ha noi', 10)
--insert nhieu dong
insert into GIAOVIEN values ('gv1', 'nguyen thi b', 0, 2000-9-30, 'ha noi', 850),
							('gv2', 'nguyen thi c', 0, 2000-9-10, 'vinh phuc', 860)
insert into LOPHOC values ('lop10', 'lop 10', 10),
					      ('lop11', 'lop 11', 11)

--Sua du lieu 
update HOCSINH
set diemtb = 9.5
where mahs = 'hs1'
select * from HOCSINH

	-- su dung case
UPDATE LOPHOC
SET soluong = CASE malop when 'lop10' then 11
						 when 'lop11' then 12
						 else 13
		      END
select * from LOPHOC

--xoa du lieu
DELETE GIAOVIEN
where luong = 850
select * from GIAOVIEN


