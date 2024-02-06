--21127660--
--W4-Truy vấn gom nhóm--
USE MASTER
GO
IF DB_ID('QLThamGiaDeTai') IS NOT NULL
	DROP DATABASE QLThamGiaDeTai
GO

CREATE DATABASE QLThamGiaDeTai
GO

USE QLThamGiaDeTai
GO

--TẠO BẢNG VÀ TẠO RÀNG BUỘC KHÓA CHÍNH CHO CÁC BẢNG
--GIAOVIEN
CREATE TABLE GIAOVIEN
(
	MAGV char(5),
	HOTEN nvarchar(30),
	LUONG float,
	PHAI nvarchar(4),
	NGAYSINH date,
	DIACHI nvarchar(50),
	GVQLCM char(5),
	MABM nchar(5)

	CONSTRAINT PK_GIAOVIEN
	PRIMARY KEY(MAGV)
)
--GV_DT
CREATE TABLE GV_DT
(
	MAGV char(5),
	DIENTHOAI char(10)

	CONSTRAINT PK_GV_DT
	PRIMARY KEY(MAGV, DIENTHOAI)
)
--BOMON--
CREATE TABLE BOMON
(
	MABM nchar(5),
	TENBM nvarchar(30),
	PHONG char(5),
	DIENTHOAI char(10),
	TRUONGBM char(5),
	MAKHOA char(5),
	NGAYNHANCHUC date

	CONSTRAINT PK_BOMON
	PRIMARY KEY(MABM)
)
--KHOA
CREATE TABLE KHOA
(
	MAKHOA char(5),
	TENKHOA nvarchar(30),
	NAMTL int,
	PHONG char(5),
	DIENTHOAI char(10),
	TRUONGKHOA char(5),
	NGAYNHANCHUC date

	CONSTRAINT PK_KHOA
	PRIMARY KEY(MAKHOA)
)
--DETAI
CREATE TABLE DETAI
(
	MADT char(5),
	TENDT nvarchar(50),
	CAPQL nvarchar(20),
	KINHPHI float,
	NGAYBD date,
	NGAYKT date,
	MACD nchar(5),
	GVCNDT char(5)

	CONSTRAINT PK_DETAI
	PRIMARY KEY(MADT)
)
--CHUDE
CREATE TABLE CHUDE
(
	MACD nchar(5),
	TENCD nvarchar(50)

	CONSTRAINT PK_CHUDE
	PRIMARY KEY(MACD)
)
--CONGVIEC
CREATE TABLE CONGVIEC
(
	MADT char(5),
	SOTT int,
	TENCV nvarchar(50),
	NGAYBD date,
	NGAYKT date

	CONSTRAINT PK_CONGVIEC
	PRIMARY KEY(MADT, SOTT)
)
--THAMGIADT
CREATE TABLE THAMGIADT
(
	MAGV char(5),
	MADT char(5),
	STT int,
	PHUCAP float,
	KETQUA nvarchar(3)

	CONSTRAINT PK_THAMGIADT
	PRIMARY KEY(MAGV, MADT, STT)
)
--NGUOI_THAN
CREATE TABLE NGUOITHAN
(
	MAGV char(5),
	TEN nvarchar(30),
	NGSINH date,
	PHAI nvarchar(3),
	QUANHE nvarchar(15)
)
--TAO RANG BUOC
alter table GIAOVIEN
add
	constraint FK_GIAOVIEN_GIAOVIEN
	foreign key(GVQLCM)
	references GIAOVIEN,

	constraint FK_GIAOVIEN_BOMON
	foreign key(MABM)
	references BOMON

alter table GV_DT
add
	constraint FK_GV_DT_GIAOVIEN
	foreign key(MAGV)
	references GIAOVIEN

alter table BOMON
add	
	constraint FK_BOMON_GIAOVIEN
	foreign key(TRUONGBM)
	references GIAOVIEN,

	constraint FK_BOMON_KHOA
	foreign key(MAKHOA)
	references KHOA

alter table KHOA
add
	constraint FK_KHOA_GIAOVIEN
	foreign key (TRUONGKHOA)
	references GIAOVIEN

