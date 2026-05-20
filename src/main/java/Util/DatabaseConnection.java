package Util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Single point of entry for getting a JDBC connection to the SarkarSathi
 * MySQL database.
 * <p>
 * Database credentials are loaded from {@code application.properties} so
 * private values can stay out of source control.
 *
 * @author SarkarSathi
 */
public final class DatabaseConnection {
    private static final String CONFIG_FILE = "application.properties";
    private static final Properties DATABASE_PROPERTIES = loadDatabaseProperties();
    private static final String DRIVER = getRequiredProperty("db.driver");
    private static final String URL = getRequiredProperty("db.url");
    private static final String USERNAME = getRequiredProperty("db.username");
    private static final String PASSWORD = getProperty("db.password");
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver not found on the classpath.", e);
        }
    }

    private DatabaseConnection() {
    }
    private static Properties loadDatabaseProperties() {
        Properties properties = new Properties();
        try (InputStream inputStream = DatabaseConnection.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (inputStream == null) {
                throw new IllegalStateException(
                        "Missing " + CONFIG_FILE + ". Create it from application.properties.example before starting the app.");
            }
            properties.load(inputStream);
            return properties;
        } catch (IOException e) {
            throw new IllegalStateException("Unable to load database configuration from " + CONFIG_FILE + ".", e);
        }
    }

    private static String getRequiredProperty(String key) {
        String value = DATABASE_PROPERTIES.getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException("Missing required database property: " + key);
        }
        return value.trim();
    }

    private static String getProperty(String key) {
        String value = DATABASE_PROPERTIES.getProperty(key);
        if (value == null) {
            throw new IllegalStateException("Missing required database property: " + key);
        }
        return value.trim();
    }

    public static String getUrl() {
        return URL;
    }

    public static String getUsername() {
        return USERNAME;
    }

    public static String getPassword() {
        return PASSWORD;
    }

    /**
     * Opens a fresh JDBC connection to the database.
     * <p>
     * The caller is responsible for closing it (typically via
     * try-with-resources). There's no pooling here - every call hits
     * {@link DriverManager} directly, which is fine for a low-traffic
     * teaching project but worth swapping out for HikariCP if real load
     * shows up.
     *
     * @return a freshly opened connection
     * @throws SQLException if the connection can't be opened
     */
    public static Connection getConnection() throws SQLException {
        Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        SchemaMigration.ensureCompatibility(connection);
        return connection;
    }
}
