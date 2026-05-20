# SarkarSathi (सरकार साथी)

SarkarSathi is a comprehensive e-governance web application designed for the Nepalese municipal context. It bridges the gap between citizens and local government by digitizing the application process for vital personal certificates and providing an efficient workflow for administrative review.

## 🚀 Key Features

### For Citizens

- **Self-Registration & Login**: Secure citizen accounts using BCrypt password hashing.
- **Digital Applications**: Apply for Marriage, Residence, and Citizenship certificates online.
- **Document Vault**: Upload and store digital copies of essential documents (photos, signatures, identity proofs).
- **Application Tracking**: Real-time status updates (Submitted → Pending Review → Approved/Rejected).
- **Tax Management**: View and pay property and land taxes (simulated integration).

### For Administrators

- **Analytical Dashboard**: Visual representation of application trends using Chart.js.
- **Status Breakdown**: Quick counters for Total, Submitted, Pending, Approved, and Rejected applications.
- **Review Workflow**: Dedicated screens for reviewing submitted documents and forms.
- **Ward Management**: Multi-ward support for decentralized administration.

## 🛠️ Tech Stack

- **Language**: Java 22
- **Framework**: Jakarta EE (Servlets, JSP)
- **Database**: MySQL 8.x+
- **Styling**: Tailwind CSS
- **Icons**: Lucide Icons
- **Visualization**: Chart.js
- **Dependency Management**: Maven

## 📋 Prerequisites

- **JDK**: Version 22 or higher.
- **MySQL Server**: Running on `localhost:3306`.
- **Apache Tomcat**: Version 10.1.x (supports Jakarta EE 10 / Servlet 6.0).
- **Maven**: To build the project.

## ⚙️ Setup & Installation

### 1. Database & Initial Setup

The project includes a built-in bootstrapper to set up everything automatically.

1. Ensure your MySQL server is running on `localhost:3306` with user `root` (and no password).
2. Run the following command from the project root:

   ```bash
   ./mvnw exec:java@setup-db
   ```

   _This will create the `SarkarSathi` database, all necessary tables, and initial ward data._

3. Seed the admin accounts:
   ```bash
   ./mvnw exec:java@seed-admins
   ```
   _Note: Default admin password is `Admin@123`._

### 2. Configure Database Connection (Optional)

If your MySQL configuration differs (non-root user or custom password):

- Open [src/main/java/Util/DatabaseConnection.java](src/main/java/Util/DatabaseConnection.java) and [src/main/java/Util/DatabaseSetup.java](src/main/java/Util/DatabaseSetup.java).
- Update the connection constants accordingly.

### 3. Build & Deploy

1. Build the WAR file:
   ```bash
   ./mvnw clean package
   ```
2. Move the generated `SarkarSatthi-1.0-SNAPSHOT.war` from `target/` to your Tomcat `webapps/` folder.
3. Start Tomcat and navigate to `http://localhost:8080/SarkarSatthi`.

## 🔑 Default Credentials

You can log in as an Admin using one of the following emails (Password: `Admin@123`):

- `samir.nepal@sarkarsathi.gov.np` (Supervisor - Ward 1)
- `prajwal.koirala@sarkarsathi.gov.np` (Officer - Ward 2)

## 🔍 Debugging & Troubleshooting

| Issue                         | Potential Cause           | Fix                                                                                                                                           |
| ----------------------------- | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **404 Not Found**             | Deployment context path.  | Ensure you use the correct context path (e.g., `/SarkarSatthi/login`) or rename the `.war` to `ROOT.war`.                                     |
| **500 Internal Server Error** | MySQL Connection failure. | Check if MySQL is running and credentials in `DatabaseConnection.java` are correct.                                                           |
| **JSP Errors**                | Tomcat Version Mismatch.  | This project uses `Jakarta EE 10`. Ensure you are using **Tomcat 10.1+**. Tomcat 9 or below will not support the `jakarta.servlet` namespace. |
| **Uploads Failing**           | Directory permissions.    | Ensure the application has write permissions to the server's temp directory or specified storage paths.                                       |
| **Icons not showing**         | Lucide not initialized.   | Check if `lucide.createIcons()` is called in the `<script>` tag at the bottom of the JSP.                                                     |

## 🏗️ Project Structure

- `src/main/java/Controller`: Servlet-based HTTP handlers.
- `src/main/java/DAO`: Data Access Objects for database interactions.
- `src/main/java/Model`: Java POJOs representing database entities.
- `src/main/webapp/WEB-INF/admin`: Admin dashboard and management screens.
- `src/main/webapp/WEB-INF/citizen`: Citizen application forms and vault.

---

Developed by **SarkarSathi Team**.
