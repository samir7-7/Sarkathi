package Controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

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
        String target = PAGE_MAPPINGS.get(servletPath);

        if (target == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(target);
        dispatcher.forward(request, response);
    }
}
