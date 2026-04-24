package Controller;

import DAO.AgricultureNoticeDAO;
import Model.AgricultureNotice;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "agricultureNoticeServlet", urlPatterns = "/api/agriculture-notices")
public class AgricultureNoticeServlet extends BaseApiServlet {
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            requireAdmin(request);
            Integer adminId = getSessionAdminId(request);
            AgricultureNotice n = new AgricultureNotice();
            n.setPostedByAdminId(adminId == null ? Integer.parseInt(getRequiredParameter(request, "adminId")) : adminId);
            n.setTitle(getRequiredParameter(request, "title"));
            n.setContent(getRequiredParameter(request, "content"));
            n.setCategory(getRequiredParameter(request, "category"));
            n.setPublishedAt(LocalDateTime.now());
            try (Connection conn = DatabaseConnection.getConnection()) {
                new AgricultureNoticeDAO(conn).create(n);
                writeJson(response, HttpServletResponse.SC_CREATED, "{\"success\":true,\"notice\":" + toJson(n) + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

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

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            requireAdmin(request);
            int id = Integer.parseInt(getRequiredParameter(request, "noticeId"));
            try (Connection conn = DatabaseConnection.getConnection()) {
                boolean ok = new AgricultureNoticeDAO(conn).delete(id);
                writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND, "{\"success\":" + ok + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private String toJson(AgricultureNotice n) {
        return "{\"noticeId\":" + n.getNoticeId()
                + ",\"postedByAdminId\":" + n.getPostedByAdminId()
                + ",\"title\":" + quote(n.getTitle())
                + ",\"content\":" + quote(n.getContent())
                + ",\"category\":" + quote(n.getCategory())
                + ",\"publishedAt\":" + quote(n.getPublishedAt() != null ? n.getPublishedAt().toString() : null) + "}";
    }
}