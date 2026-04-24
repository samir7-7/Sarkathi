CREATE TABLE `CITIZEN` (
                           `CitizenID` INT PRIMARY KEY AUTO_INCREMENT,
                           `FullName` VARCHAR(100),
                           `Email` VARCHAR(150) UNIQUE,
                           `Phone` VARCHAR(15),
                           `PasswordHash` VARCHAR(255),
                           `DateOfBirth` DATE,
                           `Gender` ENUM('M','F','O'),
                           `CreatedAt` DATETIME
);

CREATE TABLE `WARD` (
                        `WardID` INT PRIMARY KEY,
                        `WardNumber` INT,
                        `MunicipalityName` VARCHAR(100),
                        `Province` VARCHAR(50),
                        `WardStampImage` VARCHAR(255)
);

CREATE TABLE `ADMIN_USER` (
                              `AdminID` INT PRIMARY KEY,
                              `WardID` INT,
                              `FullName` VARCHAR(100),
                              `Email` VARCHAR(150) UNIQUE,
                              `PasswordHash` VARCHAR(255),
                              `Role` ENUM('officer','supervisor'),
                              FOREIGN KEY (`WardID`) REFERENCES `WARD` (`WardID`)
);

CREATE TABLE `SERVICE_TYPE` (
                                `ServiceTypeID` INT PRIMARY KEY AUTO_INCREMENT,
                                `ServiceName` VARCHAR(100),
                                `Description` TEXT,
                                `BaseFee` DECIMAL(10,2),
                                `IsActive` BOOLEAN
);

CREATE TABLE `APPLICATION` (
                               `ApplicationID` INT PRIMARY KEY AUTO_INCREMENT,
                               `TrackingID` VARCHAR(20) UNIQUE,
                               `CitizenID` INT,
                               `ServiceTypeID` INT,
                               `WardID` INT,
                               `Status` ENUM('submitted','review','approved','rejected'),
                               `SubmittedAt` DATETIME,
                               `FormData` JSON,
                               `LastUpdatedAt` DATETIME,
                               `Remarks` TEXT,
                               `ReviewedByAdminID` INT,
                               FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`),
                               FOREIGN KEY (`ServiceTypeID`) REFERENCES `SERVICE_TYPE` (`ServiceTypeID`),
                               FOREIGN KEY (`WardID`) REFERENCES `WARD` (`WardID`),
                               FOREIGN KEY (`ReviewedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)
);

CREATE TABLE `PAYMENT` (
                           `PaymentID` INT PRIMARY KEY AUTO_INCREMENT,
                           `ApplicationID` INT,
                           `Amount` DECIMAL(10,2),
                           `PaymentType` ENUM('service','housetax','landtax'),
                           `Status` ENUM('pending','completed'),
                           `PaidAt` DATETIME,
                           FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`)
);

CREATE TABLE `TAX_RECORD` (
                              `TaxID` INT PRIMARY KEY AUTO_INCREMENT,
                              `CitizenID` INT,
                              `TaxType` ENUM('house','land'),
                              `FiscalYear` VARCHAR(10),
                              `DueAmount` DECIMAL(10,2),
                              `PaymentID` INT,
                              `IsPaid` BOOLEAN,
                              FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`),
                              FOREIGN KEY (`PaymentID`) REFERENCES `PAYMENT` (`PaymentID`)
);

CREATE TABLE `CITIZEN_DOCUMENT_VAULT` (
                                          `VaultDocID` INT PRIMARY KEY AUTO_INCREMENT,
                                          `CitizenID` INT,
                                          `DocumentType` VARCHAR(50),
                                          `FilePath` VARCHAR(255),
                                          `UploadedAt` DATETIME,
                                          FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`)
);

CREATE TABLE `APPLICATION_DOCUMENT` (
                                        `DocID` INT PRIMARY KEY AUTO_INCREMENT,
                                        `ApplicationID` INT,
                                        `DocumentType` VARCHAR(50),
                                        `FilePath` VARCHAR(255),
                                        `UploadedAt` DATETIME,
                                        `IsReusable` BOOLEAN,
                                        FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`)
);

