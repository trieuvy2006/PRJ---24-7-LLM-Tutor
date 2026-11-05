USE AITA_DB;
GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT N'Bắt đầu thêm 100 sinh viên và dữ liệu bài nộp mẫu thực tế...';
GO

-- 1. Chèn 100 sinh viên mới (chia đều vào 5 lớp)
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180005')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180005', 'hash_student_123', N'Phạm Văn Ngọc', 'sv_se180005@fpt.edu.vn', '0937518734', 'SE180005', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180006')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180006', 'hash_student_123', N'Đỗ Thị Quang', 'sv_se180006@fpt.edu.vn', '0915360909', 'SE180006', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180007')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180007', 'hash_student_123', N'Phạm Khánh Thịnh', 'sv_se180007@fpt.edu.vn', '0961108869', 'SE180007', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180008')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180008', 'hash_student_123', N'Đỗ Thanh Toàn', 'sv_se180008@fpt.edu.vn', '0990860037', 'SE180008', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180009')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180009', 'hash_student_123', N'Phạm Đức Tùng', 'sv_se180009@fpt.edu.vn', '0939505652', 'SE180009', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180010')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180010', 'hash_student_123', N'Đỗ Hoàng Vy', 'sv_se180010@fpt.edu.vn', '0958879509', 'SE180010', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180011')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180011', 'hash_student_123', N'Phạm Anh Châu', 'sv_se180011@fpt.edu.vn', '0957378366', 'SE180011', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180012')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180012', 'hash_student_123', N'Đỗ Ngọc Giang', 'sv_se180012@fpt.edu.vn', '0911375865', 'SE180012', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180013')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180013', 'hash_student_123', N'Phạm Minh Huy', 'sv_se180013@fpt.edu.vn', '0943856074', 'SE180013', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180014')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180014', 'hash_student_123', N'Đỗ Bảo Long', 'sv_se180014@fpt.edu.vn', '0988530405', 'SE180014', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180015')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180015', 'hash_student_123', N'Phạm Tuấn Nhân', 'sv_se180015@fpt.edu.vn', '0923173057', 'SE180015', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180016')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180016', 'hash_student_123', N'Đỗ Hữu Tài', 'sv_se180016@fpt.edu.vn', '0942636519', 'SE180016', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180017')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180017', 'hash_student_123', N'Phạm Quốc Thư', 'sv_se180017@fpt.edu.vn', '0964323385', 'SE180017', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180018')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180018', 'hash_student_123', N'Đỗ Gia Trinh', 'sv_se180018@fpt.edu.vn', '0967593887', 'SE180018', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180019')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180019', 'hash_student_123', N'Phạm Phương Vân', 'sv_se180019@fpt.edu.vn', '0929486030', 'SE180019', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180020')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180020', 'hash_student_123', N'Đỗ Văn Yên', 'sv_se180020@fpt.edu.vn', '0989836232', 'SE180020', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180021')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180021', 'hash_student_123', N'Phạm Thị Dũng', 'sv_se180021@fpt.edu.vn', '0924865587', 'SE180021', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180022')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180022', 'hash_student_123', N'Đỗ Khánh Hà', 'sv_se180022@fpt.edu.vn', '0958756609', 'SE180022', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180023')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180023', 'hash_student_123', N'Phạm Thanh Khoa', 'sv_se180023@fpt.edu.vn', '0974391539', 'SE180023', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180024')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180024', 'hash_student_123', N'Đỗ Đức Nam', 'sv_se180024@fpt.edu.vn', '0989618201', 'SE180024', 1);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180025')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180025', 'hash_student_123', N'Lý Văn Giang', 'sv_se180025@fpt.edu.vn', '0935767250', 'SE180025', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180026')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180026', 'hash_student_123', N'Vũ Thị Huy', 'sv_se180026@fpt.edu.vn', '0970849735', 'SE180026', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180027')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180027', 'hash_student_123', N'Lý Khánh Long', 'sv_se180027@fpt.edu.vn', '0940931928', 'SE180027', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180028')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180028', 'hash_student_123', N'Vũ Thanh Nhân', 'sv_se180028@fpt.edu.vn', '0941053441', 'SE180028', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180029')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180029', 'hash_student_123', N'Lý Đức Tài', 'sv_se180029@fpt.edu.vn', '0960484854', 'SE180029', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180030')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180030', 'hash_student_123', N'Vũ Hoàng Thư', 'sv_se180030@fpt.edu.vn', '0927929227', 'SE180030', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180031')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180031', 'hash_student_123', N'Lý Anh Trinh', 'sv_se180031@fpt.edu.vn', '0976390627', 'SE180031', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180032')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180032', 'hash_student_123', N'Vũ Ngọc Vân', 'sv_se180032@fpt.edu.vn', '0915536289', 'SE180032', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180033')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180033', 'hash_student_123', N'Lý Minh Yên', 'sv_se180033@fpt.edu.vn', '0982997282', 'SE180033', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180034')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180034', 'hash_student_123', N'Vũ Bảo Dũng', 'sv_se180034@fpt.edu.vn', '0983271881', 'SE180034', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180035')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180035', 'hash_student_123', N'Lý Tuấn Hà', 'sv_se180035@fpt.edu.vn', '0978475084', 'SE180035', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180036')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180036', 'hash_student_123', N'Vũ Hữu Khoa', 'sv_se180036@fpt.edu.vn', '0958882955', 'SE180036', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180037')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180037', 'hash_student_123', N'Lý Quốc Nam', 'sv_se180037@fpt.edu.vn', '0955646584', 'SE180037', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180038')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180038', 'hash_student_123', N'Vũ Gia Phúc', 'sv_se180038@fpt.edu.vn', '0995568213', 'SE180038', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180039')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180039', 'hash_student_123', N'Lý Phương Thắng', 'sv_se180039@fpt.edu.vn', '0915576051', 'SE180039', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180040')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180040', 'hash_student_123', N'Vũ Văn Tiến', 'sv_se180040@fpt.edu.vn', '0999941754', 'SE180040', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180041')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180041', 'hash_student_123', N'Lý Thị Tú', 'sv_se180041@fpt.edu.vn', '0976852205', 'SE180041', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180042')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180042', 'hash_student_123', N'Vũ Khánh Vinh', 'sv_se180042@fpt.edu.vn', '0972714968', 'SE180042', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180043')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180043', 'hash_student_123', N'Lý Thanh Anh', 'sv_se180043@fpt.edu.vn', '0943721990', 'SE180043', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180044')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180044', 'hash_student_123', N'Vũ Đức Đạt', 'sv_se180044@fpt.edu.vn', '0945129199', 'SE180044', 2);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170045')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170045', 'hash_student_123', N'Đỗ Văn Vân', 'sv_ai170045@fpt.edu.vn', '0942985914', 'AI170045', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170046')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170046', 'hash_student_123', N'Phạm Thị Yên', 'sv_ai170046@fpt.edu.vn', '0931353511', 'AI170046', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170047')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170047', 'hash_student_123', N'Đỗ Khánh Dũng', 'sv_ai170047@fpt.edu.vn', '0969254956', 'AI170047', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170048')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170048', 'hash_student_123', N'Phạm Thanh Hà', 'sv_ai170048@fpt.edu.vn', '0959981036', 'AI170048', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170049')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170049', 'hash_student_123', N'Đỗ Đức Khoa', 'sv_ai170049@fpt.edu.vn', '0976856403', 'AI170049', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170050')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170050', 'hash_student_123', N'Phạm Hoàng Nam', 'sv_ai170050@fpt.edu.vn', '0978216219', 'AI170050', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170051')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170051', 'hash_student_123', N'Đỗ Anh Phúc', 'sv_ai170051@fpt.edu.vn', '0982403164', 'AI170051', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170052')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170052', 'hash_student_123', N'Phạm Ngọc Thắng', 'sv_ai170052@fpt.edu.vn', '0999136734', 'AI170052', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170053')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170053', 'hash_student_123', N'Đỗ Minh Tiến', 'sv_ai170053@fpt.edu.vn', '0970478094', 'AI170053', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170054')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170054', 'hash_student_123', N'Phạm Bảo Tú', 'sv_ai170054@fpt.edu.vn', '0993476902', 'AI170054', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170055')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170055', 'hash_student_123', N'Đỗ Tuấn Vinh', 'sv_ai170055@fpt.edu.vn', '0962084849', 'AI170055', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170056')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170056', 'hash_student_123', N'Phạm Hữu Anh', 'sv_ai170056@fpt.edu.vn', '0943595405', 'AI170056', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170057')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170057', 'hash_student_123', N'Đỗ Quốc Đạt', 'sv_ai170057@fpt.edu.vn', '0991493497', 'AI170057', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170058')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170058', 'hash_student_123', N'Phạm Gia Hùng', 'sv_ai170058@fpt.edu.vn', '0955880599', 'AI170058', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170059')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170059', 'hash_student_123', N'Đỗ Phương Lâm', 'sv_ai170059@fpt.edu.vn', '0933889246', 'AI170059', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170060')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170060', 'hash_student_123', N'Phạm Văn Ngọc', 'sv_ai170060@fpt.edu.vn', '0943319746', 'AI170060', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170061')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170061', 'hash_student_123', N'Đỗ Thị Quang', 'sv_ai170061@fpt.edu.vn', '0926503931', 'AI170061', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170062')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170062', 'hash_student_123', N'Phạm Khánh Thịnh', 'sv_ai170062@fpt.edu.vn', '0990691920', 'AI170062', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170063')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170063', 'hash_student_123', N'Đỗ Thanh Toàn', 'sv_ai170063@fpt.edu.vn', '0987710205', 'AI170063', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'AI170064')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_ai170064', 'hash_student_123', N'Phạm Đức Tùng', 'sv_ai170064@fpt.edu.vn', '0996316514', 'AI170064', 3);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180065')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180065', 'hash_student_123', N'Vũ Văn Thắng', 'sv_se180065@fpt.edu.vn', '0945320647', 'SE180065', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180066')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180066', 'hash_student_123', N'Lý Thị Tiến', 'sv_se180066@fpt.edu.vn', '0939413150', 'SE180066', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180067')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180067', 'hash_student_123', N'Vũ Khánh Tú', 'sv_se180067@fpt.edu.vn', '0940763722', 'SE180067', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180068')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180068', 'hash_student_123', N'Lý Thanh Vinh', 'sv_se180068@fpt.edu.vn', '0951515552', 'SE180068', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180069')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180069', 'hash_student_123', N'Vũ Đức Anh', 'sv_se180069@fpt.edu.vn', '0936479613', 'SE180069', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180070')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180070', 'hash_student_123', N'Lý Hoàng Đạt', 'sv_se180070@fpt.edu.vn', '0973685662', 'SE180070', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180071')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180071', 'hash_student_123', N'Vũ Anh Hùng', 'sv_se180071@fpt.edu.vn', '0930214386', 'SE180071', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180072')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180072', 'hash_student_123', N'Lý Ngọc Lâm', 'sv_se180072@fpt.edu.vn', '0980170766', 'SE180072', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180073')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180073', 'hash_student_123', N'Vũ Minh Ngọc', 'sv_se180073@fpt.edu.vn', '0945657250', 'SE180073', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180074')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180074', 'hash_student_123', N'Lý Bảo Quang', 'sv_se180074@fpt.edu.vn', '0933789252', 'SE180074', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180075')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180075', 'hash_student_123', N'Vũ Tuấn Thịnh', 'sv_se180075@fpt.edu.vn', '0981341233', 'SE180075', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180076')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180076', 'hash_student_123', N'Lý Hữu Toàn', 'sv_se180076@fpt.edu.vn', '0912638738', 'SE180076', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180077')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180077', 'hash_student_123', N'Vũ Quốc Tùng', 'sv_se180077@fpt.edu.vn', '0982632068', 'SE180077', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180078')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180078', 'hash_student_123', N'Lý Gia Vy', 'sv_se180078@fpt.edu.vn', '0931344015', 'SE180078', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180079')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180079', 'hash_student_123', N'Vũ Phương Châu', 'sv_se180079@fpt.edu.vn', '0965525872', 'SE180079', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180080')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180080', 'hash_student_123', N'Lý Văn Giang', 'sv_se180080@fpt.edu.vn', '0958074536', 'SE180080', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180081')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180081', 'hash_student_123', N'Vũ Thị Huy', 'sv_se180081@fpt.edu.vn', '0914095295', 'SE180081', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180082')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180082', 'hash_student_123', N'Lý Khánh Long', 'sv_se180082@fpt.edu.vn', '0944930654', 'SE180082', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180083')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180083', 'hash_student_123', N'Vũ Thanh Nhân', 'sv_se180083@fpt.edu.vn', '0991565879', 'SE180083', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180084')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180084', 'hash_student_123', N'Lý Đức Tài', 'sv_se180084@fpt.edu.vn', '0944412154', 'SE180084', 4);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180085')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180085', 'hash_student_123', N'Phạm Văn Lâm', 'sv_se180085@fpt.edu.vn', '0943751669', 'SE180085', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180086')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180086', 'hash_student_123', N'Đỗ Thị Ngọc', 'sv_se180086@fpt.edu.vn', '0953866471', 'SE180086', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180087')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180087', 'hash_student_123', N'Phạm Khánh Quang', 'sv_se180087@fpt.edu.vn', '0918851700', 'SE180087', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180088')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180088', 'hash_student_123', N'Đỗ Thanh Thịnh', 'sv_se180088@fpt.edu.vn', '0965118638', 'SE180088', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180089')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180089', 'hash_student_123', N'Phạm Đức Toàn', 'sv_se180089@fpt.edu.vn', '0956514607', 'SE180089', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180090')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180090', 'hash_student_123', N'Đỗ Hoàng Tùng', 'sv_se180090@fpt.edu.vn', '0926027835', 'SE180090', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180091')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180091', 'hash_student_123', N'Phạm Anh Vy', 'sv_se180091@fpt.edu.vn', '0979385256', 'SE180091', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180092')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180092', 'hash_student_123', N'Đỗ Ngọc Châu', 'sv_se180092@fpt.edu.vn', '0933173260', 'SE180092', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180093')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180093', 'hash_student_123', N'Phạm Minh Giang', 'sv_se180093@fpt.edu.vn', '0970837062', 'SE180093', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180094')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180094', 'hash_student_123', N'Đỗ Bảo Huy', 'sv_se180094@fpt.edu.vn', '0990934244', 'SE180094', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180095')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180095', 'hash_student_123', N'Phạm Tuấn Long', 'sv_se180095@fpt.edu.vn', '0929673626', 'SE180095', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180096')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180096', 'hash_student_123', N'Đỗ Hữu Nhân', 'sv_se180096@fpt.edu.vn', '0944923309', 'SE180096', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180097')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180097', 'hash_student_123', N'Phạm Quốc Tài', 'sv_se180097@fpt.edu.vn', '0931097621', 'SE180097', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180098')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180098', 'hash_student_123', N'Đỗ Gia Thư', 'sv_se180098@fpt.edu.vn', '0968364391', 'SE180098', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE180099')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se180099', 'hash_student_123', N'Phạm Phương Trinh', 'sv_se180099@fpt.edu.vn', '0976743223', 'SE180099', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE1800100')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se1800100', 'hash_student_123', N'Đỗ Văn Vân', 'sv_se1800100@fpt.edu.vn', '0995905297', 'SE1800100', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE1800101')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se1800101', 'hash_student_123', N'Phạm Thị Yên', 'sv_se1800101@fpt.edu.vn', '0940626624', 'SE1800101', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE1800102')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se1800102', 'hash_student_123', N'Đỗ Khánh Dũng', 'sv_se1800102@fpt.edu.vn', '0976550101', 'SE1800102', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE1800103')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se1800103', 'hash_student_123', N'Phạm Thanh Hà', 'sv_se1800103@fpt.edu.vn', '0994329095', 'SE1800103', 5);
IF NOT EXISTS (SELECT 1 FROM Users WHERE student_code = 'SE1800104')
    INSERT INTO Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) VALUES (3, 'sv_se1800104', 'hash_student_123', N'Đỗ Đức Khoa', 'sv_se1800104@fpt.edu.vn', '0992269926', 'SE1800104', 5);
