

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




