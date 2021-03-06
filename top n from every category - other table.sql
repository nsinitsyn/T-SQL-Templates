-- Для каждого продукта X вывести максимальную цену среди цен всех продуктов поставщика продукта X

-- INNER JOIN и табличное выражение (как производная таблица D)

SELECT P2.productid, P2.supplierid, P2.unitprice, D.maxprice
FROM Production.Products AS P2
INNER JOIN
	(SELECT P.supplierid, MAX(unitprice) AS maxprice
	FROM Production.Products AS P
	GROUP BY P.supplierid) AS D
ON D.supplierid = P2.supplierid


-- CROSS APPLY

SELECT P2.productid, P2.supplierid, P2.unitprice, D.*
FROM Production.Products AS P2
CROSS APPLY
	(SELECT MAX(unitprice) AS maxprice
	FROM Production.Products AS P
	GROUP BY P.supplierid
	HAVING P.supplierid = P2.supplierid) AS D



-- Вывести 5 самых дешевых товара для каждого поставщика

-- CROSS APPLY
SELECT S.supplierid, S.companyname, P.*
FROM Production.Suppliers AS S
	CROSS APPLY
	(SELECT TOP(2) productid, productname, unitprice 
	FROM Production.Products
	WHERE supplierid = S.supplierid
	ORDER BY unitprice, productid) AS P


-- INNER JOIN