/*---------------------------------------------TRUY VẤN ĐƠN GIẢN------------------------------------
Cấu trúc chung: 
    SELECT COLUMN1, COLUMN2, ...
    FROM TABLE1, TABLE2, ..
    WHERE <Dieu kien>
    ORDER BY ...

THỨ TỰ XỬ LÝ: FROM --> WHERE --> ORDER BY --> SELECT

SỬ DỤNG ALIAS (ĐẶT LẠI TÊN) CHO CỘT VÀ BẢNG
    SELECT COLUMN1 [AS] CLM
    FROM TABLE1 [AS] TBL
--------------------------------------------------------------------------------------------------*/
--TRUY VẤN TRÊN 1 BẢNG ĐIỀU KIỆN ĐƠN GIẢN
--VD0: Cho biết mã, họ tên và lương tất cả giáo viên
select MAGV, HOTEN, LUONG
from GIAOVIEN

--VD1: Cho biết mã, họ tên và lương giáo viên HTTT.
select MAGV, HOTEN, LUONG
from GIAOVIEN
where MABM = 'HTTT' -- <> !=

--VD2: Cho biết thông tin (toàn bộ) giáo viên HTTT.
select * --Dấu * cho phép lấy toàn bộ cột thuộc tính của bảng
from GIAOVIEN
where MABM = 'HTTT'
--So sánh: =, != (<>), >=, <=, ...
--TRUY VẤN VỚI ĐIỀU KIỆN LIÊN QUAN ĐẾN CHUỖI KÝ TỰ: LIKE, %, _ [ABC]% [TH]__
--VD3: Cho biết mã, họ tên và lương giáo viên Nguyễn Hoài An
select MAGV, HOTEN, LUONG
from GIAOVIEN
where HOTEN = N'Nguyễn Hoài An'

--VD4: Cho biết mã, họ tên và lương giáo viên họ Nguyễn
select MAGV, HOTEN, LUONG
from GIAOVIEN
where HOTEN like N'Nguyễn%'
--GHI CHÚ: KHÔNG BIẾT CHÍNH XÁC TOÀN BỘ CHUỖI SO SÁNH PHẢI DÙNG LIKE/NOT LIKE

--VD5: Cho biết mã, họ tên và lương giáo viên tên kết thúc là nh
select MAGV, HOTEN, LUONG
from GIAOVIEN
where HOTEN like N'[NH]%'

--VD6: Cho biết mã, họ tên và lương giáo viên tên có 5 ký tự kết thúc là nh
select MAGV, HOTEN, LUONG
from GIAOVIEN
where HOTEN like N'% ___nh'

--TRUY VẤN VỚI ĐIỀU KIỆN LIÊN QUAN ĐẾN NGÀY THÁNG (DATE, DATETIME): 
--GETDATE(), DAY(d), MONTH(d), YEAR(d)
--DATEDIFF(yy|mm|dd, d1, d2), 
--DATEPART(yy|mm|dd, d)
select day(getdate()), datepart(dd, getdate())
--MẶC ĐỊNH :MM/DD/YYYY
SET DAteformat Dmy

select datediff(dd, '01/19/2022', getdate())

--VD7: Cho biết mã, họ tên và tuổi các giáo viên
--Cách 1: năm hiện hành - năm sinh
select MAGV N'Mã giáo viên', HOTEN N'Họ tên', 
       year(getdate()) - year(NGSINH) as TUOI, 
       datediff(yy, NGSINH, GETDATE()) TUOI
from GIAOVIEN

--VD7BIS: Cho biết mã, họ tên và tuổi các giáo viên trên 50 tuổi


--TRUY VẤN VỚI ĐIỀU KIỆN TRÊN DỮ LIỆU NULL/NOT NULL: IS NULL / IS NOT NULL
--VD8: Cho biết mã, họ tên các giáo viên có người quản lý
select * from GIAOVIEN where GVQLCM is not null 

