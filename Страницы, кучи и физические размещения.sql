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


-- Код проверки внутренней (столбец avg_page_space_used_in_percent) и внешней (столбец avg_fragmentation_in_percent) фрагментации
SELECT index_level, page_count, avg_page_space_used_in_percent, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), OBJECT_ID(N'dbo.TestStructure'), NULL, NULL, 'DETAILED')


-- Перестроить индекс (при внешней фрагментации > 30%)
ALTER INDEX idx_cl_filler1 ON dbo.TestStructure REBUILD;


-- Реорганизовать индекс (при внешней фрагментации < 30%)
ALTER INDEX idx_cl_filler1 ON dbo.TestStructure REORGANIZE;


-- Статистика использования индекса
SELECT OBJECT_NAME(S.object_id) AS table_name,
	I.name AS index_name, S.user_seeks,
	S.user_scans, s.user_lookups
FROM sys.dm_db_index_usage_stats AS S
	INNER JOIN sys.indexes AS i
		ON S.object_id = I.object_id
			AND S.index_id = I.index_id
WHERE S.object_id = OBJECT_ID(N'Sales.Orders', N'U');