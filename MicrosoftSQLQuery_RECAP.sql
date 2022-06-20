----

SELECT *
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

---
SELECT email
FROM sale.customer

SELECT DISTINCT COUNT(*)
FROM sale.customer
WHERE RIGHT(email, 9) = 'yahoo.com'

--Solution-2
SELECT DISTINCT COUNT(*)
FROM sale.customer
WHERE email LIKE '%yahoo.com%'

--Solution-3
SELECT COUNT(*)
FROM sale.customer
WHERE SUBSTRING(email, PATINDEX('%@%', email), 10) = '@yahoo.com'

--
SELECT email, LEFT(email, PATINDEX('%@%', email) -1) as Chars
FROM sale.customer

--2nd Solution
select email, TRIM(RIGHT(email,(LEN(email) - PATINDEX('%@%', email)+1)) FROM email)  as Chars
from sale.customer;

---
SELECT *, 
    ISNULL(phone, email)
FROM sale.customer

--2nd Solution
SELECT *, 
    COALESCE(phone, email)
FROM sale.customer

---
SELECT street, 
    SUBSTRING(street, 3, 1) AS third_Char
FROM sale.customer
WHERE ISNUMERIC(SUBSTRING(street, 3, 1)) = 1


---
select email,
		SUBSTRING(email, 1, (PATINDEX('%@%', email)-1)) left_part,
		SUBSTRING(email, PATINDEX('%@%', email)+1, 15) as right_part
from sale.customer

---
SELECT street, TRIM()


---JOINS

SELECT pp.product_id, pp.product_name, pc.category_id, pc.category_name
FROM product.product as pp
JOIN product.category as pc
ON pp.category_id = pc.category_id;

--2nd Solution
SELECT pp.product_id, pp.product_name, pc.category_id, pc.category_name
FROM product.product as pp, product.category as pc
WHERE pp.category_id = pc.category_id;

---
SELECT *
FROM sale.store as ss, sale.staff as st 
WHERE ss.store_id = st.store_id;

---
SELECT sc.[state], YEAR(so.order_date) YEARS, MONTH(so.order_date) MONTHS, COUNT(*) NOO
FROM sale.customer as sc, sale.orders as so 
WHERE sc.customer_id = so.customer_id 
GROUP BY sc.state, YEAR(so.order_date), MONTH(so.order_date)
ORDER BY 1, 2, 3
---

SELECT pp.product_id, pp.product_name, soi.order_id
FROM product.product as pp
LEFT JOIN sale.order_item as soi 
ON pp.product_id = soi.product_id
WHERE soi.order_id IS NULL

---
SELECT pp.product_id, pp.product_name, ps.store_id, ps.product_id, ps.quantity
FROM product.product as pp
LEFT JOIN product.stock as ps 
ON pp.product_id = ps.product_id 
WHERE pp.product_id > 310

---
SELECT TOP 100 pp.product_id, ps.store_id, ps.quantity, soi.order_id, soi.list_price
FROM product.product as pp 
FULL OUTER JOIN sale.order_item as soi
ON pp.product_id = soi.product_id
FULL OUTER JOIN product.stock as ps 
ON pp.product_id = ps.product_id 
GROUP BY pp.product_id, ps.store_id, ps.quantity, soi.order_id, soi.list_price 
ORDER BY 2


---SELF JOIN
SELECT A.first_name as staff_firstname, a.last_name as staff_lastname, B.first_name as manager_name
FROM sale.staff A 
INNER JOIN sale.staff B 
ON B.staff_id = A.manager_id 

SELECT A.first_name as staff_firstname, a.last_name as staff_lastname, B.first_name as manager_name
FROM sale.staff A 
INNER JOIN sale.staff B 
ON B.staff_id = A.manager_id 
WHERE B.first_name = 'Charles'

SELECT *
FROM sale.staff 

---
SELECT A.first_name as staff_firstname, a.last_name as staff_lastname, B.first_name as manager1_name, C.first_name as manager2_name
FROM sale.staff A 
INNER JOIN sale.staff B 
ON A.manager_id = B.staff_id 
INNER JOIN sale.staff C 
ON B.manager_id = C.staff_id 

---
--ADVANCED GROUPING OPS
--HAVING

--
SELECT DISTINCT COUNT(product_id)
FROM product.product
HAVING COUNT(product_id) > 1 
--GROUP BY product_id 

SELECT *
FROM product.product 


---
SELECT category_id, MAX(list_price) as max_price, MIN(list_price) as min_price
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500

