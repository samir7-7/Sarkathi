package Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * One-time utility that seeds five default admin accounts into the database
 * so you can actually log in to the admin side after a fresh install.
 * <p>
 * Wards 1–5 are a prerequisite — if they're missing, this seeder also
 * creates those (Birgunj Metropolitan City, Madhesh province) before
 * inserting the admin rows.
 * <p>
 * <strong>Default credentials</strong> (all use password {@code Admin@123}):
 * <ol>
 *   <li>samir.nepal@sarkarsathi.gov.np — supervisor, Ward 1</li>
 *   <li>prajwal.koirala@sarkarsathi.gov.np — officer, Ward 2</li>
 *   <li>min.pandey@sarkarsathi.gov.np — officer, Ward 3</li>
 *   <li>nabin.adhikari@sarkarsathi.gov.np — supervisor, Ward 4</li>
 *   <li>rythm.shrestha@sarkarsathi.gov.np — officer, Ward 5</li>
 * </ol>
 * Passwords are stored as BCrypt hashes via {@link PasswordUtil#hash(String)}.
 *
 * @author SarkarSathi
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

    /**
     * Entry point used when running this seeder manually
     * ({@code mvnw exec:java@seed-admins}). Always tries to create every
     * admin in the {@link #ADMINS} list, skipping ones whose email already
     * exists.
     *
     * @param args ignored
     */
    public static void main(String[] args) {
        System.out.println("=== SarkarSathi Admin Seeder ===");
        System.out.println("Seeding 5 admin accounts...\n");

        try (Connection connection = DatabaseConnection.getConnection()) {
            SeedResult result = seedAdmins(connection, false);

            System.out.println("\n=== Done ===");
            System.out.println("Created: " + result.created + " | Skipped: " + result.skipped);
            System.out.println("\nAll admin credentials use password: Admin@123");

        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            System.err.println("Stack trace:");
            for (StackTraceElement element : e.getStackTrace()) {
                System.err.println("  at " + element);
            }
        }
    }

    /**
     * Server-startup hook used by {@link AdminSeedStartupListener}. Only
     * seeds when the {@code ADMIN_USER} table is completely empty — so
     * existing deployments with custom admins don't get extra defaults
     * sprinkled in on every restart.
     *
     * @return {@code true} if any admin rows were actually inserted
     * @throws SQLException if the database operations fail
     */
    public static boolean seedAdminsIfMissing() throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            SeedResult result = seedAdmins(connection, true);
            return result.created > 0;
        }
    }

    /**
     * Shared seed loop. Makes sure wards exist, then for each entry in
     * {@link #ADMINS} skips it if an admin with that email is already in
     * the table, otherwise BCrypt-hashes the password and inserts a row.
     *
     * @param connection         open JDBC connection to use
     * @param onlyWhenTableEmpty if {@code true}, do nothing when at least
     *                           one admin already exists (used by the
     *                           startup-listener path)
     * @return a small struct of created/skipped counts
     * @throws SQLException if any of the queries fail
     */
    private static SeedResult seedAdmins(Connection connection, boolean onlyWhenTableEmpty) throws SQLException {
        seedWards(connection);

        if (onlyWhenTableEmpty && hasExistingAdmins(connection)) {
            return new SeedResult(0, ADMINS.length);
        }

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

            try (PreparedStatement check = connection.prepareStatement(checkSql)) {
                check.setString(1, email);
                try (ResultSet rs = check.executeQuery()) {
                    rs.next();
                    if (rs.getInt(1) > 0) {
                        skipped++;
                        continue;
                    }
                }
            }

            String hashedPassword = PasswordUtil.hash(password);
            try (PreparedStatement insert = connection.prepareStatement(insertSql)) {
                insert.setInt(1, adminId);
                insert.setInt(2, wardId);
                insert.setString(3, fullName);
                insert.setString(4, email);
                insert.setString(5, hashedPassword);
                insert.setString(6, role);
                insert.executeUpdate();
                created++;
            }
        }

        return new SeedResult(created, skipped);
    }

    /**
     * @param connection open JDBC connection
     * @return {@code true} if there's at least one row in {@code ADMIN_USER}
     * @throws SQLException if the count query fails
     */
    private static boolean hasExistingAdmins(Connection connection) throws SQLException {
        try (PreparedStatement check = connection.prepareStatement("SELECT COUNT(*) FROM ADMIN_USER")) {
            try (ResultSet rs = check.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    /**
     * Inserts wards 1–5 if they aren't already in the database. Each ward
     * is checked individually so partially-seeded states are handled
     * correctly.
     *
     * @param connection open JDBC connection
     * @throws SQLException if any of the inserts fail
     */
    private static void seedWards(Connection connection) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM WARD WHERE WardID = ?";
        String insertSql = "INSERT INTO WARD (WardID, WardNumber, MunicipalityName, Province) VALUES (?, ?, ?, ?)";

        String[][] wards = {
                { "1", "1", "Birgunj Metropolitan City", "Madhesh" },
                { "2", "2", "Birgunj Metropolitan City", "Madhesh" },
                { "3", "3", "Birgunj Metropolitan City", "Madhesh" },
                { "4", "4", "Birgunj Metropolitan City", "Madhesh" },
                { "5", "5", "Birgunj Metropolitan City", "Madhesh" },
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

    /**
     * Tiny value type holding the count of admins that were freshly
     * inserted vs. skipped because an account with that email already
     * existed.
     */
    private static final class SeedResult {
        private final int created;
        private final int skipped;

        /**
         * @param created number of admin rows newly inserted
         * @param skipped number of admins that were already present
         */
        private SeedResult(int created, int skipped) {
            this.created = created;
            this.skipped = skipped;
        }
    }
}
