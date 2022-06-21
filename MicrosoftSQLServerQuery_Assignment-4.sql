--------- Assignment-4  - 19-06-2022 --------------


--Discount Effects

--Generate a report including product IDs and discount effects 
--on whether the increase in the discount rate positively impacts the number of orders for the products.
--In this assignment, you are expected to generate a solution using SQL with a logical approach.  

/*Sample Result:
Product_id	Discount Effect
1	Positive
2	Negative
3	Negative
4	Neutral
*/ 



SELECT product_id, discount, SUM(quantity) SumQuantity 
FROM sale.order_item 
GROUP BY product_id, discount 
ORDER BY 1, 2 
;

--In other codes
SELECT DISTINCT product_id, discount, 
        SUM(quantity) OVER (PARTITION BY product_id, discount ORDER BY product_id, discount) SumQuantity
FROM sale.order_item
;
--
SELECT DISTINCT product_id, discount, 
        SUM(quantity) OVER (PARTITION BY product_id, discount ORDER BY product_id, discount) SumQuantity,
        SUM(quantity) OVER (PARTITION BY product_id) TotalQuantity
FROM sale.order_item
;
----
SELECT DISTINCT product_id, discount, 
        SUM(quantity) OVER (PARTITION BY product_id, discount ORDER BY product_id, discount) SumQuantity,
        SUM(quantity) OVER (PARTITION BY product_id) TotalQuantity
INTO #TBL1 
FROM sale.order_item
; 
---
SELECT *,
        CAST(100.0*SumQuantity/TotalQuantity AS decimal (5,2)) PercentQuantity
FROM #TBL1
;
---
SELECT *,
        CAST(100.0*SumQuantity/TotalQuantity AS decimal (5,2)) PercentQuantity 
INTO #TBL2
FROM #TBL1
;
---

SELECT *,
    FIRST_VALUE(PercentQuantity)
            OVER(PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MinDiscPer,
    LAST_VALUE(PercentQuantity)
            OVER(PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MaxDiscPer
FROM #TBL2
---
SELECT *,
    FIRST_VALUE(PercentQuantity)
            OVER(PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MinDiscPer,
    LAST_VALUE(PercentQuantity)
            OVER(PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MaxDiscPer
INTO #TBL3
FROM #TBL2
---
SELECT *,
        CASE WHEN MaxDiscPer > MinDiscPer THEN 'Positive'
             WHEN MaxDiscPer < MinDiscPer THEN 'Negative'
             ELSE 'Neutral'
        END AS DiscountEffect
INTO #TBL4
FROM #TBL3 
;
---
SELECT DISTINCT *
FROM #TBL4
---
SELECT DISTINCT product_id, DiscountEffect
FROM #TBL4
ORDER BY 1 



--------------------------
--Solution of the Instructor

SELECT product_id, discount, SUM(quantity) SumQuantity
FROM sale.order_item 
GROUP BY product_id, discount 
ORDER BY 1, 2 

---Uygulanan en düşük indirim oranında satılan ürün miktarı ile 
--en yüksek indirim oranıbda satılan ürün miktarı arasındaki farkın 
--uygulanan en düşük indirim oranına bölünmesiyle 
--elde edilecek artış oranı 

WITH T1 AS 
        (
        SELECT product_id, discount, SUM(quantity) SumQuantity 
        FROM sale.order_item
        GROUP BY product_id, discount 
        ), T2 AS 
        (
        SELECT *,
                FIRST_VALUE(SumQuantity)
                        OVER (PARTITION BY product_id ORDER BY discount) MinDisQuantity,
                LAST_VALUE(SumQuantity)
                        OVER (PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MaxDisQuantity
        FROM T1
        ), T3 AS 
        (
        SELECT DISTINCT product_id, 1.0*(MaxDisQuantity-MinDisQuantity)/MinDisQuantity IncRate
        FROM T2
        )
        
        SELECT product_id, 
                CASE 
                        WHEN IncRate >= 0.05 THEN 'Positive'
                        WHEN IncRate <= -0.05 THEN 'Negative'
                        ELSE 'Neutral'
                END DiscountEffect
        FROM T3

---------------
--IMPORT

--Create new DB (Project)
--Tasks-->Import Flat File(csv için) (İlerle, Use rich data seçeneği işaretli olsun.)


--Tasks-->Import Data (excel için)