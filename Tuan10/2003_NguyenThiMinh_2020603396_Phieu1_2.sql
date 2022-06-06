use qlhoadon
go

create table hang(
	mahang char(10) not null primary key,
	tenhang nvarchar(30),
	soluong int,
	giaban money
)
create table hoadon(
	mahd char(10) not null primary key,
	mahang char(10),
	soluongban int,
	ngayban date,
	constraint fk_hd_hang foreign key(mahang) references hang(mahang)
)

--PHIEU1
--Hãy tạo 1 trigger insert HoaDon, hãy kiểm tra xem mahang cần mua có tồn
--tại trong bảng HANG không, nếu không hãy đưa ra thông báo.
-- - Nếu thỏa mãn hãy kiểm tra xem: soluongban <= soluong? Nếu không hãy đưa
--ra thông báo.
-- - Ngược lại cập nhật lại bảng HANG với: soluong = soluong - soluongbanalter trigger trg_inserthdon hoadonfor insertasbegin	if(exists(select mahd))		begin			print 'Hoa don da ton tai'			rollback transaction		end	else		begin			declare @mahang char(10)			select @mahang = mahang from inserted			if(not exists (select mahang from hang where mahang = @mahang))				begin					print 'Ma hang khong ton tai'					rollback transaction				end			else				begin					declare @slban int					declare @slco int					select @slban = soluongban from inserted					select @slco = soluong from hang where mahang = @mahang					if(@slco<@slban) 						begin							print 'Khong du hang'							rollback transaction						end					else						begin							update hang							set soluong = soluong - @slban							where mahang = @mahang						end				end		end	endinsert into hoadon values ('hd1', 'h01',13, '2020-9-9')select * from hangselect * from hoadon--PHIEU2--Câu 1 (5đ). Viết trigger kiểm soát việc Delete bảng HOADON, Hãy cập nhật lại
--soluong trong bảng HANG với: SOLUONG =SOLUONG +
--DELETED.SOLUONGBAN
alter trigger trg_deletehd
on hoadon
for delete
as
begin
	declare @soluongban int
	declare @mahang char(10)
	select @soluongban = soluongban from deleted
	select @mahang = mahang from deleted
	update hang
	set soluong = soluong + @soluongban
	where mahang = @mahang
end

delete from hoadon
where mahd = 'hd1'
select * from hangselect * from hoadon
--Câu 2 (5đ). Hãy viết trigger kiểm soát việc Update bảng HOADON. Khi đó hãy
--update lại soluong trong bảng HANG.
create trigger trg_update
on hoadon
for update
as
begin
	declare @mahang char(10)
	select @mahang = mahang from deleted
	declare @slbancu int
	declare @slbanmoi int
	declare @slco int
	select @slbancu = soluongban from deleted
	select @slbanmoi = soluongban from inserted
	select @slco = soluong from hang where mahang = @mahang
	if(@slco-@slbanmoi+@slbancu < 0)
		begin
			print 'Khong du hang'
			rollback transaction
		end
	else
		begin
			update hang
			set soluong = soluong-@slbanmoi+@slbancu
			where mahang = @mahang
		end
end
update hoadon
set soluongban = 10
where mahd = 'hd3'
select * from hangselect * from hoadon