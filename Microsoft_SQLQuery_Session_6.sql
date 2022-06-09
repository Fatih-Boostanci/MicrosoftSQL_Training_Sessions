--SESSION 6

--SET OPERATORS

--UNION
--Charlotte şehrindeki müşteriler ile Aurora şehrindeki 
--müşterilerin soyisimlerini listeleyin

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'

UNION

SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';

--UNION ALL (not ordered, more performance)

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'

UNION

SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'

UNION

SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';


--Çalışanların ve müşterilerin eposta adreslerinin 
--unique olacak şekilde listeleyiniz.

SELECT email
FROM sale.customer

UNION

SELECT email
FROM sale.staff;

--UNION ALL

---- Adı Thomas olan ya da soyadı Thomas olan müşterilerin 
--isim soyisimlerini listeleyiniz.

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION ALL 

SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas';


--INTERSECT

-- Write a query that returns brands that have products for both 2018 and 2019.

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2018

INTERSECT

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2019;

--Write a query that returns customers 
--who have orders for both 2018, 2019, and 2020

SELECT B.first_name, B.last_name
FROM sale.orders A, sale.customer B
WHERE A.customer_id = B.customer_id
    AND YEAR(A.order_date) = 2018

INTERSECT

SELECT B.first_name, B.last_name
FROM sale.orders A, sale.customer B
WHERE A.customer_id = B.customer_id
    AND YEAR(A.order_date) = 2019

INTERSECT

SELECT B.first_name, B.last_name
FROM sale.orders A, sale.customer B
WHERE A.customer_id = B.customer_id
    AND YEAR(A.order_date) = 2020;

--Charlotte şehrindeki müşteriler ile Aurora şehrindeki 
--müşterilerden isimleri aynı olanları listeleyin

SELECT first_name
FROM sale.customer
WHERE city = 'Charlotte'

INTERSECT

SELECT first_name
FROM sale.customer
WHERE city = 'Aurora';

--EXCEPT

-- Write a query that returns brands that have a 2018 model product 
--but not a 2019 model product

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2018

EXCEPT

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2019
;



--Sadece 2019 yılında sipariş verilen 
--diğer yıllarda sipariş verilmeyen ürünleri getiriniz.

 select	C.product_id, D.product_name
from	
	(
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id
	except
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id
	) C, product.product D
where	C.product_id = D.product_id
;

--isequalto
select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id
	except
	select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id;

---


--CASE

--Generate a new column containing what the mean of the values in Order_Status column

SELECT order_id, order_status,

    CASE order_status WHEN 1 THEN 'Pending'
                        WHEN 2 THEN 'Processing'
                        WHEN 3 THEN 'Rejected'
                        WHEN 4 THEN 'Completed'
    END order_status_desc

FROM sale.orders;



--Add a column to the sale.staff table containing the store names of the employees.

SELECT first_name, last_name, store_id, 

    CASE store_id      WHEN 1 THEN 'Davi techno Retail'
                        WHEN 2 THEN 'The BFLO Store'
                        WHEN 3 THEN 'Burkes Outlet'
                        
    END order_store

FROM sale.staff;

--Generate a new column containing 
--what the mean of the values in Order_Status column
--(w/SEARCHED CASE)

SELECT order_id, order_status,

    CASE 
                        WHEN order_status = 1 THEN 'Pending'
                        WHEN order_status = 2 THEN 'Processing'
                        WHEN order_status = 3 THEN 'Rejected'
                        WHEN order_status = 4 THEN 'Completed'
                        ELSE 'others'
    END order_status_desc2

FROM sale.orders;


--MüşterilERİN e-mail adreslerindeki servis sağlayıcılarını 
--yeni bir sütun oluşturarak belirtiniz.

SELECT first_name, last_name, email,

    CASE 
        WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%yahoo%' THEN 'Yahoo'
		ELSE 'Other'
	END AS email_service_provider

FROM sale.customer;


-- Aynı siparişte 
--hem mp4 player, hem Computer Accessories 
--hem de Speakers kategorilerinde ürün sipariş veren müşterileri bulunuz.

select	c.order_id, count(distinct a.category_id) uniqueCategory
from	product.category A, product.product B, sale.order_item C
where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
		A.category_id = B.category_id AND
		B.product_id = C.product_id
group by C.order_id
having	count(distinct a.category_id) = 3
;

select	C.first_name, C.last_name
from	(
		select	c.order_id, count(distinct a.category_id) uniqueCategory
		from	product.category A, product.product B, sale.order_item C
		where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		group by C.order_id
		having	count(distinct a.category_id) = 3
		) A, sale.orders B, sale.customer C
where	A.order_id = B.order_id AND
		B.customer_id = C.customer_id
;