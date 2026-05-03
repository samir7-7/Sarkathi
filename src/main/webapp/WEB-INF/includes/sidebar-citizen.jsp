<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String sidebarCitizenName = (String) session.getAttribute("citizenName");
    if (sidebarCitizenName == null) sidebarCitizenName = (String) session.getAttribute("fullName");
    if (sidebarCitizenName == null) sidebarCitizenName = "Citizen";
    String sidebarCurrentPath = request.getServletPath();

    String sidebarActiveClass = "sidebar-link active flex items-center gap-3 rounded-xl px-4 py-3 text-sm";
    String sidebarNormalClass = "sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600";

    Integer sidebarUnreadCount = (Integer) request.getAttribute("unreadCount");
    if (sidebarUnreadCount == null) sidebarUnreadCount = 0;
%>
<aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 -translate-x-full border-r border-slate-200 bg-white transition-transform duration-300 lg:static lg:translate-x-0">
    <div class="flex h-full flex-col">
        <div class="p-6 border-b border-slate-100 flex items-center justify-between">
            <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a>
            <button onclick="toggleSidebar()" class="lg:hidden p-2 text-slate-400"><i data-lucide="x" class="h-5 w-5"></i></button>
        </div>

        <div class="p-6">
            <div class="flex items-center gap-3 p-4 rounded-2xl bg-slate-50 border border-slate-100 mb-8">
                <div class="h-10 w-10 flex items-center justify-center rounded-xl bg-brand-900 text-white font-bold uppercase text-xs">
                    <%= sidebarCitizenName.substring(0,1).toUpperCase() %>
                </div>
                <div class="overflow-hidden">
                    <p class="text-sm font-bold text-slate-900 truncate uppercase tracking-tight text-ellipsis"><%= sidebarCitizenName %></p>
                    <p class="text-[10px] font-medium text-slate-500 uppercase tracking-widest">Citizen Profile</p>
                </div>
            </div>

            <nav class="space-y-1">
                <p class="px-2 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-4">CORE</p>
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="<%= sidebarCurrentPath.contains("dashboard") ? sidebarActiveClass : sidebarNormalClass %>">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span>Home Board</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="<%= sidebarCurrentPath.contains("apply") ? sidebarActiveClass : sidebarNormalClass %>">
                    <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                    <span>Apply for Service</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="<%= sidebarCurrentPath.contains("tracking") ? sidebarActiveClass : sidebarNormalClass %>">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span>Track Status</span>
                </a>
                <p class="px-2 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-8">RECORDS</p>
                <a href="<%= request.getContextPath() %>/citizen/payments" class="<%= sidebarCurrentPath.contains("payments") ? sidebarActiveClass : sidebarNormalClass %>">
                    <i data-lucide="credit-card" class="h-5 w-5"></i>
                    <span>Payments & Tax</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/certificates" class="<%= sidebarCurrentPath.contains("certificates") ? sidebarActiveClass : sidebarNormalClass %>">
                    <i data-lucide="award" class="h-5 w-5"></i>
                    <span>My Certificates</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/documents" class="<%= sidebarCurrentPath.contains("documents") ? sidebarActiveClass : sidebarNormalClass %>">
                    <i data-lucide="folder-open" class="h-5 w-5"></i>
                    <span>My Documents</span>
                </a>
            </nav>
        </div>

        <div class="mt-auto p-6 border-t border-slate-100 pb-20 lg:pb-6">
            <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-3 px-4 py-3 text-sm font-medium text-red-600 hover:bg-red-50 rounded-xl transition-colors">
                <i data-lucide="log-out" class="h-5 w-5"></i>
                <span>Log Out</span>
            </a>
        </div>
    </div>
</aside>
