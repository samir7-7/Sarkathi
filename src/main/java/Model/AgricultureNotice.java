package Model;

import java.time.LocalDateTime;

public class AgricultureNotice {
    private int noticeId;
    private int postedByAdminId;
    private String title;
    private String content;
    private String category;
    private LocalDateTime publishedAt;

    public AgricultureNotice() {
    }

    public AgricultureNotice(int noticeId, int postedByAdminId, String title,
                             String content, String category, LocalDateTime publishedAt) {
        this.noticeId = noticeId;
        this.postedByAdminId = postedByAdminId;
        this.title = title;
        this.content = content;
        this.category = category;
        this.publishedAt = publishedAt;
    }

    public int getNoticeId() {
        return noticeId;
    }

    public void setNoticeId(int noticeId) {
        this.noticeId = noticeId;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public LocalDateTime getPublishedAt() {
        return publishedAt;
    }

    public void setPublishedAt(LocalDateTime publishedAt) {
        this.publishedAt = publishedAt;
    }
}