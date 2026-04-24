package Controller;

import DAO.AdminUserDAO;
import DAO.CitizenDAO;
import Model.AdminUser;
import Model.Citizen;
import Util.DatabaseConnection;
import Util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Optional;
import java.util.regex.Pattern;

@WebServlet(name = "loginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userType = request.getParameter("userType");
        if (userType == null || userType.isBlank()) {
            userType = "citizen";
        }

        request.setAttribute("userType", userType.trim().toLowerCase());
        request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            forwardToLogin(request, response, "Email and password are required.", email, userType);
            return;
        }

        email = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            forwardToLogin(request, response, "Please enter a valid email address.", email, userType);
            return;
        }
        if (userType == null || userType.isBlank()) {
            userType = "citizen";
        }
        userType = userType.trim().toLowerCase();

        try (Connection connection = DatabaseConnection.getConnection()) {
            if ("admin".equals(userType)) {
                handleAdminLogin(request, response, connection, email, password);
            } else {
                handleCitizenLogin(request, response, connection, email, password);
            }
        } catch (SQLException e) {
            forwardToLogin(request, response, "A system error occurred. Please try again later.", email, userType);
        }
    }

    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response,
                                  Connection connection, String email, String password)
            throws ServletException, IOException, SQLException {

        AdminUserDAO adminUserDAO = new AdminUserDAO(connection);
        Optional<AdminUser> adminUser = adminUserDAO.findByEmail(email);

        if (adminUser.isPresent() && PasswordUtil.matches(password, adminUser.get().getPasswordHash())) {
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(30 * 60);
            session.setAttribute("role", "admin");
            session.setAttribute("adminId", adminUser.get().getAdminId());
            session.setAttribute("fullName", adminUser.get().getFullName());
            session.setAttribute("email", adminUser.get().getEmail());
            session.setAttribute("adminRole", adminUser.get().getRole());

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            forwardToLogin(request, response, "Invalid admin credentials. Please check your email and password.", email, "admin");
        }
    }

    private void handleCitizenLogin(HttpServletRequest request, HttpServletResponse response,
                                    Connection connection, String email, String password)
            throws ServletException, IOException, SQLException {

        CitizenDAO citizenDAO = new CitizenDAO(connection);
        Optional<Citizen> citizen = citizenDAO.findByEmail(email);

        if (citizen.isPresent() && PasswordUtil.matches(password, citizen.get().getPasswordHash())) {
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(30 * 60);
            session.setAttribute("role", "citizen");
            session.setAttribute("citizenId", citizen.get().getCitizenId());
            session.setAttribute("fullName", citizen.get().getFullName());
            session.setAttribute("email", citizen.get().getEmail());

            response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
        } else {
            forwardToLogin(request, response, "Invalid credentials. Please check your email and password.", email, "citizen");
        }
    }

    private void forwardToLogin(HttpServletRequest request, HttpServletResponse response,
                                String error, String email, String userType)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("email", email);
        request.setAttribute("userType", userType == null || userType.isBlank() ? "citizen" : userType.trim().toLowerCase());
        request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
    }
}
