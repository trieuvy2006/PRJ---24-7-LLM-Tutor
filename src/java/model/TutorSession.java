package model;

import java.sql.Timestamp;

/**
 * Model ánh xạ bảng Tutor_Sessions (Phiên tư vấn của AI Tutor).
 */
public class TutorSession {
    private int sessionId;
    private int studentId;
    private Integer submissionId; // có thể null
    private String errorType;
    private String rawErrorMessage;
    private Timestamp startedAt;
    private String displayTitle;
    private Timestamp lastActivityAt;

    public TutorSession() {
    }

    public TutorSession(int sessionId, int studentId, Integer submissionId, String errorType, String rawErrorMessage, Timestamp startedAt) {
        this.sessionId = sessionId;
        this.studentId = studentId;
        this.submissionId = submissionId;
        this.errorType = errorType;
        this.rawErrorMessage = rawErrorMessage;
        this.startedAt = startedAt;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public Integer getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(Integer submissionId) {
        this.submissionId = submissionId;
    }

    public String getErrorType() {
        return errorType;
    }

    public void setErrorType(String errorType) {
        this.errorType = errorType;
    }

    public String getRawErrorMessage() {
        return rawErrorMessage;
    }

    public void setRawErrorMessage(String rawErrorMessage) {
        this.rawErrorMessage = rawErrorMessage;
    }

    public Timestamp getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Timestamp startedAt) {
        this.startedAt = startedAt;
    }

    public String getDisplayTitle() {
        return displayTitle;
    }

    public void setDisplayTitle(String displayTitle) {
        this.displayTitle = displayTitle;
    }

    public Timestamp getLastActivityAt() {
        return lastActivityAt;
    }

    public void setLastActivityAt(Timestamp lastActivityAt) {
        this.lastActivityAt = lastActivityAt;
    }
}
