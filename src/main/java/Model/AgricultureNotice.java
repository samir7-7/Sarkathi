package Model;

import java.time.LocalDateTime;

/**
 * A notice posted by an admin about something happening in the agriculture
 * space — a new subsidy, an upcoming training, a government scheme, etc.
 * <p>
 * Citizens see these on the public agriculture page; admins create them from
 * the admin notices page. The {@link #category} field is what the UI uses to
 * group or filter notices (typical values: {@code subsidy}, {@code training},
 * {@code scheme}).
 *
 * @author SarkarSathi
 */
public class AgricultureNotice {
    private int noticeId;
    private int postedByAdminId;
    private String title;
    private String content;
    private String category;
    private LocalDateTime publishedAt;

    /**
     * Creates an empty notice — handy for ResultSet mapping.
     */
    public AgricultureNotice() {
    }

    /**
     * Creates a fully-populated notice.
     *
     * @param noticeId         database primary key
     * @param postedByAdminId  id of the admin who posted it
     * @param title            short headline shown in lists
     * @param content          full body text
     * @param category         category string used for filtering
     * @param publishedAt      timestamp the notice was published
     */
    public AgricultureNotice(int noticeId, int postedByAdminId, String title,
                             String content, String category, LocalDateTime publishedAt) {
        this.noticeId = noticeId;
        this.postedByAdminId = postedByAdminId;
        this.title = title;
        this.content = content;
        this.category = category;
        this.publishedAt = publishedAt;
    }

    /** @return the notice's database id */
    public int getNoticeId() {
        return noticeId;
    }

    /** @param noticeId new database id */
    public void setNoticeId(int noticeId) {
        this.noticeId = noticeId;
    }

    /** @return id of the admin who posted this notice */
    public int getPostedByAdminId() {
        return postedByAdminId;
    }

    /** @param postedByAdminId id of the posting admin */
    public void setPostedByAdminId(int postedByAdminId) {
        this.postedByAdminId = postedByAdminId;
    }

    /** @return the notice's headline */
    public String getTitle() {
        return title;
    }

    /** @param title the notice's headline */
    public void setTitle(String title) {
        this.title = title;
    }

    /** @return the full body text of the notice */
    public String getContent() {
        return content;
    }

    /** @param content full body text */
    public void setContent(String content) {
        this.content = content;
    }

    /** @return the category string (subsidy, training, scheme, ...) */
    public String getCategory() {
        return category;
    }

    /** @param category the category string */
    public void setCategory(String category) {
        this.category = category;
    }

    /** @return the timestamp this notice was published */
    public LocalDateTime getPublishedAt() {
        return publishedAt;
    }

    /** @param publishedAt the publish timestamp */
    public void setPublishedAt(LocalDateTime publishedAt) {
        this.publishedAt = publishedAt;
    }
}
