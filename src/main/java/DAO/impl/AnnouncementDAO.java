package DAO.impl;

import DAO.interfaces.AnnouncementDAOInterface;

import Model.Announcement;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link AnnouncementDAOInterface}. Mostly a mirror
 * of {@link AgricultureNoticeDAO} with an extra {@code EventDate} column.
 *
 * @author SarkarSathi
 */
public class AnnouncementDAO extends BaseDAO implements AnnouncementDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public AnnouncementDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     * <p>
     * If no publish timestamp is set on the announcement, the current time
     * is substituted in.
     */
    public Announcement create(Announcement announcement) throws SQLException {
        String sql = """
                INSERT INTO ANNOUNCEMENT (PostedByAdminID, Title, Content, EventDate, PublishedAt)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, announcement.getPostedByAdminId());
            statement.setString(2, announcement.getTitle());
            statement.setString(3, announcement.getContent());
            statement.setDate(4, announcement.getEventDate() != null ? Date.valueOf(announcement.getEventDate()) : null);
            statement.setTimestamp(5, Timestamp.valueOf(
                    announcement.getPublishedAt() != null ? announcement.getPublishedAt() : LocalDateTime.now()));
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    announcement.setAnnouncementId(keys.getInt(1));
                }
            }
            return announcement;
        }
    }

    /**
     * {@inheritDoc}
     */
    public boolean update(Announcement announcement) throws SQLException {
        String sql = "UPDATE ANNOUNCEMENT SET Title = ?, Content = ?, EventDate = ? WHERE AnnouncementID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, announcement.getTitle());
            statement.setString(2, announcement.getContent());
            statement.setDate(3, announcement.getEventDate() != null ? Date.valueOf(announcement.getEventDate()) : null);
            statement.setInt(4, announcement.getAnnouncementId());
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * {@inheritDoc}
     */
    public boolean delete(int announcementId) throws SQLException {
        String sql = "DELETE FROM ANNOUNCEMENT WHERE AnnouncementID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, announcementId);
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Sorted newest-first by publish time.
     */
    public List<Announcement> findAll() throws SQLException {
        String sql = "SELECT * FROM ANNOUNCEMENT ORDER BY PublishedAt DESC";
        List<Announcement> announcements = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                announcements.add(map(resultSet));
            }
        }
        return announcements;
    }

    /**
     * Maps the current row into an {@link Announcement}.
     *
     * @param resultSet result set positioned on an {@code ANNOUNCEMENT} row
     * @return the row as an announcement object
     * @throws SQLException if a column read fails
     */
    private Announcement map(ResultSet resultSet) throws SQLException {
        Announcement announcement = new Announcement();
        announcement.setAnnouncementId(resultSet.getInt("AnnouncementID"));
        announcement.setPostedByAdminId(resultSet.getInt("PostedByAdminID"));
        announcement.setTitle(resultSet.getString("Title"));
        announcement.setContent(resultSet.getString("Content"));
        announcement.setEventDate(getLocalDate(resultSet, "EventDate"));
        announcement.setPublishedAt(getLocalDateTime(resultSet, "PublishedAt"));
        return announcement;
    }
}
