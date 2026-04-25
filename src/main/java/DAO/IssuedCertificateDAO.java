package DAO;

import Model.IssuedCertificate;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class IssuedCertificateDAO extends BaseDAO {
    private final Connection connection;

    public IssuedCertificateDAO(Connection connection) {
        this.connection = connection;
    }

    public IssuedCertificate create(IssuedCertificate certificate) throws SQLException {
        String sql = """
                INSERT INTO ISSUED_CERTIFICATE (ApplicationID, CertificateNo, IssuedAt, PDFFilePath, IssuedByAdminID)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, certificate.getApplicationId());
            statement.setString(2, certificate.getCertificateNo());
            statement.setTimestamp(3, Timestamp.valueOf(
                    certificate.getIssuedAt() != null ? certificate.getIssuedAt() : LocalDateTime.now()));
            statement.setString(4, certificate.getPdfFilePath());
            statement.setInt(5, certificate.getIssuedByAdminId());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    certificate.setCertificateId(keys.getInt(1));
                }
            }
            return certificate;
        }
    }

    public Optional<IssuedCertificate> findByApplicationId(int applicationId) throws SQLException {
        String sql = "SELECT * FROM ISSUED_CERTIFICATE WHERE ApplicationID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, applicationId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public List<IssuedCertificate> findByCitizenId(int citizenId) throws SQLException {
        String sql = """
                SELECT ic.* FROM ISSUED_CERTIFICATE ic
                JOIN APPLICATION a ON ic.ApplicationID = a.ApplicationID
                WHERE a.CitizenID = ?
                ORDER BY ic.IssuedAt DESC
                """;
        List<IssuedCertificate> certificates = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    certificates.add(map(resultSet));
                }
            }
        }
        return certificates;
    }

    private IssuedCertificate map(ResultSet resultSet) throws SQLException {
        IssuedCertificate certificate = new IssuedCertificate();
        certificate.setCertificateId(resultSet.getInt("CertificateID"));
        certificate.setApplicationId(resultSet.getInt("ApplicationID"));
        certificate.setCertificateNo(resultSet.getString("CertificateNo"));
        certificate.setIssuedAt(getLocalDateTime(resultSet, "IssuedAt"));
        certificate.setPdfFilePath(resultSet.getString("PDFFilePath"));
        certificate.setIssuedByAdminId(resultSet.getInt("IssuedByAdminID"));
        return certificate;
    }
}
