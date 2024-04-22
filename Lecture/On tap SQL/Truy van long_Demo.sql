/*********************************************DEMO TOPIC 5: TRUY VẤN LỒNG **********************************************/
/*
- Định nghĩa: Sử dụng truy vấn con ở một mệnh đề nào đó trong truy vấn (Select, From, Where, ...)
- Cú pháp:
  Select col1, col2, (select ... from .. where) -- Truy vấn con ở Select
  From tab1, tab2, (select ...) as T -- Truy vấn con ở From
  Where tab2.luong > T.luong -- Truy vấn con ở Where 
  Group by ...
  Having avg(tab2.luong) >= ALL (...) -- Truy vấn con ở Having

  */

/* #1. Dùng toán tử so sánh 
     Select ... From
     Where ttA = (Select B from ...) 
     ==> Truy vấn con trả về 1 GIÁ TRỊ DUY NHẤT 
     cùng kiểu dữ liệu và ngữ nghĩa với ttA (1 dòng, 1 cột) */
select * from giaovien gv 
where gv.luong >  (select min(luong) from giaovien 
                  where magv='001' or magv='006')

/* #2. Dùng IN/NOT IN. 
     Select ... From
     Where ttA IN/NOT IN (Select B from ...) ttA IN (002, 004, 007)
     ==> Truy vấn con trả về 1 CỘT DUY NHẤT cùng kiểu dữ liệu và ngữ nghĩa với ttA
     ==> ttA IN (select B ...) <=> ttA = ANY (select B...)
    
    #3. Dùng toán tử so sánh kết hợp lượng từ ALL(với mọi), ANY/SOME (ít nhất một).
     Select ... From
     Where ttA >= ALL (Select B from ...) 
     ==> Truy vấn con trả về 1 CỘT DUY NHẤT cùng kiểu dữ liệu và ngữ nghĩa với ttA */
-- GV có lương lớn hơn ít nhất lương của 1 giáo viên bộ môn VS
select * from giaovien gv 
where gv.luong > ANY (select luong from giaovien 
                      where mabm='VS')

-- GV có lương lớn nhất

-- GV có lương lớn nhất khi mức lương của họ lớn hơn TẤT CẢ (ALL) mức lương

-- Tìm giáo viên có lương lớn nhất ở từng bộ môn

select gv.magv, gv.hoten, gv.luong, gv.mabm 
from giaovien gv 
where gv.luong >= ALL (select luong from giaovien gv2 where gv.mabm = gv2.mabm)

-- GV có lương lớn nhất khi mức lương = mức lương MAX
select * from giaovien gv 
where gv.luong = (select max(luong) from giaovien gv2 where gv.mabm = gv2.mabm)

-- GV có lương lớn nhất khi KHÔNG TỒN TẠI (NOT EXISTS) giáo viên có lương lớn hơn họ
select * from giaovien gv 
where not exists (select * from giaovien gv2 
                  where gv2.luong > gv.luong and gv.mabm = gv2.mabm)

-- Tìm giáo viên có lương lớn nhất ở từng bộ môn




-- Tìm giáo viên (tất cả) có tham gia đề tài.
select gv.* from giaovien gv
where gv.magv IN (select magv from thamgiadt) -- gv có mã NẰM TRONG (IN) các mã giáo viên có trong thamgiadt

select gv.*  from giaovien gv
where gv.magv = ANY (select magv from thamgiadt) -- gv có mã BẰNG BẤT KỲ (= ANY) một mã giáo viên nào có trong bảng thamgiadt

select gv.* from giaovien gv
where exists (select * from thamgiadt tg where tg.magv = gv.magv) -- TỒN TẠI ít nhất 1 dòng trong thamgiadt có mã giống với gv đang xét

select gv.* from giaovien gv
where (select distinct tg.magv from thamgiadt tg where tg.magv = gv.magv) >= 1 -- Tại sao cần phải có distinct???


-- Tìm giáo viên không có tham gia đề tài.
select gv.*  from giaovien gv
where gv.magv not IN (select magv from thamgiadt) -- gv.magv KHÔNG NẰM TRONG (NOT IN) danh sách mã tham gia

select gv.*  from giaovien gv
where gv.magv != ALL (select magv from thamgiadt) -- gv.magv KHÁC TẤT CẢ (!= ALL) các giá trị trong danh sách mã tham gia

select gv.* from giaovien gv 
where not exists (select * from thamgiadt tg where tg.magv = gv.magv) -- KHÔNG TỒN TẠI dòng nào trong thamgiadt có mã giống với gv đang xét 