GO

-- 2. Ghi danh (Course_Enrollments) 100 sinh viên vào 5 môn học
INSERT INTO Course_Enrollments (student_id, course_id)
SELECT u.user_id, c.course_id FROM Users u CROSS JOIN Courses c
WHERE u.role_id = 3 AND u.user_id >= 11
AND NOT EXISTS (SELECT 1 FROM Course_Enrollments ce WHERE ce.student_id = u.user_id AND ce.course_id = c.course_id);
GO

-- 3. Chèn các bài nộp mẫu của sinh viên lên Supabase Storage
-- Bài nộp của SE180005
BEGIN
    DECLARE @curr_sub_id_0 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180005' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'f1f912a8c98d8bdaec7771b4fa08c013c77c64745b11b2c0bbef4faa14c95a36', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180005_v1.zip', 2, 'GRADED', DATEADD(MINUTE, -10, GETDATE())
        FROM Users WHERE student_code = 'SE180005';
        SET @curr_sub_id_0 = SCOPE_IDENTITY();

        IF @curr_sub_id_0 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_0, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -5, GETDATE()));

    END
END
GO
-- Bài nộp của SE180006
BEGIN
    DECLARE @curr_sub_id_1 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180006' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'cf6502704445a165f2bef2cd76ccfc749b76079178c1ab63605c114548d3a23d', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180006_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -45, GETDATE())
        FROM Users WHERE student_code = 'SE180006';
        SET @curr_sub_id_1 = SCOPE_IDENTITY();

        IF @curr_sub_id_1 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_1, 9.0, N'Bài làm chất lượng cao, DAO sử dụng PreparedStatement đúng chuẩn, cấu trúc rõ ràng.', DATEADD(MINUTE, -20, GETDATE()));

    END
