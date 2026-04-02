package DAO;

import Model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    private Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }
    /**
     * Registers a new user in the system.
     * @param user The user object containing registration details.
     * @return true if insertion was successful, false otherwise.
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, password, number, dob, isActive, gender, isVerified) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getNumber());
            ps.setTimestamp(5, user.getDOB());
            ps.setBoolean(6, user.isActive());
            ps.setString(7, String.valueOf(user.getGender()));
            ps.setBoolean(8, user.isVerified());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * Checks whether a user with the given email already exists in the database.
     *
     * @param email The email address to check for existence.
     * @return true if a user with the specified email is found, false otherwise.
     */
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true; //
        }
    }
}