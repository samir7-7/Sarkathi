package Util;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Small runtime schema compatibility fixes for local development databases.
 * This keeps older installs working even after the codebase starts accepting
 * more tax/payment types than the original ENUM columns allowed.
 */
public final class SchemaMigration {
    private static volatile boolean schemaChecked;

    private SchemaMigration() {
    }

    /**
     * Applies lightweight, idempotent schema adjustments once per app run.
     *
     * @param connection open JDBC connection
     * @throws SQLException if a compatible schema cannot be ensured
     */
    public static void ensureCompatibility(Connection connection) throws SQLException {
        if (schemaChecked) {
            return;
        }

        synchronized (SchemaMigration.class) {
            if (schemaChecked) {
                return;
            }

            try (Statement stmt = connection.createStatement()) {
                stmt.execute("ALTER TABLE PAYMENT MODIFY COLUMN PaymentType VARCHAR(40) NOT NULL");
                stmt.execute("ALTER TABLE TAX_RECORD MODIFY COLUMN TaxType VARCHAR(40) NOT NULL");
            } catch (SQLException e) {
                if (!isMissingTableError(e)) {
                    throw e;
                }
            }

            schemaChecked = true;
        }
    }

    private static boolean isMissingTableError(SQLException e) {
        return e.getMessage() != null
                && (e.getMessage().contains("doesn't exist") || e.getMessage().contains("Unknown table"));
    }
}