alter table DETAI
add
	constraint FK_DETAI_GIAOVIEN
	foreign key(GVCNDT)
	references GIAOVIEN,

	constraint FK_DETAI_CHUDE
	foreign key(MACD)
	references CHUDE

alter table CONGVIEC
add
	constraint FK_CONGVIEC_DETAI
	foreign key(MADT)
	references DETAI

alter table THAMGIADT
add
	constraint FK_THAMGIADT_GIAOVIEN
	foreign key(MAGV)
	references GIAOVIEN,

	constraint FK_THAMGIADT_CONGVIEC
	foreign key(MADT, STT)
	references CONGVIEC

alter table NGUOITHAN
add
	constraint FK_NGUOITHAN_GIAOVIEN
	foreign key(MAGV)
	references GIAOVIEN

--RANG BUUOC MIEN GIA TRI
alter table GIAOVIEN
add constraint C_PHAI
check(PHAI IN('NAM',N'NỮ'))

alter table NGUOITHAN
add constraint NT_PHAI
check(PHAI IN('NAM',N'NỮ'))

--Nhập dữ liệu cho các bảng
insert KHOA
values
	('CNTT',N'Công nghệ thông tin',1995,'B11','0838123456',NULL,'02/20/2005'),
	('HH', N'Hóa học',1980,'B41','083845656',NULL,'10/15/2001'),
	('SH',N'Sinh học',1980,'B31','0838454545',NULL,'10/11/2000'),
	('VL',N'Vật lý',1976,'B21','0838223223',NULL,'09/18/2003')
insert BOMON
values
	('CNTT',N'Công nghệ tri thức','B15','0838126126',NULL,'CNTT',NULL),
	('HHC',N'Hóa hữu cơ','B44','838222222',NULL,'HH',NULL),
	('HL',N'Hóa lý','B42','0838878787',NULL,'HH',NULL),
	('HPT',N'Hóa phân tích','B43','0838777777',NULL,'HH','10/15/2007'),
	('HTTT', N'Hệ thống thông tin','B13','0838125125',NULL,'CNTT','09/20/2004'),
	('MMT',N'Mạng máy tính','B16','0838676767',NULL,'CNTT','05/15/2005'),
	('SH',N'Sinh hóa','B33','0838898989',NULL,'SH',NULL),
	('VLƯD',N'Vật lý ứng dụng','B24','0838454545',NULL,'VL','02/18/2006'),
	('VLĐT',N'Vật lý điện tử','B23','0838234234',NULL,'VL',NULL),
	('VS',N'Vi sinh','B32','0838909090',NULL,'SH','01/01/2007')
