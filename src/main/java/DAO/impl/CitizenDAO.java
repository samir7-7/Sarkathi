package DAO.impl;

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

import DAO.interfaces.CitizenDAOInterface;
import Model.Citizen;

/**
 * JDBC implementation of {@link CitizenDAOInterface}. Used by registration,
 * login, the citizen profile page, and admin lookups of citizen accounts.
 *
 * @author SarkarSathi
 */
public class CitizenDAO extends BaseDAO implements CitizenDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public CitizenDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     * <p>
     * The citizen object is expected to already carry a BCrypt password hash
     * by the time it gets here — see {@code Util.PasswordUtil}.
     */
    @Override
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

    /**
     * {@inheritDoc}
     */
    @Override
    public Optional<Citizen> findById(int citizenId) throws SQLException {
        String sql = "SELECT * FROM CITIZEN WHERE CitizenID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Optional<Citizen> findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM CITIZEN WHERE Email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Sorted newest-registration first.
     */
    @Override
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

    /**
     * {@inheritDoc}
     * <p>
     * The password hash is intentionally <em>not</em> updated here — password
     * changes go through a dedicated flow so we don't accidentally clobber
     * the hash with whatever was in memory.
     */
    @Override
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

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean deleteById(int citizenId) throws SQLException {
        String sql = "DELETE FROM CITIZEN WHERE CitizenID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * Maps the current row into a {@link Citizen}.
     *
     * @param resultSet result set positioned on a {@code CITIZEN} row
     * @return the row as a citizen object
     * @throws SQLException if a column read fails
     */
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
