package Controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public abstract class BaseApiServlet extends HttpServlet {
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
        String value = request.getParameter(parameterName);
        if (value == null || value.trim().isBlank()) {
            throw new IllegalArgumentException(parameterName + " is required");
        }
        return value.trim();
    }

    protected String getOptionalParameter(HttpServletRequest request, String parameterName) {
        String value = request.getParameter(parameterName);
        return value == null ? null : value.trim();
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
