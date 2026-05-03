package Model;

import java.time.LocalDateTime;

/**
 * An in-app notification delivered to a citizen — usually triggered when one
 * of their applications changes status, but it can also carry general
 * messages.
 * <p>
 * Notifications are delivered through the database only; the platform does
 * not currently send email or SMS. The {@link #title} field is optional —
 * {@link #getTitle()} falls back to a generic label when it's not set.
 *
 * @author SarkarSathi
 */
public class Notification {
    private int notificationId;
    private int citizenId;
    private int applicationId;
    private String message;
    private boolean isRead;
    private LocalDateTime createdAt;
    private String title;

    /**
     * Creates an empty notification.
     */
    public Notification() {
    }

    /**
     * Returns the notification's title, or a generic fallback if no title was
     * set. The fallback keeps the UI from showing an empty heading for older
     * notifications that were created before titles were introduced.
     *
     * @return the title, or {@code "Notification Update"} if none was set
     */
    public String getTitle() {
        if (title != null)
            return title;
        return "Notification Update";
    }

    /** @param title the notification title */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Creates a fully-populated notification.
     *
     * @param notificationId  database primary key
     * @param citizenId       citizen this notification is for
     * @param applicationId   related application id (may be 0 for general
     *                        notifications not tied to an application)
     * @param message         the message body
     * @param isRead          whether the citizen has marked it as read
     * @param createdAt       when the notification was generated
     */
    public Notification(int notificationId, int citizenId, int applicationId,
            String message, boolean isRead, LocalDateTime createdAt) {
        this.notificationId = notificationId;
        this.citizenId = citizenId;
        this.applicationId = applicationId;
        this.message = message;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    /** @return the notification's database id */
    public int getNotificationId() {
        return notificationId;
    }

    /** @param notificationId new database id */
    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    /** @return id of the recipient citizen */
    public int getCitizenId() {
        return citizenId;
    }

    /** @param citizenId id of the recipient citizen */
    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    /** @return id of the related application, or 0 if none */
    public int getApplicationId() {
        return applicationId;
    }

    /** @param applicationId id of the related application */
    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    /** @return the notification message */
    public String getMessage() {
        return message;
    }

    /** @param message the notification message */
    public void setMessage(String message) {
        this.message = message;
    }

    /** @return whether the citizen has marked this notification as read */
    public boolean isRead() {
        return isRead;
    }

    /** @param read read flag */
    public void setRead(boolean read) {
        isRead = read;
    }

    /** @return when this notification was created */
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    /** @param createdAt creation timestamp */
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
