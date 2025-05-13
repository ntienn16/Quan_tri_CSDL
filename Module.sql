-----------Cập nhật lại các bảng----------------
USE master;  
GO  
IF DB_ID (N'NHOM05') IS NOT NULL  
DROP DATABASE NHOM05;  
GO  
CREATE DATABASE NHOM05  
go
use NHOM05
go
--Bảng Hàng
Create table Hang(
		Ma_H char(6) not null primary key,
		Ten_H nvarchar(100) not null unique,
		DonGia numeric(15) not null)
--Bảng Nhà cung cấp
Create table NhaCungCap(
		Ma_NCC char(6) not null primary key,
		Ten_NCC nvarchar(100) not null,
		DiaChi_NCC nvarchar(150),
		SDT_NCC char(10) unique)
--Bảng Nợ
Create table No(
				Ma_HD_No char(6) primary key,
				Tien_No numeric(15),
				NgayHetHan date,
				Ma_NCC char(6)
				foreign key (Ma_NCC) references NhaCungCap(Ma_NCC))
--Bảng NhanVien
CREATE TABLE NhanVien(
		Ma_NhanVien Char(6) not null PRIMARY KEY,
		Ten_NhanVien NVARCHAR(50) not null,
		SDT_NV char(10) unique)
-- Bảng Nhập:
Create table Nhap(	
		Ma_HD_Nhap char(6) not null primary key,
		NgayNhap date,
		--ThanhTien numeric(15),
		--TongCong numeric(15),
		Ma_HD_No char(6) not null,
		Ma_NCC char(6) not null,
		Ma_NhanVien char(6),
		foreign key(Ma_HD_No) references No,
		foreign key (Ma_NCC) references NhaCungCap(Ma_NCC),
		foreign key (Ma_NhanVien) references NhanVien(Ma_NhanVien))
--Bảng Nhap_CT
Create table Nhap_CT(	
		Ma_HD_Nhap char(6) not null,
		Ma_H char(6) not null,
		PRIMARY KEY (Ma_HD_Nhap, Ma_H),
		foreign key(Ma_HD_Nhap) references Nhap,
		foreign key(Ma_H) references Hang,
		SoLuong int)
--Bảng Món nước
CREATE TABLE MonNuoc(
		Ma_Mon CHAR(6) not null PRIMARY KEY,
		Ten_Mon NVARCHAR(100)not null unique,
		DonGia NUMERIC(15)not null)
--Bản Bán Hàng
CREATE TABLE BanHang (
		Ma_HD_BanHang CHAR(6) not null PRIMARY KEY,
		NgayThanhToan DATE not null,
		--ThanhTien NUMERIC(15)not null,
		--TongThanhToan NUMERIC (15) not null,
		PhuongThucThanhToan bit not null,
		-- 0: tiền mặt, 1: chuyển khoản
		So_Ban INT,
		Ma_NhanVien char(6) not null,
		FOREIGN KEY (Ma_NhanVien) REFERENCES NhanVien(Ma_NhanVien))
--Bảng Bán Hàng Chi Tiết
CREATE TABLE BanHang_CT (
		Ma_HD_BanHang CHAR(6) not null,
		Ma_Mon CHAR(6) not null,
		SoLuong INT not null,
		PRIMARY KEY (Ma_HD_BanHang, Ma_Mon),
		FOREIGN KEY (Ma_HD_BanHang) REFERENCES BanHang(Ma_HD_BanHang),
		FOREIGN KEY (Ma_Mon) REFERENCES MonNuoc(Ma_Mon))
--Bảng Tài Khoản
CREATE TABLE TaiKhoan(
	TenDN varchar(20) primary key,
	MatKhau varchar(20),
	Quyen bit)
	--QL:0, NV:1
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
------------------Dump dữ liệu cho các bảng-------------------
--------------------------------------------------------------
--1.Data bảng Hang
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

--2.Data Bảng NCC
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

--3.Data Bảng Nợ
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

