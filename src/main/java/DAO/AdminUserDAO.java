package DAO;

import Model.AdminUser;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class AdminUserDAO {
    private final Connection connection;

    public AdminUserDAO(Connection connection) {
        this.connection = connection;
    }

    public Optional<AdminUser> findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM ADMIN_USER WHERE Email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

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
