-- Run this in SQL Server Management Studio after selecting database AITA_DB.
USE AITA_DB;
GO

-- 1. Create Users table required by UserDAO
IF OBJECT_ID('dbo.Users', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users (
        user_id INT IDENTITY(1,1) PRIMARY KEY,
        role_id INT NOT NULL DEFAULT 2,
        username NVARCHAR(50) NOT NULL UNIQUE,
        password_hash NVARCHAR(255) NOT NULL DEFAULT '123456',
        full_name NVARCHAR(100) NOT NULL,
        email NVARCHAR(100) NULL,
        phone NVARCHAR(20) NULL,
        created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );
END
GO

-- 2. Insert sample data into Users table
IF NOT EXISTS (SELECT 1 FROM dbo.Users)
BEGIN
    INSERT INTO dbo.Users (role_id, username, password_hash, full_name, email, phone)
    VALUES 
    (1, 'admin', '123456', N'Quản trị viên AITA', 'admin@aita.edu.vn', '0901234567'),
    (2, 'trieuvy', '123456', N'Triệu Vy', 'vy@gmail.com', '0912345678'),
    (2, 'student1', '123456', N'Nguyễn Văn A', 'nguyenvana@gmail.com', '0987654321');
END
GO

-- 3. Create Messages table
IF OBJECT_ID('dbo.Messages', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Messages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        content NVARCHAR(255) NOT NULL,
        created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );
END
GO

