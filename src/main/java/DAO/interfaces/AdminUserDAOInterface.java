package DAO.interfaces;

import Model.AdminUser;

import java.sql.SQLException;
import java.util.Optional;

/**
 * Database access contract for {@link AdminUser} records.
 * <p>
 * The admin login flow only needs to look an admin up by email — there's no
 * admin self-registration, since admins are seeded by {@code Util.AdminSeeder}.
 *
 * @author SarkarSathi
 */
public interface AdminUserDAOInterface {
    /**
     * Looks up an admin by their login email.
     *
     * @param email the login email to search for
     * @return the matching admin if one exists, otherwise an empty Optional
     * @throws SQLException if the database query fails
     */
    Optional<AdminUser> findByEmail(String email) throws SQLException;
}
