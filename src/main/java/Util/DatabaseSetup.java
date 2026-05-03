package Util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * One-shot bootstrapper that creates the {@code SarkarSathi} database, all
 * its tables, and a small set of default rows (wards 1–5, four basic
 * service types).
 * <p>
 * Wired up as a Maven {@code exec:java} execution so the database can be
 * brought up from scratch with a single command. Idempotent: every
 * {@code CREATE} uses {@code IF NOT EXISTS} and every default-data insert
 * uses {@code ON DUPLICATE KEY UPDATE}, so it's safe to re-run.
 *
 * @author SarkarSathi
 */
public class DatabaseSetup {
  /**
   * Entry point. Connects to MySQL, creates the database if it doesn't
   * exist, then creates every table and seeds the default reference data.
   * Errors are printed to stderr — the process won't throw out of main.
   *
   * @param args ignored
   */
  public static void main(String[] args) {
    System.out.println("\n========================================");
    System.out.println("   SarkarSathi Database Setup");
    System.out.println("========================================\n");

    try {
      String urlWithoutDb = "jdbc:mysql://localhost:3306";
      try (Connection connection = DriverManager.getConnection(urlWithoutDb, "root", "")) {
        System.out.println("Connected to MySQL");
        try (Statement stmt = connection.createStatement()) {
          stmt.execute("CREATE DATABASE IF NOT EXISTS SarkarSathi DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
          System.out.println("Created/Verified database 'SarkarSathi'");
        }
      }

      try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/SarkarSathi", "root", "")) {
        System.out.println("Connected to SarkarSathi database\n");
        System.out.println("Creating tables...\n");

        try (Statement stmt = connection.createStatement()) {
          stmt.execute("CREATE TABLE IF NOT EXISTS `CITIZEN` ("
                  + "`CitizenID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`FullName` VARCHAR(100),"
                  + "`Email` VARCHAR(150) UNIQUE,"
                  + "`Phone` VARCHAR(15),"
                  + "`PasswordHash` VARCHAR(255),"
                  + "`DateOfBirth` DATE,"
                  + "`Gender` ENUM('M','F','O'),"
                  + "`CreatedAt` DATETIME"
                  + ")");
          System.out.println("  CITIZEN");

          stmt.execute("CREATE TABLE IF NOT EXISTS `WARD` ("
                  + "`WardID` INT PRIMARY KEY,"
                  + "`WardNumber` INT,"
                  + "`MunicipalityName` VARCHAR(100),"
                  + "`Province` VARCHAR(50),"
                  + "`WardStampImage` VARCHAR(255)"
                  + ")");
          System.out.println("  WARD");

          stmt.execute("CREATE TABLE IF NOT EXISTS `ADMIN_USER` ("
                  + "`AdminID` INT PRIMARY KEY,"
                  + "`WardID` INT,"
                  + "`FullName` VARCHAR(100),"
                  + "`Email` VARCHAR(150) UNIQUE,"
                  + "`PasswordHash` VARCHAR(255),"
                  + "`Role` ENUM('officer','supervisor'),"
                  + "FOREIGN KEY (`WardID`) REFERENCES `WARD` (`WardID`)"
                  + ")");
          System.out.println("  ADMIN_USER");

          stmt.execute("CREATE TABLE IF NOT EXISTS `SERVICE_TYPE` ("
                  + "`ServiceTypeID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`ServiceName` VARCHAR(100),"
                  + "`Description` TEXT,"
                  + "`BaseFee` DECIMAL(10,2),"
                  + "`IsActive` BOOLEAN"
                  + ")");
          System.out.println("  SERVICE_TYPE");

          stmt.execute("CREATE TABLE IF NOT EXISTS `APPLICATION` ("
                  + "`ApplicationID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`TrackingID` VARCHAR(20) UNIQUE,"
                  + "`CitizenID` INT,"
                  + "`ServiceTypeID` INT,"
                  + "`WardID` INT,"
                  + "`Status` ENUM('submitted','review','approved','rejected'),"
                  + "`SubmittedAt` DATETIME,"
                  + "`FormData` JSON,"
                  + "`LastUpdatedAt` DATETIME,"
                  + "`Remarks` TEXT,"
                  + "`ReviewedByAdminID` INT,"
                  + "FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`),"
                  + "FOREIGN KEY (`ServiceTypeID`) REFERENCES `SERVICE_TYPE` (`ServiceTypeID`),"
                  + "FOREIGN KEY (`WardID`) REFERENCES `WARD` (`WardID`),"
                  + "FOREIGN KEY (`ReviewedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)"
                  + ")");
          System.out.println("  APPLICATION");

          stmt.execute("CREATE TABLE IF NOT EXISTS `PAYMENT` ("
                  + "`PaymentID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`ApplicationID` INT,"
                  + "`Amount` DECIMAL(10,2),"
                  + "`PaymentType` ENUM('service','housetax','landtax'),"
                  + "`Status` ENUM('pending','completed'),"
                  + "`PaidAt` DATETIME,"
                  + "FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`)"
                  + ")");
          System.out.println("  PAYMENT");

          stmt.execute("CREATE TABLE IF NOT EXISTS `TAX_RECORD` ("
                  + "`TaxID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`CitizenID` INT,"
                  + "`TaxType` ENUM('house','land'),"
                  + "`FiscalYear` VARCHAR(10),"
                  + "`DueAmount` DECIMAL(10,2),"
                  + "`PaymentID` INT,"
                  + "`IsPaid` BOOLEAN,"
                  + "FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`),"
                  + "FOREIGN KEY (`PaymentID`) REFERENCES `PAYMENT` (`PaymentID`)"
                  + ")");
          System.out.println("  TAX_RECORD");

          stmt.execute("CREATE TABLE IF NOT EXISTS `CITIZEN_DOCUMENT_VAULT` ("
                  + "`VaultDocID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`CitizenID` INT,"
                  + "`DocumentType` VARCHAR(50),"
                  + "`FilePath` VARCHAR(255),"
                  + "`UploadedAt` DATETIME,"
                  + "FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`)"
                  + ")");
          System.out.println("  CITIZEN_DOCUMENT_VAULT");

          stmt.execute("CREATE TABLE IF NOT EXISTS `APPLICATION_DOCUMENT` ("
                  + "`DocID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`ApplicationID` INT,"
                  + "`DocumentType` VARCHAR(50),"
                  + "`FilePath` VARCHAR(255),"
                  + "`UploadedAt` DATETIME,"
                  + "`IsReusable` BOOLEAN,"
                  + "FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`)"
                  + ")");
          System.out.println("  APPLICATION_DOCUMENT");

          stmt.execute("CREATE TABLE IF NOT EXISTS `ISSUED_CERTIFICATE` ("
                  + "`CertificateID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`ApplicationID` INT UNIQUE,"
                  + "`CertificateNo` VARCHAR(30) UNIQUE,"
                  + "`IssuedAt` DATETIME,"
                  + "`PDFFilePath` VARCHAR(255),"
                  + "`IssuedByAdminID` INT,"
                  + "FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`),"
                  + "FOREIGN KEY (`IssuedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)"
                  + ")");
          System.out.println("  ISSUED_CERTIFICATE");

          stmt.execute("CREATE TABLE IF NOT EXISTS `NOTIFICATION` ("
                  + "`NotificationID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`CitizenID` INT,"
                  + "`ApplicationID` INT,"
                  + "`Message` TEXT,"
                  + "`IsRead` BOOLEAN,"
                  + "`CreatedAt` DATETIME,"
                  + "FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`),"
                  + "FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`)"
                  + ")");
          System.out.println("  NOTIFICATION");

          stmt.execute("CREATE TABLE IF NOT EXISTS `AGRICULTURE_NOTICE` ("
                  + "`NoticeID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`PostedByAdminID` INT,"
                  + "`Title` VARCHAR(200),"
                  + "`Content` TEXT,"
                  + "`Category` ENUM('subsidy','training','scheme'),"
                  + "`PublishedAt` DATETIME,"
                  + "FOREIGN KEY (`PostedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)"
                  + ")");
          System.out.println("  AGRICULTURE_NOTICE");

          stmt.execute("CREATE TABLE IF NOT EXISTS `ANNOUNCEMENT` ("
                  + "`AnnouncementID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`PostedByAdminID` INT,"
                  + "`Title` VARCHAR(200),"
                  + "`Content` TEXT,"
                  + "`EventDate` DATE,"
                  + "`PublishedAt` DATETIME,"
                  + "FOREIGN KEY (`PostedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)"
                  + ")");
          System.out.println("  ANNOUNCEMENT");

          stmt.execute("CREATE TABLE IF NOT EXISTS `BUDGET_ALLOCATION` ("
                  + "`BudgetID` INT PRIMARY KEY AUTO_INCREMENT,"
                  + "`WardID` INT,"
                  + "`Department` VARCHAR(100),"
                  + "`AllocatedAmount` DECIMAL(15,2),"
                  + "`FiscalYear` VARCHAR(10),"
                  + "`Description` TEXT,"
                  + "FOREIGN KEY (`WardID`) REFERENCES `WARD` (`WardID`)"
                  + ")");
          System.out.println("  BUDGET_ALLOCATION");

          stmt.executeUpdate("INSERT INTO WARD (WardID, WardNumber, MunicipalityName, Province, WardStampImage) VALUES "
                  + "(1, 1, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),"
                  + "(2, 2, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),"
                  + "(3, 3, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),"
                  + "(4, 4, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),"
                  + "(5, 5, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png') "
                  + "ON DUPLICATE KEY UPDATE MunicipalityName = VALUES(MunicipalityName), Province = VALUES(Province), WardStampImage = VALUES(WardStampImage)");
          System.out.println("  Default wards seeded");

          stmt.executeUpdate("INSERT INTO SERVICE_TYPE (ServiceTypeID, ServiceName, Description, BaseFee, IsActive) VALUES "
                  + "(1, 'Birth Certificate', 'Register and request a birth certificate', 100.00, TRUE),"
                  + "(2, 'Marriage Certificate', 'Apply for marriage registration certificate', 200.00, TRUE),"
                  + "(3, 'Residence Certificate', 'Request proof of residence from the ward office', 150.00, TRUE),"
                  + "(4, 'Citizenship Recommendation', 'Apply for a ward recommendation for citizenship', 500.00, TRUE) "
                  + "ON DUPLICATE KEY UPDATE ServiceName = VALUES(ServiceName), Description = VALUES(Description), BaseFee = VALUES(BaseFee), IsActive = VALUES(IsActive)");
          System.out.println("  Default services seeded");

          System.out.println("\nAll tables created successfully!");
        }
      }

      System.out.println("\n========================================");
      System.out.println("   Database Setup Complete!");
      System.out.println("========================================\n");
      System.out.println("Next steps:");
      System.out.println("  1. Run AdminSeeder to create admin accounts");
      System.out.println("     Command: mvnw exec:java@seed-admins\n");
    } catch (SQLException e) {
      System.err.println("ERROR: " + e.getMessage());
      e.printStackTrace();
    }
  }
}