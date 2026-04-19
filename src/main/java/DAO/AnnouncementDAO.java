package DAO;

import Model.Announcement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO extends BaseDAO {
    private final Connection connection;

    public AnnouncementDAO(Connection connection) {
        this.connection = connection;
    }

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