--VD9: Cho biết mã, họ tên các giáo viên KHÔNG có người quản lý
select magv, hoten, isnull(gvqlcm,'-') ql
from GIAOVIEN where GVQLCM is null 

select distinct gvqlcm --distinct: loại trùng
from GIAOVIEN 
where GVQLCM is not null 
order by gvqlcm desc --order by: sắp xếp: asc: mặc định tăng, desc: giảm

select magv, hoten, luong, year(ngsinh) namsinh
from giaovien 
order by luong, year(ngsinh) desc

select magv, hoten, luong, year(ngsinh) namsinh
from giaovien 
order by year(ngsinh) desc, luong asc

--Sử dụng hàm isnull(cotA, gia_triX) bien các giá trị null trong cột A thành gia_triX
select magv, hoten, isnull(gvqlcm, 'X') from GIAOVIEN

--TRUY VẤN VỚI ĐIỀU KIỆN SỬ DỤNG TOÁN TỬ LOGIC AND/OR
--VD10: Cho biết mã, họ tên các giáo viên KHÔNG có người quản lý hoặc thuộc bộ môn VS
select magv, hoten, gvqlcm from GIAOVIEN 
where (GVQLCM is null) OR (MABM = 'VS')

--TRUY VẤN VỚI ĐIỀU KIỆN SỬ DỤNG IN/NOT IN, BETWEEN/NOT BETWEEN ... AND ...

--VD11: Cho biết mã, họ tên các giáo viên nữ có lương từ 2000 đến 3000
select magv, hoten from GIAOVIEN 
where luong between 2000 and 3000 --luong >= 2000 and luong <=3000

--VD12: Cho biết mã, họ tên các giáo viên sinh năm 1973, 1975, hoặc 1980
select magv, hoten from GIAOVIEN 
where year(NGSINH) in (1973, 1975, 1980) 
--year(NGSINH) = 1973 OR year(NGSINH) = 1975 or year(ngsinh) = 1980

--SẮP XẾP KẾT QUẢ TRẢ RA: ORDER BY ColumnA, ColumnB ASC, ColumnC DESC
select magv, hoten, luong, ngsinh from GIAOVIEN 
order by luong desc, year(ngsinh) asc

--ĐIỀU KIỆN TRÊN MỆNH ĐỀ SELECT: DISTINCT, TOP N, TOP N PERCENT, DÙNG HÀM HOẶC TÍNH TOÁN TRÊN CỘT
--VD13: Cho biết mã các giáo viên có tham gia đề tài 
SELECT DISTINCT magv --distinct dùng loại trùng
from THAMGIADT
order by magv

select top 3 * from GIAOVIEN --Lấy 3 dòng đầu tiên của bảng giáo viên
select top 3 percent * from GIAOVIEN --Lấy 3% số dòng đầu tiên của bảng giáo viên

--VD14: Cho biết 3 mức lương cao nhất
select distinct top 3 luong 
from GIAOVIEN
ORDER by luong desc


--VD15: Cho biết 25% mức lương cao nhất
select distinct top 25 percent luong 
from GIAOVIEN
ORDER by luong desc

--VD16: Cho biết mã, tên, mức lương và mức phụ cấp của các giáo viên biết phụ cấp bằng 25% tiền lương


--TRUY VẤN TRÊN NHIỀU BẢNG SỬ DỤNG PHÉP TÍCH DESCARTES BangA, BangB
/* Select *
From BangA, BangB --Tích descartes
Where <Đk_chọn>*/

--VD17: Cho biết thông tin bộ môn, và tên khoa mà bộ môn thuộc về
--Cần 2 bảng: BOMON, KHOA
Select bm.MABM, bm.TENBM, bm.MAKHOA, k.TENKHOA 
From BOMON as bm, KHOA k --Tích descartes

order by bm.MABM

--Cách 1: Điều kiện kết ở where
Select bm.MABM, bm.TENBM, bm.MAKHOA, k.TENKHOA 
From BOMON bm, KHOA k --Tích descartes
Where bm.makhoa = k.makhoa --Lọc kết quả của phép tích
order by bm.MABM

