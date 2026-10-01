package service;

import dao.UserDAO;
import model.Role;
import model.User;
import util.PasswordUtil;

/**
 * Service xử lý nghiệp vụ xác thực: Đăng ký, Đăng nhập, Đăng xuất, Kiểm tra mật khẩu.
 */
public class AuthService {

    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Đăng ký tài khoản mới cho sinh viên.
     * Mặc định role_id = 3 (STUDENT).
     * Mật khẩu được băm an toàn bằng SHA-256.
     *
     * @param username tên đăng nhập
     * @param password mật khẩu thô
     * @param fullName họ và tên
     * @param email email
     * @param phone số điện thoại
     * @param studentCode mã sinh viên
     * @param classId ID lớp học
     * @return đối tượng User đã tạo thành công
     * @throws Exception khi dữ liệu không hợp lệ hoặc đã tồn tại
     */
    public User register(String username, String password, String fullName, 
                         String email, String phone, String studentCode, Integer classId) throws Exception {
        // 1. Kiểm tra dữ liệu đầu vào (Validation)
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }
        username = username.trim();
        if (username.length() < 3 || username.length() > 50) {
            throw new IllegalArgumentException("Tên đăng nhập phải từ 3 đến 50 ký tự.");
        }
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            throw new IllegalArgumentException("Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới (_).");
        }

        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        if (password.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự.");
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Họ và tên không được để trống.");
        }
        fullName = fullName.trim();

        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống.");
        }
        email = email.trim();
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Địa chỉ email không đúng định dạng.");
        }

        if (phone != null && !phone.trim().isEmpty()) {
            phone = phone.trim();
            if (!phone.matches("^[0-9]{9,15}$")) {
                throw new IllegalArgumentException("Số điện thoại phải từ 9 đến 15 chữ số.");
            }
        } else {
            phone = null;
        }

        if (studentCode != null && !studentCode.trim().isEmpty()) {
            studentCode = studentCode.trim().toUpperCase();
        } else {
            studentCode = null;
        }

        // 2. Kiểm tra tài khoản đã tồn tại chưa
        if (userDAO.checkUsernameExists(username)) {
            throw new IllegalStateException("Tên đăng nhập '" + username + "' đã được sử dụng.");
        }
        if (userDAO.checkEmailExists(email)) {
            throw new IllegalStateException("Email '" + email + "' đã được đăng ký.");
        }

        // 3. Mã hóa mật khẩu bằng SHA-256
        String hashedPassword = PasswordUtil.hashPassword(password);

        // 4. Tạo đối tượng User với role mặc định là STUDENT (3)
        User newUser = new User(Role.STUDENT, username, hashedPassword, fullName, email, phone, studentCode, classId);

        // 5. Lưu vào Database
        String err = userDAO.insert(newUser);
        if (err != null) {
            throw new Exception("Lỗi khi lưu vào cơ sở dữ liệu: " + err);
        }

        // 6. Lấy lại thông tin đầy đủ kèm user_id từ database
        User created = userDAO.getUserByUsername(username);
        return created;
    }

    /**
     * Đăng nhập hệ thống.
     *
     * @param username tên đăng nhập
     * @param password mật khẩu thô
     * @return User nếu thành công
     * @throws Exception nếu tài khoản không tồn tại hoặc sai mật khẩu
     */
    public User login(String username, String password) throws Exception {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập tên đăng nhập.");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập mật khẩu.");
        }

        username = username.trim();
        User user = userDAO.getUserByUsername(username);
        if (user == null) {
            throw new IllegalArgumentException("Tài khoản '" + username + "' không tồn tại trong hệ thống.");
        }

        // Kiểm tra mật khẩu (hỗ trợ SHA-256 và dữ liệu mẫu)
        boolean isMatch = PasswordUtil.verifyPassword(password, user.getPassword_hash());
        if (!isMatch) {
            throw new IllegalArgumentException("Mật khẩu không chính xác.");
        }

        return user;
    }
}
