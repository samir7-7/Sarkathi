package Util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Thin wrapper around the jBCrypt library for hashing and verifying
 * passwords. Centralising it here means callers don't need to know the
 * specific algorithm, salt strategy, or library being used.
 *
 * @author SarkarSathi
 */
public final class PasswordUtil {
    /**
     * Private constructor — static utility class, never instantiated.
     */
    private PasswordUtil() {
    }

    /**
     * Generates a salted BCrypt hash of the given plaintext password.
     *
     * @param password the plaintext password to hash
     * @return the BCrypt hash, suitable for storing in {@code PasswordHash}
     *         columns
     */
    public static String hash(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    /**
     * Verifies a plaintext password against a stored hash.
     * <p>
     * If the stored value isn't a valid BCrypt hash (which happens with
     * some legacy seed data that was inserted in plaintext), we fall back
     * to a plain string-equals check rather than failing the login. That
     * keeps older data working but is also a known weak spot — once
     * everything has been re-saved through {@link #hash(String)} the
     * fallback can be removed.
     *
     * @param rawPassword    the plaintext password the user typed
     * @param hashedPassword the stored hash to compare against
     * @return {@code true} if the password matches, {@code false} otherwise
     *         (also {@code false} if either argument is null)
     */
    public static boolean matches(String rawPassword, String hashedPassword) {
        if (rawPassword == null || hashedPassword == null) {
            return false;
        }

        try {
            return BCrypt.checkpw(rawPassword, hashedPassword);
        } catch (IllegalArgumentException invalidHash) {
            // Gracefully handle legacy/plain-text records instead of failing the whole login.
            return rawPassword.equals(hashedPassword);
        }
    }
}
