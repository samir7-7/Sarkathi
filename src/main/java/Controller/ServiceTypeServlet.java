package Controller;

import DAO.ServiceTypeDAO;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.ServiceType;

@WebServlet(name = "serviceTypeServlet", urlPatterns = "/api/services")
public class ServiceTypeServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean activeOnly = Boolean.parseBoolean(request.getParameter("activeOnly"));
        try (Connection connection = DatabaseConnection.getConnection()) {
            ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO(connection);
            List<ServiceType> serviceTypes = serviceTypeDAO.findAll(activeOnly);
            List<String> items = new ArrayList<>();
            for (ServiceType serviceType : serviceTypes) {
                items.add("{"
                        + "\"serviceTypeId\":" + serviceType.getServiceTypeId() + ","
                        + "\"serviceName\":" + quote(serviceType.getServiceName()) + ","
                        + "\"description\":" + quote(serviceType.getDescription()) + ","
                        + "\"baseFee\":" + serviceType.getBaseFee() + ","
                        + "\"active\":" + serviceType.isActive()
                        + "}");
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
