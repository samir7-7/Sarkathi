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
            boolean ok = deleteNotice(request);
            writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND, "{\"success\":" + ok + "}");
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private boolean deleteNotice(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(getRequiredParameter(request, "noticeId"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            return new AgricultureNoticeDAO(conn).delete(id);
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
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/admin/notices";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
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