--Cách 2: Kết trên điều kiện c. Cú pháp: From A join B on c
Select bm.MABM, bm.TENBM, bm.MAKHOA, k.TENKHOA 
From BOMON bm join KHOA k on bm.makhoa = k.makhoa --Kết theo điều kiện
order by bm.MABM

-- Lấy toàn bộ thông tin đề tài và các công việc liên quan đã có người tham gia
select dt.*, cv.TENCV
from detai dt, congviec cv, thamgiadt tg 
where (dt.MADT = cv.MADT) and (cv.MADT = tg.MADT and cv.SOTT = tg.STT)

select dt.*, cv.TENCV
from detai dt join congviec cv on dt.MADT = cv.MADT
              join thamgiadt tg on cv.MADT = tg.MADT and cv.SOTT = tg.STT

-- Cho biết mã đề tài, tên đề tài, tên công việc 
-- có giáo viên '001' tham gia
select tg.MADT, dt.TENDT, cv.TENCV
from THAMGIADT tg, CONGVIEC cv, DETAI dt 
where (tg.MADT = cv.MADT and tg.STT = cv.SOTT) and 
      (cv.MADT = dt.MADT)and
      (tg.magv = '001')

select tg.MADT, dt.TENDT, cv.TENCV
from THAMGIADT tg join CONGVIEC cv on (tg.MADT = cv.MADT and tg.STT = cv.SOTT)
                  join DETAI dt on (cv.MADT = dt.MADT)
where (tg.magv = '001')


--Cách 2: Điều kiện kết ở from
Select bm.*, k.TENKHOA 
From BOMON bm join KHOA k on bm.makhoa = k.makhoa --Phép kết
--BangA tham chiếu khoá ngoại đến BangB
--Điều kiện kết tổng quát của BangA và BangB: BangA.Khoangoai = BangB.Khoachinh
--Ví dụ: Điều kiện kết giữa ThamGiaDT tg và CongViec cv:
select * from THAMGIADT tg join congviec cv on tg.madt = cv.madt and tg.stt = cv.SOTT

--VD18: Tìm mã, họ tên giáo viên có tham gia đề tài có công việc liên quan đến 
--"thiết kế" hoặc công việc bắt đầu trong năm (2000, 2008, hoặc 2009).
--Bảng: Giaovien, thamgiadt, congviec
select distinct gv.MAGV, gv.HOTEN
from GIAOVIEN gv join THAMGIADT tg on gv.MAGV = tg.MAGV
                 join CONGVIEC cv on tg.madt = cv.madt and tg.stt = cv.SOTT
where (cv.TENCV like N'%thiết kế%') OR 
      (YEAR(cv.NGAYBD) in (2000, 2008, 2009))

--VD19: Tìm mã, họ tên, tuổi giáo viên có tham gia đề tài
--do trưởng bộ môn làm chủ nhiệm. Xuất thêm họ tên giáo viên chủ nhiệm đề tài.
    --Mã, tên giáo viên, tuổi --> Giaovien
    --Tham gia --> Thamgiadt
    --Chủ nhiệm dt --> DeTai
    --Chủ nhiệm la truong bm --> Bomon
select distinct gv.MAGV, gv.HOTEN, 
                datediff(yy, gv.NGSINH, getdate()) as TUOIGV,
                cndt.HOTEN
from GIAOVIEN gv join THAMGIADT tg on gv.MAGV = tg.MAGV
                 join DETAI dt on dt.MADT = tg.MADT
                 join GIAOVIEN cndt on cndt.magv = dt.GVCNDT
                 join BOMON bm on dt.GVCNDT = bm.TRUONGBM

