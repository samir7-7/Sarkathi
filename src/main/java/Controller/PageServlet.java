package Controller;

import DAO.impl.AgricultureNoticeDAO;
import DAO.impl.AnnouncementDAO;
import DAO.impl.ApplicationDAO;
import DAO.impl.BudgetAllocationDAO;
import Model.Application;
import Util.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "pageServlet", urlPatterns = {
    "/", "/index.jsp", "/login.jsp", "/register.jsp",
    "/announcements", "/agriculture", "/budget", "/crop-advisory", "/track"
})
public class PageServlet extends HttpServlet {
    private static final Map<String, String> PAGE_MAPPINGS = Map.ofEntries(
            Map.entry("/", "/WEB-INF/pages/index.jsp"),
            Map.entry("/index.jsp", "/WEB-INF/pages/index.jsp"),
            Map.entry("/login.jsp", "/WEB-INF/pages/login.jsp"),
            Map.entry("/register.jsp", "/WEB-INF/pages/register.jsp"),
            Map.entry("/announcements", "/WEB-INF/pages/announcements.jsp"),
            Map.entry("/agriculture", "/WEB-INF/pages/agriculture.jsp"),
            Map.entry("/budget", "/WEB-INF/pages/budget.jsp"),
            Map.entry("/crop-advisory", "/WEB-INF/pages/crop-advisory.jsp"),
            Map.entry("/track", "/WEB-INF/pages/tracking.jsp")
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if (servletPath == null || servletPath.isEmpty() || "/".equals(servletPath)) {
            servletPath = "/";
        }
        String target = PAGE_MAPPINGS.get(servletPath);
        if (target == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("/announcements".equals(servletPath)) {
                request.setAttribute("announcements", new AnnouncementDAO(conn).findAll());
            } else if ("/agriculture".equals(servletPath)) {
                request.setAttribute("notices", new AgricultureNoticeDAO(conn).findAll());
            } else if ("/budget".equals(servletPath)) {
                request.setAttribute("budgets", new BudgetAllocationDAO(conn).findAll());
            } else if ("/crop-advisory".equals(servletPath)) {
                request.setAttribute("recommendations", cropRecommendations());
            } else if ("/track".equals(servletPath)) {
                String trackingId = request.getParameter("trackingId");
                if (trackingId != null && !trackingId.isBlank()) {
                    Application application = new ApplicationDAO(conn).findByTrackingId(trackingId.trim()).orElse(null);
                    request.setAttribute("trackingResult", application);
                    request.setAttribute("trackingSearched", true);
                }
            }
        } catch (SQLException e) {
            request.setAttribute("pageError", "Unable to load page data.");
            request.setAttribute("announcements", List.of());
            request.setAttribute("notices", List.of());
            request.setAttribute("budgets", List.of());
            request.setAttribute("recommendations", cropRecommendations());
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher(target);
        dispatcher.forward(request, response);
    }

    private Map<String, Map<String, List<String[]>>> cropRecommendations() {
        Map<String, Map<String, List<String[]>>> recommendations = new LinkedHashMap<>();
        Map<String, List<String[]>> flatland = new LinkedHashMap<>();
        flatland.put("spring", List.of(new String[]{"Rice (Paddy)", "Main staple crop, transplant in monsoon-ready fields", "120-150 days"}, new String[]{"Maize", "Versatile cereal for food and fodder", "90-120 days"}, new String[]{"Jute", "Cash crop for fiber production", "100-120 days"}));
        flatland.put("summer", List.of(new String[]{"Rice (Paddy)", "Peak season for lowland rice cultivation", "120-150 days"}, new String[]{"Sugarcane", "Long-duration cash crop", "270-365 days"}, new String[]{"Vegetables (Cucumber, Bottle Gourd)", "Quick income from vegetable farming", "60-90 days"}));
        flatland.put("autumn", List.of(new String[]{"Wheat", "Winter cereal, sow after rice harvest", "120-150 days"}, new String[]{"Mustard", "Oilseed crop for winter season", "90-120 days"}, new String[]{"Lentil (Masoor)", "Protein-rich pulse crop", "100-120 days"}));
        flatland.put("winter", List.of(new String[]{"Wheat", "Continue winter wheat cultivation", "120-150 days"}, new String[]{"Potato", "High-value root vegetable", "90-120 days"}, new String[]{"Pea", "Cool-season legume", "60-90 days"}));
        recommendations.put("flatland", flatland);

        Map<String, List<String[]>> hilly = new LinkedHashMap<>();
        hilly.put("spring", List.of(new String[]{"Maize", "Primary cereal for hill regions", "90-120 days"}, new String[]{"Millet (Kodo/Kaguno)", "Drought-tolerant grain", "90-120 days"}, new String[]{"Ginger", "High-value spice crop", "240-270 days"}));
        hilly.put("summer", List.of(new String[]{"Rice (Upland)", "Direct-seeded rice on terraces", "120-150 days"}, new String[]{"Cardamom", "Cash crop under shade trees", "Perennial"}, new String[]{"Turmeric", "Spice and medicinal crop", "210-270 days"}));
        hilly.put("autumn", List.of(new String[]{"Wheat", "Winter cereal for mid-hills", "120-150 days"}, new String[]{"Barley", "Hardy cereal for higher elevations", "100-120 days"}, new String[]{"Rapeseed", "Oilseed for cool-season", "90-120 days"}));
        hilly.put("winter", List.of(new String[]{"Potato", "Cool-climate root crop", "90-120 days"}, new String[]{"Cabbage", "Cold-hardy vegetable", "80-100 days"}, new String[]{"Garlic", "High-value allium crop", "120-150 days"}));
        recommendations.put("hilly", hilly);

        Map<String, List<String[]>> mountain = new LinkedHashMap<>();
        mountain.put("spring", List.of(new String[]{"Buckwheat", "Short-season grain for high altitude", "60-90 days"}, new String[]{"Barley", "Cold-tolerant cereal", "100-120 days"}, new String[]{"Apple", "Temperate fruit for mountains", "Perennial"}));
        mountain.put("summer", List.of(new String[]{"Potato", "High-altitude potato cultivation", "90-120 days"}, new String[]{"Amaranth", "Nutritious pseudo-cereal", "60-90 days"}, new String[]{"Beans", "Nitrogen-fixing legume", "60-90 days"}));
        mountain.put("autumn", List.of(new String[]{"Buckwheat", "Second season buckwheat", "60-90 days"}, new String[]{"Radish", "Quick-growing root vegetable", "40-60 days"}, new String[]{"Turnip", "Cold-hardy root crop", "40-60 days"}));
        mountain.put("winter", List.of(new String[]{"Limited Options", "Most mountain areas under snow cover", "N/A"}, new String[]{"Greenhouse Vegetables", "Tomato, capsicum under protection", "60-90 days"}, new String[]{"Mushroom", "Indoor cultivation possible year-round", "30-60 days"}));
        recommendations.put("mountain", mountain);
        return recommendations;
    }
}
