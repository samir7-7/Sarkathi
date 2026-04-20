package Controller;

import DAO.CitizenDAO;
import DAO.CitizenDocumentVaultDAO;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.Citizen;
import Model.CitizenDocumentVault;

@WebServlet(name = "citizenServlet", urlPatterns = "/api/citizens/*")
public class CitizenServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo() == null ? "" : request.getPathInfo();
        try (Connection connection = DatabaseConnection.getConnection()) {
            CitizenDAO citizenDAO = new CitizenDAO(connection);
            CitizenDocumentVaultDAO vaultDAO = new CitizenDocumentVaultDAO(connection);

            if (path.isBlank() || "/".equals(path)) {
                writeJson(response, HttpServletResponse.SC_OK, citizensToJson(citizenDAO.findAll()));
                return;
            }

            if (path.endsWith("/documents")) {
                int citizenId = extractCitizenId(path.replace("/documents", ""));
                writeJson(response, HttpServletResponse.SC_OK, documentsToJson(vaultDAO.findByCitizenId(citizenId)));
                return;
            }

            int citizenId = extractCitizenId(path);
            Citizen citizen = citizenDAO.findById(citizenId).orElse(null);
            writeJson(response, HttpServletResponse.SC_OK,
                    "{"
                            + "\"citizen\":" + (citizen == null ? "null" : toCitizenJson(citizen)) + ","
                            + "\"documents\":" + documentsToJson(vaultDAO.findByCitizenId(citizenId))
                            + "}");
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private int extractCitizenId(String path) {
        String normalized = path.startsWith("/") ? path.substring(1) : path;
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("Citizen id is required");
        }
        return Integer.parseInt(normalized);
    }

    private String citizensToJson(List<Citizen> citizens) {
        List<String> items = new ArrayList<>();
        for (Citizen citizen : citizens) {
            items.add(toCitizenJson(citizen));
        }
        return jsonArray(items);
    }

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