END
GO
-- Bài nộp của SE180007
BEGIN
    DECLARE @curr_sub_id_2 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180007' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '36604bca3ee9bfb8de7a5719365f76e590b2589134b5209ff6e4a3f1971e4914', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180007_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -80, GETDATE())
        FROM Users WHERE student_code = 'SE180007';
        SET @curr_sub_id_2 = SCOPE_IDENTITY();

        IF @curr_sub_id_2 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_2, 8.5, N'Hoàn thành tốt các yêu cầu rubric, code clean và có comment giải thích cụ thể.', DATEADD(MINUTE, -35, GETDATE()));

    END
END
GO
-- Bài nộp của SE180008
BEGIN
    DECLARE @curr_sub_id_3 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180008' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '5d8ee84d4e3a9fd88c1c6c3a11ec9543128cb3452ce6b7414ff8f1afcd168d42', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180008_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -115, GETDATE())
        FROM Users WHERE student_code = 'SE180008';
        SET @curr_sub_id_3 = SCOPE_IDENTITY();

        IF @curr_sub_id_3 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_3, 8.0, N'Chức năng chạy ổn định, cần bổ sung thêm ràng buộc kiểm tra chuỗi rỗng ở client.', DATEADD(MINUTE, -50, GETDATE()));

    END
END
GO
-- Bài nộp của SE180009
BEGIN
    DECLARE @curr_sub_id_4 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180009' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'e7457f4c948b40419d7e41096bf43fc7d9434fc012a27baa2cc5a05d7f9a6bb6', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180009_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -150, GETDATE())
        FROM Users WHERE student_code = 'SE180009';
        SET @curr_sub_id_4 = SCOPE_IDENTITY();

        IF @curr_sub_id_4 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_4, 7.5, N'Bài nộp đầy đủ, chú ý đặt tên biến và hàm theo quy ước CamelCase của Java.', DATEADD(MINUTE, -65, GETDATE()));

    END
END
GO
-- Bài nộp của SE180010
BEGIN
    DECLARE @curr_sub_id_5 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180010' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'a63d25712380071236c3ad89ea9d4a87c7362ad53dabf87553a065ae2b46449d', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180010_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -185, GETDATE())
        FROM Users WHERE student_code = 'SE180010';
        SET @curr_sub_id_5 = SCOPE_IDENTITY();

        IF @curr_sub_id_5 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_5, 7.0, N'Đáp ứng luồng chính, cần xử lý thêm trường hợp người dùng nhập ký tự đặc biệt.', DATEADD(MINUTE, -80, GETDATE()));

    END
END
GO
-- Bài nộp của SE180011
BEGIN
    DECLARE @curr_sub_id_6 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180011' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '034ef15f65155f25c399f15eb873568d605c2fc534ef8a90c01283d55130b037', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180011_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -220, GETDATE())
        FROM Users WHERE student_code = 'SE180011';
        SET @curr_sub_id_6 = SCOPE_IDENTITY();

        IF @curr_sub_id_6 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_6, 8.75, N'Rất tốt! Tích hợp lưu trữ Cloud Supabase minh bạch và đối soát SHA-256 chuẩn xác.', DATEADD(MINUTE, -95, GETDATE()));

    END
END
GO
-- Bài nộp của SE180012
BEGIN
    DECLARE @curr_sub_id_7 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180012' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '4c0fcb0ed159c27ab7661beef0450cb4eebe59c5fb050c3ffe60f28d80cfebca', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180012_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -255, GETDATE())
        FROM Users WHERE student_code = 'SE180012';
        SET @curr_sub_id_7 = SCOPE_IDENTITY();

        IF @curr_sub_id_7 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_7, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -110, GETDATE()));

    END
END
GO
-- Bài nộp của SE180013
BEGIN
    DECLARE @curr_sub_id_8 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180013' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'f70d62cd05bd4a98b0fae42b1387b8ba71bb5253516ff80c24a127fbdde54cca', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180013_v1.zip', 2, 'GRADED', DATEADD(MINUTE, -290, GETDATE())
        FROM Users WHERE student_code = 'SE180013';
        SET @curr_sub_id_8 = SCOPE_IDENTITY();

        IF @curr_sub_id_8 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_8, 9.0, N'Bài làm chất lượng cao, DAO sử dụng PreparedStatement đúng chuẩn, cấu trúc rõ ràng.', DATEADD(MINUTE, -125, GETDATE()));

    END
END
GO
-- Bài nộp của SE180014
BEGIN
    DECLARE @curr_sub_id_9 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180014' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'c220f16c1d0cdbce82b051f87c22f71b52f648287808ef4b9274d4335fac474c', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180014_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -325, GETDATE())
        FROM Users WHERE student_code = 'SE180014';
        SET @curr_sub_id_9 = SCOPE_IDENTITY();

        IF @curr_sub_id_9 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_9, 8.5, N'Hoàn thành tốt các yêu cầu rubric, code clean và có comment giải thích cụ thể.', DATEADD(MINUTE, -140, GETDATE()));

    END
END
GO
-- Bài nộp của SE180015
BEGIN
    DECLARE @curr_sub_id_10 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180015' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, 'e9b4103b0ce951ef15619e7706a467a8df694a8253ac3b13a8979b7d2208a5ab', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180015_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -360, GETDATE())
        FROM Users WHERE student_code = 'SE180015';
        SET @curr_sub_id_10 = SCOPE_IDENTITY();

        IF @curr_sub_id_10 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_10, 8.0, N'Chức năng chạy ổn định, cần bổ sung thêm ràng buộc kiểm tra chuỗi rỗng ở client.', DATEADD(MINUTE, -155, GETDATE()));

    END
END
GO
-- Bài nộp của SE180016
BEGIN
    DECLARE @curr_sub_id_11 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180016' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '314647adee07efebf85d4edd37660e3bc4afa98ee96efd681b9e185464cdabe4', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180016_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -395, GETDATE())
        FROM Users WHERE student_code = 'SE180016';
        SET @curr_sub_id_11 = SCOPE_IDENTITY();

        IF @curr_sub_id_11 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_11, 7.5, N'Bài nộp đầy đủ, chú ý đặt tên biến và hàm theo quy ước CamelCase của Java.', DATEADD(MINUTE, -170, GETDATE()));

    END
END
GO
-- Bài nộp của SE180017
BEGIN
    DECLARE @curr_sub_id_12 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180017' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'f7147831336972420a21b0f743b83805da1bfeb8fb9f6002473ab23b6289cbe2', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180017_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -430, GETDATE())
        FROM Users WHERE student_code = 'SE180017';
        SET @curr_sub_id_12 = SCOPE_IDENTITY();

        IF @curr_sub_id_12 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_12, 7.0, N'Đáp ứng luồng chính, cần xử lý thêm trường hợp người dùng nhập ký tự đặc biệt.', DATEADD(MINUTE, -185, GETDATE()));

    END
END
GO
-- Bài nộp của SE180018
BEGIN
    DECLARE @curr_sub_id_13 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180018' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'cef4fd6daf2003afaff1118cee47ee26b25aa8ea129c9de08639a1e3318975b1', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180018_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -465, GETDATE())
        FROM Users WHERE student_code = 'SE180018';
        SET @curr_sub_id_13 = SCOPE_IDENTITY();

        IF @curr_sub_id_13 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_13, 8.75, N'Rất tốt! Tích hợp lưu trữ Cloud Supabase minh bạch và đối soát SHA-256 chuẩn xác.', DATEADD(MINUTE, -200, GETDATE()));

    END
