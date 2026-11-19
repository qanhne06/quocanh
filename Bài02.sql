CREATE DATABASE QuanLyHang
-- Bang KHACH
CREATE TABLE KHACH (
    Ma_khach   CHAR(6) PRIMARY KEY,             
    Ten_kh     NVARCHAR(30) NOT NULL,           
    Diachi_kh  NVARCHAR(30) NOT NULL
);

-- Bang HANG
CREATE TABLE HANG (
    Ma_hang    CHAR(6) PRIMARY KEY,            
    Ten_hang   NVARCHAR(15) NOT NULL,
    Mota_hang  NVARCHAR(30),
    Don_vi     NVARCHAR(10)
);

-- Bang DONHANG
CREATE TABLE DONHANG (
    So_don     CHAR(6) PRIMARY KEY,
    Ma_khach   CHAR(6) NOT NULL,
    Ngay_don   DATE DEFAULT GETDATE(),          
    FOREIGN KEY (Ma_khach) REFERENCES KHACH(Ma_khach)
);

-- Bảng DÒNG ĐƠN HÀNG
CREATE TABLE DONGDON (
    So_don     CHAR(6) NOT NULL,
    Ma_hang    CHAR(6) NOT NULL,
    So_luongd  INT CHECK (So_luongd > 0),
    PRIMARY KEY (So_don, Ma_hang),
    FOREIGN KEY (So_don) REFERENCES DONHANG(So_don),
    FOREIGN KEY (Ma_hang) REFERENCES HANG(Ma_hang)
);

-- Bảng PHIẾU GIAO
CREATE TABLE PHIEUGIAO (
    So_phieu   CHAR(6) PRIMARY KEY,
    Ma_khach   CHAR(6) NOT NULL,
    Ngay_giao  DATE,
    Noi_giao   NVARCHAR(30),
    Tong_tien  DECIMAL(12,2),
    FOREIGN KEY (Ma_khach) REFERENCES KHACH(Ma_khach)
);

-- Bảng DONG PHIEU
CREATE TABLE DONGPHIEU (
    So_phieu   CHAR(6) NOT NULL,
    Ma_hang    CHAR(6) NOT NULL,
    Don_gia    DECIMAL(12,2) CHECK (Don_gia >= 0),
    So_luonggi INT CHECK (So_luonggi > 0),
    PRIMARY KEY (So_phieu, Ma_hang),
    FOREIGN KEY (So_phieu) REFERENCES PHIEUGIAO(So_phieu),
    FOREIGN KEY (Ma_hang) REFERENCES HANG(Ma_hang)
);
-- Thêm khách hàng
INSERT INTO KHACH (Ma_khach, Ten_kh, Diachi_kh)
VALUES ('KH0001', N'Vũ Quốc Anh', N'Hà Nội');

INSERT INTO KHACH (Ma_khach, Ten_kh, Diachi_kh)
VALUES ('KH0002', N'Nguyễn Gia Bảo', N'Hà Nam');

INSERT INTO KHACH (Ma_khach, Ten_kh, Diachi_kh)
VALUES ('KH0003', N'Lường Văn Chương', N'Sơn La');

-- Thêm hàng
INSERT INTO HANG (Ma_hang, Ten_hang, Mota_hang, Don_vi)
VALUES ('H0001', N'May tinh', N'Hang dien tu', N'Cai');

INSERT INTO HANG (Ma_hang, Ten_hang, Mota_hang, Don_vi)
VALUES ('H0002', N'Dien thoai', N'Hang dien tu', N'Chiec');

INSERT INTO HANG (Ma_hang, Ten_hang, Mota_hang, Don_vi)
VALUES ('H0003', N'Tu lanh', N'Do dien', N'Chiec');

-- Thêm đơn hàng
INSERT INTO DONHANG (So_don, Ma_khach, Ngay_don)
VALUES ('D0001', 'KH0001', GETDATE());

