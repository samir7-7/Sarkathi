package DAO.interfaces;

import Model.AdminUser;

import java.sql.SQLException;
import java.util.Optional;

public interface AdminUserDAOInterface {
    Optional<AdminUser> findByEmail(String email) throws SQLException;
}
