package DAO.impl;

import DAO.interfaces.CitizenDocumentVaultDAOInterface;

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

/**
 * JDBC implementation of {@link CitizenDocumentVaultDAOInterface}.
 *
 * @author SarkarSathi
 */
public class CitizenDocumentVaultDAO extends BaseDAO implements CitizenDocumentVaultDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public CitizenDocumentVaultDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     * <p>
     * If no upload timestamp is set on the doc, the current time is used.
     */
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

    /**
     * {@inheritDoc}
     * <p>
     * Sorted newest-upload first.
     */
    public List<CitizenDocumentVault> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM CITIZEN_DOCUMENT_VAULT WHERE CitizenID = ? ORDER BY UploadedAt DESC";
        List<CitizenDocumentVault> documents = new ArrayList<>();
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, citizenId);
            try (ResultSet rs = s.executeQuery()) { while (rs.next()) documents.add(map(rs)); }
        }
        return documents;
    }

    /**
     * {@inheritDoc}
     * <p>
     * Builds the {@code IN (?, ?, ?...)} clause dynamically based on the
     * number of ids passed in. Returns an empty list immediately if the
     * caller passes a null or empty id list — that's not an error, it just
     * means "nothing to fetch."
     */
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

    /**
     * Maps the current row into a {@link CitizenDocumentVault}.
     *
     * @param rs result set positioned on a {@code CITIZEN_DOCUMENT_VAULT} row
     * @return the row as a vault document object
     * @throws SQLException if a column read fails
     */
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
