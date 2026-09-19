IF DB_ID('AITA_DB') IS NULL
BEGIN
    CREATE DATABASE AITA_DB;
END
GO

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'llm_tutor')
BEGIN
    CREATE LOGIN [llm_tutor]
    WITH PASSWORD = 'ChangeMe_123!',
         CHECK_POLICY = OFF,
         CHECK_EXPIRATION = OFF,
         DEFAULT_DATABASE = [AITA_DB];
END
ELSE
BEGIN
    ALTER LOGIN [llm_tutor] ENABLE;
    ALTER LOGIN [llm_tutor] WITH DEFAULT_DATABASE = [AITA_DB];
END
GO

GRANT CONNECT SQL TO [llm_tutor];

IF EXISTS (SELECT 1 FROM sys.endpoints WHERE name = 'TSQL Default TCP')
BEGIN
    GRANT CONNECT ON ENDPOINT::[TSQL Default TCP] TO [llm_tutor];
END
GO

USE AITA_DB;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'llm_tutor')
BEGIN
    CREATE USER [llm_tutor] FOR LOGIN [llm_tutor];
END
ELSE
BEGIN
    ALTER USER [llm_tutor] WITH LOGIN = [llm_tutor];
END
GO

ALTER ROLE db_datareader ADD MEMBER [llm_tutor];
ALTER ROLE db_datawriter ADD MEMBER [llm_tutor];
GO

IF OBJECT_ID('dbo.ErrorLogs', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ErrorLogs (
        id INT IDENTITY(1,1) PRIMARY KEY,
        source NVARCHAR(255) NOT NULL,
        message NVARCHAR(MAX) NOT NULL,
        created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO
