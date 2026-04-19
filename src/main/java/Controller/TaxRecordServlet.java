package Controller;

import DAO.TaxRecordDAO;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.TaxRecord;

@WebServlet(name = "taxRecordServlet", urlPatterns = "/api/taxes")
public class TaxRecordServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String citizenIdParam = request.getParameter("citizenId");
        if (citizenIdParam == null || citizenIdParam.isBlank()) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "citizenId is required");
            return;
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            TaxRecordDAO taxRecordDAO = new TaxRecordDAO(connection);
            List<TaxRecord> taxRecords = taxRecordDAO.findByCitizenId(Integer.parseInt(citizenIdParam));
            List<String> items = new ArrayList<>();
            for (TaxRecord taxRecord : taxRecords) {
                items.add("{"
                        + "\"taxId\":" + taxRecord.getTaxId() + ","
                        + "\"citizenId\":" + taxRecord.getCitizenId() + ","
                        + "\"taxType\":" + quote(taxRecord.getTaxType()) + ","
                        + "\"fiscalYear\":" + quote(taxRecord.getFiscalYear()) + ","
                        + "\"dueAmount\":" + taxRecord.getDueAmount() + ","
                        + "\"paymentId\":" + taxRecord.getPaymentId() + ","
                        + "\"paid\":" + taxRecord.isPaid()
                        + "}");
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
