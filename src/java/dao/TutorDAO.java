package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.TutorMessage;
import model.TutorSession;
import util.DBContext;

/**
 * Data Access Object cho Tutor_Sessions và Tutor_Messages.
 */
public class TutorDAO extends DBContext {

    /**
     * Tạo hoặc lấy phiên chat gần nhất của sinh viên.
     */
    public int getOrCreateActiveSession(int studentId, Integer submissionId, String errorType, String rawError) {
        String findSql = "SELECT TOP 1 session_id FROM Tutor_Sessions "
                       + "WHERE student_id = ? "
                       + "ORDER BY started_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(findSql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("session_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Tạo phiên mới
        return createNewSession(studentId, submissionId, errorType, rawError);
    }

    public int createNewSession(int studentId, Integer submissionId, String errorType, String rawError) {
        String insertSql = "INSERT INTO Tutor_Sessions (student_id, submission_id, error_type, raw_error_message, started_at) "
                         + "VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, studentId);
            if (submissionId != null && submissionId > 0) {
                ps.setInt(2, submissionId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, errorType);
            ps.setString(4, rawError);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Returns a student's recent conversations with a short, safe display title. */
    public List<TutorSession> getRecentSessions(int studentId) {
        List<TutorSession> sessions = new ArrayList<>();
        String sql = "SELECT TOP 20 s.session_id, s.student_id, s.submission_id, s.error_type, s.raw_error_message, s.started_at, "
                   + "COALESCE((SELECT TOP 1 LEFT(m.message_text, 60) FROM Tutor_Messages m "
                   + "WHERE m.session_id = s.session_id AND m.sender_type = 'STUDENT' ORDER BY m.message_id ASC), N'Cuộc trò chuyện mới') AS display_title, "
                   + "COALESCE((SELECT MAX(m.sent_at) FROM Tutor_Messages m WHERE m.session_id = s.session_id), s.started_at) AS last_activity "
                   + "FROM Tutor_Sessions s WHERE s.student_id = ? "
                   + "ORDER BY last_activity DESC, s.session_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TutorSession item = new TutorSession(rs.getInt("session_id"), rs.getInt("student_id"),
                            (Integer) rs.getObject("submission_id"), rs.getString("error_type"),
                            rs.getString("raw_error_message"), rs.getTimestamp("started_at"));
                    item.setDisplayTitle(rs.getString("display_title"));
                    item.setLastActivityAt(rs.getTimestamp("last_activity"));
                    sessions.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessions;
    }

    /** Avoids loading another student's conversation when a session id comes from the browser. */
    public boolean belongsToStudent(int sessionId, int studentId) {
        String sql = "SELECT 1 FROM Tutor_Sessions WHERE session_id = ? AND student_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lưu tin nhắn hội thoại giữa sinh viên và AI
     */
    public boolean saveMessage(int sessionId, String senderType, String text) {
        String sql = "INSERT INTO Tutor_Messages (session_id, sender_type, message_text, sent_at) "
                   + "VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            ps.setString(2, senderType);
            ps.setString(3, text);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách tin nhắn của 1 phiên chat
     */
    public List<TutorMessage> getMessagesBySession(int sessionId) {
        List<TutorMessage> list = new ArrayList<>();
        String sql = "SELECT message_id, session_id, sender_type, message_text, sent_at "
                   + "FROM Tutor_Messages WHERE session_id = ? ORDER BY sent_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TutorMessage m = new TutorMessage(
                        rs.getInt("message_id"),
                        rs.getInt("session_id"),
                        rs.getString("sender_type"),
                        rs.getString("message_text"),
                        rs.getTimestamp("sent_at")
                    );
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Xóa 1 phiên hội thoại cùng toàn bộ tin nhắn thuộc phiên đó của sinh viên.
     */
    public boolean deleteSession(int sessionId, int studentId) {
        if (!belongsToStudent(sessionId, studentId)) {
            return false;
        }
        String deleteMessagesSql = "DELETE FROM Tutor_Messages WHERE session_id = ?";
        String deleteSessionSql = "DELETE FROM Tutor_Sessions WHERE session_id = ?";
        try {
            try (PreparedStatement psMsg = connection.prepareStatement(deleteMessagesSql)) {
                psMsg.setInt(1, sessionId);
                psMsg.executeUpdate();
            }
            try (PreparedStatement psSes = connection.prepareStatement(deleteSessionSql)) {
                psSes.setInt(1, sessionId);
                return psSes.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
