--PRE-CLASS CHECK YOURSELF

--FUNCTIONS
--1
select product_name
from product.product
where substring(product_name,1,7) = 'Samsung'
order by product_name;

select product_name
from product.product
where substring(product_name, 
                1, 
                CHARINDEX(' ', product_name)) = 'Samsung '
order by product_name asc;

--SELECT product_name
--FROM product.product
--WHERE product_name LIKE 'Samsung%'

--2
select street
from sale.customer
where (street LIKE '%#1') OR (street LIKE '%#2') OR (street LIKE '%#3') OR (street LIKE '%#4')
ORDER BY street ASC;


--JOINS
--1 
--Write a query that returns orders of the products branded "Seagate". 
--It should be listed Product names and order IDs of all the products ordered or not ordered. 
--(order_id in ascending order)

SELECT pp.product_name, soi.order_id
FROM sale.order_item soi 
FULL OUTER JOIN product.product pp
ON soi.product_id = pp.product_id
FULL OUTER JOIN product.brand pb
ON pp.brand_id = pb.brand_id 
WHERE pb.brand_name ='Seagate'
ORDER BY soi.order_id
; 








--2
--Write a query that returns the order date of the product named 
"Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black"

SELECT A.order_date
FROM sale.orders AS A
INNER JOIN sale.order_item AS B
    ON A.order_id = B.order_id
INNER JOIN product.product AS C
    ON B.product_id = C.product_id
WHERE C.product_name = 
'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black';


--Advanced Grouping Operations
--1 ?sonuç biraz farklı eksik birşeyler var
--Please write a query to return only the order ids that have an average amount of more than $2000. 
--Your result set should include order_id. Sort the order_id in ascending order.

SELECT order_id
FROM sale.order_item
GROUP BY order_id
HAVING AVG((list_price*quantity)*(1-discount)) > 2000
ORDER BY 1;

--2
--Write a query that returns the count of orders of each day 
--between '2020-01-19' and '2020-01-25'. Report the result using Pivot Table.

--Note: The column names should be day names (Sun, Mon, etc.).


SELECT order_id, DATENAME(weekday, order_date) w_day
FROM sale.orders 
WHERE order_date BETWEEN '2020-01-19' AND '2020-01-25'
ORDER BY order_id;

--
SELECT [sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [saturday]
FROM 
(
SELECT order_id, DATENAME(weekday, order_date) w_day
FROM sale.orders 
WHERE order_date BETWEEN '2020-01-19' AND '2020-01-25'
) AS SourceTable
PIVOT 
(
 count(order_id)
 FOR w_day
 IN ([sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [saturday])
) AS pivot_table;



SELECT *
FROM 
(
SELECT order_id, DATENAME(weekday, order_date) w_day
FROM sale.orders 
WHERE order_date BETWEEN '2020-01-19' AND '2020-01-25'
) t 
PIVOT(
    order_id
    FOR w_day IN (
        [Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday]
    )
) AS pivot_table;


--SET OPERATORS

--1
--List in ascending order the stores where both 
--"Samsung Galaxy Tab S3 Keyboard Cover" and "Apple - Pre-Owned iPad 3 - 64GB - Black" are stocked.

SELECT C.store_name
FROM product.stock as A
JOIN product.product as B
    ON A.product_id = B. product_id
JOIN sale.store as C
    ON A.store_id = C.store_id
WHERE B.product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'

INTERSECT

SELECT C.store_name
FROM product.stock as A
JOIN product.product as B
    ON A.product_id = B. product_id
JOIN sale.store as C
    ON A.store_id = C.store_id
WHERE B.product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black';

--2
--Detect the store that does not have a product named 
"Samsung Galaxy Tab S3 Keyboard Cover" in its stock.

SELECT C.store_name
FROM product.stock as A
JOIN product.product as B
    ON A.product_id = B. product_id
JOIN sale.store as C
    ON A.store_id = C.store_id
WHERE B.product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black'

EXCEPT

SELECT C.store_name
FROM product.stock as A
JOIN product.product as B
    ON A.product_id = B. product_id
JOIN sale.store as C
    ON A.store_id = C.store_id
WHERE B.product_name = 'Samsung Galaxy Tab S3 Keyboard Cover';

---

--CASE Expression

--Classify staff according to the count of orders they receive as follows:
--a) 'High-Performance Employee' if the number of orders is greater than 400
--b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
--c) 'Low-Performance Employee' if the number of orders is between 1 and 100
--d) 'No Order' if the number of orders is 0

--Then, list the staff's first name, last name, employee class, and count of orders.  
--(Count of orders and first names in ascending order)

SELECT *
    COUNT(CASE WHEN COUNT(order_id) > 400 THEN 'High-Performance_Employee')



FROM sale.staff as A
JOIN sale.orders as B
    ON A.staff_id = B.staff_id
GROUP BY 


--Check yourself sorusu Subqueries (NOT EXIST)(soruyu çöz)

SELECT A.store_name 
FROM sale.store A 
WHERE NOT EXISTS(
    SELECT 1
    FROM sale.orders B
    WHERE  B.order_date BETWEEN '2018-07-22' AND '2018-07-28'
      AND A.store_id = B.store_id
    )
ORDER BY B.order_id