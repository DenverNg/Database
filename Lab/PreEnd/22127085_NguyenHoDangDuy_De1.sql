USE QLDETAI
GO

-- 1. Cho biết những bộ môn nào có nhiều giáo viên có số điện thoại nhất
SELECT BM.MABM, BM.TENBM
FROM BOMON BM JOIN GIAOVIEN GV ON BM.MABM = GV.MABM
WHERE GV.MAGV IN (SELECT MAGV
FROM GV_DT
WHERE GV_DT.MAGV = GV.MAGV)
GROUP BY BM.MABM, BM.TENBM
HAVING COUNT(GV.MAGV) >= ALL(SELECT COUNT(GV1.MAGV)
FROM GIAOVIEN GV1 JOIN BOMON BM1 ON GV1.MABM = BM1.MABM
WHERE GV1.MAGV IN (SELECT MAGV
FROM GV_DT
WHERE GV_DT.MAGV = GV1.MAGV)
GROUP BY BM1.MABM)

-- 2. Cho biết những giáo viên nào có tham gia tất cả các đề tài của giáo viên
-- "Trương Nam Sơn" làm chủ nhiệm đề tài
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
WHERE TG.MADT IN (SELECT DT1.MADT
FROM DETAI DT1 JOIN GIAOVIEN GV1 ON DT1.GVCNDT = GV1.MAGV
WHERE GV1.HOTEN = N'TRƯƠNG NAM SƠN')
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT TG.MADT) = (SELECT COUNT(DISTINCT MADT)
FROM DETAI DT2 JOIN GIAOVIEN GV2 ON DT2.GVCNDT = GV2.MAGV
WHERE GV2.HOTEN = N'TRƯƠNG NAM SƠN')

-- 3. Cho biết những giáo viên nào mà tất cả các đề tài mình tham gia đều có kinh phí trên 80 triệu
SELECT DISTINCT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
WHERE TG.MADT IN (SELECT MADT
FROM DETAI
WHERE KINHPHI > 80)

-- Cho biết mã đề tài, tên công việc của giáo viên tham gia từ 2 công việc trở lên
-- trong khoảng thời gian (Từ_Ngày, Đến_Ngày)
SELECT DISTINCT GV.MAGV, CV.MADT, CV.SOTT, CV.TENCV
FROM GIAOVIEN GV, THAMGIADT TG, CONGVIEC CV
WHERE GV.MAGV = TG.MAGV AND TG.MADT = CV.MADT AND TG.STT = CV.SOTT AND GV.MAGV = '003' AND (CV.NGAYBD BETWEEN '2000-1-1' AND '2020-1-1')
    AND (CV.NGAYKT BETWEEN '2000-1-1' AND '2020-1-1')
GROUP BY GV.MAGV , CV.MADT, CV.SOTT, CV.TENCV
HAVING COUNT(DISTINCT TG.MADT + TG.STT) >= 2

-- 4. Viết function fnLay_DSDeTai_GVThamGia với tham số vào (MaGV, Tu_Ngay, Den_Ngay) với nội dung:
-- Trả về các đề tài mà giáo viên có Mã GV tham gia từ 2 công việc trở lên trong khoảng thời gian (Từ_Ngày, Đến_Ngày)
GO
CREATE OR ALTER FUNCTION fnLay_DSDeTai_GVThamGia (@MAGV CHAR(5), @TUNGAY DATE, @DENNGAY DATE)
RETURNS TABLE
AS 
    RETURN (SELECT DISTINCT GV.MAGV, CV.MADT, CV.SOTT, CV.TENCV
FROM GIAOVIEN GV, THAMGIADT TG, CONGVIEC CV
WHERE GV.MAGV = TG.MAGV AND TG.MADT = CV.MADT AND TG.STT = CV.SOTT AND GV.MAGV = @MAGV AND (CV.NGAYBD BETWEEN @TUNGAY AND @DENNGAY)
    AND (CV.NGAYKT BETWEEN @TUNGAY AND @DENNGAY)
GROUP BY GV.MAGV , CV.MADT, CV.SOTT, CV.TENCV
HAVING COUNT(DISTINCT TG.MADT + TG.STT) >= 2)
GO

SELECT *
FROM DBO.fnLay_DSDeTai_GVThamGia('003', '2000-1-1' , '2020-1-1' )

-- 5. Viết stored procedure "spHienThi_DSCongViec_GVThamGia" với tham số vào (MaGV, Tu_Ngay, Den_Ngay) với nội dung sau
GO
CREATE PROCEDURE spHienThi_DSCongViec_GVThamGia
    @MAGV CHAR(5),
    @TUNGAY DATE,
    @DENNGAY DATE
AS
-- a) Kiểm tra giá trị đầu vào có hợp lệ không? Nếu không thì báo lỗi và kết thúc
--		MaGV phải tồn tại trong CSDL
IF (NOT EXISTS (SELECT *
FROM GIAOVIEN
WHERE MAGV = @MAGV))
    BEGIN
    RAISERROR(N'Mã giáo viên không tồn tại',16,1)
    RETURN
END
--		Tu_Ngay phải nhỏ hơn Den_Ngay
IF (@TUNGAY > @DENNGAY)
    BEGIN
    RAISERROR(N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc',16,1)
    RETURN
END
-- b) Sử dụng function fnLay_DSDeTai_GVThamGia để xác định số lượng đề tài
-- mà GV này tham gia thực hiện trong khoảng thời gian này
DECLARE @DSDeTai TABLE (MADT CHAR(5))
INSERT INTO @DSDeTai
SELECT *
FROM DBO.fnLay_DSDeTai_GVThamGia(@MAGV, @TUNGAY, @DENNGAY)

DECLARE @SOLUONG INT
SET @SOLUONG = (SELECT COUNT(*)
FROM @DSDeTai)

-- c) In thông báo số lượng đề tài thỏa yêu cầu. Nếu = 0 thì kết thúc
IF (@SOLUONG = 0)
    BEGIN
    PRINT N'Không có công việc nào thỏa yêu cầu'
    RETURN
END 
    ELSE 
        PRINT N'Số lượng đề tài mà giáo viên ' + @MAGV + ' tham gia trong khoảng thời gian từ ' + CONVERT(VARCHAR, @TUNGAY, 103) + ' đến ' + CONVERT(VARCHAR, @DENNGAY, 103) + ' là ' + CONVERT(VARCHAR, @SOLUONG)

-- d) Xuất ra tất cả các công việc của những đề tài được trả về từ function fnLay_DSDeTai_GVThamGia
SELECT *
FROM DBO.fnLay_DSDeTai_GVThamGia(@MAGV, @TUNGAY, @DENNGAY) TEST JOIN CONGVIEC CV ON TEST.MADT = CV.MADT


