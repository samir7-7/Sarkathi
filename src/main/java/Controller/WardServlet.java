package Controller;

import DAO.WardDAO;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.Ward;

@WebServlet(name = "wardServlet", urlPatterns = "/api/wards")
public class WardServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            WardDAO wardDAO = new WardDAO(connection);
            List<Ward> wards = wardDAO.findAll();
            List<String> items = new ArrayList<>();
            for (Ward ward : wards) {
                items.add("{"
                        + "\"wardId\":" + ward.getWardId() + ","
                        + "\"wardNumber\":" + ward.getWardNumber() + ","
                        + "\"municipalityName\":" + quote(ward.getMunicipalityName()) + ","
                        + "\"province\":" + quote(ward.getProvince()) + ","
                        + "\"wardStampImage\":" + quote(ward.getWardStampImage())
                        + "}");
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
