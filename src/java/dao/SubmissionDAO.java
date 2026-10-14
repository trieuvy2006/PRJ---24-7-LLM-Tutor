package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Submission;
import util.DBContext;

/**
 * Data Access Object (DAO) thực hiện các thao tác CRUD và truy vấn bảng Submissions
 * trong database AITA_DB trên MS SQL Server.
 */
public class SubmissionDAO extends DBContext {

    /**
     * Map một dòng ResultSet sang đối tượng Submission đầy đủ (có hỗ trợ JOIN).
     */
    private Submission mapRowToSubmission(ResultSet rs) throws SQLException {
        Submission s = new Submission();
        s.setSubmission_id(rs.getInt("submission_id"));
        s.setAssignment_id(rs.getInt("assignment_id"));
        s.setStudent_id(rs.getInt("student_id"));
        s.setSha256_hash(rs.getString("sha256_hash"));
        s.setFile_path(rs.getString("file_path"));
        s.setAttempt_number(rs.getInt("attempt_number"));
        s.setSubmitted_at(rs.getTimestamp("submitted_at"));
        s.setStatus(rs.getString("status"));

        // Các cột JOIN (có thể null nếu query không JOIN)
        try { s.setStudent_name(rs.getString("student_name")); } catch (SQLException ignored) {}
        try { s.setStudent_code(rs.getString("student_code")); } catch (SQLException ignored) {}
        try { s.setAssignment_title(rs.getString("assignment_title")); } catch (SQLException ignored) {}
        try { s.setCourse_code(rs.getString("course_code")); } catch (SQLException ignored) {}

        // Điểm số từ bảng Grades (LEFT JOIN)
        try {
            double score = rs.getDouble("score");
            if (!rs.wasNull()) s.setScore(score);
        } catch (SQLException ignored) {}
        try { s.setFeedback(rs.getString("feedback")); } catch (SQLException ignored) {}

        return s;
    }

