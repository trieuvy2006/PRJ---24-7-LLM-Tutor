package console;

import dao.ClassDAO;
import java.util.List;
import java.util.Scanner;
import model.ClassRoom;
import model.User;
import service.AuthService;
import service.UserService;

/**
 * Chương trình Console kiểm thử toàn diện nền tảng AITA 24/7 LLM Tutor.
 * Đồng bộ các chức năng và phân quyền tương tự giao diện Web:
 * 1. Menu khi chưa đăng nhập (Đăng ký Sinh viên, Đăng nhập hệ thống)
 * 2. Phân luồng theo 3 Vai trò (Admin, Instructor, Student):
 *    - Admin: Toàn quyền CRUD tất cả người dùng trong CSDL, Quản lý Lớp học, Demo AI.
 *    - Instructor (Giáo viên): Xem lớp học phụ trách, Ngân hàng bài tập, Giám sát AI, Quản lý tài khoản cá nhân.
 *    - Student (Học sinh): AI Tutor Chatbot 24/7, Bài tập & Nộp bài Milestones, Quản lý tài khoản cá nhân.
 * 3. Quản lý tài khoản cá nhân (cho cả GV và HS): Xem hồ sơ, Đổi Email & SĐT, Đổi mật khẩu.
 * 4. Các chức năng bổ trợ (Nộp bài, AI Chatbot) được mô phỏng trực quan, ngắn gọn.
 */
public class UserConsoleTest {

    private static final Scanner scanner = new Scanner(System.in);
    private static final AuthService authService = new AuthService();
    private static final UserService userService = new UserService();
    private static final ClassDAO classDAO = new ClassDAO();
    private static User currentUser = null;

    public static void main(String[] args) {
        boolean running = true;

        while (running) {
            try {
                if (currentUser == null) {
                    // 1. Menu ban đầu khi chưa đăng nhập
                    printGuestMenu();
                    System.out.print("Chọn chức năng: ");
                    String choice = scanner.nextLine().trim();

                    System.out.println("\n------------------------------------------------------------------");
                    switch (choice) {
                        case "1":
                            handleRegister();
                            break;
                        case "2":
                            handleLogin();
                            break;
                        case "0":
                            System.out.println("Cảm ơn bạn đã sử dụng nền tảng AITA. Tạm biệt!");
                            running = false;
                            break;
                        default:
                            System.out.println("[LỖI] Lựa chọn không hợp lệ. Vui lòng chọn lại (1, 2 hoặc 0)!");
                    }
                    System.out.println("------------------------------------------------------------------\n");

                } else if (currentUser.isAdmin()) {
                    // 2. Menu dành cho Quản trị viên (Admin)
                    printAdminMenu();
                    System.out.print("Chọn chức năng: ");
                    String choice = scanner.nextLine().trim();

                    System.out.println("\n------------------------------------------------------------------");
                    switch (choice) {
                        case "1":
                            handleViewAllUsers();
                            break;
                        case "2":
                            handleViewUserDetail();
                            break;
                        case "3":
                            handleAddNewUser();
                            break;
                        case "4":
                            handleUpdateUserByAdmin();
                            break;
                        case "5":
                            handleDeleteUser();
                            break;
                        case "6":
                            handleSearchByUsername();
                            break;
                        case "7":
                            handleViewClasses();
                            break;
                        case "8":
                            handleAIChatBoxDemo();
                            break;
                        case "9":
                            handlePersonalAccountManagement();
                            break;
                        case "10":
                            handleLogout();
                            break;
                        case "0":
                            System.out.println("Cảm ơn bạn đã sử dụng nền tảng AITA. Tạm biệt!");
                            running = false;
                            break;
                        default:
                            System.out.println("[LỖI] Lựa chọn không hợp lệ. Vui lòng chọn lại (từ 0 đến 10)!");
                    }
                    System.out.println("------------------------------------------------------------------\n");

                } else if (currentUser.isInstructor()) {
                    // 3. Menu dành cho Giảng viên (Instructor)
                    printInstructorMenu();
                    System.out.print("Chọn chức năng: ");
                    String choice = scanner.nextLine().trim();

                    System.out.println("\n------------------------------------------------------------------");
                    switch (choice) {
                        case "1":
                            handleViewClasses();
                            break;
                        case "2":
                            handleAssignmentBankDemo();
                            break;
                        case "3":
                            handleMonitorDemo();
                            break;
                        case "4":
                            handleAIChatBoxDemo();
                            break;
                        case "5":
                            handlePersonalAccountManagement();
                            break;
                        case "6":
                            handleLogout();
                            break;
                        case "0":
                            System.out.println("Cảm ơn bạn đã sử dụng nền tảng AITA. Tạm biệt!");
                            running = false;
                            break;
                        default:
                            System.out.println("[LỖI] Lựa chọn không hợp lệ. Vui lòng chọn lại (từ 0 đến 6)!");
                    }
                    System.out.println("------------------------------------------------------------------\n");

                } else {
                    // 4. Menu dành cho Sinh viên (Student)
                    printStudentMenu();
                    System.out.print("Chọn chức năng: ");
                    String choice = scanner.nextLine().trim();

                    System.out.println("\n------------------------------------------------------------------");
                    switch (choice) {
                        case "1":
                            handleAIChatBoxDemo();
                            break;
                        case "2":
                            handleSubmissionDemo();
                            break;
                        case "3":
                            handleChatHistoryDemo();
                            break;
                        case "4":
                            handleStudyResourcesDemo();
                            break;
                        case "5":
                            handlePersonalAccountManagement();
                            break;
                        case "6":
                            handleLogout();
                            break;
                        case "0":
                            System.out.println("Cảm ơn bạn đã sử dụng nền tảng AITA. Tạm biệt!");
                            running = false;
                            break;
                        default:
                            System.out.println("[LỖI] Lựa chọn không hợp lệ. Vui lòng chọn lại (từ 0 đến 6)!");
                    }
                    System.out.println("------------------------------------------------------------------\n");
                }
            } catch (Exception e) {
                System.err.println("[LỖI XẢY RA]: " + e.getMessage());
                if (System.getProperty("debug") != null) {
                    e.printStackTrace();
                }
                System.out.println("------------------------------------------------------------------\n");
            }
        }
    }

