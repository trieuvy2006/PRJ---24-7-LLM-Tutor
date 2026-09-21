-- Run this once in SQL Server Management Studio after creating AITA_DB.
USE AITA_DB;
GO

IF OBJECT_ID('dbo.Messages', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Messages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        content NVARCHAR(255) NOT NULL,
        created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );
END
GO
