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

/**
 * Read-only tax record endpoint for citizens. The first time a citizen hits
 * this in a given fiscal year we lazily seed the canonical house- and
 * land-tax rows for them so the payments page always has something to show.
 * <p>
 * Default amounts are hard-coded for now (5000 / 3000) — when the
 * municipality starts publishing real per-citizen amounts, this is the
 * place to read them from.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "taxRecordServlet", urlPatterns = "/api/taxes")
public class TaxRecordServlet extends BaseApiServlet {
    /**
     * Returns the citizen's tax records, seeding the current fiscal year's
     * placeholder rows if they don't exist yet.
     *
     * @param request  the incoming request
     * @param response JSON array of tax records
     * @throws IOException if writing fails
     */
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

    /**
     * Seeds the two standard tax records (house, land) for the current
     * fiscal year if they don't already exist for this citizen.
     *
     * @param taxRecordDAO tax DAO
     * @param citizenId    the citizen's primary key
     * @throws SQLException if a lookup or insert fails
     */
    private void ensureCurrentFiscalYearRecords(TaxRecordDAO taxRecordDAO, int citizenId) throws SQLException {
        String fiscalYear = currentFiscalYear();
        ensureRecordExists(taxRecordDAO, citizenId, "house", fiscalYear, new BigDecimal("5000"));
        ensureRecordExists(taxRecordDAO, citizenId, "land", fiscalYear, new BigDecimal("3000"));
    }

    /**
     * Inserts a placeholder tax record if one doesn't already exist for the
     * given (citizen, type, fiscal year) tuple. The new row is unpaid and
     * has no associated payment ID yet.
     *
     * @param taxRecordDAO tax DAO
     * @param citizenId    the citizen's primary key
     * @param taxType      canonical tax type
     * @param fiscalYear   fiscal-year label
     * @param dueAmount    placeholder due amount
     * @throws SQLException if the insert fails
     */
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

    /**
     * Computes the current fiscal-year label ({@code yyyy/yy}). Mirrors the
     * helper in {@link PaymentServlet} — kept local so this servlet has no
     * dependency on it.
     *
     * @return fiscal-year label like {@code 2025/26}
     */
    private String currentFiscalYear() {
        LocalDate today = LocalDate.now();
        int startYear = today.getMonthValue() >= 7 ? today.getYear() : today.getYear() - 1;
        return startYear + "/" + String.valueOf(startYear + 1).substring(2);
    }

    /**
     * Renders a tax record as a JSON object.
     *
     * @param taxRecord the tax record
     * @return JSON object literal
     */
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