    // =========================================================================
    // CÁC HÀM HIỂN THỊ MENU GIAO DIỆN CONSOLE
    // =========================================================================

    /**
     * Menu ban đầu khi chưa đăng nhập
     */
    private static void printGuestMenu() {
        System.out.println("========== AITA — 24/7 LLM TUTOR PLATFORM ==========");
        System.out.println("1. Đăng ký tài khoản (Dành cho Sinh viên)");
        System.out.println("2. Đăng nhập hệ thống");
        System.out.println("0. Thoát chương trình");
        System.out.println("=====================================================");
    }

    /**
     * Menu dành cho Quản trị viên (Admin)
     */
    private static void printAdminMenu() {
        System.out.println("========== BẢNG ĐIỀU KHIỂN QUẢN TRỊ VIÊN (ADMIN) ==========");
        System.out.println("Xin chào: " + currentUser.getFull_name() + " (@" + currentUser.getUsername() + ")");
        System.out.println("[HỆ THỐNG QUẢN TRỊ NGƯỜI DÙNG - TOÀN QUYỀN CRUD]");
        System.out.println("  1. Xem danh sách tất cả tài khoản (Read all)");
        System.out.println("  2. Xem chi tiết tài khoản theo ID (Read detail)");
        System.out.println("  3. Thêm tài khoản mới (Create)");
        System.out.println("  4. Cập nhật tài khoản bất kỳ (Update)");
        System.out.println("  5. Xóa tài khoản khỏi CSDL (Delete)");
        System.out.println("  6. Tìm kiếm tài khoản theo Username");
        System.out.println("[ĐIỀU HÀNH NỀN TẢNG AITA]");
        System.out.println("  7. Xem danh sách Môn học & Lớp học");
        System.out.println("  8. Thử nghiệm AI Tutor Chatbot 24/7 (Demo)");
        System.out.println("[TÀI KHOẢN CÁ NHÂN]");
        System.out.println("  9. Quản lý tài khoản cá nhân (Xem hồ sơ, Đổi SĐT/Email, Đổi mật khẩu)");
        System.out.println("  10. Đăng xuất");
        System.out.println("  0. Thoát chương trình");
        System.out.println("===========================================================");
    }

    /**
     * Menu dành cho Giảng viên (Instructor)
     */
    private static void printInstructorMenu() {
        System.out.println("========== BẢNG ĐIỀU KHIỂN GIẢNG VIÊN (INSTRUCTOR) ==========");
        System.out.println("Giảng viên: " + currentUser.getFull_name() + " (@" + currentUser.getUsername() + ")");
        System.out.println("[GIẢNG DẠY & GIÁM SÁT HỌC VIÊN]");
        System.out.println("  1. Xem danh sách Lớp học phụ trách & Sĩ số sinh viên");
        System.out.println("  2. Ngân hàng Bài tập & Milestones môn học");
        System.out.println("  3. Giám sát Hỏi đáp AI & Báo cáo tiến độ học viên");
        System.out.println("  4. Thử nghiệm AI Tutor Chatbot 24/7");
        System.out.println("[TÀI KHOẢN CÁ NHÂN]");
        System.out.println("  5. Quản lý tài khoản cá nhân (Xem hồ sơ, Đổi SĐT/Email, Đổi mật khẩu)");
        System.out.println("  6. Đăng xuất");
        System.out.println("  0. Thoát chương trình");
        System.out.println("=============================================================");
    }

