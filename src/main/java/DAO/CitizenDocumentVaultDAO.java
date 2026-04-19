package DAO;

import Model.CitizenDocumentVault;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CitizenDocumentVaultDAO extends BaseDAO {
    private final Connection connection;

    public CitizenDocumentVaultDAO(Connection connection) {
        this.connection = connection;
    }

    public List<CitizenDocumentVault> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM CITIZEN_DOCUMENT_VAULT WHERE CitizenID = ? ORDER BY UploadedAt DESC";
        List<CitizenDocumentVault> documents = new ArrayList<>();
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

    private CitizenDocumentVault map(ResultSet resultSet) throws SQLException {
        CitizenDocumentVault document = new CitizenDocumentVault();
        document.setVaultDocId(resultSet.getInt("VaultDocID"));
        document.setCitizenId(resultSet.getInt("CitizenID"));
        document.setDocumentType(resultSet.getString("DocumentType"));
        document.setFilePath(resultSet.getString("FilePath"));
        document.setUploadedAt(getLocalDateTime(resultSet, "UploadedAt"));
        return document;
    }
}
