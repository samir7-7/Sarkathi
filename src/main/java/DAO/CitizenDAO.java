package DAO;

import Model.Citizen;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CitizenDAO extends BaseDAO {
    private final Connection connection;

    public CitizenDAO(Connection connection) {
        this.connection = connection;
    }

    public Citizen create(Citizen citizen) throws SQLException {
        String sql = """
                INSERT INTO CITIZEN (FullName, Email, Phone, PasswordHash, DateOfBirth, Gender, CreatedAt)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, citizen.getFullName());
            statement.setString(2, citizen.getEmail());
            statement.setString(3, citizen.getPhone());
            statement.setString(4, citizen.getPasswordHash());
            statement.setDate(5, citizen.getDateOfBirth() == null ? null : Date.valueOf(citizen.getDateOfBirth()));
            statement.setString(6, citizen.getGender());
            statement.setTimestamp(7, Timestamp.valueOf(citizen.getCreatedAt()));
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    citizen.setCitizenId(keys.getInt(1));
                }
            }
            return citizen;
        }
    }

    public Optional<Citizen> findById(int citizenId) throws SQLException {
        String sql = "SELECT * FROM CITIZEN WHERE CitizenID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public Optional<Citizen> findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM CITIZEN WHERE Email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public List<Citizen> findAll() throws SQLException {
        String sql = "SELECT * FROM CITIZEN ORDER BY CreatedAt DESC";
        List<Citizen> citizens = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                citizens.add(map(resultSet));
            }
        }
        return citizens;
    }

    public Citizen update(Citizen citizen) throws SQLException {
        String sql = """
                UPDATE CITIZEN
                SET FullName = ?, Email = ?, Phone = ?, DateOfBirth = ?, Gender = ?
                WHERE CitizenID = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, citizen.getFullName());
            statement.setString(2, citizen.getEmail());
            statement.setString(3, citizen.getPhone());
            statement.setDate(4, citizen.getDateOfBirth() == null ? null : Date.valueOf(citizen.getDateOfBirth()));
            statement.setString(5, citizen.getGender());
            statement.setInt(6, citizen.getCitizenId());
            statement.executeUpdate();
        }
        return citizen;
    }

    public boolean deleteById(int citizenId) throws SQLException {
        String sql = "DELETE FROM CITIZEN WHERE CitizenID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            return statement.executeUpdate() > 0;
        }
    }

    private Citizen map(ResultSet resultSet) throws SQLException {
        Citizen citizen = new Citizen();
        citizen.setCitizenId(resultSet.getInt("CitizenID"));
        citizen.setFullName(resultSet.getString("FullName"));
        citizen.setEmail(resultSet.getString("Email"));
        citizen.setPhone(resultSet.getString("Phone"));
        citizen.setPasswordHash(resultSet.getString("PasswordHash"));
        citizen.setDateOfBirth(getLocalDate(resultSet, "DateOfBirth"));
        citizen.setGender(resultSet.getString("Gender"));
        citizen.setCreatedAt(getLocalDateTime(resultSet, "CreatedAt"));
        return citizen;
    }
}
