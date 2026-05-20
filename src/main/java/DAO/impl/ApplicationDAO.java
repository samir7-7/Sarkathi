package DAO.impl;

import DAO.interfaces.ApplicationDAOInterface;

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

/**
 * JDBC implementation of {@link ApplicationDAOInterface}. The most heavily
 * used DAO in the system — citizen submissions, public tracking, and the
 * admin review screens all read or write through here.
 * <p>
 * Several queries do a {@code LEFT JOIN} on {@code SERVICE_TYPE} so the
 * {@link Application#getServiceTypeName()} field comes back populated and
 * the UI doesn't need a second lookup. The {@link #map(ResultSet)} helper
 * tolerates that join column being absent for queries that don't include it.
 *
 * @author SarkarSathi
 */
public class ApplicationDAO extends BaseDAO implements ApplicationDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public ApplicationDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     * <p>
     * {@code reviewedByAdminId} of 0 (or less) is stored as SQL NULL — that
     * way unreviewed applications show up cleanly when joined against the
     * {@code ADMIN_USER} table.
     */
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

    /**
     * {@inheritDoc}
     * <p>
     * Sorted newest-first by submission time. Note that this overload does
     * <em>not</em> join the service type, so
     * {@link Application#getServiceTypeName()}
     * will be null on the returned objects.
     */
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

    /**
     * {@inheritDoc}
     * <p>
     * Joins the service type name in so the citizen's "My Applications" page
     * can render service names without a second lookup.
     */
    public List<Application> findByCitizenId(int citizenId) throws SQLException {
        String sql = """
                SELECT a.*, st.ServiceName as ServiceTypeName FROM APPLICATION a
                LEFT JOIN SERVICE_TYPE st ON a.ServiceTypeID = st.ServiceTypeID
                WHERE a.CitizenID = ? ORDER BY a.SubmittedAt DESC
                """;
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

    /**
     * {@inheritDoc}
     * <p>
     * Joins in the service type name for the public tracking page.
     */
    public Optional<Application> findByTrackingId(String trackingId) throws SQLException {
        String sql = """
                SELECT a.*, st.ServiceName as ServiceTypeName FROM APPLICATION a
                LEFT JOIN SERVICE_TYPE st ON a.ServiceTypeID = st.ServiceTypeID
                WHERE a.TrackingID = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, trackingId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public Optional<Application> findById(int applicationId) throws SQLException {
        String sql = "SELECT * FROM APPLICATION WHERE ApplicationID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, applicationId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public Optional<Application> findLatestByCitizenAndService(int citizenId, int serviceTypeId) throws SQLException {
        String sql = """
                SELECT a.*, st.ServiceName as ServiceTypeName
                FROM APPLICATION a
                LEFT JOIN SERVICE_TYPE st ON a.ServiceTypeID = st.ServiceTypeID
                WHERE a.CitizenID = ? AND a.ServiceTypeID = ?
                ORDER BY a.SubmittedAt DESC, a.ApplicationID DESC
                LIMIT 1
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            statement.setInt(2, serviceTypeId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Also bumps {@code LastUpdatedAt} to the current database time so the
     * citizen sees an accurate "last activity" stamp.
     */
    public boolean updateStatus(String trackingId, String status, String remarks, int reviewedByAdminId)
            throws SQLException {
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

    /**
     * {@inheritDoc}
     * <p>
     * Also bumps {@code LastUpdatedAt} to the current database time.
     */
    public boolean updateStatusById(int applicationId, String status, String remarks, int reviewedByAdminId)
            throws SQLException {
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

    /**
     * {@inheritDoc}
     */
    public boolean resubmit(Application application) throws SQLException {
        String sql = """
                UPDATE APPLICATION
                SET WardID = ?, Status = ?, SubmittedAt = ?, FormData = ?, LastUpdatedAt = ?, Remarks = ?, ReviewedByAdminID = ?
                WHERE ApplicationID = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, application.getWardId());
            statement.setString(2, application.getStatus());
            statement.setTimestamp(3, Timestamp.valueOf(application.getSubmittedAt()));
            statement.setString(4, application.getFormData());
            statement.setTimestamp(5, Timestamp.valueOf(application.getLastUpdatedAt()));
            statement.setString(6, application.getRemarks());
            if (application.getReviewedByAdminId() > 0) {
                statement.setInt(7, application.getReviewedByAdminId());
            } else {
                statement.setNull(7, java.sql.Types.INTEGER);
            }
            statement.setInt(8, application.getApplicationId());
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * {@inheritDoc}
     */
    public long countAll() throws SQLException {
        return count("SELECT COUNT(*) FROM APPLICATION");
    }

    /**
     * Returns a JSON-formatted string of daily application counts for the last 30
     * days.
     * Includes counts for total, submitted, review, approved, and rejected.
     * 
     * @return JSON string representing the daily statistics
     */
    public String getDailyStatsJson() throws SQLException {
        String sql = """
                    SELECT
                        DATE(SubmittedAt) as date,
                        COUNT(*) as total,
                        SUM(CASE WHEN Status = 'submitted' THEN 1 ELSE 0 END) as submitted,
                        SUM(CASE WHEN Status = 'review' THEN 1 ELSE 0 END) as review,
                        SUM(CASE WHEN Status = 'approved' THEN 1 ELSE 0 END) as approved,
                        SUM(CASE WHEN Status = 'rejected' THEN 1 ELSE 0 END) as rejected
                    FROM APPLICATION
                    WHERE SubmittedAt >= DATE_SUB(CURDATE(), INTERVAL 29 DAY)
                    GROUP BY DATE(SubmittedAt)
                    ORDER BY DATE(SubmittedAt) ASC
                """;

        StringBuilder json = new StringBuilder("[");
        try (PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet rs = statement.executeQuery()) {
            boolean first = true;
            while (rs.next()) {
                if (!first)
                    json.append(",");
                json.append("{")
                        .append("\"date\":\"").append(rs.getString("date")).append("\",")
                        .append("\"total\":").append(rs.getInt("total")).append(",")
                        .append("\"submitted\":").append(rs.getInt("submitted")).append(",")
                        .append("\"review\":").append(rs.getInt("review")).append(",")
                        .append("\"approved\":").append(rs.getInt("approved")).append(",")
                        .append("\"rejected\":").append(rs.getInt("rejected"))
                        .append("}");
                first = false;
            }
        }
        json.append("]");
        return json.toString();
    }

    /**
     * {@inheritDoc}
     */
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

    /**
     * Runs a count query that returns a single number in column 1.
     *
     * @param sql the count SQL — assumed to return one row, one column
     * @return the count value
     * @throws SQLException if the query fails
     */
    private long count(String sql) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getLong(1);
        }
    }

    /**
     * Maps the current row into an {@link Application}. If the result set
     * also includes the joined-in {@code ServiceTypeName} column it's
     * populated; otherwise that field is left null and the
     * {@link SQLException} from the missing column is swallowed.
     *
     * @param resultSet result set positioned on an {@code APPLICATION} row
     * @return the row as an application object
     * @throws SQLException if a required column read fails
     */
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

        try {
            application.setServiceTypeName(resultSet.getString("ServiceTypeName"));
        } catch (SQLException e) {
            // ServiceTypeName not in result set
        }

        return application;
    }
}
