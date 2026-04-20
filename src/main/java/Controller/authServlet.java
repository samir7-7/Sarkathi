<<<<<<< HEAD
package Controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

import DAO.AdminUserDAO;
import DAO.CitizenDAO;
import Model.AdminUser;
import Model.Citizen;
import Util.DatabaseConnection;
import Util.PasswordUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "authServlet", urlPatterns = "/api/auth/*")
public class AuthServlet extends BaseApiServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo() == null ? "" : request.getPathInfo();
        try {
            switch (path) {
                case "/register/citizen" -> registerCitizen(request, response);
                case "/login" -> login(request, response);
                default -> writeError(response, HttpServletResponse.SC_NOT_FOUND, "Unknown auth endpoint");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void registerCitizen(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Citizen citizen = new Citizen();
        citizen.setFullName(getRequiredParameter(request, "fullName"));
        citizen.setEmail(getRequiredParameter(request, "email"));
        citizen.setPhone(getRequiredParameter(request, "phone"));
        citizen.setPasswordHash(PasswordUtil.hash(getRequiredParameter(request, "password")));
        citizen.setDateOfBirth(LocalDate.parse(getRequiredParameter(request, "dateOfBirth")));
        citizen.setGender(getRequiredParameter(request, "gender"));
        citizen.setCreatedAt(LocalDateTime.now());

        try (Connection connection = DatabaseConnection.getConnection()) {
            CitizenDAO citizenDAO = new CitizenDAO(connection);
            if (citizenDAO.findByEmail(citizen.getEmail()).isPresent()) {
                writeError(response, HttpServletResponse.SC_CONFLICT, "Citizen email already exists");
                return;
            }

            Citizen savedCitizen = citizenDAO.create(citizen);
            writeJson(response, HttpServletResponse.SC_CREATED,
                    "{\"success\":true,\"citizen\":" + toCitizenJson(savedCitizen) + "}");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String email = getRequiredParameter(request, "email");
        String password = getRequiredParameter(request, "password");
        String userType = getOptionalParameter(request, "userType");
        if (userType == null || userType.isBlank()) {
            userType = "citizen";
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            if ("admin".equalsIgnoreCase(userType)) {
                AdminUserDAO adminUserDAO = new AdminUserDAO(connection);
                Optional<AdminUser> adminUser = adminUserDAO.findByEmail(email);
                if (adminUser.isPresent() && PasswordUtil.matches(password, adminUser.get().getPasswordHash())) {
                    writeJson(response, HttpServletResponse.SC_OK,
                            "{\"success\":true,\"role\":\"admin\",\"user\":" + toAdminJson(adminUser.get()) + "}");
                    return;
                }
            } else {
                CitizenDAO citizenDAO = new CitizenDAO(connection);
                Optional<Citizen> citizen = citizenDAO.findByEmail(email);
                if (citizen.isPresent() && PasswordUtil.matches(password, citizen.get().getPasswordHash())) {
                    writeJson(response, HttpServletResponse.SC_OK,
                            "{\"success\":true,\"role\":\"citizen\",\"user\":" + toCitizenJson(citizen.get()) + "}");
                    return;
                }
            }
        }

        writeError(response, HttpServletResponse.SC_UNAUTHORIZED, "Invalid credentials");
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

    private String toAdminJson(AdminUser adminUser) {
        return "{"
                + "\"adminId\":" + adminUser.getAdminId() + ","
                + "\"wardId\":" + adminUser.getWardId() + ","
                + "\"fullName\":" + quote(adminUser.getFullName()) + ","
                + "\"email\":" + quote(adminUser.getEmail()) + ","
                + "\"role\":" + quote(adminUser.getRole())
                + "}";
    }
}
=======
package Controller;

import DAO.AdminUserDAO;
import DAO.CitizenDAO;
import Model.AdminUser;
import Model.Citizen;
import Util.DatabaseConnection;
import Util.PasswordUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

@WebServlet(name = "authServlet", urlPatterns = "/api/auth/*")
public class AuthServlet extends BaseApiServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo() == null ? "" : request.getPathInfo();
        try {
            switch (path) {
                case "/register/citizen" -> registerCitizen(request, response);
                case "/login" -> login(request, response);
                default -> writeError(response, HttpServletResponse.SC_NOT_FOUND, "Unknown auth endpoint");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void registerCitizen(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Citizen citizen = new Citizen();
        citizen.setFullName(getRequiredParameter(request, "fullName"));
        citizen.setEmail(getRequiredParameter(request, "email"));
        citizen.setPhone(getRequiredParameter(request, "phone"));
        citizen.setPasswordHash(PasswordUtil.hash(getRequiredParameter(request, "password")));
        citizen.setDateOfBirth(LocalDate.parse(getRequiredParameter(request, "dateOfBirth")));
        citizen.setGender(getRequiredParameter(request, "gender"));
        citizen.setCreatedAt(LocalDateTime.now());

        try (Connection connection = DatabaseConnection.getConnection()) {
            CitizenDAO citizenDAO = new CitizenDAO(connection);
            if (citizenDAO.findByEmail(citizen.getEmail()).isPresent()) {
                writeError(response, HttpServletResponse.SC_CONFLICT, "Citizen email already exists");
                return;
            }

            Citizen savedCitizen = citizenDAO.create(citizen);
            writeJson(response, HttpServletResponse.SC_CREATED,
                    "{\"success\":true,\"citizen\":" + toCitizenJson(savedCitizen) + "}");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String email = getRequiredParameter(request, "email");
        String password = getRequiredParameter(request, "password");
        String userType = getOptionalParameter(request, "userType");
        if (userType == null || userType.isBlank()) {
            userType = "citizen";
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            if ("admin".equalsIgnoreCase(userType)) {
                AdminUserDAO adminUserDAO = new AdminUserDAO(connection);
                Optional<AdminUser> adminUser = adminUserDAO.findByEmail(email);
                if (adminUser.isPresent() && PasswordUtil.matches(password, adminUser.get().getPasswordHash())) {
                    writeJson(response, HttpServletResponse.SC_OK,
                            "{\"success\":true,\"role\":\"admin\",\"user\":" + toAdminJson(adminUser.get()) + "}");
                    return;
                }
            } else {
                CitizenDAO citizenDAO = new CitizenDAO(connection);
                Optional<Citizen> citizen = citizenDAO.findByEmail(email);
                if (citizen.isPresent() && PasswordUtil.matches(password, citizen.get().getPasswordHash())) {
                    writeJson(response, HttpServletResponse.SC_OK,
                            "{\"success\":true,\"role\":\"citizen\",\"user\":" + toCitizenJson(citizen.get()) + "}");
                    return;
                }
            }
        }

        writeError(response, HttpServletResponse.SC_UNAUTHORIZED, "Invalid credentials");
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

    private String toAdminJson(AdminUser adminUser) {
        return "{"
                + "\"adminId\":" + adminUser.getAdminId() + ","
                + "\"wardId\":" + adminUser.getWardId() + ","
                + "\"fullName\":" + quote(adminUser.getFullName()) + ","
                + "\"email\":" + quote(adminUser.getEmail()) + ","
                + "\"role\":" + quote(adminUser.getRole())
                + "}";
    }
}
>>>>>>> origin/frontend
