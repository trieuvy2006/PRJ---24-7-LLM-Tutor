USE master;
GO

-- 1. Cưỡng chế ngắt kết nối và Xóa Database cũ (nếu có) để làm sạch
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'AITA_DB')
BEGIN
    ALTER DATABASE AITA_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AITA_DB;
END
GO

-- 2. Tạo mới Database AITA_DB
CREATE DATABASE AITA_DB;
GO
USE AITA_DB;
GO

-- =========================================================
-- 3. TẠO CÁC BẢNG DỮ LIỆU (TABLES)
-- =========================================================

-- 3.1 Bảng Roles (Vai trò người dùng)
CREATE TABLE Roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL UNIQUE
);

-- 3.2 Bảng Classes (Lớp học sinh hoạt / chuyên ngành)
CREATE TABLE Classes (
    class_id INT IDENTITY(1,1) PRIMARY KEY,
    class_code VARCHAR(20) NOT NULL UNIQUE,
    class_name NVARCHAR(100) NOT NULL
);

-- 3.3 Bảng Users (Tài khoản người dùng: Admin, Giảng viên, Sinh viên)
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    role_id INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NULL,
    student_code VARCHAR(20) NULL, -- Bỏ UNIQUE inline vì trong T-SQL UNIQUE mặc định chỉ cho phép 1 giá trị NULL
    class_id INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    CONSTRAINT FK_Users_Classes FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);
GO

-- Tạo Filtered Unique Index cho student_code (cho phép nhiều tài khoản không phải sinh viên có student_code NULL)
CREATE UNIQUE NONCLUSTERED INDEX UQ_Users_student_code 
ON Users(student_code) 
WHERE student_code IS NOT NULL;
GO

-- 3.4 Bảng Courses (Môn học)
CREATE TABLE Courses (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX)
);

-- 3.5 Bảng Course_Enrollments (Sinh viên đăng ký môn học)
CREATE TABLE Course_Enrollments (
    enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Enrollments_Users FOREIGN KEY (student_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Enrollments_Courses FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT UQ_Student_Course UNIQUE (student_id, course_id)
);

-- 3.6 Bảng Assignments (Bài tập môn học)
CREATE TABLE Assignments (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    created_by INT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX),
    deadline DATETIME NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
	CONSTRAINT FK_Assignments_Courses FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT FK_Assignments_Users FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

-- 3.7 Bảng Submissions (Bài nộp của sinh viên)
CREATE TABLE Submissions (
    submission_id INT IDENTITY(1,1) PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    sha256_hash VARCHAR(64) NOT NULL UNIQUE,
    file_path VARCHAR(255) NOT NULL,
    attempt_number INT NOT NULL DEFAULT 1,
    submitted_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT FK_Submissions_Assignments FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id),
    CONSTRAINT FK_Submissions_Users FOREIGN KEY (student_id) REFERENCES Users(user_id),
    CONSTRAINT CHK_Submission_Status CHECK (status IN ('PENDING', 'PROCESSING', 'GRADED', 'FAILED'))
);

-- 3.8 Bảng Grades (Điểm số & Phản hồi)
CREATE TABLE Grades (
    grade_id INT IDENTITY(1,1) PRIMARY KEY,
    submission_id INT NOT NULL UNIQUE,
    score DECIMAL(4,2) CHECK (score >= 0 AND score <= 10),
    feedback NVARCHAR(MAX),
    graded_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Grades_Submissions FOREIGN KEY (submission_id) REFERENCES Submissions(submission_id)
);

-- 3.9 Bảng Tutor_Sessions (Phiên tư vấn của AI Tutor)
CREATE TABLE Tutor_Sessions (
    session_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    submission_id INT NULL,
    error_type VARCHAR(100) NULL,
    raw_error_message NVARCHAR(MAX) NULL,
    started_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TutorSessions_Users FOREIGN KEY (student_id) REFERENCES Users(user_id),
    CONSTRAINT FK_TutorSessions_Submissions FOREIGN KEY (submission_id) REFERENCES Submissions(submission_id) ON DELETE SET NULL
);

