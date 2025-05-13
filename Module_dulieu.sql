---Data bảng Hang
CREATE PROCEDURE ThemDataHang
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @Ma_H CHAR(6);
    DECLARE @Ten_H NVARCHAR(100);
    DECLARE @DonGia NUMERIC(15);

    WHILE @i <= 1000
    BEGIN
        SET @Ma_H = 'H' + RIGHT('00000' + CAST(@i AS VARCHAR(6)), 5);
        SET @Ten_H = 'Ten_H' + FORMAT(@i, '0000');
        SET @DonGia = ROUND(1000 + (RAND() * 99000), 2);
        INSERT INTO Hang (Ma_H, Ten_H, DonGia)
        VALUES (@Ma_H, @Ten_H, @DonGia);
        SET @i = @i + 1;
    END
END

exec ThemDataHang

-----Data Bảng NCC
CREATE PROCEDURE ThemDataNhaCungCap
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @Ma_NCC CHAR(6);
    DECLARE @Ten_NCC NVARCHAR(100);
    DECLARE @DiaChi_NCC NVARCHAR(150);
    DECLARE @SDT_NCC CHAR(10);

    WHILE @i <= 1000
    BEGIN
        SET @Ma_NCC = 'CC' + RIGHT('0000' + CAST(@i AS VARCHAR(4)), 4);
        SET @Ten_NCC = 'Nha Cung Cap ' + CAST(@i AS NVARCHAR(4));
        SET @DiaChi_NCC = 'Dia chi NCC ' + CAST(@i AS NVARCHAR(4));
        SET @SDT_NCC = '09' + RIGHT('000000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000000 AS VARCHAR(9)), 9);
        INSERT INTO NhaCungCap (Ma_NCC, Ten_NCC, DiaChi_NCC, SDT_NCC)
        VALUES (@Ma_NCC, @Ten_NCC, @DiaChi_NCC, @SDT_NCC);
        SET @i = @i + 1;
    END
END

exec ThemDataNhaCungCap

---Data Bảng Nợ
CREATE PROCEDURE ThemDataNo
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @Ma_HD_No CHAR(6);
    DECLARE @Tien_No NUMERIC(15);
    DECLARE @NgayHetHan DATE;
    DECLARE @Ma_NCC CHAR(6);

    WHILE @i <= 1000
    BEGIN
        SET @Ma_HD_No = 'NO' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4);
        SET @Tien_No = ROUND(10000 + (RAND() * 990000), 2);
        SET @NgayHetHan = DATEADD(DAY, CONVERT(INT, (RAND() * 30)), GETDATE());
        SET @Ma_NCC = 'CC' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4);
        INSERT INTO No (Ma_HD_No, Tien_No, NgayHetHan, Ma_NCC)
        VALUES (@Ma_HD_No, @Tien_No, @NgayHetHan, @Ma_NCC);
        SET @i = @i + 1;
    END
END

exec ThemDataNo

------Data Bảng Nhân viên
create proc ThemDataNhanVien
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 1000
    BEGIN
        INSERT INTO NhanVien(Ma_NhanVien, Ten_NhanVien, SDT_NV)
        VALUES ('NV' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4),  
			'Nhan Vien' + CAST(@i AS VARCHAR(6)),
			'08' + RIGHT('000000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000000 AS VARCHAR(9)), 9))
        SET @i = @i + 1;
    END
END

EXEC ThemDataNhanVien

---------Data Bảng Nhập-----
CREATE PROCEDURE ThemDataNhap
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 1000
    BEGIN
        INSERT INTO Nhap (Ma_HD_Nhap, NgayNhap, Ma_HD_No, Ma_NCC, Ma_NhanVien)
        VALUES (
            'NH' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4), 
            DATEADD(DAY, ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, '2020-01-01', GETDATE()), '2020-01-01'),
            'NO' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4), 
            'CC' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4), 
            'NV' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4)
        );
        SET @i = @i + 1;
    END;
END;

