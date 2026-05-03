package Controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Set;

/**
 * Path-based access control for the whole web app. Sits in front of every
 * request and decides one of three things:
 * <ul>
 *   <li>The path is on the public allow-list — let it through.</li>
 *   <li>The path requires authentication (or a specific role) — check the
 *       session, redirect to login or 403 if it's missing.</li>
 *   <li>Everything else falls through unchanged.</li>
 * </ul>
 * <p>
 * For API requests we return JSON errors instead of HTML redirects, which
 * keeps fetch-based callers happy. Static assets ({@code /css}, {@code /js},
 * {@code /images}) are always public.
 *
 * @author SarkarSathi
 */
@WebFilter(filterName = "authenticationFilter", urlPatterns = "/*")
public class AuthenticationFilter implements Filter {
    private static final Set<String> PUBLIC_PATHS = Set.of(
            "",
            "/",
            "/index.jsp",
            "/login",
            "/login.jsp",
            "/register",
            "/register.jsp",
            "/announcements",
            "/agriculture",
            "/budget",
            "/crop-advisory",
            "/track",
            "/logout",
            "/api/auth",
            "/api/crop-advisory",
            "/api/services",
            "/api/wards"
    );

    /**
     * No-op — the filter has no startup configuration.
     *
     * @param filterConfig unused
     */
    @Override
    public void init(FilterConfig filterConfig) {
        // No startup configuration required.
    }

    /**
     * The main gate. Classifies the request, then either lets it through,
     * redirects to login, or returns 403 — depending on what the path requires
     * and whether the session has the right role.
     *
     * @param servletRequest  the incoming request
     * @param servletResponse the response
     * @param chain           the rest of the filter chain
     * @throws IOException      if writing fails
     * @throws ServletException if downstream processing fails
     */
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String path = requestPath(request);

        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        String requiredRole = requiredRole(path);
        if (requiredRole == null && !requiresAuthenticatedUser(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        String currentRole = session == null ? null : String.valueOf(session.getAttribute("role"));

        if (currentRole == null || "null".equals(currentRole)) {
            handleUnauthenticated(request, response, path, requiredRole);
            return;
        }

        if (requiredRole != null && !requiredRole.equals(currentRole)) {
            handleForbidden(request, response);
            return;
        }

        chain.doFilter(request, response);
    }

    /**
     * No-op — the filter holds no resources that need releasing.
     */
    @Override
    public void destroy() {
        // Nothing to release.
    }

    /**
     * Strips the context path from the request URI so we can match against
     * application-relative paths regardless of how the app is deployed.
     *
     * @param request the incoming request
     * @return application-relative path (always starts with {@code /})
     */
    private String requestPath(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        if (contextPath != null && !contextPath.isBlank() && uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }
        return uri == null || uri.isBlank() ? "/" : uri;
    }

    /**
     * Is the given path on the public allow-list — exact match or one of the
     * shared static-asset prefixes?
     *
     * @param path application-relative path
     * @return true if no auth check is needed
     */
    private boolean isPublic(String path) {
        return PUBLIC_PATHS.contains(path)
                || path.startsWith("/api/auth/")
                || path.startsWith("/style/")
                || path.startsWith("/assets/")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || "/favicon.ico".equals(path);
    }

    /**
     * Returns the role a path requires, or {@code null} if the path doesn't
     * pin to a specific role (it may still need an authenticated user — see
     * {@link #requiresAuthenticatedUser(String)}).
     *
     * @param path application-relative path
     * @return {@code "admin"}, {@code "citizen"}, or {@code null}
     */
    private String requiredRole(String path) {
        if (path.startsWith("/admin") || path.startsWith("/api/admin")
                || "/api/analytics".equals(path)
                || "/api/dashboard".equals(path)
                || "/api/announcements".equals(path)
                || "/api/agriculture-notices".equals(path)
                || "/api/budgets".equals(path)) {
            return "admin";
        }
        if (path.startsWith("/citizen")) {
            return "citizen";
        }
        return null;
    }

    /**
     * Paths that need a logged-in user but don't care which role — citizens
     * and admins both reach these (e.g., uploaded files, shared certificate
     * APIs).
     *
     * @param path application-relative path
     * @return true if the path requires authentication of any role
     */
    private boolean requiresAuthenticatedUser(String path) {
        return path.startsWith("/uploads/")
                || path.startsWith("/api/applications")
                || path.startsWith("/api/certificates")
                || path.startsWith("/api/citizens")
                || path.startsWith("/api/notifications")
                || path.startsWith("/api/payments")
                || path.startsWith("/api/taxes")
                || path.startsWith("/api/upload");
    }

    /**
     * Handles the "no session" case. API callers get a JSON 401; browsers get
     * a redirect to login with a {@code next} parameter so we can bounce them
     * back to where they were trying to go.
     *
     * @param request      the incoming request
     * @param response     the response
     * @param path         application-relative path the user was reaching for
     * @param requiredRole the role the path requires (used to pick the login tab)
     * @throws IOException if writing fails
     */
    private void handleUnauthenticated(HttpServletRequest request, HttpServletResponse response,
                                       String path, String requiredRole) throws IOException {
        if (expectsJson(request)) {
            writeJsonError(response, HttpServletResponse.SC_UNAUTHORIZED,
                    "Please sign in before continuing.");
            return;
        }

        String userType = "admin".equals(requiredRole) ? "admin" : "citizen";
        String target = request.getContextPath() + "/login?userType=" + userType
                + "&next=" + URLEncoder.encode(pathWithQuery(request), StandardCharsets.UTF_8);
        response.sendRedirect(target);
    }

    /**
     * Handles "logged in but wrong role". JSON callers get a 403 message;
     * everyone else gets the standard 403 error page.
     *
     * @param request  the incoming request
     * @param response the response
     * @throws IOException if writing fails
     */
    private void handleForbidden(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (expectsJson(request)) {
            writeJsonError(response, HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to perform this action.");
            return;
        }
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
    }

    /**
     * Re-attaches the query string to the path so a post-login redirect lands
     * the user on the exact URL they originally tried to open.
     *
     * @param request the incoming request
     * @return path plus query string, or just path when no query was given
     */
    private String pathWithQuery(HttpServletRequest request) {
        String query = request.getQueryString();
        return query == null || query.isBlank() ? requestPath(request) : requestPath(request) + "?" + query;
    }

    /**
     * Heuristic for "is this an API/AJAX call?" so we can pick JSON vs HTML
     * for our auth errors. We require the path to be under {@code /api/} and
     * either an Accept header that includes JSON or the standard
     * {@code X-Requested-With} XHR header.
     *
     * @param request the incoming request
     * @return true if a JSON response is appropriate
     */
    private boolean expectsJson(HttpServletRequest request) {
        String path = requestPath(request);
        String accept = request.getHeader("Accept");
        String requestedWith = request.getHeader("X-Requested-With");
        return path.startsWith("/api/")
                && ((accept != null && accept.contains("application/json"))
                || "XMLHttpRequest".equalsIgnoreCase(requestedWith));
    }

    /**
     * Writes a small JSON error envelope to the response with the given
     * status code. Keeps the filter independent of {@code BaseApiServlet}.
     *
     * @param response the response
     * @param status   HTTP status code
     * @param message  human-readable error message
     * @throws IOException if writing fails
     */
    private void writeJsonError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}");
    }

    /**
     * Minimal JSON string escaper for the inline error writer above. Not a
     * full JSON encoder — handles the characters that actually show up in
     * our messages.
     *
     * @param value raw string
     * @return JSON-safe version of the string
     */
    private String escapeJson(String value) {
        return value == null ? "" : value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}
