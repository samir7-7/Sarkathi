package Controller;

import DAO.AnnouncementDAO;
import Model.Announcement;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
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
        try {
            requireAdmin(request);
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
                writeJson(response, HttpServletResponse.SC_CREATED, "{\"success\":true,\"announcement\":" + toJson(a) + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
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
            int id = Integer.parseInt(getRequiredParameter(request, "announcementId"));
            try (Connection conn = DatabaseConnection.getConnection()) {
                boolean ok = new AnnouncementDAO(conn).delete(id);
                writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                    "{\"success\":" + ok + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
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
