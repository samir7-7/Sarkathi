# SarkarSathi (सरकार साथी)

SarkarSathi is a municipal e-governance web application built for the Nepalese local-government context. It gives citizens a digital way to register, apply for ward services, track requests, manage documents, and pay municipal fees, while giving ward administrators tools to review applications, publish notices, and manage budgets.

## Overview

- Citizen and admin login flows with BCrypt-hashed passwords
- Online application workflow for common municipal certificate services
- Citizen document vault for reusable uploads
- Application tracking, notifications, and issued certificates
- Municipal tax and service payment flows, including eSewa callback handling
- Admin tools for announcements, agriculture notices, budgets, and tax-payment review

## Tech Stack

- Java 22
- Jakarta EE 10 (`Servlet` + `JSP`)
- MySQL 8+
- Maven
- Apache Tomcat 10.1+
- BCrypt (`jBCrypt`)
- Chart.js and Lucide Icons on the frontend

## Project Structure

- `src/main/java/Controller` - servlet endpoints and page dispatchers
- `src/main/java/DAO` - database access layer
- `src/main/java/Model` - application domain models
- `src/main/java/Util` - database bootstrap, migration, seeding, auth helpers
- `src/main/resources` - example config and Tomcat support files
- `src/main/webapp/WEB-INF/pages` - public pages
- `src/main/webapp/WEB-INF/citizen` - citizen dashboard pages
- `src/main/webapp/WEB-INF/admin` - admin dashboard pages

## Prerequisites

- JDK 22
- MySQL Server running locally or reachable from the app
- Apache Tomcat 10.1.x or newer
- Maven, or use the included Maven wrapper

## Setup

### 1. Create application config

Copy the example file and create your local database config:

```powershell
Copy-Item src/main/resources/application.properties.example src/main/resources/application.properties
```

Update `src/main/resources/application.properties` with your MySQL details:

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/SarkarSathi
db.username=root
db.password=your_mysql_password_here
```

Important:

- `DatabaseConnection` loads `application.properties` at runtime.
- The app will fail to start if that file is missing.
- `db.url` must include the database name because the setup utility derives it from that URL.

### 2. Create the database and seed base data

Run the bundled setup utility from the project root:

```powershell
.\mvnw.cmd exec:java@setup-db
```

This creates the `SarkarSathi` database if needed, creates the tables, and seeds:

- Wards 1-5 for Birgunj Metropolitan City
- Default service types:
  - Birth Certificate
  - Marriage Certificate
  - Residence Certificate
  - Citizenship Recommendation

### 3. Seed admin accounts

You can seed the default admin users manually:

```powershell
.\mvnw.cmd exec:java@seed-admins
```

The web app also auto-seeds these accounts on startup if the `ADMIN_USER` table is empty.

### 4. Build the WAR

```powershell
.\mvnw.cmd clean package
```

The WAR will be generated in `target/` as `SarkarSatthi-1.0-SNAPSHOT.war`.

### 5. Deploy to Tomcat

Copy the WAR into your Tomcat `webapps` directory, start Tomcat, then open:

```text
http://localhost:8080/SarkarSatthi
```

## Default Admin Credentials

All seeded admin accounts use this password:

```text
Admin@123
```

Available accounts:

- `samir.nepal@sarkarsathi.gov.np` - Supervisor, Ward 1
- `prajwal.koirala@sarkarsathi.gov.np` - Officer, Ward 2
- `min.pandey@sarkarsathi.gov.np` - Officer, Ward 3
- `nabin.adhikari@sarkarsathi.gov.np` - Supervisor, Ward 4
- `rythm.shrestha@sarkarsathi.gov.np` - Officer, Ward 5

## Main User Flows

### Citizen side

- Register and log in as a citizen
- Submit certificate/service applications
- Reuse uploaded documents from the document vault
- Track application status from the public tracker or citizen area
- View notifications and issued certificates
- Pay service and tax charges from the citizen dashboard

### Admin side

- Log in to the admin dashboard
- Review applications and supporting documents
- Manage agriculture notices and public announcements
- Manage budget allocations
- Review recent tax payments

## Database Utilities

Useful Maven commands:

```powershell
.\mvnw.cmd exec:java@check-db
.\mvnw.cmd exec:java@setup-db
.\mvnw.cmd exec:java@seed-admins
```

## Troubleshooting

### App fails on startup with missing config

Cause: `src/main/resources/application.properties` has not been created.

Fix: Copy `application.properties.example` and fill in valid database credentials.

### Database connection errors

Cause: MySQL is not running, credentials are wrong, or `db.url` is invalid.

Fix: Verify the values in `application.properties` and confirm MySQL is reachable.

### JSP or servlet namespace errors

Cause: Tomcat version is too old.

Fix: Use Tomcat 10.1+ because this project uses the `jakarta.*` servlet namespace.

### Admin login does not work on a fresh install

Cause: The admin seeder has not run yet, or the database setup was skipped.

Fix: Run `.\mvnw.cmd exec:java@setup-db` and `.\mvnw.cmd exec:java@seed-admins`, then retry.

## Team

Developed by the SarkarSathi team.
