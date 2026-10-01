package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.User;
import util.DBContext;

/**
 * Data Access Object (DAO) thực hiện các thao tác CRUD và truy vấn bảng Users
 * trong database AITA_DB trên MS SQL Server.
 */
public class UserDAO extends DBContext {

    /**
     * Map một dòng ResultSet sang đối tượng User đầy đủ
     */
    private User mapRowToUser(ResultSet rs) throws SQLException {
        int userId = rs.getInt("user_id");
        int roleId = rs.getInt("role_id");
        String username = rs.getString("username");
        String passwordHash = rs.getString("password_hash");
        String fullName = rs.getString("full_name");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        String studentCode = rs.getString("student_code");
        
        Integer classId = null;
        int cid = rs.getInt("class_id");
        if (!rs.wasNull()) {
            classId = cid;
        }
        
        java.sql.Timestamp createdAt = rs.getTimestamp("created_at");

        return new User(userId, roleId, username, passwordHash, fullName, email, phone, studentCode, classId, createdAt);
    }

    /**
     * Lấy toàn bộ danh sách người dùng trong hệ thống
     * @return danh sách User
     */
    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, role_id, username, password_hash, full_name, email, phone, student_code, class_id, created_at "
                   + "FROM dbo.Users ORDER BY user_id ASC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getAll Users: " + e.getMessage());
        }
        return list;
    }

    /**
     * Thêm mới người dùng vào database
     * @param u đối tượng User cần thêm
     * @return null nếu thành công, hoặc chuỗi thông báo lỗi nếu thất bại
     */
    public String insert(User u) {
        String sql = "INSERT INTO dbo.Users (role_id, username, password_hash, full_name, email, phone, student_code, class_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, u.getRole_id());
            st.setString(2, u.getUsername());
            st.setString(3, u.getPassword_hash());
            st.setString(4, u.getFull_name());
            st.setString(5, u.getEmail());
            
            if (u.getPhone() != null && !u.getPhone().trim().isEmpty()) {
                st.setString(6, u.getPhone());
            } else {
                st.setNull(6, Types.VARCHAR);
            }

            if (u.getStudent_code() != null && !u.getStudent_code().trim().isEmpty()) {
                st.setString(7, u.getStudent_code());
            } else {
                st.setNull(7, Types.VARCHAR);
            }

            if (u.getClass_id() != null && u.getClass_id() > 0) {
                st.setInt(8, u.getClass_id());
            } else {
                st.setNull(8, Types.INTEGER);
            }

            st.executeUpdate();
            return null;
        } catch (SQLException e) {
            System.err.println("Lỗi insert User: " + e.getMessage());
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                if (e.getMessage().contains("username")) {
                    return "Tên đăng nhập '" + u.getUsername() + "' đã tồn tại trong hệ thống.";
                }
                if (e.getMessage().contains("email")) {
                    return "Email '" + u.getEmail() + "' đã được sử dụng.";
                }
                if (e.getMessage().contains("student_code")) {
                    return "Mã sinh viên '" + u.getStudent_code() + "' đã tồn tại.";
                }
            }
            return e.getMessage();
        }
    }

    /**
     * Lấy thông tin người dùng theo user_id
     * @param user_id khóa chính
     * @return đối tượng User nếu tìm thấy, null nếu không tìm thấy
     */
    public User getUserById(int user_id) {
        String sql = "SELECT user_id, role_id, username, password_hash, full_name, email, phone, student_code, class_id, created_at "
                   + "FROM dbo.Users WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, user_id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getUserById: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy thông tin người dùng theo username
     * @param username tên đăng nhập
     * @return đối tượng User nếu tìm thấy, null nếu không tồn tại
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT user_id, role_id, username, password_hash, full_name, email, phone, student_code, class_id, created_at "
                   + "FROM dbo.Users WHERE username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getUserByUsername: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy thông tin người dùng theo email
     * @param email email người dùng
     * @return đối tượng User nếu tìm thấy, null nếu không tồn tại
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT user_id, role_id, username, password_hash, full_name, email, phone, student_code, class_id, created_at "
                   + "FROM dbo.Users WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getUserByEmail: " + e.getMessage());
        }
        return null;
    }

    /**
     * Tìm kiếm người dùng theo username (chứa từ khóa)
     * @param keyword từ khóa tìm kiếm
     * @return danh sách người dùng phù hợp
     */
    public List<User> searchByUsername(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, role_id, username, password_hash, full_name, email, phone, student_code, class_id, created_at "
                   + "FROM dbo.Users WHERE username LIKE ? ORDER BY user_id ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi searchByUsername: " + e.getMessage());
        }
        return list;
    }

    /**
     * Xóa người dùng theo user_id
     * @param user_id ID cần xóa
     * @return null nếu xóa thành công, hoặc chuỗi mô tả lỗi nếu thất bại
     */
    public String delete(int user_id) {
        String sql = "DELETE FROM dbo.Users WHERE user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, user_id);
            int rows = st.executeUpdate();
            if (rows > 0) {
                return null;
            } else {
                return "Không tìm thấy người dùng có ID " + user_id + " để xóa.";
            }
        } catch (SQLException e) {
            System.err.println("Lỗi delete User: " + e.getMessage());
            // Mã lỗi 547 trong SQL Server là Foreign Key Violation
            if (e.getErrorCode() == 547) {
                return "Không thể xóa người dùng này vì đã có dữ liệu liên kết ràng buộc (bài tập, môn học, bài nộp, v.v.).";
            }
            return e.getMessage();
        }
    }

    /**
     * Cập nhật thông tin người dùng (cho quyền Quản trị viên Admin)
     * @param u đối tượng User chứa thông tin mới
     * @return null nếu thành công, hoặc chuỗi mô tả lỗi nếu thất bại
     */
    public String update(User u) {
        String sql = "UPDATE dbo.Users SET role_id=?, username=?, full_name=?, email=?, phone=?, student_code=?, class_id=? "
                   + "WHERE user_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, u.getRole_id());
            st.setString(2, u.getUsername());
            st.setString(3, u.getFull_name());
            st.setString(4, u.getEmail());
            
            if (u.getPhone() != null && !u.getPhone().trim().isEmpty()) {
                st.setString(5, u.getPhone());
            } else {
                st.setNull(5, Types.VARCHAR);
            }

            if (u.getStudent_code() != null && !u.getStudent_code().trim().isEmpty()) {
                st.setString(6, u.getStudent_code());
            } else {
                st.setNull(6, Types.VARCHAR);
            }

            if (u.getClass_id() != null && u.getClass_id() > 0) {
                st.setInt(7, u.getClass_id());
            } else {
                st.setNull(7, Types.INTEGER);
            }

            st.setInt(8, u.getUser_id());
            int rows = st.executeUpdate();
            if (rows > 0) {
                return null;
            } else {
                return "Không tìm thấy người dùng có ID " + u.getUser_id() + " để cập nhật.";
            }
        } catch (SQLException e) {
            System.err.println("Lỗi update User: " + e.getMessage());
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                return "Cập nhật thất bại do trùng lặp username, email hoặc mã sinh viên.";
            }
            return e.getMessage();
        }
    }

    /**
     * Cập nhật thông tin cá nhân (dành cho Sinh viên - không đổi role_id, không đổi username)
     * @param u đối tượng User với thông tin cá nhân mới
     * @return null nếu thành công, hoặc lỗi nếu thất bại
     */
    public String updateProfile(User u) {
        String sql = "UPDATE dbo.Users SET full_name=?, email=?, phone=?, class_id=? "
                   + "WHERE user_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, u.getFull_name());
            st.setString(2, u.getEmail());

            if (u.getPhone() != null && !u.getPhone().trim().isEmpty()) {
                st.setString(3, u.getPhone());
            } else {
                st.setNull(3, Types.VARCHAR);
            }

            if (u.getClass_id() != null && u.getClass_id() > 0) {
                st.setInt(4, u.getClass_id());
            } else {
                st.setNull(4, Types.INTEGER);
            }

            st.setInt(5, u.getUser_id());
            int rows = st.executeUpdate();
            if (rows > 0) {
                return null;
            } else {
                return "Không tìm thấy tài khoản để cập nhật thông tin cá nhân.";
            }
        } catch (SQLException e) {
            System.err.println("Lỗi updateProfile User: " + e.getMessage());
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                return "Cập nhật thất bại do email đã tồn tại ở tài khoản khác.";
            }
            return e.getMessage();
        }
    }

    /**
     * Cập nhật mật khẩu cho người dùng
     * @param userId ID người dùng
     * @param newPasswordHash mật khẩu đã được băm SHA-256
     * @return null nếu thành công, hoặc lỗi nếu thất bại
     */
    public String updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE dbo.Users SET password_hash=? WHERE user_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newPasswordHash);
            st.setInt(2, userId);
            st.executeUpdate();
            return null;
        } catch (SQLException e) {
            return e.getMessage();
        }
    }

    /**
     * Kiểm tra username đã tồn tại chưa
     */
    public boolean checkUsernameExists(String username) {
        return getUserByUsername(username) != null;
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     */
    public boolean checkEmailExists(String email) {
        return getUserByEmail(email) != null;
    }
}