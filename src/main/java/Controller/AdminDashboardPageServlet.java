package Controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "adminDashboardPageServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String adminName = (String) session.getAttribute("fullName");
        String adminEmail = (String) session.getAttribute("email");
        String adminRole = (String) session.getAttribute("adminRole");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"en\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>Admin Dashboard - SarkarSathi</title>");
        out.println("    <script src=\"https://cdn.tailwindcss.com\"></script>");
        out.println("    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">");
        out.println("    <link href=\"https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap\" rel=\"stylesheet\">");
        out.println("    <style>");
        out.println("        body { font-family: 'Outfit', sans-serif; }");
        out.println("        .nav-link { transition: all 0.2s ease; }");
        out.println("        .nav-link:hover { background: #f0f5fc; color: #0b3d86; }");
        out.println("        .stat-card { transition: all 0.25s ease; }");
        out.println("        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px -5px rgba(0, 0, 0, 0.08); }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body class=\"bg-slate-50\">");
        out.println("    <div class=\"min-h-screen flex\">");
        // Sidebar
        out.println("        <aside class=\"w-64 bg-white border-r border-slate-200 shadow-sm\">");
        out.println("            <div class=\"p-6 border-b border-slate-200\">");
        out.println("                <div class=\"flex h-12 w-12 items-center justify-center rounded-lg bg-brand-800 text-white mb-3\">");
        out.println("                    <svg class=\"h-6 w-6\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M3 21h18\"></path><path d=\"M3 13L12 4l9 9\"></path><path d=\"M5 21v-4\"></path><path d=\"M19 21v-4\"></path><path d=\"M12 17v-4\"></path></svg>");
        out.println("                </div>");
        out.println("                <h1 class=\"text-lg font-bold text-slate-900\">SarkarSathi</h1>");
        out.println("                <p class=\"text-xs text-slate-500 mt-1\">Admin Portal</p>");
        out.println("            </div>");
        out.println("            <nav class=\"p-4 space-y-2\">");
        out.println("                <a href=\"#\" class=\"nav-link active flex items-center gap-3 px-4 py-3 rounded-lg bg-brand-50 text-brand-800 font-500\">");
        out.println("                    <svg class=\"h-5 w-5\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z\"></path></svg>");
        out.println("                    <span>Dashboard</span>");
        out.println("                </a>");
        out.println("                <a href=\"#\" class=\"nav-link flex items-center gap-3 px-4 py-3 rounded-lg text-slate-700 hover:text-brand-800\">");
        out.println("                    <svg class=\"h-5 w-5\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2\"></path><circle cx=\"12\" cy=\"7\" r=\"4\"></circle></svg>");
        out.println("                    <span>Users</span>");
        out.println("                </a>");
        out.println("                <a href=\"#\" class=\"nav-link flex items-center gap-3 px-4 py-3 rounded-lg text-slate-700 hover:text-brand-800\">");
        out.println("                    <svg class=\"h-5 w-5\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z\"></path><polyline points=\"13 2 13 9 20 9\"></polyline></svg>");
        out.println("                    <span>Applications</span>");
        out.println("                </a>");
        out.println("                <a href=\"#\" class=\"nav-link flex items-center gap-3 px-4 py-3 rounded-lg text-slate-700 hover:text-brand-800\">");
        out.println("                    <svg class=\"h-5 w-5\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><rect x=\"3\" y=\"4\" width=\"18\" height=\"18\" rx=\"2\" ry=\"2\"></rect><path d=\"M16 2v4\"></path><path d=\"M8 2v4\"></path><path d=\"M3 10h18\"></path></svg>");
        out.println("                    <span>Reports</span>");
        out.println("                </a>");
        out.println("            </nav>");
        out.println("            <div class=\"absolute bottom-0 left-0 right-0 p-4 border-t border-slate-200 bg-white\">");
        out.println("                <a href=\"" + request.getContextPath() + "/logout\" class=\"nav-link flex items-center gap-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 font-500\">");
        out.println("                    <svg class=\"h-5 w-5\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4\"></path><polyline points=\"16 17 21 12 16 7\"></polyline><line x1=\"21\" y1=\"12\" x2=\"9\" y2=\"12\"></line></svg>");
        out.println("                    <span>Logout</span>");
        out.println("                </a>");
        out.println("            </div>");
        out.println("        </aside>");
        // Main Content
        out.println("        <main class=\"flex-1 overflow-auto\">");
        out.println("            <div class=\"border-b border-slate-200 bg-white\">");
        out.println("                <div class=\"flex items-center justify-between px-8 py-6\">");
        out.println("                    <div>");
        out.println("                        <h1 class=\"text-3xl font-bold text-slate-900\">Welcome, " + adminName + "</h1>");
        out.println("                        <p class=\"text-slate-600 mt-1\">You are logged in as <strong>" + adminRole + "</strong></p>");
        out.println("                    </div>");
        out.println("                    <div class=\"text-right\">");
        out.println("                        <p class=\"text-sm font-medium text-slate-900\">" + adminName + "</p>");
        out.println("                        <p class=\"text-sm text-slate-500\">" + adminEmail + "</p>");
        out.println("                    </div>");
        out.println("                </div>");
        out.println("            </div>");
        out.println("            <div class=\"p-8\">");
        out.println("                <div class=\"grid grid-cols-1 md:grid-cols-4 gap-6 mb-8\">");
        out.println("                    <div class=\"stat-card bg-white rounded-lg border border-slate-200 p-6\">");
        out.println("                        <div class=\"flex items-center justify-between\">");
        out.println("                            <div>");
        out.println("                                <p class=\"text-sm font-medium text-slate-600\">Total Applications</p>");
        out.println("                                <p class=\"text-3xl font-bold text-slate-900 mt-2\">128</p>");
        out.println("                            </div>");
        out.println("                            <div class=\"text-brand-800/20\"><svg class=\"h-12 w-12\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z\"></path></svg></div>");
        out.println("                        </div>");
        out.println("                    </div>");
        out.println("                    <div class=\"stat-card bg-white rounded-lg border border-slate-200 p-6\">");
        out.println("                        <div class=\"flex items-center justify-between\">");
        out.println("                            <div>");
        out.println("                                <p class=\"text-sm font-medium text-slate-600\">Pending Review</p>");
        out.println("                                <p class=\"text-3xl font-bold text-slate-900 mt-2\">24</p>");
        out.println("                            </div>");
        out.println("                            <div class=\"text-yellow-600/20\"><svg class=\"h-12 w-12\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><circle cx=\"12\" cy=\"12\" r=\"10\"></circle></svg></div>");
        out.println("                        </div>");
        out.println("                    </div>");
        out.println("                    <div class=\"stat-card bg-white rounded-lg border border-slate-200 p-6\">");
        out.println("                        <div class=\"flex items-center justify-between\">");
        out.println("                            <div>");
        out.println("                                <p class=\"text-sm font-medium text-slate-600\">Completed</p>");
        out.println("                                <p class=\"text-3xl font-bold text-slate-900 mt-2\">94</p>");
        out.println("                            </div>");
        out.println("                            <div class=\"text-green-600/20\"><svg class=\"h-12 w-12\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M10 15l-3.5-3.5a1 1 0 1 0-1.415 1.415l5 5a1 1 0 0 0 1.415 0l10-10a1 1 0 1 0-1.415-1.415L10 15z\"></path></svg></div>");
        out.println("                        </div>");
        out.println("                    </div>");
        out.println("                    <div class=\"stat-card bg-white rounded-lg border border-slate-200 p-6\">");
        out.println("                        <div class=\"flex items-center justify-between\">");
        out.println("                            <div>");
        out.println("                                <p class=\"text-sm font-medium text-slate-600\">Registered Users</p>");
        out.println("                                <p class=\"text-3xl font-bold text-slate-900 mt-2\">652</p>");
        out.println("                            </div>");
        out.println("                            <div class=\"text-blue-600/20\"><svg class=\"h-12 w-12\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2\"></path><circle cx=\"9\" cy=\"7\" r=\"4\"></circle><path d=\"M23 21v-2a4 4 0 0 0-3-3.87\"></path><path d=\"M16 3.13a4 4 0 0 1 0 7.75\"></path></svg></div>");
        out.println("                        </div>");
        out.println("                    </div>");
        out.println("                </div>");
        out.println("                <div class=\"bg-white rounded-lg border border-slate-200 p-6\">");
        out.println("                    <h2 class=\"text-lg font-bold text-slate-900 mb-4\">Quick Start</h2>");
        out.println("                    <div class=\"grid grid-cols-2 md:grid-cols-4 gap-4\">");
        out.println("                        <a href=\"#\" class=\"p-4 rounded-lg border border-slate-200 hover:border-brand-500 hover:bg-brand-50 transition text-center\">");
        out.println("                            <div class=\"text-brand-800 text-2xl mb-2\">📋</div>");
        out.println("                            <p class=\"text-sm font-medium text-slate-700\">Review Applications</p>");
        out.println("                        </a>");
        out.println("                        <a href=\"#\" class=\"p-4 rounded-lg border border-slate-200 hover:border-brand-500 hover:bg-brand-50 transition text-center\">");
        out.println("                            <div class=\"text-brand-800 text-2xl mb-2\">👥</div>");
        out.println("                            <p class=\"text-sm font-medium text-slate-700\">Manage Users</p>");
        out.println("                        </a>");
        out.println("                        <a href=\"#\" class=\"p-4 rounded-lg border border-slate-200 hover:border-brand-500 hover:bg-brand-50 transition text-center\">");
        out.println("                            <div class=\"text-brand-800 text-2xl mb-2\">📊</div>");
        out.println("                            <p class=\"text-sm font-medium text-slate-700\">View Reports</p>");
        out.println("                        </a>");
        out.println("                        <a href=\"#\" class=\"p-4 rounded-lg border border-slate-200 hover:border-brand-500 hover:bg-brand-50 transition text-center\">");
        out.println("                            <div class=\"text-brand-800 text-2xl mb-2\">⚙️</div>");
        out.println("                            <p class=\"text-sm font-medium text-slate-700\">Settings</p>");
        out.println("                        </a>");
        out.println("                    </div>");
        out.println("                </div>");
        out.println("            </div>");
        out.println("        </main>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }
}
