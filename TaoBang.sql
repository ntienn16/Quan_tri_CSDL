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