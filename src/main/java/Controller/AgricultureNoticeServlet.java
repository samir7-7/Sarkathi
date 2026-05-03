package Controller;

import DAO.impl.AgricultureNoticeDAO;
import Model.AgricultureNotice;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD endpoint for agriculture notices — the seasonal advisories shown on
 * the public agriculture page and managed from the admin notices page. Reads
 * are public; writes require an admin session.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "agricultureNoticeServlet", urlPatterns = "/api/agriculture-notices")
public class AgricultureNoticeServlet extends BaseApiServlet {
    /**
     * Returns every agriculture notice as a JSON array.
     *
     * @param request  the incoming request
     * @param response JSON array of notices
     * @throws IOException if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            List<AgricultureNotice> items = new AgricultureNoticeDAO(conn).findAll();
            List<String> json = new ArrayList<>();
            for (AgricultureNotice n : items) {
                json.add(toJson(n));
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(json));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Creates a notice, or deletes one if {@code action=delete} is supplied.
     * Admin-only.
     *
     * @param request  the incoming request
     * @param response redirect or JSON envelope
     * @throws IOException if writing fails
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = getOptionalParameter(request, "redirectTo");
        try {
            requireAdmin(request);
            if ("delete".equalsIgnoreCase(getOptionalParameter(request, "action"))) {
                deleteNotice(request);
                redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_OK, "{\"success\":true}");
                return;
            }

            Integer adminId = getSessionAdminId(request);
            AgricultureNotice n = new AgricultureNotice();
            n.setPostedByAdminId(adminId == null ? Integer.parseInt(getRequiredParameter(request, "adminId")) : adminId);
            n.setTitle(getRequiredParameter(request, "title"));
            n.setContent(getRequiredParameter(request, "content"));
            n.setCategory(getRequiredParameter(request, "category"));
            n.setPublishedAt(LocalDateTime.now());
            try (Connection conn = DatabaseConnection.getConnection()) {
                new AgricultureNoticeDAO(conn).create(n);
                redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_CREATED,
                        "{\"success\":true,\"notice\":" + toJson(n) + "}");
            }
        } catch (SecurityException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_FORBIDDEN);
        } catch (IllegalArgumentException | SQLException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /**
     * Updates a notice in place. Admin-only.
     *
     * @param request  the incoming request
     * @param response JSON success envelope
     * @throws IOException if writing fails
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            requireAdmin(request);
            AgricultureNotice n = new AgricultureNotice();
            n.setNoticeId(Integer.parseInt(getRequiredParameter(request, "noticeId")));
            n.setTitle(getRequiredParameter(request, "title"));
            n.setContent(getRequiredParameter(request, "content"));
            n.setCategory(getRequiredParameter(request, "category"));
            try (Connection conn = DatabaseConnection.getConnection()) {
                boolean ok = new AgricultureNoticeDAO(conn).update(n);
                writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND, "{\"success\":" + ok + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    /**
     * Deletes a notice. Admin-only.
     *
     * @param request  the incoming request
     * @param response JSON success envelope
     * @throws IOException if writing fails
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            requireAdmin(request);
            boolean ok = deleteNotice(request);
            writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND, "{\"success\":" + ok + "}");
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    /**
     * Shared delete helper.
     *
     * @param request the incoming request
     * @return true if a row was deleted
     * @throws SQLException if the delete fails
     */
    private boolean deleteNotice(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(getRequiredParameter(request, "noticeId"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            return new AgricultureNoticeDAO(conn).delete(id);
        }
    }

    /**
     * Form/JSON dual-mode success dispatcher.
     *
     * @param request    the incoming request
     * @param response   the response
     * @param redirectTo redirect target (may be null/blank for JSON mode)
     * @param statusCode HTTP status when writing JSON
     * @param json       JSON body when writing JSON
     * @throws IOException if writing fails
     */
    private void redirectOrWriteJson(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                     int statusCode, String json) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, null));
            return;
        }
        writeJson(response, statusCode, json);
    }

    /**
     * Form/JSON dual-mode error dispatcher.
     *
     * @param request    the incoming request
     * @param response   the response
     * @param redirectTo redirect target (may be null/blank for JSON mode)
     * @param message    error message
     * @param statusCode HTTP status when writing JSON
     * @throws IOException if writing fails
     */
    private void redirectOrWriteError(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                      String message, int statusCode) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, message));
            return;
        }
        writeError(response, statusCode, message);
    }

    /**
     * Builds a safe redirect URL. Untrusted targets fall back to
     * {@code /admin/notices}.
     *
     * @param request    the incoming request
     * @param redirectTo requested target
     * @param error      optional error to surface as a query parameter
     * @return absolute redirect URL
     */
    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/admin/notices";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    /**
     * Renders a notice as a JSON object.
     *
     * @param n the notice
     * @return JSON object literal
     */
    private String toJson(AgricultureNotice n) {
        return "{\"noticeId\":" + n.getNoticeId()
                + ",\"postedByAdminId\":" + n.getPostedByAdminId()
                + ",\"title\":" + quote(n.getTitle())
                + ",\"content\":" + quote(n.getContent())
                + ",\"category\":" + quote(n.getCategory())
                + ",\"publishedAt\":" + quote(n.getPublishedAt() != null ? n.getPublishedAt().toString() : null) + "}";
    }
}
