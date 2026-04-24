package DAO;

import Model.Application;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ApplicationDAO extends BaseDAO {
    private final Connection connection;

    public ApplicationDAO(Connection connection) {
        this.connection = connection;
    }

    public Application create(Application application) throws SQLException {
        String sql = """
                INSERT INTO APPLICATION (TrackingID, CitizenID, ServiceTypeID, WardID, Status, SubmittedAt, FormData, LastUpdatedAt, Remarks, ReviewedByAdminID)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, application.getTrackingId());
            statement.setInt(2, application.getCitizenId());
            statement.setInt(3, application.getServiceTypeId());
            statement.setInt(4, application.getWardId());
            statement.setString(5, application.getStatus());
            statement.setTimestamp(6, Timestamp.valueOf(application.getSubmittedAt()));
            statement.setString(7, application.getFormData());
            statement.setTimestamp(8, Timestamp.valueOf(application.getLastUpdatedAt()));
            statement.setString(9, application.getRemarks());
            if (application.getReviewedByAdminId() > 0) {
                statement.setInt(10, application.getReviewedByAdminId());
            } else {
                statement.setNull(10, java.sql.Types.INTEGER);
            }
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    application.setApplicationId(keys.getInt(1));
                }
            }
            return application;
        }
    }

    public List<Application> findAll() throws SQLException {
        String sql = "SELECT * FROM APPLICATION ORDER BY SubmittedAt DESC";
        List<Application> applications = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                applications.add(map(resultSet));
            }
        }
        return applications;
    }

    public List<Application> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM APPLICATION WHERE CitizenID = ? ORDER BY SubmittedAt DESC";
        List<Application> applications = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    applications.add(map(resultSet));
                }
            }
        }
        return applications;
    }

    public Optional<Application> findByTrackingId(String trackingId) throws SQLException {
        String sql = "SELECT * FROM APPLICATION WHERE TrackingID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, trackingId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public Optional<Application> findById(int applicationId) throws SQLException {
        String sql = "SELECT * FROM APPLICATION WHERE ApplicationID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, applicationId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public boolean updateStatus(String trackingId, String status, String remarks, int reviewedByAdminId) throws SQLException {
        String sql = """
                UPDATE APPLICATION
                SET Status = ?, Remarks = ?, ReviewedByAdminID = ?, LastUpdatedAt = CURRENT_TIMESTAMP
                WHERE TrackingID = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setString(2, remarks);
            statement.setInt(3, reviewedByAdminId);
            statement.setString(4, trackingId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean updateStatusById(int applicationId, String status, String remarks, int reviewedByAdminId) throws SQLException {
        String sql = """
                UPDATE APPLICATION
                SET Status = ?, Remarks = ?, ReviewedByAdminID = ?, LastUpdatedAt = CURRENT_TIMESTAMP
                WHERE ApplicationID = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setString(2, remarks);
            statement.setInt(3, reviewedByAdminId);
            statement.setInt(4, applicationId);
            return statement.executeUpdate() > 0;
        }
    }

    public long countAll() throws SQLException {
        return count("SELECT COUNT(*) FROM APPLICATION");
    }

    public long countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM APPLICATION WHERE Status = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getLong(1);
            }
        }
    }

    private long count(String sql) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getLong(1);
        }
    }

    private Application map(ResultSet resultSet) throws SQLException {
        Application application = new Application();
        application.setApplicationId(resultSet.getInt("ApplicationID"));
        application.setTrackingId(resultSet.getString("TrackingID"));
        application.setCitizenId(resultSet.getInt("CitizenID"));
        application.setServiceTypeId(resultSet.getInt("ServiceTypeID"));
        application.setWardId(resultSet.getInt("WardID"));
        application.setStatus(resultSet.getString("Status"));
        application.setSubmittedAt(getLocalDateTime(resultSet, "SubmittedAt"));
        application.setFormData(resultSet.getString("FormData"));
        application.setLastUpdatedAt(getLocalDateTime(resultSet, "LastUpdatedAt"));
        application.setRemarks(resultSet.getString("Remarks"));
        application.setReviewedByAdminId(resultSet.getInt("ReviewedByAdminID"));
        return application;
    }
}