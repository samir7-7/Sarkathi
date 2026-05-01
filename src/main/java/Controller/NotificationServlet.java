package Controller;

import DAO.NotificationDAO;
import Model.Notification;
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

@WebServlet(name = "notificationServlet", urlPatterns = "/api/notifications")
public class NotificationServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String citizenIdParam = request.getParameter("citizenId");
        if (citizenIdParam == null || citizenIdParam.isBlank()) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "citizenId is required");
            return;
        }
        try (Connection conn = DatabaseConnection.getConnection()) {
            int citizenId = Integer.parseInt(citizenIdParam);
            requireCitizenOwnership(request, citizenId);
            NotificationDAO dao = new NotificationDAO(conn);
            List<Notification> items = dao.findByCitizenId(citizenId);
            int unread = dao.countUnreadByCitizenId(citizenId);
            List<String> json = new ArrayList<>();
            for (Notification n : items) {
                json.add(toJson(n));
            }
            writeJson(response, HttpServletResponse.SC_OK,
                    "{\"unreadCount\":" + unread + ",\"notifications\":" + jsonArray(json) + "}");
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = getOptionalParameter(request, "action");
            if ("markRead".equalsIgnoreCase(action) || "markAll".equalsIgnoreCase(action)) {
                handleMarkRead(request, response);
                return;
            }
            requireAdmin(request);
            Notification n = new Notification();
            n.setCitizenId(Integer.parseInt(getRequiredParameter(request, "citizenId")));
            String appId = getOptionalParameter(request, "applicationId");
            n.setApplicationId(appId != null && !appId.isBlank() ? Integer.parseInt(appId) : 0);
            n.setMessage(getRequiredParameter(request, "message"));
            n.setRead(false);
            n.setCreatedAt(LocalDateTime.now());
            try (Connection conn = DatabaseConnection.getConnection()) {
                new NotificationDAO(conn).create(n);
                writeJson(response, HttpServletResponse.SC_CREATED, "{\"success\":true,\"notification\":" + toJson(n) + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private void handleMarkRead(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = getOptionalParameter(request, "redirectTo");
        try (Connection conn = DatabaseConnection.getConnection()) {
            NotificationDAO dao = new NotificationDAO(conn);
            String citizenIdParam = getRequiredParameter(request, "citizenId");
            int citizenId = Integer.parseInt(citizenIdParam);
            requireCitizenOwnership(request, citizenId);
            if ("markAll".equalsIgnoreCase(getOptionalParameter(request, "action"))) {
                dao.markAllAsRead(citizenId);
            } else {
                dao.markAsRead(Integer.parseInt(getRequiredParameter(request, "notificationId")));
            }
            if (redirectTo != null && !redirectTo.isBlank()) {
                response.sendRedirect(request.getContextPath() + redirectTo);
            } else {
                writeJson(response, HttpServletResponse.SC_OK, "{\"success\":true}");
            }
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            NotificationDAO dao = new NotificationDAO(conn);
            String notifId = getOptionalParameter(request, "notificationId");
            String citizenIdParam = getOptionalParameter(request, "citizenId");
            String markAll = getOptionalParameter(request, "markAll");

            if ("true".equalsIgnoreCase(markAll) && citizenIdParam != null) {
                int citizenId = Integer.parseInt(citizenIdParam);
                requireCitizenOwnership(request, citizenId);
                dao.markAllAsRead(citizenId);
                writeJson(response, HttpServletResponse.SC_OK, "{\"success\":true}");
            } else if (notifId != null) {
                if (citizenIdParam == null || citizenIdParam.isBlank()) {
                    writeError(response, HttpServletResponse.SC_BAD_REQUEST, "citizenId is required to mark a notification");
                    return;
                }
                requireCitizenOwnership(request, Integer.parseInt(citizenIdParam));
                boolean ok = dao.markAsRead(Integer.parseInt(notifId));
                writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND, "{\"success\":" + ok + "}");
            } else {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, "notificationId or markAll+citizenId required");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private String toJson(Notification n) {
        return "{\"notificationId\":" + n.getNotificationId()
                + ",\"citizenId\":" + n.getCitizenId()
                + ",\"applicationId\":" + n.getApplicationId()
                + ",\"message\":" + quote(n.getMessage())
                + ",\"read\":" + n.isRead()
                + ",\"createdAt\":" + quote(n.getCreatedAt() != null ? n.getCreatedAt().toString() : null) + "}";
    }
}
