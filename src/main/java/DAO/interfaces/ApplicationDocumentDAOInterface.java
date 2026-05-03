package DAO.interfaces;

import Model.ApplicationDocument;

import java.sql.SQLException;
import java.util.List;

/**
 * Database access contract for {@link ApplicationDocument} records — files
 * uploaded as part of a specific application.
 *
 * @author SarkarSathi
 */
public interface ApplicationDocumentDAOInterface {
    /**
     * Stores a document upload record.
     *
     * @param document the document metadata to persist
     * @return the saved document with its id populated
     * @throws SQLException if the insert fails
     */
    ApplicationDocument create(ApplicationDocument document) throws SQLException;

    /**
     * Returns every document attached to a given application.
     *
     * @param applicationId application to look up
     * @return documents attached to that application, possibly empty
     * @throws SQLException if the query fails
     */
    List<ApplicationDocument> findByApplicationId(int applicationId) throws SQLException;

    /**
     * Returns every document the given citizen has ever uploaded across all
     * their applications.
     *
     * @param citizenId citizen to look up
     * @return all documents owned by that citizen
     * @throws SQLException if the query fails
     */
    List<ApplicationDocument> findByCitizenId(int citizenId) throws SQLException;
}
