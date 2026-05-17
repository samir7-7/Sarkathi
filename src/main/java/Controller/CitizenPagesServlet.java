package Controller;

import DAO.impl.ApplicationDAO;
import DAO.impl.ApplicationDocumentDAO;
import DAO.impl.PaymentDAO;
import DAO.interfaces.ApplicationDocumentDAOInterface;
import DAO.interfaces.ApplicationDAOInterface;
import DAO.impl.CitizenDocumentVaultDAO;
import DAO.interfaces.CitizenDocumentVaultDAOInterface;
import DAO.impl.IssuedCertificateDAO;
import DAO.interfaces.IssuedCertificateDAOInterface;
import DAO.impl.NotificationDAO;
import DAO.interfaces.NotificationDAOInterface;
import DAO.impl.ServiceTypeDAO;
import DAO.impl.TaxRecordDAO;
import DAO.impl.WardDAO;
import Model.Application;
import Model.Notification;
import Model.Payment;
import Model.TaxRecord;
import Util.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * Page dispatcher for the citizen-facing area. Like {@link AdminPagesServlet}
 * but for citizen views — dashboard, apply, tracking, payments,
 * notifications, certificates, document vault — each path prefetches the
 * data its JSP needs.
 * <p>
 * Every page also gets the "shared" citizen data (notification counter,
 * application counters, certificate count) so the sidebar widgets work
 * regardless of which page the citizen is on.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "citizenPagesServlet", urlPatterns = {
    "/citizen/dashboard", "/citizen/apply", "/citizen/tracking",
    "/citizen/payments", "/citizen/notifications", "/citizen/certificates",
    "/citizen/documents"
})
public class CitizenPagesServlet extends HttpServlet {
    private static final String ESEWA_PRODUCT_CODE = "EPAYTEST";
    private static final String ESEWA_SECRET = "8gBm/:&EnhH.1/q";

