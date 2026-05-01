package Controller;

import DAO.ApplicationDAO;
import DAO.CitizenDocumentVaultDAO;
import DAO.IssuedCertificateDAO;
import DAO.NotificationDAO;
import DAO.ServiceTypeDAO;
import DAO.TaxRecordDAO;
import DAO.WardDAO;
import Model.Application;
import Model.Notification;
import Util.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

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
        Integer citizenId = (Integer) session.getAttribute("citizenId");
        try (Connection conn = DatabaseConnection.getConnection()) {
            loadSharedCitizenData(request, conn, citizenId);
            if ("/citizen/dashboard".equals(path) || "/citizen/tracking".equals(path)) {
                request.setAttribute("applications", new ApplicationDAO(conn).findByCitizenId(citizenId));
                String trackingId = request.getParameter("trackingId");
                if (trackingId != null && !trackingId.isBlank()) {
                    Application application = new ApplicationDAO(conn).findByTrackingId(trackingId.trim()).orElse(null);
                    if (application != null && application.getCitizenId() == citizenId) {
                        request.setAttribute("trackingResult", application);
                    }
                    request.setAttribute("trackingSearched", true);
                }
            } else if ("/citizen/apply".equals(path)) {
                request.setAttribute("serviceTypes", new ServiceTypeDAO(conn).findAll(true));
                request.setAttribute("wards", new WardDAO(conn).findAll());
                request.setAttribute("documents", new CitizenDocumentVaultDAO(conn).findByCitizenId(citizenId));
            } else if ("/citizen/payments".equals(path)) {
                request.setAttribute("taxRecords", new TaxRecordDAO(conn).findByCitizenId(citizenId));
            } else if ("/citizen/notifications".equals(path)) {
                request.setAttribute("notifications", new NotificationDAO(conn).findByCitizenId(citizenId));
            } else if ("/citizen/certificates".equals(path)) {
                request.setAttribute("certificates", new IssuedCertificateDAO(conn).findByCitizenId(citizenId));
            } else if ("/citizen/documents".equals(path)) {
                request.setAttribute("documents", new CitizenDocumentVaultDAO(conn).findByCitizenId(citizenId));
            }
        } catch (SQLException e) {
            request.setAttribute("pageError", "Unable to load page data.");
            request.setAttribute("applications", List.of());
            request.setAttribute("serviceTypes", List.of());
            request.setAttribute("wards", List.of());
            request.setAttribute("documents", List.of());
            request.setAttribute("taxRecords", List.of());
            request.setAttribute("notifications", List.of());
            request.setAttribute("certificates", List.of());
            request.setAttribute("unreadCount", 0);
        }

        String jsp = switch (path) {
            case "/citizen/dashboard" -> "/WEB-INF/citizen/dashboard.jsp";
            case "/citizen/apply" -> "/WEB-INF/citizen/apply.jsp";
            case "/citizen/tracking" -> "/WEB-INF/pages/tracking.jsp";
            case "/citizen/payments" -> "/WEB-INF/citizen/payments.jsp";
            case "/citizen/notifications" -> "/WEB-INF/citizen/notifications.jsp";
            case "/citizen/certificates" -> "/WEB-INF/citizen/certificates.jsp";
            case "/citizen/documents" -> "/WEB-INF/citizen/documents.jsp";
            default -> "/WEB-INF/citizen/dashboard.jsp";
        };

        request.getRequestDispatcher(jsp).forward(request, response);
    }

    private void loadSharedCitizenData(HttpServletRequest request, Connection conn, int citizenId) throws SQLException {
        NotificationDAO notificationDAO = new NotificationDAO(conn);
        List<Notification> notifications = notificationDAO.findByCitizenId(citizenId);
        List<Application> applications = new ApplicationDAO(conn).findByCitizenId(citizenId);
        request.setAttribute("sharedNotifications", notifications);
        request.setAttribute("unreadCount", notificationDAO.countUnreadByCitizenId(citizenId));
        request.setAttribute("applicationCount", applications.size());
        request.setAttribute("approvedApplicationCount",
                applications.stream().filter(a -> "approved".equals(a.getStatus())).count());
        request.setAttribute("pendingApplicationCount",
                applications.stream().filter(a -> "submitted".equals(a.getStatus()) || "review".equals(a.getStatus())).count());
        request.setAttribute("certificateCount", new IssuedCertificateDAO(conn).findByCitizenId(citizenId).size());
    }
}