---
SELECT pb.brand_name, AVG(pp.list_price) as avg_price
FROM product.product pp, product.brand pb 
WHERE pp.brand_id = pb.brand_id 
GROUP BY pb.brand_name 
HAVING AVG(pp.list_price) > 1000
ORDER BY avg_price DESC 

---
SELECT so.customer_id, SUM((soi.list_price*soi.quantity)*(1-soi.discount)) as net_price 
FROM sale.order_item soi, sale.orders so 
WHERE soi.order_id = so.order_id 
GROUP BY so.customer_id 
ORDER BY 1 

--GROUPING SETS

SELECT pb.brand_name, pc.category_name, pp.model_year, 
        ROUND(SUM((soi.list_price*soi.quantity)*(1-soi.discount)), 2) as total_sales_price
FROM product.product pp, product.brand pb, product.category pc, sale.order_item soi 
WHERE pp.brand_id = pb.brand_id
    AND pp.category_id = pc.category_id 
    AND pp.product_id = soi.product_id 
GROUP BY 
    GROUPING SETS (
        (pb.brand_name),
        (pb.brand_name, pc.category_name),
        (pb.brand_name, pc.category_name, pp.model_year)
        ) 
ORDER BY 1 

--ROLLUP 

SELECT pb.brand_name, pc.category_name, pp.model_year, 
        ROUND(SUM((soi.list_price*soi.quantity)*(1-soi.discount)), 2) as total_sales_price
FROM product.product pp, product.brand pb, product.category pc, sale.order_item soi 
WHERE pp.brand_id = pb.brand_id
    AND pp.category_id = pc.category_id 
    AND pp.product_id = soi.product_id 
GROUP BY 
    ROLLUP 
            (pb.brand_name, pc.category_name, pp.model_year)
         
ORDER BY 1 

----
--CUBE 

SELECT pb.brand_name, pc.category_name, pp.model_year, 
        ROUND(SUM((soi.list_price*soi.quantity)*(1-soi.discount)), 2) as total_sales_price
FROM product.product pp, product.brand pb, product.category pc, sale.order_item soi 
WHERE pp.brand_id = pb.brand_id
    AND pp.category_id = pc.category_id 
    AND pp.product_id = soi.product_id 
GROUP BY 
    CUBE 
            (pb.brand_name, pc.category_name, pp.model_year)
        
--ORDER BY 1  

--- 

--PIVOT 
SELECT pc.category_name, SUM((soi.list_price*soi.quantity)*(1-soi.discount)) as total_sales
FROM product.category pc, product.product pp, sale.order_item soi 
WHERE pp.category_id =  pc.category_id 
    AND pp.product_id = soi.product_id
GROUP BY pc.category_name
ORDER BY 1 

SELECT *
FROM (
            SELECT pc.category_name, SUM((soi.list_price*soi.quantity)*(1-soi.discount)) as total_sales
            FROM product.category pc, product.product pp, sale.order_item soi 
            WHERE pp.category_id =  pc.category_id 
                AND pp.product_id = soi.product_id
            GROUP BY pc.category_name 
       ) AS Source_table

PIVOT (
    SUM((soi.list_price*soi.quantity)*(1-soi.discount))
    FOR category_name
    IN ([Audio & Video Accessories], [Bluetooth], [Car Electronics], 
        [Computer Accessories], [Earbud], [gps], [Hi-Fi Systems], [Home Theater], [mp4 player], 
        [Receivers Amplifiers], [Speakers], [Televisions & Accessories])
) AS pivot_table; 




-----

--SET OPERATORS 

--UNION 

--
SELECT last_name, city
FROM sale.customer 
WHERE city = 'Aurora'
UNION 
SELECT last_name, city
FROM sale.customer 
WHERE city = 'Charlotte'


SELECT customer_id, first_name, last_name
FROM sale.customer 
WHERE first_name = 'Thomas'
UNION 
SELECT customer_id, first_name, last_name
FROM sale.customer 
WHERE last_name = 'Thomas'
ORDER BY 1
;

--INTERSECT 
--
SELECT pb.brand_id, pb.brand_name
FROM product.product pp, product.brand pb 
WHERE pp.brand_id = pb.brand_id 
    AND pp.model_year = 2018 
INTERSECT
SELECT pb.brand_id, pb.brand_name
FROM product.product pp, product.brand pb 
WHERE pp.brand_id = pb.brand_id 
    AND pp.model_year = 2019 
--ORDER BY 1 

