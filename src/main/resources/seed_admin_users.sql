-- ============================================================
-- SarkarSathi Admin Accounts Seed Script
-- ============================================================
-- Matches schema in src/main/query/create.sql
--   AdminID  INT PRIMARY KEY (not auto-increment)
--   Role     ENUM('officer','supervisor')
--   WardID   FK -> WARD(WardID)
--
-- All 5 admins use the password: Admin@123
-- ============================================================

-- Ensure wards exist first (required for FK)
INSERT IGNORE INTO WARD (WardID, WardNumber, MunicipalityName, Province) VALUES
(1, 1, 'Kathmandu Metropolitan City', 'Bagmati'),
(2, 2, 'Kathmandu Metropolitan City', 'Bagmati'),
(3, 3, 'Kathmandu Metropolitan City', 'Bagmati'),
(4, 4, 'Kathmandu Metropolitan City', 'Bagmati'),
(5, 5, 'Kathmandu Metropolitan City', 'Bagmati');

-- ============================================================
-- RECOMMENDED: Run the Java AdminSeeder class instead
-- ============================================================
-- The Java seeder generates fresh BCrypt hashes at runtime.
-- In IntelliJ: Right-click AdminSeeder.java -> Run
-- ============================================================

-- Verify
SELECT AdminID, WardID, FullName, Email, Role FROM ADMIN_USER;
