package Controller;

import DAO.impl.ApplicationDAO;
import DAO.impl.ApplicationDocumentDAO;
import DAO.impl.CitizenDocumentVaultDAO;
import Model.Application;
import Model.ApplicationDocument;
import Model.CitizenDocumentVault;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

/**
 * Handles citizen file uploads — both vault-only saves and per-application
 * attachments. Files are validated by extension and content type, capped at
 * 10 MB, and stored on disk under {@code /uploads/} with a UUID filename so
 * we never collide with the user's original name.
 * <p>
 * The same upload can populate the citizen's vault, the application's
 * documents, or both (when the user ticks "save to vault" on the apply
 * form). Everything happens in one request so the page only has to upload
 * the file once.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "fileUploadServlet", urlPatterns = "/api/upload")
@MultipartConfig(maxFileSize = 10485760, maxRequestSize = 20971520, fileSizeThreshold = 1048576)
public class FileUploadServlet extends BaseApiServlet {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(".pdf", ".jpg", ".jpeg", ".png");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of("application/pdf", "image/jpeg", "image/png");

    /**
     * Returns the on-disk upload directory, creating it if it doesn't exist.
     * Resolved relative to the deployed app so the same code works under
     * different Tomcat installations.
     *
     * @return absolute path to the uploads directory
     */
    private String getUploadDir() {
        String dir = getServletContext().getRealPath("/uploads");
        File f = new File(dir);
        if (!f.exists()) {
            f.mkdirs();
        }
        return dir;
    }

    /**
     * Processes a multipart upload. Validates the file, writes it to the
     * uploads directory, and creates the matching database rows depending on
     * what the request asked for ({@code applicationId}, {@code saveToVault}).
     * <p>
     * If a redirect target is provided we redirect there on success or
     * error — the apply form uses this so it behaves like a normal HTML form.
     * Otherwise we return a JSON envelope.
     *
     * @param request  the incoming multipart request
     * @param response redirect or JSON envelope
     * @throws IOException if writing fails
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = request.getParameter("redirectTo");
        try {
            String citizenIdParam = request.getParameter("citizenId");
            String applicationIdParam = request.getParameter("applicationId");
            String documentType = request.getParameter("documentType");
            String saveToVault = request.getParameter("saveToVault");

            if (citizenIdParam == null || citizenIdParam.isBlank()) {
                redirectOrWriteError(request, response, redirectTo, "citizenId is required", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            int citizenId = Integer.parseInt(citizenIdParam);
            requireCitizenOwnership(request, citizenId);

            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                redirectOrWriteError(request, response, redirectTo, "file is required", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String ext = originalName.contains(".") ? originalName.substring(originalName.lastIndexOf('.')).toLowerCase() : "";
            if (!ALLOWED_EXTENSIONS.contains(ext) || !ALLOWED_CONTENT_TYPES.contains(String.valueOf(filePart.getContentType()).toLowerCase())) {
                redirectOrWriteError(request, response, redirectTo, "Only PDF, JPG, JPEG, and PNG files are allowed", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            if (filePart.getSize() > 10 * 1024 * 1024L) {
                redirectOrWriteError(request, response, redirectTo, "File exceeds 10MB limit", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            String storedName = UUID.randomUUID().toString() + ext;
            String uploadDir = getUploadDir();
            Path filePath = Paths.get(uploadDir, storedName);
            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, filePath);
            }

            String relativePath = "uploads/" + storedName;

            try (Connection conn = DatabaseConnection.getConnection()) {
                if (applicationIdParam != null && !applicationIdParam.isBlank()) {
                    ApplicationDAO applicationDAO = new ApplicationDAO(conn);
                    Application application = applicationDAO.findById(Integer.parseInt(applicationIdParam)).orElse(null);
                    if (application == null) {
                        redirectOrWriteError(request, response, redirectTo, "Application not found", HttpServletResponse.SC_NOT_FOUND);
                        return;
                    }
                    requireCitizenOwnership(request, application.getCitizenId());
                }

                if ("true".equalsIgnoreCase(saveToVault)) {
                    CitizenDocumentVaultDAO vaultDAO = new CitizenDocumentVaultDAO(conn);
                    CitizenDocumentVault vaultDoc = new CitizenDocumentVault();
                    vaultDoc.setCitizenId(citizenId);
                    vaultDoc.setDocumentType(safeDocumentType(documentType));
                    vaultDoc.setFilePath(relativePath);
                    vaultDoc.setUploadedAt(LocalDateTime.now());
                    vaultDAO.create(vaultDoc);
                }

                if (applicationIdParam != null && !applicationIdParam.isBlank()) {
                    int applicationId = Integer.parseInt(applicationIdParam);
                    ApplicationDocumentDAO appDocDAO = new ApplicationDocumentDAO(conn);
                    ApplicationDocument appDoc = new ApplicationDocument();
                    appDoc.setApplicationId(applicationId);
                    appDoc.setDocumentType(safeDocumentType(documentType));
                    appDoc.setFilePath(relativePath);
                    appDoc.setUploadedAt(LocalDateTime.now());
                    appDoc.setReusable("true".equalsIgnoreCase(saveToVault));
                    appDocDAO.create(appDoc);
                }

                redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_CREATED,
                        "{\"success\":true,\"filePath\":" + quote(relativePath) + ",\"fileName\":" + quote(originalName) + "}");
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
     * {@code /citizen/documents}.
     *
     * @param request    the incoming request
     * @param redirectTo requested target
     * @param error      optional error to surface as a query parameter
     * @return absolute redirect URL
     */
    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/citizen/documents";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    /**
     * Sanitises the {@code documentType} input by lower-casing, stripping
     * everything that isn't alphanumeric/dash/space, and capping the length
     * at 50 characters. Falls back to {@code "general"} when the result is
     * blank.
     *
     * @param documentType raw type string from the form
     * @return safe document-type slug
     */
    private String safeDocumentType(String documentType) {
        if (documentType == null || documentType.isBlank()) {
            return "general";
        }
        String normalized = documentType.trim().toLowerCase().replaceAll("[^a-z0-9\\- ]", "");
        return normalized.isBlank() ? "general" : normalized.substring(0, Math.min(normalized.length(), 50));
    }
}
