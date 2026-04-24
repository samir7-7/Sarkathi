package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.StringJoiner;

import Model.CitizenDocumentVault;

public class CitizenDocumentVaultDAO extends BaseDAO {
    private final Connection connection;

    public CitizenDocumentVaultDAO(Connection connection) {
        this.connection = connection;
    }

    public CitizenDocumentVault create(CitizenDocumentVault doc) throws SQLException {
        String sql = "INSERT INTO CITIZEN_DOCUMENT_VAULT (CitizenID, DocumentType, FilePath, UploadedAt) VALUES (?, ?, ?, ?)";
        try (PreparedStatement s = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            s.setInt(1, doc.getCitizenId());
            s.setString(2, doc.getDocumentType());
            s.setString(3, doc.getFilePath());
            s.setTimestamp(4, Timestamp.valueOf(doc.getUploadedAt() != null ? doc.getUploadedAt() : LocalDateTime.now()));
            s.executeUpdate();
            try (ResultSet keys = s.getGeneratedKeys()) { if (keys.next()) doc.setVaultDocId(keys.getInt(1)); }
            return doc;
        }
    }

    public List<CitizenDocumentVault> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM CITIZEN_DOCUMENT_VAULT WHERE CitizenID = ? ORDER BY UploadedAt DESC";
        List<CitizenDocumentVault> documents = new ArrayList<>();
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, citizenId);
            try (ResultSet rs = s.executeQuery()) { while (rs.next()) documents.add(map(rs)); }
        }
        return documents;
    }

    public List<CitizenDocumentVault> findByCitizenIdAndIds(int citizenId, List<Integer> vaultDocIds) throws SQLException {
        if (vaultDocIds == null || vaultDocIds.isEmpty()) {
            return List.of();
        }

        StringJoiner placeholders = new StringJoiner(", ");
        for (int i = 0; i < vaultDocIds.size(); i++) {
            placeholders.add("?");
        }

        String sql = "SELECT * FROM CITIZEN_DOCUMENT_VAULT WHERE CitizenID = ? AND VaultDocID IN (" + placeholders + ") ORDER BY UploadedAt DESC";
        List<CitizenDocumentVault> documents = new ArrayList<>();
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, citizenId);
            for (int i = 0; i < vaultDocIds.size(); i++) {
                s.setInt(i + 2, vaultDocIds.get(i));
            }
            try (ResultSet rs = s.executeQuery()) {
                while (rs.next()) {
                    documents.add(map(rs));
                }
            }
        }
        return documents;
    }

    private CitizenDocumentVault map(ResultSet rs) throws SQLException {
        CitizenDocumentVault d = new CitizenDocumentVault();
        d.setVaultDocId(rs.getInt("VaultDocID"));
        d.setCitizenId(rs.getInt("CitizenID"));
        d.setDocumentType(rs.getString("DocumentType"));
        d.setFilePath(rs.getString("FilePath"));
        d.setUploadedAt(getLocalDateTime(rs, "UploadedAt"));
        return d;
    }
}
