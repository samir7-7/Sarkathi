package DAO;

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

public class ApplicationDocumentDAO extends BaseDAO {
    private final Connection connection;

    public ApplicationDocumentDAO(Connection connection) {
        this.connection = connection;
    }

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
