package Controller;

import DAO.impl.PaymentDAO;
import DAO.impl.TaxRecordDAO;
import Model.Payment;
import Model.TaxRecord;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Payment recording endpoint. Payments are dual-purpose: application service
 * fees are charged against an application, while house and land taxes are
 * recorded against the citizen and create or update a {@code TaxRecord} row
 * in the same transaction.
 * <p>
 * The whole save runs inside a manual transaction so a half-committed payment
 * (without the matching tax-record update) can never leak into the database.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "paymentServlet", urlPatterns = "/api/payments")
public class PaymentServlet extends BaseApiServlet {
    /**
     * Lists payments for an application. Admin-only.
     *
     * @param request  the incoming request
     * @param response JSON array of payments
     * @throws IOException if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String applicationIdParam = request.getParameter("applicationId");
        if (applicationIdParam == null || applicationIdParam.isBlank()) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "applicationId is required");
            return;
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            requireAdmin(request);
            PaymentDAO paymentDAO = new PaymentDAO(connection);
            writeJson(response, HttpServletResponse.SC_OK,
                    paymentsToJson(paymentDAO.findByApplicationId(Integer.parseInt(applicationIdParam))));
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Records a payment, updating the matching tax record in the same
     * transaction when this payment is for a tax type. Citizens can pay their
     * own taxes; everything else (admin-driven payments, application fees)
     * runs through {@code requireAdmin}.
     *
     * @param request  the incoming request
     * @param response redirect or JSON envelope with the saved payment
     * @throws IOException if writing fails
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = getOptionalParameter(request, "redirectTo");
        try (Connection connection = DatabaseConnection.getConnection()) {
            Payment payment = new Payment();
            String applicationId = getOptionalParameter(request, "applicationId");
            payment.setApplicationId(applicationId == null || applicationId.isBlank() ? 0 : Integer.parseInt(applicationId));
            BigDecimal amount = new BigDecimal(getRequiredParameter(request, "amount"));
            if (amount.signum() <= 0) {
                throw new IllegalArgumentException("Amount must be greater than zero");
            }
            payment.setAmount(amount);
            payment.setPaymentType(getRequiredParameter(request, "paymentType"));
            String status = getOptionalParameter(request, "status");
            payment.setStatus(status == null || status.isBlank() ? "completed" : status);
            payment.setPaidAt(LocalDateTime.now());

            PaymentDAO paymentDAO = new PaymentDAO(connection);
            TaxRecordDAO taxRecordDAO = new TaxRecordDAO(connection);

            String citizenIdParam = getOptionalParameter(request, "citizenId");
            String normalizedTaxType = normalizeTaxType(payment.getPaymentType());
            if (citizenIdParam != null && normalizedTaxType != null) {
                requireCitizenOwnership(request, Integer.parseInt(citizenIdParam));
            } else {
                requireAdmin(request);
            }

            boolean previousAutoCommit = connection.getAutoCommit();
            try {
                connection.setAutoCommit(false);
                Payment savedPayment = paymentDAO.create(payment);
                TaxRecord taxRecord = handleTaxPayment(request, taxRecordDAO, savedPayment);
                connection.commit();

                redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_CREATED,
                        "{"
                                + "\"success\":true,"
                                + "\"payment\":" + toPaymentJson(savedPayment) + ","
                                + "\"taxRecord\":" + (taxRecord == null ? "null" : toTaxJson(taxRecord)) + ","
                                + "\"receiptNumber\":" + quote("RCPT-" + savedPayment.getPaymentId())
                                + "}");
            } catch (Exception e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(previousAutoCommit);
            }
        } catch (IllegalArgumentException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_BAD_REQUEST);
        } catch (SecurityException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_FORBIDDEN);
        } catch (SQLException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Form/JSON dual-mode success dispatcher.
     *
     * @param request    the incoming request
     * @param response   the response
     * @param redirectTo redirect target (may be null/blank)
     * @param statusCode HTTP status when writing JSON
     * @param json       JSON body when writing JSON
     * @throws IOException if writing fails
     */
    private void redirectOrWriteJson(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                     int statusCode, String json) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, null));
            return;
        }
        writeJson(response, statusCode, json);
    }

    /**
     * Form/JSON dual-mode error dispatcher.
     *
     * @param request    the incoming request
     * @param response   the response
     * @param redirectTo redirect target (may be null/blank)
     * @param message    error message
     * @param statusCode HTTP status when writing JSON
     * @throws IOException if writing fails
     */
    private void redirectOrWriteError(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                      String message, int statusCode) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, message));
            return;
        }
        writeError(response, statusCode, message);
    }

    /**
     * Builds a safe redirect URL. Untrusted targets fall back to
     * {@code /citizen/payments}.
     *
     * @param request    the incoming request
     * @param redirectTo requested target
     * @param error      optional error to surface as a query parameter
     * @return absolute redirect URL
     */
    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/citizen/payments";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    /**
     * If this payment looks like a tax payment, locate or create the matching
     * tax-record row and mark it paid. Returns {@code null} when the payment
     * isn't tax-related — the caller treats that as "nothing to do".
     *
     * @param request      the incoming request (may carry {@code taxId} or
     *                     {@code fiscalYear})
     * @param taxRecordDAO tax-record DAO
     * @param savedPayment the freshly-persisted payment
     * @return updated tax record, or {@code null}
     * @throws SQLException if any update fails
     */
    private TaxRecord handleTaxPayment(HttpServletRequest request, TaxRecordDAO taxRecordDAO, Payment savedPayment)
            throws SQLException {
        String citizenIdParam = getOptionalParameter(request, "citizenId");
        String normalizedTaxType = normalizeTaxType(savedPayment.getPaymentType());
        if (citizenIdParam == null || normalizedTaxType == null) {
            return null;
        }

        int citizenId = Integer.parseInt(citizenIdParam);
        String fiscalYear = getOptionalParameter(request, "fiscalYear");
        if (fiscalYear == null || fiscalYear.isBlank()) {
            fiscalYear = currentFiscalYear();
        }

        TaxRecord taxRecord;
        String taxIdParam = getOptionalParameter(request, "taxId");
        if (taxIdParam != null && !taxIdParam.isBlank()) {
            taxRecord = taxRecordDAO.findById(Integer.parseInt(taxIdParam)).orElse(null);
            if (taxRecord != null && (taxRecord.getCitizenId() != citizenId || !normalizedTaxType.equals(taxRecord.getTaxType()))) {
                throw new SecurityException("This tax record does not belong to the selected citizen");
            }
        } else {
            taxRecord = taxRecordDAO.findByCitizenTypeAndFiscalYear(citizenId, normalizedTaxType, fiscalYear).orElse(null);
        }

        if (taxRecord == null) {
            taxRecord = new TaxRecord();
            taxRecord.setCitizenId(citizenId);
            taxRecord.setTaxType(normalizedTaxType);
            taxRecord.setFiscalYear(fiscalYear);
            taxRecord.setDueAmount(savedPayment.getAmount());
            taxRecord.setPaymentId(savedPayment.getPaymentId());
            taxRecord.setPaid(true);
            return taxRecordDAO.create(taxRecord);
        }

        taxRecord.setFiscalYear(fiscalYear);
        taxRecord.setDueAmount(savedPayment.getAmount());
        taxRecord.setPaymentId(savedPayment.getPaymentId());
        taxRecord.setPaid(true);
        return taxRecordDAO.update(taxRecord);
    }

    /**
     * Maps the loose payment-type strings the form may send ({@code houseTax},
     * {@code house}, etc.) to the canonical tax types stored on the record.
     * Returns {@code null} for non-tax payment types.
     *
     * @param paymentType payment-type string from the request
     * @return canonical tax type, or {@code null}
     */
    private String normalizeTaxType(String paymentType) {
        if (paymentType == null) {
            return null;
        }
        return switch (paymentType.toLowerCase()) {
            case "housetax", "house" -> "house";
            case "landtax", "land" -> "land";
            default -> null;
        };
    }

    /**
     * Computes the current Nepali fiscal year label ({@code yyyy/yy}). The
     * fiscal year flips on July 1 — so July 2025 onwards is "2025/26", and
     * January 2026 still belongs to "2025/26".
     *
     * @return current fiscal-year label
     */
    private String currentFiscalYear() {
        LocalDate today = LocalDate.now();
        int startYear = today.getMonthValue() >= 7 ? today.getYear() : today.getYear() - 1;
        return startYear + "/" + String.valueOf(startYear + 1).substring(2);
    }

    /**
     * Renders a list of payments as a JSON array.
     *
     * @param payments payments to render
     * @return JSON array string
     */
    private String paymentsToJson(List<Payment> payments) {
        List<String> items = new ArrayList<>();
        for (Payment payment : payments) {
            items.add(toPaymentJson(payment));
        }
        return jsonArray(items);
    }

    /**
     * Renders a single payment as a JSON object.
     *
     * @param payment the payment
     * @return JSON object literal
     */
    private String toPaymentJson(Payment payment) {
        return "{"
                + "\"paymentId\":" + payment.getPaymentId() + ","
                + "\"applicationId\":" + payment.getApplicationId() + ","
                + "\"amount\":" + payment.getAmount() + ","
                + "\"paymentType\":" + quote(payment.getPaymentType()) + ","
                + "\"status\":" + quote(payment.getStatus()) + ","
                + "\"paidAt\":" + quote(payment.getPaidAt() == null ? null : payment.getPaidAt().toString())
                + "}";
    }

    /**
     * Renders a tax-record as a JSON object.
     *
     * @param taxRecord the tax record
     * @return JSON object literal
     */
    private String toTaxJson(TaxRecord taxRecord) {
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
