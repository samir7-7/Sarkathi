package Util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Single point of entry for getting a JDBC connection to the SarkarSathi
 * MySQL database.
 * <p>
 * <strong>Heads up:</strong> the database URL, username, and password are
 * hardcoded here for development convenience — root with no password
 * pointing at {@code localhost}. Anything beyond local dev should move these
 * to a config file or environment variables before going anywhere near
 * production.
 *
 * @author SarkarSathi
 */
public final class DatabaseConnection {
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/SarkarSathi";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver not found on the classpath.", e);
        }
    }

    /**
     * Private constructor — this class is a static utility holder and
     * shouldn't be instantiated.
     */
    private DatabaseConnection() {
    }

    /**
     * Opens a fresh JDBC connection to the database.
     * <p>
     * The caller is responsible for closing it (typically via
     * try-with-resources). There's no pooling here — every call hits
     * {@link DriverManager} directly, which is fine for a low-traffic
     * teaching project but worth swapping out for HikariCP if real load
     * shows up.
     *
     * @return a freshly opened connection
     * @throws SQLException if the connection can't be opened
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
