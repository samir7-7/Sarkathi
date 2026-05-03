package Controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Shared base class for every JSON-returning servlet in the project.
 * <p>
 * It centralises three things that would otherwise be duplicated across all
 * the API endpoints:
 * <ul>
 *   <li><strong>JSON response writing</strong> — status code, content type,
 *       UTF-8 encoding, and a small set of helpers for hand-rolling JSON
 *       (this codebase doesn't use a JSON library).</li>
 *   <li><strong>Parameter parsing</strong> — including a workaround for the
 *       fact that {@code request.getParameter()} can't see body parameters
 *       once the request body has been read; we cache parsed body params on
 *       a request attribute.</li>
 *   <li><strong>Authorization helpers</strong> — session-based
 *       {@code requireAdmin}, {@code requireCitizenOwnership}, etc., that
 *       throw {@link SecurityException} when the caller isn't allowed.</li>
 * </ul>
 *
 * @author SarkarSathi
 */
public abstract class BaseApiServlet extends HttpServlet {
    private static final String FORM_BODY_PARAMS_ATTR = BaseApiServlet.class.getName() + ".formBodyParams";

    /**
     * Writes a JSON payload to the response with the given status code and
     * UTF-8 encoding.
     *
     * @param response   the servlet response
     * @param statusCode HTTP status to set
     * @param payload    pre-rendered JSON string
     * @throws IOException if writing fails
     */
    protected void writeJson(HttpServletResponse response, int statusCode, String payload) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter writer = response.getWriter()) {
            writer.write(payload);
        }
    }

    /**
     * Writes a standard error envelope:
     * {@code {"success":false,"message":"..."}} with the given status.
     *
     * @param response   the servlet response
     * @param statusCode HTTP status to set
     * @param message    human-readable error message (will be JSON-escaped)
     * @throws IOException if writing fails
     */
    protected void writeError(HttpServletResponse response, int statusCode, String message) throws IOException {
        writeJson(response, statusCode, "{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}");
    }

    /**
     * Reads a parameter that the caller is required to supply, throwing
     * {@link IllegalArgumentException} if it's missing or blank. Looks at
     * both query/form parameters and (when applicable) the request body.
     *
     * @param request       the incoming request
     * @param parameterName name of the parameter to read
     * @return the trimmed parameter value
     * @throws IllegalArgumentException if missing or blank
     */
    protected String getRequiredParameter(HttpServletRequest request, String parameterName) {
        String value = getOptionalParameter(request, parameterName);
        if (value == null || value.trim().isBlank()) {
            throw new IllegalArgumentException(parameterName + " is required");
        }
        return value.trim();
    }

    /**
     * Reads a parameter that may or may not be present. Falls back to
     * parsing the request body if the standard parameter map didn't have
     * it (see {@link #readFormBodyParameters(HttpServletRequest)} for why
     * that's needed).
     *
     * @param request       the incoming request
     * @param parameterName name of the parameter to read
     * @return the trimmed value, or {@code null} if not provided
     */
    protected String getOptionalParameter(HttpServletRequest request, String parameterName) {
        String value = request.getParameter(parameterName);
        if (value == null) {
            value = readFormBodyParameters(request).get(parameterName);
        }
        return value == null ? null : value.trim();
    }

    /**
     * Lazily parses the request body as
     * {@code application/x-www-form-urlencoded} and caches the result on a
     * request attribute. We need this because some clients (and our own
     * fetch calls from the JSP front-end) write parameters into the body
     * even on PUT/DELETE requests, and the servlet container doesn't always
     * expose those through {@code getParameter}.
     *
     * @param request the incoming request
     * @return a map of body parameters — empty if the body was unreadable
     *         or wasn't form-encoded
     */
    @SuppressWarnings("unchecked")
    private Map<String, String> readFormBodyParameters(HttpServletRequest request) {
        Object cached = request.getAttribute(FORM_BODY_PARAMS_ATTR);
        if (cached instanceof Map<?, ?>) {
            return (Map<String, String>) cached;
        }

        Map<String, String> parameters = new LinkedHashMap<>();
        String contentType = request.getContentType();
        if (contentType == null || !contentType.startsWith("application/x-www-form-urlencoded")) {
            request.setAttribute(FORM_BODY_PARAMS_ATTR, parameters);
            return parameters;
        }

        try {
            String body = request.getReader().lines().reduce("", (left, right) -> left + right);
            if (!body.isBlank()) {
                for (String pair : body.split("&")) {
                    if (pair.isBlank()) {
                        continue;
                    }
                    String[] parts = pair.split("=", 2);
                    String key = URLDecoder.decode(parts[0], StandardCharsets.UTF_8);
                    String value = parts.length > 1
                            ? URLDecoder.decode(parts[1], StandardCharsets.UTF_8)
                            : "";
                    parameters.putIfAbsent(key, value);
                }
            }
        } catch (IOException ignored) {
            // Fall back to regular request parameters if the body cannot be read.
        }

        request.setAttribute(FORM_BODY_PARAMS_ATTR, parameters);
        return parameters;
    }

    /**
     * Escapes a string for safe inclusion in a JSON literal — backslashes,
     * quotes, and the usual control characters.
     *
     * @param value the raw string, may be null
     * @return the escaped string, or empty when {@code value} is null
     */
    protected String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }

    /**
     * Renders a string as a JSON literal — quoted and escaped, or the
     * literal {@code null} if the value is null.
     *
     * @param value string to quote
     * @return JSON-ready quoted value
     */
    protected String quote(String value) {
        return value == null ? "null" : "\"" + escapeJson(value) + "\"";
    }

    /**
     * Joins a list of pre-rendered JSON values into an array literal.
     *
     * @param items already-formatted JSON strings
     * @return the JSON array source
     */
    protected String jsonArray(List<String> items) {
        return "[" + String.join(",", items) + "]";
    }

    /**
     * @param request the incoming request
     * @return the session role attribute as a string, or {@code null} if no
     *         session exists or the attribute isn't set
     */
    protected String getSessionRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object role = session == null ? null : session.getAttribute("role");
        return role == null ? null : role.toString();
    }

    /**
     * @param request the incoming request
     * @return the citizen id stored on the session, or {@code null} if not
     *         logged in as a citizen
     */
    protected Integer getSessionCitizenId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object citizenId = session == null ? null : session.getAttribute("citizenId");
        return citizenId instanceof Integer ? (Integer) citizenId : null;
    }

    /**
     * @param request the incoming request
     * @return the admin id stored on the session, or {@code null} if not
     *         logged in as an admin
     */
    protected Integer getSessionAdminId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object adminId = session == null ? null : session.getAttribute("adminId");
        return adminId instanceof Integer ? (Integer) adminId : null;
    }

    /**
     * @param request the incoming request
     * @return {@code true} if the session is an admin session
     */
    protected boolean isAdmin(HttpServletRequest request) {
        return "admin".equals(getSessionRole(request));
    }

    /**
     * @param request the incoming request
     * @return {@code true} if the session is a citizen session
     */
    protected boolean isCitizen(HttpServletRequest request) {
        return "citizen".equals(getSessionRole(request));
    }

    /**
     * Throws {@link SecurityException} if the caller isn't logged in as an
     * admin. The exception is converted into an HTTP 403 by the calling
     * servlet's normal error handling.
     *
     * @param request the incoming request
     */
    protected void requireAdmin(HttpServletRequest request) {
        if (!isAdmin(request)) {
            throw new SecurityException("Admin access is required");
        }
    }

    /**
     * Enforces that the caller is allowed to read or modify data belonging
     * to the given citizen. Admins can always pass; citizens can only pass
     * if their session citizen id matches the resource owner.
     *
     * @param request   the incoming request
     * @param citizenId id of the citizen whose data is being accessed
     * @throws SecurityException if the caller is neither the owning citizen
     *                           nor an admin
     */
    protected void requireCitizenOwnership(HttpServletRequest request, int citizenId) {
        if (isAdmin(request)) {
            return;
        }
        Integer sessionCitizenId = getSessionCitizenId(request);
        if (!isCitizen(request) || sessionCitizenId == null || sessionCitizenId != citizenId) {
            throw new SecurityException("You are not allowed to access this citizen record");
        }
    }
}