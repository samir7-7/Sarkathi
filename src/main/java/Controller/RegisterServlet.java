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

@WebServlet(name = "registerServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
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
