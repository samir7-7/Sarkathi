package Controller;

import DAO.impl.CitizenDAO;
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

/**
 * Citizen self-registration. Validates and normalises every field server-side
 * (we don't trust the JS validation), hashes the password with BCrypt, and
 * inserts a fresh citizen row. On success the user lands on the login page
 * with a {@code registered=success} flag the JSP shows as a banner.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "registerServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{7,15}$");

    /**
     * Renders the registration form.
     *
     * @param request  the incoming request
     * @param response the page response
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }

    /**
     * Handles the registration form submission. Validation errors are caught
     * and surfaced via the registration page; database errors fall through to
     * a generic message so we don't leak schema details.
     *
     * @param request  the incoming request
     * @param response redirect to login on success, forward to register on failure
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
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

    /**
     * Pulls a required parameter from the request and trims it. Throws if
     * missing or blank — the surrounding {@code doPost} converts that into a
     * user-visible error.
     *
     * @param request       the incoming request
     * @param parameterName name of the form field
     * @return trimmed, non-blank value
     * @throws IllegalArgumentException if the parameter is missing or blank
     */
    private String getRequiredParameter(HttpServletRequest request, String parameterName) {
        String value = request.getParameter(parameterName);
        if (value == null || value.trim().isBlank()) {
            throw new IllegalArgumentException(parameterName + " is required");
        }
        return value.trim();
    }

    /**
     * Length-checks the full name and collapses inner whitespace so we don't
     * end up storing names like "Ram   Bahadur".
     *
     * @param fullName raw full name
     * @return cleaned full name
     * @throws IllegalArgumentException if too short or too long
     */
    private String validateFullName(String fullName) {
        if (fullName.length() < 3 || fullName.length() > 100) {
            throw new IllegalArgumentException("Full name must be between 3 and 100 characters");
        }
        return fullName.replaceAll("\\s+", " ").trim();
    }

    /**
     * Lower-cases the email and runs it through {@link #EMAIL_PATTERN}.
     *
     * @param email raw email
     * @return normalised email (lower-cased, trimmed)
     * @throws IllegalArgumentException if the email isn't well-formed
     */
    private String validateEmail(String email) {
        String normalized = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("Please enter a valid email address");
        }
        return normalized;
    }

    /**
     * Strips everything that isn't a digit and confirms the result is between
     * 7 and 15 digits long. We accept formatting in input but store digits only.
     *
     * @param phone raw phone (may contain spaces, dashes, etc.)
     * @return digits-only phone
     * @throws IllegalArgumentException if the digit count is out of range
     */
    private String validatePhone(String phone) {
        String normalized = phone.replaceAll("[^0-9]", "");
        if (!PHONE_PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("Phone number must contain 7 to 15 digits");
        }
        return normalized;
    }

    /**
     * Enforces the minimum password length. Stronger checks (entropy, common
     * passwords) belong upstream — for now we just keep ridiculously short
     * passwords out.
     *
     * @param password raw password
     * @return same password if it passes
     * @throws IllegalArgumentException if shorter than 8 characters
     */
    private String validatePassword(String password) {
        if (password.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters long");
        }
        return password;
    }

    /**
     * Parses an ISO date string and rejects ages outside [16, 120].
     *
     * @param value ISO-formatted date string ({@code yyyy-MM-dd})
     * @return parsed {@link LocalDate}
     * @throws IllegalArgumentException if the resulting age is out of range
     */
    private LocalDate validateDateOfBirth(String value) {
        LocalDate dateOfBirth = LocalDate.parse(value);
        int age = Period.between(dateOfBirth, LocalDate.now()).getYears();
        if (age < 16 || age > 120) {
            throw new IllegalArgumentException("Citizen age must be between 16 and 120 years");
        }
        return dateOfBirth;
    }

    /**
     * Normalises the gender to one of {@code M}, {@code F}, or {@code O}.
     *
     * @param gender raw gender input
     * @return upper-cased single-letter code
     * @throws IllegalArgumentException if the value isn't one of the three
     */
    private String validateGender(String gender) {
        return switch (gender.trim().toUpperCase()) {
            case "M", "F", "O" -> gender.trim().toUpperCase();
            default -> throw new IllegalArgumentException("Gender must be M, F, or O");
        };
    }

    /**
     * Re-renders the registration form, echoing back the non-secret fields the
     * user already entered so they don't have to retype everything.
     *
     * @param request  the incoming request
     * @param response the response
     * @param error    the message to show above the form
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
    private void forwardToRegister(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("fullName", valueOrEmpty(request.getParameter("fullName")));
        request.setAttribute("email", valueOrEmpty(request.getParameter("email")));
        request.setAttribute("phone", valueOrEmpty(request.getParameter("phone")));
        request.setAttribute("dateOfBirth", valueOrEmpty(request.getParameter("dateOfBirth")));
        request.setAttribute("gender", valueOrEmpty(request.getParameter("gender"), "M"));
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }

    /**
     * Null-safe accessor that returns an empty string for missing values.
     *
     * @param value possibly-null input
     * @return value or empty string
     */
    private String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }

    /**
     * Null-or-blank-safe accessor with an explicit fallback.
     *
     * @param value    possibly-null input
     * @param fallback default to use when value is null or blank
     * @return value or the fallback
     */
    private String valueOrEmpty(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }
}
