package Controller;

import DAO.NotificationDAO;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.Notification;

@WebServlet(name = "notificationServlet", urlPatterns = "/api/notifications")
public class NotificationServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String citizenIdParam = request.getParameter("citizenId");
        if (citizenIdParam == null || citizenIdParam.isBlank()) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "citizenId is required");
            return;
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            NotificationDAO notificationDAO = new NotificationDAO(connection);
            List<Notification> notifications = notificationDAO.findByCitizenId(Integer.parseInt(citizenIdParam));
            List<String> items = new ArrayList<>();
            for (Notification notification : notifications) {
                items.add("{"
                        + "\"notificationId\":" + notification.getNotificationId() + ","
                        + "\"citizenId\":" + notification.getCitizenId() + ","
                        + "\"applicationId\":" + notification.getApplicationId() + ","
                        + "\"message\":" + quote(notification.getMessage()) + ","
                        + "\"read\":" + notification.isRead() + ","
                        + "\"createdAt\":" + quote(notification.getCreatedAt() == null ? null : notification.getCreatedAt().toString())
                        + "}");
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
