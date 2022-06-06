use quanlykhoa
go

create table khoa(
	makhoa char(10) not null primary key,
	tenkhoa nvarchar(30),
	dienthoai nvarchar(12)
)

create table lop(
	malop char(10) not null primary key,
	tenlop nvarchar(30),
	khoa int,
	hedt nvarchar(30),
	namnhaphoc int,
	makhoa char(10) not null,
	constraint fk_lop_khoa foreign key(makhoa) references khoa(makhoa)
)

--PHIEU 1
--cau 1
-- Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa,
--nếu đã tồn tại đưa ra thông báo, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2
--trường hợp.--cach1alter proc pr_nhapdlkhoa(@makhoa char(10),@tenkhoa nvarchar(30),@dienthoai nvarchar(12))asbegin	if(exists(select tenkhoa from khoa where tenkhoa = @tenkhoa))		print 'Khoa '+ @tenkhoa + ' da ton tai'	else		begin			insert into khoa values (@makhoa, @tenkhoa, @dienthoai)			print 'Nhap thanh cong'		endend--cach2alter proc pr_nhapdlkhoa(@makhoa char(10),@tenkhoa nvarchar(30),@dienthoai nvarchar(12))asbegin	declare @dem int	select dem = count(*) from khoa where tenkhoa = @tenkhoa	if(@dem = 0)		print 'Khoa '+ @tenkhoa + ' da ton tai'	else		begin			insert into khoa values (@makhoa, @tenkhoa, @dienthoai)			print 'Nhap thanh cong'		endendselect * from khoaexec pr_nhapdlkhoa 'k05', 'khoa 5', '8438923489'--Cau 2: Hãy viết thủ tục nhập dữ liệu cho bảng Lop với các tham biến Malop,
--Tenlop, Khoa,Hedt,Namnhaphoc,Makhoa nhập từ bàn phím.
-- - Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì thông báo
-- - Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì thông báo
-- - Nếu đầy đủ thông tin thì cho nhậpalter proc pr_nhapdllop(@malop char(10) ,@tenlop nvarchar(30),@khoa int,@hedt nvarchar(30),@namnhaphoc int,@makhoa char(10))asbegin	if(exists(select tenlop from lop where tenlop = @tenlop))		print 'Lop ' + @tenlop + ' da ton tai'	else 		if(not exists(select makhoa from khoa where makhoa = @makhoa))			print 'Ma khoa ' + @makhoa + ' khong ton tai'		else 			begin				insert into lop values(@malop, @tenlop, @khoa, @hedt, @namnhaphoc, @makhoa)				print 'Nhap thanh cong'			endendselect * from lopexec pr_nhapdllop 'lop6', 'lop 6', 1, 'cu nhan', 2021, 'k06'--PHIEU 2--Câu 1 (5đ). Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa,
--nếu đã tồn tại trả về giá trị 0, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2
--trường hợp.
create proc  pr_nhapkhoa(@makhoa char(10),@tenkhoa nvarchar(30),@dienthoai nvarchar(12), @kq int output)
as
begin
	if(exists(select tenkhoa from khoa where tenkhoa = @tenkhoa))
		begin
			set @kq = 0
		end
	else
		begin
			insert into khoa values (@makhoa, @tenkhoa, @dienthoai)			set @kq = 1
		end
	return @kq
end

select * from khoadeclare @kq intexec pr_nhapkhoa 'k06', 'khoa 10', '8438923489', @kq output
select @kq
--Câu 2 (5đ). Hãy viết thủ tục nhập dữ liệu cho bảng lop với các tham biến
--malop,tenlop,khoa,hedt,namnhaphoc,makhoa.
-- - Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì trả về 0.
-- - Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì trả về 1.
-- - Nếu đầy đủ thông tin thì cho nhập và trả về 2.
create proc pr_nhaplop(@malop char(10) ,@tenlop nvarchar(30),@khoa int,@hedt nvarchar(30),@namnhaphoc int,@makhoa char(10), @kq int output)asbegin	if(exists(select tenlop from lop where tenlop = @tenlop))		set @kq = 0	else 		if(not exists(select makhoa from khoa where makhoa = @makhoa))			set @kq = 1		else 			begin				insert into lop values(@malop, @tenlop, @khoa, @hedt, @namnhaphoc, @makhoa)				set @kq = 2			end	return @kqendselect * from lopdeclare @kq intexec pr_nhaplop 'lop6', 'lop 6', 1, 'cu nhan', 2021, 'k0', @kq outputselect @kq