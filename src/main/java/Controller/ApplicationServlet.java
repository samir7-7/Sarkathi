package Controller;

import DAO.ApplicationDAO;
import Model.Application;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "applicationServlet", urlPatterns = "/api/applications/*")
public class ApplicationServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String trackingId = request.getParameter("trackingId");
        String citizenIdParam = request.getParameter("citizenId");

        try (Connection connection = DatabaseConnection.getConnection()) {
            ApplicationDAO applicationDAO = new ApplicationDAO(connection);

            if (trackingId != null && !trackingId.isBlank()) {
                Application application = applicationDAO.findByTrackingId(trackingId).orElse(null);
                writeJson(response, HttpServletResponse.SC_OK,
                        "{\"application\":" + (application == null ? "null" : toApplicationJson(application)) + "}");
                return;
            }

            if (citizenIdParam != null && !citizenIdParam.isBlank()) {
                writeJson(response, HttpServletResponse.SC_OK,
                        applicationsToJson(applicationDAO.findByCitizenId(Integer.parseInt(citizenIdParam))));
                return;
            }

            writeJson(response, HttpServletResponse.SC_OK, applicationsToJson(applicationDAO.findAll()));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Application application = new Application();
            application.setTrackingId("UDAS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            application.setCitizenId(Integer.parseInt(getRequiredParameter(request, "citizenId")));
            application.setServiceTypeId(Integer.parseInt(getRequiredParameter(request, "serviceTypeId")));
            application.setWardId(Integer.parseInt(getRequiredParameter(request, "wardId")));
            application.setStatus("submitted");
            application.setSubmittedAt(LocalDateTime.now());
            String formData = getOptionalParameter(request, "formData");
            application.setFormData(formData == null || formData.isBlank() ? "{}" : formData);
            application.setLastUpdatedAt(LocalDateTime.now());
            application.setRemarks(getOptionalParameter(request, "remarks"));
            application.setReviewedByAdminId(0);

            try (Connection connection = DatabaseConnection.getConnection()) {
                ApplicationDAO applicationDAO = new ApplicationDAO(connection);
                Application savedApplication = applicationDAO.create(application);
                writeJson(response, HttpServletResponse.SC_CREATED,
                        "{\"success\":true,\"application\":" + toApplicationJson(savedApplication) + "}");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private String applicationsToJson(List<Application> applications) {
        List<String> items = new ArrayList<>();
        for (Application application : applications) {
            items.add(toApplicationJson(application));
        }
        return jsonArray(items);
    }

    private String toApplicationJson(Application application) {
        return "{"
                + "\"applicationId\":" + application.getApplicationId() + ","
                + "\"trackingId\":" + quote(application.getTrackingId()) + ","
                + "\"citizenId\":" + application.getCitizenId() + ","
                + "\"serviceTypeId\":" + application.getServiceTypeId() + ","
                + "\"wardId\":" + application.getWardId() + ","
                + "\"status\":" + quote(application.getStatus()) + ","
                + "\"submittedAt\":" + quote(application.getSubmittedAt() == null ? null : application.getSubmittedAt().toString()) + ","
                + "\"formData\":" + quote(application.getFormData()) + ","
                + "\"lastUpdatedAt\":" + quote(application.getLastUpdatedAt() == null ? null : application.getLastUpdatedAt().toString()) + ","
                + "\"remarks\":" + quote(application.getRemarks()) + ","
                + "\"reviewedByAdminId\":" + application.getReviewedByAdminId()
                + "}";
    }
}
