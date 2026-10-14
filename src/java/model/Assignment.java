package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho bảng Assignments trong database AITA_DB.
 * Lưu trữ thông tin bài tập thuộc từng môn học.
 */
public class Assignment {
    private int assignment_id;
    private int course_id;
    private int created_by;
    private String title;
    private String description;
    private Timestamp deadline;
    private Timestamp created_at;

    // Các trường mở rộng để hiển thị (JOIN)
    private String course_code;
    private String course_name;
    private String created_by_name; // full_name của người tạo

    public Assignment() {}

    public Assignment(int course_id, int created_by, String title, String description, Timestamp deadline) {
        this.course_id = course_id;
        this.created_by = created_by;
        this.title = title;
        this.description = description;
        this.deadline = deadline;
    }

    public Assignment(int assignment_id, int course_id, int created_by, String title,
                      String description, Timestamp deadline, Timestamp created_at) {
        this.assignment_id = assignment_id;
        this.course_id = course_id;
        this.created_by = created_by;
        this.title = title;
        this.description = description;
        this.deadline = deadline;
        this.created_at = created_at;
    }

    // ── Getters & Setters ──

    public int getAssignment_id() { return assignment_id; }
    public void setAssignment_id(int assignment_id) { this.assignment_id = assignment_id; }

    public int getCourse_id() { return course_id; }
    public void setCourse_id(int course_id) { this.course_id = course_id; }

    public int getCreated_by() { return created_by; }
    public void setCreated_by(int created_by) { this.created_by = created_by; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getDeadline() { return deadline; }
    public void setDeadline(Timestamp deadline) { this.deadline = deadline; }

    public Timestamp getCreated_at() { return created_at; }
    public void setCreated_at(Timestamp created_at) { this.created_at = created_at; }

    public String getCourse_code() { return course_code; }
    public void setCourse_code(String course_code) { this.course_code = course_code; }

    public String getCourse_name() { return course_name; }
    public void setCourse_name(String course_name) { this.course_name = course_name; }

    public String getCreated_by_name() { return created_by_name; }
    public void setCreated_by_name(String created_by_name) { this.created_by_name = created_by_name; }

    /**
     * Kiểm tra bài tập đã qua hạn nộp chưa
     */
    public boolean isOverdue() {
        return deadline != null && deadline.before(new Timestamp(System.currentTimeMillis()));
    }

    @Override
    public String toString() {
        return String.format("Assignment[id=%d, title=%s, course=%s, deadline=%s]",
                assignment_id, title, course_code, deadline);
    }
}
