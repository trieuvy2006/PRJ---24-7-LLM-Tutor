package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Assignment;
import util.DBContext;

/**
 * Data Access Object (DAO) thực hiện các thao tác CRUD và truy vấn bảng Assignments
 * trong database AITA_DB trên MS SQL Server.
 */
public class AssignmentDAO extends DBContext {

    /**
     * Map một dòng ResultSet (kết quả JOIN) sang đối tượng Assignment đầy đủ.
     */
    private Assignment mapRowToAssignment(ResultSet rs) throws SQLException {
        Assignment a = new Assignment();
        a.setAssignment_id(rs.getInt("assignment_id"));
        a.setCourse_id(rs.getInt("course_id"));
        a.setCreated_by(rs.getInt("created_by"));
        a.setTitle(rs.getString("title"));
        a.setDescription(rs.getString("description"));
        a.setDeadline(rs.getTimestamp("deadline"));
        a.setCreated_at(rs.getTimestamp("created_at"));

        // Các cột JOIN (có thể null nếu query không JOIN)
        try { a.setCourse_code(rs.getString("course_code")); } catch (SQLException ignored) {}
        try { a.setCourse_name(rs.getString("course_name")); } catch (SQLException ignored) {}
        try { a.setCreated_by_name(rs.getString("created_by_name")); } catch (SQLException ignored) {}
        return a;
    }

    /**
     * Lấy toàn bộ danh sách bài tập kèm thông tin môn học và người tạo.
     *
     * @return danh sách Assignment
     */
    public List<Assignment> getAll() {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.assignment_id, a.course_id, a.created_by, a.title, a.description, "
                   + "       a.deadline, a.created_at, "
                   + "       c.course_code, c.course_name, "
                   + "       u.full_name AS created_by_name "
                   + "FROM dbo.Assignments a "
                   + "JOIN dbo.Courses c ON a.course_id = c.course_id "
                   + "JOIN dbo.Users u   ON a.created_by  = u.user_id "
                   + "ORDER BY a.deadline ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToAssignment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getAll Assignments: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách bài tập mà sinh viên được đăng ký học (theo enrollment).
     *
     * @param studentId ID sinh viên
     * @return danh sách Assignment
     */
    public List<Assignment> getByStudentId(int studentId) {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.assignment_id, a.course_id, a.created_by, a.title, a.description, "
                   + "       a.deadline, a.created_at, "
                   + "       c.course_code, c.course_name, "
                   + "       u.full_name AS created_by_name "
                   + "FROM dbo.Assignments a "
                   + "JOIN dbo.Courses c ON a.course_id = c.course_id "
                   + "JOIN dbo.Users u   ON a.created_by = u.user_id "
                   + "WHERE a.course_id IN ( "
                   + "    SELECT course_id FROM dbo.Course_Enrollments WHERE student_id = ? "
                   + ") "
                   + "ORDER BY a.deadline ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToAssignment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getByStudentId Assignments: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách bài tập do một giảng viên tạo.
     *
     * @param instructorId ID giảng viên
     * @return danh sách Assignment
     */
    public List<Assignment> getByInstructorId(int instructorId) {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.assignment_id, a.course_id, a.created_by, a.title, a.description, "
                   + "       a.deadline, a.created_at, "
                   + "       c.course_code, c.course_name, "
                   + "       u.full_name AS created_by_name "
                   + "FROM dbo.Assignments a "
                   + "JOIN dbo.Courses c ON a.course_id = c.course_id "
                   + "JOIN dbo.Users u   ON a.created_by = u.user_id "
                   + "WHERE a.created_by = ? "
                   + "ORDER BY a.deadline ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, instructorId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToAssignment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getByInstructorId Assignments: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy thông tin bài tập theo assignment_id.
     *
     * @param id khóa chính
     * @return đối tượng Assignment nếu tìm thấy, null nếu không
     */
    public Assignment getById(int id) {
        String sql = "SELECT a.assignment_id, a.course_id, a.created_by, a.title, a.description, "
                   + "       a.deadline, a.created_at, "
                   + "       c.course_code, c.course_name, "
                   + "       u.full_name AS created_by_name "
                   + "FROM dbo.Assignments a "
                   + "JOIN dbo.Courses c ON a.course_id = c.course_id "
                   + "JOIN dbo.Users u   ON a.created_by = u.user_id "
                   + "WHERE a.assignment_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRowToAssignment(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getById Assignment: " + e.getMessage());
        }
        return null;
    }

    /**
     * Thêm bài tập mới vào database.
     *
     * @param a đối tượng Assignment cần thêm
     * @return null nếu thành công, hoặc chuỗi lỗi nếu thất bại
     */
    public String insert(Assignment a) {
        String sql = "INSERT INTO dbo.Assignments (course_id, created_by, title, description, deadline) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, a.getCourse_id());
            st.setInt(2, a.getCreated_by());
            st.setString(3, a.getTitle());
            st.setString(4, a.getDescription());
            st.setTimestamp(5, a.getDeadline());
            st.executeUpdate();
            return null;
        } catch (SQLException e) {
            System.err.println("Lỗi insert Assignment: " + e.getMessage());
            return e.getMessage();
        }
    }

