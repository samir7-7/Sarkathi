package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import Model.Notification;

public class NotificationDAO extends BaseDAO {
    private final Connection connection;

    public NotificationDAO(Connection connection) {
        this.connection = connection;
    }

    public Notification create(Notification notification) throws SQLException {
        String sql = """
                INSERT INTO NOTIFICATION (CitizenID, ApplicationID, Message, IsRead, CreatedAt)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, notification.getCitizenId());
            if (notification.getApplicationId() > 0) {
                statement.setInt(2, notification.getApplicationId());
            } else {
                statement.setNull(2, java.sql.Types.INTEGER);
            }
            statement.setString(3, notification.getMessage());
            statement.setBoolean(4, notification.isRead());
            statement.setTimestamp(5, Timestamp.valueOf(
                    notification.getCreatedAt() != null ? notification.getCreatedAt() : LocalDateTime.now()));
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    notification.setNotificationId(keys.getInt(1));
                }
            }
            return notification;
        }
    }

    public List<Notification> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM NOTIFICATION WHERE CitizenID = ? ORDER BY CreatedAt DESC";
        List<Notification> notifications = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    notifications.add(map(resultSet));
                }
            }
        }
        return notifications;
    }

    public int countUnreadByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM NOTIFICATION WHERE CitizenID = ? AND IsRead = FALSE";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1);
            }
        }
    }

    public boolean markAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE NOTIFICATION SET IsRead = TRUE WHERE NotificationID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, notificationId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean markAllAsRead(int citizenId) throws SQLException {
        String sql = "UPDATE NOTIFICATION SET IsRead = TRUE WHERE CitizenID = ? AND IsRead = FALSE";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            return statement.executeUpdate() > 0;
        }
    }

    private Notification map(ResultSet resultSet) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationId(resultSet.getInt("NotificationID"));
        notification.setCitizenId(resultSet.getInt("CitizenID"));
        notification.setApplicationId(resultSet.getInt("ApplicationID"));
        notification.setMessage(resultSet.getString("Message"));
        notification.setRead(resultSet.getBoolean("IsRead"));
        notification.setCreatedAt(getLocalDateTime(resultSet, "CreatedAt"));
        return notification;
    }
}
