USE QLDETAI
GO

-- Tìm đề tài có tất cả công việc đều 'đạt'
SELECT DISTINCT DT.MADT, DT.TENDT
FROM DETAI DT
WHERE DT.MADT IN (
    SELECT TG.MADT
FROM THAMGIADT TG
WHERE TG.KETQUA = N'Đạt'
)
GROUP BY DT.MADT, DT.TENDT

-- Tìm giáo viên tham gia tất cả đề tài thuộc chủ đề 'quản lý' (tên chứa cụm 'quản lý')
SELECT DISTINCT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV
    AND NOT EXISTS (
            (
        SELECT DT.MACD
        FROM DETAI DT
        WHERE DT.MADT = TG.MADT
        )
    EXCEPT
        (SELECT CD.MACD
        FROM CHUDE CD
        WHERE CD.TENCD LIKE N'%quản lý%')
)

-- Tìm bộ môn (mã, tên), trưởng bộ môn (mã, tên) của các bộ môn có giáo viên có các đề tài từng tham gia
-- bao phủ tất cả chủ đề

-- Tìm đề tài, chủ nhiệm đề tài có tất cả giáo viên có lương trên 2000 tham gia
SELECT DT.MADT, DT.TENDT, GV.MAGV, GV.HOTEN
FROM DETAI DT, GIAOVIEN GV, GIAOVIEN GV1, THAMGIADT TGDT
WHERE DT.GVCNDT = GV.MAGV AND TGDT.MADT = DT.MADT AND GV1.MAGV = TGDT.MAGV AND GV1.LUONG > 2000
GROUP BY DT.MADT, DT.TENDT, GV.MAGV, GV.HOTEN
HAVING COUNT(*) = (
    SELECT COUNT(*)
FROM GIAOVIEN GV
WHERE GV.LUONG > 2000
)