    /**
     * Routes the citizen to the right view and pre-loads its data. Tracking
     * lookups are scoped to the logged-in citizen so people can't peek at
     * other citizens' applications by guessing tracking IDs.
     *
     * @param request  the incoming request
     * @param response the response (forward to JSP, or redirect to login)
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"citizen".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?userType=citizen");
            return;
        }

        request.setAttribute("citizenId", session.getAttribute("citizenId"));
        request.setAttribute("citizenName", session.getAttribute("fullName"));
        request.setAttribute("citizenEmail", session.getAttribute("email"));

        String path = request.getServletPath();
        Integer citizenId = (Integer) session.getAttribute("citizenId");
        try (Connection conn = DatabaseConnection.getConnection()) {
            loadSharedCitizenData(request, conn, citizenId);
            if ("/citizen/dashboard".equals(path) || "/citizen/tracking".equals(path)) {
                ApplicationDAOInterface applicationDAO = new ApplicationDAO(conn);
                request.setAttribute("applications", applicationDAO.findByCitizenId(citizenId));
                String trackingId = request.getParameter("trackingId");
                if (trackingId != null && !trackingId.isBlank()) {
                    Application application = applicationDAO.findByTrackingId(trackingId.trim()).orElse(null);
                    if (application != null && application.getCitizenId() == citizenId) {
                        request.setAttribute("trackingResult", application);
                    }
                    request.setAttribute("trackingSearched", true);
                }
            } else if ("/citizen/apply".equals(path)) {
                processEsewaCallback(request, conn, citizenId);
                request.setAttribute("serviceTypes", new ServiceTypeDAO(conn).findAll(true));
                request.setAttribute("wards", new WardDAO(conn).findAll());
                request.setAttribute("documents", new CitizenDocumentVaultDAO(conn).findByCitizenId(citizenId));
            } else if ("/citizen/payments".equals(path)) {
                processEsewaCallback(request, conn, citizenId);
                TaxRecordDAO taxRecordDAO = new TaxRecordDAO(conn);
                ensureCurrentFiscalYearTaxRecords(taxRecordDAO, citizenId);
                request.setAttribute("taxRecords", taxRecordDAO.findByCitizenId(citizenId));
            } else if ("/citizen/notifications".equals(path)) {
                request.setAttribute("notifications", new NotificationDAO(conn).findByCitizenId(citizenId));
            } else if ("/citizen/certificates".equals(path)) {
                request.setAttribute("certificates", new IssuedCertificateDAO(conn).findByCitizenId(citizenId));
            } else if ("/citizen/documents".equals(path)) {
                CitizenDocumentVaultDAOInterface vaultDAO = new CitizenDocumentVaultDAO(conn);
                ApplicationDocumentDAOInterface applicationDocumentDAO = new ApplicationDocumentDAO(conn);
                request.setAttribute("documents", vaultDAO.findByCitizenId(citizenId));
                request.setAttribute("applicationDocuments", applicationDocumentDAO.findByCitizenId(citizenId));
            }
        } catch (SQLException e) {
            request.setAttribute("pageError", "Unable to load page data.");
            request.setAttribute("applications", List.of());
            request.setAttribute("serviceTypes", List.of());
            request.setAttribute("wards", List.of());
            request.setAttribute("documents", List.of());
            request.setAttribute("applicationDocuments", List.of());
            request.setAttribute("taxRecords", List.of());
            request.setAttribute("notifications", List.of());
            request.setAttribute("certificates", List.of());
            request.setAttribute("unreadCount", 0);
        }

        String jsp = switch (path) {
            case "/citizen/dashboard" -> "/WEB-INF/citizen/dashboard.jsp";
            case "/citizen/apply" -> "/WEB-INF/citizen/apply.jsp";
            case "/citizen/tracking" -> "/WEB-INF/citizen/tracking.jsp";
            case "/citizen/payments" -> "/WEB-INF/citizen/payments.jsp";
            case "/citizen/notifications" -> "/WEB-INF/citizen/notifications.jsp";
            case "/citizen/certificates" -> "/WEB-INF/citizen/certificates.jsp";
            case "/citizen/documents" -> "/WEB-INF/citizen/documents.jsp";
            default -> "/WEB-INF/citizen/dashboard.jsp";
        };

        request.getRequestDispatcher(jsp).forward(request, response);
    }

    /**
     * Populates request attributes that every citizen page leans on:
     * notification list and unread count, application counters (total,
     * approved, pending), and certificate count. These feed sidebar badges
     * and dashboard widgets.
     *
     * @param request   the incoming request
     * @param conn      open JDBC connection
     * @param citizenId the logged-in citizen's primary key
     * @throws SQLException if a lookup fails
     */
    private void loadSharedCitizenData(HttpServletRequest request, Connection conn, int citizenId) throws SQLException {
        NotificationDAOInterface notificationDAO = new NotificationDAO(conn);
        List<Notification> notifications = notificationDAO.findByCitizenId(citizenId);
        ApplicationDAOInterface applicationDAO = new ApplicationDAO(conn);
        List<Application> applications = applicationDAO.findByCitizenId(citizenId);
        request.setAttribute("sharedNotifications", notifications);
        request.setAttribute("unreadCount", notificationDAO.countUnreadByCitizenId(citizenId));
        request.setAttribute("applicationCount", applications.size());
        request.setAttribute("approvedApplicationCount",
                applications.stream().filter(a -> "approved".equals(a.getStatus())).count());
        request.setAttribute("pendingApplicationCount",
                applications.stream().filter(a -> "submitted".equals(a.getStatus()) || "review".equals(a.getStatus())).count());
        IssuedCertificateDAOInterface certificateDAO = new IssuedCertificateDAO(conn);
        request.setAttribute("certificateCount", certificateDAO.findByCitizenId(citizenId).size());
    }