END
GO
-- Bài nộp của SE180019
BEGIN
    DECLARE @curr_sub_id_14 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180019' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '8ac1a87f54806ecd3f543b9958e02d112655ce307b49a483d9ba0d6b6303524b', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180019_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -500, GETDATE())
        FROM Users WHERE student_code = 'SE180019';
        SET @curr_sub_id_14 = SCOPE_IDENTITY();

        IF @curr_sub_id_14 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_14, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -215, GETDATE()));

    END
END
GO
-- Bài nộp của SE180020
BEGIN
    DECLARE @curr_sub_id_15 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180020' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '0f7c3d15d49dc615690b8835dc515f6671d0c8648a5ba4ed8d77f21bd394d680', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180020_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -535, GETDATE())
        FROM Users WHERE student_code = 'SE180020';
        SET @curr_sub_id_15 = SCOPE_IDENTITY();

        IF @curr_sub_id_15 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_15, 9.0, N'Bài làm chất lượng cao, DAO sử dụng PreparedStatement đúng chuẩn, cấu trúc rõ ràng.', DATEADD(MINUTE, -230, GETDATE()));

    END
END
GO
-- Bài nộp của SE180021
BEGIN
    DECLARE @curr_sub_id_16 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180021' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '3fe65bf16ae7c7265c6c435acdd733e2045cc7d923b383299e6826017957e2e7', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180021_v1.zip', 2, 'GRADED', DATEADD(MINUTE, -570, GETDATE())
        FROM Users WHERE student_code = 'SE180021';
        SET @curr_sub_id_16 = SCOPE_IDENTITY();

        IF @curr_sub_id_16 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_16, 8.5, N'Hoàn thành tốt các yêu cầu rubric, code clean và có comment giải thích cụ thể.', DATEADD(MINUTE, -245, GETDATE()));

    END
END
GO
-- Bài nộp của SE180022
BEGIN
    DECLARE @curr_sub_id_17 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180022' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'a4f3a30345788822ad4d445bf3b0b2babf97ac088c2fcb8746d9a2deab5781a7', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180022_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -605, GETDATE())
        FROM Users WHERE student_code = 'SE180022';
        SET @curr_sub_id_17 = SCOPE_IDENTITY();

        IF @curr_sub_id_17 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_17, 8.0, N'Chức năng chạy ổn định, cần bổ sung thêm ràng buộc kiểm tra chuỗi rỗng ở client.', DATEADD(MINUTE, -260, GETDATE()));

    END
END
GO
-- Bài nộp của SE180023
BEGIN
    DECLARE @curr_sub_id_18 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180023' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '46d638739b732ae488f1921dea3e15ff71dd205784aaa486c929cbdf61bb76a0', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180023_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -640, GETDATE())
        FROM Users WHERE student_code = 'SE180023';
        SET @curr_sub_id_18 = SCOPE_IDENTITY();

        IF @curr_sub_id_18 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_18, 7.5, N'Bài nộp đầy đủ, chú ý đặt tên biến và hàm theo quy ước CamelCase của Java.', DATEADD(MINUTE, -275, GETDATE()));

    END
END
GO
-- Bài nộp của SE180024
BEGIN
    DECLARE @curr_sub_id_19 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180024' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '5754946f69b84a6ea7e0cb70d176d843cf3ab4d63be727b958dd7624982dc02d', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180024_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -675, GETDATE())
        FROM Users WHERE student_code = 'SE180024';
        SET @curr_sub_id_19 = SCOPE_IDENTITY();

        IF @curr_sub_id_19 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_19, 7.0, N'Đáp ứng luồng chính, cần xử lý thêm trường hợp người dùng nhập ký tự đặc biệt.', DATEADD(MINUTE, -290, GETDATE()));

    END
END
GO
-- Bài nộp của SE180025
BEGIN
    DECLARE @curr_sub_id_20 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180025' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'ad9dc8709c06c21932c4998bde374240343f5a7aa024f8f0a7b4e917d2dcd6f3', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180025_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -710, GETDATE())
        FROM Users WHERE student_code = 'SE180025';
        SET @curr_sub_id_20 = SCOPE_IDENTITY();

        IF @curr_sub_id_20 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_20, 8.75, N'Rất tốt! Tích hợp lưu trữ Cloud Supabase minh bạch và đối soát SHA-256 chuẩn xác.', DATEADD(MINUTE, -305, GETDATE()));

    END
END
GO
-- Bài nộp của SE180026
BEGIN
    DECLARE @curr_sub_id_21 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180026' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '12e51993910f15747838de4ef1f7aa8803f43cbff76550ef3c2267a21c3963ab', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180026_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -745, GETDATE())
        FROM Users WHERE student_code = 'SE180026';
        SET @curr_sub_id_21 = SCOPE_IDENTITY();

        IF @curr_sub_id_21 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_21, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -320, GETDATE()));

    END
END
GO
-- Bài nộp của SE180027
BEGIN
    DECLARE @curr_sub_id_22 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180027' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '4a4e87c7a91c9b5096d3ee23d01d6c59cb7decbb7404defca8318b5b98249032', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180027_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -780, GETDATE())
        FROM Users WHERE student_code = 'SE180027';
        SET @curr_sub_id_22 = SCOPE_IDENTITY();

        IF @curr_sub_id_22 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_22, 9.0, N'Bài làm chất lượng cao, DAO sử dụng PreparedStatement đúng chuẩn, cấu trúc rõ ràng.', DATEADD(MINUTE, -335, GETDATE()));

    END
END
GO
-- Bài nộp của SE180028
BEGIN
    DECLARE @curr_sub_id_23 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180028' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, 'f131bdfb8eec686533cafd60606587bfa31f0c7cc75e55589cf84c97c6a0c67d', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180028_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -815, GETDATE())
        FROM Users WHERE student_code = 'SE180028';
        SET @curr_sub_id_23 = SCOPE_IDENTITY();

        IF @curr_sub_id_23 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_23, 8.5, N'Hoàn thành tốt các yêu cầu rubric, code clean và có comment giải thích cụ thể.', DATEADD(MINUTE, -350, GETDATE()));

    END
END
GO
-- Bài nộp của SE180029
BEGIN
    DECLARE @curr_sub_id_24 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180029' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '935856d40c11ca8da92dfe6ae5764cae9cad8aa6b61c8008a04fd1decfc3d503', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180029_v1.zip', 2, 'GRADED', DATEADD(MINUTE, -850, GETDATE())
        FROM Users WHERE student_code = 'SE180029';
        SET @curr_sub_id_24 = SCOPE_IDENTITY();

        IF @curr_sub_id_24 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_24, 8.0, N'Chức năng chạy ổn định, cần bổ sung thêm ràng buộc kiểm tra chuỗi rỗng ở client.', DATEADD(MINUTE, -365, GETDATE()));

    END
END
GO
-- Bài nộp của SE180030
BEGIN
    DECLARE @curr_sub_id_25 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180030' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '771e1b0528931445fbca0a2039f9cd8974480bccc2103217a8aa1d81e199dda4', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180030_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -885, GETDATE())
        FROM Users WHERE student_code = 'SE180030';
        SET @curr_sub_id_25 = SCOPE_IDENTITY();

        IF @curr_sub_id_25 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_25, 7.5, N'Bài nộp đầy đủ, chú ý đặt tên biến và hàm theo quy ước CamelCase của Java.', DATEADD(MINUTE, -380, GETDATE()));

    END
END
GO
-- Bài nộp của SE180031
BEGIN
    DECLARE @curr_sub_id_26 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180031' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, 'afebe9cfd6c1e730d1b7b11362c74d5e2b7cbe835d0dda94fafd658ef43c8bcb', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180031_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -920, GETDATE())
        FROM Users WHERE student_code = 'SE180031';
        SET @curr_sub_id_26 = SCOPE_IDENTITY();

        IF @curr_sub_id_26 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_26, 7.0, N'Đáp ứng luồng chính, cần xử lý thêm trường hợp người dùng nhập ký tự đặc biệt.', DATEADD(MINUTE, -395, GETDATE()));

    END
