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