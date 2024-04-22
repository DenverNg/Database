
GIẢI QUYẾT BÀI TOÁN TÌM TẤT CẢ: "TÌM TẤT CẢ BỘ T TRONG R THOẢ MÃN TẤT CẢ S"
 - SỐ BỊ CHIA: R(X, Y)
 - SỐ CHIA: S(Y)
 - THƯƠNG: T(X)
 VD1: TÌM GIÁO VIÊN THAM GIA TẤT CẢ ĐỀ TÀI CÓ TÊN ĐỀ TÀI LIÊN QUAN ĐẾN NGHIÊN CỨU.
 VD2: TÌM GIÁO VIÊN THAM GIA TẤT CẢ CÔNG VIỆC CỦA ĐỀ TÀI 001.
 VD3: TÌM ĐỀ TÀI THUỘC CHỦ ĐỀ "NGHIÊN CỨU" CÓ TẤT CẢ TRƯỞNG BỘ MÔN THAM GIA.
 VD4: TÌM BỘ MÔN MÀ CÁC ĐỀ TÀI DO CÁC GIÁO VIÊN CỦA BỘ MÔN CHỦ NHIỆM BAO PHỦ TẤT CẢ CHỦ ĐỀ.


/*
CÁCH 1: SỬ DỤNG GROUP BY, HAVING CHO BÀI TOÁN PHÉP CHIA (TÌM T THOẢ TẤT CẢ S)
 - SỐ BỊ CHIA: R(X, Y)
 - SỐ CHIA: S(Y)
 - THƯƠNG: T(X)
SELECT R.X
FROM R
GROUP BY R.X ==> TRONG R ĐẾM XEM ỨNG VỚI MỖI BỘ T CÓ BAO NHIÊU BỘ S THOẢ MÃN
HAVING COUNT(R.Y) = (SELECT COUNT(S.Y) ==> ĐẾM TỔNG SỐ S CÓ
                     FROM S)
*/
VD1: TÌM GIÁO VIÊN THAM GIA TẤT CẢ ĐỀ TÀI 
        CÓ TÊN ĐỀ TÀI LIÊN QUAN ĐẾN NGHIÊN CỨU.
T: GIAOVIEN(MAGV)
S: DETAI(MADT) CÓ TENDT CÓ CHỨA "NGHIÊN CỨU"
R: THAMGIADT(MAGV, MADT)
*/
SELECT T.MAGV, T.HOTEN, COUNT(DISTINCT R.MADT) SLDT_NC
FROM THAMGIADT R JOIN GIAOVIEN T ON R.MAGV = T.MAGV
                 JOIN DETAI DT ON R.MADT = DT.MADT
WHERE DT.TENDT LIKE N'%NGHIÊN CỨU ab%'
GROUP BY T.MAGV, T.HOTEN -- ĐẾM SỐ ĐỀ TÀI "NGHIÊN CỨU" MỖI GIÁO VIÊN T THAM GIA
HAVING COUNT(DISTINCT R.MADT) = (SELECT COUNT(S.MADT) -- ĐẾM TỔNG SỐ BỘ ĐỀ TÀI NGHIÊN CỨU CÓ
                                 FROM DETAI S
                                 WHERE S.TENDT LIKE N'%NGHIÊN CỨU ab%')


-- THÊM DỮ LIỆU TEST THỬ CHO PHÉP CHIA
INSERT INTO CONGVIEC(MADT, SOTT, TENCV) VALUES ('003', 1, N'Khảo sát')
INSERT INTO THAMGIADT VALUES ('004', '003', 1, 2, NULL) 


/*
CÁCH 2: SỬ DỤNG PHÉP TRỪ EXCEPT
 - SỐ BỊ CHIA: R(X, Y)
 - SỐ CHIA: S(Y)
 - THƯƠNG: T(X)
SELECT T.X
FROM T
/* TÌM S KHÔNG THOẢ T: NẾU TRUY VẤN CON RA RỖNG (NOT EXISTS TRẢ RA TRUE): T LÀ KẾT QUẢ PHÉP CHIA CẦN TÌM 
                                                    ==> KHÔNG CÓ S KHÔNG THOẢ T ==> T THOẢ TẤT CẢ S
                       NÊU TRUY VẤN CON RA ÍT NHẤT 1 DÒNG (NOT EXISTS RA FALSE): T KHÔNG PHẢI KẾT QUẢ PHÉP CHIA CẦN TÌM 
                                                    ==> CÓ ÍT NHẤT 1 S KHÔNG THOẢ T ==> T KHÔNG THOẢ TẤT CẢ */
