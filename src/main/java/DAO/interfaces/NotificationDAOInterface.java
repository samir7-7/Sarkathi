package DAO.interfaces;

import Model.Notification;

import java.sql.SQLException;
import java.util.List;

public interface NotificationDAOInterface {
    Notification create(Notification notification) throws SQLException;

    List<Notification> findByCitizenId(int citizenId) throws SQLException;

    int countUnreadByCitizenId(int citizenId) throws SQLException;

    boolean markAsRead(int notificationId) throws SQLException;

    boolean markAllAsRead(int citizenId) throws SQLException;
}
