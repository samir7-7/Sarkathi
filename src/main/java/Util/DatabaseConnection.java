package Util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/SarkarSathi";
    private static final String USERNAME = "ROOT";
    private static final String PASSWORD = "1234567890";

    private DatabaseConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
