package Util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Diagnostic helper for verifying the database is in a usable state.
 * <p>
 * Run this any time you're not sure whether the schema is created, the
 * admins are seeded, or the wards exist. It just prints a status report —
 * it doesn't change anything.
 *
 * @author SarkarSathi
 */
public class DatabaseChecker {
  /**
   * Entry point. Opens a connection through {@link DatabaseConnection},
   * lists every table it can find via JDBC metadata, then prints summary
   * counts of admins, citizens, and wards.
   *
   * @param args ignored
   */
  public static void main(String[] args) {
    try (Connection connection = DatabaseConnection.getConnection()) {
      System.out.println("\n========================================");
      System.out.println("   Database: SarkarSathi Status Check");
      System.out.println("========================================\n");

      // Check tables
      DatabaseMetaData metaData = connection.getMetaData();
      ResultSet tables = metaData.getTables(null, null, "%", new String[] { "TABLE" });

      System.out.println("TABLES FOUND:");
      System.out.println("-------------");
      int tableCount = 0;
      while (tables.next()) {
        System.out.println("  ✓ " + tables.getString("TABLE_NAME"));
        tableCount++;
      }
      System.out.println("Total: " + tableCount + " tables\n");

      // Check admin users
      System.out.println("ADMIN USERS:");
      System.out.println("------------");
      try (Statement stmt = connection.createStatement()) {
        ResultSet adminUsers = stmt.executeQuery(
            "SELECT AdminID, FullName, Email, Role, WardID FROM ADMIN_USER");
        int adminCount = 0;
        while (adminUsers.next()) {
          System.out.printf("  ✓ [%d] %s (%s) - Ward %d - %s%n",
              adminUsers.getInt("AdminID"),
              adminUsers.getString("FullName"),
              adminUsers.getString("Email"),
              adminUsers.getInt("WardID"),
              adminUsers.getString("Role"));
          adminCount++;
        }
        if (adminCount == 0) {
          System.out.println("  ✗ NO ADMIN USERS FOUND - Run AdminSeeder first!");
        } else {
          System.out.println("Total: " + adminCount + " admins\n");
        }
      }

      // Check citizens
      System.out.println("CITIZENS:");
      System.out.println("---------");
      try (Statement stmt = connection.createStatement()) {
        ResultSet citizens = stmt.executeQuery(
            "SELECT COUNT(*) as count FROM CITIZEN");
        citizens.next();
        int citizenCount = citizens.getInt("count");
        System.out.println("  Total: " + citizenCount + " citizens\n");
      }

      // Check wards
      System.out.println("WARDS:");
      System.out.println("------");
      try (Statement stmt = connection.createStatement()) {
        ResultSet wards = stmt.executeQuery(
            "SELECT WardID, WardNumber, MunicipalityName FROM WARD ORDER BY WardID");
        int wardCount = 0;
        while (wards.next()) {
          System.out.printf("  ✓ Ward %d - %s%n",
              wards.getInt("WardID"),
              wards.getString("MunicipalityName"));
          wardCount++;
        }
        if (wardCount == 0) {
          System.out.println("  ✗ NO WARDS FOUND");
        } else {
          System.out.println("Total: " + wardCount + " wards\n");
        }
      }

      System.out.println("========================================");
      System.out.println("   Database Ready: " + (tableCount > 0 ? "YES ✓" : "NO ✗"));
      System.out.println("========================================\n");

    } catch (SQLException e) {
      System.err.println("ERROR: " + e.getMessage());
      e.printStackTrace();
    }
  }
}
