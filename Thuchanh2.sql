CREATE DATABASE QuanLyBanHang
USE QuanLyBanHang;

CREATE TABLE tblKhachHang(
    iMaKH INT NOT NULL,
    sTenKH NVARCHAR(50),
    dNgaySinh DATE,
    sDiaChi NVARCHAR(100),
    sDienThoai VARCHAR(15)
);
GO

CREATE TABLE tblNhanVien (
    iMaNV INT NOT NULL,
    sTenNV NVARCHAR(50),
    dNgaySinh DATE,
    dNgayVaoLam DATE,
    sDiaChi NVARCHAR(100),
    sDienThoai VARCHAR(15),
    fLuongCoBan FLOAT CHECK(fLuongCoBan > 0),
    fPhuCap FLOAT CHECK(fPhuCap > 0)
);
GO

ALTER TABLE tblNhanVien
ADD sCMND VARCHAR(12) UNIQUE;
GO

ALTER TABLE tblKhachHang
ADD CONSTRAINT PK_tblKhachHang PRIMARY KEY (iMaKH);

ALTER TABLE tblNhanVien
ADD CONSTRAINT PK_tblNhanVien PRIMARY KEY (iMaNV);

ALTER TABLE tblKhachHang
ADD iMaNV CHAR(10);

ALTER TABLE tblKhachHang
ADD CONSTRAINT FK_KhachHang_NhanVien FOREIGN KEY (iMaNV)
REFERENCES tblNhanVien(iMaNV);
GO

ALTER TABLE tblNhanVien
ADD CONSTRAINT CK_TuoiNhanVien CHECK (DATEDIFF(YEAR, dNgaySinh, dNgayVaoLam) >= 18);
GO

CREATE TABLE tblMathang (
    sMaHang CHAR(10) NOT NULL PRIMARY KEY,
    sTenHang NVARCHAR(50),
    fSoluong FLOAT,
    fGiahang FLOAT,
    sDonvitinh NVARCHAR(10)
);

ALTER TABLE tblMathang
ADD sDonvitinh NVARCHAR(10);
GO

CREATE INDEX TenHang ON tblMathang(sTenHang);
GO

CREATE TABLE tblDonNhapHang(
    iSoDN INT PRIMARY KEY,          
    dNgayNhap DATETIME NOT NULL,    
    iMaNV INT NOT NULL,             
    iMaNCC INT NOT NULL
);
GO
CREATE TABLE tblChiTietNhapHang(
    iSoDN INT NOT NULL,            
    sMaHang CHAR(10) NOT NULL,      
    iSoLuong INT CHECK (iSoLuong > 0),
    fDonGia FLOAT CHECK (fDonGia >= 0),
    CONSTRAINT PK_tblChiTietNhapHang PRIMARY KEY(iSoDN, sMaHang)
);
GO

ALTER TABLE tblChiTietNhapHang
ADD CONSTRAINT FK_ChiTiet_DonNhap FOREIGN KEY (iSoDN)
REFERENCES tblDonNhapHang(iSoDN);
GO
ALTER TABLE tblChiTietNhapHang
ADD CONSTRAINT FK_ChiTiet_MatHang FOREIGN KEY (sMaHang)
REFERENCES tblMatHang(sMaHang);
GO
ALTER TABLE tblChiTietNhapHang
ADD CONSTRAINT CK_GiaNhap CHECK (fGiaNhap > 0);

ALTER TABLE tblChiTietNhapHang
ADD CONSTRAINT CK_SoLuongNhap CHECK (fSoLuongNhap > 0);


ALTER TABLE tblKhachHang
ADD bGioiTinh BIT;

CREATE TABLE tblDonDatHang (
    iSoHD INT NOT NULL,
    iMaNV INT NOT NULL,
    iMaKH INT NOT NULL,
    dNgayDatHang DATETIME NOT NULL DEFAULT GETDATE(),
    dNgayGiaoHang DATETIME NOT NULL,
    CONSTRAINT PK_tblDonDatHang PRIMARY KEY (iSoHD),
    CONSTRAINT CK_NgayGiaoHang CHECK (dNgayGiaoHang >= dNgayDatHang),
    CONSTRAINT CK_NgayDatHang CHECK (dNgayDatHang <= GETDATE())
);
ALTER TABLE tblDonDatHang
ADD CONSTRAINT FK_DonDatHang_KhachHang FOREIGN KEY (iMaKH)
    REFERENCES tblKhachHang(iMaKH);

ALTER TABLE tblDonDatHang
ADD CONSTRAINT FK_DonDatHang_NhanVien FOREIGN KEY (iMaNV)
    REFERENCES tblNhanVien(iMaNV);