WHERE NOT EXISTS (SELECT S.Y -- LẤY TẤT CẢ Y CÓ
                  FROM S 
                  EXCEPT
                  SELECT R.Y -- LẤY CÁC BỘ Y THOẢ T.X Ở TRUY VẤN CHA
                  FROM R
                  WHERE R.X = T.X
                
) */

SELECT T.MAGV, T.HOTEN
FROM GIAOVIEN T
WHERE NOT EXISTS (SELECT S.MADT -- LẤY TẤT CẢ MÃ ĐỀ TÀI CỦA ĐỀ TÀI CÓ TÊN CHỨA "NGHIÊN CỨU"
                  FROM DETAI S WHERE S.TENDT LIKE N'%NGHIÊN CỨU ab%'
                  EXCEPT
                  SELECT R.MADT -- LẤY CÁC MÃ ĐỀ TÀI T THAM GIA
                  FROM THAMGIADT R
                  WHERE R.MAGV = T.MAGV) -- TRUY VẤN CON TRẢ RA MÃ ĐỀ TÀI T KHÔNG THAM GIA
      AND EXISTS (SELECT * FROM DETAI S WHERE S.TENDT LIKE N'%NGHIÊN CỨU ab%') -- KIỂM TRA S KHÁC RỖNG VÌ S RỖNG RA TOÀN BỘ GIÁO VIÊN


/*LUYỆN TẬP:
1. CHO DANH SÁCH GIÁO VIÊN THAM GIA TẤT CẢ ĐỀ TÀI 
   DO TRƯỞNG BỘ MÔN HỌ LÀM CHỦ NHIỆM.

T: GIAOVIEN GV (GV.MAGV)
S: DETAI DT (DT.MADT), DT DO TRƯỞNG BỘ MÔN CỦA GV LÀ CHỦ NHIỆM
R: THAMGIADT (MAGV, MADT)
--DÙNG NOT EXIST ... EXCEPT
SELECT 
FROM GV
WHERE NOT EXISTS(--LẤY RA MÃ ĐỀ TÀI TRƯỞNG BỘ MÔN GV LÀ CHỦ NHIỆM
                 EXCEPT -- TRỪ ĐI
                 --LẤY RA MÃ ĐỀ TÀI GV CÓ THAM GIA)

--DÙNG GROUP BY HAVING
SELECT
FROM GV, TG
WHERE ...
GROUP BY GV.MAGV 
-- ỨNG VỚI MỖI GV ĐẾN SỐ ĐỀ TÀI DO TRƯỞNG BỘ MÔN GV LÀ CHỦ NHIỆM MÀ GV THAM GIA
HAVING COUNT(DISTINCT TG.MADT) = (--TỔNG SỐ ĐỀ TÀI DO TRBM GV LÀ CHỦ NHIỆM
                                    SELECT ...
                                    FROM DETAI DT
                                    WHERE DT.GVCNDT = TRBM.MAGV -- LẤY TỪ CHA
)

2. CHO ĐỀ TÀI DO GIÁO VIÊN KHOA CNTT 
LÀM CHỦ NHIỆM CÓ TẤT CẢ GIÁO VIÊN CỦA KHOA THAM GIA.

3. CHO GIÁO VIÊN MÀ 
TẤT CẢ CÔNG VIỆC THAM GIA ĐỀU "ĐẠT" 
--> LƯU Ý: KHÔNG PHẢI CÁC TRUY VẤN CÓ LƯỢNG TỪ TẤT CẢ ĐỀU SỬ DỤNG PHÉP CHIA
*/
SELECT * FROM GIAOVIEN GV 
WHERE NOT EXISTS (SELECT * FROM THAMGIADT TG
                  WHERE TG.MAGV = GV.MAGV AND TG.KETQUA != N'ĐẠT')

/*MỞ RỘNG