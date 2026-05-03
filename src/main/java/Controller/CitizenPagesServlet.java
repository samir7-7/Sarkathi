package Controller;

import DAO.impl.ApplicationDAO;
import DAO.impl.ApplicationDocumentDAO;
import DAO.interfaces.ApplicationDocumentDAOInterface;
import DAO.interfaces.ApplicationDAOInterface;
import DAO.impl.CitizenDocumentVaultDAO;
import DAO.interfaces.CitizenDocumentVaultDAOInterface;
import DAO.impl.IssuedCertificateDAO;
import DAO.interfaces.IssuedCertificateDAOInterface;
import DAO.impl.NotificationDAO;
import DAO.interfaces.NotificationDAOInterface;
import DAO.impl.ServiceTypeDAO;
import DAO.impl.TaxRecordDAO;
import DAO.impl.WardDAO;
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

/**
 * Page dispatcher for the citizen-facing area. Like {@link AdminPagesServlet}
 * but for citizen views — dashboard, apply, tracking, payments,
 * notifications, certificates, document vault — each path prefetches the
 * data its JSP needs.
 * <p>
 * Every page also gets the "shared" citizen data (notification counter,
 * application counters, certificate count) so the sidebar widgets work
 * regardless of which page the citizen is on.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "citizenPagesServlet", urlPatterns = {
    "/citizen/dashboard", "/citizen/apply", "/citizen/tracking",
    "/citizen/payments", "/citizen/notifications", "/citizen/certificates",
    "/citizen/documents"
})
public class CitizenPagesServlet extends HttpServlet {
    /**
     * Routes the citizen to the right view and pre-loads its data. Tracking
     * lookups are scoped to the logged-in citizen so people can't peek at
     * other citizens' applications by guessing tracking IDs.
     *
     * @param request  the incoming request
     * @param response the response (forward to JSP, or redirect to login)
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
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
                ApplicationDAOInterface applicationDAO = new ApplicationDAO(conn);
                request.setAttribute("applications", applicationDAO.findByCitizenId(citizenId));
                String trackingId = request.getParameter("trackingId");
                if (trackingId != null && !trackingId.isBlank()) {
                    Application application = applicationDAO.findByTrackingId(trackingId.trim()).orElse(null);
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
                CitizenDocumentVaultDAOInterface vaultDAO = new CitizenDocumentVaultDAO(conn);
                ApplicationDocumentDAOInterface applicationDocumentDAO = new ApplicationDocumentDAO(conn);
                request.setAttribute("documents", vaultDAO.findByCitizenId(citizenId));
                request.setAttribute("applicationDocuments", applicationDocumentDAO.findByCitizenId(citizenId));
            }
        } catch (SQLException e) {
            request.setAttribute("pageError", "Unable to load page data.");
            request.setAttribute("applications", List.of());
            request.setAttribute("serviceTypes", List.of());
            request.setAttribute("wards", List.of());
            request.setAttribute("documents", List.of());
            request.setAttribute("applicationDocuments", List.of());
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

    /**
     * Populates request attributes that every citizen page leans on:
     * notification list and unread count, application counters (total,
     * approved, pending), and certificate count. These feed sidebar badges
     * and dashboard widgets.
     *
     * @param request   the incoming request
     * @param conn      open JDBC connection
     * @param citizenId the logged-in citizen's primary key
     * @throws SQLException if a lookup fails
     */
    private void loadSharedCitizenData(HttpServletRequest request, Connection conn, int citizenId) throws SQLException {
        NotificationDAOInterface notificationDAO = new NotificationDAO(conn);
        List<Notification> notifications = notificationDAO.findByCitizenId(citizenId);
        ApplicationDAOInterface applicationDAO = new ApplicationDAO(conn);
        List<Application> applications = applicationDAO.findByCitizenId(citizenId);
        request.setAttribute("sharedNotifications", notifications);
        request.setAttribute("unreadCount", notificationDAO.countUnreadByCitizenId(citizenId));
        request.setAttribute("applicationCount", applications.size());
        request.setAttribute("approvedApplicationCount",
                applications.stream().filter(a -> "approved".equals(a.getStatus())).count());
        request.setAttribute("pendingApplicationCount",
                applications.stream().filter(a -> "submitted".equals(a.getStatus()) || "review".equals(a.getStatus())).count());
        IssuedCertificateDAOInterface certificateDAO = new IssuedCertificateDAO(conn);
        request.setAttribute("certificateCount", certificateDAO.findByCitizenId(citizenId).size());
    }
}
