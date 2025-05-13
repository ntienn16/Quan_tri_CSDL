---------------------------------
-------Mã hóa--------------------
update TaiKhoan
set MatKhau=convert(varchar(50),HASHBYTES('md5',MatKhau))

--Trigger tự động mã hóa--
Create Trigger trig_HashMK
on TaiKhoan
after insert, update
as
begin
	update TaiKhoan
	set MatKhau=convert(varchar(50),HASHBYTES('md5',inserted.MatKhau))
	from TaiKhoan
	join inserted on TaiKhoan.TenDN=inserted.TenDN
end
--Test:
insert into Taikhoan
values('admin','admin',0)
select * from TaiKhoan Where TenDN='admin'
select * from TaiKhoan