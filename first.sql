DECLARE @t AS TABLE
(orderid INT NOT NULL PRIMARY KEY,
custid INT NOT NULL,
empid INT NOT NULL,
orderdate DATE NOT NULL);

INSERT INTO @t(orderid, custid, empid, orderdate)
VALUES(1, 70, 1, '20061218'),
(2, 70, 7, '20070429'),
(3, 70, 7, '20070820'),
(4, 70, 3, '20080114'),
(5, 70, 1, '20080226'),
(6, 70, 2, '20080410');

SELECT * FROM @t;