insert GIAOVIEN
values
	('001', N'Nguyễn Hoài An', '2000.0','Nam','02/15/1973',N'25/3 Lạc Long Quân, Q.10, TP HCM',NULL,NULL),
	('002', N'Trần Trà Hương', '2500.0',N'Nữ','06/20/1960',N'125 Trần Hưng Đạo, Q.1, TP HCM', NULL,NULL),
	('003', N'Nguyễn Ngọc Ánh', '2200.0', N'Nữ','05/11/1975',N'12/21 Võ Văn Ngân Thủ Đức, TP HCM', NULL,NULL),
	('004', N'Trương Nam Sơn', '2300.0', 'Nam','06/20/1959',N'215 Lý Thường Kiệt, TP Biên Hòa',NULL,NULL),
	('005', N'Lý Hoàng Hà', '2500.0', 'Nam', '10/23/1954', N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM', NULL,NULL),
	('006', N'Trần Bạch Tuyết','1500.0',N'Nữ','05/20/1980',N'127 Hùng Vương, TP Mỹ Tho',NULL,NULL),
	('007', N'Nguyễn An Trung','2100.0','Nam','06/05/1976',N'234 3/2, TP Biên Hòa', NULL,NULL),
	('008', N'Trần Trung Hiếu','1800.0','Nam','08/06/1977',N'22/11 Lý Thường Kiệt, TP Mỹ Tho',NULL,NULL),
	('009', N'Trần Hoàng Nam','2000.0','Nam','11/22/1975',N'234 Trấn Não, An Phú, TP HCM',NULL,NULL),
	('010', N'Phạm Nam Thanh','1500.0','Nam','12/12/1980',N'221 Hùng Vương, Q.5, TP HCM',NULL,NULL)

update BOMON
set MAKHOA='CNTT' where MABM='CNTT'
update BOMON
set MAKHOA='HH' where MABM='HHC'
update BOMON
set MAKHOA='HH' where MABM='HL'
update BOMON
set MAKHOA='HH' where MABM='HPT'
update BOMON
set MAKHOA='CNTT' where MABM='HTTT'
update BOMON
set MAKHOA='CNTT' where MABM='MTT'
update BOMON
set MAKHOA='SH' where MABM='SH'
update BOMON
set MAKHOA='VL' where MABM='VLĐT'
update BOMON
set MAKHOA='VL' where MABM='VLƯD'
update BOMON
set MAKHOA='SH' where MABM='VS'

update GIAOVIEN
set MABM='MMT'where MAGV='001'
update GIAOVIEN
set MABM='HTTT'where MAGV='002'
update GIAOVIEN
set GVQLCM='002', MABM='HTTT'where MAGV='003'
update GIAOVIEN
set MABM='VS'where MAGV='004'
update GIAOVIEN
set MABM='VLĐT'where MAGV='005'
update GIAOVIEN
set GVQLCM='004', MABM='VS'where MAGV='006'
update GIAOVIEN
set MABM='HPT'where MAGV='007'
update GIAOVIEN
set GVQLCM='007', MABM='HPT'where MAGV='008'
update GIAOVIEN
set GVQLCM='001', MABM='MMT'where MAGV='009'
update GIAOVIEN
set GVQLCM='007', MABM='HPT'where MAGV='010'

--update KHOA
update KHOA
set TRUONGKHOA='002'where MAKHOA='CNTT'
update KHOA
set TRUONGKHOA='007'where MAKHOA='HH'
update KHOA
set TRUONGKHOA='004'where MAKHOA='SH'
update KHOA
set TRUONGKHOA='005'where MAKHOA='VL'

--update BOMON
update BOMON set TRUONGBM='007'where MABM='HPT'
update BOMON 
set TRUONGBM='002'where MABM='HTTT'
update BOMON 
set TRUONGBM='001'where MABM='MMT'
update BOMON 
set TRUONGBM='005'where MABM='VLƯD'
update BOMON 
set TRUONGBM='004'where MABM='VS'

insert GV_DT
values
	('001','0838912112'),
	('001','0903123123'),
	('002','0913454545'),
	('003','0838121212'),
	('003','0903656565'),
	('003','0937125125'),
	('006','0937888888'),
	('008','0653717171'),
	('008','0913232323')

insert CHUDE
values
	('NCPT',N'Nghiên cứu phát triển'),
	('QLGD',N'Quản lý giáo dục'),
	('ƯDCN',N'Ứng dụng công nghệ')

insert DETAI
values
	('001',N'HTTT quản lý các trường ĐH','ĐHQG','20.0','10/20/2007','10/20/2008','QLGD','002'),
	('002',N'HTTT quản lý giáo vụ cho một Khoa',N'Trường','20.0','10/12/2000','10/12/2001','QLGD','002'),
	('003',N'Nghiên cứu chế tạo sợi Nanô Platin','ĐHQG','300.0','05/15/2008','05/15/2010','NCPT','005'),
	('004',N'Tạo vật liệu sinh học bằng màng ối người',N'Nhà nước','100.0','01/01/2003','12/31/2008','NCPT','004'),
	('005',N'Ứng dụng hóa học xanh',N'Trường','200.0','10/10/2003','12/10/2004','ƯDCN','007'),
	('006',N'Nghiên cứu tế bào gốc',N'Nhà nước','4000.0','10/20/2006','10/20/2009','NCPT','004'),
	('007',N'HTTT quản lý thư viện ở các trường ĐH',N'Trường','20.0','05/10/2009','05/10/2010','QLGD','001')


insert CONGVIEC
values
	('001',1,N'Khởi tạo và Lập kế hoạch','10/20/2007','12/20/2008'),
	('001',2,N'Xác định yêu cầu','12/21/2008','03/21/2008'),
	('001',3,N'Phân tích hệ thống','03/22/2008','05/22/2008'),
	('001',4,N'Thiết kế hệ thống','05/23/2008','06/23/2008'),
	('001',5,N'Cài đặt thử nghiệm','06/24/2008','10/20/2008'),
	('002',1,N'Khởi tạo và Lập kế hoạch','05/10/2009','07/10/2009'),
	('002',2,N'Xác định yêu cầu','07/11/2009','10/11/2009'),
	('002',3,N'Phân tích hệ thống','10/12/2009','12/20/2009'),
	('002',4,N'Thiết kế hệ thống','12/21/2009','03/22/2010'),
	('002',5,N'Cài đặt thử nghiệm','03/23/2010','05/10/2010'),
	('006',1,N'Lấy mẫu','10/20/2006','02/20/2007'),
	('006',2,N'Nuôi cấy','02/21/2007','08/21/2008')

insert THAMGIADT
values
	('001','002',1,'0.0',NULL),
	('001','002',2,'2.0',NULL),
	('002','001',4,'2.0',N'Đạt'),
	('003','001',1,'1.0',N'Đạt'),
	('003','001',2,'0.0',N'Đạt'),
	('003','001',4,'1.0',N'Đạt'),
	('003','002',2,'0.0',NULL),
	('004','006',1,'0.0',N'Đạt'),
	('004','006',2,'1.0',N'Đạt'),
	('006','006',2,'1.5',N'Đạt'),
	('009','002',3,'0.5',NULL),
	('009','002',4,'1.5',NULL)

insert NGUOITHAN
values
	('001',N'Hùng','01/14/1990','Nam','Con trai'),
	('001',N'Thủy','12/08/1994',N'Nữ','Con gái'),
	('003',N'Hà','09/03/1998',N'Nữ','Con gái'),
	('003','Thu','09/03/1998',N'Nữ','Con gái'),
	('007','Mai','03/26/2003',N'Nữ','Con gái'),
	('007','Vy','02/14/2000',N'Nữ', 'Con gái'),
	('008','Nam','05/06/1991','Nam','Em trai'),
	('009','An','08/19/1996','Nam','Em trai'),
	('010',N'Nguyệt','01/14/2006',N'Nữ','Con gái')

--Q27. Cho biết số lượng giáo viên và tổng lương của họ
select count(GV.MAGV) SOGV, SUM(GV.LUONG) TONGLUONG
from GIAOVIEN GV
--Q28. Cho biết số lượng giáo viên và lương trung bình của từng bộ môn
select GV.MABM, count(GV.MAGV) SOGV, avg(GV.LUONG) LUONGTB
from GIAOVIEN GV
group by MABM
--Q29. Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó
select CD.TENCD, count(DT.MADT) SODT
from CHUDE CD, DETAI DT 
where CD.MACD=DT.MACD
group by CD.MACD, CD.TENCD
--Q30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia
select GV.HOTEN, count(distinct TGDT.MADT) SODTTG
from GIAOVIEN GV, THAMGIADT TGDT
where GV.MAGV=TGDT.MAGV
group by GV.MAGV, GV.HOTEN
--Q31. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm
select GV.HOTEN, count(DT.GVCNDT) SODTCN
from GIAOVIEN GV, DETAI DT
where GV.MAGV=DT.GVCNDT
group by GV.MAGV, GV.HOTEN
--Q32. Với mỗi giáo viên cho tên giáo viên và số người thân của giáo viên đó
select GV.HOTEN, count(NT.MAGV) SONT
from GIAOVIEN GV join NGUOITHAN NT on GV.MAGV=NT.MAGV
group by GV.MAGV, GV.HOTEN
--Q33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên
select GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV=TGDT.MAGV
group by GV.MAGV, GV.HOTEN
having count(distinct TGDT.MADT)>3
--Q34. Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh
select count(distinct TG.MAGV) SOGV
from GIAOVIEN GV join THAMGIADT TG on GV.MAGV=TG.MAGV
				 join DETAI DT on TG.MADT=DT.MADT
where DT.TENDT like N'Ứng dụng hóa học xanh'
group by TG.MADT








