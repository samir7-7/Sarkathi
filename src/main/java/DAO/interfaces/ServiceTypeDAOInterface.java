package DAO.interfaces;

import Model.ServiceType;

import java.sql.SQLException;
import java.util.List;

public interface ServiceTypeDAOInterface {
    List<ServiceType> findAll(boolean activeOnly) throws SQLException;
}
