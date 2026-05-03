<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<aside class="fixed left-0 top-0 hidden h-full w-64 border-r border-slate-200 bg-white lg:block z-50">
    <div class="flex h-full flex-col p-6">
        <a href="<%= request.getContextPath() %>" class="flex items-center gap-2 text-2xl font-black tracking-tight text-brand-900 mb-10">
            Sarkar<span class="text-brand-500">Sathi</span>
        </a>
        
        <nav class="flex-1 space-y-2">
            <%
                String sidebarCurrentPath = request.getServletPath();
                String sidebarNormalClass = "flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all";
                String sidebarActiveClass = "flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-black bg-brand-50 text-brand-900 shadow-sm border border-brand-100/50";

                boolean sidebarIsHome = sidebarCurrentPath.equals("/") || sidebarCurrentPath.contains("index");
                boolean sidebarIsAnnouncements = sidebarCurrentPath.contains("announcements");
                boolean sidebarIsAgriculture = sidebarCurrentPath.contains("agriculture");
                boolean sidebarIsBudget = sidebarCurrentPath.contains("budget");
                boolean sidebarIsCrop = sidebarCurrentPath.contains("crop-advisory");
            %>
            <a href="<%= request.getContextPath() %>/" class="<%= sidebarIsHome ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="home" class="h-5 w-5"></i> Home
            </a>
            <a href="<%= request.getContextPath() %>/announcements" class="<%= sidebarIsAnnouncements ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="megaphone" class="h-5 w-5"></i> Announcements
            </a>
            <a href="<%= request.getContextPath() %>/agriculture" class="<%= sidebarIsAgriculture ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="leaf" class="h-5 w-5"></i> Agriculture
            </a>
            <a href="<%= request.getContextPath() %>/budget" class="<%= sidebarIsBudget ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="wallet" class="h-5 w-5"></i> Budget
            </a>
            <a href="<%= request.getContextPath() %>/crop-advisory" class="<%= sidebarIsCrop ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="sprout" class="h-5 w-5"></i> Crop Advisory
            </a>
        </nav>

        <div class="mt-auto pt-6 border-t border-slate-100">
            <% if (session.getAttribute("citizenId") != null) { %>
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex items-center justify-center gap-2 w-full rounded-xl bg-brand-900 py-3 text-sm font-black text-white hover:bg-brand-800 transition-all mb-2">
                    <i data-lucide="layout-dashboard" class="h-4 w-4"></i> Dashboard
                </a>
            <% } else if (session.getAttribute("adminId") != null) { %>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="flex items-center justify-center gap-2 w-full rounded-xl bg-brand-900 py-3 text-sm font-black text-white hover:bg-brand-800 transition-all mb-2">
                    <i data-lucide="layout-dashboard" class="h-4 w-4"></i> Admin Panel
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="flex items-center justify-center gap-2 w-full rounded-xl bg-slate-900 py-3 text-sm font-black text-white hover:bg-brand-900 transition-all">
                    <i data-lucide="log-in" class="h-4 w-4"></i> Login
                </a>
            <% } %>
        </div>
    </div>
</aside>
