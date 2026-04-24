package Controller;

import DAO.CitizenDAO;
import Model.Citizen;
import Util.DatabaseConnection;
import Util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.regex.Pattern;

@WebServlet(name = "registerServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{7,15}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Citizen citizen = new Citizen();
            citizen.setFullName(getRequiredParameter(request, "fullName"));
            citizen.setEmail(getRequiredParameter(request, "email"));
            citizen.setPhone(getRequiredParameter(request, "phone"));
            String password = getRequiredParameter(request, "password");
            citizen.setPasswordHash(PasswordUtil.hash(validatePassword(password)));
            citizen.setDateOfBirth(validateDateOfBirth(getRequiredParameter(request, "dateOfBirth")));
            citizen.setGender(validateGender(getRequiredParameter(request, "gender")));
            citizen.setCreatedAt(LocalDateTime.now());
            citizen.setFullName(validateFullName(citizen.getFullName()));
            citizen.setEmail(validateEmail(citizen.getEmail()));
            citizen.setPhone(validatePhone(citizen.getPhone()));

            try (Connection connection = DatabaseConnection.getConnection()) {
                CitizenDAO citizenDAO = new CitizenDAO(connection);
                if (citizenDAO.findByEmail(citizen.getEmail()).isPresent()) {
                    forwardToRegister(request, response, "Citizen email already exists");
                    return;
                }

                citizenDAO.create(citizen);
                response.sendRedirect(request.getContextPath() + "/login?registered=success");
            }
        } catch (IllegalArgumentException e) {
            forwardToRegister(request, response, e.getMessage());
        } catch (SQLException e) {
            forwardToRegister(request, response, "A system error occurred. Please try again later.");
        }
    }

    private String getRequiredParameter(HttpServletRequest request, String parameterName) {
        String value = request.getParameter(parameterName);
        if (value == null || value.trim().isBlank()) {
            throw new IllegalArgumentException(parameterName + " is required");
        }
        return value.trim();
    }

    private String validateFullName(String fullName) {
        if (fullName.length() < 3 || fullName.length() > 100) {
            throw new IllegalArgumentException("Full name must be between 3 and 100 characters");
        }
        return fullName.replaceAll("\\s+", " ").trim();
    }

    private String validateEmail(String email) {
        String normalized = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("Please enter a valid email address");
        }
        return normalized;
    }

    private String validatePhone(String phone) {
        String normalized = phone.replaceAll("[^0-9]", "");
        if (!PHONE_PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("Phone number must contain 7 to 15 digits");
        }
        return normalized;
    }

    private String validatePassword(String password) {
        if (password.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters long");
        }
        return password;
    }

    private LocalDate validateDateOfBirth(String value) {
        LocalDate dateOfBirth = LocalDate.parse(value);
        int age = Period.between(dateOfBirth, LocalDate.now()).getYears();
        if (age < 16 || age > 120) {
            throw new IllegalArgumentException("Citizen age must be between 16 and 120 years");
        }
        return dateOfBirth;
    }

    private String validateGender(String gender) {
        return switch (gender.trim().toUpperCase()) {
            case "M", "F", "O" -> gender.trim().toUpperCase();
            default -> throw new IllegalArgumentException("Gender must be M, F, or O");
        };
    }

    private void forwardToRegister(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("fullName", valueOrEmpty(request.getParameter("fullName")));
        request.setAttribute("email", valueOrEmpty(request.getParameter("email")));
        request.setAttribute("phone", valueOrEmpty(request.getParameter("phone")));
        request.setAttribute("dateOfBirth", valueOrEmpty(request.getParameter("dateOfBirth")));
        request.setAttribute("gender", valueOrEmpty(request.getParameter("gender"), "M"));
        request.getRequestDispatcher("/WEB-INF/register.jsp").forward(request, response);
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }

    private String valueOrEmpty(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }
}