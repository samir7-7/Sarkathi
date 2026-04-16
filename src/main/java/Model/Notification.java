package Model;

import java.time.LocalDateTime;

public class Notification {
    private int notificationId;
    private int citizenId;
    private int applicationId;
    private String message;
    private boolean isRead;
    private LocalDateTime createdAt;

    public Notification() {
    }

    public Notification(int notificationId, int citizenId, int applicationId,
                        String message, boolean isRead, LocalDateTime createdAt) {
        this.notificationId = notificationId;
        this.citizenId = citizenId;
        this.applicationId = applicationId;
        this.message = message;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}