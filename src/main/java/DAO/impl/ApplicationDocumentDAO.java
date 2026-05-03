package DAO.impl;

import DAO.interfaces.ApplicationDocumentDAOInterface;

import Model.ApplicationDocument;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link ApplicationDocumentDAOInterface}.
 *
 * @author SarkarSathi
 */
public class ApplicationDocumentDAO extends BaseDAO implements ApplicationDocumentDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public ApplicationDocumentDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     * <p>
     * If no upload timestamp is set on the document, the current time is
     * substituted in.
     */
    public ApplicationDocument create(ApplicationDocument document) throws SQLException {
        String sql = """
                INSERT INTO APPLICATION_DOCUMENT (ApplicationID, DocumentType, FilePath, UploadedAt, IsReusable)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, document.getApplicationId());
            statement.setString(2, document.getDocumentType());
            statement.setString(3, document.getFilePath());
            statement.setTimestamp(4, Timestamp.valueOf(
                    document.getUploadedAt() != null ? document.getUploadedAt() : LocalDateTime.now()));
            statement.setBoolean(5, document.isReusable());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    document.setDocId(keys.getInt(1));
                }
            }
            return document;
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Sorted newest-upload first.
     */
    public List<ApplicationDocument> findByApplicationId(int applicationId) throws SQLException {
        String sql = "SELECT * FROM APPLICATION_DOCUMENT WHERE ApplicationID = ? ORDER BY UploadedAt DESC";
        List<ApplicationDocument> documents = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, applicationId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    documents.add(map(resultSet));
                }
            }
        }
        return documents;
    }

    /**
     * {@inheritDoc}
     * <p>
     * Joins through {@code APPLICATION} so we can filter by the owning
     * citizen rather than by application id.
     */
    public List<ApplicationDocument> findByCitizenId(int citizenId) throws SQLException {
        String sql = """
                SELECT ad.* FROM APPLICATION_DOCUMENT ad
                JOIN APPLICATION a ON ad.ApplicationID = a.ApplicationID
                WHERE a.CitizenID = ?
                ORDER BY ad.UploadedAt DESC
                """;
        List<ApplicationDocument> documents = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    documents.add(map(resultSet));
                }
            }
        }
        return documents;
    }

    /**
     * Maps the current row into an {@link ApplicationDocument}.
     *
     * @param resultSet result set positioned on an {@code APPLICATION_DOCUMENT} row
     * @return the row as a document object
     * @throws SQLException if a column read fails
     */
    private ApplicationDocument map(ResultSet resultSet) throws SQLException {
        ApplicationDocument document = new ApplicationDocument();
        document.setDocId(resultSet.getInt("DocID"));
        document.setApplicationId(resultSet.getInt("ApplicationID"));
        document.setDocumentType(resultSet.getString("DocumentType"));
        document.setFilePath(resultSet.getString("FilePath"));
        document.setUploadedAt(getLocalDateTime(resultSet, "UploadedAt"));
        document.setReusable(resultSet.getBoolean("IsReusable"));
        return document;
    }
}
