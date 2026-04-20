package Controller;

import DAO.AdminUserDAO;
import DAO.CitizenDAO;
import Model.AdminUser;
import Model.Citizen;
import Util.DatabaseConnection;
import Util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet(name = "loginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private void renderLoginPage(HttpServletRequest request, HttpServletResponse response, String error) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String userType = request.getParameter("userType");
        if (userType == null) userType = "citizen";
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"en\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>SarkarSathi - Login</title>");
        out.println("    <script src=\"https://cdn.tailwindcss.com\"></script>");
        out.println("    <style>");
        out.println("        @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap');");
        out.println("        body { font-family: 'Outfit', sans-serif; }");
        out.println("        .role-toggle { position: relative; display: flex; background: #eef1f6; border-radius: 14px; padding: 4px; }");
        out.println("        .role-toggle input[type=\"radio\"] { display: none; }");
        out.println("        .role-toggle label { flex: 1; text-align: center; padding: 10px 0; font-size: 14px; font-weight: 600; color: #64748b; cursor: pointer; border-radius: 11px; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); z-index: 1; user-select: none; }");
        out.println("        .role-toggle input[type=\"radio\"]:checked + label { color: #fff; background: #154a91; box-shadow: 0 2px 12px rgba(21, 74, 145, 0.35); }");
        out.println("        @keyframes shake { 0%, 100% { transform: translateX(0); } 20%, 60% { transform: translateX(-6px); } 40%, 80% { transform: translateX(6px); } }");
        out.println("        .shake { animation: shake 0.4s ease-in-out; }");
        out.println("        @keyframes fadeInUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }");
        out.println("        .fade-in { animation: fadeInUp 0.5s ease-out forwards; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body class=\"min-h-screen bg-slate-100 text-slate-900\">");
        out.println("    <div class=\"flex min-h-screen flex-col\">");
        out.println("        <main class=\"grid flex-1 lg:grid-cols-2\">");
        out.println("            <section class=\"relative hidden overflow-hidden lg:flex\">");
        out.println("                <img src=\"https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1600&auto=format&fit=crop\" alt=\"City skyline\" class=\"absolute inset-0 h-full w-full object-cover\">");
        out.println("                <div class=\"absolute inset-0 bg-[#0f4ea8]/85\"></div>");
        out.println("                <div class=\"absolute inset-0 bg-gradient-to-b from-[#0f4ea8]/55 via-[#0f4ea8]/60 to-[#062e69]/90\"></div>");
        out.println("                <div class=\"relative flex h-full w-full flex-col justify-between px-12 py-16 text-white\">");
        out.println("                    <div class=\"max-w-xl pt-12\">");
        out.println("                        <h1 class=\"text-4xl lg:text-5xl font-bold leading-tight tracking-tight\">Empowering<br>Citizens, Building<br>Cities.</h1>");
        out.println("                        <p class=\"mt-6 max-w-lg text-lg leading-relaxed text-blue-100/90\">Connecting you to municipal excellence through a unified digital gateway. Experience governance that works for you.</p>");
        out.println("                    </div>");
        out.println("                    <div class=\"pb-8\">");
        out.println("                        <div class=\"inline-flex items-center gap-2 rounded-full border border-white/25 bg-white/10 px-5 py-2.5 text-xs font-semibold uppercase tracking-widest text-white shadow-lg shadow-slate-950/20 backdrop-blur-sm\">");
        out.println("                            <svg class=\"h-4 w-4\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\"><path d=\"M22 11.08V12a10 10 0 1 1-5.93-9.14\"></path><polyline points=\"22 4 12 14.01 9 11.01\"></polyline></svg>");
        out.println("                            Official Portal");
        out.println("                        </div>");
        out.println("                    </div>");
        out.println("                </div>");
        out.println("            </section>");
        out.println("            <section class=\"flex items-center justify-center bg-[#f7f7fb] px-6 py-12 lg:px-12\">");
        out.println("                <div class=\"w-full max-w-md fade-in\">");
        out.println("                    <div>");
        out.println("                        <div class=\"flex h-16 w-16 items-center justify-center rounded-full bg-[#154a91] text-white shadow-lg shadow-blue-950/20\">");
        out.println("                            <svg class=\"h-8 w-8\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\"><path d=\"M3 21h18\"></path><path d=\"M5 21v-4\"></path><path d=\"M19 21v-4\"></path><path d=\"M7 17v-4\"></path><path d=\"M17 17v-4\"></path><path d=\"M12 17v-4\"></path><path d=\"M3 13L12 4l9 9\"></path></svg>");
        out.println("                        </div>");
        out.println("                        <h2 class=\"mt-8 text-4xl font-bold tracking-tight text-[#0b3d86]\">SarkarSathi</h2>");
        out.println("                        <p class=\"mt-4 text-base text-slate-700\">Access your municipal services with ease. Please login to your account.</p>");
        out.println("                    </div>");
        out.println("                    <div class=\"mt-8 rounded-2xl bg-white px-6 py-8 shadow-[0_20px_60px_rgba(15,23,42,0.08)] sm:px-8\">");
        
        if (error != null) {
            out.println("                        <div id=\"error-alert\" class=\"mb-5 flex items-center gap-3 rounded-xl border border-red-200 bg-red-50 px-4 py-3 shake\">");
            out.println("                            <svg class=\"h-5 w-5 shrink-0 text-red-500\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"12\" r=\"10\"></circle><line x1=\"15\" y1=\"9\" x2=\"9\" y2=\"15\"></line><line x1=\"9\" y1=\"9\" x2=\"15\" y2=\"15\"></line></svg>");
            out.println("                            <p class=\"text-sm font-medium text-red-700\">" + error + "</p>");
            out.println("                        </div>");
        }
        
        out.println("                        <div class=\"mb-6\">");
        out.println("                            <p class=\"mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800\">Login As</p>");
        out.println("                            <div class=\"role-toggle\" id=\"role-toggle\">");
        out.println("                                <input type=\"radio\" name=\"roleToggle\" id=\"role-citizen\" value=\"citizen\" " + ("citizen".equals(userType) ? "checked" : "") + ">");
        out.println("                                <label for=\"role-citizen\">");
        out.println("                                    <span class=\"inline-flex items-center gap-1.5\">");
        out.println("                                        <svg class=\"h-4 w-4\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2\"></path><circle cx=\"12\" cy=\"7\" r=\"4\"></circle></svg>");
        out.println("                                        Citizen");
        out.println("                                    </span>");
        out.println("                                </label>");
        out.println("                                <input type=\"radio\" name=\"roleToggle\" id=\"role-admin\" value=\"admin\" " + ("admin".equals(userType) ? "checked" : "") + ">");
        out.println("                                <label for=\"role-admin\">");
        out.println("                                    <span class=\"inline-flex items-center gap-1.5\">");
        out.println("                                        <svg class=\"h-4 w-4\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z\"></path></svg>");
        out.println("                                        Admin");
        out.println("                                    </span>");
        out.println("                                </label>");
        out.println("                            </div>");
        out.println("                        </div>");
        out.println("                        <form id=\"login-form\" action=\"" + request.getContextPath() + "/login\" method=\"post\" class=\"space-y-6\">");
        out.println("                            <input type=\"hidden\" name=\"userType\" id=\"userType\" value=\"" + userType + "\">");
        out.println("                            <div>");
        out.println("                                <label for=\"email\" class=\"mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800\">Email Address</label>");
        out.println("                                <input id=\"email\" type=\"email\" name=\"email\" placeholder=\"name@example.com\" required class=\"w-full rounded-xl border border-slate-200 bg-[#f4f5fa] px-4 py-3 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100\">");
        out.println("                            </div>");
        out.println("                            <div>");
        out.println("                                <div class=\"mb-2 flex items-center justify-between gap-4\">");
        out.println("                                    <label for=\"password\" class=\"block text-xs font-semibold uppercase tracking-wider text-slate-800\">Password</label>");
        out.println("                                    <a href=\"#\" class=\"text-xs font-semibold text-[#0b3d86] transition hover:text-[#154a91]\">Forgot Password?</a>");
        out.println("                                </div>");
        out.println("                                <input id=\"password\" type=\"password\" name=\"password\" placeholder=\"••••••••\" required class=\"w-full rounded-xl border border-slate-200 bg-[#f4f5fa] px-4 py-3 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100\">");
        out.println("                            </div>");
        out.println("                            <button type=\"submit\" id=\"login-btn\" class=\"inline-flex w-full items-center justify-center gap-2 rounded-xl bg-[#154a91] px-5 py-3 text-base font-semibold text-white shadow-md transition hover:bg-[#103b74] focus:outline-none focus:ring-2 focus:ring-blue-200 focus:ring-offset-1\">");
        out.println("                                <span id=\"btn-text\">" + ("admin".equals(userType) ? "Login as Admin" : "Login to Dashboard") + "</span>");
        out.println("                                <svg class=\"h-4 w-4\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\"><line x1=\"5\" y1=\"12\" x2=\"19\" y2=\"12\"></line><polyline points=\"12 5 19 12 12 19\"></polyline></svg>");
        out.println("                            </button>");
        out.println("                        </form>");
        out.println("                        <div id=\"register-link\" class=\"mt-8 border-t border-slate-100 pt-6 text-center text-sm text-slate-600\" " + ("admin".equals(userType) ? "style=\"display: none;\"" : "") + ">");
        out.println("                            Don't have an account?");
        out.println("                            <a href=\"#\" class=\"ml-1 font-semibold text-[#157a2f] transition hover:text-[#0f5d24]\">Register as a Citizen</a>");
        out.println("                        </div>");
        out.println("                    </div>");
        out.println("                    <div class=\"mt-8 flex items-center justify-center gap-2 text-[10px] font-semibold uppercase tracking-widest text-slate-400\">");
        out.println("                        <svg class=\"h-3 w-3\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" aria-hidden=\"true\"><path d=\"M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z\"></path></svg>");
        out.println("                        Secure Government Portal &bull; Data Encrypted");
        out.println("                    </div>");
        out.println("                </div>");
        out.println("            </section>");
        out.println("        </main>");
        out.println("    </div>");
        out.println("    <script>");
        out.println("        const citizenRadio = document.getElementById('role-citizen');");
        out.println("        const adminRadio = document.getElementById('role-admin');");
        out.println("        const userTypeInput = document.getElementById('userType');");
        out.println("        const btnText = document.getElementById('btn-text');");
        out.println("        const registerLink = document.getElementById('register-link');");
        out.println("        function updateRole() {");
        out.println("            if (adminRadio.checked) {");
        out.println("                userTypeInput.value = 'admin';");
        out.println("                btnText.textContent = 'Login as Admin';");
        out.println("                registerLink.style.display = 'none';");
        out.println("            } else {");
        out.println("                userTypeInput.value = 'citizen';");
        out.println("                btnText.textContent = 'Login to Dashboard';");
        out.println("                registerLink.style.display = 'block';");
        out.println("            }");
        out.println("        }");
        out.println("        citizenRadio.addEventListener('change', updateRole);");
        out.println("        adminRadio.addEventListener('change', updateRole);");
        out.println("    </script>");
        out.println("</body>");
        out.println("</html>");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        renderLoginPage(request, response, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            renderLoginPage(request, response, "Email and password are required.");
            return;
        }

        email = email.trim();
        if (userType == null || userType.isBlank()) {
            userType = "citizen";
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            if ("admin".equalsIgnoreCase(userType)) {
                handleAdminLogin(request, response, connection, email, password);
            } else {
                handleCitizenLogin(request, response, connection, email, password);
            }
        } catch (SQLException e) {
            renderLoginPage(request, response, "A system error occurred. Please try again later.");
        }
    }

    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response,
                                  Connection connection, String email, String password)
            throws ServletException, IOException, SQLException {

        AdminUserDAO adminUserDAO = new AdminUserDAO(connection);
        Optional<AdminUser> adminUser = adminUserDAO.findByEmail(email);

        if (adminUser.isPresent() && PasswordUtil.matches(password, adminUser.get().getPasswordHash())) {
            HttpSession session = request.getSession(true);
            session.setAttribute("role", "admin");
            session.setAttribute("adminId", adminUser.get().getAdminId());
            session.setAttribute("fullName", adminUser.get().getFullName());
            session.setAttribute("email", adminUser.get().getEmail());
            session.setAttribute("adminRole", adminUser.get().getRole());

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            renderLoginPage(request, response, "Invalid admin credentials. Please check your email and password.");
        }
    }

    private void handleCitizenLogin(HttpServletRequest request, HttpServletResponse response,
                                    Connection connection, String email, String password)
            throws ServletException, IOException, SQLException {

        CitizenDAO citizenDAO = new CitizenDAO(connection);
        Optional<Citizen> citizen = citizenDAO.findByEmail(email);

        if (citizen.isPresent() && PasswordUtil.matches(password, citizen.get().getPasswordHash())) {
            HttpSession session = request.getSession(true);
            session.setAttribute("role", "citizen");
            session.setAttribute("citizenId", citizen.get().getCitizenId());
            session.setAttribute("fullName", citizen.get().getFullName());
            session.setAttribute("email", citizen.get().getEmail());

            response.sendRedirect(request.getContextPath() + "/");
        } else {
            renderLoginPage(request, response, "Invalid credentials. Please check your email and password.");
        }
    }
}
