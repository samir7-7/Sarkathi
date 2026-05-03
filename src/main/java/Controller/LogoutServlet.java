package Controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles {@code GET /logout}: invalidates the current session (if any) and
 * redirects the user back to the login page.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "logoutServlet", urlPatterns = "/logout")
public class LogoutServlet extends HttpServlet {
    /**
     * Tears down the session and redirects to {@code /login}. Calling this
     * when there's no active session is harmless — we simply skip the
     * invalidate and still send the redirect.
     *
     * @param request  the incoming request
     * @param response used to issue the redirect
     * @throws IOException if writing the redirect fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