--VD19b: Tìm mã, họ tên, tuổi, họ tên quản lý chuyên môn
--của các giáo viên có tham gia đề tài
--do trưởng bộ môn làm chủ nhiệm. 
--Xuất thêm họ tên giáo viên chủ nhiệm đề tài 
select distinct gv.MAGV, gv.HOTEN, 
                datediff(yy, gv.NGSINH, getdate()) as TUOIGV,
                cndt.HOTEN as ChuNhiemDT, isnull(qlcm.HOTEN, '--') as QLChuyenMon 
from GIAOVIEN gv join THAMGIADT tg on gv.MAGV = tg.MAGV
                 join DETAI dt on dt.MADT = tg.MADT
                 join GIAOVIEN cndt on cndt.magv = dt.GVCNDT
                 join BOMON bm on dt.GVCNDT = bm.TRUONGBM
                 left join GIAOVIEN qlcm on gv.GVQLCM = qlcm.MAGV

SELECT * from GIAOVIEN

--VD20: Tìm mã và tên chủ đề của các đề tài có trưởng khoa tham gia.
select distinct cd.MACD, cd.TENCD
from CHUDE cd join DETAI dt on cd.MACD = dt.MACD
              join THAMGIADT tg on tg.MADT = dt.MADT
              join KHOA k on tg.MAGV = k.TRUONGKHOA

--VD21: Cho biết mã, tên giáo viên, tên khoa mà giáo viên thuộc về

--VD22: SỐ LƯỢNG ĐỀ TÀI 001 THAM GIA
SELECT MAGV, COUNT(DISTINCT MADT) AS SLDT
FROM THAMGIADT
HAVING MAGV = '001'


/*-----------------------------------KẾT MỞ RỘNG, TẬP HỢP-----------------------------------------
KẾT MỞ RỘNG: GIỮ LẠI CÁC DÒNG DỮ LIỆU KHÔNG THOẢ ĐK KẾT CỦA BẢNG TRÁI/PHẢI/CẢ HAI
    SELECT ...
    FROM R LEFT|RIGHT|FULL JOIN S ON DK_KET

TRUY VẤN TẬP HỢP: UNION (HỘI), INTERSECT (GIAO), EXCEPT (TRỪ)
    SELECT A, B ...
    UNION|INTERSECTION|EXCEPT
    SELECT C, D ...
    
ĐIỀU KIỆN: SỐ LƯỢNG CỘT TRẢ RA Ở CÂU TRUY VẤN TRƯỚC VÀ SAU UNION|INTERSECT|EXCEPT PHẢI = NHAU VÀ
LẦN LƯỢT TƯƠNG ĐỒNG KIỂU DỮ LIỆU
--------------------------------------------------------------------------------------------------*/
--Thảo luận: Nhận xét phép kết cho bảng bên dưới
--VD23: Xuất danh sách giáo viên cùng tên giáo viên quản lý chuyên môn của họ (nếu có)
-- KẾT MỞ RỘNG: LEFT, RIGHT, FULL JOIN ...
SELECT GV.MAGV, GV.HOTEN, ISNULL(GV.GVQLCM, '-') AS QL, QL.HOTEN
FROM GIAOVIEN GV LEFT JOIN GIAOVIEN QL ON GV.GVQLCM = QL.MAGV
ORDER BY GV.MAGV


--TRUY VẤN TẬP HỢP: INTERSECT, UNION, EXCEPT
--VD24: Cho mã và tên giáo viên hoặc là trưởng bộ môn hoặc có tham gia đề tài
select gv.MAGV, gv.HOTEN
from giaovien gv JOIN BOMON bm on gv.magv = bm.truongbm
UNION
select distinct gv.MAGV, gv.HOTEN
from giaovien gv JOIN THAMGIADT tg on gv.magv = tg.MAGV

--VD25: Cho mã và tên các trưởng bộ môn có tham gia đề tài
select gv.MAGV, gv.HOTEN
from giaovien gv JOIN BOMON bm on gv.magv = bm.truongbm
INTERSECT
select distinct gv.MAGV, gv.HOTEN
from giaovien gv JOIN THAMGIADT tg on gv.magv = tg.MAGV

