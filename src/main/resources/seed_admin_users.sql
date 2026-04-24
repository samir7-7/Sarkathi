INSERT IGNORE INTO WARD (WardID, WardNumber, MunicipalityName, Province) VALUES
(1, 1, 'Birgunj Metropolitan City', 'Madhesh'),
(2, 2, 'Birgunj Metropolitan City', 'Madhesh'),
(3, 3, 'Birgunj Metropolitan City', 'Madhesh'),
(4, 4, 'Birgunj Metropolitan City', 'Madhesh'),
(5, 5, 'Birgunj Metropolitan City', 'Madhesh');

-- Verify
SELECT AdminID, WardID, FullName, Email, Role FROM ADMIN_USER;
