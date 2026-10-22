package model;

import java.sql.Timestamp;

/**
 * Model ánh xạ bảng Personalized_Learning_Paths (Lộ trình học tập cá nhân hóa).
 */
public class PersonalizedLearningPath {
    private int pathId;
    private int studentId;
    private String weaknessTopic;
    private String recommendedAction;
    private String status; // 'IN_PROGRESS', 'COMPLETED', 'SKIPPED'
    private Timestamp createdAt;

    // Phụ trợ hiển thị tên sinh viên
    private String studentName;
    private String studentCode;

    public PersonalizedLearningPath() {
    }

    public PersonalizedLearningPath(int pathId, int studentId, String weaknessTopic, String recommendedAction, String status, Timestamp createdAt) {
        this.pathId = pathId;
        this.studentId = studentId;
        this.weaknessTopic = weaknessTopic;
        this.recommendedAction = recommendedAction;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getPathId() {
        return pathId;
    }

    public void setPathId(int pathId) {
        this.pathId = pathId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getWeaknessTopic() {
        return weaknessTopic;
    }

    public void setWeaknessTopic(String weaknessTopic) {
        this.weaknessTopic = weaknessTopic;
    }

    public String getRecommendedAction() {
        return recommendedAction;
    }

    public void setRecommendedAction(String recommendedAction) {
        this.recommendedAction = recommendedAction;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }
}
