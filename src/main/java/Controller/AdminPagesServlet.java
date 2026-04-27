package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "adminPagesServlet", urlPatterns = {
    "/admin/applications", "/admin/notices", "/admin/announcements", "/admin/budgets"
})
public class AdminPagesServlet extends HttpServlet {
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

        String path = request.getServletPath();
        String jsp = switch (path) {
            case "/admin/applications" -> "/WEB-INF/admin-applications.jsp";
            case "/admin/notices" -> "/WEB-INF/admin-notices.jsp";
            case "/admin/announcements" -> "/WEB-INF/admin-announcements.jsp";
            case "/admin/budgets" -> "/WEB-INF/admin-budgets.jsp";
            default -> "/WEB-INF/admin-dashboard.jsp";
        };

        request.getRequestDispatcher(jsp).forward(request, response);
    }
}
