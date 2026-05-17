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
<aside id="sidebar" class="fixed inset-y-0 left-0 z-50 h-screen w-64 -translate-x-full border-r border-slate-200 bg-white transition-transform duration-300 overflow-hidden lg:sticky lg:top-0 lg:translate-x-0">
    <div class="flex h-full min-h-0 flex-col">
        <div class="p-6 border-b border-slate-100 flex items-center justify-between">
            <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a>
            <button onclick="toggleSidebar()" class="lg:hidden p-2 text-slate-400"><i data-lucide="x" class="h-5 w-5"></i></button>
        </div>

        <div class="flex-1 p-6 min-h-0">

            <nav class="space-y-1">
                <p class="px-2 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-4 ml-1">CORE ACTIONS</p>
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="<%= sidebarCurrentPath.contains("dashboard") ? sidebarActiveClass : sidebarNormalClass %> hover:bg-slate-50 active:scale-95 transition-all">
                    <div class="h-5 w-5 flex items-center justify-center rounded-md bg-blue-50 text-blue-600">
                        <i data-lucide="layout-dashboard" class="h-4 w-4"></i>
                    </div>
                    <span class="font-semibold">Dashboard</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="<%= sidebarCurrentPath.contains("apply") ? sidebarActiveClass : sidebarNormalClass %> hover:bg-slate-50 active:scale-95 transition-all">
                    <div class="h-5 w-5 flex items-center justify-center rounded-md bg-green-50 text-green-600">
                        <i data-lucide="file-plus-2" class="h-4 w-4"></i>
                    </div>
                    <span class="font-semibold">New Application</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="<%= sidebarCurrentPath.contains("tracking") ? sidebarActiveClass : sidebarNormalClass %> hover:bg-slate-50 active:scale-95 transition-all">
                    <div class="h-5 w-5 flex items-center justify-center rounded-md bg-amber-50 text-amber-600">
                        <i data-lucide="search-check" class="h-4 w-4"></i>
                    </div>
                    <span class="font-semibold">Track Status</span>
                </a>



                <p class="px-2 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-6 ml-1">MY RECORDS</p>
                <a href="<%= request.getContextPath() %>/citizen/payments" class="<%= sidebarCurrentPath.contains("payments") ? sidebarActiveClass : sidebarNormalClass %> hover:bg-slate-50 active:scale-95 transition-all">
                    <div class="h-5 w-5 flex items-center justify-center rounded-md bg-purple-50 text-purple-600">
                        <i data-lucide="credit-card" class="h-4 w-4"></i>
                    </div>
                    <span class="font-semibold">Payments & Tax</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/certificates" class="<%= sidebarCurrentPath.contains("certificates") ? sidebarActiveClass : sidebarNormalClass %> hover:bg-slate-50 active:scale-95 transition-all">
                    <div class="h-5 w-5 flex items-center justify-center rounded-md bg-pink-50 text-pink-600">
                        <i data-lucide="award" class="h-4 w-4"></i>
                    </div>
                    <span class="font-semibold">Certificates</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/documents" class="<%= sidebarCurrentPath.contains("documents") ? sidebarActiveClass : sidebarNormalClass %> hover:bg-slate-50 active:scale-95 transition-all">
                    <div class="h-5 w-5 flex items-center justify-center rounded-md bg-cyan-50 text-cyan-600">
                        <i data-lucide="folder-open" class="h-4 w-4"></i>
                    </div>
                    <span class="font-semibold">Documents</span>
                </a>
            </nav>
        </div>

        <div class="shrink-0 p-6 border-t border-slate-100 pb-20 lg:pb-6">
            <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-3 px-4 py-3 text-sm font-medium text-red-600 hover:bg-red-50 rounded-xl transition-colors">
                <i data-lucide="log-out" class="h-5 w-5"></i>
                <span>Log Out</span>
            </a>
        </div>
    </div>
</aside>