--4.Data Bảng Nhân viên
CREATE PROCEDURE ThemDataNhanVien
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @Ma_NhanVien CHAR(6);
    DECLARE @Ten_NhanVien NVARCHAR(100);
	DECLARE @SDT_NV CHAR(10)

    WHILE @i <= 1000
    BEGIN
        SET @Ma_NhanVien = 'NV' + RIGHT('0000' + CAST(@i AS VARCHAR(4)), 4);
        SET @Ten_NhanVien = 'Nha Vien' + CAST(@i AS NVARCHAR(4));
        SET @SDT_NV = '08' + RIGHT('000000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000000 AS VARCHAR(9)), 9);
        INSERT INTO NhanVien (Ma_NhanVien, Ten_NhanVien, SDT_NV)
        VALUES (@Ma_NhanVien, @Ten_NhanVien, @SDT_NV);
        SET @i = @i + 1;
    END
END

EXEC ThemDataNhanVien
--5.Data Bảng Nhập
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

--6.Data Nhập_CT
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

--7.Data Bản món nước
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

--8.Data Bảng Bán Hàng
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

--8.Data Bảng BanHang_CT
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

--9. Data Bảng TaiKhoan
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

------------------------
select * from Hang
select * from NhaCungCap
select * from No
SELECT * FROM NhanVien
SELECT * FROM Nhap
SELECT * FROM Nhap_CT
Select * from MonNuoc
SELECT * FROM BanHang
SELECT * FROM BanHang_CT
SELECT * FROM TaiKhoan

-----------------------------------------------------------------
-------------------Module xử lý----------------------------------
-----------------------------------------------------------------

--Module 1
CREATE PROCEDURE Mod1_LuuThongTinNhapHang (
    @Ma_HD_Nhap CHAR(6),        
    @NgayNhap DATE,
    @Ma_NCC CHAR(6),
    @Ma_NhanVien CHAR(6),
    @Ma_HD_No CHAR(6) = NULL
	)
AS
BEGIN
    --IF EXISTS (SELECT 1 FROM Nhap WHERE Ma_HD_Nhap = @Ma_HD_Nhap)
	If @Ma_HD_Nhap in (select Ma_HD_Nhap from Nhap)
    BEGIN
        Print(N'Mã hóa đơn nhập đã tồn tại. Không thể thêm.')
        RETURN
    END

    INSERT INTO Nhap (Ma_HD_Nhap, NgayNhap, Ma_HD_No, Ma_NCC, Ma_NhanVien)
    VALUES (@Ma_HD_Nhap, @NgayNhap, @Ma_HD_No, @Ma_NCC, @Ma_NhanVien)
    
    PRINT N'Thông tin nhập hàng đã được lưu thành công.';
END
----Test:
EXEC Mod1_LuuThongTinNhapHang 
    @Ma_HD_Nhap = 'NH1002',        -- Mã hóa đơn nhập mới
    @NgayNhap = '2024-10-20',      -- Ngày nhập
    @Ma_NCC = 'CC0002',            -- Mã nhà cung cấp
    @Ma_NhanVien = 'NV0002',       -- Mã nhân viên thực hiện
    @Ma_HD_No = 'NO0002';          -- Mã hóa đơn nợ (nếu có, có thể NULL)

--Module 2
CREATE FUNCTION Mod2_TinhTongTienHDNhap(@Ma_HD_Nhap CHAR(6))
RETURNS NUMERIC(15, 2)
AS
BEGIN
    DECLARE @TongTien NUMERIC(15, 2)

    SELECT @TongTien = SUM(NCT.SoLuong * Hang.DonGia)
    FROM Nhap_CT NCT
    JOIN Hang ON NCT.Ma_H = Hang.Ma_H
    WHERE NCT.Ma_HD_Nhap = @Ma_HD_Nhap
    RETURN @TongTien
END
----Test:
SELECT dbo.Mod2_TinhTongTienHDNhap('NH0001') AS TongTien;

--Module 3:
CREATE PROCEDURE Mod3_TinhTongChiPhiNhap
    @startDate DATE,
    @endDate DATE
AS
BEGIN

    SELECT SUM(Nhap_CT.SoLuong * Hang.DonGia) AS TongChiPhi
    FROM Nhap
    INNER JOIN Nhap_CT ON Nhap.Ma_HD_Nhap = Nhap_CT.Ma_HD_Nhap
	INNER JOIN Hang ON Nhap_CT.Ma_H = Hang.Ma_H
    WHERE Nhap.NgayNhap BETWEEN @startDate AND @endDate
END
----Test:
EXEC Mod3_TinhTongChiPhiNhap '2024-01-01', '2024-12-31'

--Module 4:
CREATE TRIGGER mod4_trigger_ThongBaoTongTienNhap
ON Nhap_CT
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    DECLARE @Ma_HD_Nhap char(6)
    DECLARE @TongTienCu numeric(15)
    DECLARE @TongTienMoi numeric(15)
    
    IF (SELECT COUNT(*) FROM inserted) > 0
        SELECT @Ma_HD_Nhap = (SELECT TOP 1 Ma_HD_Nhap FROM inserted)
    ELSE IF (SELECT COUNT(*) FROM deleted) > 0
        SELECT @Ma_HD_Nhap = (SELECT TOP 1 Ma_HD_Nhap FROM deleted)


    SELECT @TongTienCu = ISNULL(
        (--Tiền của các dòng không bị xóa/sửa, isnull để khi null trả về bằng 0
            SELECT SUM(Nhap_CT.SoLuong * Hang.DonGia)
            FROM Nhap_CT
            JOIN Hang ON Nhap_CT.Ma_H = Hang.Ma_H
            WHERE Nhap_CT.Ma_HD_Nhap = @Ma_HD_Nhap
        ), 0) +
        ISNULL(
        (  -- Cộng vào tiền của các dòng bị xóa/sửa (từ deleted)
            SELECT SUM(deleted.SoLuong * Hang.DonGia)
            FROM deleted
            JOIN Hang ON deleted.Ma_H = Hang.Ma_H
            WHERE deleted.Ma_HD_Nhap = @Ma_HD_Nhap
        ), 0) -
        ISNULL(
        (
            -- Trừ đi tiền của các dòng mới thêm/sửa (từ inserted)
            SELECT SUM(inserted.SoLuong * Hang.DonGia)
            FROM inserted
            JOIN Hang ON inserted.Ma_H = Hang.Ma_H
            WHERE inserted.Ma_HD_Nhap = @Ma_HD_Nhap
        ), 0)

    SELECT @TongTienMoi = ISNULL(SUM(Nhap_CT.SoLuong * Hang.DonGia), 0)
    FROM Nhap_CT
    JOIN Hang ON Nhap_CT.Ma_H = Hang.Ma_H
    WHERE Nhap_CT.Ma_HD_Nhap = @Ma_HD_Nhap

    PRINT N'Mã hóa đơn: ' + @Ma_HD_Nhap
    PRINT N'Tổng tiền cũ: ' + CAST(@TongTienCu AS nvarchar(20))
    PRINT N'Tổng tiền mới: ' + CAST(@TongTienMoi AS nvarchar(20))
    PRINT N'Thay đổi: ' + CAST((@TongTienMoi - @TongTienCu) AS nvarchar(20))
END
----Test:
INSERT INTO Nhap_CT(Ma_HD_Nhap, Ma_H, SoLuong)
VALUES ('NH0110', 'H00101', 5)
select * from Nhap_CT

DELETE FROM Nhap_CT
WHERE Ma_HD_Nhap = 'NH0110'

--Module 5:
CREATE PROCEDURE Mod5_procKiemTraThemNhap_CT
    @Ma_HD_Nhap CHAR(6),
    @Ma_H CHAR(6),
    @SoLuong INT,
	@Output nvarchar(50) OUTPUT
AS
BEGIN
    IF @Ma_HD_Nhap IN (SELECT Ma_HD_Nhap FROM Nhap_CT WHERE Ma_H = @Ma_H)

    BEGIN
		SET @Output = (N'Đã tồn tại bản ghi')
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO Nhap_CT (Ma_HD_Nhap, Ma_H, SoLuong)
        VALUES (@Ma_HD_Nhap, @Ma_H, @SoLuong)
        SET @Output = N'Dữ liệu đã được thêm thành công.'
    END
END

declare @Output nvarchar(50)
Exec Mod5_procKiemTraThemNhap_CT 'NH0110','H00120', 7, @Output out
print @output

select * from Nhap
select * from Nhap_CT

--Module 6:
CREATE TRIGGER Mod6_triggerXoaNhap
ON Nhap
FOR DELETE
AS
BEGIN
    DELETE FROM Nhap_CT
    WHERE Ma_HD_Nhap IN (SELECT Ma_HD_Nhap FROM DELETED)
END

--Test:
INSERT INTO Nhap_CT(Ma_HD_Nhap, Ma_H, SoLuong)
VALUES ('NH0110', 'H00101', 6)
select * from Nhap_CT

DELETE FROM Nhap_CT
WHERE Ma_HD_Nhap = 'NH0110'

DELETE FROM Nhap_CT
WHERE Ma_HD_Nhap = 'NH0003'
  AND Ma_H = 'H00101'

--Mod 7:
CREATE PROCEDURE Mod7_LuuThongTinBanHang
    @Ma_HD_BanHang CHAR(6),        
    @NgayThanhToan DATE,
	@PhuongThucThanhToan bit,
	@So_Ban int,
    @Ma_NhanVien CHAR(6)
AS
BEGIN
    If @Ma_HD_BanHang in (select @Ma_HD_BanHang from BanHang)
    BEGIN
        Print N'Mã hóa đơn bán hàng đã tồn tại. Không thể thêm.'
        RETURN
    END

    INSERT INTO BanHang(Ma_HD_BanHang, NgayThanhToan, PhuongThucThanhToan, So_Ban, Ma_NhanVien)
    VALUES (@Ma_HD_BanHang, @NgayThanhToan, @PhuongThucThanhToan, @So_Ban, @Ma_NhanVien)    
    PRINT N'Thông tin bán hàng đã được lưu thành công.';
END
-----Test
Exec Mod7_LuuThongTinBanHang 'BH1114', '2024-01-01', 0, 4,'NV0990'
select * from BanHang

--Mod 8
CREATE FUNCTION Mod8_TinhTongTienHoaDonBan (@Ma_HD_BanHang CHAR(6))
RETURNS NUMERIC(15, 2)
AS
BEGIN
    DECLARE @TongTien NUMERIC(15, 2)

    SELECT @TongTien = SUM(BanHang_CT.SoLuong * MonNuoc.DonGia)
    FROM BanHang_CT
    JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon
    WHERE BanHang_CT.Ma_HD_BanHang = @Ma_HD_BanHang

    RETURN @TongTien
END
-----Test:
SELECT dbo.Mod8_TinhTongTienHoaDonBan('BH0001') AS TongTien

--Mod 9:
CREATE PROCEDURE Mod9_TinhTongDoanhThu
    @startDate DATE,
    @endDate DATE
AS
BEGIN

    SELECT SUM(BanHang_CT.SoLuong * MonNuoc.DonGia) AS TongDoanhThu
    FROM BanHang 
    JOIN BanHang_CT ON BanHang.Ma_HD_BanHang = BanHang_CT.Ma_HD_BanHang
    JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon
    WHERE BanHang.NgayThanhToan BETWEEN @startDate AND @endDate
END
----Test 
EXEC Mod9_TinhTongDoanhThu '2022-01-01', '2022-12-31'

--Mod 10:
CREATE TRIGGER Mod10_triggerThanhTienBanHang
ON BanHang_CT
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Ma_HD_BanHang CHAR(6);
    DECLARE @TongTienCu NUMERIC(15, 2);
    DECLARE @TongTienMoi NUMERIC(15, 2);

	IF (SELECT COUNT(*) FROM inserted) > 0
        SELECT @Ma_HD_BanHang = (SELECT TOP 1 Ma_HD_BanHang FROM inserted)
    ELSE IF (SELECT COUNT(*) FROM deleted) > 0
        SELECT @Ma_HD_BanHang = (SELECT TOP 1 Ma_HD_BanHang FROM deleted)

    -- Tính tổng tiền cũ (trước khi thay đổi) từ các dòng không bị ảnh hưởng trong bảng BanHang_CT và các bản ghi trong deleted
    SELECT @TongTienCu = ISNULL(
        (SELECT SUM(BanHang_CT.SoLuong * MonNuoc.DonGia)
         FROM BanHang_CT
         JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon
         WHERE BanHang_CT.Ma_HD_BanHang = @Ma_HD_BanHang), 0) + 
        ISNULL(
        (SELECT SUM(deleted.SoLuong * MonNuoc.DonGia)
         FROM deleted
         JOIN MonNuoc ON deleted.Ma_Mon = MonNuoc.Ma_Mon
         WHERE deleted.Ma_HD_BanHang = @Ma_HD_BanHang), 0) - 
        ISNULL(
        (SELECT SUM(inserted.SoLuong * MonNuoc.DonGia)
         FROM inserted
         JOIN MonNuoc ON inserted.Ma_Mon = MonNuoc.Ma_Mon
         WHERE inserted.Ma_HD_BanHang = @Ma_HD_BanHang), 0);

    -- Tính tổng tiền mới (sau khi thay đổi) từ bảng BanHang_CT hiện tại
    SELECT @TongTienMoi = ISNULL(
        (SELECT SUM(BanHang_CT.SoLuong * MonNuoc.DonGia)
         FROM BanHang_CT
         JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon
         WHERE BanHang_CT.Ma_HD_BanHang = @Ma_HD_BanHang), 0)

    -- In ra tiền ban đầu và tiền đã thay đổi
    PRINT N'Mã hóa đơn: ' + @Ma_HD_BanHang;
    PRINT N'Tiền ban đầu: ' + CAST(@TongTienCu AS NVARCHAR(20));
    PRINT N'Tiền đã thay đổi: ' + CAST(@TongTienMoi AS NVARCHAR(20));
    PRINT N'Thay đổi: ' + CAST((@TongTienMoi - @TongTienCu) AS NVARCHAR(20));
END

--Mod11:
CREATE PROCEDURE proc_KiemTraThemBanHang_CT
    @Ma_HD_BanHang CHAR(6),
    @Ma_Mon CHAR(6),
    @SoLuong INT,
    @Output nvarchar(50) OUTPUT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM BanHang_CT
        WHERE Ma_HD_BanHang = @Ma_HD_BanHang
        AND Ma_Mon = @Ma_Mon
    )
    BEGIN
        SET @Output = N'Đã tồn tại bản ghi';
    END
    ELSE
    BEGIN
        INSERT INTO BanHang_CT (Ma_HD_BanHang, Ma_Mon, SoLuong)
        VALUES (@Ma_HD_BanHang, @Ma_Mon, @SoLuong)
        SET @Output = N'Dữ liệu đã được thêm thành công.'
    END
