package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.PersonalizedLearningPath;
import util.DBContext;

/**
 * Data Access Object cho Lộ trình học tập cá nhân hóa (Personalized_Learning_Paths).
 */
public class LearningPathDAO extends DBContext {

    /**
     * Lấy danh sách lộ trình học tập cá nhân của một sinh viên cụ thể.
     */
    public List<PersonalizedLearningPath> getPathsByStudent(int studentId) {
        List<PersonalizedLearningPath> list = new ArrayList<>();
        String sql = "SELECT path_id, student_id, weakness_topic, recommended_action, status, created_at "
                   + "FROM Personalized_Learning_Paths "
                   + "WHERE student_id = ? AND weakness_topic <> N'Lộ trình học tập lập trình cá nhân' "
                   + "ORDER BY CASE WHEN status = 'IN_PROGRESS' THEN 0 ELSE 1 END, created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PersonalizedLearningPath p = new PersonalizedLearningPath(
                        rs.getInt("path_id"),
                        rs.getInt("student_id"),
                        rs.getString("weakness_topic"),
                        rs.getString("recommended_action"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at")
                    );
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy toàn bộ lộ trình kèm thông tin sinh viên dành cho Giảng viên / Admin theo dõi.
     */
    public List<PersonalizedLearningPath> getAllPaths() {
        List<PersonalizedLearningPath> list = new ArrayList<>();
        String sql = "SELECT p.path_id, p.student_id, p.weakness_topic, p.recommended_action, p.status, p.created_at, "
                   + "u.full_name, u.student_code "
                   + "FROM Personalized_Learning_Paths p "
                   + "JOIN Users u ON p.student_id = u.user_id "
                   + "ORDER BY p.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PersonalizedLearningPath p = new PersonalizedLearningPath(
                    rs.getInt("path_id"),
                    rs.getInt("student_id"),
                    rs.getString("weakness_topic"),
                    rs.getString("recommended_action"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                );
                p.setStudentName(rs.getString("full_name"));
                p.setStudentCode(rs.getString("student_code"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm một mục điểm yếu mới do AI Tutor phát hiện vào lộ trình của sinh viên.
     * Nếu chủ đề đã tồn tại ở trạng thái IN_PROGRESS thì chỉ cập nhật thời gian hoặc bỏ qua.
     */
    public boolean addLearningPath(int studentId, String weaknessTopic, String recommendedAction) {
        // Kiểm tra xem đã tồn tại chủ đề này chưa
        String checkSql = "SELECT path_id FROM Personalized_Learning_Paths "
                        + "WHERE student_id = ? AND weakness_topic = ? AND status = 'IN_PROGRESS'";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, studentId);
            checkPs.setString(2, weaknessTopic);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Đã tồn tại mục này đang học -> cập nhật lại hành động mới nhất
                    String updateSql = "UPDATE Personalized_Learning_Paths SET recommended_action = ?, created_at = GETDATE() WHERE path_id = ?";
                    try (PreparedStatement upPs = connection.prepareStatement(updateSql)) {
                        upPs.setString(1, recommendedAction);
                        upPs.setInt(2, rs.getInt("path_id"));
                        return upPs.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Nếu chưa có, thêm mới
        String insertSql = "INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at) "
                         + "VALUES (?, ?, ?, 'IN_PROGRESS', GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(insertSql)) {
            ps.setInt(1, studentId);
            ps.setString(2, weaknessTopic);
            ps.setString(3, recommendedAction);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật trạng thái của mục lộ trình ('COMPLETED', 'IN_PROGRESS', 'SKIPPED')
     */
    public boolean updateStatus(int pathId, int studentId, String status) {
        String sql = "UPDATE Personalized_Learning_Paths SET status = ? WHERE path_id = ? AND student_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, pathId);
            ps.setInt(3, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
