-- *************************DEMO SỬ DỤNG BIẾN VÀ CẤU TRÚC ĐIỀU KHIỂN *************************** --
-- 1. Khai báo biến dùng lệnh DECLARE, biến cục bộ phải bắt đầu bằng @tenbien
declare @tong int, @a int, @b int

-- 2. Gán biến dùng lệnh SET: Gán 1 giá trị duy nhất (cùng kiểu dữ liệu) cho biến
set @a = 5 
set @b = 6
set @tong = @a + @b 

--In kết quả
select @tong -- Dạng bảng
print @tong -- Dạng message

-- 3. Gán biến ở mệnh đề SELECT: 
--Gán được nhiều cột, nhưng 1 dòng duy nhất
Declare @magv char(10), @hoten nvarchar(100), @tenbm nvarchar(50), @sldt int 
Select @magv = gv.magv, 
       @hoten = gv.hoten, 
       @tenbm = bm.tenbm, 
       @sldt = count(distinct tg.madt)
From Giaovien gv join BOMON bm on gv.MABM = bm.MABM
                 join THAMGIADT tg on gv.magv = tg.MAGV
group by gv.magv, gv.hoten, bm.TENBM    
having gv.MAGV = '002'

--In kết quả
Select @magv N'Mã giáo viên', @hoten N'Họ tên', @tenbm N'Tên bộ môn', @sldt N'Số lượng đề tài'

-- Hàm cast và convert cho phép chuyển số sang chuỗi
Print @magv + '**********' + @hoten + '**********' + @tenbm + '**********' + cast(@sldt as char(2))
Print @magv + '**********' + @hoten + '**********' + @tenbm + '**********' + convert(char(2), @sldt)
GO

-- ********************************DEMO STORED PROCEDURE ******************************** --
/* 1. Tạo thủ tục thường trú: CREATE PROC*/
alter PROC sp_TenProc1 @thamso1 char(5), @thamso2 int, 
                        @kq1 char(10) out, @kq2 int out
AS
    /* @thamso1, @thamso2: tham số đầu vào cung cấp dữ liệu cho proc, phải cung cấp giá trị khi gọi thực thi
        @kq1, @kq2: tham số đầu ra nhận kết quả trả ra từ proc, phải có out ở cuối mỗi khai báo
        proc có thể KHÔNG CÓ hoặc CÓ NHIỀU tham số đầu vào và đầu ra
    */
        SET @kq1 = 'Hello ' + @thamso1
        SET @kq2 = @thamso2 + 1
GO

/* 2. Cập nhật thủ tục đã tạo: Giữ nguyên cú pháp thay lệnh CREATE bằng ALTER
ALTER PROC sp_TenProc1 @thamso1 char(5), @thamso2 int, @kq1 char(10) out, @kq2 int out 
AS 
        ... 
GO */

/* 3. Xoá thủ tục: DROP PROC */
DROP PROC sp_TenProc1

/* 4. Gọi thực thi thủ tục */
-- Khai báo biến chứa giá trị sẽ gán cho các tham số đầu --> cần khởi gán giá trị
DECLARE @ts1 char(5), @ts2 int 
SET @ts1 = 'LyLy'
SET @ts2 = 10

-- Khai báo biến chứa kết quả trả ra của proc --> không khởi gán giá trị nhưng cần khai báo out khi gọi thực thi
DECLARE @k1 char(10), @k2 int 

-- Thực thi liệt kê tường minh tham số --> Không cần quan tâm thứ tự tham số khi create proc
EXEC sp_TenProc1 @kq1 = @k1 out, @thamso2 = @ts2, 
                 @thamso1 = @ts1, @kq2 = @k2 out

-- Dùng lệnh select in kết quả dạng bảng
Select @k1 N'Xin chào', @k2 N'Tuổi'

-- Thực thi KHÔNG liệt kê tường minh tham số --> SỬ DỤNG thứ tự tham số khi create proc
EXEC sp_TenProc1 @ts1, @ts2, @k1 out, @k2 out

-- Dùng lệnh print in ra kết quả dạng chuỗi message
print @k1 + ' ' + convert(char(2), @k2) -- Cần chuyển số sang chuỗi để thực hiện phép toán + chuỗi


/*VÍ DỤ DEMO*/
--VD1: Lấy danh sách giáo viên theo bộ môn
--Input: @mabm, output: - (in danh sách trực tiếp trong SP)
--Cú pháp chung tạo đối tượng mới trong CSDL
--CREATE [LOAI_DOI_TUONG] Ten_DOI_TUONG KHAI_BAO
--LOAI_DOI_TUONG: database, table, procedure, function ...
go
--Create proc ten_proc dsthamso
--input: mặc định, tham số đầu vào, phải có giá trị khởi gán khi gọi proc thực thi
--output: phải được khai báo out|output sau kiểu dữ liệu, chứa kết quả xử lý
create proc sp_DSGV_TheoPhong @mabm char(5)
as
	select gv.*
	from giaovien gv
	where gv.mabm = @mabm
go 

--Dùng lệnh alter proc sp_DSGV_TheoPhong @mabm char(5) as .... go 
--để cập nhật store đã tồn tại
--Thực thi
declare @in1 char(5)
set @in1 = 'MMT'
exec sp_DSGV_TheoPhong @in1
go

--Tạo và thực thi stored procedure có giá trị trả về

