package service;

import dao.UserDAO;
import java.util.List;
import model.Role;
import model.User;
import util.PasswordUtil;

/**
 * Service xử lý nghiệp vụ quản lý tài khoản người dùng và phân quyền hệ thống.
 */
public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Xem danh sách tất cả tài khoản người dùng (Chỉ dành cho Admin).
     */
    public List<User> getAllUsers(User currentUser) throws Exception {
        if (currentUser == null) {
            throw new SecurityException("Vui lòng đăng nhập để thực hiện chức năng này.");
        }
        if (!currentUser.isAdmin()) {
            throw new SecurityException("Từ chối truy cập: Chỉ Quản trị viên (Admin) mới có quyền xem danh sách tài khoản.");
        }
        return userDAO.getAll();
    }

    /**
     * Xem chi tiết tài khoản theo user_id.
     * Admin xem được mọi người; Sinh viên chỉ xem được chính mình.
     */
    public User getUserById(User currentUser, int targetUserId) throws Exception {
        if (currentUser == null) {
            throw new SecurityException("Vui lòng đăng nhập để thực hiện chức năng này.");
        }
        if (!currentUser.isAdmin() && currentUser.getUser_id() != targetUserId) {
            throw new SecurityException("Từ chối truy cập: Bạn không có quyền xem thông tin của tài khoản khác.");
        }

        User target = userDAO.getUserById(targetUserId);
        if (target == null) {
            throw new IllegalArgumentException("Không tìm thấy người dùng có ID " + targetUserId);
        }
        return target;
    }

    /**
     * Tìm kiếm người dùng theo username (Chỉ dành cho Admin).
     */
    public List<User> searchByUsername(User currentUser, String keyword) throws Exception {
        if (currentUser == null) {
            throw new SecurityException("Vui lòng đăng nhập.");
        }
        if (!currentUser.isAdmin()) {
            throw new SecurityException("Từ chối truy cập: Chỉ Quản trị viên (Admin) mới có quyền tìm kiếm tài khoản người khác.");
        }
        if (keyword == null || keyword.trim().isEmpty()) {
            return userDAO.getAll();
        }
        return userDAO.searchByUsername(keyword.trim());
    }

    /**
     * Thêm tài khoản mới (Chỉ dành cho Admin).
     */
    public User createUser(User currentUser, int roleId, String username, String password,
                           String fullName, String email, String phone, String studentCode, Integer classId) throws Exception {
        if (currentUser == null || !currentUser.isAdmin()) {
            throw new SecurityException("Từ chối truy cập: Chỉ Quản trị viên (Admin) mới có quyền thêm tài khoản.");
        }

        // Validate
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }
        username = username.trim();
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Họ tên không được để trống.");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống.");
        }
        if (roleId < Role.ADMIN || roleId > Role.STUDENT) {
            throw new IllegalArgumentException("Vai trò role_id không hợp lệ (1: ADMIN, 2: INSTRUCTOR, 3: STUDENT).");
        }

        if (userDAO.checkUsernameExists(username)) {
            throw new IllegalStateException("Tên đăng nhập '" + username + "' đã tồn tại.");
        }
        if (userDAO.checkEmailExists(email)) {
            throw new IllegalStateException("Email '" + email + "' đã tồn tại.");
        }

        String hashedPassword = PasswordUtil.hashPassword(password);
        User uNew = new User(roleId, username, hashedPassword, fullName.trim(), email.trim(), 
                             (phone != null ? phone.trim() : null), 
                             (studentCode != null ? studentCode.trim().toUpperCase() : null), 
                             classId);

        String err = userDAO.insert(uNew);
        if (err != null) {
            throw new Exception("Thêm tài khoản thất bại: " + err);
        }
        return userDAO.getUserByUsername(username);
    }

    /**
     * Cập nhật tài khoản do Quản trị viên (Admin) thực hiện.
     */
    public void updateUserByAdmin(User currentUser, int targetUserId, int roleId, String username,
                                  String fullName, String email, String phone, String studentCode, Integer classId) throws Exception {
        if (currentUser == null || !currentUser.isAdmin()) {
            throw new SecurityException("Từ chối truy cập: Chỉ Quản trị viên (Admin) mới có quyền cập nhật tài khoản người khác.");
        }

        User existing = userDAO.getUserById(targetUserId);
        if (existing == null) {
            throw new IllegalArgumentException("Không tìm thấy người dùng có ID " + targetUserId);
        }

        // Cập nhật các trường
        existing.setRole_id(roleId);
        existing.setUsername(username.trim());
        existing.setFull_name(fullName.trim());
        existing.setEmail(email.trim());
        existing.setPhone(phone != null ? phone.trim() : null);
        existing.setStudent_code(studentCode != null ? studentCode.trim().toUpperCase() : null);
        existing.setClass_id(classId);

        String err = userDAO.update(existing);
        if (err != null) {
            throw new Exception("Cập nhật thất bại: " + err);
        }
    }

    /**
     * Sinh viên tự cập nhật thông tin cá nhân của chính mình.
     * Chỉ được cập nhật: full_name, email, phone, class_id.
     * KHÔNG được đổi role_id, username, password_hash hoặc user_id.
     */
    public void updateStudentProfile(User currentUser, String fullName, String email, String phone, Integer classId) throws Exception {
        if (currentUser == null) {
            throw new SecurityException("Vui lòng đăng nhập.");
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Họ tên không được để trống.");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống.");
        }

        // Kiểm tra email nếu thay đổi có bị trùng tài khoản khác không
        User checkEmail = userDAO.getUserByEmail(email.trim());
        if (checkEmail != null && checkEmail.getUser_id() != currentUser.getUser_id()) {
            throw new IllegalStateException("Email '" + email + "' đã được sử dụng bởi tài khoản khác.");
        }

        currentUser.setFull_name(fullName.trim());
        currentUser.setEmail(email.trim());
        currentUser.setPhone(phone != null ? phone.trim() : null);
        currentUser.setClass_id(classId);

        String err = userDAO.updateProfile(currentUser);
        if (err != null) {
            throw new Exception("Cập nhật thông tin cá nhân thất bại: " + err);
        }
    }

    /**
     * Xóa tài khoản (Chỉ dành cho Admin).
     */
    public void deleteUser(User currentUser, int targetUserId) throws Exception {
        if (currentUser == null || !currentUser.isAdmin()) {
            throw new SecurityException("Từ chối truy cập: Chỉ Quản trị viên (Admin) mới có quyền xóa tài khoản.");
        }
        if (currentUser.getUser_id() == targetUserId) {
            throw new IllegalArgumentException("Không thể tự xóa chính tài khoản Admin đang đăng nhập.");
        }

        User target = userDAO.getUserById(targetUserId);
        if (target == null) {
            throw new IllegalArgumentException("Không tìm thấy người dùng có ID " + targetUserId + " để xóa.");
        }

        String err = userDAO.delete(targetUserId);
        if (err != null) {
            throw new Exception("Xóa thất bại: " + err);
        }
    }
}
