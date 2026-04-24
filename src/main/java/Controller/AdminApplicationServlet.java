package Controller;

import DAO.ApplicationDAO;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
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

                if (applicationIdParam != null && !applicationIdParam.isBlank()) {
                    updated = applicationDAO.updateStatusById(
                            Integer.parseInt(applicationIdParam), status, remarks, adminId);
                } else if (trackingId != null && !trackingId.isBlank()) {
                    updated = applicationDAO.updateStatus(trackingId, status, remarks, adminId);
                } else {
                    writeError(response, HttpServletResponse.SC_BAD_REQUEST, "applicationId or trackingId is required");
                    return;
                }

                writeJson(response,
                        updated ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                        "{\"success\":" + updated + ",\"status\":" + quote(status) + "}");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}