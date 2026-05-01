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

    @Override
    public void init(FilterConfig filterConfig) {
        // No startup configuration required.
    }

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

    @Override
    public void destroy() {
        // Nothing to release.
    }

    private String requestPath(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        if (contextPath != null && !contextPath.isBlank() && uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }
        return uri == null || uri.isBlank() ? "/" : uri;
    }

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

    private void handleForbidden(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (expectsJson(request)) {
            writeJsonError(response, HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to perform this action.");
            return;
        }
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
    }

    private String pathWithQuery(HttpServletRequest request) {
        String query = request.getQueryString();
        return query == null || query.isBlank() ? requestPath(request) : requestPath(request) + "?" + query;
    }

    private boolean expectsJson(HttpServletRequest request) {
        String path = requestPath(request);
        String accept = request.getHeader("Accept");
        String requestedWith = request.getHeader("X-Requested-With");
        return path.startsWith("/api/")
                && ((accept != null && accept.contains("application/json"))
                || "XMLHttpRequest".equalsIgnoreCase(requestedWith));
    }

    private void writeJsonError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}");
    }

    private String escapeJson(String value) {
        return value == null ? "" : value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}
