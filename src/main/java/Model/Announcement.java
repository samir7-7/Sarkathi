package Model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Announcement {
    private int announcementId;
    private int postedByAdminId;
    private String title;
    private String content;
    private LocalDate eventDate;
    private LocalDateTime publishedAt;

    public Announcement() {
    }

    public Announcement(int announcementId, int postedByAdminId, String title, String content,
                        LocalDate eventDate, LocalDateTime publishedAt) {
        this.announcementId = announcementId;
        this.postedByAdminId = postedByAdminId;
        this.title = title;
        this.content = content;
        this.eventDate = eventDate;
        this.publishedAt = publishedAt;
    }

    public int getAnnouncementId() {
        return announcementId;
    }

    public void setAnnouncementId(int announcementId) {
        this.announcementId = announcementId;
    }

    public int getPostedByAdminId() {
        return postedByAdminId;
    }

    public void setPostedByAdminId(int postedByAdminId) {
        this.postedByAdminId = postedByAdminId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDate getEventDate() {
        return eventDate;
    }

    public void setEventDate(LocalDate eventDate) {
        this.eventDate = eventDate;
    }

    public LocalDateTime getPublishedAt() {
        return publishedAt;
    }

    public void setPublishedAt(LocalDateTime publishedAt) {
        this.publishedAt = publishedAt;
    }
}