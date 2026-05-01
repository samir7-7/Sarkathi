package Controller;

import DAO.impl.TaxRecordDAO;
import Model.TaxRecord;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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
            int citizenId = Integer.parseInt(citizenIdParam);
            requireCitizenOwnership(request, citizenId);
            TaxRecordDAO taxRecordDAO = new TaxRecordDAO(connection);
            ensureCurrentFiscalYearRecords(taxRecordDAO, citizenId);

            List<TaxRecord> taxRecords = taxRecordDAO.findByCitizenId(citizenId);
            List<String> items = new ArrayList<>();
            for (TaxRecord taxRecord : taxRecords) {
                items.add(toJson(taxRecord));
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void ensureCurrentFiscalYearRecords(TaxRecordDAO taxRecordDAO, int citizenId) throws SQLException {
        String fiscalYear = currentFiscalYear();
        ensureRecordExists(taxRecordDAO, citizenId, "house", fiscalYear, new BigDecimal("5000"));
        ensureRecordExists(taxRecordDAO, citizenId, "land", fiscalYear, new BigDecimal("3000"));
    }

    private void ensureRecordExists(TaxRecordDAO taxRecordDAO, int citizenId, String taxType,
                                    String fiscalYear, BigDecimal dueAmount) throws SQLException {
        if (taxRecordDAO.findByCitizenTypeAndFiscalYear(citizenId, taxType, fiscalYear).isPresent()) {
            return;
        }

        TaxRecord taxRecord = new TaxRecord();
        taxRecord.setCitizenId(citizenId);
        taxRecord.setTaxType(taxType);
        taxRecord.setFiscalYear(fiscalYear);
        taxRecord.setDueAmount(dueAmount);
        taxRecord.setPaymentId(0);
        taxRecord.setPaid(false);
        taxRecordDAO.create(taxRecord);
    }

    private String currentFiscalYear() {
        LocalDate today = LocalDate.now();
        int startYear = today.getMonthValue() >= 7 ? today.getYear() : today.getYear() - 1;
        return startYear + "/" + String.valueOf(startYear + 1).substring(2);
    }

    private String toJson(TaxRecord taxRecord) {
        return "{"
                + "\"taxId\":" + taxRecord.getTaxId() + ","
                + "\"citizenId\":" + taxRecord.getCitizenId() + ","
                + "\"taxType\":" + quote(taxRecord.getTaxType()) + ","
                + "\"fiscalYear\":" + quote(taxRecord.getFiscalYear()) + ","
                + "\"dueAmount\":" + taxRecord.getDueAmount() + ","
                + "\"paymentId\":" + taxRecord.getPaymentId() + ","
                + "\"paid\":" + taxRecord.isPaid()
                + "}";
    }
}