    private void processEsewaCallback(HttpServletRequest request, Connection conn, int citizenId) {
        String encodedData = request.getParameter("data");
        if (encodedData == null || encodedData.isBlank()) {
            String failure = request.getParameter("error");
            if (failure != null && !failure.isBlank()) {
                request.setAttribute("paymentCallbackState", "error");
                request.setAttribute("paymentCallbackMessage", failure);
            }
            return;
        }

        try {
            Map<String, String> payload = decodeEsewaPayload(encodedData);
            validateEsewaPayload(payload);

            String transactionUuid = payload.get("transaction_uuid");
            String taxType = taxTypeFromTransactionUuid(transactionUuid);
            if (taxType != null) {
                Integer taxId = taxIdFromTransactionUuid(transactionUuid);
                recordTaxEsewaPayment(request, conn, citizenId, payload, taxType, taxId);
                return;
            }
            Integer applicationId = applicationIdFromTransactionUuid(transactionUuid);
            if (applicationId != null) {
                recordApplicationEsewaPayment(request, conn, citizenId, payload, applicationId);
                return;
            }
            throw new IllegalArgumentException("Unknown eSewa transaction type");
        } catch (Exception e) {
            request.setAttribute("paymentCallbackState", "error");
            request.setAttribute("paymentCallbackMessage",
                    e.getMessage() == null || e.getMessage().isBlank()
                            ? "Unable to verify the eSewa payment callback."
                            : e.getMessage());
        }
    }

    private void recordTaxEsewaPayment(HttpServletRequest request, Connection conn, int citizenId,
                                       Map<String, String> payload, String taxType, Integer taxId) throws Exception {
        TaxRecordDAO taxRecordDAO = new TaxRecordDAO(conn);
        String fiscalYear = currentFiscalYear();
        TaxRecord existing = taxId != null
                ? taxRecordDAO.findById(taxId).orElse(null)
                : taxRecordDAO.findByCitizenTypeAndFiscalYear(citizenId, taxType, fiscalYear).orElse(null);
        if (existing != null && (existing.getCitizenId() != citizenId || !taxType.equals(existing.getTaxType()))) {
            throw new SecurityException("This tax record does not belong to the logged-in citizen.");
        }
        if (existing != null && existing.isPaid()) {
            request.setAttribute("paymentCallbackState", "success");
            request.setAttribute("paymentCallbackMessage",
                    "eSewa payment for " + taxType.toUpperCase() + " tax was already recorded.");
            return;
        }

        Payment payment = new Payment();
        payment.setApplicationId(0);
        payment.setAmount(new BigDecimal(payload.get("total_amount")));
        payment.setPaymentType(taxType.toLowerCase() + "tax");
        payment.setStatus("completed");
        payment.setPaidAt(LocalDateTime.now());

        PaymentDAO paymentDAO = new PaymentDAO(conn);
        boolean previousAutoCommit = conn.getAutoCommit();
        try {
            conn.setAutoCommit(false);
            Payment savedPayment = paymentDAO.create(payment);
            if (existing == null) {
                TaxRecord created = new TaxRecord();
                created.setCitizenId(citizenId);
                created.setTaxType(taxType);
                created.setFiscalYear(fiscalYear);
                created.setDueAmount(savedPayment.getAmount());
                created.setPaymentId(savedPayment.getPaymentId());
                created.setPaid(true);
                taxRecordDAO.create(created);
            } else {
                existing.setFiscalYear(fiscalYear);
                existing.setDueAmount(savedPayment.getAmount());
                existing.setPaymentId(savedPayment.getPaymentId());
                existing.setPaid(true);
                taxRecordDAO.update(existing);
            }
            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(previousAutoCommit);
        }

        request.setAttribute("paymentCallbackState", "success");
        request.setAttribute("paymentCallbackMessage",
                "eSewa payment recorded successfully for " + humanizeTaxType(taxType) + ".");
    }

