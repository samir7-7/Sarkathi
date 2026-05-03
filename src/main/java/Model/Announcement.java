package Model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * A general municipal announcement posted by an admin — town hall meetings,
 * holidays, public works updates, anything the public should know about.
 * <p>
 * Unlike {@link AgricultureNotice}, an Announcement carries an optional
 * {@link #eventDate} for things that happen on a specific day, separate from
 * {@link #publishedAt} (when the post itself went live).
 *
 * @author SarkarSathi
 */
public class Announcement {
    private int announcementId;
    private int postedByAdminId;
    private String title;
    private String content;
    private LocalDate eventDate;
    private LocalDateTime publishedAt;

    /**
     * Creates an empty announcement — used by DAO mappers.
     */
    public Announcement() {
    }

    /**
     * Creates a fully-populated announcement.
     *
     * @param announcementId   database primary key
     * @param postedByAdminId  admin who posted it
     * @param title            announcement headline
     * @param content          full body text
     * @param eventDate        date of the event being announced (may be null
     *                         for general announcements)
     * @param publishedAt      timestamp the announcement was made public
     */
    public Announcement(int announcementId, int postedByAdminId, String title, String content,
                        LocalDate eventDate, LocalDateTime publishedAt) {
        this.announcementId = announcementId;
        this.postedByAdminId = postedByAdminId;
        this.title = title;
        this.content = content;
        this.eventDate = eventDate;
        this.publishedAt = publishedAt;
    }

    /** @return the announcement's database id */
    public int getAnnouncementId() {
        return announcementId;
    }

    /** @param announcementId new database id */
    public void setAnnouncementId(int announcementId) {
        this.announcementId = announcementId;
    }

    /** @return id of the admin who posted this */
    public int getPostedByAdminId() {
        return postedByAdminId;
    }

    /** @param postedByAdminId id of the posting admin */
    public void setPostedByAdminId(int postedByAdminId) {
        this.postedByAdminId = postedByAdminId;
    }

    /** @return announcement headline */
    public String getTitle() {
        return title;
    }

    /** @param title the announcement headline */
    public void setTitle(String title) {
        this.title = title;
    }

    /** @return the full body text */
    public String getContent() {
        return content;
    }

    /** @param content full body text */
    public void setContent(String content) {
        this.content = content;
    }

    /** @return date of the event being announced, or {@code null} if none */
    public LocalDate getEventDate() {
        return eventDate;
    }

    /** @param eventDate date of the event, or {@code null} for general posts */
    public void setEventDate(LocalDate eventDate) {
        this.eventDate = eventDate;
    }

    /** @return when the announcement was published */
    public LocalDateTime getPublishedAt() {
        return publishedAt;
    }

    /** @param publishedAt the publish timestamp */
    public void setPublishedAt(LocalDateTime publishedAt) {
        this.publishedAt = publishedAt;
    }
}