END
GO
-- Bài nộp của SE180032
BEGIN
    DECLARE @curr_sub_id_27 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180032' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '5a2974b37b36f166f42148ea7e2e5cb4c790a8ac966000dd8182e2425a994835', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180032_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -955, GETDATE())
        FROM Users WHERE student_code = 'SE180032';
        SET @curr_sub_id_27 = SCOPE_IDENTITY();

        IF @curr_sub_id_27 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_27, 8.75, N'Rất tốt! Tích hợp lưu trữ Cloud Supabase minh bạch và đối soát SHA-256 chuẩn xác.', DATEADD(MINUTE, -410, GETDATE()));

    END
END
GO
-- Bài nộp của SE180033
BEGIN
    DECLARE @curr_sub_id_28 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180033' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'cdd31e299979934e8b671a1123b0c48d5ec480a33ecbd7595eca9b1b4c04da4e', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180033_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -990, GETDATE())
        FROM Users WHERE student_code = 'SE180033';
        SET @curr_sub_id_28 = SCOPE_IDENTITY();

        IF @curr_sub_id_28 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_28, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -425, GETDATE()));

    END
END
GO
-- Bài nộp của SE180034
BEGIN
    DECLARE @curr_sub_id_29 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180034' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'b31b6dc5471ddea007a0b1f93901f1479020b469ec2b6c61dcb5954cb3088537', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180034_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1025, GETDATE())
        FROM Users WHERE student_code = 'SE180034';
        SET @curr_sub_id_29 = SCOPE_IDENTITY();

        IF @curr_sub_id_29 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_29, 9.0, N'Bài làm chất lượng cao, DAO sử dụng PreparedStatement đúng chuẩn, cấu trúc rõ ràng.', DATEADD(MINUTE, -440, GETDATE()));

    END
END
GO
-- Bài nộp của SE180035
BEGIN
    DECLARE @curr_sub_id_30 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180035' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, 'b64674fcf3a09f43c4eca901dd90084cbc132285f6c631df932c523eb28b2729', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180035_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1060, GETDATE())
        FROM Users WHERE student_code = 'SE180035';
        SET @curr_sub_id_30 = SCOPE_IDENTITY();

        IF @curr_sub_id_30 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_30, 8.5, N'Hoàn thành tốt các yêu cầu rubric, code clean và có comment giải thích cụ thể.', DATEADD(MINUTE, -455, GETDATE()));

    END
END
GO
-- Bài nộp của SE180036
BEGIN
    DECLARE @curr_sub_id_31 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180036' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '0c7f81d288838c833a70a8f0be58ad6977bef5745c9768064d60f126210e8b5c', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180036_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1095, GETDATE())
        FROM Users WHERE student_code = 'SE180036';
        SET @curr_sub_id_31 = SCOPE_IDENTITY();

        IF @curr_sub_id_31 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_31, 8.0, N'Chức năng chạy ổn định, cần bổ sung thêm ràng buộc kiểm tra chuỗi rỗng ở client.', DATEADD(MINUTE, -470, GETDATE()));

    END
END
GO
-- Bài nộp của SE180037
BEGIN
    DECLARE @curr_sub_id_32 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180037' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'e860b9c12a7dd1713b23c31b23e857cb2ad8bad594495853b4e4858b5c9abf8b', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180037_v1.zip', 2, 'GRADED', DATEADD(MINUTE, -1130, GETDATE())
        FROM Users WHERE student_code = 'SE180037';
        SET @curr_sub_id_32 = SCOPE_IDENTITY();

        IF @curr_sub_id_32 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_32, 7.5, N'Bài nộp đầy đủ, chú ý đặt tên biến và hàm theo quy ước CamelCase của Java.', DATEADD(MINUTE, -485, GETDATE()));

    END
END
GO
-- Bài nộp của SE180038
BEGIN
    DECLARE @curr_sub_id_33 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180038' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '54883062c02714089e06b68de8ef887b3a914b71ca5369351a132a3ed831afde', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180038_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1165, GETDATE())
        FROM Users WHERE student_code = 'SE180038';
        SET @curr_sub_id_33 = SCOPE_IDENTITY();

        IF @curr_sub_id_33 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_33, 7.0, N'Đáp ứng luồng chính, cần xử lý thêm trường hợp người dùng nhập ký tự đặc biệt.', DATEADD(MINUTE, -500, GETDATE()));

    END
END
GO
-- Bài nộp của SE180039
BEGIN
    DECLARE @curr_sub_id_34 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180039' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '84d3b39ff3ed7c67ab7b657919e2d8ca339d56077fea4c56f30ccf3391e6e306', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180039_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1200, GETDATE())
        FROM Users WHERE student_code = 'SE180039';
        SET @curr_sub_id_34 = SCOPE_IDENTITY();

        IF @curr_sub_id_34 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_34, 8.75, N'Rất tốt! Tích hợp lưu trữ Cloud Supabase minh bạch và đối soát SHA-256 chuẩn xác.', DATEADD(MINUTE, -515, GETDATE()));

    END
END
GO
-- Bài nộp của SE180040
BEGIN
    DECLARE @curr_sub_id_35 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180040' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, 'dd4be5a19cfc4ad5a969f64f7162f41839854a170662511cb413a7fa95e80377', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180040_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1235, GETDATE())
        FROM Users WHERE student_code = 'SE180040';
        SET @curr_sub_id_35 = SCOPE_IDENTITY();

        IF @curr_sub_id_35 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_35, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -530, GETDATE()));

    END
END
GO
-- Bài nộp của SE180041
BEGIN
    DECLARE @curr_sub_id_36 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180041' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '62a520b44e9cc119745be469363a10a3cbe1f2ca9ef4efef2a6e73b1bae76383', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180041_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1270, GETDATE())
        FROM Users WHERE student_code = 'SE180041';
        SET @curr_sub_id_36 = SCOPE_IDENTITY();

        IF @curr_sub_id_36 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_36, 9.0, N'Bài làm chất lượng cao, DAO sử dụng PreparedStatement đúng chuẩn, cấu trúc rõ ràng.', DATEADD(MINUTE, -545, GETDATE()));

    END
END
GO
-- Bài nộp của SE180042
BEGIN
    DECLARE @curr_sub_id_37 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180042' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '075e07e549e6ad0f2dee7c8a3bf27bdc2981a6ccde5b5de1f54ff746bb9d9ad4', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180042_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1305, GETDATE())
        FROM Users WHERE student_code = 'SE180042';
        SET @curr_sub_id_37 = SCOPE_IDENTITY();

        IF @curr_sub_id_37 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_37, 8.5, N'Hoàn thành tốt các yêu cầu rubric, code clean và có comment giải thích cụ thể.', DATEADD(MINUTE, -560, GETDATE()));

    END
END
GO
-- Bài nộp của SE180043
BEGIN
    DECLARE @curr_sub_id_38 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180043' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, 'd9db890f75313274d8fabfb352392fe0895e60c2df72f0e92a8fc84f800cb73e', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180043_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1340, GETDATE())
        FROM Users WHERE student_code = 'SE180043';
        SET @curr_sub_id_38 = SCOPE_IDENTITY();

        IF @curr_sub_id_38 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_38, 8.0, N'Chức năng chạy ổn định, cần bổ sung thêm ràng buộc kiểm tra chuỗi rỗng ở client.', DATEADD(MINUTE, -575, GETDATE()));

    END
END
GO
-- Bài nộp của SE180044
BEGIN
    DECLARE @curr_sub_id_39 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180044' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '7949ee1b4e46f3cc37133e917c6cd3022af273c4a9db73bd7ebe55974e79f354', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180044_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1375, GETDATE())
        FROM Users WHERE student_code = 'SE180044';
        SET @curr_sub_id_39 = SCOPE_IDENTITY();

        IF @curr_sub_id_39 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_39, 7.5, N'Bài nộp đầy đủ, chú ý đặt tên biến và hàm theo quy ước CamelCase của Java.', DATEADD(MINUTE, -590, GETDATE()));

    END
END
GO
-- Bài nộp của AI170045
BEGIN
    DECLARE @curr_sub_id_40 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170045' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'e65345b65f8c89a56aad70109f980ff801f1560b90545933e5cf8d3bf330685b', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_AI170045_v1.zip', 2, 'GRADED', DATEADD(MINUTE, -1410, GETDATE())
        FROM Users WHERE student_code = 'AI170045';
        SET @curr_sub_id_40 = SCOPE_IDENTITY();

        IF @curr_sub_id_40 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_40, 7.0, N'Đáp ứng luồng chính, cần xử lý thêm trường hợp người dùng nhập ký tự đặc biệt.', DATEADD(MINUTE, -605, GETDATE()));

    END
