USE QLDETAI 
GO

-- Q58. Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề
--COUNT
SELECT GV.HOTEN, COUNT(DISTINCT DT.MACD), COUNT(DT.MACD)
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
    JOIN DETAI DT ON TG.MADT = DT.MADT
GROUP BY GV.HOTEN, GV.MAGV
HAVING COUNT(DISTINCT DT.MACD) = (SELECT COUNT(*) FROM CHUDE)

-- Q60. Cho biết tên đề tài có tất cả giảng viên bộ môn "Hệ thống thông tin" tham gia
--COUNT
SELECT DT.TENDT 
FROM DETAI DT JOIN THAMGIADT TG ON DT.MADT = TG.MADT
GROUP BY DT.TENDT, DT.MADT
HAVING COUNT(DISTINCT TG.MAGV) = (SELECT COUNT(GV.MAGV) 
FROM GIAOVIEN GV
WHERE GV.MABM = (SELECT MABM FROM BOMON WHERE TENBM = N'Hệ thống thông tin'))

-- Q62. Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
WHERE TG.MADT IN (SELECT TG1.MADT FROM THAMGIADT TG1 JOIN GIAOVIEN GV1 ON TG1.MAGV = GV1.MAGV 
WHERE GV1.HOTEN = N'Trần Trà Hương' AND GV.HOTEN != N'Trần Trà Hương')
GROUP BY GV.HOTEN, GV.MAGV
HAVING COUNT(DISTINCT TG.MADT) = (SELECT COUNT(DISTINCT TG2.MADT)
FROM GIAOVIEN GV2 JOIN THAMGIADT TG2 ON TG2.MAGV = GV2.MAGV
WHERE GV2.HOTEN = N'Trần Trà Hương')

-- Q64. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006

-- Q66. Cho biết tên giáo viên nào đã tham gia tất cả các đề tài do Trần Trà Hương làm chủ nhiệm