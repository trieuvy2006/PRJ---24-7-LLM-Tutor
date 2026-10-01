package console;

import java.util.List;
import java.util.Scanner;
import model.User;
import service.AuthService;
import service.UserService;

/**
 * Chương trình Console kiểm thử hệ thống Quản lý Người dùng (LLM TUTOR):
 * 1. Menu ban đầu khi chưa đăng nhập (Đăng ký, Đăng nhập, Thoát)
 * 2. Phân quyền và điều hướng menu theo vai trò (ADMIN MENU, STUDENT MENU)
 * 3. Chức năng Quản trị viên (Admin): Xem danh sách, Chi tiết, Thêm, Sửa, Xóa, Tìm kiếm
 * 4. Chức năng Sinh viên (Student): Xem thông tin cá nhân, Cập nhật thông tin cá nhân
 * 5. Kết nối trực tiếp SQL Server qua DBContext, UserDAO, UserService, AuthService
 */
public class UserConsoleTest {

    private static final Scanner scanner = new Scanner(System.in);
    private static final AuthService authService = new AuthService();
    private static final UserService userService = new UserService();
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
                            System.out.println("Cảm ơn bạn đã sử dụng chương trình. Tạm biệt!");
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
                            handleLogout();
                            break;
                        case "0":
                            System.out.println("Cảm ơn bạn đã sử dụng chương trình. Tạm biệt!");
                            running = false;
                            break;
                        default:
                            System.out.println("[LỖI] Lựa chọn không hợp lệ. Vui lòng chọn lại (từ 0 đến 7)!");
                    }
                    System.out.println("------------------------------------------------------------------\n");

                } else {
                    // 3. Menu dành cho Sinh viên (Student)
                    printStudentMenu();
                    System.out.print("Chọn chức năng: ");
                    String choice = scanner.nextLine().trim();

                    System.out.println("\n------------------------------------------------------------------");
                    switch (choice) {
                        case "1":
                            handleViewMyProfile();
                            break;
                        case "2":
                            handleUpdateMyProfile();
                            break;
                        case "3":
                            handleLogout();
                            break;
                        case "0":
                            System.out.println("Cảm ơn bạn đã sử dụng chương trình. Tạm biệt!");
                            running = false;
                            break;
                        default:
                            System.out.println("[LỖI] Lựa chọn không hợp lệ. Vui lòng chọn lại (từ 0 đến 3)!");
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
    // CÁC HÀM HIỂN THỊ MENU
    // =========================================================================

    /**
     * Menu ban đầu khi chưa đăng nhập
     */
    private static void printGuestMenu() {
        System.out.println("========== LLM TUTOR ==========");
        System.out.println("1. Đăng ký tài khoản");
        System.out.println("2. Đăng nhập");
        System.out.println("0. Thoát chương trình");
        System.out.println("================================");
    }

    /**
     * Menu dành cho Admin
     */
    private static void printAdminMenu() {
        System.out.println("========== ADMIN MENU ==========");
        System.out.println("1. Xem danh sách tài khoản");
        System.out.println("2. Xem chi tiết tài khoản");
        System.out.println("3. Thêm tài khoản");
        System.out.println("4. Cập nhật tài khoản");
        System.out.println("5. Xóa tài khoản");
        System.out.println("6. Tìm kiếm tài khoản");
        System.out.println("7. Đăng xuất");
        System.out.println("0. Thoát chương trình");
        System.out.println("================================");
    }

    /**
     * Menu dành cho Student
     */
    private static void printStudentMenu() {
        System.out.println("========== STUDENT MENU ==========");
        System.out.println("1. Xem thông tin tài khoản của tôi");
        System.out.println("2. Cập nhật thông tin cá nhân");
        System.out.println("3. Đăng xuất");
        System.out.println("0. Thoát chương trình");
        System.out.println("==================================");
    }

    // =========================================================================
    // CHỨC NĂNG DÙNG CHUNG / KHÁCH CHƯA ĐĂNG NHẬP
    // =========================================================================

    /**
     * 1. Đăng ký tài khoản mới (Mặc định Role: STUDENT)
     */
    private static void handleRegister() {
        System.out.println("=== 1. ĐĂNG KÝ TÀI KHOẢN MỚI ===");
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
            System.out.println("[THÀNH CÔNG] Đăng xuất thành công. Quay lại menu ban đầu.");
        } else {
            System.out.println("Hiện tại chưa có tài khoản nào đăng nhập.");
        }
    }

    // =========================================================================
    // CÁC CHỨC NĂNG DÀNH CHO ADMIN
    // =========================================================================

    /**
     * Admin 1: Xem danh sách tài khoản
     */
    private static void handleViewAllUsers() {
        System.out.println("=== 1. XEM DANH SÁCH TÀI KHOẢN (ADMIN) ===");
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
        System.out.println("=== 2. XEM CHI TIẾT TÀI KHOẢN (ADMIN) ===");
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
        System.out.println("=== 3. THÊM TÀI KHOẢN MỚI (ADMIN) ===");
        System.out.println("Chọn vai trò:");
        System.out.println("  1 - ADMIN");
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

        System.out.print("Nhập mã sinh viên (nếu có): ");
        String studentCode = scanner.nextLine().trim();

        System.out.print("Nhập ID lớp (nếu có): ");
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
        System.out.println("=== 4. CẬP NHẬT TÀI KHOẢN (ADMIN) ===");
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

            // Nếu admin cập nhật chính tài khoản của mình thì đồng bộ lại currentUser
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
        System.out.println("=== 5. XÓA TÀI KHOẢN (ADMIN) ===");
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
    // CÁC CHỨC NĂNG DÀNH CHO STUDENT
    // =========================================================================

    /**
     * Student 1: Xem thông tin tài khoản của tôi
     */
    private static void handleViewMyProfile() {
        System.out.println("=== 1. XEM THÔNG TIN TÀI KHOẢN CỦA TÔI ===");
        try {
            // Lấy dữ liệu mới nhất từ CSDL
            User fresh = userService.getUserById(currentUser, currentUser.getUser_id());
            currentUser = fresh;
            printUserDetail(fresh);
        } catch (Exception e) {
            System.out.println("[LỖI]: " + e.getMessage());
        }
    }

    /**
     * Student 2: Cập nhật thông tin cá nhân của chính mình
     */
    private static void handleUpdateMyProfile() {
        System.out.println("=== 2. CẬP NHẬT THÔNG TIN CÁ NHÂN ===");
        System.out.println("Tài khoản: " + currentUser.getUsername());
        System.out.println("(Lưu ý: Sinh viên không được thay đổi username, password hoặc role tại đây)");
        System.out.println("(Nhấn Enter để giữ nguyên giá trị hiện tại)\n");

        System.out.print("Nhập Họ và tên mới (hiện tại: " + currentUser.getFull_name() + "): ");
        String fullName = scanner.nextLine().trim();
        if (fullName.isEmpty()) {
            fullName = currentUser.getFull_name();
        }

        System.out.print("Nhập Email mới (hiện tại: " + currentUser.getEmail() + "): ");
        String email = scanner.nextLine().trim();
        if (email.isEmpty()) {
            email = currentUser.getEmail();
        }

        System.out.print("Nhập SĐT mới (hiện tại: " + currentUser.getPhone() + "): ");
        String phone = scanner.nextLine().trim();
        if (phone.isEmpty()) {
            phone = currentUser.getPhone();
        }

        System.out.print("Nhập Class ID mới (hiện tại: " + currentUser.getClass_id() + "): ");
        String classIdRaw = scanner.nextLine().trim();
        Integer classId = classIdRaw.isEmpty() ? currentUser.getClass_id() : Integer.parseInt(classIdRaw);

        try {
            userService.updateStudentProfile(currentUser, fullName, email, phone, classId);
            System.out.println("\n[THÀNH CÔNG] Thông tin cá nhân đã được cập nhật vào SQL Server!");

            // Đọc lại từ DB để hiển thị thông tin cập nhật mới nhất
            User fresh = userService.getUserById(currentUser, currentUser.getUser_id());
            currentUser = fresh;
            printUserDetail(fresh);
        } catch (Exception e) {
            System.out.println("[THẤT BẠI] " + e.getMessage());
        }
    }

    // =========================================================================
    // CÁC HÀM TIỆN ÍCH HIỂN THỊ DỮ LIỆU
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
