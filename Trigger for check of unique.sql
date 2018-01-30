IF OBJECT_ID('Production.tr_ProductionCategories_categoryname', 'TR')
	IS NOT NULL
DROP TRIGGER Production.tr_ProductionCategories_categoryname;
GO
CREATE TRIGGER Production.tr_ProductionCategories_categoryname
ON Production.Categories
AFTER INSERT, UPDATE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	IF EXISTS (SELECT COUNT(*) FROM Inserted AS I
			  JOIN Production.Categories AS C
			  ON I.categoryname = C.categoryname
			  GROUP BY I.categoryname
			  HAVING COUNT(*) > 1 )
	BEGIN
		THROW 50000, 'Duplicate category names not allowed', 0;
		END;
END;
GO

INSERT INTO Production.Categories (categoryname, description)
VALUES ('TestCategory1', 'Test1 description v1');

UPDATE Production.Categories SET categoryname = 'Beverages'
WHERE categoryname = 'TestCategory1';