    /**
     * Menu dành cho Sinh viên (Student)
     */
    private static void printStudentMenu() {
        System.out.println("========== BẢNG ĐIỀU HƯỚNG HỌC TẬP SINH VIÊN (STUDENT) ==========");
        System.out.println("Sinh viên: " + currentUser.getFull_name() + " | MSSV: " + (currentUser.getStudent_code() != null ? currentUser.getStudent_code() : "-"));
        System.out.println("[HỌC TẬP 24/7]");
        System.out.println("  1. AI Tutor Chatbot 24/7 (Hỏi đáp & Giải thích code)");
        System.out.println("  2. Bài tập & Nộp bài Milestones");
        System.out.println("  3. Lịch sử các phiên hỏi đáp AI");
        System.out.println("  4. Tài liệu môn học & Giáo trình Java Web");
        System.out.println("[TÀI KHOẢN CÁ NHÂN]");
        System.out.println("  5. Quản lý tài khoản cá nhân (Xem hồ sơ, Đổi SĐT/Email, Đổi mật khẩu)");
        System.out.println("  6. Đăng xuất");
        System.out.println("  0. Thoát chương trình");
        System.out.println("=================================================================");
    }

    // =========================================================================
    // CHỨC NĂNG DÙNG CHUNG / KHÁCH CHƯA ĐĂNG NHẬP
    // =========================================================================

    /**
     * 1. Đăng ký tài khoản mới (Mặc định Role: STUDENT)
     */
    private static void handleRegister() {
        System.out.println("=== 1. ĐĂNG KÝ TÀI KHOẢN MỚI (SINH VIÊN) ===");
        System.out.print("Nhập username (ít nhất 3 ký tự) *: ");
        String username = scanner.nextLine().trim();

        System.out.print("Nhập mật khẩu (ít nhất 6 ký tự) *: ");
        String password = scanner.nextLine().trim();

        System.out.print("Nhập họ và tên *: ");
        String fullName = scanner.nextLine().trim();

        System.out.print("Nhập email *: ");
        String email = scanner.nextLine().trim();

        System.out.print("Nhập số điện thoại (tùy chọn): ");
        String phone = scanner.nextLine().trim();

        System.out.print("Nhập mã sinh viên (ví dụ: SE180009): ");
        String studentCode = scanner.nextLine().trim();

        System.out.print("Nhập mã ID lớp học (1: SE1801, 2: SE1802, 3: IA1701, hoặc để trống): ");
        String classIdRaw = scanner.nextLine().trim();
        Integer classId = null;
        if (!classIdRaw.isEmpty()) {
            try {
                classId = Integer.parseInt(classIdRaw);
            } catch (NumberFormatException e) {
                System.out.println("[LƯU Ý] ID lớp không hợp lệ, sẽ lưu là null.");
            }
        }

        try {
            User newUser = authService.register(username, password, fullName, email, phone, studentCode, classId);
            System.out.println("\n[THÀNH CÔNG] Đăng ký tài khoản thành công!");
            System.out.println("Thông tin tài khoản vừa tạo:");
            printUserDetail(newUser);
            System.out.println("Bạn có thể đăng nhập bằng tài khoản này tại Menu 2.");
        } catch (Exception e) {
            System.out.println("[THẤT BẠI] Đăng ký không thành công: " + e.getMessage());
        }
    }

    /**
     * 2. Đăng nhập vào hệ thống
     */
    private static void handleLogin() {
        System.out.println("=== 2. ĐĂNG NHẬP VÀO HỆ THỐNG ===");
        System.out.print("Nhập username: ");
        String username = scanner.nextLine().trim();

        System.out.print("Nhập password: ");
        String password = scanner.nextLine().trim();

        try {
            User user = authService.login(username, password);
            currentUser = user;
            System.out.println("\n[THÀNH CÔNG] Đăng nhập thành công!");
            System.out.println("Xin chào: " + user.getFull_name() + " | Vai trò: " + user.getRole_name());
        } catch (Exception e) {
            System.out.println("[THẤT BẠI] Đăng nhập thất bại: " + e.getMessage());
        }
    }

    /**
     * Đăng xuất khỏi hệ thống
     */
    private static void handleLogout() {
        if (currentUser != null) {
            System.out.println("Đã đăng xuất tài khoản: " + currentUser.getUsername());
            currentUser = null;
            System.out.println("[THÀNH CÔNG] Đăng xuất an toàn. Quay lại menu ban đầu.");
        } else {
            System.out.println("Hiện tại chưa có tài khoản nào đăng nhập.");
        }
    }

    // =========================================================================
    // QUẢN LÝ TÀI KHOẢN CÁ NHÂN (HOẠT ĐỘNG THẬT CHO CẢ GV, HS VÀ ADMIN)
    // Chỉ cho đổi SĐT, Email và Mật khẩu (theo đúng quy chuẩn hệ thống)
    // =========================================================================

    private static void handlePersonalAccountManagement() {
        boolean inAccountMenu = true;
        while (inAccountMenu) {
            System.out.println("\n--- [QUẢN LÝ TÀI KHOẢN CÁ NHÂN] ---");
            System.out.println("Đang đăng nhập: " + currentUser.getFull_name() + " (@" + currentUser.getUsername() + ")");
            System.out.println("  1. Xem thông tin hồ sơ của tôi");
            System.out.println("  2. Cập nhật Số điện thoại & Email liên lạc");
            System.out.println("  3. Đổi mật khẩu tài khoản");
            System.out.println("  0. Quay lại menu chính");
            System.out.print("Chọn thao tác (0-3): ");
            String act = scanner.nextLine().trim();

            System.out.println("\n--------------------------------------------------");
            switch (act) {
                case "1":
                    handleViewMyProfile();
                    break;
                case "2":
                    handleUpdatePhoneAndEmail();
                    break;
                case "3":
                    handleChangePassword();
                    break;
                case "0":
                    inAccountMenu = false;
                    System.out.println("Quay trở lại menu chức năng.");
                    break;
                default:
                    System.out.println("[LỖI] Lựa chọn không hợp lệ. Vui lòng chọn từ 0 đến 3!");
            }
            System.out.println("--------------------------------------------------");
        }
    }

