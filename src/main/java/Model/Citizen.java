package Model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * A registered citizen — the people the platform actually serves.
 * <p>
 * Citizens log in with email and password, submit applications, pay taxes,
 * download issued certificates, and receive notifications. Like
 * {@link AdminUser}, the password is stored as a BCrypt hash.
 *
 * @author SarkarSathi
 */
public class Citizen {
    private int citizenId;
    private String fullName;
    private String email;
    private String phone;
    private String passwordHash;
    private LocalDate dateOfBirth;
    private String gender;
    private LocalDateTime createdAt;

    /**
     * Creates an empty citizen — typically used by DAO row mappers.
     */
    public Citizen() {
    }

    /**
     * Creates a fully-populated citizen.
     *
     * @param citizenId    database primary key
     * @param fullName     citizen's full legal name
     * @param email        login email (unique)
     * @param phone        contact phone number
     * @param passwordHash BCrypt hash — never plaintext
     * @param dateOfBirth  date of birth (used for age checks during registration)
     * @param gender       single-character code: {@code M}, {@code F}, or {@code O}
     * @param createdAt    timestamp the account was created
     */
    public Citizen(int citizenId, String fullName, String email, String phone, String passwordHash,
                   LocalDate dateOfBirth, String gender, LocalDateTime createdAt) {
        this.citizenId = citizenId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.passwordHash = passwordHash;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.createdAt = createdAt;
    }

    /** @return the citizen's database id */
    public int getCitizenId() {
        return citizenId;
    }

    /** @param citizenId new database id */
    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    /** @return the citizen's full legal name */
    public String getFullName() {
        return fullName;
    }

    /** @param fullName the citizen's full legal name */
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    /** @return login email */
    public String getEmail() {
        return email;
    }

    /** @param email login email (must be unique) */
    public void setEmail(String email) {
        this.email = email;
    }

    /** @return contact phone number */
    public String getPhone() {
        return phone;
    }

    /** @param phone contact phone number */
    public void setPhone(String phone) {
        this.phone = phone;
    }

    /** @return the BCrypt-hashed password */
    public String getPasswordHash() {
        return passwordHash;
    }

    /**
     * @param passwordHash BCrypt hash to store. Plain text passwords should
     *                     never be passed here.
     */
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    /** @return the citizen's date of birth */
    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    /** @param dateOfBirth the citizen's date of birth */
    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    /** @return single-character gender code ({@code M}, {@code F}, {@code O}) */
    public String getGender() {
        return gender;
    }

    /** @param gender single-character gender code */
    public void setGender(String gender) {
        this.gender = gender;
    }

    /** @return when the account was created */
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    /** @param createdAt account creation timestamp */
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
