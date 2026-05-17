<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String sidebarAdminName = (String) request.getAttribute("adminName");
    String sidebarAdminRole = (String) request.getAttribute("adminRole");
    if (sidebarAdminName == null) sidebarAdminName = (String) session.getAttribute("fullName");
    if (sidebarAdminRole == null) sidebarAdminRole = (String) session.getAttribute("adminRole");
    if (sidebarAdminName == null) sidebarAdminName = "Admin";
    if (sidebarAdminRole == null) sidebarAdminRole = "Staff";
    String sidebarCurrentPath = request.getServletPath();
%>
<aside id="sidebar" class="fixed inset-y-0 left-0 z-[70] h-screen w-[260px] -translate-x-full border-r border-slate-200/80 bg-white transition-transform duration-300 overflow-hidden flex flex-col lg:sticky lg:top-0 lg:translate-x-0">
    <div class="flex h-full min-h-0 flex-col">
        <!-- Logo -->
        <div class="flex items-center justify-between px-5 pt-5 pb-2">
            <a href="<%= request.getContextPath() %>/" class="flex items-center gap-2 text-lg font-black text-slate-900 tracking-tight no-underline">
                <div class="h-8 w-8 rounded-lg bg-brand-900 flex items-center justify-center">
                    <i data-lucide="shield-check" class="h-4 w-4 text-white"></i>
                </div>
                <span>Sarkar<span class="text-brand-500">Sathi</span></span>
            </a>
            <button onclick="toggleSidebar()" class="lg:hidden h-8 w-8 flex items-center justify-center rounded-lg hover:bg-slate-100 text-slate-400 transition-colors">
                <i data-lucide="x" class="h-4 w-4"></i>
            </button>
        </div>


        <!-- Navigation -->
        <nav class="flex-1 px-3 mt-6 space-y-1 min-h-0">
            <p class="px-3 pb-1.5 text-[10px] font-bold uppercase tracking-wider text-slate-400">Overview</p>
            
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-nav-link flex items-center gap-3 px-3 py-2 rounded-lg text-[13px] transition-all <%= sidebarCurrentPath.contains("dashboard") ? "bg-brand-50 text-brand-900 font-bold" : "text-slate-600 font-medium hover:bg-slate-50" %>">
                <i data-lucide="layout-dashboard" class="h-[18px] w-[18px] flex-shrink-0"></i>
                <span>Dashboard</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-nav-link flex items-center gap-3 px-3 py-2 rounded-lg text-[13px] transition-all <%= sidebarCurrentPath.contains("applications") ? "bg-brand-50 text-brand-900 font-bold" : "text-slate-600 font-medium hover:bg-slate-50" %>">
                <i data-lucide="clipboard-list" class="h-[18px] w-[18px] flex-shrink-0"></i>
                <span>Applications</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/tax-payments" class="sidebar-nav-link flex items-center gap-3 px-3 py-2 rounded-lg text-[13px] transition-all <%= sidebarCurrentPath.contains("tax-payments") ? "bg-brand-50 text-brand-900 font-bold" : "text-slate-600 font-medium hover:bg-slate-50" %>">
                <i data-lucide="receipt" class="h-[18px] w-[18px] flex-shrink-0"></i>
                <span>Tax Payments</span>
            </a>

            <p class="px-3 pb-1.5 pt-4 text-[10px] font-bold uppercase tracking-wider text-slate-400">Content</p>
            
            <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-nav-link flex items-center gap-3 px-3 py-2 rounded-lg text-[13px] transition-all <%= sidebarCurrentPath.contains("announcements") ? "bg-brand-50 text-brand-900 font-bold" : "text-slate-600 font-medium hover:bg-slate-50" %>">
                <i data-lucide="megaphone" class="h-[18px] w-[18px] flex-shrink-0"></i>
                <span>Announcements</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-nav-link flex items-center gap-3 px-3 py-2 rounded-lg text-[13px] transition-all <%= sidebarCurrentPath.contains("notices") ? "bg-brand-50 text-brand-900 font-bold" : "text-slate-600 font-medium hover:bg-slate-50" %>">
                <i data-lucide="sprout" class="h-[18px] w-[18px] flex-shrink-0"></i>
                <span>Agriculture</span>
            </a>

            <p class="px-3 pb-1.5 pt-4 text-[10px] font-bold uppercase tracking-wider text-slate-400">Configuration</p>

            <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-nav-link flex items-center gap-3 px-3 py-2 rounded-lg text-[13px] transition-all <%= sidebarCurrentPath.contains("budgets") ? "bg-brand-50 text-brand-900 font-bold" : "text-slate-600 font-medium hover:bg-slate-50" %>">
                <i data-lucide="wallet" class="h-[18px] w-[18px] flex-shrink-0"></i>
                <span>Budgets</span>
            </a>
        </nav>

        <!-- Logout -->
        <div class="shrink-0 border-t border-slate-100 p-3 pb-6 lg:pb-3">
            <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-3 px-3 py-2 rounded-lg text-[13px] font-medium text-slate-500 hover:bg-red-50 hover:text-red-600 transition-all">
                <i data-lucide="log-out" class="h-[18px] w-[18px]"></i>
                <span>Log Out</span>
            </a>
        </div>
    </div>
</aside>
