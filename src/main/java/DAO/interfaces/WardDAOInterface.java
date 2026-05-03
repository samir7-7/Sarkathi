package DAO.interfaces;

import Model.Ward;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Database access contract for {@link Ward} records.
 *
 * @author SarkarSathi
 */
public interface WardDAOInterface {
    /**
     * @return every ward in the system
     * @throws SQLException if the query fails
     */
    List<Ward> findAll() throws SQLException;

    /**
     * Looks up a ward by id.
     *
     * @param wardId the database id
     * @return matching ward if any
     * @throws SQLException if the query fails
     */
    Optional<Ward> findById(int wardId) throws SQLException;
}
