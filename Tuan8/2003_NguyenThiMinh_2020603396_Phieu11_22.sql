use qlnv
go 

create table tblchucvu(
	macv nvarchar(2) not null primary key,
	tencv nvarchar(30)
)
create table tblnhanvien(
	manv nvarchar(4) not null primary key,
	macv nvarchar(2),
	tennv nvarchar(30),
	ngaysinh datetime,
	luongcanban float,
	ngaycong int,
	phucap float,
	constraint fk_nv_cv foreign key(macv) references tblchucvu(macv)
)

--PHIEU11
--1. Viết thủ tục SP_Them_Nhan_Vien, biết tham biến là MaNV, MaCV,
--TenNV,Ngaysinh,LuongCanBan,NgayCong,PhuCap. Kiểm tra MaCV có tồn tại
--trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho thêm nhân viên
--mới, nếu không thì đưa ra thông báo.
create proc sp_them_nhan_vien(@manv nvarchar(4),
								@macv nvarchar(2),
								@tennv nvarchar(30),
								@ngaysinh datetime,
								@luongcanban float,
								@ngaycong int,
								@phucap float)
as
begin
	if(not exists (select macv from tblchucvu where macv = @macv))
		print 'Ma chuc vu ' + @macv + ' khong ton tai'
	else 
		if(exists (select manv from tblnhanvien where manv = @manv))
			print 'Nhan vien co ma ' + @manv + ' da ton tai'
		else 
			begin
				insert into tblnhanvien values (@MaNV, @MaCV,@TenNV,@Ngaysinh,@LuongCanBan,@NgayCong,@PhuCap)
				print 'Nhap thanh cong'
			end
end
exec sp_them_nhan_vien 'nv04', 'vs', 'uidio jioweo', '2020-9-9', 300000, 26, 300000
select * from tblnhanvien
--2. Viết thủ tục SP_CapNhat_Nhan_Vien ( không cập nhật mã), biết tham biến là
--MaNV, MaCV, TenNV, Ngaysinh, LuongCanBan, NgayCong, PhuCap. Kiểm tra
--MaCV có tồn tại trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho
--cập nhật, nếu không thì đưa ra thông báo.
create proc sp_capnhat_nhan_vien(@manv nvarchar(4),
								@macv nvarchar(2),
								@tennv nvarchar(30),
								@ngaysinh datetime,
								@luongcanban float,
								@ngaycong int,
								@phucap float)
as
begin
	if(not exists (select macv from tblchucvu where macv = @macv))
		print 'Ma chuc vu ' + @macv + ' khong ton tai'
	else 
		if(not exists (select manv from tblnhanvien where manv = @manv))
			print 'Nhan vien co ma ' + @manv + ' khong ton tai'
		else 
			begin
				update tblnhanvien
				set macv=@MaCV,tennv=@TenNV,ngaysinh=@Ngaysinh,luongcanban=@LuongCanBan,ngaycong=@NgayCong,phucap=@PhuCap
				where manv = @manv
				print 'Cap nhap thanh cong'
			end
end
exec sp_capnhat_nhan_vien 'nv04', 'vs', 'nguyen thi minh', '2020-10-9', 900000, 26, 900000
select * from tblnhanvien
--3. Viết thủ tục SP_LuongLN với Luong=LuongCanBan*NgayCong PhuCap, biết
--thủ tục trả về, không truyền tham biến.
create type bangtam1 as table(
	manv nvarchar(4) not null primary key, 
	tennv nvarchar(30), 
	luong float
)
create proc sp_luongln(@bang table(manv nvarchar(4), tennv nvarchar(30), luong float) output)
as
begin
	insert into @bang
	select manv, tennv, LuongCanBan*NgayCong+PhuCap as luong
	from tblnhanvien
	return @bang
end
--PHIEU 2
--1. Tạo thủ tục có tham số đưa vào là MaNV, MaCV, TenNV, NgaySinh, LuongCB,
--NgayCong, PhucCap. Trước khi chèn một bản ghi mới vào bảng NHANVIEN với danh
--sách giá trị là giá trị của các biến phải kiểm tra xem MaCV đã tồn tại bên bảng ChucVu
--chưa, nếu chưa trả ra 0.
alter proc cau1(	@manv nvarchar(4),
					@macv nvarchar(2),
					@tennv nvarchar(30),
					@ngaysinh datetime,
					@luongcanban float,
					@ngaycong int,
					@phucap float,
					@kq int output)
as
begin
	if(not exists(select macv from tblchucvu where macv = @macv))
		set @kq = 0
	else
		if(exists(select manv from tblnhanvien where manv = @manv) or @ngaycong > 30)
			set @kq = 0
		else 
			begin
				insert into tblnhanvien values(@manv,@macv,@tennv,@ngaysinh,@luongcanban,@ngaycong,@phucap)
				set @kq = 1
			end
	return @kq
end

declare @kq int
exec cau1 'nv06', 'kt', 'hdwj iowdq', '1997-12-12', 200000, 24, 200000, @kq output
select @kq
select * from tblnhanvien
--2. Sửa thủ tục ở câu một kiểm tra xem thêm MaNV được chèn vào có trùng với MaNV
--nào đó có trong bảng không. Nếu MaNV đã tồn tại trả ra 0, nếu MaCV chưa tồn tại trả ra
--1. Ngược lại cho phép chèn bản ghi.
alter proc cau1(	@manv nvarchar(4),
					@macv nvarchar(2),
					@tennv nvarchar(30),
					@ngaysinh datetime,
					@luongcanban float,
					@ngaycong int,
					@phucap float,
					@kq int output)
as
begin
	if(not exists(select macv from tblchucvu where macv = @macv))
		set @kq = 1
	else
		if(exists(select manv from tblnhanvien where manv = @manv))
			set @kq = 0
		else 
			begin
				insert into tblnhanvien values(@manv,@macv,@tennv,@ngaysinh,@luongcanban,@ngaycong,@phucap)
				set @kq = 1
			end
	return @kq
end

--3. Tạo SP cập nhật trường NgaySinh cho các nhân viên (thủ tục có hai tham số đầu vào
--gồm mã nhân viên, Ngaysinh). Nếu không tìm thấy bản ghi cần cập nhật trả ra giá trị 0.
--Ngược lại, cho phép cập nhật.
alter proc cau3(	@manv nvarchar(4),
					@ngaysinh datetime,
					@kq int output)
as
begin
	if(not exists(select manv from tblnhanvien where manv = @manv))
		set @kq = 0
	else
		begin
			update tblnhanvien
			set ngaysinh = @ngaysinh
			where manv = @manv
			set @kq = 1
		end
	return @kq
end

declare @kq int
exec cau3 'nv06','2097-12-12 00:00:00.000', @kq output
select @kq
select * from tblnhanvien