END
GO
-- Bài nộp của AI170046
BEGIN
    DECLARE @curr_sub_id_41 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170046' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '93e8022cf76bf4d7aee5baa84e2066781048c36f0ff50a30a368697aa3672c55', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_AI170046_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1445, GETDATE())
        FROM Users WHERE student_code = 'AI170046';
        SET @curr_sub_id_41 = SCOPE_IDENTITY();

        IF @curr_sub_id_41 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_41, 8.75, N'Rất tốt! Tích hợp lưu trữ Cloud Supabase minh bạch và đối soát SHA-256 chuẩn xác.', DATEADD(MINUTE, -620, GETDATE()));

    END
END
GO
-- Bài nộp của AI170047
BEGIN
    DECLARE @curr_sub_id_42 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170047' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '59081c2e4311f3901ca72f7057a58a13b4de731d0870fdcd80079d9548c7e8cf', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_AI170047_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1480, GETDATE())
        FROM Users WHERE student_code = 'AI170047';
        SET @curr_sub_id_42 = SCOPE_IDENTITY();

        IF @curr_sub_id_42 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_42, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -635, GETDATE()));

    END
END
GO
-- Bài nộp của AI170048
BEGIN
    DECLARE @curr_sub_id_43 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170048' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '08101ad0447aec24c5186714e9b1a94de4b3b9e79f383f590637d01be12ef28d', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_AI170048_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1515, GETDATE())
        FROM Users WHERE student_code = 'AI170048';
        SET @curr_sub_id_43 = SCOPE_IDENTITY();

        IF @curr_sub_id_43 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_43, 9.0, N'Bài làm chất lượng cao, DAO sử dụng PreparedStatement đúng chuẩn, cấu trúc rõ ràng.', DATEADD(MINUTE, -650, GETDATE()));

    END
END
GO
-- Bài nộp của AI170049
BEGIN
    DECLARE @curr_sub_id_44 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170049' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '9193f3aa942329e358f7d45445e0a5ae7cdeeb19bfb6c4b6735f3f1ed21eb8f7', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_AI170049_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1550, GETDATE())
        FROM Users WHERE student_code = 'AI170049';
        SET @curr_sub_id_44 = SCOPE_IDENTITY();

        IF @curr_sub_id_44 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_44, 8.5, N'Hoàn thành tốt các yêu cầu rubric, code clean và có comment giải thích cụ thể.', DATEADD(MINUTE, -665, GETDATE()));

    END
END
GO
-- Bài nộp của AI170050
BEGIN
    DECLARE @curr_sub_id_45 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170050' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'eb7829653ef08ee16e83ff6ee4243ad1fb60f1158d065eb1b1edb6e7702e769a', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_AI170050_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1585, GETDATE())
        FROM Users WHERE student_code = 'AI170050';
        SET @curr_sub_id_45 = SCOPE_IDENTITY();

        IF @curr_sub_id_45 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_45, 8.0, N'Chức năng chạy ổn định, cần bổ sung thêm ràng buộc kiểm tra chuỗi rỗng ở client.', DATEADD(MINUTE, -680, GETDATE()));

    END
END
GO
-- Bài nộp của AI170051
BEGIN
    DECLARE @curr_sub_id_46 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170051' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '4758ed0fdc755c236b0ff71fdd0abf85c27c60681d180f8a7fb7c733d09d12bb', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_AI170051_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1620, GETDATE())
        FROM Users WHERE student_code = 'AI170051';
        SET @curr_sub_id_46 = SCOPE_IDENTITY();

        IF @curr_sub_id_46 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_46, 7.5, N'Bài nộp đầy đủ, chú ý đặt tên biến và hàm theo quy ước CamelCase của Java.', DATEADD(MINUTE, -695, GETDATE()));

    END
END
GO
-- Bài nộp của AI170052
BEGIN
    DECLARE @curr_sub_id_47 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170052' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, 'c44fb865c3b9c7330429a0a7829b8b5429a7aa004efb10247fa4d32eac539697', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_AI170052_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1655, GETDATE())
        FROM Users WHERE student_code = 'AI170052';
        SET @curr_sub_id_47 = SCOPE_IDENTITY();

        IF @curr_sub_id_47 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_47, 7.0, N'Đáp ứng luồng chính, cần xử lý thêm trường hợp người dùng nhập ký tự đặc biệt.', DATEADD(MINUTE, -710, GETDATE()));

    END
END
GO
-- Bài nộp của AI170053
BEGIN
    DECLARE @curr_sub_id_48 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170053' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'f5b512fdffe09c6fe8250c364ef56a612d50e85603c91e971bb49fbe9a527abd', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_AI170053_v1.zip', 2, 'GRADED', DATEADD(MINUTE, -1690, GETDATE())
        FROM Users WHERE student_code = 'AI170053';
        SET @curr_sub_id_48 = SCOPE_IDENTITY();

        IF @curr_sub_id_48 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_48, 8.75, N'Rất tốt! Tích hợp lưu trữ Cloud Supabase minh bạch và đối soát SHA-256 chuẩn xác.', DATEADD(MINUTE, -725, GETDATE()));

    END
END
GO
-- Bài nộp của AI170054
BEGIN
    DECLARE @curr_sub_id_49 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170054' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '9320c0772bff3add7c7bb802c0f6813c53329396ce3b39853015eedba688b3e1', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_AI170054_v1.zip', 1, 'GRADED', DATEADD(MINUTE, -1725, GETDATE())
        FROM Users WHERE student_code = 'AI170054';
        SET @curr_sub_id_49 = SCOPE_IDENTITY();

        IF @curr_sub_id_49 IS NOT NULL
            INSERT INTO Grades (submission_id, score, feedback, graded_at)
            VALUES (@curr_sub_id_49, 9.5, N'Kiến trúc MVC chuẩn mực, servlet filter bắt exception rất tốt, SHA-256 toàn vẹn.', DATEADD(MINUTE, -740, GETDATE()));

    END
END
GO
-- Bài nộp của AI170055
BEGIN
    DECLARE @curr_sub_id_50 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170055' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '6edea2068fcaa470f89f28f63ea969db04201f3989e5c238c1c9306604652423', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_AI170055_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -1760, GETDATE())
        FROM Users WHERE student_code = 'AI170055';
        SET @curr_sub_id_50 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170056
BEGIN
    DECLARE @curr_sub_id_51 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170056' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '2fb19aeb1ee8dd600b293e5addc9ca222f8639b653667628c89fb082b9a2a439', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_AI170056_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -1795, GETDATE())
        FROM Users WHERE student_code = 'AI170056';
        SET @curr_sub_id_51 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170057
BEGIN
    DECLARE @curr_sub_id_52 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170057' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '690f2e3d1941727a0a67c7540c4288800a9c1f542ffbd766e15a67ab1aca8a88', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_AI170057_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -1830, GETDATE())
        FROM Users WHERE student_code = 'AI170057';
        SET @curr_sub_id_52 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170058
BEGIN
    DECLARE @curr_sub_id_53 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170058' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'bc5b664ac79ace01f10975412b42e6be405db4e57f98d07b885ffc6b75235ac9', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_AI170058_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -1865, GETDATE())
        FROM Users WHERE student_code = 'AI170058';
        SET @curr_sub_id_53 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170059
BEGIN
    DECLARE @curr_sub_id_54 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170059' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '72c097df9e172a10d411d8fd7e3ae187c721bc5c1e9790ea77efe69da34f5153', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_AI170059_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -1900, GETDATE())
        FROM Users WHERE student_code = 'AI170059';
        SET @curr_sub_id_54 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170060
BEGIN
    DECLARE @curr_sub_id_55 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170060' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '3297ddc87b6496b56d24540cd53f24cff6a6086a846abef6947a3859d0586b08', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_AI170060_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -1935, GETDATE())
        FROM Users WHERE student_code = 'AI170060';
        SET @curr_sub_id_55 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170061
BEGIN
    DECLARE @curr_sub_id_56 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170061' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '18c840ccd4b509eeb626d95c20f1493f5daa57ebc1890c89c2762af0e4a8fe03', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_AI170061_v1.zip', 2, 'PENDING', DATEADD(MINUTE, -1970, GETDATE())
        FROM Users WHERE student_code = 'AI170061';
        SET @curr_sub_id_56 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170062
BEGIN
    DECLARE @curr_sub_id_57 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170062' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'a6da3864f7a754e898c87a9b51c06827e7b45e0528bf2aa387cce53ef0bfb6f1', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_AI170062_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2005, GETDATE())
        FROM Users WHERE student_code = 'AI170062';
        SET @curr_sub_id_57 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170063
