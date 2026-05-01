package DAO.interfaces;

import Model.Application;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface ApplicationDAOInterface {
    Application create(Application application) throws SQLException;

    List<Application> findAll() throws SQLException;

    List<Application> findByCitizenId(int citizenId) throws SQLException;

    Optional<Application> findByTrackingId(String trackingId) throws SQLException;

    Optional<Application> findById(int applicationId) throws SQLException;

    boolean updateStatus(String trackingId, String status, String remarks, int reviewedByAdminId) throws SQLException;

    boolean updateStatusById(int applicationId, String status, String remarks, int reviewedByAdminId) throws SQLException;

    long countAll() throws SQLException;

    long countByStatus(String status) throws SQLException;
}
