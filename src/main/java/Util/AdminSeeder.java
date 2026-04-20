package Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * One-time utility to seed 5 admin accounts into the database.
 * Run this class once to create the admin accounts.
 *
 * PREREQUISITE: WARD table must have at least wards 1-5 inserted.
 * If not, this seeder will create them automatically.
 *
 * Admin accounts created (all use password: Admin@123):
 * 1. samir.nepal@sarkarsathi.gov.np (supervisor, Ward 1)
 * 2. prajwal.koirala@sarkarsathi.gov.np (officer, Ward 2)
 * 3. min.pandey@sarkarsathi.gov.np (officer, Ward 3)
 * 4. nabin.adhikari@sarkarsathi.gov.np (supervisor, Ward 4)
 * 5. rythm.shrestha@sarkarsathi.gov.np (officer, Ward 5)
 */
public class AdminSeeder {

    // Schema: AdminID INT PRIMARY KEY (not auto-increment),
    // WardID INT FK -> WARD, Role ENUM('officer','supervisor')
    private static final String[][] ADMINS = {
            // { adminId, fullName, email, password, role, wardId }
            { "1", "Samir Nepal", "samir.nepal@sarkarsathi.gov.np", "Admin@123", "supervisor", "1" },
            { "2", "Prajwal Koirala", "prajwal.koirala@sarkarsathi.gov.np", "Admin@123", "officer", "2" },
            { "3", "Min Kumar Pandey", "min.pandey@sarkarsathi.gov.np", "Admin@123", "officer", "3" },
            { "4", "Nabin Adhikari", "nabin.adhikari@sarkarsathi.gov.np", "Admin@123", "supervisor", "4" },
            { "5", "Rythm Shrestha", "rythm.shrestha@sarkarsathi.gov.np", "Admin@123", "officer", "5" },
    };

    public static void main(String[] args) {
        System.out.println("=== SarkarSathi Admin Seeder ===");
        System.out.println("Seeding 5 admin accounts...\n");

        try (Connection connection = DatabaseConnection.getConnection()) {

            // Ensure wards 1-5 exist
            seedWards(connection);

            String checkSql = "SELECT COUNT(*) FROM ADMIN_USER WHERE Email = ?";
            String insertSql = "INSERT INTO ADMIN_USER (AdminID, WardID, FullName, Email, PasswordHash, Role) VALUES (?, ?, ?, ?, ?, ?)";

            int created = 0;
            int skipped = 0;

            for (String[] admin : ADMINS) {
                int adminId = Integer.parseInt(admin[0]);
                String fullName = admin[1];
                String email = admin[2];
                String password = admin[3];
                String role = admin[4];
                int wardId = Integer.parseInt(admin[5]);

                // Check if admin already exists
                try (PreparedStatement check = connection.prepareStatement(checkSql)) {
                    check.setString(1, email);
                    try (ResultSet rs = check.executeQuery()) {
                        rs.next();
                        if (rs.getInt(1) > 0) {
                            System.out.println("  SKIP  : " + email + " (already exists)");
                            skipped++;
                            continue;
                        }
                    }
                }

                // Hash password and insert
                String hashedPassword = PasswordUtil.hash(password);
                try (PreparedStatement insert = connection.prepareStatement(insertSql)) {
                    insert.setInt(1, adminId);
                    insert.setInt(2, wardId);
                    insert.setString(3, fullName);
                    insert.setString(4, email);
                    insert.setString(5, hashedPassword);
                    insert.setString(6, role);
                    insert.executeUpdate();
                    System.out.println("  CREATE: " + email + " (" + role + ", Ward " + wardId + ")");
                    created++;
                }
            }

            System.out.println("\n=== Done ===");
            System.out.println("Created: " + created + " | Skipped: " + skipped);
            System.out.println("\nAll admin credentials use password: Admin@123");

        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            System.err.println("Stack trace:");
            for (StackTraceElement element : e.getStackTrace()) {
                System.err.println("  at " + element);
            }
        }
    }

    private static void seedWards(Connection connection) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM WARD WHERE WardID = ?";
        String insertSql = "INSERT INTO WARD (WardID, WardNumber, MunicipalityName, Province) VALUES (?, ?, ?, ?)";

        String[][] wards = {
                { "1", "1", "Kathmandu Metropolitan City", "Bagmati" },
                { "2", "2", "Kathmandu Metropolitan City", "Bagmati" },
                { "3", "3", "Kathmandu Metropolitan City", "Bagmati" },
                { "4", "4", "Kathmandu Metropolitan City", "Bagmati" },
                { "5", "5", "Kathmandu Metropolitan City", "Bagmati" },
        };

        for (String[] ward : wards) {
            try (PreparedStatement check = connection.prepareStatement(checkSql)) {
                check.setInt(1, Integer.parseInt(ward[0]));
                try (ResultSet rs = check.executeQuery()) {
                    rs.next();
                    if (rs.getInt(1) > 0)
                        continue;
                }
            }
            try (PreparedStatement insert = connection.prepareStatement(insertSql)) {
                insert.setInt(1, Integer.parseInt(ward[0]));
                insert.setInt(2, Integer.parseInt(ward[1]));
                insert.setString(3, ward[2]);
                insert.setString(4, ward[3]);
                insert.executeUpdate();
                System.out.println("  WARD  : Created Ward " + ward[1]);
            }
        }
    }
}
