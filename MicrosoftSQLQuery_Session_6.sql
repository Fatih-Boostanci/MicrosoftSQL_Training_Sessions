CREATE TABLE departments
(
id BIGINT,
name VARCHAR(20),
dept_name VARCHAR(20),
seniority VARCHAR(20),
graduation CHAR (3),
salary BIGINT,
hire_date DATE
);

INSERT departments VALUES
 (10238,  'Eric'    , 'Economics'        , 'Experienced'  , 'MSc'      ,   72000 ,  '2019-12-01')
,(13378,  'Karl'    , 'Music'            , 'Candidate'    , 'BSc'      ,   42000 ,  '2022-01-01')
,(23493,  'Jason'   , 'Philosophy'       , 'Candidate'    , 'MSc'      ,   45000 ,  '2022-01-01')
,(36299,  'Jane'    , 'Computer Science' , 'Senior'       , 'PhD'      ,   91000 ,  '2018-05-15')
,(30766,  'Jack'    , 'Economics'        , 'Experienced'  , 'BSc'      ,   68000 ,  '2020-04-06')
,(40284,  'Mary'    , 'Psychology'       , 'Experienced'  , 'MSc'      ,   78000 ,  '2019-10-22')
,(43087,  'Brian'   , 'Physics'          , 'Senior'       , 'PhD'      ,   93000 ,  '2017-08-18')
,(53695,  'Richard' , 'Philosophy'       , 'Candidate'    , 'PhD'      ,   54000 ,  '2021-12-17')
,(58248,  'Joseph'  , 'Political Science', 'Experienced'  , 'BSc'      ,   58000 ,  '2021-09-25')
,(63172,  'David'   , 'Art History'      , 'Experienced'  , 'BSc'      ,   65000 ,  '2021-03-11')
,(64378,  'Elvis'   , 'Physics'          , 'Senior'       , 'MSc'      ,   87000 ,  '2018-11-23')
,(96945,  'John'    , 'Computer Science' , 'Experienced'  , 'MSc'      ,   80000 ,  '2019-04-20')
,(99231,  'Santosh'	,'Computer Science'  ,'Experienced'   ,'BSc'       ,  74000  , '2020-05-07' )
;
---

--HAVING

SELECT *
FROM dbo.departments;


SELECT dept_name, AVG(Salary) 
FROM dbo.departments
GROUP BY dept_name
HAVING AVG(Salary) > 50000;


--GROUPING SETS (PIVOT, CUBE, ROLL UP)

SELECT
    seniority,
    graduation,
    AVG(Salary) AS avg_salary
FROM
    departments
GROUP BY
    GROUPING SETS (
        (seniority, graduation),
        (graduation)
);

---


SELECT [seniority], [BSc], [MSc], [PhD]
FROM 
(
SELECT seniority, graduation, salary
FROM   departments
) AS SourceTable
PIVOT 
(
 avg(salary)
 FOR graduation
 IN ([BSc], [MSc], [PhD])
) AS pivot_table;

---
SELECT
    seniority,
    graduation,
    AVG(Salary) AS avg_salary
FROM
    departments
GROUP BY
    ROLLUP (seniority, graduation);


    --IN-CLASS (08 Jun 22)

    --VIEW

CREATE VIEW ProductStock AS
SELECT	A.product_id, A.product_name, B.store_id, B.quantity
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310; 


SELECT *
FROM dbo.ProductStock;

select	*
from	dbo.ProductStock
where	store_id = 1;

---

CREATE VIEW SaleStaff as
SELECT  A.first_name, A.last_name, B.store_name
FROM    sale.staff A
INNER JOIN sale.store B
    ON  A.store_id = B.store_id;

SELECT * 
FROM dbo.SaleStaff;


---

--GROUP BY

SELECT *
FROM product.brand


SELECT brand_id, COUNT(*) as brand_count
FROM product.product
GROUP BY brand_id;

SELECT brand_id, COUNT(*) as brand_count
FROM product.product
GROUP BY brand_id;

---Total number of products on category basis

SELECT category_id, COUNT(*)
FROM product.product
GROUP BY category_id

SELECT A.category_id, B.category_name, COUNT(*) AS count_products
FROM product.product as A
JOIN product.category as B 
ON A.category_id = B.category_id
GROUP BY A.category_id, B.category_name;


---HAVING CLAUSE

SELECT B.brand_name, AVG(list_price) AS avg_price
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
      AND a.model_year > 2016
GROUP BY B.brand_name
HAVING AVG(list_price) > 1000
ORDER BY avg_price;

--HAVING alias hata veriyor. Alias kullanılacaksa ORDER BY kısmında kullanılabilir.

--Write a query that checks if any product id is repeated in 
--more than one row in the product table.


SELECT COUNT(*)
FROM product.product
GROUP BY product_id
HAVING COUNT(*) > 1;

--maximum list price' ı 4000' in üzerinde olan veya minimum list price' ı 500' ün altında olan categori id' leri getiriniz
--category name' e gerek yok.

SELECT category_id, MAX(list_price), MIN(list_price)
FROM product.product
GROUP BY category_id
HAVING (MAX(list_price) > 4000) OR (MIN(list_price) < 500);



--bir siparişin toplam net tutarını getiriniz. (müşterinin sipariş için ödediği tutar)
--discount' ı ve quantity' yi ihmal etmeyiniz.

SELECT order_id, CONVERT (DECIMAL(10,2), SUM((quantity*list_price)*(1-discount))) AS Total_Sum
FROM sale.order_item
GROUP BY order_id
;

---

GROUPING SETS


--Herbir kategorideki toplam ürün sayısı
--Herbir model yılındaki toplam ürün sayısı
--Herbir kategorinin model yılındaki toplam ürün sayısı

select	category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	grouping sets (
				(category_id), -- 1. group
				(model_year), -- 2. group
				(category_id, model_year) -- 3. group
	)
order by 1, 2
;


--ROLL UP


select	category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	ROLLUP (category_id, model_year)
;


Herbir marka id, herbir category id ve herbir model yılı için toplam ürün sayılarını getiriniz.
Sonuç tablosunda tüm ihtimaller bulunsun.

select	brand_id, category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	ROLLUP (brand_id, category_id, model_year)
;


--CUBE (--En sağdaki sütundan gruplamaya başlıyor)

select	brand_id, category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	CUBE (brand_id, category_id, model_year)
;




--PIVOT

SELECT model_year, COUNT(*)
FROM product.product
GROUP BY model_year;

-- model yıllarına göre toplam ürün sayısı
SELECT *
FROM
			(
			SELECT product_id, Model_Year --Source Table for PIVOT
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE;


SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;









