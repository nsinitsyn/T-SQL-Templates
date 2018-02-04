
-- Способ хранения таблицы или индекса
SELECT OBJECT_NAME(object_id) AS table_name,
	name AS index_name, type, type_desc
FROM sys.indexes
WHERE object_id = OBJECT_ID(N'dbo.TestStructure', N'U');

-- Код проверки выделения кучи - сколько страниц используется под объект
-- Столбец avg_space_used_in_percent - Внутренния фрагментация
SELECT index_type_desc, page_count, record_count, avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'dbo.TestStructure'), NULL, NULL , 'DETAILED');
EXEC dbo.sp_spaceused @objname = N'dbo.TestStructure', @updateusage = true;

-- Код проверки выделения кластеризованного индекса
SELECT index_type_desc, index_depth, index_level, page_count, record_count, avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'dbo.TestStructure'), NULL, NULL, 'DETAILED');


TRUNCATE TABLE dbo.TestStructure;
DECLARE @i AS int = 0;
WHILE @i < 8908
BEGIN
SET @i = @i + 1;
INSERT INTO dbo.TestStructure (id, filler1, filler2)
VALUES (@i % 100, 'a', 'b');
END;