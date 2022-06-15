--ASIGNMENT-3


--a.Create above table (Actions) and insert values,

CREATE TABLE Actions(
	visitor_id int primary key,
	adv_type varchar(50) null,
	action varchar(50) null
);

INSERT INTO actions (visitor_id, adv_type, action)
VALUES (1, 'A', 'Left'),
        (2, 'A', 'Order'),
        (3, 'B', 'Left'),
        (4, 'A', 'Order'),
        (5, 'A', 'Review'),
        (6, 'A', 'Left'),
        (7, 'B', 'Left'),
        (8, 'B', 'Order'),
        (9, 'B', 'Review'),
        (10, 'A', 'Review');

SELECT *
FROM Actions

--b. Retrieve count of total Actions and Orders for each Advertisement Type,

-- Total action count for A
SELECT COUNT(action) as Count_A
FROM Actions
WHERE adv_type = 'A' 

-- Total action count for B
SELECT COUNT(action) as Count_B
FROM Actions
WHERE adv_type = 'B'

--Order action count for A
SELECT COUNT(action) as Count_Order_A
FROM Actions
WHERE action = 'Order'
    AND adv_type = 'A'

--Order action count for B
SELECT COUNT(action) as Count_Order_B
FROM Actions
WHERE action = 'Order'
    AND adv_type = 'B'






--c.Calculate Orders (Conversion) rates for each Advertisement Type 
--by dividing by total count of actions casting as float by multiplying by 1.0

SELECT A.[Adv_Type],
	   cast(sum(A.new_action)*1.0/count(A.new_action)  as numeric (10,2)) as Conversion_Rate
FROM	(SELECT *,
		CASE [Action]
		WHEN 'Order' THEN 1	ELSE 0
		END new_action
		FROM sample1
		) A
GROUP BY A.[Adv_Type]


--SOLUTION OF THE INSTRUCTOR

CREATE TABLE #T1
(
id int,
adv_type char,
[action] varchar(10)
)
SELECT *
FROM #T1
INSERT INTO #T1 VALUES
(1,'A', 'Left'),
(2,'A', 'Order'),
(3,'B', 'Left'),
(4,'A', 'Order'),
(5,'A', 'Review'),
(6,'A', 'Left'),
(7,'B', 'Left'),
(8,'B', 'Order'),
(9,'B', 'Review'),
(10,'A', 'Review')


SELECT adv_type, COUNT(*) total_action
FROM actions 
GROUP BY adv_type

SELECT adv_type, COUNT(*) total_order
FROM actions 
WHERE action = 'order'
GROUP BY adv_type 

WITH CTE1 AS
(
SELECT adv_type,
		COUNT (*) total_action
FROM	#T1
GROUP BY adv_type
), CTE2 AS
(
SELECT adv_type, COUNT (*) order_action
FROM	#T1
WHERE action = 'Order'
GROUP BY adv_type
)
SELECT	CTE1.adv_type, CTE1.total_action, CTE2.order_action, cast(1.0*order_action/total_action as decimal(3,2)) AS conversion_rate
FROM	CTE1, CTE2
WHERE	CTE1.adv_type = CTE2.adv_type 

--3rd Solution
select n.[Adv_Type]
		,cast(sum(n.new_action)*1.0/count(n.new_action)  as numeric (10,2)) as Conversion_Rate
		from	(select * 
					,case [Action]
						when 'Order' then 1
						else 0
					end new_action
				from [Visitor].[Actions]
				) n
group by n.[Adv_Type] 

