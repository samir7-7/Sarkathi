package Controller;

import DAO.impl.AdminUserDAO;
import DAO.impl.CitizenDAO;
import Model.AdminUser;
import Model.Citizen;
import Util.CookieUtil;
import Util.DatabaseConnection;
import Util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;
import java.util.regex.Pattern;

/**
 * Form-based login for both citizens and admins. The single endpoint dispatches
 * based on the {@code userType} parameter — citizens go to the citizen table,
 * admins to the admin table — and on success drops a 30-minute session cookie
 * with role-specific attributes.
 * <p>
 * Failed logins re-render the login page with a generic error so we don't leak
 * which half of the credential pair was wrong.
 *
 * @author SarkarSathi
 */
@WebServlet(name = "loginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final int REMEMBER_ME_MAX_AGE = 30 * 24 * 60 * 60;

    /**
     * Renders the login page. Honours the {@code userType} query parameter so
     * that links from the navbar can pre-select the citizen or admin tab.
     * Defaults to citizen when nothing is supplied.
     *
     * @param request  the incoming request
     * @param response the page response
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userType = request.getParameter("userType");
        String rememberedUserType = decodeCookie(request, CookieUtil.REMEMBER_USER_TYPE_COOKIE);
        String rememberedEmail = decodeCookie(request, CookieUtil.REMEMBER_EMAIL_COOKIE);
        boolean remembered = CookieUtil.getCookieValue(request, CookieUtil.REMEMBER_FLAG_COOKIE)
                .map("true"::equalsIgnoreCase)
                .orElse(false);

        if (userType == null || userType.isBlank()) {
            userType = rememberedUserType == null || rememberedUserType.isBlank() ? "citizen" : rememberedUserType;
        }

        request.setAttribute("userType", userType.trim().toLowerCase());
        request.setAttribute("email", rememberedEmail);
        request.setAttribute("rememberMe", remembered);
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    /**
     * Handles the login form submission. Performs basic email-format validation
     * before delegating to the role-specific helper. Any database error is
     * surfaced to the user as a generic system message.
     *
     * @param request  the incoming request
     * @param response the response (redirect on success, forward on failure)
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        boolean rememberMe = "on".equalsIgnoreCase(request.getParameter("rememberMe"))
                || "true".equalsIgnoreCase(request.getParameter("rememberMe"));

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            forwardToLogin(request, response, "Email and password are required.", email, userType, rememberMe);
            return;
        }

        email = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            forwardToLogin(request, response, "Please enter a valid email address.", email, userType, rememberMe);
            return;
        }
        if (userType == null || userType.isBlank()) {
            userType = "citizen";
        }
        userType = userType.trim().toLowerCase();

        try (Connection connection = DatabaseConnection.getConnection()) {
            if ("admin".equals(userType)) {
                handleAdminLogin(request, response, connection, email, password, rememberMe);
            } else {
                handleCitizenLogin(request, response, connection, email, password, rememberMe);
            }
        } catch (SQLException e) {
            forwardToLogin(request, response, "A system error occurred. Please try again later.", email, userType,
                    rememberMe);
        }
    }

    /**
     * Authenticates against the admin table and, on success, populates the
     * session with admin-specific attributes ({@code adminId}, {@code adminRole})
     * before redirecting to the admin dashboard.
     *
     * @param request    the incoming request
     * @param response   the response
     * @param connection an open JDBC connection
     * @param email      normalised admin email
     * @param password   raw password from the form
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     * @throws SQLException     if the lookup fails
     */
    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response,
            Connection connection, String email, String password, boolean rememberMe)
            throws ServletException, IOException, SQLException {

        AdminUserDAO adminUserDAO = new AdminUserDAO(connection);
        Optional<AdminUser> adminUser = adminUserDAO.findByEmail(email);

        if (adminUser.isPresent() && PasswordUtil.matches(password, adminUser.get().getPasswordHash())) {
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(30 * 60);
            session.setAttribute("role", "admin");
            session.setAttribute("adminId", adminUser.get().getAdminId());
            session.setAttribute("fullName", adminUser.get().getFullName());
            session.setAttribute("displayName", adminUser.get().getFullName());
            session.setAttribute("email", adminUser.get().getEmail());
            session.setAttribute("adminRole", adminUser.get().getRole());
            syncRememberMeCookies(request, response, email, "admin", rememberMe);

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            forwardToLogin(request, response, "Invalid admin credentials. Please check your email and password.", email,
                    "admin", rememberMe);
        }
    }

    /**
     * Authenticates against the citizen table and, on success, populates the
     * session with citizen-specific attributes before redirecting to the
     * citizen dashboard.
     *
     * @param request    the incoming request
     * @param response   the response
     * @param connection an open JDBC connection
     * @param email      normalised citizen email
     * @param password   raw password from the form
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     * @throws SQLException     if the lookup fails
     */
    private void handleCitizenLogin(HttpServletRequest request, HttpServletResponse response,
            Connection connection, String email, String password, boolean rememberMe)
            throws ServletException, IOException, SQLException {

        CitizenDAO citizenDAO = new CitizenDAO(connection);
        Optional<Citizen> citizen = citizenDAO.findByEmail(email);

        if (citizen.isPresent() && PasswordUtil.matches(password, citizen.get().getPasswordHash())) {
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(30 * 60);
            session.setAttribute("role", "citizen");
            session.setAttribute("citizenId", citizen.get().getCitizenId());
            session.setAttribute("fullName", citizen.get().getFullName());
            session.setAttribute("displayName", citizen.get().getFullName());
            session.setAttribute("email", citizen.get().getEmail());
            syncRememberMeCookies(request, response, email, "citizen", rememberMe);

            response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
        } else {
            forwardToLogin(request, response, "Invalid credentials. Please check your email and password.", email,
                    "citizen", rememberMe);
        }
    }

    /**
     * Re-renders the login page after a failed attempt, preserving what the
     * user entered (minus the password) so they don't have to retype the
     * non-secret fields.
     *
     * @param request  the incoming request
     * @param response the response
     * @param error    the message to show above the form
     * @param email    the email the user typed (echoed back into the form)
     * @param userType the tab to keep selected ("citizen" or "admin")
     * @throws ServletException if forwarding fails
     * @throws IOException      if writing fails
     */
    private void forwardToLogin(HttpServletRequest request, HttpServletResponse response,
            String error, String email, String userType, boolean rememberMe)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("email", email);
        request.setAttribute("rememberMe", rememberMe);
        request.setAttribute("userType",
                userType == null || userType.isBlank() ? "citizen" : userType.trim().toLowerCase());
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    private void syncRememberMeCookies(HttpServletRequest request, HttpServletResponse response,
            String email, String userType, boolean rememberMe) {
        if (rememberMe) {
            CookieUtil.addCookie(request, response, CookieUtil.REMEMBER_EMAIL_COOKIE, email, REMEMBER_ME_MAX_AGE);
            CookieUtil.addCookie(request, response, CookieUtil.REMEMBER_USER_TYPE_COOKIE, userType,
                    REMEMBER_ME_MAX_AGE);
            CookieUtil.addCookie(request, response, CookieUtil.REMEMBER_FLAG_COOKIE, "true", REMEMBER_ME_MAX_AGE);
            return;
        }

        CookieUtil.clearCookie(request, response, CookieUtil.REMEMBER_EMAIL_COOKIE);
        CookieUtil.clearCookie(request, response, CookieUtil.REMEMBER_USER_TYPE_COOKIE);
        CookieUtil.clearCookie(request, response, CookieUtil.REMEMBER_FLAG_COOKIE);
    }

    private String decodeCookie(HttpServletRequest request, String cookieName) {
        return CookieUtil.getCookieValue(request, cookieName)
                .map(value -> URLDecoder.decode(value, StandardCharsets.UTF_8))
                .orElse(null);
    }
}
