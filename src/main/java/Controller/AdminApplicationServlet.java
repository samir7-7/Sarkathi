package Controller;

import DAO.ApplicationDAO;
import DAO.NotificationDAO;
import Model.Application;
import Model.Notification;
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
import java.util.Set;

@WebServlet(name = "adminApplicationServlet", urlPatterns = {"/api/admin/applications/review", "/api/admin/applications"})
public class AdminApplicationServlet extends BaseApiServlet {
    private static final Set<String> ALLOWED_STATUSES = Set.of("submitted", "review", "approved", "rejected");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        handleReview(request, response);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        handleReview(request, response);
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = getOptionalParameter(request, "redirectTo");
        try {
            requireAdmin(request);
            String status = getRequiredParameter(request, "status").toLowerCase();
            if (!ALLOWED_STATUSES.contains(status)) {
                throw new IllegalArgumentException("Invalid application status");
            }
            String remarks = getOptionalParameter(request, "remarks");

            String applicationIdParam = getOptionalParameter(request, "applicationId");
            String trackingId = getOptionalParameter(request, "trackingId");
            String adminIdParam = getOptionalParameter(request, "adminId");
            if (adminIdParam == null) {
                adminIdParam = getOptionalParameter(request, "reviewedByAdminId");
            }
            int adminId = Integer.parseInt(adminIdParam);
            Integer sessionAdminId = getSessionAdminId(request);
            if (sessionAdminId == null || sessionAdminId != adminId) {
                throw new SecurityException("Admin session does not match the requested reviewer");
            }

            try (Connection connection = DatabaseConnection.getConnection()) {
                ApplicationDAO applicationDAO = new ApplicationDAO(connection);
                boolean updated;
                Application application = null;

                if (applicationIdParam != null && !applicationIdParam.isBlank()) {
                    int applicationId = Integer.parseInt(applicationIdParam);
                    application = applicationDAO.findById(applicationId).orElse(null);
                    updated = applicationDAO.updateStatusById(applicationId, status, remarks, adminId);
                } else if (trackingId != null && !trackingId.isBlank()) {
                    application = applicationDAO.findByTrackingId(trackingId).orElse(null);
                    updated = applicationDAO.updateStatus(trackingId, status, remarks, adminId);
                } else {
                    redirectOrWriteError(request, response, redirectTo, "applicationId or trackingId is required",
                            HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                if (updated && application != null) {
                    Notification notification = new Notification();
                    notification.setCitizenId(application.getCitizenId());
                    notification.setApplicationId(application.getApplicationId());
                    notification.setMessage("Your application #" + application.getTrackingId() + " has been " + status
                            + (remarks == null || remarks.isBlank() ? "" : " - " + remarks));
                    notification.setRead(false);
                    notification.setCreatedAt(LocalDateTime.now());
                    new NotificationDAO(connection).create(notification);
                }

                redirectOrWriteJson(request, response, redirectTo,
                        updated ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                        "{\"success\":" + updated + ",\"status\":" + quote(status) + "}");
            }
        } catch (IllegalArgumentException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_BAD_REQUEST);
        } catch (SecurityException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_FORBIDDEN);
        } catch (SQLException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/admin/applications";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }
}