    /**
     * Xem thông tin hồ sơ của chính mình
     */
    private static void handleViewMyProfile() {
        System.out.println("=== THÔNG TIN HỒ SƠ TÀI KHOẢN CỦA TÔI ===");
        try {
            User fresh = userService.getUserById(currentUser, currentUser.getUser_id());
            currentUser = fresh;
            printUserDetail(fresh);
        } catch (Exception e) {
            System.out.println("[LỖI]: " + e.getMessage());
        }
    }

    /**
     * Cập nhật Số điện thoại và Email (hoạt động thật, lưu vào SQL Server)
     */
    private static void handleUpdatePhoneAndEmail() {
        System.out.println("=== CẬP NHẬT SỐ ĐIỆN THOẠI & EMAIL LIÊN LẠC ===");
        System.out.println("Lưu ý: Tên đăng nhập, vai trò và họ tên chính thức được bảo lưu cố định.");
        System.out.println("(Nhấn Enter để giữ nguyên giá trị hiện tại)\n");

        System.out.print("Nhập Email mới (hiện tại: " + currentUser.getEmail() + "): ");
        String newEmail = scanner.nextLine().trim();
        if (newEmail.isEmpty()) {
            newEmail = currentUser.getEmail();
        }

        System.out.print("Nhập Số điện thoại mới (hiện tại: " + (currentUser.getPhone() != null ? currentUser.getPhone() : "[Trống]") + "): ");
        String newPhone = scanner.nextLine().trim();
        if (newPhone.isEmpty()) {
            newPhone = currentUser.getPhone();
        }

        try {
            userService.updateStudentProfile(currentUser, currentUser.getFull_name(), newEmail, newPhone, currentUser.getClass_id());
            System.out.println("\n[THÀNH CÔNG] Đã cập nhật Số điện thoại và Email thành công vào CSDL!");

            User fresh = userService.getUserById(currentUser, currentUser.getUser_id());
            currentUser = fresh;
            printUserDetail(fresh);
        } catch (Exception e) {
            System.out.println("[THẤT BẠI] Cập nhật không thành công: " + e.getMessage());
        }
    }

    /**
     * Đổi mật khẩu tài khoản (hoạt động thật, lưu vào SQL Server)
     */
    private static void handleChangePassword() {
        System.out.println("=== BẢO MẬT & ĐỔI MẬT KHẨU TÀI KHOẢN ===");
        System.out.print("Nhập mật khẩu hiện tại *: ");
        String oldPass = scanner.nextLine().trim();

        System.out.print("Nhập mật khẩu mới (tối thiểu 6 ký tự) *: ");
        String newPass = scanner.nextLine().trim();

        System.out.print("Xác nhận lại mật khẩu mới *: ");
        String confirmPass = scanner.nextLine().trim();

        try {
            userService.changePassword(currentUser, oldPass, newPass, confirmPass);
            System.out.println("\n[THÀNH CÔNG] Đổi mật khẩu thành công! Mật khẩu mới đã được cập nhật an toàn.");
        } catch (Exception e) {
            System.out.println("[THẤT BẠI] Đổi mật khẩu thất bại: " + e.getMessage());
        }
    }

    // =========================================================================
    // CÁC CHỨC NĂNG DÀNH CHO ADMIN (QUẢN TRỊ VIÊN - TOÀN QUYỀN CRUD)
    // =========================================================================

    /**
     * Admin 1: Xem danh sách tài khoản
     */
    private static void handleViewAllUsers() {
        System.out.println("=== 1. XEM TOÀN BỘ DANH SÁCH TÀI KHOẢN (ADMIN CRUD - READ) ===");
        try {
            List<User> list = userService.getAllUsers(currentUser);
            System.out.println("Tổng số tài khoản trong hệ thống: " + list.size());
            printUserTable(list);
        } catch (Exception e) {
            System.out.println("[LỖI]: " + e.getMessage());
        }
    }

    /**
     * Admin 2: Xem chi tiết tài khoản theo user_id
     */
    private static void handleViewUserDetail() {
        System.out.println("=== 2. XEM CHI TIẾT TÀI KHOẢN THEO ID (ADMIN CRUD - READ DETAIL) ===");
        System.out.print("Nhập user_id cần xem chi tiết: ");
        int targetId;
        try {
            targetId = Integer.parseInt(scanner.nextLine().trim());
        } catch (NumberFormatException e) {
            System.out.println("[LỖI] user_id phải là số nguyên.");
            return;
        }

        try {
            User target = userService.getUserById(currentUser, targetId);
            System.out.println("\nThông tin chi tiết tài khoản ID " + targetId + ":");
            printUserDetail(target);
        } catch (Exception e) {
            System.out.println("[LỖI]: " + e.getMessage());
        }
    }

