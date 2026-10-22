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
                   + "WHERE u.role_id = 3 "
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
     * So sánh xem 2 chủ đề có tương đồng (trùng lặp ý) hay không.
     * Ví dụ: "Xử lý điều kiện biên trong Doubly Linked List" và "Xử lý điều kiện biên và con trỏ trong Doubly Linked List"
     */
    private boolean isSimilarTopic(String t1, String t2) {
        if (t1 == null || t2 == null) return false;
        String s1 = t1.toLowerCase().trim();
        String s2 = t2.toLowerCase().trim();
        if (s1.equals(s2) || s1.contains(s2) || s2.contains(s1)) {
            return true;
        }
        String[] words1 = s1.split("\\s+");
        String[] words2 = s2.split("\\s+");
        int matchCount = 0;
        int meaningfulWords = 0;
        for (String w1 : words1) {
            if (w1.length() <= 2) continue; // Bỏ qua từ đệm như và, ở, in, on...
            meaningfulWords++;
            for (String w2 : words2) {
                if (w1.equals(w2)) {
                    matchCount++;
                    break;
                }
            }
        }
        return meaningfulWords > 0 && ((double) matchCount / meaningfulWords) >= 0.6;
    }

    /**
     * Thêm một mục điểm yếu mới do AI Tutor phát hiện vào lộ trình của sinh viên.
     * Nếu chủ đề đã tồn tại ở trạng thái IN_PROGRESS thì chỉ cập nhật hành động mới nhất.
     * Nếu sinh viên đã hoàn thành (COMPLETED) chủ đề tương tự thì không tự ý tạo lại để tránh làm phiền.
     */
    public boolean addLearningPath(int studentId, String weaknessTopic, String recommendedAction) {
        if (weaknessTopic == null || weaknessTopic.trim().isEmpty()) return false;
        String cleanTopic = weaknessTopic.replaceAll("\\s+", " ").trim();

        // Kiểm tra xem đã tồn tại chủ đề tương tự chưa
        String checkSql = "SELECT path_id, weakness_topic, status FROM Personalized_Learning_Paths "
                        + "WHERE student_id = ? "
                        + "ORDER BY created_at DESC";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, studentId);
            try (ResultSet rs = checkPs.executeQuery()) {
                while (rs.next()) {
                    String existingTopic = rs.getString("weakness_topic");
                    String status = rs.getString("status");
                    int pathId = rs.getInt("path_id");

                    if (isSimilarTopic(cleanTopic, existingTopic)) {
                        if ("IN_PROGRESS".equalsIgnoreCase(status)) {
                            // Đã tồn tại mục đang học -> chỉ cập nhật hành động mới nhất
                            String updateSql = "UPDATE Personalized_Learning_Paths SET recommended_action = ?, created_at = GETDATE() WHERE path_id = ?";
                            try (PreparedStatement upPs = connection.prepareStatement(updateSql)) {
                                upPs.setString(1, recommendedAction);
                                upPs.setInt(2, pathId);
                                return upPs.executeUpdate() > 0;
                            }
                        } else if ("COMPLETED".equalsIgnoreCase(status)) {
                            // Đã hoàn thành mục tương tự trước đó -> không tự động spam lại mục mới
                            return false;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Nếu chưa có chủ đề tương tự, thêm mới
        String insertSql = "INSERT INTO Personalized_Learning_Paths (student_id, weakness_topic, recommended_action, status, created_at) "
                         + "VALUES (?, ?, ?, 'IN_PROGRESS', GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(insertSql)) {
            ps.setInt(1, studentId);
            ps.setString(2, cleanTopic);
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
