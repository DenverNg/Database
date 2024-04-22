/*MỞ RỘNG SỬ DỤNG CASE ... WHEN...*/
DECLARE @I INT 
SET @I = 12
SELECT CASE 
            WHEN @I%2=0 THEN N'SỐ CHẴN'
            ELSE N'SỐ LẺ'
       END

DECLARE @DTB FLOAT 
SET @DTB = 9
SELECT CASE 
            WHEN @DTB < 5 THEN N'RỚT'
            WHEN @DTB BETWEEN 5 AND 6.9 THEN N'TRUNG BÌNH KHÁ'
            WHEN @DTB BETWEEN 7 AND 7.9 THEN N'KHÁ'
            WHEN @DTB BETWEEN 8 AND 8.9 THEN N'GIỎI'
            ELSE N'XUẤT SẮC'
       END


DECLARE @PHAI CHAR
SET @PHAI = 'K'
SELECT CASE @PHAI 
            WHEN 'F' THEN N'NỮ'
            WHEN 'M' THEN N'NAM'
            ELSE '-'
       END AS N'GIỚI TÍNH'