

--------- Session 11 (Window Functions-3) - 18-06-2022 --------------

--ROW NUMBER

--Assign an ordinal number to the product prices for each category in ascending order
--1. Herbir kategori içinde ürünlerin fiyat sıralamasını yapınız (artan fiyata göre 1'den başlayıp birer birer artacak) 

SELECT product_id, category_id, list_price,
        ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price ASC) Row_Num
FROM product.product 
;

--RANK, DENSE_RANK

--Aynı soruyu aynı fiyatlı ürünler aynı sıra numarasını alacak şekilde yapınız (RANK fonksiyonunu kullanınız) 
-- Lets try previous query again using DENSE_RANK() function.

SELECT product_id, category_id, list_price,
        ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price ASC) Row_Num,
        RANK() OVER(PARTITION BY category_id ORDER BY list_price ASC) [Rank],
        DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price ASC) [Dense_Rank]
FROM product.product 
;




--/* Assign an ordinal number to the product prices for each category in ascending order */
SELECT product_id, model_year, list_price,
        ROW_NUMBER() OVER(PARTITION BY model_year ORDER BY list_price ASC) Row_Num,
        RANK() OVER(PARTITION BY model_year ORDER BY list_price ASC) [Rank],
        DENSE_RANK() OVER(PARTITION BY model_year ORDER BY list_price ASC) [Dense_Rank]
FROM product.product 
;


--CUME_LIST, PERCENT_RANK, NTILE 

--Write a query that returns the cumulative distribution of the list price in product table by brand.

-- product tablosundaki list price' ların kümülatif dağılımını marka kırılımında hesaplayınız

SELECT brand_id, list_price,
    ROUND(CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price), 3) AS [Cume_Dist],
    ROUND(PERCENT_RANK() OVER(PARTITION BY brand_id ORDER BY list_price), 3) AS [Per_Rank] 
FROM product.product
; 

-- Yukarıdaki sorguda CumDist alanını CUME_DIST fonksiyonunu kullanmadan hesaplayınız.

SELECT brand_id, list_price, 
        COUNT(*) OVER (PARTITION BY brand_id) TotalRowNumber,
        ROW_NUMBER() OVER (PARTITION BY brand_id ORDER BY list_price) RowNumber,
        RANK() OVER (PARTITION BY brand_id ORDER BY list_price) RankNumber
FROM product.product 
ORDER BY 1, 2 

WITH T1 AS 
(
        SELECT brand_id, list_price, 
            COUNT(*) OVER (PARTITION BY brand_id) TotalRowNumber,
            ROW_NUMBER() OVER (PARTITION BY brand_id ORDER BY list_price) RowNumber,
            RANK() OVER (PARTITION BY brand_id ORDER BY list_price) RankNumber
        FROM product.product 
)

SELECT *,
        ROUND(CAST(RowNumber as float)/ TotalRowNumber, 3) CumeDist_RowN,
        ROUND(1.0*RankNumber / TotalRowNumber, 3) CumeDist_RankN
FROM T1
;



--2nd Solution

WITH tbl as (
        select	brand_id, list_price,
                count(*) over(partition by brand_id) TotalProductInBrand,
                row_number() over(partition by brand_id order by list_price) RowNum,
                rank() over(partition by brand_id order by list_price) RankNum
        from	product.product
)
SELECT  *
        ,ROUND(CAST(RowNum as float) / TotalProductInBrand, 3)  CumDistRowNum
        ,STR(CONVERT(float, RankNum) / TotalProductInBrand, 10, 3) CumDistRankNum
FROM    tbl
; 



--Write a query that returns both of the followings:
--The average product price of orders.
--Average net amount.


--Aşağıdakilerin her ikisini de döndüren bir sorgu yazın:
--Siparişlerin ortalama ürün fiyatı.
--Ortalama net tutar.

SELECT order_id,  
    AVG((list_price*quantity)*(1-discount)) OVER (PARTITION BY order_id) avg_NetPrice,
    AVG(list_price) OVER (PARTITION BY order_id) avg_ListPrice
FROM sale.order_item 
; 

--List orders for which the average product price is higher than the average net amount.
--Ortalama ürün fiyatının ortalama net tutardan yüksek olduğu siparişleri listeleyin.
WITH T1 AS
(
SELECT DISTINCT order_id,  
    AVG((list_price*quantity)*(1-discount)) OVER (PARTITION BY order_id) avg_NetPrice,
    AVG(list_price) OVER (PARTITION BY order_id) avg_ListPrice
FROM sale.order_item 
)
SELECT *
FROM T1
WHERE avg_NetPrice > avg_ListPrice 
ORDER BY 2
; 

--2nd Solution
select distinct order_id, a.Avg_price,a.Avg_net_amount
from (
select *,
avg(list_price*quantity*(1-discount))  over() Avg_net_amount,
avg(list_price*quantity*(1-discount))  over(partition by order_id) Avg_price
from [sale].[order_item]
) A
where  a.Avg_price > a.Avg_net_amount
order by 2 

--
--Calculate the stores' weekly cumulative number of orders for 2018
--mağazaların 2018 yılına ait haftalık kümülatif sipariş sayılarını hesaplayınız

SELECT ss.store_id, ss.store_name, 
    DATEPART(wk,so.order_date) week_of_year, 
    COUNT(*) OVER (PARTITION BY ss.store_id, DATEPART(wk,so.order_date)) weeks_order,
    COUNT(*) OVER (PARTITION BY ss.store_id ORDER BY DATEPART(wk,so.order_date ) cum_total_order
FROM sale.orders so, sale.store ss 
WHERE ss.store_id = so.store_id 
    AND YEAR(so.order_date) = 2018
ORDER BY 1, 3 

--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasında satılan ürün sayısının 7 günlük hareketli ortalamasını hesaplayın.

SELECT so.order_date, SUM(soi.quantity) SumQuantity
FROM sale.orders so, sale.order_item soi 
WHERE so.order_id = soi.order_id 
GROUP BY so.order_date
;   

WITH TBL AS 
(
    SELECT so.order_date, SUM(soi.quantity) SumQuantity
    FROM sale.orders so, sale.order_item soi 
    WHERE so.order_id = soi.order_id 
    GROUP BY so.order_date
)

SELECT *,
    AVG(SumQuantity*1.0) 
    OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) sales_moving_avg_7
FROM TBL
WHERE order_date BETWEEN '2018-03-12' AND '2018-04-12'
ORDER BY 1
; --eksik tarihler?


--2nd Solution

with tbl as (
	select	B.order_date, sum(A.quantity) SumQuantity --A.order_id, A.product_id, A.quantity
	from	sale.order_item A, sale.orders B
	where	A.order_id = B.order_id
	group by B.order_date
)
select	*
from	(
	select	*,
		avg(SumQuantity*1.0) over(order by order_date rows between 6 preceding and current row) sales_moving_average_7
	from	tbl
) A
where	A.order_date between '2018-03-12' and '2018-04-12'
order by 1    
   
   
--List customers whose have at least 2 consecutive orders are not shipped 

SELECT customer_id, order_id, order_date, shipped_date
FROM sale.orders 
