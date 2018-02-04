-- Информация об SQL Сервере
SELECT cpu_count AS logical_cpu_count,
	cpu_count / hyperthread_ratio AS physical_cpu_count,
	CAST(physical_memory_kb / 1024. AS int) AS physical_memory__mb,
	sqlserver_start_time
FROM sys.dm_os_sys_info;


-- Получение сеансов, находящихся в ожидании, с игнорированием системных сеансов
SELECT S.login_name, S.host_name, S.program_name,
	WT.session_id, WT.wait_duration_ms,
	WT.wait_type, WT.blocking_session_id, WT.resource_description
FROM sys.dm_os_waiting_tasks AS WT
	INNER JOIN sys.dm_exec_sessions AS S
		ON WT.session_id = S.session_id
WHERE s.is_user_process = 1;


-- Текущие выполняющиеся запросы с пользователем, хостом, приложением и полным текстом sql-запроса
SELECT S.login_name, S.host_name, S.program_name,
	R.command, T.text,
	R.wait_type, R.wait_time, R.blocking_session_id
FROM sys.dm_exec_requests AS R
	INNER JOIN sys.dm_exec_sessions AS S
		ON R.session_id = S.session_id
	OUTER APPLY sys.dm_exec_sql_text(R.sql_handle) AS T
WHERE S.is_user_process = 1;

-- 5 запросов, использовавших большую часть логических операций ввода-вывода, а также текст запроса, извлеченный из текста пакета
SELECT TOP (5)
	(total_logical_reads + total_logical_writes) AS total_logical_IO,
	execution_count,
	(total_logical_reads/execution_count) AS avg_logical_reads,
	(total_logical_writes/execution_count) AS avg_logical_writes,
	(SELECT SUBSTRING(text, statement_start_offset/2 + 1,
		(CASE WHEN statement_end_offset = -1
			THEN LEN(CONVERT(nvarchar(MAX),text)) * 2
			ELSE statement_end_offset
		END - statement_start_offset)/2)
	FROM sys.dm_exec_sql_text(sql_handle)) AS query_text
FROM sys.dm_exec_query_stats
ORDER BY (total_logical_reads + total_logical_writes) DESC;

-- Информация об отсутствующих индексах
SELECT DB.name AS database_name, O.name AS object_name, D.*, C.* FROM sys.dm_db_missing_index_details AS D
	INNER JOIN sys.objects AS O
		ON D.object_id = O.object_id
	INNER JOIN sys.databases AS DB
		ON D.database_id = DB.database_id
	OUTER APPLY sys.dm_db_missing_index_columns(D.index_handle) AS C;


-- Также об индекса
SELECT * FROM sys.dm_db_missing_index_details
SELECT * FROM sys.dm_db_missing_index_columns();
SELECT * FROM sys.dm_db_missing_index_groups;
SELECT * FROM sys.dm_db_missing_index_group_stats;

-- Всякое разное
select S.*, T.* from sys.dm_exec_query_stats AS S
	OUTER APPLY sys.dm_exec_query_plan(S.plan_handle) AS T



SELECT norderid
FROM dbo.NewOrders
WHERE norderid = 110248
ORDER BY norderid;