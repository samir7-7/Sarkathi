package Controller;

import DAO.ApplicationDAO;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(name = "adminApplicationServlet", urlPatterns = "/api/admin/applications/review")
public class AdminApplicationServlet extends BaseApiServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String trackingId = getRequiredParameter(request, "trackingId");
            String status = getRequiredParameter(request, "status");
            String remarks = getOptionalParameter(request, "remarks");
            int reviewedByAdminId = Integer.parseInt(getRequiredParameter(request, "reviewedByAdminId"));

            try (Connection connection = DatabaseConnection.getConnection()) {
                ApplicationDAO applicationDAO = new ApplicationDAO(connection);
                boolean updated = applicationDAO.updateStatus(trackingId, status, remarks, reviewedByAdminId);
                writeJson(response,
                        updated ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                        "{"
                                + "\"success\":" + updated + ","
                                + "\"trackingId\":" + quote(trackingId) + ","
                                + "\"status\":" + quote(status)
                                + "}");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
