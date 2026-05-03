package DAO.interfaces;

import Model.IssuedCertificate;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Database access contract for {@link IssuedCertificate} records.
 *
 * @author SarkarSathi
 */
public interface IssuedCertificateDAOInterface {
    /**
     * Records a newly-issued certificate.
     *
     * @param certificate certificate to save
     * @return the saved certificate with its id populated
     * @throws SQLException if the insert fails (e.g. duplicate certificate
     *                      number, or a certificate already exists for that
     *                      application)
     */
    IssuedCertificate create(IssuedCertificate certificate) throws SQLException;

    /**
     * Finds the certificate issued for a particular application, if any.
     *
     * @param applicationId application to look up
     * @return the certificate for that application, if one was issued
     * @throws SQLException if the query fails
     */
    Optional<IssuedCertificate> findByApplicationId(int applicationId) throws SQLException;

    /**
     * Returns every certificate ever issued to a given citizen, across all
     * their applications.
     *
     * @param citizenId citizen to look up
     * @return that citizen's certificates, possibly empty
     * @throws SQLException if the query fails
     */
    List<IssuedCertificate> findByCitizenId(int citizenId) throws SQLException;
}