-- 3.10 Bảng Tutor_Messages (Tin nhắn hội thoại giữa Sinh viên & AI Tutor)
CREATE TABLE Tutor_Messages (
    message_id INT IDENTITY(1,1) PRIMARY KEY,
    session_id INT NOT NULL,
    sender_type VARCHAR(10) NOT NULL,
    message_text NVARCHAR(MAX) NOT NULL,
    sent_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TutorMessages_Sessions FOREIGN KEY (session_id) REFERENCES Tutor_Sessions(session_id) ON DELETE CASCADE,
    CONSTRAINT CHK_Sender_Type CHECK (sender_type IN ('STUDENT', 'LLM_TUTOR'))
);

-- 3.11 Bảng Personalized_Learning_Paths (Lộ trình học tập cá nhân hóa)
CREATE TABLE Personalized_Learning_Paths (
    path_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    weakness_topic NVARCHAR(150) NOT NULL,
    recommended_action NVARCHAR(MAX) NOT NULL,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS',
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_LearningPaths_Users FOREIGN KEY (student_id) REFERENCES Users(user_id),
	CONSTRAINT CHK_Path_Status CHECK (status IN ('IN_PROGRESS', 'COMPLETED', 'SKIPPED'))
);
GO

-- =========================================================
-- 4. CHÈN DỮ LIỆU MẪU (SAMPLE DATA)
-- =========================================================

-- 4.1 Bảng Roles
INSERT INTO Roles (role_name) VALUES 
('ADMIN'), 
('INSTRUCTOR'), 
('STUDENT');

-- 4.2 Bảng Classes
INSERT INTO Classes (class_code, class_name) VALUES 
('SE1801', N'Kỹ thuật Phần mềm 1801'),
('SE1802', N'Kỹ thuật Phần mềm 1802'),
('IA1701', N'An toàn Thông tin 1701');

-- 4.3 Bảng Users
INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES 
(1, 'admin', 'hash_admin_123', N'Nguyễn Văn Quản Trị', 'admin@fe.edu.vn', '0901234567', NULL, NULL),
(2, 'dungkt', 'hash_dungkt_123', N'Nguyễn Văn Dũng', 'dungkt@fe.edu.vn', '0912345678', NULL, NULL),
(2, 'haonn', 'hash_haonn_123', N'Nguyễn Nhật Hào', 'haonn@fe.edu.vn', '0912345679', NULL, NULL),
(3, 'duynd', 'hash_duynd_123', N'Nguyễn Đức Duy', 'duyndse180000@fpt.edu.vn', '0987654321', 'SE180000', 1),
(3, 'vynt', 'hash_vynt_123', N'Nhật Tường Vy', 'vyntse180001@fpt.edu.vn', '0987654322', 'SE180001', 1),
(3, 'khoana', 'hash_khoana_123', N'Nguyễn Anh Khoa', 'khoanase180002@fpt.edu.vn', '0987654323', 'SE180002', 1),
(3, 'baov', 'hash_baov_123', N'Văn Bảo', 'baovse180003@fpt.edu.vn', '0987654324', 'SE180003', 2),
(3, 'tuanna', 'hash_tuanna_123', N'Nguyễn Anh Tuấn', 'tuannase170001@fpt.edu.vn', '0987654325', 'IA170001', 3);

-- 4.4 Bảng Courses
INSERT INTO Courses (course_code, course_name, description) VALUES 
('PRJ301', N'Lập trình Java Web', N'Phát triển ứng dụng Web MVC2 với Java Servlet, JSP và JDBC'),
('DBW301', N'Cơ sở dữ liệu nâng cao', N'Thiết kế, quản trị và tối ưu hóa truy vấn CSDL SQL Server'),
('SWP391', N'Dự án Phần mềm Mẫu', N'Thực hành quy trình phát triển phần mềm theo mô hình Agile/Scrum');

-- 4.5 Bảng Course_Enrollments
INSERT INTO Course_Enrollments (student_id, course_id) VALUES 
(4, 1), (4, 2), (5, 1), (5, 3), (6, 1), (7, 2), (8, 3);

