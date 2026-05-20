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
 *
 * <p>All cookies created through this utility are:
 * <ul>
 *   <li>HttpOnly – not accessible via JavaScript</li>
 *   <li>Secure – only sent over HTTPS when the request itself is secure</li>
 *   <li>Scoped to the application's context path</li>
 *   <li>URL-encoded to safely handle special characters in values</li>
 * </ul>
 *
 * <p>This class is not instantiable; use its static methods directly.
 */
public final class CookieUtil {

    /**
     * Cookie name used to persist the user's email address for the
     * "Remember Me" feature across browser sessions.
     */
    public static final String REMEMBER_EMAIL_COOKIE = "sarkarsathi_remember_email";

    /**
     * Cookie name used to persist the user type (e.g., "admin", "citizen")
     * so the correct login form can be pre-selected on return visits.
     */
    public static final String REMEMBER_USER_TYPE_COOKIE = "sarkarsathi_remember_user_type";

    /**
     * Cookie name used as a boolean flag indicating whether the user
     * opted in to the "Remember Me" feature during their last login.
     */
    public static final String REMEMBER_FLAG_COOKIE = "sarkarsathi_remember_me";

    /**
     * Private constructor to prevent instantiation of this utility class.
     * All methods are static and should be accessed without creating an instance.
     */
    private CookieUtil() {
    }

    /**
     * Retrieves the value of a named cookie from the incoming HTTP request.
     *
     * <p>Returns {@link Optional#empty()} in any of the following cases:
     * <ul>
     *   <li>No cookies are present in the request</li>
     *   <li>The provided {@code name} is {@code null} or blank</li>
     *   <li>No cookie with the given name exists</li>
     *   <li>The matched cookie's value is {@code null} or blank</li>
     * </ul>
     *
     * @param request the current {@link HttpServletRequest}; must not be {@code null}
     * @param name    the name of the cookie to look up; blank or {@code null} returns empty
     * @return an {@link Optional} containing the cookie value if found and non-blank,
     *         or {@link Optional#empty()} otherwise
     */
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

    /**
     * Creates and adds a new cookie to the HTTP response with the given name,
     * value, and expiry duration.
     *
     * <p>The cookie value is URL-encoded before storage to safely handle spaces,
     * special characters, and non-ASCII input. If {@code value} is {@code null},
     * an empty string is stored instead.
     *
     * <p>Cookie attributes applied automatically:
     * <ul>
     *   <li>{@code HttpOnly} – prevents client-side script access</li>
     *   <li>{@code Secure} – sent only over HTTPS if the current request is secure</li>
     *   <li>{@code Path} – scoped to the application's context path (or {@code /})</li>
     * </ul>
     *
     * @param request       the current {@link HttpServletRequest}, used to derive
     *                      the secure flag and context path
     * @param response      the current {@link HttpServletResponse} to which the cookie is added
     * @param name          the name of the cookie; must be a valid cookie token
     * @param value         the value to store; {@code null} is treated as an empty string
     * @param maxAgeSeconds the lifetime of the cookie in seconds;
     *                      use {@code -1} for session-only, {@code 0} to delete
     */
    public static void addCookie(HttpServletRequest request, HttpServletResponse response,
            String name, String value, int maxAgeSeconds) {
        Cookie cookie = new Cookie(name, urlEncode(value == null ? "" : value));
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        cookie.setPath(cookiePath(request));
        cookie.setMaxAge(maxAgeSeconds);
        response.addCookie(cookie);
    }

    /**
     * Removes a cookie from the client by sending a replacement cookie with the
     * same name, an empty value, and a {@code Max-Age} of {@code 0}.
     *
     * <p>The path and security attributes are matched to the originals so the
     * browser correctly identifies and expires the existing cookie.
     *
     * @param request  the current {@link HttpServletRequest}, used to derive
     *                 the secure flag and context path
     * @param response the current {@link HttpServletResponse} to which the
     *                 expiry cookie is added
     * @param name     the name of the cookie to clear; must match the name
     *                 used when the cookie was originally set
     */
    public static void clearCookie(HttpServletRequest request, HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        cookie.setPath(cookiePath(request));
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }

    /**
     * Resolves the cookie path from the request's context path.
     *
     * <p>Falls back to {@code "/"} if the context path is absent or blank,
     * ensuring the cookie is accessible across the entire application.
     *
     * @param request the current {@link HttpServletRequest}
     * @return the context path if non-blank, otherwise {@code "/"}
     */
    private static String cookiePath(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        return contextPath == null || contextPath.isBlank() ? "/" : contextPath;
    }

    /**
     * URL-encodes a string using UTF-8 to ensure the cookie value contains
     * only characters permitted by the cookie specification.
     *
     * <p>Spaces are encoded as {@code +}, and special characters such as
     * {@code =}, {@code ;}, and {@code ,} are percent-encoded.
     *
     * @param value the raw string to encode; must not be {@code null}
     * @return the URL-encoded representation of {@code value}
     */
    private static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}