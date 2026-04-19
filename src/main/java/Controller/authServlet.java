package Controller;

import DAO.AdminUserDAO;
import DAO.CitizenDAO;
import Model.AdminUser;
import Model.Citizen;
import Util.DatabaseConnection;
import Util.PasswordUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
            handleAuthFailure(request, response, HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage(), resolveRedirectPath(path));
        } catch (SQLException e) {
            handleAuthFailure(request, response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage(), resolveRedirectPath(path));
        }
    }

    private void registerCitizen(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Citizen citizen = new Citizen();
        citizen.setFullName(getRequiredParameter(request, "fullName"));
        citizen.setEmail(getRequiredParameter(request, "email"));
        citizen.setPhone(getRequiredParameter(request, "phone"));
        citizen.setPasswordHash(PasswordUtil.hash(getRequiredParameter(request, "password")));
        citizen.setDateOfBirth(LocalDate.parse(getRequiredParameter(request, "dateOfBirth")));
        citizen.setGender(normalizeGender(getRequiredParameter(request, "gender")));
        citizen.setCreatedAt(LocalDateTime.now());

        try (Connection connection = DatabaseConnection.getConnection()) {
            CitizenDAO citizenDAO = new CitizenDAO(connection);
            if (citizenDAO.findByEmail(citizen.getEmail()).isPresent()) {
                handleAuthFailure(request, response, HttpServletResponse.SC_CONFLICT,
                        "Citizen email already exists", "/register.jsp");
                return;
            }

            Citizen savedCitizen = citizenDAO.create(citizen);
            if (isBrowserFormRequest(request)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?registered=1");
                return;
            }
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
                    if (isBrowserFormRequest(request)) {
                        HttpSession session = request.getSession(true);
                        session.setAttribute("userRole", "admin");
                        session.setAttribute("adminId", adminUser.get().getAdminId());
                        session.setAttribute("displayName", adminUser.get().getFullName());
                        response.sendRedirect(request.getContextPath() + "/index.jsp?login=success");
                        return;
                    }
                    writeJson(response, HttpServletResponse.SC_OK,
                            "{\"success\":true,\"role\":\"admin\",\"user\":" + toAdminJson(adminUser.get()) + "}");
                    return;
                }
            } else {
                CitizenDAO citizenDAO = new CitizenDAO(connection);
                Optional<Citizen> citizen = citizenDAO.findByEmail(email);
                if (citizen.isPresent() && PasswordUtil.matches(password, citizen.get().getPasswordHash())) {
                    if (isBrowserFormRequest(request)) {
                        HttpSession session = request.getSession(true);
                        session.setAttribute("userRole", "citizen");
                        session.setAttribute("citizenId", citizen.get().getCitizenId());
                        session.setAttribute("displayName", citizen.get().getFullName());
                        response.sendRedirect(request.getContextPath() + "/index.jsp?login=success");
                        return;
                    }
                    writeJson(response, HttpServletResponse.SC_OK,
                            "{\"success\":true,\"role\":\"citizen\",\"user\":" + toCitizenJson(citizen.get()) + "}");
                    return;
                }
            }
        }

        handleAuthFailure(request, response, HttpServletResponse.SC_UNAUTHORIZED,
                "Invalid credentials", "/login.jsp");
    }

    private void handleAuthFailure(HttpServletRequest request, HttpServletResponse response,
                                   int statusCode, String message, String redirectPath) throws IOException {
        if (isBrowserFormRequest(request)) {
            response.sendRedirect(request.getContextPath() + redirectPath + "?error=" + encode(message));
            return;
        }
        writeError(response, statusCode, message);
    }

    private boolean isBrowserFormRequest(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        return accept != null && accept.contains("text/html");
    }

    private String normalizeGender(String gender) {
        return switch (gender.trim().toUpperCase()) {
            case "M", "MALE" -> "M";
            case "F", "FEMALE" -> "F";
            case "O", "OTHER" -> "O";
            default -> throw new IllegalArgumentException("gender must be M, F, or O");
        };
    }

    private String encode(String value) {
        return java.net.URLEncoder.encode(value, java.nio.charset.StandardCharsets.UTF_8);
    }

    private String resolveRedirectPath(String path) {
        return "/register/citizen".equals(path) ? "/register.jsp" : "/login.jsp";
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
