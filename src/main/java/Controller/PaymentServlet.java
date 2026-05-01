package Controller;

import DAO.PaymentDAO;
import DAO.TaxRecordDAO;
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

@WebServlet(name = "paymentServlet", urlPatterns = "/api/payments")
public class PaymentServlet extends BaseApiServlet {
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

    private void redirectOrWriteJson(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                     int statusCode, String json) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, null));
            return;
        }
        writeJson(response, statusCode, json);
    }

    private void redirectOrWriteError(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                      String message, int statusCode) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, message));
            return;
        }
        writeError(response, statusCode, message);
    }

    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/citizen/payments";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

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

    private String currentFiscalYear() {
        LocalDate today = LocalDate.now();
        int startYear = today.getMonthValue() >= 7 ? today.getYear() : today.getYear() - 1;
        return startYear + "/" + String.valueOf(startYear + 1).substring(2);
    }

    private String paymentsToJson(List<Payment> payments) {
        List<String> items = new ArrayList<>();
        for (Payment payment : payments) {
            items.add(toPaymentJson(payment));
        }
        return jsonArray(items);
    }

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