END

--Mod 12:
CREATE TRIGGER Mod12_triggerXoaBanHang_CT
ON BanHang
AFTER DELETE
AS
BEGIN
    DELETE FROM BanHang_CT
    WHERE Ma_HD_BanHang IN (SELECT Ma_HD_BanHang FROM DELETED)
END

--Mod 13:
CREATE PROCEDURE Mod13_proc_ThongKeNo
    @Ma_NCC char(6) = NULL
As
BEGIN
    IF @Ma_NCC IS NOT NULL  -- Tính cho 1 NCC cụ thể
    BEGIN
        SELECT 
			NhaCungCap.Ma_NCC,
			NhaCungCap.Ten_NCC,
			COUNT(No.Ma_HD_No)as SoLuongNo,
			Sum(No.Tien_No) as TongNo
		From NhaCungCap
		Join No on NhaCungCap.Ma_NCC=No.Ma_NCC
		Where NhaCungCap.Ma_NCC=@Ma_NCC
		group by NhaCungCap.Ma_NCC, Ten_NCC
	End
	Else	--Tính nợ toàn bộ NCC
	Begin
		Select
			NhaCungCap.Ma_NCC,
			NhaCungCap.Ten_NCC,
			COUNT(No.Ma_HD_No) as SoLuongNo,
            SUM(No.Tien_No) as TongNo
		From NhaCungCap
		join No on NhaCungCap.Ma_NCC=No.Ma_NCC
		Group by NhaCungCap.Ma_NCC, Ten_NCC
		order by TongNo desc
		end
