package DAO.impl;

import DAO.interfaces.ServiceTypeDAOInterface;

import Model.ServiceType;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link ServiceTypeDAOInterface}.
 *
 * @author SarkarSathi
 */
public class ServiceTypeDAO implements ServiceTypeDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public ServiceTypeDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     * <p>
     * Always sorted alphabetically by service name so the citizen apply
     * dropdown is predictable.
     */
    public List<ServiceType> findAll(boolean activeOnly) throws SQLException {
        String sql = activeOnly
                ? "SELECT * FROM SERVICE_TYPE WHERE IsActive = TRUE ORDER BY ServiceName"
                : "SELECT * FROM SERVICE_TYPE ORDER BY ServiceName";
        List<ServiceType> serviceTypes = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                serviceTypes.add(map(resultSet));
            }
        }
        return serviceTypes;
    }

    /**
     * Maps the current row into a {@link ServiceType}.
     *
     * @param resultSet result set positioned on a {@code SERVICE_TYPE} row
     * @return the row as a service type object
     * @throws SQLException if a column read fails
     */
    private ServiceType map(ResultSet resultSet) throws SQLException {
        ServiceType serviceType = new ServiceType();
        serviceType.setServiceTypeId(resultSet.getInt("ServiceTypeID"));
        serviceType.setServiceName(resultSet.getString("ServiceName"));
        serviceType.setDescription(resultSet.getString("Description"));
        serviceType.setBaseFee(resultSet.getBigDecimal("BaseFee"));
        serviceType.setActive(resultSet.getBoolean("IsActive"));
        return serviceType;
    }
}
