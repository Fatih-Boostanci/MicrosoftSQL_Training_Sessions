/*

SELECT
FROM
WHERE
ORDER BY
TOP(instead of LIMIT)
*/

SELECT *
FROM product.brand
ORDER BY brand_name;

SELECT *
FROM product.brand
ORDER BY brand_name DESC;

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_id DESC

--WHERE

SELECT * 
FROM product.brand
WHERE brand_name LIKE 'S%';

SELECT *
FROM product.product
ORDER BY brand_id;

SELECT *
FROM product.product
WHERE model_year 
BETWEEN 2019 AND 2021;

SELECT TOP 3 *
FROM product.product
WHERE model_year 
BETWEEN 2019 AND 2021
ORDER BY model_year DESC;

---

SELECT *
FROM product.product
WHERE category_id IN (3, 4, 5);

--is equal to
-- SELECT *
-- FROM product.product
-- WHERE category_id = 3 OR category_id = 4 OR category_id = 5

SELECT *
FROM product.product
WHERE category_id NOT IN (3, 4, 5);


--DATE FUNCTIONS

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

INSERT t_date_time
VALUES ( GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE() )

SELECT *
FROM t_date_time

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )

SELECT *
FROM t_date_time;



--CONVERT Date to VARCHAR

SELECT CONVERT (VARCHAR(10), GETDATE(), 6)


--VARCHAR to Date

SELECT CONVERT (DATE, '04 Jun 22', 6)

SELECT CONVERT (DATETIME, '04 Jun 22', 6)


--FUNCTIONS for RETURN DATE or TIME PARTs

SELECT
        DAY(A_DATE) DAY_
FROM t_date_time

SELECT
        DAY(A_DATE) DAY_,
        MONTH(A_DATE) [MONTH],
        DATENAME (DAYOFYEAR, A_DATE) DOY,
        DATEPART(WEEKDAY, A_DATE) WKD,
        DATENAME (MONTH, A_DATE) MNT
FROM t_date_time


--STRING FUNCTIONS

--LEN, CHARINDEX, PATINDEX

SELECT LEN ('CHAR')

SELECT CHARINDEX ( 'R', 'CHARACTER', 5)
--5. karakterden itibaren say 'R' karakterinin indexi

--R ile biten stringler (PATINDEX(Pattern Index))

SELECT PATINDEX ('%r', 'CHAR')

SELECT PATINDEX ('%A____', 'CHARACTER')

---

--LEFT, RIGHT, SUBSTRING

SELECT LEFT ('CHARACTER', 3)

SELECT RIGHT ('CHARACTER', 4)

SELECT SUBSTRING ('CHARACTER', 4, 3)  --4'ten başla, 3 karakter al


--STRING_SPLIT

SELECT value as NAME
FROM STRING_SPLIT ('victor,saint,brian,heagle,habip', ',')


---Write a script that makes upper first letter of 'character'

SELECT UPPER(SUBSTRING('character', 1, 1)) + RIGHT ('character', 8) 