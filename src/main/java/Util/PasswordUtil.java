package Util;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtil {
    private PasswordUtil() {
    }

    public static String hash(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean matches(String rawPassword, String hashedPassword) {
        return hashedPassword != null && BCrypt.checkpw(rawPassword, hashedPassword);
    }
}
