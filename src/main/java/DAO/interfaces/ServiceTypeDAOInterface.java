package DAO.interfaces;

import Model.ServiceType;

import java.sql.SQLException;
import java.util.List;

/**
 * Database access contract for {@link ServiceType} records — the catalogue
 * of services citizens can apply for.
 *
 * @author SarkarSathi
 */
public interface ServiceTypeDAOInterface {
    /**
     * Returns every service type, optionally filtered to only the ones still
     * accepting new applications.
     *
     * @param activeOnly if {@code true}, return only services with
     *                   {@code isActive = true}; if {@code false}, return all
     * @return matching service types
     * @throws SQLException if the query fails
     */
    List<ServiceType> findAll(boolean activeOnly) throws SQLException;
}