--EXCEPT 
SELECT pp.product_id, pp.product_name
FROM product.product pp, sale.order_item soi, sale.orders so 
WHERE pp.product_id = soi.product_id 
    AND soi.order_id = so.order_id 
    AND YEAR(so.order_date) = 2019 
EXCEPT 
SELECT pp.product_id, pp.product_name
FROM product.product pp, sale.order_item soi, sale.orders so 
WHERE pp.product_id = soi.product_id 
    AND soi.order_id = so.order_id 
    AND YEAR(so.order_date) = 2018 
EXCEPT 
SELECT pp.product_id, pp.product_name
FROM product.product pp, sale.order_item soi, sale.orders so 
WHERE pp.product_id = soi.product_id 
    AND soi.order_id = so.order_id 
    AND YEAR(so.order_date) = 2020 
; 

--2nd Solution 
SELECT pp.product_id, pp.product_name
FROM product.product pp, sale.order_item soi, sale.orders so 
WHERE pp.product_id = soi.product_id 
    AND soi.order_id = so.order_id 
    AND YEAR(so.order_date) = 2019 
EXCEPT 
SELECT pp.product_id, pp.product_name
FROM product.product pp, sale.order_item soi, sale.orders so 
WHERE pp.product_id = soi.product_id 
    AND soi.order_id = so.order_id 
    AND YEAR(so.order_date) <> 2019 
    ; 


--CASE 

--
SELECT order_id, order_status, 
    CASE order_status 
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Processing'
            WHEN 3 THEN 'Rejected'
            WHEN 4 THEN 'Completed'
    END AS order_status_desc
FROM sale.orders
; 
--
SELECT *,
    CASE 
        WHEN shipped_date = order_date then 'Fast'
        WHEN DATEDIFF(day, order_date, shipped_date) <  3  
            AND DATEDIFF(day, order_date, shipped_date) > 0 then 'Normal'
        WHEN DATEDIFF(day, order_date, shipped_date) >=  3  then 'Slow'
        ELSE 'Not Shipped'
    END AS ORDER_LABEL
FROM sale.orders 
ORDER BY shipped_date
;

SELECT shipped_date
FROM sale.orders 
ORDER BY 1 ASC 

--------------
--SUBQUERY

--Q1
--Write a query that returns the total list price by each order ids
SELECT soi.order_id, 
    (SELECT SUM(list_price) 
    FROM sale.order_item 
    WHERE order_id = soi.order_id
    ) total_price
FROM sale.order_item soi 
GROUP BY soi.order_id

--Q2
--Bring all the staff from the store that Davis Thomas works 

SELECT *
FROM sale.staff 
WHERE store_id IN (
SELECT store_id 
FROM sale.staff 
WHERE first_name = 'Davis' AND last_name = 'Thomas'
)


-- 
SELECT *
FROM sale.staff 
WHERE store_id IN (
SELECT store_id
FROM sale.store
WHERE store_name = 'Burkes Outlet'
)

SELECT store_name 
FROM sale.store
--
SELECT *, st.store_name
FROM sale.staff ss, sale.store st
WHERE ss.store_id =  st.store_id
    AND ss.store_id 
    IN (
        SELECT store_id 
        FROM sale.staff 
        WHERE first_name = 'Davis' AND last_name = 'Thomas'
        ) 
--Q3
--List the staff that Charles Cussona is the manager of
SELECT *
FROM sale.staff 
WHERE manager_id =
        (
        SELECT staff_id
        FROM sale.staff 
        WHERE first_name = 'Charles' 
            AND last_name = 'Cussona'
            )

--Q4  
--Write a query that returns customers in the city 
--where 'The BFLO Store' is located

SELECT *
FROM sale.customer 
WHERE city IN  
    (
        SELECT city 
        FROM sale.store 
        WHERE store_name = 'The BFLO Store'
    )
;

--Q5 
--List prodcuts that are more expensive than 
--Pro-Series 49-Class Full HD Outdoor LED TV (Silver)
SELECT *
FROM product.product
WHERE list_price > 
(
        SELECT list_price 
        FROM product.product 
        WHERE product_name = 
                'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

)

--Q6 
--List customers whose order dates are before than Hassan Pope.

SELECT *
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id
    AND so.order_date < 
    (
        SELECT order_date 
        FROM sale.orders so, sale.customer sc 
        WHERE so.customer_id = sc.customer_id 
            AND sc.first_name = 'Hassan' 
            AND sc.last_name = 'Pope'
    ) 
