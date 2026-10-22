package model;

import java.sql.Timestamp;

/**
 * Model ánh xạ bảng Tutor_Messages (Tin nhắn hội thoại giữa Sinh viên & AI Tutor).
 */
public class TutorMessage {
    private int messageId;
    private int sessionId;
    private String senderType; // 'STUDENT' hoặc 'LLM_TUTOR'
    private String messageText;
    private Timestamp sentAt;

    public TutorMessage() {
    }

    public TutorMessage(int messageId, int sessionId, String senderType, String messageText, Timestamp sentAt) {
        this.messageId = messageId;
        this.sessionId = sessionId;
        this.senderType = senderType;
        this.messageText = messageText;
        this.sentAt = sentAt;
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public String getSenderType() {
        return senderType;
    }

    public void setSenderType(String senderType) {
        this.senderType = senderType;
    }

    public String getMessageText() {
        return messageText;
    }

    public void setMessageText(String messageText) {
        this.messageText = messageText;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }
}
