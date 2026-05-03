package DAO.interfaces;

import Model.Notification;

import java.sql.SQLException;
import java.util.List;

/**
 * Database access contract for {@link Notification} records.
 *
 * @author SarkarSathi
 */
public interface NotificationDAOInterface {
    /**
     * Stores a new notification for a citizen — typically called when an
     * application status changes.
     *
     * @param notification the notification to save
     * @return the saved notification with its id populated
     * @throws SQLException if the insert fails
     */
    Notification create(Notification notification) throws SQLException;

    /**
     * Returns every notification ever delivered to a citizen, newest first.
     *
     * @param citizenId citizen to look up
     * @return that citizen's notifications, possibly empty
     * @throws SQLException if the query fails
     */
    List<Notification> findByCitizenId(int citizenId) throws SQLException;

    /**
     * @param citizenId citizen to look up
     * @return number of unread notifications — drives the badge in the navbar
     * @throws SQLException if the count query fails
     */
    int countUnreadByCitizenId(int citizenId) throws SQLException;

    /**
     * Marks a single notification as read.
     *
     * @param notificationId id of the notification
     * @return {@code true} if a row was updated
     * @throws SQLException if the update fails
     */
    boolean markAsRead(int notificationId) throws SQLException;

    /**
     * Marks every one of a citizen's notifications as read in a single call.
     *
     * @param citizenId citizen whose notifications to flag
     * @return {@code true} if any rows were updated
     * @throws SQLException if the update fails
     */
    boolean markAllAsRead(int citizenId) throws SQLException;
}
