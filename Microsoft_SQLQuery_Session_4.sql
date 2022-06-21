

SELECT TRIM (' CHAR')

SELECT TRIM (' CHAR ')

SELECT GETDATE();

SELECT TRIM ('ABC' FROM 'CCCCBBBAAdfdfdfCBABCA');

SELECT LTRIM(' CHAR ');

-- STRING, REPLACE

SELECT REPLACE ('CHAR STRING', ' ', '/');

SELECT STR (5454);

SELECT STR (213456745);

SELECT STR (133215.654645, 11, 3);

 133215.655

 --CAST, CONVERT

SELECT CAST (12345 AS CHAR);

SELECT CAST (123.65 AS INT);

SELECT CONVERT(int, 30.60)

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)


--COALESCE--

SELECT COALESCE (NULL, 'Hi', 'Hello', NULL);


--NULLIF-- (NULL if the values are the same)

SELECT NULLIF (10, 10);

SELECT NULLIF (10, 9);

SELECT NULLIF ('Hi', 'Hi');


--ROUND

SELECT ROUND (432.368, 2, 0)

SELECT ROUND (432.368, 2, 1)
--1--> round to down

--ISNULL (IOT fill null values w/ specific values)

SELECT ISNULL (NULL, 'ABC');

SELECT ISNULL ('', 'ABC');


--ISNUMERIC--(results "1" if is numeric)

SELECT ISNUMERIC (123);

SELECT ISNUMERIC ('ABC');



----JOIN

--INNER JOIN

SELECT A.product_id, A.product_name,
       B.category_id, B.category_name
FROM product.product as A
INNER JOIN product.category as B
ON A.category_id = B.category_id;

SELECT S.first_name, S.last_name, R.store_name
FROM sale.staff as S
INNER JOIN sale.store as R
ON S.store_id = R.store_id;


--LEFT JOIN

SELECT P.product_id, P.product_name, O.order_id
FROM product.product as P
LEFT JOIN sale.order_item as O
ON P.product_id = O.product_id
WHERE O.product_id IS NULL;



SELECT P.product_id, P.product_name, S.*
FROM product.product as P
LEFT JOIN product.stock as S
ON P.product_id = S.product_id
WHERE P.product_id > 310;


--RIGHT JOIN

SELECT P.product_id, P.product_name, S.*
FROM product.stock as S
RIGHT JOIN product.product as P
ON P.product_id = S.product_id
WHERE S.product_id > 310;

--FULL OUTER JOIN

--Write a query that returns stock and order info together for all products(Top 100)
select	top 100 A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
from	product.product A
FULL OUTER JOIN product.stock B
ON		A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C
ON		A.product_id = C.product_id
order by B.store_id;


--CROSS JOIN

SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id;




