--PHIEU 5.11
use QLKHO
go
create table nhap(
	sohdn char(10) not null primary key,
	mavt char(10) not null,
	soluongn int,
	dongian money,
	ngayn date
)
create table xuat(
	sohdx char(10) not null primary key,
	mavt char(10) not null,
	soluongx int,
	dongiax money,
	ngayx date
)
create table ton(
	mavt char(10) not null primary key,
	tenvt nvarchar(30),
	soluongt int
)
--Bai 2
--Thống kê tiền bán theo mã vật tư gồm MaVT, TenVT, TienBan
--(TienBan=SoLuongX*DonGiaX) 
create view tienbanvt
as
select ton.mavt, tenvt,sum(soluongx*dongiax) as 'tien ban'
from ton
inner join xuat on ton.mavt = xuat.mavt
group by ton.mavt, tenvt
drop view tienbanvt
select * from tienbanvt
--Bai 3
--Thống kê soluongxuat theo tên vattu
create view bai3_11
as
select tenvt, sum(soluongx) as	N'số lượng xuất'
from ton
inner join xuat on ton.mavt = xuat.mavt
group by tenvt

select * from bai3_11
--Bai 4
-- Thống kê soluongnhap theo tên vật tư
create view bai4_12
as
select tenvt, sum(soluongn) as	N'số lượng nhap'
from ton
inner join nhap on ton.mavt = nhap.mavt
group by tenvt

select * from bai4_12
--bai 5
--Đưa ra tổng soluong còn trong kho biết còn = nhap – xuất + tồn theo
--từng nhóm vật tư
create view bai5_11
as
select ton.mavt,sum(soluongn) - sum(soluongx) + sum(soluongt) as tongton 
from ton
inner join xuat on ton.mavt = xuat.mavt
inner join nhap on ton.mavt = nhap.mavt
group by ton.mavt

drop view bai5_11
select * from bai5_11

--PHIEU 5.22
use QLSV
go
create table lop(
	malop char(10) not null primary key,
	tenlop nvarchar(30),
	phong int
)
create table sv(
	masv char(10) not null primary key,
	tensv nvarchar(30),
	malop char(10) not null, 
	constraint fk_sv_lop foreign key(malop) references lop(malop)
)

--Cau 1
--Viết hàm thống kê xem mỗi lớp có bao nhiêu sinh viên với malop là tham số truyền vào
--từ bàn phím. create function cau1_22(@malop char(10)) returns int as begin	declare @sosv int	set @sosv = (select count(masv) from sv				 where malop = @malop				 group by malop)	return @sosv end select dbo.cau1_22('lop2')
--Cau 2
--Đưa ra danh sách sinh viên(masv,tensv) học lớp với tenlop được truyền vào từ bàn phím
create function cau2_22(@tenlop nvarchar(30))
returns @danhsachcunglop table(masv char(10), tensv nvarchar(30))
as
begin
	insert into @danhsachcunglop select masv, tensv
								 from sv inner join lop on sv.malop = lop.malop
								 where tenlop = @tenlop
	return
end

select * from cau2_22('lop 3')

--Cau 3
--Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp, với tên lớp
--được nhập từ bàn phím. Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp, ngược lại nếu
--lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó.
create function cau3_22(@tenlop nvarchar(30))
returns @danhsach2 table(malop char(10), tenlop nvarchar(30), slsv int)
as
begin
	if(not exists(select malop from lop where tenlop = @tenlop))
		insert into @danhsach2
		select lop.malop, tenlop, count(masv)
		from sv inner join lop on sv.malop = lop.malop
		group by lop.malop, tenlop
	else
		insert into @danhsach2
		select lop.malop, tenlop, count(masv)
		from sv inner join lop on sv.malop = lop.malop
		where tenlop = @tenlop
		group by lop.malop, tenlop
		return
end

select * from cau3_22('lop 6')\

--4
-- Đưa ra phòng học của tên sinh viên nhập từ bàn phím.
create function cau4_22(@tensv nvarchar(30))
returns @danhsach table(masv char(10), tensv nvarchar(30), phong int)
as
begin
	if(not exists (select tensv from sv where tensv = @tensv))
		insert into @danhsach
		select masv, tensv, phong from sv
		inner join lop on lop.malop = sv.malop
	else
		insert into @danhsach
		select masv, tensv, phong from sv
		inner join lop on lop.malop = sv.malop
		where tensv = @tensv
		return
end

select * from cau4_22('nguyen van g')

--5 Đưa ra thống kê masv,tensv, tenlop với tham biến nhập từ bàn phím là phòng. Nếu phòng
--không tồn tại thì đưa ra tất cả các sinh viên và các phòng. Neu phòng tồn tại thì đưa ra các
--sinh vien của các lớp học phòng đó (Nhiều lớp học cùng phòng)
create function cau5_22(@phong int)
returns @danhsach table(masv char(10), tensv char(30), tenlop char(30), phong int)
as
begin
	if(not exists (select phong from lop where phong = @phong))
		insert into @danhsach
		select masv, tensv, tenlop, phong from sv 
		inner join lop on sv.malop = lop.malop
	else
		insert into @danhsach
		select masv, tensv, tenlop, phong from sv 
		inner join lop on sv.malop = lop.malop
		where phong = @phong
		return
end
select * from cau5_22(3)

--Cau 6
--Viết hàm thống kê xem mỗi phòng có bao nhiêu lớp học. Nếu phòng không tồn tại trả
--về giá trị 0

create function cau6_22(@phong int)
returns int
as
begin
	declare @dem int
	if(not exists (select phong from lop where phong = @phong))
		set @dem = 0
	else
		set @dem = (select count(malop) from lop 
					where phong = @phong 
					group by phong)
	return @dem
end

select dbo.cau6_22(4)