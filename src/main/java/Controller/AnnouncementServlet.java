package Controller;

import DAO.impl.AnnouncementDAO;
import Model.Announcement;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD endpoint for municipal announcements. Reads are public; writes (create,
 * update, delete) require an admin session. The servlet intentionally accepts
 * "delete via POST with {@code action=delete}" alongside HTTP DELETE so plain
 * HTML forms can drive the admin page without JavaScript.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "announcementServlet", urlPatterns = "/api/announcements")
public class AnnouncementServlet extends BaseApiServlet {
    /**
     * Returns every announcement as a JSON array.
     *
     * @param request  the incoming request
     * @param response JSON array of announcements
     * @throws IOException if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            AnnouncementDAO dao = new AnnouncementDAO(conn);
            List<Announcement> items = dao.findAll();
            List<String> json = new ArrayList<>();
            for (Announcement a : items) {
                json.add(toJson(a));
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(json));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Creates a new announcement, or deletes an existing one if {@code
     * action=delete} is supplied. Authorship is taken from the admin session
     * if available; the form-supplied {@code adminId} is only a fallback.
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
                boolean ok = deleteAnnouncement(request);
                redirectOrWriteJson(request, response, redirectTo,
                        ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                        "{\"success\":" + ok + "}");
                return;
            }

            Integer adminId = getSessionAdminId(request);
            Announcement a = new Announcement();
            a.setPostedByAdminId(adminId == null ? Integer.parseInt(getRequiredParameter(request, "adminId")) : adminId);
            a.setTitle(getRequiredParameter(request, "title"));
            a.setContent(getRequiredParameter(request, "content"));
            String eventDate = getOptionalParameter(request, "eventDate");
            if (eventDate != null && !eventDate.isBlank()) {
                a.setEventDate(LocalDate.parse(eventDate));
            }
            a.setPublishedAt(LocalDateTime.now());
            try (Connection conn = DatabaseConnection.getConnection()) {
                new AnnouncementDAO(conn).create(a);
                redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_CREATED,
                        "{\"success\":true,\"announcement\":" + toJson(a) + "}");
            }
        } catch (SecurityException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_FORBIDDEN);
        } catch (Exception e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /**
     * Updates an existing announcement. Admin-only.
     *
     * @param request  the incoming request
     * @param response JSON success envelope, or 404 when the row doesn't exist
     * @throws IOException if writing fails
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            requireAdmin(request);
            Announcement a = new Announcement();
            a.setAnnouncementId(Integer.parseInt(getRequiredParameter(request, "announcementId")));
            a.setTitle(getRequiredParameter(request, "title"));
            a.setContent(getRequiredParameter(request, "content"));
            String eventDate = getOptionalParameter(request, "eventDate");
            if (eventDate != null && !eventDate.isBlank()) {
                a.setEventDate(LocalDate.parse(eventDate));
            }
            try (Connection conn = DatabaseConnection.getConnection()) {
                boolean ok = new AnnouncementDAO(conn).update(a);
                writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                    "{\"success\":" + ok + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    /**
     * Deletes an announcement. Admin-only.
     *
     * @param request  the incoming request
     * @param response JSON success envelope, or 404 when the row doesn't exist
     * @throws IOException if writing fails
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            requireAdmin(request);
            boolean ok = deleteAnnouncement(request);
            writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                "{\"success\":" + ok + "}");
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    /**
     * Shared delete helper used by both POST-with-action and DELETE handlers.
     *
     * @param request the incoming request
     * @return true if a row was deleted
     * @throws SQLException if the delete fails
     */
    private boolean deleteAnnouncement(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(getRequiredParameter(request, "announcementId"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            return new AnnouncementDAO(conn).delete(id);
        }
    }

    /**
     * Form/JSON dual-mode dispatcher for success paths.
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
     * Form/JSON dual-mode dispatcher for error paths.
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
     * Builds a safe redirect URL within this app's context. Untrusted targets
     * fall back to the announcements admin page.
     *
     * @param request    the incoming request
     * @param redirectTo requested redirect target
     * @param error      optional error to surface as a query parameter
     * @return absolute redirect URL
     */
    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/admin/announcements";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    /**
     * Renders an announcement as a JSON object.
     *
     * @param a the announcement
     * @return JSON object literal
     */
    private String toJson(Announcement a) {
        return "{\"announcementId\":" + a.getAnnouncementId()
            + ",\"postedByAdminId\":" + a.getPostedByAdminId()
            + ",\"title\":" + quote(a.getTitle())
            + ",\"content\":" + quote(a.getContent())
            + ",\"eventDate\":" + quote(a.getEventDate() != null ? a.getEventDate().toString() : null)
            + ",\"publishedAt\":" + quote(a.getPublishedAt() != null ? a.getPublishedAt().toString() : null) + "}";
    }
}
