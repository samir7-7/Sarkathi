package Controller;

import DAO.AnnouncementDAO;
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

@WebServlet(name = "announcementServlet", urlPatterns = "/api/announcements")
public class AnnouncementServlet extends BaseApiServlet {
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

    private boolean deleteAnnouncement(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(getRequiredParameter(request, "announcementId"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            return new AnnouncementDAO(conn).delete(id);
        }
    }

    private void redirectOrWriteJson(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                     int statusCode, String json) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, null));
            return;
        }
        writeJson(response, statusCode, json);
    }

    private void redirectOrWriteError(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                      String message, int statusCode) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, message));
            return;
        }
        writeError(response, statusCode, message);
    }

    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/admin/announcements";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    private String toJson(Announcement a) {
        return "{\"announcementId\":" + a.getAnnouncementId()
            + ",\"postedByAdminId\":" + a.getPostedByAdminId()
            + ",\"title\":" + quote(a.getTitle())
            + ",\"content\":" + quote(a.getContent())
            + ",\"eventDate\":" + quote(a.getEventDate() != null ? a.getEventDate().toString() : null)
            + ",\"publishedAt\":" + quote(a.getPublishedAt() != null ? a.getPublishedAt().toString() : null) + "}";
    }
}