    /**
     * Admin 3: Thêm tài khoản mới
     */
    private static void handleAddNewUser() {
        System.out.println("=== 3. THÊM TÀI KHOẢN MỚI (ADMIN CRUD - CREATE) ===");
        System.out.println("Chọn vai trò:");
        System.out.println("  1 - ADMIN (Quản trị viên)");
        System.out.println("  2 - INSTRUCTOR (Giảng viên)");
        System.out.println("  3 - STUDENT (Sinh viên)");
        System.out.print("Nhập role_id (1-3): ");
        int roleId;
        try {
            roleId = Integer.parseInt(scanner.nextLine().trim());
        } catch (NumberFormatException e) {
            System.out.println("[LỖI] role_id phải là số nguyên.");
            return;
        }

        System.out.print("Nhập username *: ");
        String username = scanner.nextLine().trim();

        System.out.print("Nhập mật khẩu *: ");
        String password = scanner.nextLine().trim();

        System.out.print("Nhập họ và tên *: ");
        String fullName = scanner.nextLine().trim();

        System.out.print("Nhập email *: ");
        String email = scanner.nextLine().trim();

        System.out.print("Nhập số điện thoại: ");
        String phone = scanner.nextLine().trim();

        System.out.print("Nhập mã sinh viên (nếu là Sinh viên): ");
        String studentCode = scanner.nextLine().trim();

        System.out.print("Nhập ID lớp học (nếu có): ");
        String classIdRaw = scanner.nextLine().trim();
        Integer classId = null;
        if (!classIdRaw.isEmpty()) {
            try {
                classId = Integer.parseInt(classIdRaw);
            } catch (NumberFormatException ignored) {
            }
        }

        try {
            User created = userService.createUser(currentUser, roleId, username, password, fullName, email, phone,
                    studentCode, classId);
            System.out.println("\n[THÀNH CÔNG] Đã tạo mới tài khoản thành công!");
            printUserDetail(created);
        } catch (Exception e) {
            System.out.println("[THẤT BẠI] " + e.getMessage());
        }
    }

    /**
     * Admin 4: Cập nhật tài khoản bất kỳ theo user_id
     */
    private static void handleUpdateUserByAdmin() {
        System.out.println("=== 4. CẬP NHẬT TÀI KHOẢN BẤT KỲ (ADMIN CRUD - UPDATE) ===");
        System.out.print("Nhập user_id cần cập nhật: ");
        int targetId;
        try {
            targetId = Integer.parseInt(scanner.nextLine().trim());
        } catch (NumberFormatException e) {
            System.out.println("[LỖI] user_id phải là số nguyên.");
            return;
        }

        try {
            User target = userService.getUserById(currentUser, targetId);
            System.out.println("\nThông tin hiện tại của tài khoản ID " + targetId + ":");
            printUserDetail(target);
            System.out.println("(Gõ giá trị mới hoặc nhấn Enter để giữ nguyên giá trị cũ):");

            System.out.print("Nhập role_id mới (hiện tại: " + target.getRole_id() + "): ");
            String roleRaw = scanner.nextLine().trim();
            int newRoleId = roleRaw.isEmpty() ? target.getRole_id() : Integer.parseInt(roleRaw);

            System.out.print("Nhập username mới (hiện tại: " + target.getUsername() + "): ");
            String newUsername = scanner.nextLine().trim();
            if (newUsername.isEmpty()) {
                newUsername = target.getUsername();
            }

            System.out.print("Nhập họ tên mới (hiện tại: " + target.getFull_name() + "): ");
            String newFullName = scanner.nextLine().trim();
            if (newFullName.isEmpty()) {
                newFullName = target.getFull_name();
            }

            System.out.print("Nhập email mới (hiện tại: " + target.getEmail() + "): ");
            String newEmail = scanner.nextLine().trim();
            if (newEmail.isEmpty()) {
                newEmail = target.getEmail();
            }

            System.out.print("Nhập SĐT mới (hiện tại: " + target.getPhone() + "): ");
            String newPhone = scanner.nextLine().trim();
            if (newPhone.isEmpty()) {
                newPhone = target.getPhone();
            }

            System.out.print("Nhập MSSV mới (hiện tại: " + target.getStudent_code() + "): ");
            String newMSSV = scanner.nextLine().trim();
            if (newMSSV.isEmpty()) {
                newMSSV = target.getStudent_code();
            }

            System.out.print("Nhập Class ID mới (hiện tại: " + target.getClass_id() + "): ");
            String newClassRaw = scanner.nextLine().trim();
            Integer newClassId = newClassRaw.isEmpty() ? target.getClass_id() : Integer.parseInt(newClassRaw);

            userService.updateUserByAdmin(currentUser, targetId, newRoleId, newUsername, newFullName, newEmail,
                    newPhone, newMSSV, newClassId);
            System.out.println("\n[THÀNH CÔNG] Đã cập nhật tài khoản ID " + targetId + " thành công trong SQL Server!");

            if (currentUser.getUser_id() == targetId) {
                currentUser = userService.getUserById(currentUser, currentUser.getUser_id());
            }
        } catch (Exception e) {
            System.out.println("[THẤT BẠI] " + e.getMessage());
        }
    }