    /**
     * Lấy toàn bộ danh sách bài nộp (dành cho Admin xem tổng quan).
     *
     * @return danh sách Submission
     */
    public List<Submission> getAll() {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.submission_id, s.assignment_id, s.student_id, s.sha256_hash, "
                   + "       s.file_path, s.attempt_number, s.submitted_at, s.status, "
                   + "       u.full_name AS student_name, u.student_code, "
                   + "       a.title AS assignment_title, c.course_code, "
                   + "       g.score, g.feedback "
                   + "FROM dbo.Submissions s "
                   + "JOIN dbo.Users u          ON s.student_id    = u.user_id "
                   + "JOIN dbo.Assignments a     ON s.assignment_id = a.assignment_id "
                   + "JOIN dbo.Courses c         ON a.course_id     = c.course_id "
                   + "LEFT JOIN dbo.Grades g     ON s.submission_id = g.submission_id "
                   + "ORDER BY s.submitted_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToSubmission(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getAll Submissions: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách bài nộp theo assignment_id (Giảng viên xem bài nộp của 1 bài tập).
     *
     * @param assignmentId ID bài tập
     * @return danh sách Submission
     */
    public List<Submission> getByAssignmentId(int assignmentId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.submission_id, s.assignment_id, s.student_id, s.sha256_hash, "
                   + "       s.file_path, s.attempt_number, s.submitted_at, s.status, "
                   + "       u.full_name AS student_name, u.student_code, "
                   + "       a.title AS assignment_title, c.course_code, "
                   + "       g.score, g.feedback "
                   + "FROM dbo.Submissions s "
                   + "JOIN dbo.Users u          ON s.student_id    = u.user_id "
                   + "JOIN dbo.Assignments a     ON s.assignment_id = a.assignment_id "
                   + "JOIN dbo.Courses c         ON a.course_id     = c.course_id "
                   + "LEFT JOIN dbo.Grades g     ON s.submission_id = g.submission_id "
                   + "WHERE s.assignment_id = ? "
                   + "ORDER BY u.student_code ASC, s.attempt_number DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, assignmentId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToSubmission(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getByAssignmentId Submissions: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy lịch sử tất cả bài nộp của một sinh viên.
     *
     * @param studentId ID sinh viên
     * @return danh sách Submission
     */
    public List<Submission> getByStudentId(int studentId) {
        List<Submission> list = new ArrayList<>();
        String sql = "SELECT s.submission_id, s.assignment_id, s.student_id, s.sha256_hash, "
                   + "       s.file_path, s.attempt_number, s.submitted_at, s.status, "
                   + "       u.full_name AS student_name, u.student_code, "
                   + "       a.title AS assignment_title, c.course_code, "
                   + "       g.score, g.feedback "
                   + "FROM dbo.Submissions s "
                   + "JOIN dbo.Users u          ON s.student_id    = u.user_id "
                   + "JOIN dbo.Assignments a     ON s.assignment_id = a.assignment_id "
                   + "JOIN dbo.Courses c         ON a.course_id     = c.course_id "
                   + "LEFT JOIN dbo.Grades g     ON s.submission_id = g.submission_id "
                   + "WHERE s.student_id = ? "
                   + "ORDER BY s.submitted_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRowToSubmission(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getByStudentId Submissions: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy bài nộp mới nhất của một sinh viên cho một bài tập cụ thể.
     *
     * @param assignmentId ID bài tập
     * @param studentId    ID sinh viên
     * @return Submission mới nhất, hoặc null nếu chưa nộp
     */
    public Submission getLatestByStudentAndAssignment(int assignmentId, int studentId) {
        String sql = "SELECT TOP 1 s.submission_id, s.assignment_id, s.student_id, s.sha256_hash, "
                   + "       s.file_path, s.attempt_number, s.submitted_at, s.status, "
                   + "       u.full_name AS student_name, u.student_code, "
                   + "       a.title AS assignment_title, c.course_code, "
                   + "       g.score, g.feedback "
                   + "FROM dbo.Submissions s "
                   + "JOIN dbo.Users u          ON s.student_id    = u.user_id "
                   + "JOIN dbo.Assignments a     ON s.assignment_id = a.assignment_id "
                   + "JOIN dbo.Courses c         ON a.course_id     = c.course_id "
                   + "LEFT JOIN dbo.Grades g     ON s.submission_id = g.submission_id "
                   + "WHERE s.assignment_id = ? AND s.student_id = ? "
                   + "ORDER BY s.attempt_number DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, assignmentId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRowToSubmission(rs);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getLatestByStudentAndAssignment: " + e.getMessage());
        }
        return null;
    }

    /**
     * Đếm số lần đã nộp (attempt) của một sinh viên cho một bài tập.
     *
     * @param assignmentId ID bài tập
     * @param studentId    ID sinh viên
     * @return số lần đã nộp (0 nếu chưa nộp lần nào)
     */
    public int countAttempts(int assignmentId, int studentId) {
        String sql = "SELECT COUNT(*) AS cnt FROM dbo.Submissions "
                   + "WHERE assignment_id = ? AND student_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, assignmentId);
            st.setInt(2, studentId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi countAttempts: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Thêm bài nộp mới vào database.
     *
     * @param s đối tượng Submission cần thêm
     * @return null nếu thành công, hoặc chuỗi lỗi nếu thất bại
     */
    public String insert(Submission s) {
        String sql = "INSERT INTO dbo.Submissions (assignment_id, student_id, sha256_hash, file_path, attempt_number, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, s.getAssignment_id());
            st.setInt(2, s.getStudent_id());
            st.setString(3, s.getSha256_hash());
            st.setString(4, s.getFile_path());
            st.setInt(5, s.getAttempt_number());
            st.setString(6, s.getStatus() != null ? s.getStatus() : Submission.STATUS_PENDING);
            st.executeUpdate();
            return null;
        } catch (SQLException e) {
            System.err.println("Lỗi insert Submission: " + e.getMessage());
            // Mã lỗi 2627/2601: UNIQUE constraint (sha256_hash đã tồn tại)
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                return "File này đã được nộp trước đó (trùng mã SHA-256). Vui lòng kiểm tra lại nội dung file.";
            }
            return e.getMessage();
        }
    }

    /**
     * Cập nhật trạng thái bài nộp.
     *
     * @param submissionId ID bài nộp
     * @param newStatus    trạng thái mới (PENDING / PROCESSING / GRADED / FAILED)
     * @return null nếu thành công, hoặc chuỗi lỗi nếu thất bại
     */
    public String updateStatus(int submissionId, String newStatus) {
        String sql = "UPDATE dbo.Submissions SET status=? WHERE submission_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newStatus);
            st.setInt(2, submissionId);
            int rows = st.executeUpdate();
            return rows > 0 ? null : "Không tìm thấy bài nộp để cập nhật trạng thái.";
        } catch (SQLException e) {
            System.err.println("Lỗi updateStatus Submission: " + e.getMessage());
            return e.getMessage();
        }
    }
}
