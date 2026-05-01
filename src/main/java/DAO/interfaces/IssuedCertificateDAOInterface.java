package DAO.interfaces;

import Model.IssuedCertificate;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface IssuedCertificateDAOInterface {
    IssuedCertificate create(IssuedCertificate certificate) throws SQLException;

    Optional<IssuedCertificate> findByApplicationId(int applicationId) throws SQLException;

    List<IssuedCertificate> findByCitizenId(int citizenId) throws SQLException;
}
