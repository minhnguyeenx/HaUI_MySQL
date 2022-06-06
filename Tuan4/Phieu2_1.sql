use master
go

create database QLiBanHang
on primary(
	name = 'QLBanHang_dat',
	filename = 'D:\Data\QLiBanHang.mdf',
	size = 5MB, maxsize = 20MB, filegrowth = 20%
)
log on(
	name = 'QLiBanHang_log',
	filename = 'D:\Data\QLiBanHang.ldf',
	size = 1MB, maxsize = 5MB, filegrowth = 1MB
)
go
use QLiBanHang
go

create table HangSX(
	MaHangSX nchar(10) not null primary key,
	TenHang nvarchar(20) not null,
	DiaChi nvarchar(20),
	SoDT nvarchar(20),
	Email nvarchar(30)
)

create table SanPham(
	MaSP nchar(10) not null primary key,
	MaHangSX nchar(10) not null,
	TenSP nvarchar(20) not null,
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max),
	constraint fk_SP foreign key(MaHangSX)
		references HangSX(MaHangSX)
)

create table NhanVien(
	MaNV nchar(10) not null primary key,
	TenNV nvarchar(20) not null,
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)
create table PNhap(
	SoHDN nchar(10) not null primary key,
	NgayNhap date,
	MaNV nchar(10),
	constraint fk_PNhap foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Nhap(
	SoHDN nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongN int,
	DonGia money,
	constraint PK_Nhap primary key(SoHDN, MaSP),
	constraint fk_Nhap_PN foreign key(SoHDN)
		references PNhap(SoHDN),
	constraint fk_Nhap_SP foreign key(MaSP)
		references Sanpham(MaSp)
)
create table PXuat(
	SoHDX nchar(10) not null primary key,
	NgayXuat date,
	MaNV nchar(10),
	constraint fk_PXuat foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Xuat(
	SoHDX nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongX int,
	constraint PK_Xuat primary key(SoHDX, MaSP),
	constraint fk_Xuat_PN foreign key(SoHDX)
		references PXuat(SoHDX),
	constraint fk_Xuat_SP foreign key(MaSP)
		references Sanpham(MaSp)
)

insert into HangSX values('H01', 'SamSung', 'Korean','011-08271717', 'ss@gmail.com.kr'),
						('H02', 'OPPO', 'China','081-08626262', 'oppo@gmail.com.cn'),
						('H03', 'Vinfone', N'Việt Nam','084-098262626', 'vf@gmail.com.vn')


insert into SanPham values('SP01','H02', 'F1 Plus',100, N'xám', 7000000, N'chiếc', N'Hàng cận cao cấp'),
						  ('SP02','H01', 'Galaxy note11',50, N'xám', 19000000, N'chiếc', N'Hàng cao cấp'),
						  ('SP03','H02', 'F3 lite',200, N'xám', 3000000, N'chiếc', N'Hàng phổ thông'),
						  ('SP04','H03', 'Vjoy3',200, N'xám', 1500000, N'chiếc', N'Hàng phổ thông'),
						  ('SP05','H01', 'GalaxyV12',500, N'xám', 8000000, N'chiếc', N'Hàng cận cao cấp')		
		

insert into NhanVien values('NV01',N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmai.com', N'Kế toán'),
						  ('NV02',N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252','nam@gmail.com', N'Vật tư'),
						  ('Nv03',N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388', 'hbGmail.com', N'Kế toán')

insert into PNhap values('N01','02-05-2019', 'NV01'),
						  ('N02','04-07-2020', 'NV02'),
						  ('N03','05-17-2020', 'NV02'),
						  ('N04','03-22-2020', 'NV03'),
						 ('N05','07-07-2020', 'NV01')
insert into Nhap values('N01','SP02', 10, 17000000),
						  ('N02','SP01', 30,6000000),
						  ('N03','SP04', 20,1200000),
						  ('N04','SP01', 10,6200000),
						 ('N05','SP05', 20,7000000)

insert into PXuat values('X01','06-14-2020', 'NV02'),
						  ('X02','03-05-2019', 'NV03'),
						  ('X03','12-12-2020', 'NV01'),
						  ('X04','06-02-2020', 'NV02'),
						 ('X05','05-18-2020', 'NV01')
insert into Xuat values('X01','SP03', 5),
						  ('X02','SP01', 3),
						  ('X03','SP02', 1),
						  ('X04','SP03', 2),
						 ('X05','SP05', 1)


select*from HangSX
select*from SanPham
select*from NhanVien
select*from PNhap
select*from Nhap
select*from PXuat
select*from Xuat