BEGIN
    DECLARE @curr_sub_id_58 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170063' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '47fd643d5dc46c9dff15450aab0db762d4eab9edcb12db36b4980db635775bee', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_AI170063_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2040, GETDATE())
        FROM Users WHERE student_code = 'AI170063';
        SET @curr_sub_id_58 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của AI170064
BEGIN
    DECLARE @curr_sub_id_59 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'AI170064' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, '2461704c82ba15c3047cc63c89e25f7b69455e41eda0cdc17788eef34ed809d6', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_AI170064_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2075, GETDATE())
        FROM Users WHERE student_code = 'AI170064';
        SET @curr_sub_id_59 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180065
BEGIN
    DECLARE @curr_sub_id_60 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180065' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, 'eccffc0a9a64f49aeec8da07d9e5a6d4dea114034bd4c95d4369023d53fdad90', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180065_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2110, GETDATE())
        FROM Users WHERE student_code = 'SE180065';
        SET @curr_sub_id_60 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180066
BEGIN
    DECLARE @curr_sub_id_61 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180066' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '17e53f3c8776b8538ccef424b171929eb53e5a255c31e49d2ef768395f0b9287', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180066_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2145, GETDATE())
        FROM Users WHERE student_code = 'SE180066';
        SET @curr_sub_id_61 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180067
BEGIN
    DECLARE @curr_sub_id_62 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180067' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, '7c5e9587544c34a54fc8e71c0b8e207888bd11b61d07f7d45eb7c733747d33a6', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180067_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2180, GETDATE())
        FROM Users WHERE student_code = 'SE180067';
        SET @curr_sub_id_62 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180068
BEGIN
    DECLARE @curr_sub_id_63 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180068' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, 'f29f807878b9d34546a9ca268453d0711e59cb4dac08600f7cf2fb953c0de53b', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180068_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2215, GETDATE())
        FROM Users WHERE student_code = 'SE180068';
        SET @curr_sub_id_63 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180069
BEGIN
    DECLARE @curr_sub_id_64 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180069' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '45c55f31833e478a775aa712e64022cc5869af0bbaaaf34c190b09760d3df1fd', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180069_v1.zip', 2, 'PENDING', DATEADD(MINUTE, -2250, GETDATE())
        FROM Users WHERE student_code = 'SE180069';
        SET @curr_sub_id_64 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180070
BEGIN
    DECLARE @curr_sub_id_65 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180070' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, '100b84e29c1e8e8a86cae5d90247a7fe9b872b18eafcaa7e12743a5ef81c3226', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180070_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2285, GETDATE())
        FROM Users WHERE student_code = 'SE180070';
        SET @curr_sub_id_65 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180071
BEGIN
    DECLARE @curr_sub_id_66 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180071' AND s.assignment_id = 3)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 3, user_id, 'c37a9d1b8b10358e9dc515046591ed67fca12d07d685f4e51be5e8d09a195701', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/CSD201_3_SE180071_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2320, GETDATE())
        FROM Users WHERE student_code = 'SE180071';
        SET @curr_sub_id_66 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180072
BEGIN
    DECLARE @curr_sub_id_67 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180072' AND s.assignment_id = 4)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 4, user_id, 'cb482d546cbf5cd4e9d7021fcf11e89d6018abfe2b7c4de412c2493d1af31d8d', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/SWR302_4_SE180072_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2355, GETDATE())
        FROM Users WHERE student_code = 'SE180072';
        SET @curr_sub_id_67 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180073
BEGIN
    DECLARE @curr_sub_id_68 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180073' AND s.assignment_id = 1)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 1, user_id, '30f790cb2455bef89fd76006cd3ea94d32a789f9eae3f372e8590d34857ad374', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_1_SE180073_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2390, GETDATE())
        FROM Users WHERE student_code = 'SE180073';
        SET @curr_sub_id_68 = SCOPE_IDENTITY();

    END
END
GO
-- Bài nộp của SE180074
BEGIN
    DECLARE @curr_sub_id_69 INT;
    IF NOT EXISTS (SELECT 1 FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE u.student_code = 'SE180074' AND s.assignment_id = 2)
    BEGIN
        INSERT INTO Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status, submitted_at)
        SELECT 2, user_id, 'ddf4dd23068c2062cbd8d044dcf431d2e80ffef766af25b4ffa3b96654a434dd', 'https://szxduosvqbplxcomxejf.supabase.co/storage/v1/object/public/submissions/PRJ301_2_SE180074_v1.zip', 1, 'PENDING', DATEADD(MINUTE, -2425, GETDATE())
        FROM Users WHERE student_code = 'SE180074';
        SET @curr_sub_id_69 = SCOPE_IDENTITY();

    END
END
GO

