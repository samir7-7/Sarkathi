package DAO.interfaces;

import Model.AgricultureNotice;

import java.sql.SQLException;
import java.util.List;

/**
 * Database access contract for {@link AgricultureNotice} records.
 * <p>
 * Admins create and manage notices; the public agriculture page reads the
 * full list back via {@link #findAll()}.
 *
 * @author SarkarSathi
 */
public interface AgricultureNoticeDAOInterface {
    /**
     * Inserts a new notice and returns it with the database-generated id
     * filled in.
     *
     * @param notice the notice to create (id is ignored)
     * @return the saved notice with its id populated
     * @throws SQLException if the insert fails
     */
    AgricultureNotice create(AgricultureNotice notice) throws SQLException;

    /**
     * Updates an existing notice in place.
     *
     * @param notice the notice to update — must have a valid id
     * @return {@code true} if a row was updated, {@code false} if none matched
     * @throws SQLException if the update fails
     */
    boolean update(AgricultureNotice notice) throws SQLException;

    /**
     * Deletes the notice with the given id.
     *
     * @param noticeId id of the notice to delete
     * @return {@code true} if a row was deleted, {@code false} if none matched
     * @throws SQLException if the delete fails
     */
    boolean delete(int noticeId) throws SQLException;

    /**
     * Returns every notice, newest first (the actual ordering is up to the
     * implementation).
     *
     * @return all agriculture notices
     * @throws SQLException if the query fails
     */
    List<AgricultureNotice> findAll() throws SQLException;
}