select gv.* from giaovien gv
where (select distinct tg.magv from thamgiadt tg where tg.magv = gv.magv) = 0 -- Thảo luận: Kết quả trả ra???

-- Tìm giáo viên (magv, hoten) có lương lớn nhất.
-- LỒNG PHÂN CẤP (NONCORRELATED)
select * from giaovien where luong = (select max(luong) from giaovien)

-- Tìm giáo viên (magv, hoten) có lương lớn nhất của từng khoa.
-- Dùng toán tử so sánh: luong = max
-- LỒNG TƯƠNG QUAN (CORRELATED)
SELECT GV.MAGV, GV.HOTEN, BM.MAKHOA 
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM 
WHERE GV.LUONG = (SELECT MAX(GV2.LUONG) 
                  FROM GIAOVIEN GV2 JOIN BOMON BM2 
                                   ON GV2.MABM = BM2.MABM
                  WHERE BM2.MAKHOA = BM.MAKHOA) -- Chỉ lấy những giáo viên cùng khoa với gv đang xét 


-- Dùng lượng từ >= ALL
SELECT GV.MAGV, GV.HOTEN, BM.MAKHOA 
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM 
WHERE GV.LUONG >= ALL (SELECT GV2.LUONG
                       FROM GIAOVIEN GV2 JOIN BOMON BM2 ON GV2.MABM = BM2.MABM
                       WHERE BM2.MAKHOA = BM.MAKHOA) 

/* #4. Dùng EXISTS/NOT EXISTS (sub-query)
     Select ... From
     Where exists (Select * from ...) 
     ==> Kiểm tra truy vấn con có trả ra dữ liệu hay không nên KO QUAN TÂM SỐ CỘT trả về
          - Truy vấn con trả ra 0 dòng ==> mệnh đề exists là FALSE
          - Truy vấn con trả ra ít nhất 1 dòng ==> mệnh đề exists là TRUE */
-- Dùng kiểm tra tồn tại/không tồn tại: "Không tồn tại giáo viên cùng khoa có lương lớn hơn người đang xét".
-- ==> giáo viên có lương lớn nhất khoa.
SELECT GV.MAGV, GV.HOTEN, BM.MAKHOA 
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM 
WHERE NOT EXISTS (SELECT *
                  FROM GIAOVIEN GV2 JOIN BOMON BM2 ON GV2.MABM = BM2.MABM
                  WHERE BM2.MAKHOA = BM.MAKHOA AND GV2.LUONG > GV.LUONG) 


-- Tìm giáo viên (magv, hoten) tham gia nhiều đề tài nhất.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT TG.MADT) >= ALL (SELECT COUNT(DISTINCT TG2.MADT)
                                       FROM THAMGIADT TG2
                                       GROUP BY TG2.MAGV)

-- Tìm giáo viên (magv, hoten) tham gia nhiều đề tài nhất Ở TỪNG BỘ MÔN.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
GROUP BY GV.MAGV, GV.HOTEN, GV.MABM -- GV.MABM CẦN LIỆT KÊ TRONG GROUP BY VÌ ĐƯỢC SỬ DỤNG TRONG HAVING
HAVING COUNT(DISTINCT TG.MADT) >=  ALL (SELECT COUNT(DISTINCT TG2.MADT)
                                        FROM THAMGIADT TG2 JOIN GIAOVIEN GV2 ON GV2.MAGV = TG2.MAGV
                                        WHERE GV2.MABM = GV.MABM -- CÙNG BỘ MÔN NGƯỜI GV ĐANG XÉT
                                        GROUP BY TG2.MAGV)



/*********************************************DEMO TOPIC 6: PHÉP TOÁN TẬP HỢP ********************************************/
--VD2: Tìm giáo viên (magv, hoten) có lương lớn nhất.
-- KHÔNG SỬ DỤNG ALL HAY HÀM MAX
-- DÙNG PHÉP TOÁN TẬP HỢP: INTERSECT, UNION, EXCEPT
/* CÚ PHÁP:
SELECT A, B FROM ...
UNION
SELECT C, D FROM ...

SELECT A, B FROM ...
INTERSECT
SELECT C, D FROM ...

SELECT A, B FROM ...
EXCEPT
SELECT C, D FROM ...

*/
SELECT GV.* -- TẬP GIÁO VIÊN HIỆN CÓ
FROM GIAOVIEN GV 
EXCEPT 
SELECT DISTINCT GV1.* -- TẬP GIÁO VIÊN CÓ ÍT NHẤT 1 NGƯỜI CÓ LƯƠNG LỚN HƠN ==> GIÁO VIÊN KHÔNG CÓ LƯƠNG LỚN NHẤT
FROM GIAOVIEN GV1, GIAOVIEN GV2 
WHERE GV1.LUONG < GV2.LUONG