CREATE TABLE `ISSUED_CERTIFICATE` (
                                      `CertificateID` INT PRIMARY KEY AUTO_INCREMENT,
                                      `ApplicationID` INT UNIQUE,
                                      `CertificateNo` VARCHAR(30) UNIQUE,
                                      `IssuedAt` DATETIME,
                                      `PDFFilePath` VARCHAR(255),
                                      `IssuedByAdminID` INT,
                                      FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`),
                                      FOREIGN KEY (`IssuedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)
);

CREATE TABLE `NOTIFICATION` (
                                `NotificationID` INT PRIMARY KEY AUTO_INCREMENT,
                                `CitizenID` INT,
                                `ApplicationID` INT,
                                `Message` TEXT,
                                `IsRead` BOOLEAN,
                                `CreatedAt` DATETIME,
                                FOREIGN KEY (`CitizenID`) REFERENCES `CITIZEN` (`CitizenID`),
                                FOREIGN KEY (`ApplicationID`) REFERENCES `APPLICATION` (`ApplicationID`)
);

CREATE TABLE `AGRICULTURE_NOTICE` (
                                      `NoticeID` INT PRIMARY KEY AUTO_INCREMENT,
                                      `PostedByAdminID` INT,
                                      `Title` VARCHAR(200),
                                      `Content` TEXT,
                                      `Category` ENUM('subsidy','training','scheme'),
                                      `PublishedAt` DATETIME,
                                      FOREIGN KEY (`PostedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)
);

CREATE TABLE `ANNOUNCEMENT` (
                                `AnnouncementID` INT PRIMARY KEY AUTO_INCREMENT,
                                `PostedByAdminID` INT,
                                `Title` VARCHAR(200),
                                `Content` TEXT,
                                `EventDate` DATE,
                                `PublishedAt` DATETIME,
                                FOREIGN KEY (`PostedByAdminID`) REFERENCES `ADMIN_USER` (`AdminID`)
);

CREATE TABLE `BUDGET_ALLOCATION` (
                                     `BudgetID` INT PRIMARY KEY AUTO_INCREMENT,
                                     `WardID` INT,
                                     `Department` VARCHAR(100),
                                     `AllocatedAmount` DECIMAL(15,2),
                                     `FiscalYear` VARCHAR(10),
                                     `Description` TEXT,
                                     FOREIGN KEY (`WardID`) REFERENCES `WARD` (`WardID`)
);

INSERT INTO `WARD` (`WardID`, `WardNumber`, `MunicipalityName`, `Province`, `WardStampImage`) VALUES
                                                                                                  (1, 1, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),
                                                                                                  (2, 2, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),
                                                                                                  (3, 3, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),
                                                                                                  (4, 4, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png'),
                                                                                                  (5, 5, 'Birgunj Metropolitan City', 'Madhesh', 'uploads/default-stamp.png')
    ON DUPLICATE KEY UPDATE
                         `MunicipalityName` = VALUES(`MunicipalityName`),
                         `Province` = VALUES(`Province`),
                         `WardStampImage` = VALUES(`WardStampImage`);

INSERT INTO `SERVICE_TYPE` (`ServiceTypeID`, `ServiceName`, `Description`, `BaseFee`, `IsActive`) VALUES
                                                                                                      (1, 'Birth Certificate', 'Register and request a birth certificate', 100.00, TRUE),
                                                                                                      (2, 'Marriage Certificate', 'Apply for marriage registration certificate', 200.00, TRUE),
                                                                                                      (3, 'Residence Certificate', 'Request proof of residence from the ward office', 150.00, TRUE),
                                                                                                      (4, 'Citizenship Recommendation', 'Apply for a ward recommendation for citizenship', 500.00, TRUE)
    ON DUPLICATE KEY UPDATE
                         `ServiceName` = VALUES(`ServiceName`),
                         `Description` = VALUES(`Description`),
                         `BaseFee` = VALUES(`BaseFee`),
                         `IsActive` = VALUES(`IsActive`);