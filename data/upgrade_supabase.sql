-- Cập nhật bảng Submissions để hỗ trợ lưu Cloud URL Supabase Storage
USE AITA_DB;
GO

-- Mở rộng độ dài cột file_path lên VARCHAR(500)
ALTER TABLE Submissions ALTER COLUMN file_path VARCHAR(500) NOT NULL;
GO

PRINT N'Cập nhật thành công! Bảng Submissions đã sẵn sàng lưu URL Supabase Storage.';
GO