-- Cho biết đề tài có nhiều hơn 2 giáo viên không cùng bộ môn với chủ nhiệm tham gia.
SELECT DT.MADT, DT.TENDT, COUNT(DISTINCT TG.MAGV)
FROM DETAI DT JOIN THAMGIADT TG ON DT.MADT = TG.MADT
              JOIN GIAOVIEN GV ON GV.MAGV = TG.MAGV 
              JOIN GIAOVIEN CN ON DT.GVCNDT = CN.MAGV
WHERE GV.MABM != CN.MABM 
GROUP BY DT.MADT, DT.TENDT
HAVING COUNT(DISTINCT TG.MAGV) >= ALL (
                SELECT COUNT(DISTINCT TG.MAGV)
                FROM DETAI DT JOIN THAMGIADT TG ON DT.MADT = TG.MADT
                              JOIN GIAOVIEN GV ON GV.MAGV = TG.MAGV 
                              JOIN GIAOVIEN CN ON DT.GVCNDT = CN.MAGV
                WHERE GV.MABM != CN.MABM 
                GROUP BY DT.MADT, DT.TENDT)

-- TÊN KHOA, TÊN BỘ MÔN CÓ LƯƠNG TRUNG BÌNH 
-- CỦA CÁC GIÁO VIÊN TỪNG bộ môn LÀ CAO NHẤT
SELECT BM.MAKHOA, K.TENKHOA, BM.MABM, BM.TENBM, AVG(GV.LUONG) AS LUONGTB
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM 
                 JOIN KHOA K ON BM.MAKHOA = K.MAKHOA 
GROUP BY K.MAKHOA, K.TENKHOA, BM.MABM, BM.TENBM
HAVING AVG(GV.LUONG) >= ALL (SELECT AVG(GV2.LUONG) 
                         FROM GIAOVIEN GV2 JOIN BOMON BM2 ON GV2.MABM = BM2.MABM
                         GROUP BY BM2.MAKHOA, BM2.MABM
                         HAVING BM2.MAKHOA = K.MAKHOA)
ORDER BY BM.MAKHOA, BM.MABM


/*12.	Xuất mã, họ tên giáo viên và tổng tiền phụ cấp mà giáo viên nhận được theo từng năm. 
          Biết rằng tiền phụ cấp được tính từ hệ số phụ cấp cho các công việc mà giáo viên tham gia trong năm đó 
          (có ngày kết thúc trong năm đang xét) với các quy định như sau:
•	Kết quả “Đạt”, Phụ cấp = Hệ số * Lương tháng.
•	Còn lại, Phụ cấp = Hệ số * (1/2 Lương tháng).*/
select gv.magv, gv.hoten, isnull(year(T.NGAYKT), 0) as nam, isnull(sum(T.PHUCAP), 0) as sl_cv
from giaovien gv left join (select tg.magv, 
                                   tg.madt, tg.stt, tg.ketqua, 
                                   cv.ngaykt,
                                   case 
                                        when tg.ketqua = N'Đạt' then tg.phucap * gv.luong
                                        when tg.ketqua is null then 0
                                        else (tg.phucap * gv.luong)/2
                                   end as PHUCAP
                            from thamgiadt tg join congviec cv on cv.madt = tg.madt and tg.stt = cv.SOTT
                                              join giaovien gv on tg.magv = gv.magv) T on gv.magv = T.magv
-- giaovien gv left join T on gv.magv = T.magv
group by gv.magv, gv.hoten, year(T.ngaykt)
order by gv.magv, year(T.NGAYKT)

-- Thử dùng truy vấn lồng ở from cho biết
-- Danh sách giáo viên, số lượng thân nhân, số lượng đề tài họ tham gia
SELECT GV.*, GV_TN.SLNT, GV_TG.SLDT
FROM GIAOVIEN GV, (SELECT MAGV, COUNT(*) SLNT
                   FROM NGUOITHAN GROUP BY MAGV) GV_TN,
                  (SELECT MAGV, COUNT(DISTINCT MADT) SLDT
                   FROM THAMGIADT GROUP BY MAGV) GV_TG
WHERE GV.MAGV = GV_TN.MAGV AND GV.MAGV = GV_TG.MAGV