    /**
     * Admin 5: Xóa tài khoản theo user_id
     */
    private static void handleDeleteUser() {
        System.out.println("=== 5. XÓA TÀI KHOẢN KHỎI CSDL (ADMIN CRUD - DELETE) ===");
        System.out.print("Nhập user_id cần xóa: ");
        int targetId;
        try {
            targetId = Integer.parseInt(scanner.nextLine().trim());
        } catch (NumberFormatException e) {
            System.out.println("[LỖI] user_id phải là số nguyên.");
            return;
        }

        if (targetId == currentUser.getUser_id()) {
            System.out.println("[CẢNH BÁO] Bạn không thể tự xóa chính tài khoản Admin bạn đang đăng nhập!");
            return;
        }

        try {
            User target = userService.getUserById(currentUser, targetId);
            System.out.println("\nTài khoản tìm thấy để xóa:");
            printUserDetail(target);

            System.out.print(">> BẠN CÓ CHẮC CHẮN MUỐN XÓA TÀI KHOẢN NÀY KHỎI SQL SERVER? (gõ 'YES' để xác nhận): ");
            String confirm = scanner.nextLine().trim();
            if (!"YES".equalsIgnoreCase(confirm)) {
                System.out.println("Hủy thao tác xóa.");
                return;
            }

            userService.deleteUser(currentUser, targetId);
            System.out.println("\n[THÀNH CÔNG] Đã xóa tài khoản user_id = " + targetId + " thành công khỏi CSDL!");
        } catch (Exception e) {
            System.out.println("[THẤT BẠI]: " + e.getMessage());
        }
    }

    /**
     * Admin 6: Tìm kiếm tài khoản theo username
     */
    private static void handleSearchByUsername() {
        System.out.println("=== 6. TÌM KIẾM TÀI KHOẢN THEO USERNAME (ADMIN) ===");
        System.out.print("Nhập từ khóa username cần tìm: ");
        String keyword = scanner.nextLine().trim();

        try {
            List<User> list = userService.searchByUsername(currentUser, keyword);
            System.out.println("Kết quả tìm kiếm cho từ khóa '" + keyword + "': " + list.size() + " tài khoản.");
            printUserTable(list);
        } catch (Exception e) {
            System.out.println("[LỖI]: " + e.getMessage());
        }
    }

    // =========================================================================
    // CÁC CHỨC NĂNG BỔ TRỢ (LỚP HỌC, AI CHATBOX, NỘI DUNG MÔ PHỎNG QUA LOA)
    // =========================================================================

    /**
     * Xem danh sách lớp học (dùng chung cho Giảng viên & Admin)
     */
    private static void handleViewClasses() {
        System.out.println("=== DANH SÁCH LỚP HỌC PHẦN & SĨ SỐ HỌC VIÊN ===");
        try {
            List<ClassRoom> classes = classDAO.getAllClassesWithCount();
            if (classes == null || classes.isEmpty()) {
                System.out.println("(Chưa có lớp học nào)");
                return;
            }
            System.out.println("+----+------------+----------------------+---------------+----------------------------------+---------------------+");
            System.out.printf("| %-2s | %-10s | %-20s | %-13s | %-32s | %-19s |\n",
                    "ID", "Mã lớp", "Tên lớp", "Sĩ số SV", "Lịch học", "Phòng học");
            System.out.println("+----+------------+----------------------+---------------+----------------------------------+---------------------+");
            for (ClassRoom c : classes) {
                System.out.printf("| %-2d | %-10s | %-20s | %-13s | %-32s | %-19s |\n",
                        c.getClass_id(),
                        c.getClass_code(),
                        truncate(c.getClass_name(), 20),
                        c.getStudent_count() + " sinh viên",
                        (c.getSchedule() != null ? truncate(c.getSchedule(), 32) : "-"),
                        (c.getRoom() != null ? truncate(c.getRoom(), 19) : "-"));
            }
            System.out.println("+----+------------+----------------------+---------------+----------------------------------+---------------------+");
        } catch (Exception e) {
            System.out.println("[LỖI ĐỌC DỮ LIỆU LỚP HỌC]: " + e.getMessage());
        }
    }