End

EXEC Mod13_proc_ThongKeNo
EXEC Mod13_proc_ThongKeNo 'CC0565'

--Mod 14:
CREATE TRIGGER Mod14_Capnhattongno
ON No
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Ma_HD_No CHAR(6),
            @TienNoMoi INT,
            @TongNoHienTai INT

	SELECT TOP 1 @Ma_HD_No = Ma_HD_No
	FROM (
		SELECT Ma_HD_No FROM deleted
		UNION ALL
		SELECT Ma_HD_No FROM inserted
	) AS Ma_HD_No_table

    SELECT @TienNoMoi = ISNULL(
        (SELECT SUM(inserted.Tien_No)
         FROM inserted 
         WHERE inserted.Ma_HD_No = @Ma_HD_No), 0) 
        -
        ISNULL(
        (SELECT SUM(deleted.Tien_No)
         FROM deleted 
         WHERE deleted.Ma_HD_No = @Ma_HD_No), 0)

    UPDATE No
    SET Tien_No = Tien_No + @TienNoMoi
    WHERE Ma_HD_No = @Ma_HD_No

    SELECT @TongNoHienTai = SUM(Tien_No) FROM No

    PRINT N'Cập nhật tiền nợ'
    PRINT N'Lượng tiền nợ thay đổi là: ' + CAST(@TienNoMoi AS NVARCHAR(15))
    PRINT N'Tổng nợ hiện tại là: ' + CAST(@TongNoHienTai AS NVARCHAR(15))
