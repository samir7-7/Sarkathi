package Controller;

import DAO.ApplicationDAO;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(name = "dashboardServlet", urlPatterns = "/api/dashboard")
public class DashboardServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            ApplicationDAO applicationDAO = new ApplicationDAO(connection);
            writeJson(response, HttpServletResponse.SC_OK,
                    "{"
                            + "\"totalApplications\":" + applicationDAO.countAll() + ","
                            + "\"submitted\":" + applicationDAO.countByStatus("submitted") + ","
                            + "\"review\":" + applicationDAO.countByStatus("review") + ","
                            + "\"approved\":" + applicationDAO.countByStatus("approved") + ","
                            + "\"rejected\":" + applicationDAO.countByStatus("rejected")
                            + "}");
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
