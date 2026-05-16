package Util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Optional;

/**
 * Small helper for app cookies so servlet code doesn't repeat the same cookie
 * lookup and configuration logic everywhere.
 */
public final class CookieUtil {
    public static final String REMEMBER_EMAIL_COOKIE = "sarkarsathi_remember_email";
    public static final String REMEMBER_USER_TYPE_COOKIE = "sarkarsathi_remember_user_type";
    public static final String REMEMBER_FLAG_COOKIE = "sarkarsathi_remember_me";

    private CookieUtil() {
    }

    public static Optional<String> getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null || name == null || name.isBlank()) {
            return Optional.empty();
        }

        return Arrays.stream(cookies)
                .filter(cookie -> name.equals(cookie.getName()))
                .map(Cookie::getValue)
                .findFirst()
                .filter(value -> value != null && !value.isBlank());
    }

    public static void addCookie(HttpServletRequest request, HttpServletResponse response,
            String name, String value, int maxAgeSeconds) {
        Cookie cookie = new Cookie(name, urlEncode(value == null ? "" : value));
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        cookie.setPath(cookiePath(request));
        cookie.setMaxAge(maxAgeSeconds);
        response.addCookie(cookie);
    }

    public static void clearCookie(HttpServletRequest request, HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        cookie.setPath(cookiePath(request));
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }

    private static String cookiePath(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        return contextPath == null || contextPath.isBlank() ? "/" : contextPath;
    }

    private static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