END
--Test
select * from No

DELETE FROM No
WHERE Ma_HD_No = 'NO1113'

INSERT INTO No(Ma_HD_No, Tien_No, NgayHetHan, Ma_NCC)
VALUES ('NO1113', '9999', '2020-11-04', 'CC1000')

update No
set Tien_No='3'
where Ma_HD_No='NO1113'

--Mod 15:
CREATE PROCEDURE Mod15_trigger_MonNuocBanChayNhat
    @startDate DATE,
    @endDate DATE
AS
BEGIN
    DECLARE @maxDoanhSo INT;
	SELECT @maxDoanhSo = MAX(DoanhSo)
    FROM 
    (
        SELECT SUM(BanHang_CT.SoLuong) AS DoanhSo
        FROM BanHang_CT
        JOIN BanHang ON BanHang_CT.Ma_HD_BanHang = BanHang.Ma_HD_BanHang
        WHERE BanHang.NgayThanhToan BETWEEN @startDate AND @endDate
        GROUP BY BanHang_CT.Ma_Mon
    ) AS DoanhSoTable

    IF @maxDoanhSo IS NULL
    BEGIN
        PRINT N'Không có món nước nào ở thời gian này!';
        RETURN
    END

    -- Lọc các món nước có doanh số bằng doanh số lớn nhất
    SELECT MonNuoc.Ten_Mon, SUM(BanHang_CT.SoLuong) AS DoanhSo
    FROM BanHang_CT
    JOIN BanHang ON BanHang_CT.Ma_HD_BanHang = BanHang.Ma_HD_BanHang
    JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon
    WHERE BanHang.NgayThanhToan BETWEEN @startDate AND @endDate
    GROUP BY MonNuoc.Ten_Mon
    HAVING SUM(BanHang_CT.SoLuong) = @maxDoanhSo
