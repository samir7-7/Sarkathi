package Controller;

import DAO.impl.WardDAO;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.Ward;

/**
 * Serves the list of wards as JSON. Used by drop-downs on the apply form
 * and on admin pages where the user picks a ward.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "wardServlet", urlPatterns = "/api/wards")
public class WardServlet extends BaseApiServlet {
    /**
     * Handles {@code GET /api/wards} — returns every ward as a JSON array.
     *
     * @param request  the incoming request (no parameters expected)
     * @param response JSON array of wards
     * @throws IOException if writing fails
     */
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
