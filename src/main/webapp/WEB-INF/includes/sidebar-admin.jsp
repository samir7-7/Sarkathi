<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String sidebarAdminName = (String) request.getAttribute("adminName");
    String sidebarAdminRole = (String) request.getAttribute("adminRole");
    if (sidebarAdminName == null) sidebarAdminName = (String) session.getAttribute("fullName");
    if (sidebarAdminRole == null) sidebarAdminRole = (String) session.getAttribute("adminRole");
    if (sidebarAdminName == null) sidebarAdminName = "Admin";
    if (sidebarAdminRole == null) sidebarAdminRole = "Staff";

    String sidebarCurrentPath = request.getServletPath();

    String sidebarActiveClass = "sidebar-link active group flex items-center gap-4 px-4 py-4 rounded-[5px] text-[11px] font-black uppercase tracking-widest";
    String sidebarNormalClass = "sidebar-link group flex items-center gap-4 px-4 py-4 rounded-[5px] text-slate-500 font-bold uppercase tracking-widest text-[11px]";
%>
<aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-72 -translate-x-full border-r border-slate-100 bg-white transition-transform duration-300 lg:static lg:translate-x-0">
    <div class="flex h-full flex-col p-6">
        <div class="flex items-center justify-between">
            <a href="<%= request.getContextPath() %>/" class="text-2xl font-black text-brand-900 tracking-tighter">SarkarSathi</a>
            <button onclick="toggleSidebar()" class="lg:hidden h-10 w-10 flex items-center justify-center rounded-[5px] bg-slate-50 text-slate-400">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>

        <div class="mt-10 mb-6 px-4 py-8 rounded-[2rem] bg-slate-900 text-white shadow-2xl shadow-slate-900/20 relative overflow-hidden group">
            <div class="absolute top-0 right-0 h-24 w-24 bg-white/5 rounded-bl-[3rem] -mr-8 -mt-8 rotate-12 group-hover:bg-white/10 transition-colors"></div>
            <p class="text-[10px] font-black uppercase tracking-[0.3em] text-blue-300/80 mb-2">Authenticated System</p>
            <h4 class="text-lg font-black tracking-tight truncate"><%= sidebarAdminName %></h4>
            <p class="text-[9px] font-black uppercase tracking-widest text-slate-400 mt-1 uppercase"><%= sidebarAdminRole %></p>
        </div>

        <nav class="flex-1 space-y-2 overflow-y-auto">
            <p class="px-4 py-4 text-[10px] font-black uppercase tracking-[0.3em] text-slate-300">Operations</p>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="<%= sidebarCurrentPath.contains("dashboard") ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                <span>Admin Terminal</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/applications" class="<%= sidebarCurrentPath.contains("applications") ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="clipboard-check" class="h-5 w-5"></i>
                <span>Process Queue</span>
            </a>
            
            <p class="px-4 py-4 text-[10px] font-black uppercase tracking-[0.3em] text-slate-300">Content</p>
            <a href="<%= request.getContextPath() %>/admin/announcements" class="<%= sidebarCurrentPath.contains("announcements") ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="megaphone" class="h-5 w-5"></i>
                <span>Announcements</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/notices" class="<%= sidebarCurrentPath.contains("notices") ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="sprout" class="h-5 w-5"></i>
                <span>Agri Hub</span>
            </a>

            <p class="px-4 py-4 text-[10px] font-black uppercase tracking-[0.3em] text-slate-300">Management</p>
            <%-- 
            <a href="<%= request.getContextPath() %>/admin/wards" class="<%= sidebarCurrentPath.contains("wards") ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="map-pinned" class="h-5 w-5"></i>
                <span>Wards Node</span>
            </a>
            --%>
            <a href="<%= request.getContextPath() %>/admin/services" class="<%= sidebarCurrentPath.contains("services") ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="layers-3" class="h-5 w-5"></i>
                <span>Service Engine</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/budgets" class="<%= sidebarCurrentPath.contains("budgets") ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="pie-chart" class="h-5 w-5"></i>
                <span>Fiscal Flow</span>
            </a>
        </nav>

        <div class="pt-6 border-t border-slate-50">
            <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-4 px-4 py-4 rounded-[5px] text-rose-500 font-black uppercase tracking-widest text-[11px] hover:bg-rose-50 transition-colors">
                <i data-lucide="power" class="h-5 w-5"></i>
                <span>Log Out</span>
            </a>
        </div>
    </div>
</aside>
