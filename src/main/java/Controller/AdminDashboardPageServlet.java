package Controller;

import java.io.IOException;

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

        request.setAttribute("adminName", session.getAttribute("fullName"));
        request.setAttribute("adminEmail", session.getAttribute("email"));
        request.setAttribute("adminRole", session.getAttribute("adminRole"));
        request.getRequestDispatcher("/WEB-INF/admin-dashboard.jsp").forward(request, response);
    }
}
