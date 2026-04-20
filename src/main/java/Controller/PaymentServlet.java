package Controller;

import DAO.PaymentDAO;
import Model.Payment;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
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
            PaymentDAO paymentDAO = new PaymentDAO(connection);
            writeJson(response, HttpServletResponse.SC_OK,
                    paymentsToJson(paymentDAO.findByApplicationId(Integer.parseInt(applicationIdParam))));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Payment payment = new Payment();
            String applicationId = getOptionalParameter(request, "applicationId");
            payment.setApplicationId(applicationId == null || applicationId.isBlank() ? 0 : Integer.parseInt(applicationId));
            payment.setAmount(new BigDecimal(getRequiredParameter(request, "amount")));
            payment.setPaymentType(getRequiredParameter(request, "paymentType"));
            String status = getOptionalParameter(request, "status");
            payment.setStatus(status == null || status.isBlank() ? "completed" : status);
            payment.setPaidAt(LocalDateTime.now());

            try (Connection connection = DatabaseConnection.getConnection()) {
                PaymentDAO paymentDAO = new PaymentDAO(connection);
                Payment savedPayment = paymentDAO.create(payment);
                writeJson(response, HttpServletResponse.SC_CREATED,
                        "{"
                                + "\"success\":true,"
                                + "\"payment\":" + toPaymentJson(savedPayment) + ","
                                + "\"receiptNumber\":" + quote("RCPT-" + savedPayment.getPaymentId())
                                + "}");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
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
}