    /**
     * AI Tutor Chatbot 24/7 (Mô phỏng tương tác hỏi đáp qua loa theo yêu cầu)
     */
    private static void handleAIChatBoxDemo() {
        System.out.println("\n==================================================================");
        System.out.println("🤖 [AITA AI TUTOR CHATBOT 24/7 - TRỢ LÝ LẬP TRÌNH & HỌC TẬP]");
        System.out.println("Model mô phỏng: OpenAI GPT-4o / Claude 3.5 Sonnet");
        System.out.println("Xin chào " + currentUser.getFull_name() + "! Tôi có thể hướng dẫn Servlet, JSP, JDBC.");
        System.out.println("Gợi ý câu hỏi nhanh:");
        System.out.println("  1. Giải thích vòng đời của HttpServlet (init, service, destroy)");
        System.out.println("  2. Cách khắc phục lỗi NullPointerException khi gọi DBContext JDBC");
        System.out.println("  3. Hướng dẫn phân quyền bằng AuthFilter trong Java Web");
        System.out.println("  (Hoặc nhập bất kỳ câu hỏi nào. Nhập '0' hoặc 'exit' để quay lại menu)");
        System.out.println("==================================================================");

        while (true) {
            System.out.print("\n[Bạn hỏi]: ");
            String prompt = scanner.nextLine().trim();
            if (prompt.equalsIgnoreCase("0") || prompt.equalsIgnoreCase("exit") || prompt.isEmpty()) {
                System.out.println("Tạm biệt phiên hỏi đáp với AI Tutor!");
                break;
            }

            System.out.println("\n[AITA AI Tutor 24/7 đang suy nghĩ...]");
            try {
                Thread.sleep(400);
            } catch (InterruptedException ignored) {
            }

            if (prompt.contains("1") || prompt.toLowerCase().contains("vòng đời") || prompt.toLowerCase().contains("servlet")) {
                System.out.println("[AI Tutor]: HttpServlet có vòng đời gồm 3 giai đoạn chính:");
                System.out.println("  • init(): Khởi tạo servlet một lần duy nhất khi container tải lên.");
                System.out.println("  • service(): Tiếp nhận và điều phối HTTP request (doGet, doPost,...).");
                System.out.println("  • destroy(): Dọn dẹp tài nguyên trước khi servlet bị hủy.");
            } else if (prompt.contains("2") || prompt.toLowerCase().contains("nullpointer") || prompt.toLowerCase().contains("jdbc")) {
                System.out.println("[AI Tutor]: Lỗi NullPointerException thường xuất phát từ:");
                System.out.println("  • Biến connection trong DBContext chưa được kết nối thành công (sai port 1433 hoặc user/pass SQL).");
                System.out.println("  • Quên khởi tạo đối tượng trước khi gọi method.");
            } else {
                System.out.println("[AI Tutor]: Cảm ơn câu hỏi của bạn về '" + prompt + "'!");
                System.out.println("  -> Trong mô hình MVC2, bạn hãy xử lý dữ liệu ở Service/DAO, điều hướng qua Servlet và hiển thị tại JSP.");
                System.out.println("  -> Bạn có muốn tôi hướng dẫn chi tiết thêm phần nào không?");
            }
        }
    }

