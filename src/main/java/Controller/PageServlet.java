package Controller;

import java.io.IOException;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "pageServlet", urlPatterns = {"/", "/index.jsp", "/login.jsp", "/register.jsp"})
public class PageServlet extends HttpServlet {
    private static final Map<String, String> PAGE_MAPPINGS = Map.of(
            "/", "/WEB-INF/index.jsp",
            "/index.jsp", "/WEB-INF/index.jsp",
            "/login.jsp", "/WEB-INF/login.jsp",
            "/register.jsp", "/WEB-INF/register.jsp"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        
        // Handle empty path (root request) or missing servlet path
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