;
---Multiple-row Subqueries
--Q7
--List all customers who orders on the same dates as Laurel Goldammer 

SELECT *
FROM sale.customer sc, sale.orders so 
WHERE sc.customer_id = so.customer_id 
    AND so.order_date IN (
        SELECT so.order_date
        FROM sale.customer sc, sale.orders so 
        WHERE sc.customer_id = so.customer_id 
            AND sc.first_name = 'Laurel' AND sc.last_name = 'Goldammer'
    )


--Q8
--List products made in 2021 and their categories other than 
--Game, gps, or Home Theater 

SELECT pp.product_name, pc.category_name
FROM product.product pp, product.category pc 
WHERE pp.category_id = pc.category_id 
 AND pp.product_name IN 
        (SELECT pp.product_name
         FROM product.product pp, product.category pc 
         WHERE pp.category_id = pc.category_id 
    AND pc.category_name NOT IN ('Game', 'gps', 'Home Theater')
        ) 
 AND pp.model_year = 2021
;

--Q9
--List products made in 2020 and its prices more than 
--all products in the Receivers Amplifiers category 

SELECT product_name, model_year, list_price
FROM product.product 
WHERE list_price > 
    (
        SELECT  MAX(pp.list_price) 
        FROM product.product pp, product.category pc 
        WHERE pp.category_id = pc.category_id
        AND pc.category_name = 'Receivers Amplifiers'
    )
    AND model_year = 2020
ORDER BY 3 DESC
;
--2 nd Solution (w/ ALL)
SELECT * 
FROM	product.product
WHERE	model_year = 2020 and
		list_price > ALL (
			SELECT	B.list_price
			FROM	product.category A, product.product B
			WHERE	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			) 

--Correlated Subqueries           

--Q10
--
SELECT DISTINCT sc2.state
FROM sale.customer sc2
WHERE NOT EXISTS (SELECT DISTINCT sc.state
        FROM product.product pp, sale.order_item soi,
                sale.orders so, sale.customer sc 
        WHERE pp.product_id = soi.product_id 
            AND soi.order_id = so.order_id 
            AND so.customer_id = sc.customer_id 
            AND pp.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
            AND sc2.[state] = sc.[state]
)

--Q11
SELECT DISTINCT sc2.customer_id, sc2.first_name, sc2.last_name
FROM sale.customer sc2
WHERE NOT EXISTS
(
        SELECT DISTINCT *
        FROM sale.customer sc, sale.orders so 
        WHERE sc.customer_id = so.customer_id 
            AND sc2.customer_id = sc.customer_id
            AND so.order_date < '2020-01-01'
)

SELECT DISTINCT *
FROM sale.customer sc, sale.orders so 
WHERE sc.customer_id = so.customer_id 
    AND sc2.customer_id = sc.customer_id
    AND so.order_date < '2020-01-01'

--Q12
--List customers who have ---- named Jerald Berray 
SELECT *
FROM sale.customer sc, sale.orders so 
WHERE sc.customer_id = so.customer_id 
    AND so.order_date < 
    (
        SELECT MAX(so.order_date)
        FROM sale.customer sc, sale.orders so 
        WHERE sc.customer_id = so.customer_id
        AND sc.first_name = 'Jerald' AND sc.last_name = 'Berray'
    )
    AND sc.city = 'Austin'


--2nd Solution
WITH TBL AS 
    (
        SELECT MAX(so.order_date) max_order_date
        FROM sale.customer sc, sale.orders so 
        WHERE sc.customer_id = so.customer_id
        AND sc.first_name = 'Jerald' AND sc.last_name = 'Berray'
    )   

SELECT *
FROM sale.customer sc, sale.orders so, TBL t
WHERE sc.customer_id = so.customer_id 

    AND so.order_date < t.max_order_date 
    AND sc.city = 'Austin' 

--
--Create a table with a number in each row 
--in ascending order from 0 to 9
WITH TBL AS 

    (SELECT 2+3 AS n 
    UNION ALL
    SELECT n+1 
    FROM TBL
    WHERE n<10
    ) 
SELECT n 
FROM TBL 

--Write a query that returns all staff with their manager ids 

WITH TBL AS 
    (SELECT staff_id, first_name, manager_id 
    FROM sale.staff
    WHERE staff_id = 1
    UNION ALL
    SELECT A.staff_id, A.first_name, A.manager_id
    FROM sale.staff A, TBL B 
    WHERE A.manager_id = B.staff_id 
    ) 
SELECT *
FROM TBL

