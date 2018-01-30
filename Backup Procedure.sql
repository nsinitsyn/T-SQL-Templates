IF OBJECT_ID('dbo.BackupDatabases', 'P') IS NOT NULL
	DROP PROCEDURE dbo.BackupDatabases;
GO
CREATE PROCEDURE dbo.BackupDatabases
	@databasetype AS NVARCHAR(30)
AS
BEGIN
	DECLARE @databasename AS NVARCHAR(128),
			@timecomponent AS NVARCHAR(50),
			@sqlcommand AS NVARCHAR(1000);
	IF @databasetype NOT IN ('User', 'System')
	BEGIN
		THROW 50000, 'dbo.BackupDatabases: @databasetype must be User or System', 0;
		RETURN;
	END;
	IF @databasetype = 'System'
		SET @databasename = (SELECT MIN(name) FROM sys.databases
							WHERE name IN ('master', 'model', 'msdb'));
	ELSE
		SET @databasename = (SELECT MIN(name) FROM sys.databases
							WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb'));
	WHILE @databasename IS NOT NULL
	BEGIN
		SET @timecomponent = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, GETDATE(), 120), ' ', '_'), ':', ''), '-', '');
		SET @sqlcommand = 'BACKUP DATABASE ' + @databasename +
						  ' TO DISK = ''C:\Backups\' + @databasename + '_' +
						  @timecomponent + '.bak''';
		PRINT @sqlcommand;
		EXEC(@sqlcommand);
		IF @databasetype = 'System'
			SET @databasename = (SELECT MIN(name) FROM sys.databases
								WHERE name IN ('master', 'model', 'msdb')
								AND name > @databasename);
		ELSE
			SET @databasename = (SELECT MIN(name) FROM sys.databases
								WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
								AND name > @databasename);
	END;
	RETURN;
END;
GO

EXEC dbo.BackupDatabases @databasetype = 'User';