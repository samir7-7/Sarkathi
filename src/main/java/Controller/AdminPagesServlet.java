package Controller;

import DAO.AgricultureNoticeDAO;
import DAO.AnnouncementDAO;
import DAO.ApplicationDAO;
import DAO.ApplicationDocumentDAO;
import DAO.BudgetAllocationDAO;
import DAO.CitizenDAO;
import DAO.CitizenDocumentVaultDAO;
import DAO.ServiceTypeDAO;
import DAO.WardDAO;
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
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("/admin/notices".equals(path)) {
                request.setAttribute("notices", new AgricultureNoticeDAO(conn).findAll());
            } else if ("/admin/announcements".equals(path)) {
                request.setAttribute("announcements", new AnnouncementDAO(conn).findAll());
            } else if ("/admin/budgets".equals(path)) {
                request.setAttribute("budgets", new BudgetAllocationDAO(conn).findAll());
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

    private void loadApplications(HttpServletRequest request, Connection conn) throws SQLException {
        List<Application> applications = new ApplicationDAO(conn).findAll();
        request.setAttribute("applications", applications);
        request.setAttribute("citizensById", mapCitizens(new CitizenDAO(conn).findAll()));
        request.setAttribute("servicesById", mapServices(new ServiceTypeDAO(conn).findAll(false)));
        request.setAttribute("wardsById", mapWards(new WardDAO(conn).findAll()));
        ApplicationDocumentDAO documentDAO = new ApplicationDocumentDAO(conn);
        CitizenDocumentVaultDAO vaultDAO = new CitizenDocumentVaultDAO(conn);
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

    private Map<Integer, Citizen> mapCitizens(List<Citizen> citizens) {
        Map<Integer, Citizen> map = new HashMap<>();
        for (Citizen citizen : citizens) {
            map.put(citizen.getCitizenId(), citizen);
        }
        return map;
    }

    private Map<Integer, ServiceType> mapServices(List<ServiceType> services) {
        Map<Integer, ServiceType> map = new HashMap<>();
        for (ServiceType service : services) {
            map.put(service.getServiceTypeId(), service);
        }
        return map;
    }

    private Map<Integer, Ward> mapWards(List<Ward> wards) {
        Map<Integer, Ward> map = new HashMap<>();
        for (Ward ward : wards) {
            map.put(ward.getWardId(), ward);
        }
        return map;
    }
}