    /**
     * Nộp bài & Milestones (Mô phỏng qua loa cho sinh viên)
     */
    private static void handleSubmissionDemo() {
        System.out.println("=== BÀI TẬP & NỘP BÀI MILESTONES ===");
        System.out.println("Danh sách Milestones môn học PRJ301:");
        System.out.println("  [1] Milestone 1: Phân tích yêu cầu & Thiết kế CSDL (ĐÃ ĐÓNG - Điểm: 9.5/10)");
        System.out.println("  [2] Milestone 2: Luồng CRUD end-to-end với Servlet + JSP + JDBC (ĐANG MỞ)");
        System.out.println("  [3] Milestone 3: Tích hợp AI Tutor & Hệ thống chấm điểm (Sắp mở)");
        System.out.print("\nChọn Milestone muốn nộp bài (nhấn 2 để nộp MS2, hoặc 0 để hủy): ");
        String msChoice = scanner.nextLine().trim();

        if ("2".equals(msChoice)) {
            System.out.print("Nhập tên tệp bài nộp hoặc đường dẫn GitHub (ví dụ: Nhom4_Milestone2.zip): ");
            String fileLink = scanner.nextLine().trim();
            if (fileLink.isEmpty()) {
                fileLink = "PRJ301_AITA_Group_Submission.zip";
            }
            System.out.println("\n[Đang tính toán mã băm SHA-256 xác thực bài nộp...]");
            System.out.println("[THÀNH CÔNG] Đã ghi nhận bài nộp Milestone 2 thành công!");
            System.out.println("• Tệp đính kèm : " + fileLink);
            System.out.println("• Mã SHA-256   : e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
            System.out.println("• Trạng thái   : PENDING_REVIEW (Chờ Giảng viên đánh giá)");
        } else {
            System.out.println("Quay lại menu chính.");
        }
    }

    /**
     * Ngân hàng bài tập (Mô phỏng qua loa cho giảng viên)
     */
    private static void handleAssignmentBankDemo() {
        System.out.println("=== NGÂN HÀNG BÀI TẬP & ĐỀ THI PRJ301 ===");
        System.out.println("1. Đề thực hành 01: Xây dựng Module Authentication & Remember Me");
        System.out.println("2. Đề thực hành 02: Quản lý danh mục sản phẩm / người dùng chuẩn MVC");
        System.out.println("3. Đề thực hành 03: Ráp nối AI Tutor Chatbot API");
        System.out.println("Trạng thái: 3 bộ đề đã được đồng bộ với hệ thống LMS.");
    }

    /**
     * Giám sát hỏi đáp & tiến độ (Mô phỏng qua loa cho giảng viên)
     */
    private static void handleMonitorDemo() {
        System.out.println("=== GIÁM SÁT HỎI ĐÁP AI & TIẾN ĐỘ HỌC VIÊN ===");
        System.out.println("• Tổng số lượt sinh viên hỏi đáp AI trong tuần : 284 lượt");
        System.out.println("• Tỷ lệ sinh viên hiểu bài sau khi hỏi AI     : 92.4%");
        System.out.println("• Số lượng sinh viên đã hoàn thành Milestone 2 : 28/30 sinh viên (93%)");
        System.out.println("• Cảnh báo học vụ                              : 0 sinh viên bị trễ hạn.");
    }

    /**
     * Lịch sử hỏi đáp (Mô phỏng qua loa cho sinh viên)
     */
    private static void handleChatHistoryDemo() {
        System.out.println("=== LỊCH SỬ CÁC PHIÊN HỎI ĐÁP GẦN ĐÂY ===");
        System.out.println("• Phiên #1 (Hôm nay 08:15) : Giải đáp lỗi UTF-8 tiếng Việt trong JSP & Servlet");
        System.out.println("• Phiên #2 (Hôm qua 19:40) : Cách cấu hình PreparedStatement trong UserDAO");
        System.out.println("• Phiên #3 (08/10/2026)    : Phân biệt redirect sendRedirect và forward RequestDispatcher");
    }

    /**
     * Tài liệu khóa học (Mô phỏng qua loa cho sinh viên)
     */
    private static void handleStudyResourcesDemo() {
        System.out.println("=== TÀI LIỆU KHÓA HỌC & GIÁO TRÌNH ===");
        System.out.println("1. Giáo trình Java Web (Servlet & JSP MVC2 Architecture) - PDF");
        System.out.println("2. Tài liệu CSDL SQL Server & Script tạo bảng AITA_DB - SQL");
        System.out.println("3. Quy chuẩn viết code Clean Code & Bảo mật chống SQL Injection");
    }

    // =========================================================================
    // CÁC HÀM TIỆN ÍCH HIỂN THỊ DỮ LIỆU BẢNG & CHI TIẾT
    // =========================================================================

    /**
     * In thông tin chi tiết một User
     */
    private static void printUserDetail(User u) {
        if (u == null) {
            return;
        }
        System.out.println("+----------------------------------------------------------------+");
        System.out.printf("| %-20s: %-39d |\n", "User ID", u.getUser_id());
        System.out.printf("| %-20s: %-39s |\n", "Vai trò (Role)",
                u.getRole_name() + " (role_id = " + u.getRole_id() + ")");
        System.out.printf("| %-20s: %-39s |\n", "Tên đăng nhập", u.getUsername());
        System.out.printf("| %-20s: %-39s |\n", "Họ và tên", u.getFull_name());
        System.out.printf("| %-20s: %-39s |\n", "Email", u.getEmail());
        System.out.printf("| %-20s: %-39s |\n", "Số điện thoại", (u.getPhone() != null ? u.getPhone() : "[Chưa có]"));
        System.out.printf("| %-20s: %-39s |\n", "Mã sinh viên",
                (u.getStudent_code() != null ? u.getStudent_code() : "[Không có]"));
        System.out.printf("| %-20s: %-39s |\n", "Lớp (Class ID)",
                (u.getClass_id() != null ? u.getClass_id().toString() : "[Không có]"));
        System.out.printf("| %-20s: %-39s |\n", "Ngày tạo",
                (u.getCreated_at() != null ? u.getCreated_at().toString() : "[Chưa xác định]"));
        System.out.println("+----------------------------------------------------------------+");
    }

    /**
     * In danh sách User dạng bảng
     */
    private static void printUserTable(List<User> list) {
        if (list == null || list.isEmpty()) {
            System.out.println("(Không có dữ liệu)");
            return;
        }
        System.out.println(
                "+-----+------------+-----------------+----------------------+---------------------------+-------------+------------+-------+");
        System.out.printf("| %-3s | %-10s | %-15s | %-20s | %-25s | %-11s | %-10s | %-5s |\n",
                "ID", "Role", "Username", "Họ tên", "Email", "SĐT", "MSSV", "Class");
        System.out.println(
                "+-----+------------+-----------------+----------------------+---------------------------+-------------+------------+-------+");
        for (User u : list) {
            System.out.printf("| %-3d | %-10s | %-15s | %-20s | %-25s | %-11s | %-10s | %-5s |\n",
                    u.getUser_id(),
                    u.getRole_name(),
                    u.getUsername(),
                    truncate(u.getFull_name(), 20),
                    truncate(u.getEmail(), 25),
                    (u.getPhone() != null ? u.getPhone() : "-"),
                    (u.getStudent_code() != null ? u.getStudent_code() : "-"),
                    (u.getClass_id() != null ? u.getClass_id().toString() : "-"));
        }
        System.out.println(
                "+-----+------------+-----------------+----------------------+---------------------------+-------------+------------+-------+");
    }

    private static String truncate(String s, int maxLen) {
        if (s == null) {
            return "-";
        }
        if (s.length() <= maxLen) {
            return s;
        }
        return s.substring(0, maxLen - 2) + "..";
    }
}
