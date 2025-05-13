-----------R8--------------------
CREATE PROCEDURE KiemTraDangNhap
    @username VARCHAR(200),
    @password VARCHAR(200),
    @tbao bit OUTPUT --0: thành công, 1: thất bại
AS
BEGIN
    --  Kiểm tra tên đăng nhập và mật khẩu không được để trống
    IF @username IS NULL OR @username = ''
    BEGIN
		Print N'Đăng nhập thất bại'
        SET @tbao =1;
        RETURN;
    END

    IF @password IS NULL OR @password = ''
    BEGIN
		Print N'Đăng nhập thất bại!'
        SET @tbao = 1;
        RETURN;
    END
    -- Kiểm tra TenDN và MatKhau chỉ chứa chữ cái và số
    IF PATINDEX('%[^a-zA-Z0-9]%', @username) > 0
    BEGIN
		Print N'Đăng nhập thất bại!'
        SET @tbao = 1;
        RETURN;
    END

	IF PATINDEX('%[^a-zA-Z0-9]%', @password) > 0
    BEGIN
		Print N'Đăng nhập thất bại!'
        SET @tbao = 1;
        RETURN;
    END
    -- Kiểm tra xem thông tin đăng nhập có đúng không
    DECLARE @ktr INT;
    SELECT @ktr = COUNT(*) 
    FROM TaiKhoan 
	WHERE TenDN = @username AND MatKhau = CONVERT(VARBINARY(16), HASHBYTES('MD5', @password));

    IF @ktr < 1
    BEGIN
		Print N'Đăng nhập thất bại!'
        SET @tbao = 1;
        RETURN;
    END
    -- Nếu đăng nhập thành công
	Print N'Đăng nhập thành công!'
    SET @tbao = 0;
END

--Test truong hop dung
insert into TaiKhoan(TenDN,MatKhau,Quyen)
values('admin','admin',0)

declare @tbao bit --Truong hop dung
exec KiemTraDangNhap 'admin', 'admin', @tbao = @tbao output
print @tbao
--Test truong hop sai
declare @tbao bit
exec KiemTraDangNhap 'TK0001', 'Khangdz', @tbao = @tbao output
print @tbao
