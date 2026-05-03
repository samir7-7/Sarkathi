package DAO.impl;

import DAO.interfaces.NotificationDAOInterface;

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

/**
 * JDBC implementation of {@link NotificationDAOInterface}.
 * <p>
 * There's a small wrinkle here: some older databases were created without a
 * default value (or AUTO_INCREMENT) on {@code NotificationID}. To keep the
 * app working against those, {@link #create(Notification)} catches the
 * resulting "doesn't have a default value" failure and retries the insert
 * with an explicit id computed from {@code MAX(NotificationID) + 1}.
 *
 * @author SarkarSathi
 */
public class NotificationDAO extends BaseDAO implements NotificationDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public NotificationDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     * <p>
     * Tries the normal insert (auto-generated key) first. If the database
     * complains that {@code NotificationID} doesn't have a default value,
     * falls back to {@link #createWithExplicitId(Notification)}. Any other
     * SQL error is rethrown unchanged.
     */
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

    /**
     * Fallback insert path used when the schema has no default for
     * {@code NotificationID}. Computes the next id with
     * {@link #nextNotificationId()} and writes it into the row explicitly.
     *
     * @param notification the notification to save
     * @return the saved notification with its id populated
     * @throws SQLException if the insert fails
     */
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

    /**
     * Computes the next available notification id by reading
     * {@code MAX(NotificationID) + 1}. Not race-safe under heavy concurrent
     * inserts — but that's acceptable for the legacy-schema fallback path
     * since modern schemas use AUTO_INCREMENT.
     *
     * @return the next id to use
     * @throws SQLException if the query fails
     */
    private int nextNotificationId() throws SQLException {
        String sql = "SELECT COALESCE(MAX(NotificationID), 0) + 1 FROM NOTIFICATION";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1);
        }
    }

    /**
     * Binds the shared notification fields onto a prepared statement starting
     * at the given parameter index. Lets {@link #create(Notification)} and
     * {@link #createWithExplicitId(Notification)} share the parameter-binding
     * logic without duplicating it.
     *
     * @param statement     the statement to bind onto
     * @param notification  source values
     * @param startIndex    1-based parameter index of the first notification field
     * @throws SQLException if any {@code setXxx} call fails
     */
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

    /**
     * Recognises the specific MySQL error that fires when {@code NotificationID}
     * has no default value — either by error code (1364) or by sniffing the
     * message text. Used to decide whether the fallback path should run.
     *
     * @param e the SQL exception to inspect
     * @return {@code true} if this looks like the "no default" error
     */
    private boolean isMissingNotificationIdDefault(SQLException e) {
        return e.getErrorCode() == 1364
                || (e.getMessage() != null
                && e.getMessage().contains("NotificationID")
                && e.getMessage().contains("doesn't have a default value"));
    }

    /**
     * {@inheritDoc}
     * <p>
     * Sorted newest-first.
     */
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

    /**
     * {@inheritDoc}
     */
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

    /**
     * {@inheritDoc}
     */
    public boolean markAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE NOTIFICATION SET IsRead = TRUE WHERE NotificationID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, notificationId);
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Only flips notifications that are currently unread, so the call
     * returns {@code false} cleanly when there's nothing to mark.
     */
    public boolean markAllAsRead(int citizenId) throws SQLException {
        String sql = "UPDATE NOTIFICATION SET IsRead = TRUE WHERE CitizenID = ? AND IsRead = FALSE";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * Maps the current row into a {@link Notification}.
     *
     * @param resultSet result set positioned on a {@code NOTIFICATION} row
     * @return the row as a notification object
     * @throws SQLException if a column read fails
     */
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
