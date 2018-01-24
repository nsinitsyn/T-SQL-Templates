INSERT INTO Sales.MyOrdersArchive(orderid, custid, empid, orderdate)
SELECT orderid, custid, empid, orderdate
FROM (DELETE FROM Sales.MyOrders
OUTPUT deleted.*
WHERE orderdate < '20070101') AS D
WHERE custid IN (17, 19);