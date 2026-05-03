package Controller;

import DAO.impl.IssuedCertificateDAO;
import Model.IssuedCertificate;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Issuance and rendering of approval certificates. Once an application is
 * approved, an admin can mint a certificate; citizens can then view a
 * printable HTML version or download a hand-rolled PDF.
 * <p>
 * The PDF is generated inline from a tiny PDF object graph rather than
 * pulling in a heavyweight library — good enough for the simple text-only
 * certificates we issue, and avoids a multi-megabyte dependency. If the
 * certificates ever need richer layout (logos, fonts, signatures) this is
 * the obvious place to swap in a real PDF library.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "certificateServlet", urlPatterns = "/api/certificates/*")
public class CertificateServlet extends BaseApiServlet {

    /**
     * Routes the GET to one of three modes based on the path:
     * <ul>
     *   <li>{@code /view/{appId}} — printable HTML certificate.</li>
     *   <li>{@code /download/{appId}} — PDF download.</li>
     *   <li>{@code /citizen/{citizenId}} — JSON list of the citizen's
     *       certificates.</li>
     * </ul>
     * Citizens may only access certificates they own.
     *
     * @param request  the incoming request
     * @param response HTML, PDF, or JSON depending on path
     * @throws IOException if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo() == null ? "" : request.getPathInfo();
        try (Connection conn = DatabaseConnection.getConnection()) {
            IssuedCertificateDAO certDAO = new IssuedCertificateDAO(conn);

            if (path.startsWith("/view/")) {
                int appId = Integer.parseInt(path.substring(6));
                CertificateData data = loadCertificateData(conn, appId);
                if (data == null) {
                    writeError(response, HttpServletResponse.SC_NOT_FOUND, "No certificate found");
                    return;
                }
                if (isCitizen(request)) {
                    requireCitizenOwnership(request, data.citizenId);
                }
                renderCertificate(request, response, conn, appId);
                return;
            }

            if (path.startsWith("/download/")) {
                int appId = Integer.parseInt(path.substring(10));
                CertificateData data = loadCertificateData(conn, appId);
                if (data == null) {
                    writeError(response, HttpServletResponse.SC_NOT_FOUND, "No certificate found");
                    return;
                }
                if (isCitizen(request)) {
                    requireCitizenOwnership(request, data.citizenId);
                }
                downloadCertificate(response, conn, appId);
                return;
            }

            if (path.startsWith("/citizen/")) {
                int citizenId = Integer.parseInt(path.substring(9));
                requireCitizenOwnership(request, citizenId);
                List<IssuedCertificate> certs = certDAO.findByCitizenId(citizenId);
                List<String> items = new ArrayList<>();
                for (IssuedCertificate c : certs) {
                    items.add(toCertJson(c));
                }
                writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
                return;
            }

            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Specify /citizen/{id}, /view/{appId}, or /download/{appId}");
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Issues a certificate for an approved application. Refuses to issue
     * twice for the same application, and refuses to issue against an
     * application that hasn't been approved yet.
     *
     * @param request  the incoming request
     * @param response redirect or JSON envelope with the issued certificate
     * @throws IOException if writing fails
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = getOptionalParameter(request, "redirectTo");
        try {
            requireAdmin(request);
            int applicationId = Integer.parseInt(getRequiredParameter(request, "applicationId"));
            int adminId = Integer.parseInt(getRequiredParameter(request, "adminId"));
            Integer sessionAdminId = getSessionAdminId(request);
            if (sessionAdminId == null || sessionAdminId != adminId) {
                throw new SecurityException("Admin session does not match the issuing admin");
            }

            try (Connection conn = DatabaseConnection.getConnection()) {
                CertificateData data = loadCertificateData(conn, applicationId);
                if (data == null) {
                    redirectOrWriteError(request, response, redirectTo, "Application not found", HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                if (!"approved".equals(data.status)) {
                    redirectOrWriteError(request, response, redirectTo, "Application must be approved first", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                IssuedCertificateDAO certDAO = new IssuedCertificateDAO(conn);
                if (certDAO.findByApplicationId(applicationId).isPresent()) {
                    redirectOrWriteError(request, response, redirectTo, "Certificate already issued", HttpServletResponse.SC_CONFLICT);
                    return;
                }

                IssuedCertificate cert = new IssuedCertificate();
                cert.setApplicationId(applicationId);
                cert.setCertificateNo("CERT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                cert.setIssuedAt(LocalDateTime.now());
                cert.setPdfFilePath("/api/certificates/download/" + applicationId);
                cert.setIssuedByAdminId(adminId);
                certDAO.create(cert);

                redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_CREATED,
                        "{\"success\":true,\"certificate\":" + toCertJson(cert) + "}");
            }
        } catch (SecurityException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_FORBIDDEN);
        } catch (Exception e) {
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
     * {@code /admin/applications}.
     *
     * @param request    the incoming request
     * @param redirectTo requested target
     * @param error      optional error to surface as a query parameter
     * @return absolute redirect URL
     */
    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/admin/applications";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    /**
     * Renders the printable HTML certificate. Inline CSS keeps the page
     * self-contained so it prints cleanly without external stylesheets, and
     * a {@code @media print} block hides the action bar when the user prints.
     *
     * @param request  the incoming request (for context path)
     * @param response the HTML response
     * @param conn     open JDBC connection
     * @param appId    application primary key
     * @throws IOException  if writing fails
     * @throws SQLException if the lookup fails
     */
    private void renderCertificate(HttpServletRequest request, HttpServletResponse response, Connection conn, int appId)
            throws IOException, SQLException {
        CertificateData data = loadCertificateData(conn, appId);
        if (data == null || data.certificate == null) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "No certificate found");
            return;
        }

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMMM yyyy, hh:mm a");
        try (PrintWriter w = response.getWriter()) {
            w.write("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Certificate " + data.certificate.getCertificateNo() + "</title>");
            w.write("<style>");
            w.write("*{margin:0;padding:0;box-sizing:border-box}body{font-family:Arial,sans-serif;background:#eef2f7;padding:32px;color:#0f172a}");
            w.write(".cert{max-width:880px;margin:0 auto;background:#fff;border:4px solid #0b3d86;padding:48px 54px;position:relative}");
            w.write(".cert:before{content:'';position:absolute;top:12px;left:12px;right:12px;bottom:12px;border:1px solid #94a3b8;pointer-events:none}");
            w.write(".header{text-align:center;padding-bottom:18px;border-bottom:2px solid #0b3d86;margin-bottom:26px}");
            w.write(".header h1{font-size:30px;color:#0b3d86}.header p{color:#475569;font-size:13px;margin-top:6px}");
            w.write(".badge{display:inline-block;margin-top:10px;padding:7px 18px;border-radius:999px;background:#0b3d86;color:#fff;font-size:12px;font-weight:bold}");
            w.write(".grid{display:grid;grid-template-columns:1fr 1fr;gap:14px 28px;margin-top:16px}");
            w.write(".field{padding:10px 0;border-bottom:1px solid #e2e8f0}.label{font-size:11px;text-transform:uppercase;color:#64748b;font-weight:bold;margin-bottom:4px}.value{font-size:15px;font-weight:600;color:#0f172a}");
            w.write(".full{grid-column:1 / -1}.remarks{margin-top:20px;padding:16px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px}");
            w.write(".footer{display:flex;justify-content:space-between;align-items:flex-end;margin-top:30px;padding-top:22px;border-top:2px solid #0b3d86;gap:24px}");
            w.write(".stamp-box{text-align:center;min-width:180px}.stamp-box img{max-height:110px;max-width:160px;object-fit:contain;display:block;margin:0 auto 8px}");
            w.write(".stamp{display:inline-block;border:3px solid #0b3d86;border-radius:50%;padding:16px 18px;color:#0b3d86;font-weight:700;font-size:13px;transform:rotate(-8deg)}");
            w.write(".sign p{font-size:13px;color:#334155;margin-top:5px}.meta{font-size:11px;color:#64748b;margin-top:10px}");
            w.write(".actions{max-width:880px;margin:18px auto 0;display:flex;gap:10px;justify-content:flex-end}");
            w.write(".actions a{display:inline-block;padding:12px 18px;border-radius:10px;text-decoration:none;font-size:13px;font-weight:700}.primary{background:#0b3d86;color:#fff}.secondary{background:#fff;color:#0b3d86;border:1px solid #cbd5e1}");
            w.write("@media print{body{background:#fff;padding:0}.cert{border:none;padding:30px}.cert:before,.actions{display:none}}");
            w.write("</style></head><body>");
            w.write("<div class='cert'>");
            w.write("<div class='header'><h1>" + safeHtml(data.municipalityName == null ? "SarkarSathi Municipality" : data.municipalityName) + "</h1>");
            w.write("<p>Official Municipal Service Certificate - " + safeHtml(data.wardLabel) + "</p>");
            w.write("<div class='badge'>" + safeHtml(data.serviceName) + "</div></div>");
            w.write("<p style='font-size:15px;line-height:1.7;color:#334155'>This certifies that the application below has been reviewed, approved, and digitally issued by the municipal authority.</p>");
            w.write("<div class='grid'>");
            writeField(w, "Certificate No.", data.certificate.getCertificateNo(), false);
            writeField(w, "Tracking ID", data.trackingId, false);
            writeField(w, "Citizen Name", data.citizenName, false);
            writeField(w, "Email", data.email, false);
            writeField(w, "Service Type", data.serviceName, false);
            writeField(w, "Ward", data.wardLabel, false);
            writeField(w, "Issued Date", data.certificate.getIssuedAt() == null ? "N/A" : data.certificate.getIssuedAt().format(fmt), false);
            writeField(w, "Approved By", data.approvedBy == null ? "Municipal Authority" : data.approvedBy, false);
            writeField(w, "Application Details", data.formData == null || data.formData.isBlank() ? "No additional data submitted" : data.formData, true);
            w.write("</div>");
            if (data.remarks != null && !data.remarks.isBlank()) {
                w.write("<div class='remarks'><div class='label'>Approval Remarks</div><div class='value' style='font-size:14px;font-weight:500'>"
                        + safeHtml(data.remarks) + "</div></div>");
            }
            w.write("<div class='footer'><div class='sign'><div class='label'>Issuing Authority</div>");
            w.write("<div class='value'>" + safeHtml(data.approvedBy == null ? "Municipal Authority" : data.approvedBy) + "</div>");
            w.write("<p>" + safeHtml(data.wardLabel) + "</p><p>" + safeHtml(data.municipalityName) + "</p>");
            w.write("<div class='meta'>Download PDF: " + safeHtml(request.getContextPath() + "/api/certificates/download/" + appId) + "</div></div>");
            w.write("<div class='stamp-box'>");
            if (data.wardStampImage != null && !data.wardStampImage.isBlank()) {
                String stampSrc = resolveStampPath(request.getContextPath(), data.wardStampImage);
                w.write("<img src='" + safeHtml(stampSrc) + "' alt='Ward stamp'>");
            } else {
                w.write("<div class='stamp'>WARD STAMP<br>APPROVED</div>");
            }
            w.write("<p class='meta'>Digitally verified record</p></div></div>");
            w.write("</div>");
            w.write("<div class='actions'><a class='secondary' href='" + request.getContextPath() + "/api/certificates/download/" + appId + "'>Download PDF</a>");
            w.write("<a class='primary' href='#' onclick='window.print();return false;'>Print Certificate</a></div>");
            w.write("</body></html>");
        }
    }

    /**
     * Streams the certificate as a downloadable PDF. Filename uses the
     * certificate number so users get something recognisable in their
     * downloads folder.
     *
     * @param response the response
     * @param conn     open JDBC connection
     * @param appId    application primary key
     * @throws IOException  if writing fails
     * @throws SQLException if the lookup fails
     */
    private void downloadCertificate(HttpServletResponse response, Connection conn, int appId) throws IOException, SQLException {
        CertificateData data = loadCertificateData(conn, appId);
        if (data == null || data.certificate == null) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "No certificate found");
            return;
        }

        byte[] pdfBytes = generateSimplePdf(data);
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + data.certificate.getCertificateNo() + ".pdf\"");
        response.setContentLength(pdfBytes.length);
        try (OutputStream outputStream = response.getOutputStream()) {
            outputStream.write(pdfBytes);
        }
    }

    /**
     * Pulls every piece of information the certificate needs in a single
     * join. Returns {@code null} when the application doesn't exist; the
     * certificate field on the result may itself be {@code null} when the
     * application is approved but no certificate has been issued yet (used
     * by the issue path to detect duplicates).
     *
     * @param conn  open JDBC connection
     * @param appId application primary key
     * @return populated DTO or {@code null} when the application is missing
     * @throws SQLException if the join query fails
     */
    private CertificateData loadCertificateData(Connection conn, int appId) throws SQLException {
        IssuedCertificateDAO certDAO = new IssuedCertificateDAO(conn);
        Optional<IssuedCertificate> certOpt = certDAO.findByApplicationId(appId);

        String sql = """
                SELECT a.ApplicationID, a.TrackingID, a.Status, a.FormData, a.Remarks,
                       c.CitizenID, c.FullName, c.Email,
                       st.ServiceName,
                       w.WardNumber, w.MunicipalityName, w.WardStampImage,
                       au.FullName AS ApprovedBy
                FROM APPLICATION a
                JOIN CITIZEN c ON a.CitizenID = c.CitizenID
                JOIN SERVICE_TYPE st ON a.ServiceTypeID = st.ServiceTypeID
                JOIN WARD w ON a.WardID = w.WardID
                LEFT JOIN ADMIN_USER au ON a.ReviewedByAdminID = au.AdminID
                WHERE a.ApplicationID = ?
                """;

        try (var s = conn.prepareStatement(sql)) {
            s.setInt(1, appId);
            try (var rs = s.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                CertificateData data = new CertificateData();
                data.certificate = certOpt.orElse(null);
                data.citizenId = rs.getInt("CitizenID");
                data.trackingId = rs.getString("TrackingID");
                data.status = rs.getString("Status");
                data.formData = prettifyFormData(rs.getString("FormData"));
                data.remarks = rs.getString("Remarks");
                data.citizenName = rs.getString("FullName");
                data.email = rs.getString("Email");
                data.serviceName = rs.getString("ServiceName");
                data.wardLabel = "Ward " + rs.getInt("WardNumber");
                data.municipalityName = rs.getString("MunicipalityName");
                if (data.municipalityName != null && !data.municipalityName.isBlank()) {
                    data.wardLabel += " - " + data.municipalityName;
                }
                data.wardStampImage = rs.getString("WardStampImage");
                data.approvedBy = rs.getString("ApprovedBy");
                return data;
            }
        }
    }

    /**
     * Resolves the ward stamp image path into something an {@code <img>} tag
     * can use. Absolute URLs pass through as-is; root-relative paths get the
     * context path prefixed; everything else is treated as relative to the
     * webapp root.
     *
     * @param contextPath    the webapp context path
     * @param wardStampImage stored stamp path/URL (may be null)
     * @return resolved {@code src} attribute
     */
    private String resolveStampPath(String contextPath, String wardStampImage) {
        if (wardStampImage == null || wardStampImage.isBlank()) {
            return "";
        }
        if (wardStampImage.startsWith("http://") || wardStampImage.startsWith("https://") || wardStampImage.startsWith("/")) {
            return wardStampImage.startsWith("/") ? contextPath + wardStampImage : wardStampImage;
        }
        return contextPath + "/" + wardStampImage;
    }

    /**
     * Emits one labelled field block in the HTML certificate grid.
     *
     * @param w         output writer
     * @param label     field label
     * @param value     field value (renders as "N/A" if null)
     * @param fullWidth true to span both columns of the grid
     */
    private void writeField(PrintWriter w, String label, String value, boolean fullWidth) {
        w.write("<div class='field" + (fullWidth ? " full" : "") + "'><div class='label'>" + safeHtml(label)
                + "</div><div class='value'>" + safeHtml(value == null ? "N/A" : value) + "</div></div>");
    }

    /**
     * Cheap pretty-printer for the JSON form data we store on applications —
     * strips braces/quotes and turns commas into newlines so the certificate
     * renders the answers as a small list rather than a JSON blob. Returns
     * an empty string when the data is empty or just an empty object.
     *
     * @param rawFormData raw stored form-data JSON
     * @return human-readable rendering
     */
    private String prettifyFormData(String rawFormData) {
        if (rawFormData == null || rawFormData.isBlank() || "{}".equals(rawFormData.trim())) {
            return "";
        }
        String prettified = rawFormData
                .replace("{", "")
                .replace("}", "")
                .replace("\"", "")
                .replace(",", "\n")
                .replace(":", ": ");
        return prettified.trim();
    }

    /**
     * Builds a minimal PDF from scratch — header, catalog, pages, font, and
     * a single text-content stream — so we don't need a PDF library on the
     * classpath. ASCII-only by design; non-ASCII characters get replaced
     * with question marks elsewhere in the pipeline.
     *
     * @param data certificate data
     * @return PDF byte array ready to write to the response
     */
    private byte[] generateSimplePdf(CertificateData data) {
        String issuedAt = data.certificate.getIssuedAt() == null
                ? "N/A"
                : data.certificate.getIssuedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy hh:mm a"));
        List<String> lines = List.of(
                data.municipalityName == null ? "SarkarSathi Municipality" : data.municipalityName,
                "Official Municipal Certificate",
                "",
                "Certificate No.: " + safePdf(data.certificate.getCertificateNo()),
                "Tracking ID: " + safePdf(data.trackingId),
                "Citizen Name: " + safePdf(data.citizenName),
                "Email: " + safePdf(data.email),
                "Service Type: " + safePdf(data.serviceName),
                "Ward: " + safePdf(data.wardLabel),
                "Issued Date: " + safePdf(issuedAt),
                "Approved By: " + safePdf(data.approvedBy == null ? "Municipal Authority" : data.approvedBy),
                "Remarks: " + safePdf(data.remarks == null || data.remarks.isBlank() ? "None" : data.remarks),
                "",
                "Application Details:",
                safePdf(data.formData == null || data.formData.isBlank() ? "No additional details provided." : data.formData),
                "",
                "Ward Stamp: " + safePdf(data.wardStampImage == null || data.wardStampImage.isBlank()
                        ? "Embedded on printable certificate view"
                        : data.wardStampImage)
        );

        StringBuilder content = new StringBuilder();
        content.append("BT\n");
        content.append("/F1 20 Tf\n");
        content.append("50 790 Td\n");
        for (int i = 0; i < lines.size(); i++) {
            String line = escapePdfText(lines.get(i));
            content.append("(").append(line).append(") Tj\n");
            if (i < lines.size() - 1) {
                content.append("0 -24 Td\n");
            }
        }
        content.append("ET");

        byte[] streamBytes = content.toString().getBytes(StandardCharsets.US_ASCII);
        String obj1 = "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n";
        String obj2 = "2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n";
        String obj3 = "3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 5 0 R /Resources << /Font << /F1 4 0 R >> >> >>\nendobj\n";
        String obj4 = "4 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n";
        String obj5Header = "5 0 obj\n<< /Length " + streamBytes.length + " >>\nstream\n";
        String obj5Footer = "\nendstream\nendobj\n";

        List<byte[]> pieces = new ArrayList<>();
        pieces.add("%PDF-1.4\n".getBytes(StandardCharsets.US_ASCII));
        pieces.add(obj1.getBytes(StandardCharsets.US_ASCII));
        pieces.add(obj2.getBytes(StandardCharsets.US_ASCII));
        pieces.add(obj3.getBytes(StandardCharsets.US_ASCII));
        pieces.add(obj4.getBytes(StandardCharsets.US_ASCII));
        pieces.add(obj5Header.getBytes(StandardCharsets.US_ASCII));
        pieces.add(streamBytes);
        pieces.add(obj5Footer.getBytes(StandardCharsets.US_ASCII));

        int[] offsets = new int[6];
        int cursor = 0;
        for (byte[] piece : pieces) {
            if (piece == pieces.get(1)) offsets[1] = cursor;
            if (piece == pieces.get(2)) offsets[2] = cursor;
            if (piece == pieces.get(3)) offsets[3] = cursor;
            if (piece == pieces.get(4)) offsets[4] = cursor;
            if (piece == pieces.get(5)) offsets[5] = cursor;
            cursor += piece.length;
        }

        StringBuilder pdf = new StringBuilder();
        pdf.append("%PDF-1.4\n");
        pdf.append(obj1).append(obj2).append(obj3).append(obj4).append(obj5Header);
        byte[] headerBytes = pdf.toString().getBytes(StandardCharsets.US_ASCII);
        byte[] footerBytes = obj5Footer.getBytes(StandardCharsets.US_ASCII);
        int xrefOffset = headerBytes.length + streamBytes.length + footerBytes.length;

        StringBuilder xref = new StringBuilder();
        xref.append("xref\n0 6\n");
        xref.append("0000000000 65535 f \n");
        xref.append(String.format("%010d 00000 n \n", "%PDF-1.4\n".getBytes(StandardCharsets.US_ASCII).length));
        int off2 = "%PDF-1.4\n".getBytes(StandardCharsets.US_ASCII).length + obj1.getBytes(StandardCharsets.US_ASCII).length;
        int off3 = off2 + obj2.getBytes(StandardCharsets.US_ASCII).length;
        int off4 = off3 + obj3.getBytes(StandardCharsets.US_ASCII).length;
        int off5 = off4 + obj4.getBytes(StandardCharsets.US_ASCII).length;
        xref.append(String.format("%010d 00000 n \n", off2));
        xref.append(String.format("%010d 00000 n \n", off3));
        xref.append(String.format("%010d 00000 n \n", off4));
        xref.append(String.format("%010d 00000 n \n", off5));
        xref.append("trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n");
        xref.append(xrefOffset).append("\n%%EOF");

        byte[] xrefBytes = xref.toString().getBytes(StandardCharsets.US_ASCII);
        byte[] out = new byte[headerBytes.length + streamBytes.length + footerBytes.length + xrefBytes.length];
        System.arraycopy(headerBytes, 0, out, 0, headerBytes.length);
        System.arraycopy(streamBytes, 0, out, headerBytes.length, streamBytes.length);
        System.arraycopy(footerBytes, 0, out, headerBytes.length + streamBytes.length, footerBytes.length);
        System.arraycopy(xrefBytes, 0, out, headerBytes.length + streamBytes.length + footerBytes.length, xrefBytes.length);
        return out;
    }

    /**
     * Escapes the characters that are special inside a PDF text string —
     * backslashes and parentheses.
     *
     * @param value raw text
     * @return PDF-safe text
     */
    private String escapePdfText(String value) {
        return safePdf(value).replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)");
    }

    /**
     * Strips non-printable / non-ASCII characters so they don't trip up our
     * minimal PDF generator. Replacement character is {@code ?}.
     *
     * @param value raw text
     * @return ASCII-clean text
     */
    private String safePdf(String value) {
        if (value == null) {
            return "";
        }
        return value.replaceAll("[^\\x20-\\x7E]", "?");
    }

    /**
     * HTML-escapes a value for injection into the certificate template.
     * Newlines become {@code <br>} so multi-line form data renders as
     * multiple lines.
     *
     * @param value raw text (may be null)
     * @return HTML-safe text
     */
    private String safeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;")
                .replace("\n", "<br>");
    }

    /**
     * Renders an issued certificate as a JSON object.
     *
     * @param c the certificate
     * @return JSON object literal
     */
    private String toCertJson(IssuedCertificate c) {
        return "{\"certificateId\":" + c.getCertificateId()
                + ",\"applicationId\":" + c.getApplicationId()
                + ",\"certificateNo\":" + quote(c.getCertificateNo())
                + ",\"issuedAt\":" + quote(c.getIssuedAt() != null ? c.getIssuedAt().toString() : null)
                + ",\"pdfFilePath\":" + quote(c.getPdfFilePath())
                + ",\"issuedByAdminId\":" + c.getIssuedByAdminId() + "}";
    }

    /**
     * Plain DTO that carries everything the certificate views need so we
     * only run the join query once per request.
     */
    private static class CertificateData {
        private int citizenId;
        private IssuedCertificate certificate;
        private String trackingId;
        private String status;
        private String formData;
        private String remarks;
        private String citizenName;
        private String email;
        private String serviceName;
        private String wardLabel;
        private String municipalityName;
        private String wardStampImage;
        private String approvedBy;
    }
}