-- 4. Thêm dữ liệu Lộ trình học cá nhân mẫu
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180005' AND p.weakness_topic = N'Vòng đời Servlet & Cơ chế Filter')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Vòng đời Servlet & Cơ chế Filter', N'Nghiên cứu lại chu trình init -> service -> destroy của Servlet và cách chuỗi FilterChain xử lý request/response.', 'COMPLETED', DATEADD(DAY, -0, GETDATE())
    FROM Users WHERE student_code = 'SE180005';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180006' AND p.weakness_topic = N'Xử lý Exception & Giao dịch JDBC Transaction')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Xử lý Exception & Giao dịch JDBC Transaction', N'Thực hành sử dụng connection.setAutoCommit(false), commit() và rollback() trong khối try-catch.', 'IN_PROGRESS', DATEADD(DAY, -1, GETDATE())
    FROM Users WHERE student_code = 'SE180006';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180007' AND p.weakness_topic = N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL', N'Cài đặt thuật toán kiểm tra tính cân bằng chiều cao cây và viết lại phương thức rotateLeft, rotateRight.', 'IN_PROGRESS', DATEADD(DAY, -2, GETDATE())
    FROM Users WHERE student_code = 'SE180007';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180008' AND p.weakness_topic = N'Phân biệt Use Case Include vs Extend trong UML')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Phân biệt Use Case Include vs Extend trong UML', N'Vẽ lại biểu đồ Use Case mô tả phân hệ Quản lý Bài nộp với quan hệ <<include>> cho thao tác Đăng nhập.', 'COMPLETED', DATEADD(DAY, -3, GETDATE())
    FROM Users WHERE student_code = 'SE180008';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180009' AND p.weakness_topic = N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH', N'Sử dụng mệnh đề ORDER BY ... OFFSET (@page - 1) * @size ROWS FETCH NEXT @size ROWS ONLY trong DAO.', 'IN_PROGRESS', DATEADD(DAY, -4, GETDATE())
    FROM Users WHERE student_code = 'SE180009';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180010' AND p.weakness_topic = N'Nguyên lý Session Management & Chống Session Hijacking')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Nguyên lý Session Management & Chống Session Hijacking', N'Xem lại cách cấu hình session timeout trong web.xml và sử dụng session.invalidate() khi đăng xuất.', 'IN_PROGRESS', DATEADD(DAY, -5, GETDATE())
    FROM Users WHERE student_code = 'SE180010';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180011' AND p.weakness_topic = N'Vòng đời Servlet & Cơ chế Filter')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Vòng đời Servlet & Cơ chế Filter', N'Nghiên cứu lại chu trình init -> service -> destroy của Servlet và cách chuỗi FilterChain xử lý request/response.', 'COMPLETED', DATEADD(DAY, -6, GETDATE())
    FROM Users WHERE student_code = 'SE180011';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180012' AND p.weakness_topic = N'Xử lý Exception & Giao dịch JDBC Transaction')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Xử lý Exception & Giao dịch JDBC Transaction', N'Thực hành sử dụng connection.setAutoCommit(false), commit() và rollback() trong khối try-catch.', 'IN_PROGRESS', DATEADD(DAY, -7, GETDATE())
    FROM Users WHERE student_code = 'SE180012';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180013' AND p.weakness_topic = N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL', N'Cài đặt thuật toán kiểm tra tính cân bằng chiều cao cây và viết lại phương thức rotateLeft, rotateRight.', 'IN_PROGRESS', DATEADD(DAY, -8, GETDATE())
    FROM Users WHERE student_code = 'SE180013';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180014' AND p.weakness_topic = N'Phân biệt Use Case Include vs Extend trong UML')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Phân biệt Use Case Include vs Extend trong UML', N'Vẽ lại biểu đồ Use Case mô tả phân hệ Quản lý Bài nộp với quan hệ <<include>> cho thao tác Đăng nhập.', 'COMPLETED', DATEADD(DAY, -9, GETDATE())
    FROM Users WHERE student_code = 'SE180014';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180015' AND p.weakness_topic = N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH', N'Sử dụng mệnh đề ORDER BY ... OFFSET (@page - 1) * @size ROWS FETCH NEXT @size ROWS ONLY trong DAO.', 'IN_PROGRESS', DATEADD(DAY, -10, GETDATE())
    FROM Users WHERE student_code = 'SE180015';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180016' AND p.weakness_topic = N'Nguyên lý Session Management & Chống Session Hijacking')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Nguyên lý Session Management & Chống Session Hijacking', N'Xem lại cách cấu hình session timeout trong web.xml và sử dụng session.invalidate() khi đăng xuất.', 'IN_PROGRESS', DATEADD(DAY, -11, GETDATE())
    FROM Users WHERE student_code = 'SE180016';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180017' AND p.weakness_topic = N'Vòng đời Servlet & Cơ chế Filter')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Vòng đời Servlet & Cơ chế Filter', N'Nghiên cứu lại chu trình init -> service -> destroy của Servlet và cách chuỗi FilterChain xử lý request/response.', 'COMPLETED', DATEADD(DAY, -12, GETDATE())
    FROM Users WHERE student_code = 'SE180017';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180018' AND p.weakness_topic = N'Xử lý Exception & Giao dịch JDBC Transaction')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Xử lý Exception & Giao dịch JDBC Transaction', N'Thực hành sử dụng connection.setAutoCommit(false), commit() và rollback() trong khối try-catch.', 'IN_PROGRESS', DATEADD(DAY, -13, GETDATE())
    FROM Users WHERE student_code = 'SE180018';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180019' AND p.weakness_topic = N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL', N'Cài đặt thuật toán kiểm tra tính cân bằng chiều cao cây và viết lại phương thức rotateLeft, rotateRight.', 'IN_PROGRESS', DATEADD(DAY, -14, GETDATE())
    FROM Users WHERE student_code = 'SE180019';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180020' AND p.weakness_topic = N'Phân biệt Use Case Include vs Extend trong UML')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Phân biệt Use Case Include vs Extend trong UML', N'Vẽ lại biểu đồ Use Case mô tả phân hệ Quản lý Bài nộp với quan hệ <<include>> cho thao tác Đăng nhập.', 'COMPLETED', DATEADD(DAY, -15, GETDATE())
    FROM Users WHERE student_code = 'SE180020';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180021' AND p.weakness_topic = N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH', N'Sử dụng mệnh đề ORDER BY ... OFFSET (@page - 1) * @size ROWS FETCH NEXT @size ROWS ONLY trong DAO.', 'IN_PROGRESS', DATEADD(DAY, -16, GETDATE())
    FROM Users WHERE student_code = 'SE180021';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180022' AND p.weakness_topic = N'Nguyên lý Session Management & Chống Session Hijacking')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Nguyên lý Session Management & Chống Session Hijacking', N'Xem lại cách cấu hình session timeout trong web.xml và sử dụng session.invalidate() khi đăng xuất.', 'IN_PROGRESS', DATEADD(DAY, -17, GETDATE())
    FROM Users WHERE student_code = 'SE180022';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180023' AND p.weakness_topic = N'Vòng đời Servlet & Cơ chế Filter')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Vòng đời Servlet & Cơ chế Filter', N'Nghiên cứu lại chu trình init -> service -> destroy của Servlet và cách chuỗi FilterChain xử lý request/response.', 'COMPLETED', DATEADD(DAY, -18, GETDATE())
    FROM Users WHERE student_code = 'SE180023';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180024' AND p.weakness_topic = N'Xử lý Exception & Giao dịch JDBC Transaction')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Xử lý Exception & Giao dịch JDBC Transaction', N'Thực hành sử dụng connection.setAutoCommit(false), commit() và rollback() trong khối try-catch.', 'IN_PROGRESS', DATEADD(DAY, -19, GETDATE())
    FROM Users WHERE student_code = 'SE180024';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180025' AND p.weakness_topic = N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL', N'Cài đặt thuật toán kiểm tra tính cân bằng chiều cao cây và viết lại phương thức rotateLeft, rotateRight.', 'IN_PROGRESS', DATEADD(DAY, -20, GETDATE())
    FROM Users WHERE student_code = 'SE180025';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180026' AND p.weakness_topic = N'Phân biệt Use Case Include vs Extend trong UML')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Phân biệt Use Case Include vs Extend trong UML', N'Vẽ lại biểu đồ Use Case mô tả phân hệ Quản lý Bài nộp với quan hệ <<include>> cho thao tác Đăng nhập.', 'COMPLETED', DATEADD(DAY, -21, GETDATE())
    FROM Users WHERE student_code = 'SE180026';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180027' AND p.weakness_topic = N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH', N'Sử dụng mệnh đề ORDER BY ... OFFSET (@page - 1) * @size ROWS FETCH NEXT @size ROWS ONLY trong DAO.', 'IN_PROGRESS', DATEADD(DAY, -22, GETDATE())
    FROM Users WHERE student_code = 'SE180027';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180028' AND p.weakness_topic = N'Nguyên lý Session Management & Chống Session Hijacking')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Nguyên lý Session Management & Chống Session Hijacking', N'Xem lại cách cấu hình session timeout trong web.xml và sử dụng session.invalidate() khi đăng xuất.', 'IN_PROGRESS', DATEADD(DAY, -23, GETDATE())
    FROM Users WHERE student_code = 'SE180028';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180029' AND p.weakness_topic = N'Vòng đời Servlet & Cơ chế Filter')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Vòng đời Servlet & Cơ chế Filter', N'Nghiên cứu lại chu trình init -> service -> destroy của Servlet và cách chuỗi FilterChain xử lý request/response.', 'COMPLETED', DATEADD(DAY, -24, GETDATE())
    FROM Users WHERE student_code = 'SE180029';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180030' AND p.weakness_topic = N'Xử lý Exception & Giao dịch JDBC Transaction')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Xử lý Exception & Giao dịch JDBC Transaction', N'Thực hành sử dụng connection.setAutoCommit(false), commit() và rollback() trong khối try-catch.', 'IN_PROGRESS', DATEADD(DAY, -25, GETDATE())
    FROM Users WHERE student_code = 'SE180030';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180031' AND p.weakness_topic = N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Cây nhị phân tìm kiếm BST & Các phép xoay AVL', N'Cài đặt thuật toán kiểm tra tính cân bằng chiều cao cây và viết lại phương thức rotateLeft, rotateRight.', 'IN_PROGRESS', DATEADD(DAY, -26, GETDATE())
    FROM Users WHERE student_code = 'SE180031';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180032' AND p.weakness_topic = N'Phân biệt Use Case Include vs Extend trong UML')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Phân biệt Use Case Include vs Extend trong UML', N'Vẽ lại biểu đồ Use Case mô tả phân hệ Quản lý Bài nộp với quan hệ <<include>> cho thao tác Đăng nhập.', 'COMPLETED', DATEADD(DAY, -27, GETDATE())
    FROM Users WHERE student_code = 'SE180032';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180033' AND p.weakness_topic = N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Kỹ thuật phân trang Pagination với SQL OFFSET-FETCH', N'Sử dụng mệnh đề ORDER BY ... OFFSET (@page - 1) * @size ROWS FETCH NEXT @size ROWS ONLY trong DAO.', 'IN_PROGRESS', DATEADD(DAY, -28, GETDATE())
    FROM Users WHERE student_code = 'SE180033';
GO
IF NOT EXISTS (SELECT 1 FROM Personalized_Learning_Paths p JOIN Users u ON p.student_id = u.user_id WHERE u.student_code = 'SE180034' AND p.weakness_topic = N'Nguyên lý Session Management & Chống Session Hijacking')
    INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at)
    SELECT user_id, N'Nguyên lý Session Management & Chống Session Hijacking', N'Xem lại cách cấu hình session timeout trong web.xml và sử dụng session.invalidate() khi đăng xuất.', 'IN_PROGRESS', DATEADD(DAY, -29, GETDATE())
    FROM Users WHERE student_code = 'SE180034';
GO

PRINT N'Hoàn tất nạp 100 sinh viên và hệ thống dữ liệu mẫu thực tế!';
GO