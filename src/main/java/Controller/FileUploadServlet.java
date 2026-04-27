package Controller;

import DAO.ApplicationDAO;
import DAO.ApplicationDocumentDAO;
import DAO.CitizenDocumentVaultDAO;
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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

@WebServlet(name = "fileUploadServlet", urlPatterns = "/api/upload")
@MultipartConfig(maxFileSize = 10485760, maxRequestSize = 20971520, fileSizeThreshold = 1048576)
public class FileUploadServlet extends BaseApiServlet {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(".pdf", ".jpg", ".jpeg", ".png");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of("application/pdf", "image/jpeg", "image/png");

    private String getUploadDir() {
        String dir = getServletContext().getRealPath("/uploads");
        File f = new File(dir);
        if (!f.exists()) {
            f.mkdirs();
        }
        return dir;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String citizenIdParam = request.getParameter("citizenId");
            String applicationIdParam = request.getParameter("applicationId");
            String documentType = request.getParameter("documentType");
            String saveToVault = request.getParameter("saveToVault");

            if (citizenIdParam == null || citizenIdParam.isBlank()) {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, "citizenId is required");
                return;
            }
            int citizenId = Integer.parseInt(citizenIdParam);
            requireCitizenOwnership(request, citizenId);

            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, "file is required");
                return;
            }

            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String ext = originalName.contains(".") ? originalName.substring(originalName.lastIndexOf('.')).toLowerCase() : "";
            if (!ALLOWED_EXTENSIONS.contains(ext) || !ALLOWED_CONTENT_TYPES.contains(String.valueOf(filePart.getContentType()).toLowerCase())) {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Only PDF, JPG, JPEG, and PNG files are allowed");
                return;
            }
            if (filePart.getSize() > 10 * 1024 * 1024L) {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, "File exceeds 10MB limit");
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
                        writeError(response, HttpServletResponse.SC_NOT_FOUND, "Application not found");
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

                writeJson(response, HttpServletResponse.SC_CREATED,
                        "{\"success\":true,\"filePath\":" + quote(relativePath) + ",\"fileName\":" + quote(originalName) + "}");
            }
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private String safeDocumentType(String documentType) {
        if (documentType == null || documentType.isBlank()) {
            return "general";
        }
        String normalized = documentType.trim().toLowerCase().replaceAll("[^a-z0-9\\- ]", "");
        return normalized.isBlank() ? "general" : normalized.substring(0, Math.min(normalized.length(), 50));
    }
}