END
---Test 15:
EXEC Mod15_trigger_MonNuocBanChayNhat '2023-03-01', '2023-03-31'

--Mod 16:
CREATE PROCEDURE Mod16_CapNhatGiaHang
    @Ma_H CHAR(6),
    @GiaMoi NUMERIC(15)
AS
BEGIN
    IF @Ma_H Not IN (SELECT Ma_H FROM Hang)
    BEGIN
        Print(N'Không tồn tại hàng này.');
        RETURN;
    END
	ELSE
	Begin
		UPDATE Hang
		SET DonGia = @GiaMoi
		WHERE Ma_H = @Ma_H;
		PRINT N'Cập nhật giá thành công.'
	END
END
----Test
select * from Hang
EXEC Mod16_CapNhatGiaHang 'H00001', 20000;

--Mod 17:
CREATE PROCEDURE Mod17_CapNhatGiaMonNuoc
    @Ma_Mon CHAR(6),
    @GiaMoi NUMERIC(15)
AS
BEGIN
    IF @Ma_Mon Not IN (SELECT Ma_Mon FROM MonNuoc)
    BEGIN
        Print(N'Món nước không tồn tại.');
    END
	Else
	Begin
		UPDATE MonNuoc
		SET DonGia = @GiaMoi
		WHERE Ma_Mon = @Ma_Mon;
		Print(N'Đã cập nhật giá món')
	End
