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
                    cr.setCourse_code("PRJ301 (Java Web)");
                    cr.setSchedule("Thứ 2, 4 (Ca 2: 09:30 - 11:50)");
                    cr.setRoom("Phòng Alpha 302");
                } else if (code.startsWith("SE1802")) {
                    cr.setCourse_code("PRJ301 (Java Web)");
                    cr.setSchedule("Thứ 3, 5 (Ca 3: 13:00 - 15:20)");
                    cr.setRoom("Phòng Beta 204");
                } else if (code.startsWith("IA")) {
                    cr.setCourse_code("IAO201 (An toàn thông tin)");
                    cr.setSchedule("Thứ 4, 6 (Ca 4: 15:30 - 17:50)");
                    cr.setRoom("Phòng Lab Cyber 101");
                }
                list.add(cr);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getAllClassesWithCount: " + e.getMessage());
        }
        return list;
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
