package Controller;

import DAO.impl.ApplicationDAO;
import Util.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "adminDashboardPageServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?userType=admin");
            return;
        }

        request.setAttribute("adminId", session.getAttribute("adminId"));
        request.setAttribute("adminName", session.getAttribute("fullName"));
        request.setAttribute("adminEmail", session.getAttribute("email"));
        request.setAttribute("adminRole", session.getAttribute("adminRole"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            ApplicationDAO applicationDAO = new ApplicationDAO(conn);
            request.setAttribute("totalApplications", applicationDAO.countAll());
            request.setAttribute("submittedApplications", applicationDAO.countByStatus("submitted"));
            request.setAttribute("reviewApplications", applicationDAO.countByStatus("review"));
            request.setAttribute("approvedApplications", applicationDAO.countByStatus("approved"));
            request.setAttribute("rejectedApplications", applicationDAO.countByStatus("rejected"));
            request.setAttribute("recentApplications", applicationDAO.findAll());
        } catch (SQLException e) {
            request.setAttribute("pageError", "Unable to load dashboard data.");
            request.setAttribute("totalApplications", 0L);
            request.setAttribute("submittedApplications", 0L);
            request.setAttribute("reviewApplications", 0L);
            request.setAttribute("approvedApplications", 0L);
            request.setAttribute("rejectedApplications", 0L);
            request.setAttribute("recentApplications", java.util.List.of());
        }
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }
}