    private void recordApplicationEsewaPayment(HttpServletRequest request, Connection conn, int citizenId,
                                               Map<String, String> payload, int applicationId) throws Exception {
        ApplicationDAO applicationDAO = new ApplicationDAO(conn);
        Application application = applicationDAO.findById(applicationId).orElse(null);
        if (application == null) {
            throw new IllegalArgumentException("Application not found for the eSewa callback.");
        }
        if (application.getCitizenId() != citizenId) {
            throw new SecurityException("This application does not belong to the logged-in citizen.");
        }

        PaymentDAO paymentDAO = new PaymentDAO(conn);
        boolean alreadyRecorded = paymentDAO.findByApplicationId(applicationId).stream()
                .anyMatch(payment -> "service".equalsIgnoreCase(payment.getPaymentType())
                        && "completed".equalsIgnoreCase(payment.getStatus()));
        if (alreadyRecorded) {
            request.setAttribute("paymentCallbackState", "success");
            request.setAttribute("paymentCallbackMessage",
                    "eSewa payment for application #" + application.getTrackingId() + " was already recorded.");
            return;
        }

        Payment payment = new Payment();
        payment.setApplicationId(applicationId);
        payment.setAmount(new BigDecimal(payload.get("total_amount")));
        payment.setPaymentType("service");
        payment.setStatus("completed");
        payment.setPaidAt(LocalDateTime.now());
        paymentDAO.create(payment);

        request.setAttribute("paymentCallbackState", "success");
        request.setAttribute("paymentCallbackMessage",
                "Application #" + application.getTrackingId() + " was submitted and paid successfully through eSewa.");
    }

    private Map<String, String> decodeEsewaPayload(String encodedData) {
        String json = new String(Base64.getDecoder().decode(encodedData), StandardCharsets.UTF_8);
        Map<String, String> payload = new LinkedHashMap<>();
        Pattern pattern = Pattern.compile("\"([^\"]+)\"\\s*:\\s*\"([^\"]*)\"");
        Matcher matcher = pattern.matcher(json);
        while (matcher.find()) {
            payload.put(matcher.group(1), matcher.group(2));
        }
        if (payload.isEmpty()) {
            throw new IllegalArgumentException("Empty eSewa callback payload");
        }
        return payload;
    }

    private void validateEsewaPayload(Map<String, String> payload) throws Exception {
        if (!"COMPLETE".equalsIgnoreCase(payload.get("status"))) {
            throw new IllegalArgumentException("eSewa payment was not completed.");
        }
        if (!ESEWA_PRODUCT_CODE.equals(payload.get("product_code"))) {
            throw new IllegalArgumentException("Unexpected eSewa product code.");
        }
        String signature = payload.get("signature");
        String signedFieldNames = payload.get("signed_field_names");
        if (signature == null || signedFieldNames == null) {
            throw new IllegalArgumentException("Missing eSewa verification fields.");
        }

        String signedMessage = buildSignedMessage(payload, signedFieldNames);
        String expectedSignature = hmacSha256Base64(signedMessage, ESEWA_SECRET);
        if (!expectedSignature.equals(signature)) {
            throw new IllegalArgumentException("Invalid eSewa callback signature.");
        }
    }

