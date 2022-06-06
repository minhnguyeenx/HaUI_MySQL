use abc
go
create table hangsx(mahang nchar(10) not null primary key,
tenhang nvarchar(20) not null,
diachi nvarchar(20)
)
create table sanpham(masp nchar(10) not null primary key,
tensp nvarchar(20),mausac nvarchar(20),soluong int,
giaban money,mahang nchar(10),
constraint fk_sp_hsx foreign key(mahang) references
hangsx(mahang))
create table hoadon(sohd nchar(10) not null primary key,
masp nchar(10),soluongban int,ngayban date,
constraint fk_hd_sp foreign key(masp) references
sanpham(masp))
------------------------
insert into hangsx values('H01',N'Samsung',N'hàn xẻng'),
 ('H02',N'Oppo',N'Tung cửa'),
('H03',N'Appo',N'Mẽo')
insert into sanpham values('SP01',N'S21 pờ
nút',N'Xám',200,21000000,'H01'),
('SP02',N'Neo 7',N'Nâu',100,13000000,'H02'),
('SP03',N'S21 untral',N'Đỏ',300,15000000,'H01')
select * from sanpham
select * from hoadon

hangsx(mahang,tenhang,diachi)
Sanpham(masp,tensp,mausac,soluong,giaban,mahang)
hoadon(sohd,masp,soluongban,ngayban)
--vd1: viết trigger kiểm soát việc thêm mới 1 hoadon, hãy kiểm
--tra xem masp có trong bảng sanpham hay không? soluongban<=soluong
--trong bảng sanpham hay không? nếu thỏa mãn thì cho phép
--bán (insert) và cập nhật lại soluong trong bảng sanpham:
--soluong = soluong - soluongban
create trigger trg_inserthd
on hoadon
for insert
as
begin
	declare @masp nchar(10)
	select @masp = masp from inserted
	if(not exists (select masp from sanpham where masp = @masp))
		begin
			print 'Khong ton tai ma nay'
			rollback transaction
		end
	else
		begin
			declare @slban int
			declare @slco int
			select @slban = soluongban from inserted
			select @slco = soluong from sanpham where masp = @masp
			if(@slco < @slban)
				begin
					print 'Khong du hang'
					rollback transaction
				end
			else 
				begin
					update sanpham
					set soluong = soluong - @slban
					where masp = @masp
				end
		end
end

select *from sanpham
select * from hoadon

drop trigger trg_insertHD

insert into hoadon values('HD01','SP01',7,'3/5/2022')
insert into hoadon values('HD02','SP03',9,'3/5/2022')
insert into hoadon values('HD03','SP02',20,'3/5/2022')
--vd2: viết trigger kiểm soát việc xóa dữ liệu bảng hoadon,
--cập nhật lại soluong trong bảng sanpham.
create trigger trg_deletehd
on hoadon
for delete
as
begin
	declare @slban int
	declare @masp nchar(10)
	select @masp =  masp from deleted
	select @slban = soluongban from deleted
	update sanpham
	set soluong = soluong + @slban
	where masp = @masp
end
drop trigger trg_deletehd
select * from sanpham
select * from hoadon
delete from hoadon  where sohd = 'HD01'

--Vd3: Tạo Trigger cập nhật lại soluongban trong bảng hoadon,
--hãy kiểm tra xem có đủ hàng không? nếu có thì cho phép
--cập nhật
create trigger trg_updatehd
on hoadon
for update
as
begin
	declare @masp nchar(10)
	declare @slbantruoc int
	declare @slbansau int
	declare @slco int
	select @masp = masp from deleted
	select @slbantruoc = soluongban from deleted
	select @slbansau = soluongban from inserted
	select @slco = soluong from sanpham where masp = @masp
	if(@slco+@slbantruoc-@slbansau < 0)
		begin
			print 'Khong du hang'
			rollback transaction
		end
	else
		begin
			update sanpham
			set soluong = soluong + @slbantruoc - @slbansau
			where masp = @masp
		end
end


update hoadon
set soluongban = 15
where SOhd = 'HD03'
select * from sanpham
select * from hoadon

--cho 2 bảng sv(masv,hoten,que,malop)
-- Lop(malop,tenlop,siso)


use qlsinhvien
go
create table lop(
	malop char(10) not null primary key,
	tenlop nvarchar(30),
	siso int
)
create table sv(
	masv char(10) not null primary key,
	hoten nvarchar(30),
	que nvarchar(30),
	malop char(10),
	constraint fk_sv_lop foreign key(malop) references lop(malop)
)
--1. viết trigger insert sinh viên, mỗi khi insert sinh viên hãy
--kiểm tra xem malop có tồn tại không? Sĩ số có vượt 70 không? Nếu
--thỏa mãn hãy tăng sĩ số lên 1.
create trigger trg_themsv
on sv
for insert
as
begin
	declare @masv char(10)
	select @masv = masv from inserted

	if(not exists(select masv from sv where masv = @masv))
		begin
			print 'Sinh vien da ton tai'
			rollback transaction
		end
	else
		begin
			declare @malop char(10)
			select @malop = malop from inserted
			if(not exists (select malop from lop where malop = @malop))
				begin
					print 'Khong ton tai ma lop'
					rollback transaction
				end
			else
				begin
					declare @siso int
					select @siso = siso from lop where malop = @malop
					if(@siso > 70)
						begin
							print 'Lop du sinh vien'
							rollback transaction
						end
					else
						begin
							update lop
							set siso = siso+1
							where malop = @malop
						end
				end
		end
end

drop trigger trg_themsv
select * from sv
select * from lop
insert into lop values('lop1', 'lop 1', 20),
						('lop2', 'lop 2', 80)
insert into lop values('lop3', 'lop 3', 50)
insert into sv values('sv01', 'nguyen thi s', 'ha noi', 'lop3')
--2. viết trigger update bảng sinh viên thay đổi malop cho sinh
--viên. Kiểm tra xem lớp mới có >70 không?
----> cập nhật lại sĩ số lớp cũ -1, sĩ số lớp mới +1.
create trigger trg_updatesv
on sv
for update
as
begin
	declare @malopcu char(10)
	declare @malopmoi char(10)
	select @malopcu = malop from deleted
	select @malopmoi = malop from inserted
	if(not exists(select malop from lop where malop = @malopmoi))
		begin
			print 'Khong ton tai ma lop'
			rollback transaction
		end
	else
		begin
			declare @siso int
			select @siso = siso from lop where malop = @malopmoi
			if(@siso > 70)
				begin
					print 'Lop da day'
					rollback transaction
				end
			else
				begin
					update lop
					set siso = siso - 1
					where malop = @malopcu
					update lop
					set siso = siso + 1
					where malop = @malopmoi
				end
		end
end

update sv
set malop = 'lop3'
where masv = 'sv02'
select * from sv
select * from lop
--3. viết trigger xóa 1 sinh viên, hãy thay đổi soluong sinh viên
--trong bảng lớp.
create trigger trg_deletesv
on sv
for delete
as
begin
	declare @malop char(10)
	select @malop = malop from deleted
	update lop
	set siso = siso - 1
	where malop = @malop
end
delete from sv
where masv = 'sv01'
select * from sv
select * from lop