INSERT INTO DONHANG (So_don, Ma_khach, Ngay_don)
VALUES ('D0002', 'KH0002', GETDATE());

INSERT INTO DONHANG (So_don, Ma_khach, Ngay_don)
VALUES ('D0003', 'KH0003', GETDATE());

-- Thêm dòng đơn hàng
INSERT INTO DONGDON (So_don, Ma_hang, So_luongd)
VALUES ('D0001', 'H0001', 3);

INSERT INTO DONGDON (So_don, Ma_hang, So_luongd)
VALUES ('D0002', 'H0002', 5);

INSERT INTO DONGDON (So_don, Ma_hang, So_luongd)
VALUES ('D0003', 'H0003', 4);

-- Thêm phiếu giao
INSERT INTO PHIEUGIAO (So_phieu, Ma_khach, Ngay_giao, Noi_giao, Tong_tien)
VALUES ('PG001', 'KH0001', GETDATE(), N'Ha Noi', 30000000);
INSERT INTO PHIEUGIAO (So_phieu, Ma_khach, Ngay_giao, Noi_giao, Tong_tien)
VALUES ('PG002', 'KH0002', GETDATE(), N'Ha Noi', 50000000);
INSERT INTO PHIEUGIAO (So_phieu, Ma_khach, Ngay_giao, Noi_giao, Tong_tien)
VALUES ('PG003', 'KH0003', GETDATE(), N'Ha Noi', 20000000);

-- Thêm dòng phiếu
INSERT INTO DONGPHIEU (So_phieu, Ma_hang, Don_gia, So_luonggi)
VALUES ('PG001', 'H0001', 10000000, 3);
INSERT INTO DONGPHIEU (So_phieu, Ma_hang, Don_gia, So_luonggi)
VALUES ('PG002', 'H0002', 10000000, 5);
INSERT INTO DONGPHIEU (So_phieu, Ma_hang, Don_gia, So_luonggi)
VALUES ('PG003', 'H0003', 10000000, 4);
--2.Xem bang Khach
SELECT  * FROM KHACH;
SELECT * FROM HANG;
SELECT * FROM PHIEUGIAO;
--3.Xoa 1 ban ghi cua bang DONHANG 
DELETE FROM DONHANG
WHERE So_don = 'D0002';
--4.Cap nhat don gia tu lanh giam 10%
UPDATE DONGPHIEU
SET Don_gia = Don_gia * 0.9
WHERE Ma_hang IN (
    SELECT Ma_hang FROM HANG WHERE Ten_hang = N'Tu lanh'
);
--5
UPDATE KHACH
SET Ten_kh = N'Vũ Quốc Anh',
    Diachi_kh = N'TP Ho Chi Minh'
WHERE Ma_khach = 'KH0001';
--6
SELECT Ten_kh, Diachi_kh
FROM KHACH;
--7.Dua ra ten hang,mo ta hang
SELECT Ten_hang, Mota_hang, Don_vi
FROM HANG;
--8.Dua ra tat ca cac don vi tinh
SELECT DISTINCT Don_vi
FROM HANG;
--9.Dua ra tat ca cac ten hang
SELECT Ten_hang
FROM HANG;
--10.Dua ra tat ca cac dia chi cua khach hang
SELECT Diachi_kh
FROM KHACH;
--11.Đua ra so_phieu, ma_hang, don_gia, soluonggi và Thanh tien (don_gia*so_luong) cua tat ca hang
SELECT So_phieu, Ma_hang, Don_gia, So_luonggi, 
       (Don_gia * So_luonggi) AS ThanhTien
FROM DONGPHIEU;
--12.
SELECT So_phieu, Ma_hang, Don_gia, So_luonggi, 
       (Don_gia * So_luonggi) AS thanh_tien
FROM DONGPHIEU;
--13.Dua ra tat ca gia tri cua bang hang theo giam dan
SELECT*FROM HANG
ORDER BY MA_hang DESC
--14.Dua ra tat cac cua bang gia tri phieu giao theo thu tu tang dan(giam) cua tong tien
SELECT*FROM PHIEUGIAO
ORDER BY Tong_tien ASC;

