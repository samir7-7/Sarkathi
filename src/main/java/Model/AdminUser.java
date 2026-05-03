package Model;

/**
 * Represents a municipal staff member who logs into the admin side of SarkarSathi.
 * <p>
 * Each admin belongs to a specific {@link Ward} and has a role such as
 * {@code officer} or {@code supervisor}, which the application uses to decide
 * what they're allowed to do (review applications, issue certificates, post
 * announcements, and so on). Passwords are stored as BCrypt hashes — never as
 * plaintext.
 *
 * @author SarkarSathi
 */
public class AdminUser {
    private int adminId;
    private int wardId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String role;

    /**
     * Creates an empty admin user. Useful when populating fields one at a time,
     * for example while reading a row out of a {@code ResultSet}.
     */
    public AdminUser() {
    }

    /**
     * Creates a fully-populated admin user.
     *
     * @param adminId      database primary key
     * @param wardId       ward this admin belongs to
     * @param fullName     admin's full name as shown in the UI
     * @param email        login email (unique across all admins)
     * @param passwordHash BCrypt hash of the password — never the plaintext
     * @param role         role string, typically {@code "officer"} or {@code "supervisor"}
     */
    public AdminUser(int adminId, int wardId, String fullName, String email, String passwordHash, String role) {
        this.adminId = adminId;
        this.wardId = wardId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
    }

    /**
     * @return this admin's database id
     */
    public int getAdminId() {
        return adminId;
    }

    /**
     * Sets the database id. Normally only the DAO layer should call this
     * (after an insert returns a generated key).
     *
     * @param adminId new admin id
     */
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    /**
     * @return id of the ward this admin is assigned to
     */
    public int getWardId() {
        return wardId;
    }

    /**
     * @param wardId new ward id for this admin
     */
    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    /**
     * @return the admin's full display name
     */
    public String getFullName() {
        return fullName;
    }

    /**
     * @param fullName the admin's full name
     */
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    /**
     * @return the admin's login email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email the admin's login email (must be unique)
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @return the BCrypt-hashed password
     */
    public String getPasswordHash() {
        return passwordHash;
    }

    /**
     * Stores the password hash. Callers are expected to pass a BCrypt hash —
     * never a plaintext password.
     *
     * @param passwordHash BCrypt hash to store
     */
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    /**
     * @return the role string (e.g. {@code "officer"}, {@code "supervisor"})
     */
    public String getRole() {
        return role;
    }

    /**
     * @param role the role string used for authorization checks
     */
    public void setRole(String role) {
        this.role = role;
    }
}
