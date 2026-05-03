package DAO.interfaces;

import Model.Application;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Database access contract for {@link Application} records.
 * <p>
 * Applications are the heart of SarkarSathi, so this DAO has a bit more
 * surface area than the others: lookups by tracking id, by citizen, status
 * updates from two different angles (admin reviewing vs. public tracking),
 * and counts for the admin dashboard.
 *
 * @author SarkarSathi
 */
public interface ApplicationDAOInterface {
    /**
     * Inserts a new application and returns it with the database-generated
     * id and tracking id populated.
     *
     * @param application application to insert
     * @return the saved application
     * @throws SQLException if the insert fails
     */
    Application create(Application application) throws SQLException;

    /**
     * Returns every application in the system, joined with service type names
     * for display.
     *
     * @return all applications
     * @throws SQLException if the query fails
     */
    List<Application> findAll() throws SQLException;

    /**
     * Returns every application a given citizen has submitted.
     *
     * @param citizenId id of the citizen
     * @return that citizen's applications, possibly empty
     * @throws SQLException if the query fails
     */
    List<Application> findByCitizenId(int citizenId) throws SQLException;

    /**
     * Looks up an application by its public tracking id.
     *
     * @param trackingId the public UUID
     * @return the matching application if any
     * @throws SQLException if the query fails
     */
    Optional<Application> findByTrackingId(String trackingId) throws SQLException;

    /**
     * Looks up an application by its database id.
     *
     * @param applicationId the database id
     * @return the matching application if any
     * @throws SQLException if the query fails
     */
    Optional<Application> findById(int applicationId) throws SQLException;

    /**
     * Updates an application's status by tracking id. Used by the public
     * tracking flow.
     *
     * @param trackingId        the application's tracking id
     * @param status            new status
     * @param remarks           admin remarks to attach
     * @param reviewedByAdminId id of the admin making the change
     * @return {@code true} if a row was updated
     * @throws SQLException if the update fails
     */
    boolean updateStatus(String trackingId, String status, String remarks, int reviewedByAdminId) throws SQLException;

    /**
     * Updates an application's status by database id. Used by the admin
     * review screens.
     *
     * @param applicationId     the application's database id
     * @param status            new status
     * @param remarks           admin remarks to attach
     * @param reviewedByAdminId id of the admin making the change
     * @return {@code true} if a row was updated
     * @throws SQLException if the update fails
     */
    boolean updateStatusById(int applicationId, String status, String remarks, int reviewedByAdminId) throws SQLException;

    /**
     * @return total number of applications in the system
     * @throws SQLException if the count query fails
     */
    long countAll() throws SQLException;

    /**
     * @param status status to filter by
     * @return number of applications currently in the given status
     * @throws SQLException if the count query fails
     */
    long countByStatus(String status) throws SQLException;
}
