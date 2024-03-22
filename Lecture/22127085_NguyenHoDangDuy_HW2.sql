USE QLDETAI 
GO 

-- 1. Xuất mã và họ tên giáo viên có tham gia đề tài do trưởng bộ môn của họ là chủ nhiệm.


-- 2. Xuất mã, họ tên, và tuổi của các giáo viên đã từng tham gia công việc thiết kế hoặc đã 
-- từng chủ nhiệm đề tài có công việc liên quan đến xác định yêu cầu. 


-- 3. Xuất mã và họ tên các trưởng khoa có tham gia đề tài thuộc chủ đề “nghiên cứu” nhưng 
-- chưa từng tham gia đề tài nào thuộc chủ đề “ứng dụng”. 


-- 4. Xuất mã, tên chủ đề, cấp quản lý (capql) và số lượng đề tài có kinh phí từ 100 triệu trở 
-- lên theo từng cấp quản lý của mỗi chủ đề. 


-- 5. Xuất mã, họ tên giáo viên, họ tên quản lý chuyên môn của giáo viên (nếu không có 
-- quản lý để ký hiệu “-”) của các giáo viên có tham gia đề tài được chủ nhiệm bởi giáo 
-- viên khác bộ môn. 


-- 6. Xuất mã, họ tên giáo viên và tổng số lượng giáo viên mà họ quản lý chuyên môn (nếu 
-- không quản lý ai, giá trị xuất ra là 0). 


-- 7. Xuất mã, họ tên giáo viên, tên khoa mà giáo viên thuộc về của các giáo viên từng chủ 
-- nhiệm trên 2 đề tài có kinh phí >= 100 triệu. 


-- 8. Xuất mã, tên đề tài, tên và STT công việc có đông giáo viên tham gia nhất. 


-- 9. Xuất mã và họ tên giáo viên có lương lớn nhất ở từng khoa theo các yêu cầu sau: 
-- • Cách 1: Có dùng lượng từ ALL hoặc hàm kết hợp MAX. 

-- • Cách 2: Không dùng bất cứ lượng từ hay hàm kết hợp nào. 


-- 10. Xuất mã và tên khoa có đông giáo viên từng chủ nhiệm đề tài nhất. 


-- 11. Xuất mã và tên bộ môn có nhiều giáo viên có quản lý chuyên môn nhất. 


-- 12. Xuất mã, họ tên giáo viên và tổng tiền phụ cấp mà giáo viên nhận được theo từng năm. 
-- Biết rằng tiền phụ cấp được tính từ hệ số phụ cấp cho các công việc mà giáo viên tham 
-- gia trong năm đó (có ngày kết thúc trong năm đang xét) với các quy định như sau: 
-- • Kết quả “Đạt”, Phụ cấp = Hệ số * Lương tháng. 
-- • Còn lại, Phụ cấp = Hệ số * (1/2 Lương tháng). 


-- 13. Xuất mã và họ tên giáo viên thuộc khoa “Công nghệ thông tin” có tham gia tất cả đề tài 
-- thuộc cấp ĐHQG. 


-- 14. Xuất mã, họ tên giáo viên thuộc bộ môn “Mạng máy tính” tham gia tất cả công việc 
-- liên quan đến đề tài thuộc chủ đề “ứng dụng”. 


-- 15. Xuất mã, họ tên trưởng khoa có các đề tài từng chủ nhiệm bao phủ tất cả các chủ đề. 


-- 16. Xuất mã, họ tên trưởng bộ môn có các đề tài từng tham gia liên quan đến tất cả các cấp. 


-- 17. Xuất mã, tên chủ đề có đề tài có tất cả giáo viên có mã tận cùng là số chẵn tham gia. 


-- 18. Xuất mã, tên đề tài, tên công việc có tất cả giáo viên có lương 2000-3000 tham gia.