--VD2: Kiểm tra quy định của một giáo viên chỉ được thực hiện các đề tài 
--     mà giáo viên của bộ môn của giáo viên đó làm chủ nhiệm
--Input: @magv, output: 1: Thoả đk, 0: Không thoả đk
--Output có thể được trả qua lệnh return (nếu là số và chỉ có 1 giá trị duy nhất) 
--hoặc trong các trường hợp khác dùng tham số đầu ra @ts KDL out|output

--Trả qua lệnh return (1 số nguyên duy nhất)
ALTER proc sp_KiemTraPhanCong1 @magv char(5), @ketqua nvarchar(50) out -- Lệnh ALTER cho phép cập nhật stored procedure đã có
as
	DECLARE @kq int
	if(@magv in (
	  select distinct gv.magv
	  from THAMGIADT tg, GIAOVIEN gv, DETAI dt, GIAOVIEN gvcn
	  where tg.MAGV = gv.MAGV and tg.MADT = dt.MADT and 
	        dt.gvcndt = gvcn.MAGV and gv.mabm != gvcn.mabm))
    begin 
	    set @kq = 0 --không thoả mãn quy định
        set @ketqua = N'Không thoả'
    end
	ELSE
    begin
		set @kq = 1 --thoả mãn quy định
        set @ketqua = N'Thoả quy định'
    end
	RETURN @kq -- Chỉ cho phép trả ra một giá trị SỐ NGUYÊN DUY NHẤT
go 

--Thực thi store procedure có tham số trả ra qua return
declare @kq_code int, @kq_str nvarchar(50) 

--Thực thi liệt kê tường minh tham số --> Không cần quan tâm thứ tự tham số khi create proc
exec @kq_code = sp_KiemTraPhanCong1 @ketqua = @kq_str out, @magv = '005'
print @kq_code
print @kq_str

--Thực thi không liệt kê tường minh --> Sử dụng thứ tự tham số khi create proc
exec @kq = sp_KiemTraPhanCong1 '005', @ketqua out
print @kq
print @ketqua

GO

--Trả qua tham số output (mọi kiểu dữ liệu, có thể nhiều giá trị trả ra)
create proc sp_KiemTraPhanCong2 @magv char(5), @kq int out
as
	if(@magv in (
	  select distinct gv.magv
	  from THAMGIADT tg, GIAOVIEN gv, DETAI dt, GIAOVIEN gvcn
	  where tg.MAGV = gv.MAGV and tg.MADT = dt.MADT and 
	        dt.gvcndt = gvcn.MAGV and gv.mabm != gvcn.mabm))
	    set @kq = 0 --không thoả mãn quy định
	ELSE
		set @kq = 1 --thoả mãn quy định

go 

--Thực thi store procedure có tham số trả ra qua tham số output
declare @kq int
exec sp_KiemTraPhanCong2 '005', @kq out
if (@kq=1)
    print(N'Thoả điều kiện.')
else 
    print(N'Không thoả điều kiện.')

go

--VD3: Input: @magv, output: @hoten, @tenbomon, @tenkhoa
create proc sp_timThongTinGiaoVien @magv char(10), 
                                   @hoten nvarchar(100) out,
                                   @tenbomon nvarchar(50) out,
                                   @tenkhoa nvarchar(50) out 
AS
    select @hoten = gv.hoten, @tenbomon = bm.TENBM, @tenkhoa = k.TENKHOA
    from giaovien gv join bomon bm on gv.mabm = bm.mabm 
                     join khoa k on bm.makhoa = k.makhoa
    where gv.MAGV = @magv
GO
--Thực thi
declare @ht nvarchar(100), @tbm nvarchar(50), @tk nvarchar(50)
exec sp_timThongTinGiaoVien '001', @ht out, @tbm out, @tk out
select @ht N'Họ tên', @tbm N'Tên bộ môn', @tk N'Tên khoa'

GO

--********************************DEMO FUNCTION******************************** --
--Đếm số lượng đề tài một giáo viên tham gia
--Input: magv, Output: số lượng (scalar-value)
--Cú pháp phải có begin ... end có thể có nhiều lệnh và return trả về 1 giá trị đơn cùng kiểu

--Tạo hàm mới
create function demDT(@magv char(5))
returns int -- return có S
as
    begin
        declare @sldt int
        set @sldt = (select count(distinct madt) from THAMGIADT where magv = @magv)
        return @sldt --return không có S

    end
go

--Cập nhật: alter function đemT(@magv char(5)) ...

--Gọi thực thi hàm dbo.TenHam(@thamso, ...)
print 'SLDT:' + convert(char(2), dbo.demDT('001'))
print 'SLDT: ' + cast(dbo.demDT('001') as char(2))
go

--Xuất dánh sách đề tài các giáo viên tham gia
--Input: -, Output: danh sách (table)
--Cú pháp không có begin ... enb và chỉ trả về 1 lệnh return duy nhất chứa truy vấn con

create function layDSDT()
returns table
as
    -- Các cột trả về trong truy vấn con phải được đặt tên
	return (select magv, count(distinct madt) as SLDT from THAMGIADT group by magv)
go

--Gọi thực thi hàm dbo.TenHam(@thamso, ...)
select * from dbo.layDSDT() T
order by T.MAGV

select gv.magv, gv.hoten, sl.SLDT
from giaovien gv join dbo.layDSDT() sl on gv.magv = sl.MAGV

go