EXEC ThemDataNhap

--------Data Nhập_CT---------
CREATE PROCEDURE ThemDataNhap_CT
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @Ma_HD_Nhap CHAR(6);
    DECLARE @Ma_H CHAR(6);
    DECLARE @SoLuong INT;

    WHILE @i <= 1000
    BEGIN
        SET @Ma_HD_Nhap = 'NH' + RIGHT('0000' + CAST((@i % 100 + 1) AS VARCHAR(4)), 4);
        SET @Ma_H ='H' + RIGHT('00000' + CAST(@i AS VARCHAR(6)), 5);
        SET @SoLuong = FLOOR(RAND() * 100) + 1;
        INSERT INTO Nhap_CT (Ma_HD_Nhap, Ma_H, SoLuong)
        VALUES (@Ma_HD_Nhap, @Ma_H, @SoLuong);
        SET @i = @i + 1;
    END
END;

EXEC ThemDataNhap_CT

-------------Data Bản món nước--------
CREATE PROCEDURE ThemDataMonNuoc
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @MN CHAR(6);
    DECLARE @TenMon NVARCHAR(100);
    DECLARE @DonGia NUMERIC(15, 2);
    
    WHILE @i <= 1000
    BEGIN
        SET @MN = 'MN' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4);	
        SET @TenMon = 'Mon Nuoc ' + + CAST(@i AS NVARCHAR(4));
        SET @DonGia = ROUND(1000 + (RAND() * 99000), 2);
        INSERT INTO MonNuoc (Ma_Mon, Ten_Mon, DonGia)
        VALUES (@MN, @TenMon, @DonGia);
        SET @i = @i + 1;
    END;
END;

EXEC ThemDataMonNuoc

------Data Bảng Bán Hàng
CREATE PROC ThemDataBanhang
AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= 1000
    BEGIN
        INSERT INTO BanHang (Ma_HD_BanHang, NgayThanhToan, PhuongThucThanhToan, So_Ban, Ma_NhanVien)
        VALUES (
            'BH' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4),  
			DATEADD(DAY, ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, '2020-01-01', GETDATE()), '2020-01-01'),  
			CAST(ABS(CHECKSUM(NEWID()) % 2) AS BIT), 
			ABS(CHECKSUM(NEWID()) % 1000) + 1,  
			'NV' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4) 
				);
        SET @i = @i + 1;
    END;
END;

EXEC ThemDataBanhang

-------Data Bảng BanHang_CT
CREATE PROC ThemDataBanHang_CT
AS
BEGIN
    DECLARE @i INT = 1
    WHILE @i <= 1000
    BEGIN
        INSERT INTO BanHang_CT (Ma_HD_BanHang, Ma_Mon, SoLuong)
        VALUES (
            'BH' + RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4),  
			'MN' + RIGHT('0000' + CAST((@i % 100 + 1) AS VARCHAR(6)), 4),
			FLOOR(RAND() * 100) + 1)
        SET @i = @i + 1
    END
END

EXEC ThemDataBanHang_CT
---------Data Bảng TaiKhoan
CREATE PROC ThemDataTaiKhoan
AS
BEGIN
	DECLARE @i int=1
	WHILE @i<=1000
	BEGIN
		INSERT INTO TaiKhoan(TenDN, MatKhau, Quyen)
		VALUES
			(
			'TK'+ RIGHT('0000' + CAST(@i AS VARCHAR(6)), 4),
			CAST(FLOOR(RAND() * 9000) + 1000 AS VARCHAR),
			CAST(FLOOR(RAND() * 2) AS BIT)
			)
		SET @i=@i+1
	END
END

EXEC ThemDataTaiKhoan
-----------
select * from Hang
select * from NhaCungCap
select * from No
SELECT * FROM NhanVien
SELECT * FROM Nhap
SELECT * FROM Nhap_CT
Select * from MonNuoc
SELECT * FROM BanHang
SELECT * FROM BanHang_CT
Select * from TaiKhoan