/*-----------------------------------GOM NHÓM VÀ HÀM KẾT HỢP-----------------------------------------
SELECT ... FROM ...
WHERE <ĐIỀU KIỆN TRÊN DÒNG>
GROUP BY TTA, TTB
HAVING <ĐIỀU KIỆN TRÊN NHÓM>
ORDER BY ...

THUỘC TÍNH SỬ DỤNG Ở CÁC MỆNH ĐỀ SAU GROUP BY NHƯ HAVING, ORDER BY, SELECT PHẢI:
    - LỒNG TRONG HÀM KẾT HỢP
    - HOẶC, ĐƯỢC LIỆT KÊ TRONG GROUP BY
--------------------------------------------------------------------------------------------------*/
--ĐẾM SỐ LƯỢNG ĐỀ TÀI GIÁO VIÊN '001' THAM GIA
SELECT MAGV, COUNT(DISTINCT MADT) FROM THAMGIADT 
WHERE MAGV = '001'

SELECT MAGV, COUNT(DISTINCT MADT) FROM THAMGIADT 
GROUP BY MAGV
HAVING MAGV = '001'

--ĐẾM SỐ LƯỢNG GIÁO VIÊN CỦA TỪNG BỘ MÔN, THEO GIỚI TÍNH
SELECT GV.MABM, BM.TENBM, GV.PHAI, COUNT(MAGV) AS SLGV
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM 
--WHERE: LỌC TRÊN DÒNG
GROUP BY GV.MABM, GV.PHAI, BM.TENBM
--HAVING: LỌC TRÊN NHÓM
ORDER BY BM.MABM


--ĐẾM SỐ LƯỢNG ĐỀ TÀI TỪNG GIÁO VIÊN THAM GIA, XUẤT MÃ GV VÀ SỐ LƯỢNG
SELECT MAGV, COUNT(DISTINCT MADT) AS SLDT
FROM THAMGIADT  
GROUP BY MAGV

--CHO BIẾT MÃ, HỌ TÊN GIÁO VIÊN, MÃ ĐỀ TÀI VÀ SỐ LƯỢNG CÔNG VIỆC CỦA TỪNG ĐỀ TÀI GV THAMGIA
SELECT GV.MAGV, GV.HOTEN, MADT, COUNT(STT) AS SLCV
FROM THAMGIADT TG JOIN GIAOVIEN GV ON TG.MAGV = GV.MAGV  
GROUP BY GV.MAGV, MADT, GV.HOTEN

--ĐẾM SỐ LƯỢNG GIÁO VIÊN BỘ MÔN HTTT
SELECT MABM, COUNT(*) SLGV_HTTT
FROM GIAOVIEN
GROUP BY MABM
HAVING MABM = 'HTTT'

SELECT MABM, COUNT(*) SLGV_HTTT
FROM GIAOVIEN
WHERE MABM = 'HTTT'

--Cho biết mã, tên đề tài và số lượng trưởng bộ môn tham gia đề tài.
/*madt  |   tendt       |  soluong (truongbm)
001     | ...           |  3
002     | ...           |  1
*/
SELECT dt.MADT, dt.tendt, count(distinct tg.MAGV) as slgv
from DETAI dt join THAMGIADT tg on dt.MADT = tg.MADT
              join BOMON bm on bm.TRUONGBM = tg.MAGV
GROUP by dt.MADT, dt.tendt

--Cho biết mã, tên giáo viên và số lượng đề tài giáo viên tham gia 
--theo từng cấp quản lý.
/*magv    |   hoten       |   capql  | soluong
001     | nguyen van a  | nha nuoc | 3
001     | nguyen van a  | DHQG     | 1
*/
SELECT gv.MAGV, gv.HOTEN, dt.capql, count(distinct tg.MADT) as SLDT
from DETAI dt join THAMGIADT tg on dt.MADT = tg.MADT
              join GIAOVIEN gv on gv.MAGV = tg.MAGV
GROUP by gv.MAGV, gv.HOTEN, dt.CAPQL
order by gv.MAGV


