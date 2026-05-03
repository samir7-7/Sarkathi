package DAO.interfaces;

import Model.Announcement;

import java.sql.SQLException;
import java.util.List;

/**
 * Database access contract for {@link Announcement} records.
 *
 * @author SarkarSathi
 */
public interface AnnouncementDAOInterface {
    /**
     * Inserts a new announcement and returns it with its database-generated
     * id filled in.
     *
     * @param announcement the announcement to insert
     * @return the saved announcement with its id populated
     * @throws SQLException if the insert fails
     */
    Announcement create(Announcement announcement) throws SQLException;

    /**
     * Updates an existing announcement.
     *
     * @param announcement announcement to update — must have a valid id
     * @return {@code true} if a row was updated
     * @throws SQLException if the update fails
     */
    boolean update(Announcement announcement) throws SQLException;

    /**
     * Deletes an announcement.
     *
     * @param announcementId id of the announcement to delete
     * @return {@code true} if a row was deleted
     * @throws SQLException if the delete fails
     */
    boolean delete(int announcementId) throws SQLException;

    /**
     * Returns every announcement.
     *
     * @return all announcements
     * @throws SQLException if the query fails
     */
    List<Announcement> findAll() throws SQLException;
}
