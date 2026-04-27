package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "citizenPagesServlet", urlPatterns = {
    "/citizen/dashboard", "/citizen/apply", "/citizen/tracking",
    "/citizen/payments", "/citizen/notifications", "/citizen/certificates",
    "/citizen/documents"
})
public class CitizenPagesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"citizen".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?userType=citizen");
            return;
        }

        request.setAttribute("citizenId", session.getAttribute("citizenId"));
        request.setAttribute("citizenName", session.getAttribute("fullName"));
        request.setAttribute("citizenEmail", session.getAttribute("email"));

        String path = request.getServletPath();
        String jsp = switch (path) {
            case "/citizen/dashboard" -> "/WEB-INF/citizen-dashboard.jsp";
            case "/citizen/apply" -> "/WEB-INF/apply.jsp";
            case "/citizen/tracking" -> "/WEB-INF/tracking.jsp";
            case "/citizen/payments" -> "/WEB-INF/payments.jsp";
            case "/citizen/notifications" -> "/WEB-INF/notifications.jsp";
            case "/citizen/certificates" -> "/WEB-INF/certificates.jsp";
            case "/citizen/documents" -> "/WEB-INF/documents.jsp";
            default -> "/WEB-INF/citizen-dashboard.jsp";
        };

        request.getRequestDispatcher(jsp).forward(request, response);
    }
}