SELECT*FROM PHIEUGIAO
ORDER BY Tong_tien DESC;
--15.Dua ra tat ca khach hang co dia chi Dai hoc quoc gia
SELECT * FROM KHACH
WHERE Diachi_kh = N'Sơn La';
--16.Đưa ra So_phieu, Ma_khach với điều kiện Tong_ tien>=100.000, và sắp xếp theo điều kiện giảm dần của Tong_tien.
SELECT So_phieu, Ma_khach, Tong_tien
FROM PHIEUGIAO
WHERE Tong_tien >= 100000
ORDER BY Tong_tien DESC;
--17.Đưa ra ten_hang, mota_hang của những hàng hóa có don_vi được tính theo bông.
SELECT Ten_hang, Mota_hang, Don_vi
FROM HANG
WHERE Don_vi = N'bong';
--18.Đưa ra danh sách các bản ghi bao gồm so_phieu, ma_khach, ngay_giao với điều kiện Noi_giao là Hà Nội và Tong_tien>50.000.
SELECT So_phieu, Ma_khach, Ngay_giao, Noi_giao, Tong_tien
FROM PHIEUGIAO
WHERE Noi_giao = N'Ha Noi'
AND Tong_tien >50000;
--19. Đưa ra danh sách các bản ghi bao gồm Ma_khach, Ten_khach với điều kiện địa chỉ của khách ở Đại học Quốc Gia hoặc Đại học Mở. 
SELECT Ma_khach, Ten_kh, Diachi_kh
FROM KHACH
WHERE Diachi_kh = N'Dai hoc quoc gia'
   OR Diachi_kh = N'Dai hoc Mo';
--20.Đưa ra những mặt hàng có đơn vị tính là Bông, Cành hoặc Bó. 
SELECT*FROM HANG
WHERE Don_vi IN (N'Bong', N'Canh', N'Bo')
--21.Đưa ra danh sách những khách hàng (Ma_khach, Tong_tien) có Noi_giao nằm trong số các địa điểm sau:  Hà Nội, Hồ Chí Minh, Hải Phòng.
SELECT Ma_khach, Tong_tien, Noi_giao
FROM PHIEUGIAO
WHERE Noi_giao IN (N'Ha noi', N'TP Ho Chi Minh', N'Hai Phong');
--22.Đưa ra tất cả những thông tin trong bảng PHIEUGIAO với điều kiện tong_tien nằm trong khoảng từ 100.000 đến 500.000.
SELECT *
FROM PHIEUGIAO
WHERE Tong_tien BETWEEN 1000000 AND 50000000;
--23.Đưa ra ma_kh, ten_kh của những khách hàng có họ là Nguyễn.
SELECT Ma_khach, Ten_kh
FROM KHACH
WHERE Ten_kh LIKE N'Nguyễn%';
--24.
SELECT Ma_khach, COUNT(*) AS SoLanMua
FROM DONHANG
WHERE Ma_khach = 'KH0001'
GROUP BY Ma_khach;
--25.
SELECT AVG (Tong_tien) AS TrungBinhPG
FROM PHIEUGIAO;
--26
SELECT SUM (Tong_tien)  AS KH0002
FROM PHIEUGIAO
WHERE Ma_khach = 'KH0002';
--27
SELECT COUNT(*) AS SoLuongKH
FROM KHACH
WHERE Diachi_kh = N'Hà Nam';
--28
SELECT  Ma_khach, Ngay_giao, Noi_giao, Tong_tien
FROM PHIEUGIAO
WHERE Tong_tien = (SELECT MAX (Tong_tien) FROM PHIEUGIAO);
--29
SELECT  Ma_khach, Ngay_giao, Noi_giao, Tong_tien
FROM PHIEUGIAO
WHERE Tong_tien = (SELECT MIN (Tong_tien) FROM PHIEUGIAO);