END
select * from MonNuoc

-----Test
EXEC Mod17_CapNhatGiaMonNuoc 'MN1000', 25000

--Mod 18:
CREATE PROCEDURE Mod18_trigger_ThemHangHoa
    @Ma_H CHAR(6),           
    @Ten_H NVARCHAR(100),   
    @DonGia NUMERIC(15)     
AS
BEGIN
    -- Kiểm tra xem mã hàng đã tồn tại hay chưa bằng COUNT(*)
    IF (SELECT COUNT(*) FROM Hang WHERE Ma_H = @Ma_H) > 0
    BEGIN
        PRINT N'Đã tồn tại';
        RETURN; 
    END

    INSERT INTO Hang (Ma_H, Ten_H, DonGia)
    VALUES (@Ma_H, @Ten_H, @DonGia)
    PRINT N'Thêm thành công'
END
------Test
select * from Hang
EXEC Mod18_trigger_ThemHangHoa @Ma_H = 'H01001', @Ten_H = N'Nước Ngọt', @DonGia = 20000

--Mod 19: Thủ tục thêm món nước mới
CREATE PROCEDURE Mod19_ThemMonNuoc
    @Ma_Mon CHAR(6),          
    @Ten_Mon NVARCHAR(100),     
    @DonGia NUMERIC(15)         
AS
BEGIN
    -- Kiểm tra xem mã món đã tồn tại hay chưa bằng COUNT(*)
    IF (SELECT COUNT(*) FROM MonNuoc WHERE Ma_Mon = @Ma_Mon) > 0
    BEGIN
        PRINT N'Đã tồn tại'
        RETURN -- Dừng thực thi thủ tục
    END

    -- Thêm món nước mới vào bảng MonNuoc
    INSERT INTO MonNuoc (Ma_Mon, Ten_Mon, DonGia)
    VALUES (@Ma_Mon, @Ten_Mon, @DonGia)

    PRINT N'Thêm thành công.'
END

--Mod 20:
CREATE PROCEDURE Mod20_tinh_LoiNhuan
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    DECLARE @doanhthu NUMERIC(15, 2);
    DECLARE @chiphi NUMERIC(15, 2);
    DECLARE @loinhuan NUMERIC(15, 2);

    -- Tính tổng doanh thu từ bảng BanHang
    SELECT @doanhthu = ISNULL(SUM(BanHang_CT.SoLuong * MonNuoc.DonGia), 0)
    FROM BanHang
    JOIN BanHang_CT ON BanHang.Ma_HD_BanHang = BanHang_CT.Ma_HD_BanHang
    JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon
    WHERE BanHang.NgayThanhToan BETWEEN @StartDate AND @EndDate;

    -- Tính tổng chi phí từ bảng Nhap_CT
    SELECT @chiphi = ISNULL(SUM(Nhap_CT.SoLuong * Hang.DonGia), 0)
    FROM Nhap
    JOIN Nhap_CT ON Nhap.Ma_HD_Nhap = Nhap_CT.Ma_HD_Nhap
    JOIN Hang ON Nhap_CT.Ma_H = Hang.Ma_H
    WHERE Nhap.NgayNhap BETWEEN @StartDate AND @EndDate;

    -- Tính lợi nhuận
    SET @loinhuan = isnull(@doanhthu,0) - isnull(@chiphi,0)

    -- Trả kết quả
    SELECT 
        @doanhthu AS doanhthu,
        @chiphi AS chiphi,
        @loinhuan AS loinhuan
