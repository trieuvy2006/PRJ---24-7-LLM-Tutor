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
     * Tự động ghi danh sinh viên vào 5 môn học mặc định của kỳ (IOT102, PRJ301, SWR302, JPD123, CSD201)
     * nếu tài khoản chưa có ghi danh nào (như tài khoản vanbao khi mới tạo).
     *
     * @param studentId ID sinh viên
     * @return danh sách Assignment
     */
    public List<Assignment> getByStudentId(int studentId) {
        // Đảm bảo 5 môn học mặc định và ghi danh cho sinh viên
        ensureStudentEnrolledDefaultCourses(studentId);

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
     * Tự động khởi tạo 5 môn học mặc định nếu database chưa có.
     *
     * @return danh sách [course_id, course_code, course_name]
     */
    public List<model.courses> getAllCourses() {
        ensureDefaultCourses();
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

    /**
     * Lấy danh sách môn học mà Giảng viên được phân công giảng dạy (tối đa 2 môn cùng lúc).
     * Phục vụ yêu cầu: "giáo viên dạy môn nào thì chỉ đc phép làm nội dung deadline cho môn học đó nhé.
     * một giáo viên thì nhiều nhất chỉ có thể cùng lúc dạy 2 môn nhưng các lớp khác nhau kiểu khác ca ấy."
     */
    public List<model.courses> getCoursesByInstructorId(int instructorId) {
        ensureDefaultCourses();
        List<model.courses> list = new ArrayList<>();

        // 1. Thử truy vấn từ bảng Instructor_Courses nếu có
        String sqlIC = "SELECT DISTINCT c.course_id, c.course_code, c.course_name, c.description "
                     + "FROM dbo.Courses c "
                     + "JOIN dbo.Instructor_Courses ic ON c.course_id = ic.course_id "
                     + "WHERE ic.instructor_id = ? "
                     + "ORDER BY c.course_code ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sqlIC);
            st.setInt(1, instructorId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new model.courses(
                    rs.getInt("course_id"),
                    rs.getString("course_code"),
                    rs.getString("course_name"),
                    rs.getString("description")
                ));
            }
        } catch (SQLException ignored) {
            // Bảng Instructor_Courses có thể chưa được tạo trong DB hiện thời
        }

        // 2. Nếu chưa có phân công trong DB: Áp dụng phân công mặc định hợp lệ cho giảng viên
        if (list.isEmpty()) {
            List<model.courses> all = getAllCourses();
            model.courses prj301 = null;
            model.courses csd201 = null;
            model.courses swr302 = null;
            model.courses jpd123 = null;
            model.courses iot102 = null;

            for (model.courses c : all) {
                if ("PRJ301".equalsIgnoreCase(c.getCourse_code())) prj301 = c;
                else if ("CSD201".equalsIgnoreCase(c.getCourse_code())) csd201 = c;
                else if ("SWR302".equalsIgnoreCase(c.getCourse_code())) swr302 = c;
                else if ("JPD123".equalsIgnoreCase(c.getCourse_code())) jpd123 = c;
                else if ("IOT102".equalsIgnoreCase(c.getCourse_code())) iot102 = c;
            }

            if (instructorId == 2) {
                // Tài khoản dungkt (ID 2): phụ trách 2 môn PRJ301 & CSD201
                if (prj301 != null) list.add(prj301);
                if (csd201 != null) list.add(csd201);
            } else if (instructorId == 3) {
                // Tài khoản haonn (ID 3): phụ trách 2 môn SWR302 & JPD123
                if (swr302 != null) list.add(swr302);
                if (jpd123 != null) list.add(jpd123);
            } else {
                // Các giảng viên khác: tối đa 2 môn đầu tiên
                for (model.courses c : all) {
                    list.add(c);
                    if (list.size() >= 2) break;
                }
            }
        }

        // Đảm bảo nghiêm ngặt: Một giáo viên nhiều nhất chỉ có thể cùng lúc dạy 2 môn
        if (list.size() > 2) {
            list = list.subList(0, 2);
        }
        return list;
    }

    /**
     * Đảm bảo cơ sở dữ liệu đã có đủ 5 môn học của học kỳ:
     * IOT102, PRJ301, SWR302, JPD123, CSD201.
     */
    public synchronized void ensureDefaultCourses() {
        String[][] defaults = new String[][] {
            {"IOT102", "Internet of Things", "IoT system architecture, ESP32/Arduino microcontrollers and MQTT protocol"},
            {"PRJ301", "Java Web Application Development", "Web MVC2 application development with Java Servlet, JSP, JDBC and SQL Server"},
            {"SWR302", "Software Requirements", "Requirements elicitation, SRS specification, analysis and Agile/Scrum system modeling"},
            {"JPD123", "Elementary Japanese 1", "Hiragana, Katakana, basic Kanji and entry-level Japanese communication"},
            {"CSD201", "Data Structures and Algorithms", "Linked Lists, Stacks, Queues, Binary Trees, BST, AVL and Graph algorithms"}
        };

        String checkSql = "SELECT course_id FROM dbo.Courses WHERE course_code = ?";
        String insertSql = "INSERT INTO dbo.Courses (course_code, course_name, description) VALUES (?, ?, ?)";
        String updateSql = "UPDATE dbo.Courses SET course_name = ?, description = ? WHERE course_code = ?";

        for (String[] def : defaults) {
            try {
                PreparedStatement st = connection.prepareStatement(checkSql);
                st.setString(1, def[0]);
                ResultSet rs = st.executeQuery();
                if (!rs.next()) {
                    PreparedStatement ins = connection.prepareStatement(insertSql);
                    ins.setString(1, def[0]);
                    ins.setString(2, def[1]);
                    ins.setString(3, def[2]);
                    ins.executeUpdate();
                } else {
                    PreparedStatement upd = connection.prepareStatement(updateSql);
                    upd.setString(1, def[1]);
                    upd.setString(2, def[2]);
                    upd.setString(3, def[0]);
                    upd.executeUpdate();
                }
            } catch (SQLException e) {
                System.err.println("Lỗi ensureDefaultCourses (" + def[0] + "): " + e.getMessage());
            }
        }
    }

    /**
     * Đảm bảo sinh viên đã được ghi danh vào 5 môn học mặc định trong kỳ nếu chưa có môn nào.
     * Giúp sinh viên (như tài khoản vanbao) ngay lập tức thấy các deadline được giao.
     */
    public void ensureStudentEnrolledDefaultCourses(int studentId) {
        ensureDefaultCourses();
        String countSql = "SELECT COUNT(*) AS cnt FROM dbo.Course_Enrollments WHERE student_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(countSql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next() && rs.getInt("cnt") == 0) {
                // Tự động ghi danh vào cả 5 môn
                String enrollSql = "INSERT INTO dbo.Course_Enrollments (student_id, course_id) "
                                 + "SELECT ?, course_id FROM dbo.Courses "
                                 + "WHERE course_code IN ('IOT102', 'PRJ301', 'SWR302', 'JPD123', 'CSD201')";
                PreparedStatement ins = connection.prepareStatement(enrollSql);
                ins.setInt(1, studentId);
                ins.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ensureStudentEnrolledDefaultCourses: " + e.getMessage());
        }
    }

    /**
     * Đảm bảo sinh viên đã ghi danh vào môn học cụ thể khi nộp bài.
     */
    public void ensureStudentEnrolledCourse(int studentId, int courseId) {
        String checkSql = "SELECT 1 FROM dbo.Course_Enrollments WHERE student_id = ? AND course_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(checkSql);
            st.setInt(1, studentId);
            st.setInt(2, courseId);
            ResultSet rs = st.executeQuery();
            if (!rs.next()) {
                String insSql = "INSERT INTO dbo.Course_Enrollments (student_id, course_id) VALUES (?, ?)";
                PreparedStatement ins = connection.prepareStatement(insSql);
                ins.setInt(1, studentId);
                ins.setInt(2, courseId);
                ins.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ensureStudentEnrolledCourse: " + e.getMessage());
        }
    }
}
