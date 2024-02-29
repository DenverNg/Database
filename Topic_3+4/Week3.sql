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
SELECT DISTINCT GV.*
FROM GIAOVIEN GV, THAMGIADT TG, BOMON BM
WHERE GV.MABM = BM.MABM AND BM.TENBM = N'Vi sinh' AND TG.MAGV = GV.MAGV AND TG.MADT = '006'

--Q10. Với những đề tài thuộc cấp quản lý "Thành phố", cho biết mã đề tài,
-- đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng với ngày sinh và địa chỉ của người ấy
SELECT DT.MADT, CD.TENCD, GV.HOTEN, GV.NGSINH, GV.DIACHI
FROM DETAI DT JOIN CHUDE CD ON DT.MACD = CD.MACD
    JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
WHERE DT.CAPQL = N'Thành phố'

--Q11. Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
SELECT GV.HOTEN, QL.*
FROM GIAOVIEN GV JOIN GIAOVIEN QL ON GV.GVQLCM = QL.MAGV

--Q12. Tìm họ tên của những giáo viên được "Nguyễn Thanh Tùng" phụ trách trực tiếp
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN GIAOVIEN QL ON GV.GVQLCM = QL.MAGV
WHERE QL.HOTEN = N'Nguyễn Thanh Tùng'

--Q13. Cho biết tên giáo viên là trưởng bộ môn "Hệ thống thông tin"
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
WHERE BM.TENBM = N'Hệ thống thông tin'

--Q14. Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
    JOIN CHUDE CD ON DT.MACD = CD.MACD
WHERE CD.TENCD = N'Quản lý giáo dục'

--Q15. Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt 
-- đầu trong tháng 3/2008
SELECT CV.TENCV
FROM DETAI DT JOIN CONGVIEC CV ON DT.MADT = CV.MADT
WHERE DT.TENDT = N'HTTT quản lý các trường ĐH' AND ( CV.NGAYBD BETWEEN '03/01/2008' AND '03/31/2008')

--Q16. Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó
SELECT GV.HOTEN, QL.HOTEN
FROM GIAOVIEN GV JOIN GIAOVIEN QL ON GV.GVQLCM = QL.MAGV

--Q17. Cho các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007
SELECT CV.*
FROM CONGVIEC CV
WHERE CV.NGAYBD BETWEEN '01/01/2007' AND '08/01/2007'

--Q18. Cho biết họ tên các giáo viên cùng bộ môn với giáo viên "Trần Trà Hương"
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN GIAOVIEN GV1 ON GV.MABM = GV1.MABM
WHERE GV1.HOTEN = N'Trần Trà Hương' AND GV.HOTEN != N'Trần Trà Hương'

--Q19. Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài
SELECT DISTINCT GV.*
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
    JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

--Q20. Cho biết tên những giáo viên vừa là trưởng khoa và vừa là trưởng bộ môn
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
    JOIN KHOA K ON GV.MAGV = K.TRUONGKHOA

--Q21. Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
    JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

--Q22. Cho biết mã số các trưởng khoa có chủ nhiệm đề tài
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV JOIN KHOA K ON K.TRUONGKHOA=GV.MAGV
    JOIN DETAI DT ON GV.MAGV = DT.GVCNDT

--Q23. Cho biết mã số các giáo viên thuộc bộ môn "HTTT" hoặc có tham gia đề tài mã "001"
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
WHERE GV.MABM = N'HTTT' OR TG.MADT = '001'

--Q24. Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002
SELECT GV.*
FROM GIAOVIEN GV JOIN GIAOVIEN GV1 ON GV.MABM = GV1.MABM
WHERE GV1.MAGV = '002' AND GV.MAGV != '002'

--Q25. Tìm những giáo viên là trưởng bộ môn
SELECT GV.*
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM

--Q26. Cho biết họ tên và mức lương của các giáo viên
SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV

--Q27. Cho biết số lượng giáo viên và tổng lương của 
SELECT COUNT(GV.MAGV) SOGV, SUM(GV.LUONG) TONGLUONG
FROM GIAOVIEN GV

--Q28. Cho biết số lượng giáo viên và lương trung bình của từng bộ môn
SELECT BM.TENBM, COUNT(GV.MAGV) SOGV, AVG(GV.LUONG) LUONGTB
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
GROUP BY BM.MABM, BM.TENBM

--Q29. Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó
SELECT CD.TENCD, COUNT(DT.MADT) SOLUONGDT
FROM CHUDE CD JOIN DETAI DT ON CD.MACD = DT.MACD
GROUP BY CD.TENCD, CD.MACD

--Q30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia.
SELECT GV.HOTEN, COUNT(DISTINCT TG.MADT) SOLUONGDT
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
GROUP BY GV.MAGV, GV.HOTEN

--Q31. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm
SELECT GV.HOTEN, COUNT(DT.MADT) SODTCN
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
GROUP BY GV.MAGV, GV.HOTEN

--Q32. Với mỗi giáo viên cho biết tên giáo viên và số người thân của giáo viên đó
SELECT GV.HOTEN, COUNT(NT.MAGV) SONGUOITHAN
FROM GIAOVIEN GV JOIN NGUOITHAN NT ON GV.MAGV = NT.MAGV
GROUP BY GV.MAGV, GV.HOTEN

--Q33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên
SELECT GV.HOTEN
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT TG.MADT) >= 3

--Q34. Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh
SELECT COUNT(DISTINCT TG.MAGV) SOGV
FROM THAMGIADT TG JOIN DETAI DT ON TG.MADT = DT.MADT
WHERE DT.TENDT = N'Ứng dụng hóa học xanh'