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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

/**
 * Issues and renders approved application certificates.
 *
 * <p>The printable HTML and PDF outputs are generated inline so the project
 * stays dependency-light. The certificate content is now service-specific,
 * with English layouts for the currently supported citizen services.</p>
 */
@WebServlet(name = "certificateServlet", urlPatterns = "/api/certificates/*")
public class CertificateServlet extends BaseApiServlet {

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

            writeError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Specify /citizen/{id}, /view/{appId}, or /download/{appId}");
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

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
                    redirectOrWriteError(request, response, redirectTo, "Application not found",
                            HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                if (!"approved".equals(data.status)) {
                    redirectOrWriteError(request, response, redirectTo, "Application must be approved first",
                            HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                IssuedCertificateDAO certDAO = new IssuedCertificateDAO(conn);
                if (certDAO.findByApplicationId(applicationId).isPresent()) {
                    redirectOrWriteError(request, response, redirectTo, "Certificate already issued",
                            HttpServletResponse.SC_CONFLICT);
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
            redirectOrWriteError(request, response, redirectTo, e.getMessage(),
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//")
                ? redirectTo
                : "/admin/applications";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    private void renderCertificate(HttpServletRequest request, HttpServletResponse response, Connection conn, int appId)
            throws IOException, SQLException {
        CertificateData data = loadCertificateData(conn, appId);
        if (data == null || data.certificate == null) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "No certificate found");
            return;
        }

        CertificateLayout layout = buildCertificateLayout(data);
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMMM yyyy, hh:mm a");

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter w = response.getWriter()) {
            w.write("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Certificate "
                    + safeHtml(data.certificate.getCertificateNo()) + "</title>");
            w.write("<style>");
            w.write("*{margin:0;padding:0;box-sizing:border-box}");
            w.write("body{font-family:Arial,sans-serif;background:#eef2f7;padding:32px;color:#0f172a}");
            w.write(".cert{max-width:920px;margin:0 auto;background:#fff;border:4px solid #0b3d86;padding:48px 54px;position:relative}");
            w.write(".cert:before{content:'';position:absolute;top:12px;left:12px;right:12px;bottom:12px;border:1px solid #94a3b8;pointer-events:none}");
            w.write(".header{text-align:center;padding-bottom:18px;border-bottom:2px solid #0b3d86;margin-bottom:24px}");
            w.write(".header h1{font-size:30px;color:#0b3d86}");
            w.write(".header p{color:#475569;font-size:13px;margin-top:6px}");
            w.write(".badge{display:inline-block;margin-top:10px;padding:7px 18px;border-radius:999px;background:#0b3d86;color:#fff;font-size:12px;font-weight:bold}");
            w.write(".intro{font-size:15px;line-height:1.7;color:#334155}");
            w.write(".summary{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-top:18px}");
            w.write(".summary-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:14px}");
            w.write(".grid{display:grid;grid-template-columns:1fr 1fr;gap:14px 28px;margin-top:18px}");
            w.write(".field{padding:10px 0;border-bottom:1px solid #e2e8f0}");
            w.write(".label{font-size:11px;text-transform:uppercase;color:#64748b;font-weight:bold;margin-bottom:4px}");
            w.write(".value{font-size:15px;font-weight:600;color:#0f172a;line-height:1.6}");
            w.write(".full{grid-column:1 / -1}");
            w.write(".remarks{margin-top:20px;padding:16px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px}");
            w.write(".footer{display:flex;justify-content:space-between;align-items:flex-end;margin-top:30px;padding-top:22px;border-top:2px solid #0b3d86;gap:24px}");
            w.write(".stamp-box{text-align:center;min-width:180px}");
            w.write(".stamp-box img{max-height:110px;max-width:160px;object-fit:contain;display:block;margin:0 auto 8px}");
            w.write(".stamp{display:inline-block;border:3px solid #0b3d86;border-radius:50%;padding:16px 18px;color:#0b3d86;font-weight:700;font-size:13px;transform:rotate(-8deg)}");
            w.write(".sign p{font-size:13px;color:#334155;margin-top:5px}");
            w.write(".meta{font-size:11px;color:#64748b;margin-top:10px}");
            w.write(".actions{max-width:920px;margin:18px auto 0;display:flex;gap:10px;justify-content:flex-end}");
            w.write(".actions a{display:inline-block;padding:12px 18px;border-radius:10px;text-decoration:none;font-size:13px;font-weight:700}");
            w.write(".primary{background:#0b3d86;color:#fff}.secondary{background:#fff;color:#0b3d86;border:1px solid #cbd5e1}");
            w.write("@media (max-width:700px){body{padding:16px}.cert{padding:30px 24px}.summary,.grid{grid-template-columns:1fr}.footer{flex-direction:column;align-items:flex-start}}");
            w.write("@media print{body{background:#fff;padding:0}.cert{border:none;padding:30px}.cert:before,.actions{display:none}}");
            w.write("</style></head><body>");

            w.write("<div class='cert'>");
            w.write("<div class='header'><h1>" + safeHtml(value(data.municipalityName, "SarkarSathi Municipality")) + "</h1>");
            w.write("<p>" + safeHtml(layout.subtitle) + "</p>");
            w.write("<div class='badge'>" + safeHtml(layout.title) + "</div></div>");
            w.write("<p class='intro'>" + safeHtml(layout.intro) + "</p>");

            w.write("<div class='summary'>");
            writeSummaryCard(w, "Certificate No.", data.certificate.getCertificateNo());
            writeSummaryCard(w, "Tracking ID", data.trackingId);
            writeSummaryCard(w, "Issued Date",
                    data.certificate.getIssuedAt() == null ? "N/A" : data.certificate.getIssuedAt().format(fmt));
            w.write("</div>");

            w.write("<div class='grid'>");
            for (CertificateField field : layout.fields) {
                writeField(w, field.label, field.value, field.fullWidth);
            }
            w.write("</div>");

            if (data.remarks != null && !data.remarks.isBlank()) {
                w.write("<div class='remarks'><div class='label'>Approval Remarks</div><div class='value'>"
                        + safeHtml(data.remarks) + "</div></div>");
            }

            w.write("<div class='footer'><div class='sign'><div class='label'>Issuing Authority</div>");
            w.write("<div class='value'>" + safeHtml(value(data.approvedBy, "Municipal Authority")) + "</div>");
            w.write("<p>" + safeHtml(layout.authorityLine) + "</p>");
            w.write("<p>" + safeHtml(value(data.municipalityName, "SarkarSathi Municipality")) + "</p>");
            w.write("<div class='meta'>Download PDF: "
                    + safeHtml(request.getContextPath() + "/api/certificates/download/" + appId)
                    + "</div></div>");
            w.write("<div class='stamp-box'>");
            if (data.wardStampImage != null && !data.wardStampImage.isBlank()) {
                String stampSrc = resolveStampPath(request.getContextPath(), data.wardStampImage);
                w.write("<img src='" + safeHtml(stampSrc) + "' alt='Ward stamp'>");
            } else {
                w.write("<div class='stamp'>WARD STAMP<br>APPROVED</div>");
            }
            w.write("<p class='meta'>Digitally verified record</p></div></div>");
            w.write("</div>");
            w.write("<div class='actions'><a class='secondary' href='" + request.getContextPath()
                    + "/api/certificates/download/" + appId + "'>Download PDF</a>");
            w.write("<a class='primary' href='#' onclick='window.print();return false;'>Print Certificate</a></div>");
            w.write("</body></html>");
        }
    }

    private void downloadCertificate(HttpServletResponse response, Connection conn, int appId)
            throws IOException, SQLException {
        CertificateData data = loadCertificateData(conn, appId);
        if (data == null || data.certificate == null) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "No certificate found");
            return;
        }

        byte[] pdfBytes = generateSimplePdf(data);
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + data.certificate.getCertificateNo() + ".pdf\"");
        response.setContentLength(pdfBytes.length);
        try (OutputStream outputStream = response.getOutputStream()) {
            outputStream.write(pdfBytes);
        }
    }

    private CertificateData loadCertificateData(Connection conn, int appId) throws SQLException {
        IssuedCertificateDAO certDAO = new IssuedCertificateDAO(conn);
        Optional<IssuedCertificate> certOpt = certDAO.findByApplicationId(appId);

        String sql = """
                SELECT a.ApplicationID, a.TrackingID, a.Status, a.FormData, a.Remarks,
                       c.CitizenID, c.FullName, c.Email,
                       st.ServiceName,
                       w.WardNumber, w.MunicipalityName, w.Province, w.WardStampImage,
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
                data.formDataRaw = rs.getString("FormData");
                data.formFields = parseFormData(data.formDataRaw);
                data.remarks = rs.getString("Remarks");
                data.citizenName = rs.getString("FullName");
                data.email = rs.getString("Email");
                data.serviceName = rs.getString("ServiceName");
                data.municipalityName = rs.getString("MunicipalityName");
                data.provinceName = rs.getString("Province");
                data.wardLabel = "Ward " + rs.getInt("WardNumber");
                if (data.municipalityName != null && !data.municipalityName.isBlank()) {
                    data.wardLabel += " - " + data.municipalityName;
                }
                data.wardStampImage = rs.getString("WardStampImage");
                data.approvedBy = rs.getString("ApprovedBy");
                return data;
            }
        }
    }

    private String resolveStampPath(String contextPath, String wardStampImage) {
        if (wardStampImage == null || wardStampImage.isBlank()) {
            return "";
        }
        if (wardStampImage.startsWith("http://") || wardStampImage.startsWith("https://")
                || wardStampImage.startsWith("/")) {
            return wardStampImage.startsWith("/") ? contextPath + wardStampImage : wardStampImage;
        }
        return contextPath + "/" + wardStampImage;
    }

    private void writeSummaryCard(PrintWriter w, String label, String value) {
        w.write("<div class='summary-card'><div class='label'>" + safeHtml(label)
                + "</div><div class='value'>" + safeHtml(value(value, "N/A")) + "</div></div>");
    }

    private void writeField(PrintWriter w, String label, String value, boolean fullWidth) {
        w.write("<div class='field" + (fullWidth ? " full" : "") + "'><div class='label'>" + safeHtml(label)
                + "</div><div class='value'>" + safeHtml(value(value, "N/A")) + "</div></div>");
    }

    private Map<String, String> parseFormData(String rawFormData) {
        Map<String, String> fields = new LinkedHashMap<>();
        if (rawFormData == null || rawFormData.isBlank()) {
            return fields;
        }

        String raw = rawFormData.trim();
        if ("{}".equals(raw)) {
            return fields;
        }
        if (raw.startsWith("{")) {
            raw = raw.substring(1);
        }
        if (raw.endsWith("}")) {
            raw = raw.substring(0, raw.length() - 1);
        }

        List<String> pairs = splitJsonTopLevel(raw, ',');
        for (String pair : pairs) {
            List<String> parts = splitJsonTopLevel(pair, ':');
            if (parts.size() < 2) {
                continue;
            }
            String key = unquoteJson(parts.get(0).trim());
            String value = unquoteJson(joinTail(parts, 1, ":").trim());
            if (!key.isBlank()) {
                fields.put(key, value);
            }
        }
        return fields;
    }

    private List<String> splitJsonTopLevel(String input, char separator) {
        List<String> parts = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;
        boolean escaped = false;
        for (int i = 0; i < input.length(); i++) {
            char ch = input.charAt(i);
            if (escaped) {
                current.append(ch);
                escaped = false;
                continue;
            }
            if (ch == '\\') {
                current.append(ch);
                escaped = true;
                continue;
            }
            if (ch == '"') {
                inQuotes = !inQuotes;
                current.append(ch);
                continue;
            }
            if (ch == separator && !inQuotes) {
                parts.add(current.toString());
                current.setLength(0);
                continue;
            }
            current.append(ch);
        }
        if (!current.isEmpty()) {
            parts.add(current.toString());
        }
        return parts;
    }

    private String joinTail(List<String> parts, int start, String glue) {
        StringBuilder out = new StringBuilder();
        for (int i = start; i < parts.size(); i++) {
            if (i > start) {
                out.append(glue);
            }
            out.append(parts.get(i));
        }
        return out.toString();
    }

    private String unquoteJson(String value) {
        String cleaned = value;
        if (cleaned.startsWith("\"") && cleaned.endsWith("\"") && cleaned.length() >= 2) {
            cleaned = cleaned.substring(1, cleaned.length() - 1);
        }
        return cleaned.replace("\\\"", "\"")
                .replace("\\n", "\n")
                .replace("\\r", "")
                .replace("\\t", " ")
                .replace("\\\\", "\\");
    }

    private CertificateLayout buildCertificateLayout(CertificateData data) {
        CertificateLayout layout = new CertificateLayout();
        Map<String, String> f = data.formFields == null ? Map.of() : data.formFields;
        String serviceName = value(data.serviceName, "Municipal Certificate");

        layout.title = serviceName;
        layout.subtitle = "Official Municipal Record - " + value(data.wardLabel, "Ward");
        layout.authorityLine = value(data.wardLabel, "Ward Office");
        layout.intro = "This document certifies that the approved municipal record below has been officially issued.";

        if ("Birth Certificate".equalsIgnoreCase(serviceName)) {
            layout.title = "Birth Registration Certificate";
            layout.intro = "This is to certify that the following birth has been officially registered by the local registrar.";
            addField(layout, "Child Full Name", firstNonBlank(f.get("childFullName"), data.citizenName), false);
            addField(layout, "Date of Birth", f.get("dateOfBirth"), false);
            addField(layout, "Time of Birth", f.get("timeOfBirth"), false);
            addField(layout, "Gender", f.get("genderOfChild"), false);
            addField(layout, "Birth Place", f.get("placeOfBirth"), false);
            addField(layout, "Registration Number", f.get("registrationNumber"), false);
            addField(layout, "Father's Full Name", f.get("fatherFullName"), false);
            addField(layout, "Mother's Full Name", f.get("motherFullName"), false);
            addField(layout, "Parents' Nationality", f.get("parentsNationality"), false);
            addField(layout, "Parents' Occupation", f.get("parentsOccupation"), false);
            addField(layout, "Parents' Permanent Address", f.get("parentsPermanentAddress"), true);
            addField(layout, "Informant Name", f.get("informantName"), false);
        } else if ("Marriage Certificate".equalsIgnoreCase(serviceName)) {
            layout.title = "Marriage Registration Certificate";
            layout.intro = "This is to certify that the marriage described below has been officially registered by the municipal authority.";
            addField(layout, "Husband Full Name", f.get("husbandFullName"), false);
            addField(layout, "Wife Full Name", f.get("wifeFullName"), false);
            addField(layout, "Husband Date of Birth", f.get("husbandDateOfBirth"), false);
            addField(layout, "Wife Date of Birth", f.get("wifeDateOfBirth"), false);
            addField(layout, "Husband Nationality", f.get("husbandNationality"), false);
            addField(layout, "Wife Nationality", f.get("wifeNationality"), false);
            addField(layout, "Date of Marriage", f.get("dateOfMarriage"), false);
            addField(layout, "Place of Marriage", f.get("placeOfMarriage"), false);
            addField(layout, "Husband Permanent Address", f.get("husbandPermanentAddress"), true);
            addField(layout, "Wife Permanent Address", f.get("wifePermanentAddress"), true);
            addField(layout, "Witness Details", f.get("witnessNamesAndSignatures"), true);
            addField(layout, "Marriage Registration Number", f.get("marriageRegistrationNumber"), false);
        } else if ("Residence Certificate".equalsIgnoreCase(serviceName)) {
            layout.title = "Permanent Residence Recommendation";
            layout.intro = "This is to certify that the applicant named below is recorded as a resident within the stated ward jurisdiction.";
            addField(layout, "Applicant Full Name", firstNonBlank(f.get("applicantFullName"), data.citizenName), false);
            addField(layout, "Parent / Guardian Name", f.get("parentName"), false);
            addField(layout, "Date of Birth", f.get("dateOfBirth"), false);
            addField(layout, "Identification Number", f.get("identificationNumber"), false);
            addField(layout, "Permanent Address", f.get("permanentAddress"), true);
            addField(layout, "Current Address", f.get("currentAddress"), true);
            addField(layout, "Duration of Stay", f.get("durationOfStayAtCurrentAddress"), false);
            addField(layout, "Purpose of Certificate", f.get("purposeOfCertificate"), false);
            addField(layout, "Photograph Reference", f.get("photographReference"), false);
            addField(layout, "Signature / Thumbprint Reference", f.get("signatureOrThumbprintReference"), false);
        } else if ("Citizenship Recommendation".equalsIgnoreCase(serviceName)) {
            layout.title = "Citizenship Recommendation Letter";
            layout.intro = "This is to certify that the ward office recommends the applicant below for citizenship processing based on the submitted supporting details.";
            addField(layout, "Applicant Full Name", firstNonBlank(f.get("fullName"), data.citizenName), false);
            addField(layout, "Date of Birth", f.get("dateOfBirth"), false);
            addField(layout, "Place of Birth", f.get("placeOfBirth"), false);
            addField(layout, "Gender", f.get("gender"), false);
            addField(layout, "Parent Name(s)", f.get("parentNames"), false);
            addField(layout, "Parents' Nationality", f.get("nationalityOfParents"), false);
            addField(layout, "Identification Number", f.get("identificationNumber"), false);
            addField(layout, "Permanent Address", f.get("permanentAddress"), true);
        } else {
            addField(layout, "Applicant Name", data.citizenName, false);
            addField(layout, "Email", data.email, false);
            addField(layout, "Service Type", data.serviceName, false);
        }

        addField(layout, "Ward", data.wardLabel, false);
        addField(layout, "Municipality", data.municipalityName, false);
        addField(layout, "Province", data.provinceName, false);
        addField(layout, "Issued By", firstNonBlank(data.approvedBy, "Municipal Authority"), false);
        if (!f.isEmpty()) {
            addField(layout, "Submitted Application Data", prettifyFieldMap(f), true);
        }
        return layout;
    }

    private void addField(CertificateLayout layout, String label, String value, boolean fullWidth) {
        if (value == null || value.isBlank()) {
            return;
        }
        layout.fields.add(new CertificateField(label, value, fullWidth));
    }

    private String prettifyFieldMap(Map<String, String> fields) {
        StringBuilder out = new StringBuilder();
        for (Map.Entry<String, String> entry : fields.entrySet()) {
            if (entry.getValue() == null || entry.getValue().isBlank()) {
                continue;
            }
            if (!out.isEmpty()) {
                out.append("\n");
            }
            out.append(humanizeKey(entry.getKey())).append(": ").append(entry.getValue());
        }
        return out.toString();
    }

    private String humanizeKey(String key) {
        if (key == null || key.isBlank()) {
            return "";
        }
        String spaced = key.replaceAll("([a-z])([A-Z])", "$1 $2").replace('_', ' ').trim();
        return Character.toUpperCase(spaced.charAt(0)) + spaced.substring(1);
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return "";
    }

    private String value(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }

    private byte[] generateSimplePdf(CertificateData data) {
        CertificateLayout layout = buildCertificateLayout(data);
        String issuedAt = data.certificate.getIssuedAt() == null
                ? "N/A"
                : data.certificate.getIssuedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy hh:mm a"));

        List<String> lines = new ArrayList<>();
        lines.add(value(data.municipalityName, "SarkarSathi Municipality"));
        lines.add(layout.title);
        lines.add(layout.subtitle);
        lines.add("");
        lines.add("Certificate No.: " + safePdf(data.certificate.getCertificateNo()));
        lines.add("Tracking ID: " + safePdf(data.trackingId));
        lines.add("Issued Date: " + safePdf(issuedAt));
        lines.add("");
        for (CertificateField field : layout.fields) {
            if (field.value == null || field.value.isBlank()) {
                continue;
            }
            String[] valueLines = field.value.split("\\R");
            for (int i = 0; i < valueLines.length; i++) {
                if (i == 0) {
                    lines.add(safePdf(field.label + ": " + valueLines[i]));
                } else {
                    lines.add(safePdf("  " + valueLines[i]));
                }
            }
        }
        if (data.remarks != null && !data.remarks.isBlank()) {
            lines.add("");
            lines.add("Approval Remarks: " + safePdf(data.remarks));
        }

        StringBuilder content = new StringBuilder();
        content.append("BT\n");
        content.append("/F1 14 Tf\n");
        content.append("50 790 Td\n");
        for (int i = 0; i < lines.size(); i++) {
            content.append("(").append(escapePdfText(lines.get(i))).append(") Tj\n");
            if (i < lines.size() - 1) {
                content.append("0 -18 Td\n");
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
        System.arraycopy(xrefBytes, 0, out, headerBytes.length + streamBytes.length + footerBytes.length,
                xrefBytes.length);
        return out;
    }

    private String escapePdfText(String value) {
        return safePdf(value).replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)");
    }

    private String safePdf(String value) {
        if (value == null) {
            return "";
        }
        return value.replaceAll("[^\\x20-\\x7E]", "?");
    }

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

    private String toCertJson(IssuedCertificate c) {
        return "{\"certificateId\":" + c.getCertificateId()
                + ",\"applicationId\":" + c.getApplicationId()
                + ",\"certificateNo\":" + quote(c.getCertificateNo())
                + ",\"issuedAt\":" + quote(c.getIssuedAt() != null ? c.getIssuedAt().toString() : null)
                + ",\"pdfFilePath\":" + quote(c.getPdfFilePath())
                + ",\"issuedByAdminId\":" + c.getIssuedByAdminId() + "}";
    }

    private static class CertificateData {
        private int citizenId;
        private IssuedCertificate certificate;
        private String trackingId;
        private String status;
        private String formDataRaw;
        private Map<String, String> formFields;
        private String remarks;
        private String citizenName;
        private String email;
        private String serviceName;
        private String wardLabel;
        private String municipalityName;
        private String provinceName;
        private String wardStampImage;
        private String approvedBy;
    }

    private static class CertificateLayout {
        private String title;
        private String subtitle;
        private String intro;
        private String authorityLine;
        private final List<CertificateField> fields = new ArrayList<>();
    }

    private static class CertificateField {
        private final String label;
        private final String value;
        private final boolean fullWidth;

        private CertificateField(String label, String value, boolean fullWidth) {
            this.label = label;
            this.value = value;
            this.fullWidth = fullWidth;
        }
    }
}