-- 4.6 Bảng Assignments
INSERT INTO Assignments (course_id, created_by, title, description, deadline) VALUES 
(1, 2, N'Milestone 1 - Cấu trúc MVC & Setup Framework', N'Vẽ sơ đồ MVC2 và tạo bộ khung dự án Java Web trống', '2026-09-30 23:59:59'),
(1, 2, N'Milestone 2 - Xây dựng Cổng Nộp Bài (Submission Portal)', N'Lập trình Servlet/JSP upload file nén ZIP và mã băm SHA-256', '2026-10-15 23:59:59'),
(2, 3, N'Assignment 1 - Thiết kế Database chuẩn 3NF', N'Thiết kế sơ đồ ERD và viết kịch bản SQL Script tạo bảng', '2026-10-05 23:59:59');

-- 4.7 Bảng Submissions
INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status) VALUES
(1, 4, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '/uploads/PRJ301/M1_SE180000_v1.zip', 1, 'GRADED'),
(1, 5, 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', '/uploads/PRJ301/M1_SE180001_v1.zip', 1, 'GRADED'),
(1, 6, '5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9', '/uploads/PRJ301/M1_SE180002_v1.zip', 1, 'FAILED'),
(2, 4, '4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a', '/uploads/PRJ301/M2_SE180000_v1.zip', 1, 'PENDING');

-- 4.8 Bảng Grades
INSERT INTO Grades (submission_id, score, feedback) VALUES 
(1, 9.50, N'Cấu trúc package MVC rất chuẩn, trình bày rõ ràng.'),
(2, 8.75, N'Tốt, cần hoàn thiện thêm lớp DBUtils kết nối CSDL.');

-- 4.9 Bảng Tutor_Sessions
INSERT INTO Tutor_Sessions (student_id, submission_id, error_type, raw_error_message) VALUES 
(4, 1, 'NullPointerException', N'java.lang.NullPointerException: Cannot invoke "com.aita.model.dao.ErrorLogDAO.saveErrorLog()" because "this.errorLogDAO" is null'),
(6, 3, 'ClassNotFoundException', N'java.lang.ClassNotFoundException: com.microsoft.sqlserver.jdbc.SQLServerDriver'),
(5, NULL, 'SyntaxError', N'tutor-chat.jsp (line: 15, column: 12) Unterminated string literal');

-- 4.10 Bảng Tutor_Messages
INSERT INTO Tutor_Messages (session_id, sender_type, message_text) VALUES 
(1, 'STUDENT', N'Em bấm nút Submit thì bị lỗi NullPointerException ở dòng 24 TutorServlet.java, nhờ Tutor chỉ giúp lỗi ở đâu ạ?'),
(1, 'LLM_TUTOR', N'Chào bạn Duy! Lỗi `NullPointerException` xảy ra vì biến `errorLogDAO` chưa được khởi tạo trước khi gọi phương thức `saveErrorLog()`. Bạn hãy kiểm tra xem đã sử dụng từ khóa `new ErrorLogDAO()` trước khi dùng chưa nhé!'),
(1, 'STUDENT', N'Dạ em đã thêm `this.errorLogDAO = new ErrorLogDAO();` trong hàm `init()` của Servlet và code đã chạy tốt! Em cảm ơn Tutor.'),
(2, 'STUDENT', N'Em không kết nối được SQL Server, hệ thống báo ClassNotFoundException Driver ạ.'),
(2, 'LLM_TUTOR', N'Lỗi này xuất hiện do dự án của bạn chưa thêm thư viện mssql-jdbc-xx.jar vào thư mục WEB-INF/lib hoặc POM dependency.');

-- 4.11 Bảng Personalized_Learning_Paths
INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status) VALUES
(6, N'Quản lý ngoại lệ & JDBC Driver', N'Xem lại bài giảng Kết nối CSDL SQL Server trong Java và thêm file Driver JAR vào classpath.', 'IN_PROGRESS'),
(5, N'Cú pháp JSP & JSTL Standard Tag Library', N'Kiểm tra lại các thẻ đóng mở chuỗi ký tự trong file JSP.', 'IN_PROGRESS');
GO