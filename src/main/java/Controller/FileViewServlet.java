package Controller;

import DAO.impl.ApplicationDocumentDAO;
import DAO.impl.CitizenDocumentVaultDAO;
import Model.ApplicationDocument;
import Model.CitizenDocumentVault;
import Util.DatabaseConnection;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.util.List;

/**
 * Streams uploaded files back through the application so vault/application
 * documents can always be previewed even when the container does not expose
 * runtime-created files under /uploads as static assets.
 */
@WebServlet(name = "fileViewServlet", urlPatterns = "/api/files/view")
public class FileViewServlet extends BaseApiServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String requestedPath = getRequiredParameter(request, "path");
        try {
            String normalizedRelativePath = normalizeRelativeUploadPath(requestedPath);
            Path file = resolveUploadPath(normalizedRelativePath);
            if (!Files.exists(file) || !Files.isRegularFile(file)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            authorizeAccess(request, normalizedRelativePath);

            String contentType = detectContentType(file);
            response.setContentType(contentType);
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getFileName() + "\"");
            response.setHeader("X-Content-Type-Options", "nosniff");
            response.setContentLengthLong(Files.size(file));

            try (ServletOutputStream output = response.getOutputStream()) {
                Files.copy(file, output);
                output.flush();
            }
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private String normalizeRelativeUploadPath(String requestedPath) {
        String normalized = requestedPath.replace('\\', '/').trim();
        while (normalized.startsWith("/")) {
            normalized = normalized.substring(1);
        }
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("path is required");
        }
        Path safePath = Paths.get(normalized).normalize();
        String safe = safePath.toString().replace('\\', '/');
        if (!safe.startsWith("uploads/")) {
            throw new IllegalArgumentException("Only uploaded files can be viewed");
        }
        if (safe.contains("..")) {
            throw new IllegalArgumentException("Invalid file path");
        }
        return safe;
    }

    private Path resolveUploadPath(String normalizedRelativePath) {
        String appRoot = getServletContext().getRealPath("/");
        if (appRoot == null || appRoot.isBlank()) {
            throw new IllegalStateException("Unable to resolve application root");
        }
        Path root = Paths.get(appRoot).normalize();
        Path file = root.resolve(normalizedRelativePath).normalize();
        if (!file.startsWith(root.resolve("uploads").normalize())) {
            throw new IllegalArgumentException("Invalid file path");
        }
        return file;
    }

    private void authorizeAccess(HttpServletRequest request, String normalizedRelativePath) throws Exception {
        if (isAdmin(request)) {
            return;
        }

        Integer citizenId = getSessionCitizenId(request);
        if (!isCitizen(request) || citizenId == null) {
            throw new SecurityException("You are not allowed to access this file");
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            CitizenDocumentVaultDAO vaultDAO = new CitizenDocumentVaultDAO(connection);
            ApplicationDocumentDAO applicationDocumentDAO = new ApplicationDocumentDAO(connection);

            boolean matchesVaultDocument = hasVaultPath(vaultDAO.findByCitizenId(citizenId), normalizedRelativePath);
            boolean matchesApplicationDocument = hasApplicationPath(applicationDocumentDAO.findByCitizenId(citizenId), normalizedRelativePath);

            if (!matchesVaultDocument && !matchesApplicationDocument) {
                throw new SecurityException("You are not allowed to access this file");
            }
        }
    }

    private boolean hasVaultPath(List<CitizenDocumentVault> documents, String path) {
        for (CitizenDocumentVault document : documents) {
            if (path.equals(normalizeStoredPath(document.getFilePath()))) {
                return true;
            }
        }
        return false;
    }

    private boolean hasApplicationPath(List<ApplicationDocument> documents, String path) {
        for (ApplicationDocument document : documents) {
            if (path.equals(normalizeStoredPath(document.getFilePath()))) {
                return true;
            }
        }
        return false;
    }

    private String normalizeStoredPath(String storedPath) {
        if (storedPath == null) {
            return "";
        }
        return storedPath.replace('\\', '/').replaceFirst("^/+", "");
    }

    private String detectContentType(Path file) throws IOException {
        String contentType = Files.probeContentType(file);
        if (contentType != null && !contentType.isBlank()) {
            return contentType;
        }

        String name = file.getFileName().toString().toLowerCase();
        if (name.endsWith(".pdf")) {
            return "application/pdf";
        }
        if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
            return "image/jpeg";
        }
        if (name.endsWith(".png")) {
            return "image/png";
        }
        return "application/octet-stream";
    }
}
