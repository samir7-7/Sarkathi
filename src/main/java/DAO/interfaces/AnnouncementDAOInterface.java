package DAO.interfaces;

import Model.Announcement;

import java.sql.SQLException;
import java.util.List;

public interface AnnouncementDAOInterface {
    Announcement create(Announcement announcement) throws SQLException;

    boolean update(Announcement announcement) throws SQLException;

    boolean delete(int announcementId) throws SQLException;

    List<Announcement> findAll() throws SQLException;
}
