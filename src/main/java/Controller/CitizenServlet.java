package Controller;

import DAO.impl.CitizenDAO;
import DAO.impl.CitizenDocumentVaultDAO;
import Model.Citizen;
import Model.CitizenDocumentVault;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * REST-style endpoint for citizen records and their attached vault documents.
 * URL shape: {@code /api/citizens}, {@code /api/citizens/{id}}, and {@code
 * /api/citizens/{id}/documents}. Citizens can read and edit their own
 * record; admins can list everyone and delete accounts.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "citizenServlet", urlPatterns = "/api/citizens/*")
public class CitizenServlet extends BaseApiServlet {
    /**
     * Fetches either the full citizen list (admin only), a specific citizen
     * (owner only), or a citizen's vault documents (owner only). Returns
     * {@code 403} when ownership doesn't match.
     *
     * @param request  the incoming request
     * @param response JSON envelope or array
     * @throws IOException if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo() == null ? "" : request.getPathInfo();
        try (Connection connection = DatabaseConnection.getConnection()) {
            CitizenDAO citizenDAO = new CitizenDAO(connection);
            CitizenDocumentVaultDAO vaultDAO = new CitizenDocumentVaultDAO(connection);

            if (path.isBlank() || "/".equals(path)) {
                requireAdmin(request);
                writeJson(response, HttpServletResponse.SC_OK, citizensToJson(citizenDAO.findAll()));
                return;
            }

            if (path.endsWith("/documents")) {
                int citizenId = extractCitizenId(path.replace("/documents", ""));
                requireCitizenOwnership(request, citizenId);
                writeJson(response, HttpServletResponse.SC_OK, documentsToJson(vaultDAO.findByCitizenId(citizenId)));
                return;
            }

            int citizenId = extractCitizenId(path);
            requireCitizenOwnership(request, citizenId);
            Citizen citizen = citizenDAO.findById(citizenId).orElse(null);
            writeJson(response, HttpServletResponse.SC_OK,
                    "{"
                            + "\"citizen\":" + (citizen == null ? "null" : toCitizenJson(citizen)) + ","
                            + "\"documents\":" + documentsToJson(vaultDAO.findByCitizenId(citizenId))
                            + "}");
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Updates a citizen's profile. Every field is optional — omit a parameter
     * to leave that column unchanged. Email changes are checked against the
     * uniqueness constraint before we apply them.
     *
     * @param request  the incoming request
     * @param response JSON envelope with the updated record
     * @throws IOException if writing fails
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo() == null ? "" : request.getPathInfo();
        try (Connection connection = DatabaseConnection.getConnection()) {
            int citizenId = extractCitizenId(path);
            requireCitizenOwnership(request, citizenId);
            CitizenDAO citizenDAO = new CitizenDAO(connection);
            Citizen citizen = citizenDAO.findById(citizenId).orElse(null);

            if (citizen == null) {
                writeError(response, HttpServletResponse.SC_NOT_FOUND, "Citizen not found");
                return;
            }

            String fullName = getOptionalParameter(request, "fullName");
            String email = getOptionalParameter(request, "email");
            String phone = getOptionalParameter(request, "phone");
            String dateOfBirth = getOptionalParameter(request, "dateOfBirth");
            String gender = getOptionalParameter(request, "gender");

            if (fullName != null) {
                citizen.setFullName(fullName);
            }
            if (email != null) {
                Optional<Citizen> existing = citizenDAO.findByEmail(email);
                if (existing.isPresent() && existing.get().getCitizenId() != citizenId) {
                    writeError(response, HttpServletResponse.SC_CONFLICT, "Citizen email already exists");
                    return;
                }
                citizen.setEmail(email);
            }
            if (phone != null) {
                citizen.setPhone(phone);
            }
            if (dateOfBirth != null) {
                citizen.setDateOfBirth(LocalDate.parse(dateOfBirth));
            }
            if (gender != null) {
                citizen.setGender(gender);
            }

            Citizen updatedCitizen = citizenDAO.update(citizen);
            writeJson(response, HttpServletResponse.SC_OK,
                    "{\"success\":true,\"citizen\":" + toCitizenJson(updatedCitizen) + "}");
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Deletes a citizen account. Admin-only — citizens can't tear down their
     * own account through this endpoint.
     *
     * @param request  the incoming request
     * @param response JSON success envelope
     * @throws IOException if writing fails
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo() == null ? "" : request.getPathInfo();
        try (Connection connection = DatabaseConnection.getConnection()) {
            int citizenId = extractCitizenId(path);
            requireAdmin(request);
            CitizenDAO citizenDAO = new CitizenDAO(connection);

            if (!citizenDAO.findById(citizenId).isPresent()) {
                writeError(response, HttpServletResponse.SC_NOT_FOUND, "Citizen not found");
                return;
            }

            citizenDAO.deleteById(citizenId);
            writeJson(response, HttpServletResponse.SC_OK,
                    "{\"success\":true,\"message\":\"Citizen deleted successfully\"}");
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Pulls the {@code citizenId} segment from the URL path.
     *
     * @param path path info portion of the request URL
     * @return parsed citizen ID
     * @throws IllegalArgumentException if the segment is missing or non-numeric
     */
    private int extractCitizenId(String path) {
        String normalized = path.startsWith("/") ? path.substring(1) : path;
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("Citizen id is required");
        }
        try {
            return Integer.parseInt(normalized);
        } catch (NumberFormatException invalidId) {
            throw new IllegalArgumentException("Citizen id must be a number");
        }
    }

    /**
     * Renders a list of citizens as a JSON array.
     *
     * @param citizens citizens to render
     * @return JSON array string
     */
    private String citizensToJson(List<Citizen> citizens) {
        List<String> items = new ArrayList<>();
        for (Citizen citizen : citizens) {
            items.add(toCitizenJson(citizen));
        }
        return jsonArray(items);
    }

    /**
     * Renders a list of vault documents as a JSON array.
     *
     * @param documents documents to render
     * @return JSON array string
     */
    private String documentsToJson(List<CitizenDocumentVault> documents) {
        List<String> items = new ArrayList<>();
        for (CitizenDocumentVault document : documents) {
            items.add("{"
                    + "\"vaultDocId\":" + document.getVaultDocId() + ","
                    + "\"citizenId\":" + document.getCitizenId() + ","
                    + "\"documentType\":" + quote(document.getDocumentType()) + ","
                    + "\"filePath\":" + quote(document.getFilePath()) + ","
                    + "\"uploadedAt\":" + quote(document.getUploadedAt() == null ? null : document.getUploadedAt().toString())
                    + "}");
        }
        return jsonArray(items);
    }

    /**
     * Renders a single citizen as a JSON object — minus the password hash.
     *
     * @param citizen the citizen
     * @return JSON object literal
     */
    private String toCitizenJson(Citizen citizen) {
        return "{"
                + "\"citizenId\":" + citizen.getCitizenId() + ","
                + "\"fullName\":" + quote(citizen.getFullName()) + ","
                + "\"email\":" + quote(citizen.getEmail()) + ","
                + "\"phone\":" + quote(citizen.getPhone()) + ","
                + "\"dateOfBirth\":" + quote(citizen.getDateOfBirth() == null ? null : citizen.getDateOfBirth().toString()) + ","
                + "\"gender\":" + quote(citizen.getGender()) + ","
                + "\"createdAt\":" + quote(citizen.getCreatedAt() == null ? null : citizen.getCreatedAt().toString())
                + "}";
    }
}