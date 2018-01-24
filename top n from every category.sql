-- Напишите запрос к таблице Sales.Orders и отфильтруйте три заказа 
-- с наибольшим значением затрат на транспортировку (столбец freight) по
-- каждому грузоотправителю (столбец shipperid)

-- Окна, CTE, ранжирующая оконная функция
WITH cte1 AS
(
SELECT orderid, custid, shipperid, freight,
	ROW_NUMBER() OVER(PARTITION BY shipperid
	                  ORDER BY freight DESC, orderid) AS rownum
FROM Sales.Orders
)
SELECT shipperid, orderid, freight
FROM cte1
WHERE rownum <= 3
ORDER BY shipperid, freight DESC, orderid;


-- CROSS APPLY, табличное выражение
SELECT DISTINCT O.shipperid, P.*
FROM Sales.Orders AS O
	CROSS APPLY
	(SELECT TOP(3) orderid, freight
	 FROM Sales.Orders AS O2
	 WHERE O.shipperid = O2.shipperid
	 ORDER BY shipperid, freight DESC
	) AS P
ORDER BY O.shipperid, P.freight DESC, P.orderid;


-- Подзапрос, табличное выражение - ! НЕ РАБОТАЕТ
SELECT DISTINCT O1.shipperid, T.* 
FROM Sales.Orders AS O1
INNER JOIN
	(SELECT TOP(3) orderid, freight, custid
	 FROM Sales.Orders AS O2
	 ORDER BY shipperid, freight DESC
	) AS T
ON O1.custid = T.custid 
ORDER BY O1.shipperid, T.freight DESC, T.orderid;