    /**
     * Cập nhật thông tin bài tập (bao gồm chỉnh sửa deadline).
     *
     * @param a đối tượng Assignment chứa dữ liệu mới
     * @return null nếu thành công, hoặc chuỗi lỗi nếu thất bại
     */
    public String update(Assignment a) {
        String sql = "UPDATE dbo.Assignments SET course_id=?, title=?, description=?, deadline=? "
                   + "WHERE assignment_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, a.getCourse_id());
            st.setString(2, a.getTitle());
            st.setString(3, a.getDescription());
            st.setTimestamp(4, a.getDeadline());
            st.setInt(5, a.getAssignment_id());
            int rows = st.executeUpdate();
            return rows > 0 ? null : "Không tìm thấy bài tập để cập nhật.";
        } catch (SQLException e) {
            System.err.println("Lỗi update Assignment: " + e.getMessage());
            return e.getMessage();
        }
    }

    /**
     * Chỉ cập nhật deadline của bài tập (tiện ích nhanh cho Giảng viên).
     *
     * @param assignmentId ID bài tập
     * @param newDeadline  deadline mới
     * @return null nếu thành công, hoặc chuỗi lỗi nếu thất bại
     */
    public String updateDeadline(int assignmentId, Timestamp newDeadline) {
        String sql = "UPDATE dbo.Assignments SET deadline=? WHERE assignment_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setTimestamp(1, newDeadline);
            st.setInt(2, assignmentId);
            int rows = st.executeUpdate();
            return rows > 0 ? null : "Không tìm thấy bài tập để cập nhật deadline.";
        } catch (SQLException e) {
            System.err.println("Lỗi updateDeadline Assignment: " + e.getMessage());
            return e.getMessage();
        }
    }

    /**
     * Xóa bài tập theo assignment_id.
     * Lưu ý: sẽ thất bại nếu còn bài nộp liên kết (FK constraint).
     *
     * @param id ID bài tập cần xóa
     * @return null nếu thành công, hoặc chuỗi lỗi nếu thất bại
     */
    public String delete(int id) {
        String sql = "DELETE FROM dbo.Assignments WHERE assignment_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            int rows = st.executeUpdate();
            return rows > 0 ? null : "Không tìm thấy bài tập để xóa.";
        } catch (SQLException e) {
            System.err.println("Lỗi delete Assignment: " + e.getMessage());
            if (e.getErrorCode() == 547) {
                return "Không thể xóa vì đã có sinh viên nộp bài cho bài tập này.";
            }
            return e.getMessage();
        }
    }

    /**
     * Lấy danh sách tất cả môn học để hiển thị dropdown khi tạo/sửa bài tập.
     *
     * @return danh sách [course_id, course_code, course_name]
     */
    public List<model.courses> getAllCourses() {
        List<model.courses> list = new ArrayList<>();
        String sql = "SELECT course_id, course_code, course_name, description FROM dbo.Courses ORDER BY course_code ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new model.courses(
                    rs.getInt("course_id"),
                    rs.getString("course_code"),
                    rs.getString("course_name"),
                    rs.getString("description")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getAllCourses: " + e.getMessage());
        }
        return list;
    }
}
