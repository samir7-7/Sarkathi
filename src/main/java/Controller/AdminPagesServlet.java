package Controller;

import DAO.impl.AgricultureNoticeDAO;
import DAO.interfaces.AgricultureNoticeDAOInterface;
import DAO.impl.AnnouncementDAO;
import DAO.interfaces.AnnouncementDAOInterface;
import DAO.impl.ApplicationDAO;
import DAO.impl.ApplicationDocumentDAO;
import DAO.interfaces.ApplicationDocumentDAOInterface;
import DAO.interfaces.ApplicationDAOInterface;
import DAO.impl.BudgetAllocationDAO;
import DAO.interfaces.BudgetAllocationDAOInterface;
import DAO.impl.CitizenDAO;
import DAO.interfaces.CitizenDAOInterface;
import DAO.impl.CitizenDocumentVaultDAO;
import DAO.interfaces.CitizenDocumentVaultDAOInterface;
import DAO.impl.ServiceTypeDAO;
import DAO.interfaces.ServiceTypeDAOInterface;
import DAO.impl.WardDAO;
import DAO.interfaces.WardDAOInterface;
import Model.Application;
import Model.ApplicationDocument;
import Model.Citizen;
import Model.CitizenDocumentVault;
import Model.ServiceType;
import Model.Ward;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Page-loading dispatcher for the admin section. Each URL pulls the data its
 * JSP needs (notices, announcements, budgets, applications) and forwards to
 * the matching view under {@code /WEB-INF/admin/}. The whole servlet is
 * gated by an inline session check on top of the global filter — belt and
 * braces.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "adminPagesServlet", urlPatterns = {
    "/admin/applications", "/admin/notices", "/admin/announcements", "/admin/budgets"
})
public class AdminPagesServlet extends HttpServlet {
    /**
     * Routes the request to the right admin view, prefetching whatever the
     * page needs. Database failures degrade gracefully — the page renders
     * with empty lists and a banner instead of a 500.
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
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?userType=admin");
            return;
        }

        request.setAttribute("adminId", session.getAttribute("adminId"));
        request.setAttribute("adminName", session.getAttribute("fullName"));
        request.setAttribute("adminEmail", session.getAttribute("email"));
        request.setAttribute("adminRole", session.getAttribute("adminRole"));

        String path = request.getServletPath();
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("/admin/notices".equals(path)) {
                AgricultureNoticeDAOInterface noticeDAO = new AgricultureNoticeDAO(conn);
                request.setAttribute("notices", noticeDAO.findAll());
            } else if ("/admin/announcements".equals(path)) {
                AnnouncementDAOInterface announcementDAO = new AnnouncementDAO(conn);
                request.setAttribute("announcements", announcementDAO.findAll());
            } else if ("/admin/budgets".equals(path)) {
                BudgetAllocationDAOInterface budgetDAO = new BudgetAllocationDAO(conn);
                request.setAttribute("budgets", budgetDAO.findAll());
            } else if ("/admin/applications".equals(path)) {
                loadApplications(request, conn);
            }
        } catch (SQLException e) {
            request.setAttribute("pageError", "Unable to load page data.");
            request.setAttribute("notices", List.of());
            request.setAttribute("announcements", List.of());
            request.setAttribute("budgets", List.of());
            request.setAttribute("applications", List.of());
        }

        String jsp = switch (path) {
            case "/admin/applications" -> "/WEB-INF/admin/applications.jsp";
            case "/admin/notices" -> "/WEB-INF/admin/notices.jsp";
            case "/admin/announcements" -> "/WEB-INF/admin/announcements.jsp";
            case "/admin/budgets" -> "/WEB-INF/admin/budgets.jsp";
            default -> "/WEB-INF/admin/dashboard.jsp";
        };

        request.getRequestDispatcher(jsp).forward(request, response);
    }

    /**
     * Loads the data the applications page needs: every application, plus
     * lookup maps for citizens, services, and wards, plus per-application
     * documents and per-citizen vault documents. We do this in code rather
     * than via SQL joins because the vault join in particular is awkward to
     * shape into a single query.
     *
     * @param request the incoming request (attributes go here)
     * @param conn    open JDBC connection
     * @throws SQLException if any lookup fails
     */
    private void loadApplications(HttpServletRequest request, Connection conn) throws SQLException {
        ApplicationDAOInterface applicationDAO = new ApplicationDAO(conn);
        CitizenDAOInterface citizenDAO = new CitizenDAO(conn);
        ServiceTypeDAOInterface serviceTypeDAO = new ServiceTypeDAO(conn);
        WardDAOInterface wardDAO = new WardDAO(conn);
        List<Application> applications = applicationDAO.findAll();
        request.setAttribute("applications", applications);
        request.setAttribute("citizensById", mapCitizens(citizenDAO.findAll()));
        request.setAttribute("servicesById", mapServices(serviceTypeDAO.findAll(false)));
        request.setAttribute("wardsById", mapWards(wardDAO.findAll()));
        ApplicationDocumentDAOInterface documentDAO = new ApplicationDocumentDAO(conn);
        CitizenDocumentVaultDAOInterface vaultDAO = new CitizenDocumentVaultDAO(conn);
        Map<Integer, List<ApplicationDocument>> documentsByApplicationId = new HashMap<>();
        Map<Integer, List<CitizenDocumentVault>> vaultDocumentsByCitizenId = new HashMap<>();
        for (Application application : applications) {
            documentsByApplicationId.put(application.getApplicationId(),
                    documentDAO.findByApplicationId(application.getApplicationId()));
            vaultDocumentsByCitizenId.computeIfAbsent(application.getCitizenId(), citizenId -> {
                try {
                    return vaultDAO.findByCitizenId(citizenId);
                } catch (SQLException e) {
                    return List.of();
                }
            });
        }
        request.setAttribute("documentsByApplicationId", documentsByApplicationId);
        request.setAttribute("vaultDocumentsByCitizenId", vaultDocumentsByCitizenId);
    }

    /**
     * Indexes citizens by ID for cheap lookups inside the JSP.
     *
     * @param citizens citizen list
     * @return map keyed by citizen ID
     */
    private Map<Integer, Citizen> mapCitizens(List<Citizen> citizens) {
        Map<Integer, Citizen> map = new HashMap<>();
        for (Citizen citizen : citizens) {
            map.put(citizen.getCitizenId(), citizen);
        }
        return map;
    }

    /**
     * Indexes service types by ID.
     *
     * @param services service-type list
     * @return map keyed by service-type ID
     */
    private Map<Integer, ServiceType> mapServices(List<ServiceType> services) {
        Map<Integer, ServiceType> map = new HashMap<>();
        for (ServiceType service : services) {
            map.put(service.getServiceTypeId(), service);
        }
        return map;
    }

    /**
     * Indexes wards by ID.
     *
     * @param wards ward list
     * @return map keyed by ward ID
     */
    private Map<Integer, Ward> mapWards(List<Ward> wards) {
        Map<Integer, Ward> map = new HashMap<>();
        for (Ward ward : wards) {
            map.put(ward.getWardId(), ward);
        }
        return map;
    }
}
