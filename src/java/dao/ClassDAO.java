package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ClassRoom;
import util.DBContext;

/**
 * Data Access Object quản lý dữ liệu Lớp học (bảng Classes) trong database AITA_DB.
 */
public class ClassDAO extends DBContext {

    /**
     * Lấy danh sách tất cả các lớp học kèm số lượng sinh viên hiện tại trong lớp.
     */
    public List<ClassRoom> getAllClassesWithCount() {
        List<ClassRoom> list = new ArrayList<>();
        String sql = "SELECT c.class_id, c.class_code, c.class_name, "
                   + "       COUNT(u.user_id) AS student_count "
                   + "FROM dbo.Classes c "
                   + "LEFT JOIN dbo.Users u ON c.class_id = u.class_id AND u.role_id = 3 "
                   + "GROUP BY c.class_id, c.class_code, c.class_name "
                   + "ORDER BY c.class_code ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("class_id");
                String code = rs.getString("class_code");
                String name = rs.getString("class_name");
                int count = rs.getInt("student_count");

                ClassRoom cr = new ClassRoom(id, code, name, count);
                if (code.startsWith("SE1801")) {
                    cr.setCourse_code("PRJ301 - Java Web Application Development");
                    cr.setSchedule("Thứ 2, 4 (Ca 2: 09:30 - 11:50)");
                    cr.setRoom("Phòng 302");
                    cr.setProgress(78);
                } else if (code.startsWith("SE1802")) {
                    cr.setCourse_code("CSD201 - Data Structures and Algorithms");
                    cr.setSchedule("Thứ 3, 5 (Ca 3: 13:00 - 15:20)");
                    cr.setRoom("Phòng 204");
                    cr.setProgress(65);
                } else if (code.startsWith("AI") || code.startsWith("IA")) {
                    cr.setCourse_code("IOT102 - Internet of Things");
                    cr.setSchedule("Thứ 4, 6 (Ca 4: 15:30 - 17:50)");
                    cr.setRoom("Phòng 405");
                    cr.setProgress(50);
                } else if (code.startsWith("SE1803")) {
                    cr.setCourse_code("SWR302 - Software Requirements");
                    cr.setSchedule("Thứ 2, 4 (Ca 1: 07:00 - 09:20)");
                    cr.setRoom("Phòng 301");
                    cr.setProgress(40);
                } else if (code.startsWith("SE1804")) {
                    cr.setCourse_code("JPD123 - Elementary Japanese 1");
                    cr.setSchedule("Thứ 3, 5 (Ca 2: 09:30 - 11:50)");
                    cr.setRoom("Phòng 510");
                    cr.setProgress(25);
                }
                list.add(cr);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getAllClassesWithCount: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách lớp học phụ trách của một Giảng viên cụ thể (theo instructorId và username).
     * Giúp giảng viên chỉ thấy lớp mình được phân công (tối đa 2 môn).
     */
    public List<ClassRoom> getClassesByInstructor(int instructorId, String username) {
        List<ClassRoom> list = new ArrayList<>();
        String sql = "SELECT c.class_id, c.class_code, c.class_name, "
                   + "       co.course_code, co.course_name, ic.shift_name, ic.room_number, "
                   + "       COUNT(u.user_id) AS student_count "
                   + "FROM dbo.Instructor_Courses ic "
                   + "JOIN dbo.Classes c ON ic.class_id = c.class_id "
                   + "JOIN dbo.Courses co ON ic.course_id = co.course_id "
                   + "LEFT JOIN dbo.Users u ON c.class_id = u.class_id AND u.role_id = 3 "
                   + "WHERE ic.instructor_id = ? "
                   + "GROUP BY c.class_id, c.class_code, c.class_name, co.course_code, co.course_name, ic.shift_name, ic.room_number "
                   + "ORDER BY c.class_code ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, instructorId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("class_id");
                    String code = rs.getString("class_code");
                    String name = rs.getString("class_name");
                    int count = rs.getInt("student_count");

                    ClassRoom cr = new ClassRoom(id, code, name, count);
                    cr.setCourse_code(rs.getString("course_code") + " - " + rs.getString("course_name"));
                    cr.setSchedule(rs.getString("shift_name"));
                    cr.setRoom(rs.getString("room_number"));
                    if (code.startsWith("SE1801")) cr.setProgress(78);
                    else if (code.startsWith("SE1802")) cr.setProgress(65);
                    else if (code.startsWith("AI") || code.startsWith("IA")) cr.setProgress(50);
                    else if (code.startsWith("SE1803")) cr.setProgress(40);
                    else if (code.startsWith("SE1804")) cr.setProgress(25);
                    list.add(cr);
                }
            }
        } catch (SQLException e) {
            System.err.println("Notice getClassesByInstructor: " + e.getMessage());
        }

        // Phân lớp fallback theo đúng phân công nếu chưa nạp Instructor_Courses
        if (list.isEmpty()) {
            List<ClassRoom> all = getAllClassesWithCount();
            for (ClassRoom cr : all) {
                String code = cr.getClass_code();
                if ("dungkt".equalsIgnoreCase(username) || instructorId == 2) {
                    if (code.startsWith("SE1801") || code.startsWith("SE1802")) {
                        list.add(cr);
                    }
                } else if ("haonn".equalsIgnoreCase(username) || instructorId == 3) {
                    if (code.startsWith("AI") || code.startsWith("IA")) {
                        list.add(cr);
                    }
                } else if ("phuctm".equalsIgnoreCase(username) || instructorId == 9) {
                    if (code.startsWith("SE1803")) {
                        list.add(cr);
                    }
                } else if ("maianhnt".equalsIgnoreCase(username) || instructorId == 10) {
                    if (code.startsWith("SE1804")) {
                        list.add(cr);
                    }
                }
            }
        }

        return list.isEmpty() ? getAllClassesWithCount() : list;
    }

    /**
     * Lấy thông tin lớp học theo ID.
     */
    public ClassRoom getClassById(int classId) {
        String sql = "SELECT class_id, class_code, class_name FROM dbo.Classes WHERE class_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, classId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new ClassRoom(rs.getInt("class_id"), rs.getString("class_code"), rs.getString("class_name"));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getClassById: " + e.getMessage());
        }
        return null;
    }
}