END
----Test
EXEC Mod20_tinh_LoiNhuan '2020-01-01', '2020-12-31'

--Mod 21:
Create proc Mod21_DoanhSoTungMon
				@NgayBatDau date,
				@NgayKetThuc date,
				@Ma_Mon varchar(50),
				@DoanhSo int output
as
begin
		select @Ma_Mon=MonNuoc.Ma_Mon, @DoanhSo = sum(BanHang_CT.SoLuong)
		from BanHang_CT inner join MonNuoc on BanHang_CT.Ma_Mon=MonNuoc.Ma_Mon
						inner join BanHang on BanHang.Ma_HD_BanHang=BanHang_CT.Ma_HD_BanHang
		where BanHang.NgayThanhToan between @NgayBatDau and @NgayKetThuc
		group by MonNuoc.Ma_Mon
end
-----Test
DECLARE @a INT
EXEC Mod21_DoanhSoTungMon '2024-10-01', '2024-10-10', 'MN0001', @a OUTPUT
SELECT @a AS MN0001

--Mod 22
CREATE PROCEDURE Mod22_TinhDoanhThuMonNuoc (
    @startDate DATE,
    @endDate DATE
)
AS
BEGIN
    SELECT 
        MonNuoc.Ma_Mon,                      
        MonNuoc.Ten_Mon,                     
        SUM(BanHang_CT.SoLuong * MonNuoc.DonGia) AS DoanhThu  
    FROM BanHang
    JOIN BanHang_CT ON BanHang.Ma_HD_BanHang = BanHang_CT.Ma_HD_BanHang  
    JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon  
    WHERE BanHang.NgayThanhToan BETWEEN @startDate AND @endDate  
    GROUP BY MonNuoc.Ma_Mon, MonNuoc.Ten_Mon  
    ORDER BY DoanhThu DESC
END
----Test
EXEC Mod22_TinhDoanhThuMonNuoc '2024-01-01', '2024-12-31';

--Mod23
CREATE PROCEDURE Mod23_TimMonDoanhThuCaoNhatCuoiTuan
AS
BEGIN
    SELECT TOP 1 MonNuoc.Ten_Mon, 
                SUM(BanHang_CT.SoLuong * MonNuoc.DonGia) AS TongDoanhThu
    FROM BanHang
    JOIN BanHang_CT ON BanHang.Ma_HD_BanHang = BanHang_CT.Ma_HD_BanHang
    JOIN MonNuoc ON BanHang_CT.Ma_Mon = MonNuoc.Ma_Mon
    WHERE DATEPART(WEEKDAY, BanHang.NgayThanhToan) IN (7, 1) -- Thứ 7: 7, Chủ Nhật: 1
    GROUP BY MonNuoc.Ten_Mon
    ORDER BY TongDoanhThu DESC
END
----Test
EXEC Mod23_TimMonDoanhThuCaoNhatCuoiTuan;

--Mod 24:
CREATE PROCEDURE Mod24_HangNhapNhieuNhat
    @startDate DATE,
    @endDate DATE
AS
BEGIN
    SELECT TOP 1
        Hang.Ma_H,
        Hang.Ten_H,
        SUM(Nhap_CT.SoLuong) AS TongSoLuong
    FROM Nhap_CT 
    JOIN Hang ON Nhap_CT.Ma_H = Hang.Ma_H
	JOIN Nhap On Nhap.Ma_HD_Nhap=Nhap_CT.Ma_HD_Nhap
    WHERE Nhap.NgayNhap BETWEEN @startDate AND @endDate
    GROUP BY Hang.Ma_H, Hang.Ten_H
    ORDER BY SUM(Nhap_CT.SoLuong) DESC
END
----Test
EXEC Mod24_HangNhapNhieuNhat  '2024-01-01', '2024-12-31';

---------------------------------
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

---------------------------------
---------------------------------
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
declare @tbao bit --Truong hop dung
exec KiemTraDangNhap 'TK0001', '8226', @tbao = @tbao output
print @tbao

--Test truong hop sai
declare @tbao bit
exec KiemTraDangNhap 'TK0001', 'Khangdz', @tbao = @tbao output
print @tbao
