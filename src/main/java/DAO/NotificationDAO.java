package DAO;

import Model.Notification;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends BaseDAO {
    private final Connection connection;

    public NotificationDAO(Connection connection) {
        this.connection = connection;
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
