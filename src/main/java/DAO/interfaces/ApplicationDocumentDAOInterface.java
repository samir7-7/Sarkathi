package DAO.interfaces;

import Model.ApplicationDocument;

import java.sql.SQLException;
import java.util.List;

public interface ApplicationDocumentDAOInterface {
    ApplicationDocument create(ApplicationDocument document) throws SQLException;

    List<ApplicationDocument> findByApplicationId(int applicationId) throws SQLException;

    List<ApplicationDocument> findByCitizenId(int citizenId) throws SQLException;
}
