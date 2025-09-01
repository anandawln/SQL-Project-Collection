--select * from product_category pc

--select MAX(pc."Quantity") from product_category pc

--select MIN(pc."Quantity") from product_category pc 

--select count(distinct pc."ProdNumber") from product_category pc 
--where pc."Quantity" = 6 

--select pc."ProdNumber" from product_category pc
--where pc."Quantity" = 6

CREATE TABLE product_total AS
SELECT pc."ProdNumber", SUM(pc."Quantity") AS TotalQuantity
FROM product_category pc
GROUP BY pc."ProdNumber";
