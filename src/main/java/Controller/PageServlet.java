package Controller;

import java.io.IOException;
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
            Map.entry("/", "/WEB-INF/index.jsp"),
            Map.entry("/index.jsp", "/WEB-INF/index.jsp"),
            Map.entry("/login.jsp", "/WEB-INF/login.jsp"),
            Map.entry("/register.jsp", "/WEB-INF/register.jsp"),
            Map.entry("/announcements", "/WEB-INF/announcements.jsp"),
            Map.entry("/agriculture", "/WEB-INF/agriculture.jsp"),
            Map.entry("/budget", "/WEB-INF/budget.jsp"),
            Map.entry("/crop-advisory", "/WEB-INF/crop-advisory.jsp"),
            Map.entry("/track", "/WEB-INF/tracking.jsp")
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
        RequestDispatcher dispatcher = request.getRequestDispatcher(target);
        dispatcher.forward(request, response);
    }
}
