package DAO.impl;

import DAO.interfaces.AdminUserDAOInterface;

import Model.AdminUser;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

/**
 * JDBC implementation of {@link AdminUserDAOInterface}. The lookup is
 * intentionally case-insensitive and trims whitespace on both sides — admin
 * emails get hand-typed often enough that this avoids "I can't log in"
 * tickets caused by an accidental space or capital letter.
 *
 * @author SarkarSathi
 */
public class AdminUserDAO implements AdminUserDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public AdminUserDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     */
    public Optional<AdminUser> findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM ADMIN_USER WHERE LOWER(TRIM(Email)) = LOWER(TRIM(?))";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    /**
     * Maps the current row of a result set into an {@link AdminUser}.
     *
     * @param resultSet a result set positioned on a row from {@code ADMIN_USER}
     * @return the row as an {@code AdminUser}
     * @throws SQLException if any column read fails
     */
    private AdminUser map(ResultSet resultSet) throws SQLException {
        AdminUser adminUser = new AdminUser();
        adminUser.setAdminId(resultSet.getInt("AdminID"));
        adminUser.setWardId(resultSet.getInt("WardID"));
        adminUser.setFullName(resultSet.getString("FullName"));
        adminUser.setEmail(resultSet.getString("Email"));
        adminUser.setPasswordHash(resultSet.getString("PasswordHash"));
        adminUser.setRole(resultSet.getString("Role"));
        return adminUser;
    }
}
