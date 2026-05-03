package DAO.interfaces;

import Model.Citizen;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Database access contract for {@link Citizen} records.
 * <p>
 * Used by registration, login, profile pages, and admin lookups.
 *
 * @author SarkarSathi
 */
public interface CitizenDAOInterface {
    /**
     * Creates a new citizen account.
     *
     * @param citizen citizen to insert (with password already hashed)
     * @return the saved citizen with its id populated
     * @throws SQLException if the insert fails — typically because of a
     *                      duplicate email
     */
    Citizen create(Citizen citizen) throws SQLException;

    /**
     * Looks up a citizen by database id.
     *
     * @param citizenId the database id
     * @return matching citizen if any
     * @throws SQLException if the query fails
     */
    Optional<Citizen> findById(int citizenId) throws SQLException;

    /**
     * Looks up a citizen by login email — used by the login flow.
     *
     * @param email the email address
     * @return matching citizen if any
     * @throws SQLException if the query fails
     */
    Optional<Citizen> findByEmail(String email) throws SQLException;

    /**
     * @return every registered citizen
     * @throws SQLException if the query fails
     */
    List<Citizen> findAll() throws SQLException;

    /**
     * Updates an existing citizen's profile fields.
     *
     * @param citizen citizen to update — must have a valid id
     * @return the updated citizen
     * @throws SQLException if the update fails
     */
    Citizen update(Citizen citizen) throws SQLException;

    /**
     * Deletes a citizen account.
     *
     * @param citizenId id of the citizen to delete
     * @return {@code true} if a row was deleted
     * @throws SQLException if the delete fails
     */
    boolean deleteById(int citizenId) throws SQLException;
}
