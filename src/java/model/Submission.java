package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng Submissions trong database AITA_DB.
 * Lưu trữ thông tin bài nộp của sinh viên cho từng bài tập.
 */
public class Submission {

    // Các trạng thái hợp lệ của bài nộp (đồng bộ với CHK_Submission_Status trong DB)
    public static final String STATUS_PENDING    = "PENDING";
    public static final String STATUS_PROCESSING = "PROCESSING";
    public static final String STATUS_GRADED     = "GRADED";
    public static final String STATUS_FAILED     = "FAILED";

    private int submission_id;
    private int assignment_id;
    private int student_id;
    private String sha256_hash;
    private String file_path;
    private int attempt_number;
    private Timestamp submitted_at;
    private String status;

    // Các trường mở rộng để hiển thị (JOIN)
    private String student_name;      // full_name của sinh viên
    private String student_code;      // mã sinh viên
    private String assignment_title;  // tiêu đề bài tập
    private String course_code;       // mã môn học

    // Điểm số và phản hồi (từ bảng Grades)
    private Double score;
    private String feedback;

    public Submission() {}

    public Submission(int assignment_id, int student_id, String sha256_hash,
                      String file_path, int attempt_number, String status) {
        this.assignment_id = assignment_id;
        this.student_id = student_id;
        this.sha256_hash = sha256_hash;
        this.file_path = file_path;
        this.attempt_number = attempt_number;
        this.status = status;
    }

    public Submission(int submission_id, int assignment_id, int student_id,
                      String sha256_hash, String file_path, int attempt_number,
                      Timestamp submitted_at, String status) {
        this.submission_id = submission_id;
        this.assignment_id = assignment_id;
        this.student_id = student_id;
        this.sha256_hash = sha256_hash;
        this.file_path = file_path;
        this.attempt_number = attempt_number;
        this.submitted_at = submitted_at;
        this.status = status;
    }

    // ── Getters & Setters ──

    public int getSubmission_id() { return submission_id; }
    public void setSubmission_id(int submission_id) { this.submission_id = submission_id; }

    public int getAssignment_id() { return assignment_id; }
    public void setAssignment_id(int assignment_id) { this.assignment_id = assignment_id; }

    public int getStudent_id() { return student_id; }
    public void setStudent_id(int student_id) { this.student_id = student_id; }

    public String getSha256_hash() { return sha256_hash; }
    public void setSha256_hash(String sha256_hash) { this.sha256_hash = sha256_hash; }

    public String getFile_path() { return file_path; }
    public void setFile_path(String file_path) { this.file_path = file_path; }

    public int getAttempt_number() { return attempt_number; }
    public void setAttempt_number(int attempt_number) { this.attempt_number = attempt_number; }

    public Timestamp getSubmitted_at() { return submitted_at; }
    public void setSubmitted_at(Timestamp submitted_at) { this.submitted_at = submitted_at; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getStudent_name() { return student_name; }
    public void setStudent_name(String student_name) { this.student_name = student_name; }

    public String getStudent_code() { return student_code; }
    public void setStudent_code(String student_code) { this.student_code = student_code; }

    public String getAssignment_title() { return assignment_title; }
    public void setAssignment_title(String assignment_title) { this.assignment_title = assignment_title; }

    public String getCourse_code() { return course_code; }
    public void setCourse_code(String course_code) { this.course_code = course_code; }

    public Double getScore() { return score; }
    public void setScore(Double score) { this.score = score; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    /**
     * Lấy nhãn hiển thị thân thiện cho trạng thái bài nộp
     */
    public String getStatusLabel() {
        switch (status != null ? status : "") {
            case STATUS_PENDING:    return "Chờ chấm";
            case STATUS_PROCESSING: return "Đang xử lý";
            case STATUS_GRADED:     return "Đã chấm điểm";
            case STATUS_FAILED:     return "Lỗi nộp bài";
            default:                return status;
        }
    }

    @Override
    public String toString() {
        return String.format("Submission[id=%d, assignment=%d, student=%d, attempt=%d, status=%s]",
                submission_id, assignment_id, student_id, attempt_number, status);
    }
}
