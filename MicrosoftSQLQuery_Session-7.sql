--SESSION 7--

--SUBQUERY

--SELECT bloğunda kul--> tek bir değer döndürmesi gerekir.
SELECT order_id, list_price,
        (
        SELECT AVG(list_price)
        FROM sale.order_item
        ) AS avg_price
FROM sale.order_item;

--WHERE bloğunda IN ile
select	order_id, order_date
from	sale.orders
where	order_date in (
					select top 5 order_date
					from	sale.orders
					order by order_date desc
					)
;

--FROM bloğunda bir tablo döndürmesi gerekir. Alias olması zorunlu

select	order_id, order_date
from	(
		select	top 5 *
		from	sale.orders
		order by order_date desc
		) A;


--Write a query that returns the total list price by each order ids.

SELECT	so.order_id,
		(
		SELECT	sum(list_price)
		FROM	sale.order_item
		WHERE	order_id=so.order_id
		) AS total_price
FROM	sale.order_item so
GROUP BY so.order_id


-- Davis Thomas'nın çalıştığı mağazadaki tüm personelleri listeleyin.
--inner query
SELECT store_id
FROM sale.staff
WHERE first_name = 'Davis' AND last_name = 'Thomas'

--outer query
SELECT *
FROM sale.staff
WHERE store_id = ()

SELECT *
FROM sale.staff
WHERE store_id = (
                SELECT store_id
                FROM sale.staff
                WHERE first_name = 'Davis' AND last_name = 'Thomas'
                )


--Charles Cussona 'ın yöneticisi olduğu personelleri listeleyin.

select	*
from	sale.staff
where	manager_id = (
					select	staff_id
					from	sale.staff
					where	first_name = 'Charles' and last_name = 'Cussona'
					)
;


--'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen 
--pahalı olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adı ve kategori adı 
--alanlarına ihtiyaç duyulmaktadır.

SELECT *
FROM product.product
WHERE list_price > (
                    SELECT list_price 
                    FROM product.product
                    WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
)

--List all customers who orders on the same dates as Laura Goldammer

SELECT *
FROM sale.customer AS SC, sale.orders AS SO
WHERE order_date IN (
				SELECT SO.order_date
				FROM sale.customer AS SC, sale.orders AS SO
				WHERE first_name = 'Laurel' AND last_name='Goldammer'
				AND SC.customer_id=SO.customer_id)
				AND SC.customer_id=SO.customer_id
;


--List products made in 2021 and their categories other than 
--Game, gps, or Home Theater

select	*
from	product.product
where	model_year = 2021 and
		category_id NOT IN (
						select	category_id
						from	product.category
						where	category_name in ('Game', 'GPS', 'Home Theater')
						)
;

---- 2020 model olup Receivers Amplifiers kategorisindeki en pahalı üründen 
--daha pahalı ürünleri listeleyin.
-- Ürün adı, model_yılı ve fiyat bilgilerini 
--yüksek fiyattan düşük fiyata doğru sıralayınız.


select	*
from	product.product
where	model_year = 2020 and
		list_price > (
			select	max(B.list_price)
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
		)

--Second solution
select	*
from	product.product
where	model_year = 2020 and
		list_price > ALL(
			select	(B.list_price)
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
		)


select	*
from	product.product
where	model_year = 2020 and
		list_price > ANY(
			select	(B.list_price)
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
		)        