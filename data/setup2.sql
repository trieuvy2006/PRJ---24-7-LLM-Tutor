USE AITA_DB;
GO

-- 1. Tạo bảng phân công Giảng viên Instructor_Courses (nếu chưa có)
IF OBJECT_ID('dbo.Instructor_Courses', 'U') IS NULL
BEGIN
    CREATE TABLE Instructor_Courses (
        assignment_id INT IDENTITY(1,1) PRIMARY KEY,
        instructor_id INT NOT NULL,
        course_id INT NOT NULL,
        class_id INT NULL,
        shift_name NVARCHAR(50) NOT NULL,
        room_number NVARCHAR(20) NOT NULL,
        CONSTRAINT FK_IC_Instructor FOREIGN KEY (instructor_id) REFERENCES Users(user_id),
        CONSTRAINT FK_IC_Course FOREIGN KEY (course_id) REFERENCES Courses(course_id),
        CONSTRAINT FK_IC_Class FOREIGN KEY (class_id) REFERENCES Classes(class_id)
    );
END
GO

-- 2. Thêm 2 lớp học mới (SE1803, SE1804)
IF NOT EXISTS (SELECT 1 FROM Classes WHERE class_code = 'SE1803')
    INSERT INTO Classes (class_code, class_name) VALUES ('SE1803', 'Software Requirements Engineering');

IF NOT EXISTS (SELECT 1 FROM Classes WHERE class_code = 'SE1804')
    INSERT INTO Classes (class_code, class_name) VALUES ('SE1804', 'Elementary Japanese Communication');
GO

-- 3. Thêm 2 tài khoản Giảng viên mới (phuctm, maianhnt)
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'phuctm')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id)
    VALUES (2, 'phuctm', 'hash_phuctm_123', N'Trần Minh Phúc', 'phuctm@fe.edu.vn', '0912345680', NULL, NULL);

IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'maianhnt')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id)
    VALUES (2, 'maianhnt', 'hash_maianhnt_123', N'Nguyễn Thị Mai Anh', 'maianhnt@fe.edu.vn', '0912345681', NULL, NULL);
GO

-- 4. Cập nhật phân công giảng dạy mẫu
DELETE FROM Instructor_Courses;
INSERT INTO Instructor_Courses (instructor_id, course_id, class_id, shift_name, room_number) VALUES
(2, 2, 1, N'Ca 2 (09:30 - 11:50)', N'Phòng 302'),  -- dungkt dạy PRJ301 lớp SE1801
(2, 5, 2, N'Ca 3 (13:00 - 15:20)', N'Phòng 204'),  -- dungkt dạy CSD201 lớp SE1802
(3, 1, 3, N'Ca 4 (15:30 - 17:50)', N'Phòng 405'),  -- haonn dạy IOT102 lớp AI1701
(9, 3, 4, N'Ca 1 (07:00 - 09:20)', N'Phòng 301'),  -- phuctm dạy SWR302 lớp SE1803
(9, 3, 1, N'Ca 3 (13:00 - 15:20)', N'Phòng 303'),  -- phuctm dạy SWR302 lớp SE1801
(10, 4, 5, N'Ca 2 (09:30 - 11:50)', N'Phòng 510'), -- maianhnt dạy JPD123 lớp SE1804
(10, 4, 1, N'Ca 4 (15:30 - 17:50)', N'Phòng 512'); -- maianhnt dạy JPD123 lớp SE1801
GO