    private String buildSignedMessage(Map<String, String> payload, String signedFieldNames) {
        String[] names = signedFieldNames.split(",");
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < names.length; i++) {
            String name = names[i].trim();
            if (name.isEmpty()) {
                continue;
            }
            if (builder.length() > 0) {
                builder.append(",");
            }
            builder.append(name).append("=").append(payload.getOrDefault(name, ""));
        }
        return builder.toString();
    }

    private String hmacSha256Base64(String message, String secret) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] signature = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(signature);
    }

    private String taxTypeFromTransactionUuid(String transactionUuid) {
        if (transactionUuid == null) {
            return null;
        }
        Matcher matcher = Pattern.compile("^SARKAR-([A-Z]+)-TAX-").matcher(transactionUuid);
        if (!matcher.find()) {
            return null;
        }
        return matcher.group(1).toLowerCase();
    }

    private Integer applicationIdFromTransactionUuid(String transactionUuid) {
        if (transactionUuid == null) {
            return null;
        }
        Matcher matcher = Pattern.compile("^SARKAR-APP-(\\d+)-").matcher(transactionUuid);
        if (!matcher.find()) {
            return null;
        }
        return Integer.parseInt(matcher.group(1));
    }

    private Integer taxIdFromTransactionUuid(String transactionUuid) {
        if (transactionUuid == null) {
            return null;
        }
        Matcher matcher = Pattern.compile("^SARKAR-([A-Z]+)-TAX-(\\d+)-").matcher(transactionUuid);
        if (!matcher.find()) {
            return null;
        }
        return Integer.parseInt(matcher.group(2));
    }

    private String humanizeTaxType(String taxType) {
        if (taxType == null || taxType.isBlank()) {
            return "tax";
        }
        String normalized = taxType.trim().toLowerCase();
        return switch (normalized) {
            case "house" -> "House Tax";
            case "land" -> "Land Tax";
            case "business" -> "Business Tax";
            case "vehicle" -> "Vehicle Tax";
            case "sanitation" -> "Sanitation Fee";
            case "water" -> "Water Charge";
            case "rental" -> "Rental Tax";
            case "advertisement" -> "Advertisement Tax";
            case "solidwaste" -> "Solid Waste Fee";
            case "propertytransfer" -> "Property Transfer Tax";
            default -> Character.toUpperCase(normalized.charAt(0)) + normalized.substring(1) + " Tax";
        };
    }

    /**
     * Ensures the payments dashboard has current-year placeholder tax rows,
     * including extra municipal taxes beyond the original core set.
     *
     * @param taxRecordDAO tax DAO
     * @param citizenId    citizen id
     * @throws SQLException if a lookup or insert fails
     */
    private void ensureCurrentFiscalYearTaxRecords(TaxRecordDAO taxRecordDAO, int citizenId) throws SQLException {
        String fiscalYear = currentFiscalYear();
        ensureTaxRecordExists(taxRecordDAO, citizenId, "house", fiscalYear, new BigDecimal("5000"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "land", fiscalYear, new BigDecimal("3000"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "business", fiscalYear, new BigDecimal("2500"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "vehicle", fiscalYear, new BigDecimal("1800"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "sanitation", fiscalYear, new BigDecimal("1200"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "water", fiscalYear, new BigDecimal("900"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "rental", fiscalYear, new BigDecimal("2200"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "advertisement", fiscalYear, new BigDecimal("1500"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "solidwaste", fiscalYear, new BigDecimal("700"));
        ensureTaxRecordExists(taxRecordDAO, citizenId, "propertytransfer", fiscalYear, new BigDecimal("3500"));
    }

    /**
     * Creates a placeholder row when this citizen doesn't yet have the
     * requested tax type for the given fiscal year.
     *
     * @param taxRecordDAO tax DAO
     * @param citizenId    citizen id
     * @param taxType      tax type
     * @param fiscalYear   fiscal year
     * @param amount       placeholder amount
     * @throws SQLException if a lookup or insert fails
     */
    private void ensureTaxRecordExists(TaxRecordDAO taxRecordDAO, int citizenId, String taxType,
                                       String fiscalYear, BigDecimal amount) throws SQLException {
        if (taxRecordDAO.findByCitizenTypeAndFiscalYear(citizenId, taxType, fiscalYear).isPresent()) {
            return;
        }
        TaxRecord taxRecord = new TaxRecord();
        taxRecord.setCitizenId(citizenId);
        taxRecord.setTaxType(taxType);
        taxRecord.setFiscalYear(fiscalYear);
        taxRecord.setDueAmount(amount);
        taxRecord.setPaymentId(0);
        taxRecord.setPaid(false);
        taxRecordDAO.create(taxRecord);
    }

    private String currentFiscalYear() {
        LocalDate today = LocalDate.now();
        int startYear = today.getMonthValue() >= 7 ? today.getYear() : today.getYear() - 1;
        return startYear + "/" + String.valueOf(startYear + 1).substring(2);
    }
}
