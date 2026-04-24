package Controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public abstract class BaseApiServlet extends HttpServlet {
    private static final String FORM_BODY_PARAMS_ATTR = BaseApiServlet.class.getName() + ".formBodyParams";

    protected void writeJson(HttpServletResponse response, int statusCode, String payload) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter writer = response.getWriter()) {
            writer.write(payload);
        }
    }

    protected void writeError(HttpServletResponse response, int statusCode, String message) throws IOException {
        writeJson(response, statusCode, "{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}");
    }

    protected String getRequiredParameter(HttpServletRequest request, String parameterName) {
        String value = getOptionalParameter(request, parameterName);
        if (value == null || value.trim().isBlank()) {
            throw new IllegalArgumentException(parameterName + " is required");
        }
        return value.trim();
    }

    protected String getOptionalParameter(HttpServletRequest request, String parameterName) {
        String value = request.getParameter(parameterName);
        if (value == null) {
            value = readFormBodyParameters(request).get(parameterName);
        }
        return value == null ? null : value.trim();
    }

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

    protected String quote(String value) {
        return value == null ? "null" : "\"" + escapeJson(value) + "\"";
    }

    protected String jsonArray(List<String> items) {
        return "[" + String.join(",", items) + "]";
    }
}
