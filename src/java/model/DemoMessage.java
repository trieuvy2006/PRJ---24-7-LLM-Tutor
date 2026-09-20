package model;

import java.sql.Timestamp;

public class DemoMessage {

    private final int id;
    private final String content;
    private final Timestamp createdAt;

    public DemoMessage(int id, String content, Timestamp createdAt) {
        this.id = id;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public String getContent() {
        return content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
}
