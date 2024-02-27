USE  QLDETAI
GO

--Q1
SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
WHERE GV.PHAI = N'NỮ'

--Q2
SELECT GV.HOTEN, GV.LUONG*1.1 [LUONG TANG 10%]
FROM GIAOVIEN GV

--Q3 
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV, BOMON BM
WHERE (YEAR(BM.NGAYNHANCHUC) > 1995 AND BM.TRUONGBM=GV.MAGV) OR ((GV.HOTEN LIKE N'NGUYỄN %' AND GV.LUONG > 2000))
--Q4
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
    JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE K.TENKHOA = N'Công nghệ thông tin'

--Q5
SELECT *
FROM BOMON BM JOIN GIAOVIEN GV ON BM.TRUONGBM = GV.MAGV

--Q6. Với mỗi giáo viên, hãy cho biết thông tin bộ môn mà họ đang làm việc
SELECT GV.*, BM.*
FROM BOMON BM JOIN GIAOVIEN GV ON BM.MABM = GV.MABM

--Q7. Cho biết tên đề tài và giáo viên chủ nhiệm đề tài
SELECT DT.TENDT, GV.HOTEN
FROM DETAI DT JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV

--Q8. Với mỗi khoa, cho biết thông tin trường khoa
SELECT GV.*
FROM KHOA K JOIN GIAOVIEN GV ON GV.MAGV=K.TRUONGKHOA

--Q9. Cho biết các giáo viên của bộ môn "Vi sinh" có tham gia đề tài 006

--Q10. Với những đề tài thuộc cấp quản lý "Thành phố", cho biết mã đề tài,
-- đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng với ngày sinh và địa chỉ của người ấy


