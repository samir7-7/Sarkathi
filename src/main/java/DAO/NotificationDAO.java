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
            bindNotificationFields(statement, notification, 1);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    notification.setNotificationId(keys.getInt(1));
                }
            }
            return notification;
        } catch (SQLException e) {
            if (!isMissingNotificationIdDefault(e)) {
                throw e;
            }
            return createWithExplicitId(notification);
        }
    }

    private Notification createWithExplicitId(Notification notification) throws SQLException {
        String sql = """
                INSERT INTO NOTIFICATION (NotificationID, CitizenID, ApplicationID, Message, IsRead, CreatedAt)
                VALUES (?, ?, ?, ?, ?, ?)
                """;
        int nextId = nextNotificationId();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, nextId);
            bindNotificationFields(statement, notification, 2);
            statement.executeUpdate();
            notification.setNotificationId(nextId);
            return notification;
        }
    }

    private int nextNotificationId() throws SQLException {
        String sql = "SELECT COALESCE(MAX(NotificationID), 0) + 1 FROM NOTIFICATION";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1);
        }
    }

    private void bindNotificationFields(PreparedStatement statement, Notification notification, int startIndex)
            throws SQLException {
        statement.setInt(startIndex, notification.getCitizenId());
        if (notification.getApplicationId() > 0) {
            statement.setInt(startIndex + 1, notification.getApplicationId());
        } else {
            statement.setNull(startIndex + 1, java.sql.Types.INTEGER);
        }
        statement.setString(startIndex + 2, notification.getMessage());
        statement.setBoolean(startIndex + 3, notification.isRead());
        statement.setTimestamp(startIndex + 4, Timestamp.valueOf(
                notification.getCreatedAt() != null ? notification.getCreatedAt() : LocalDateTime.now()));
    }

    private boolean isMissingNotificationIdDefault(SQLException e) {
        return e.getErrorCode() == 1364
                || (e.getMessage() != null
                && e.getMessage().contains("NotificationID")
                && e.getMessage().contains("doesn't have a default value"));
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
