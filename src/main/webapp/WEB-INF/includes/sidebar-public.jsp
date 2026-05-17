<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<aside class="fixed left-0 top-0 hidden h-full w-64 border-r border-slate-200 bg-white lg:block z-50 overflow-y-auto">
    <div class="flex h-full flex-col p-6">
        <a href="<%= request.getContextPath() %>" class="flex items-center gap-2 text-2xl font-black tracking-tight text-brand-900 mb-8">
            Sarkar<span class="text-brand-500">Sathi</span>
        </a>
        
        <nav class="flex-1 space-y-1">
            <%
                String sidebarCurrentPath = request.getServletPath();
                String sidebarNormalClass = "flex items-center gap-3 rounded-lg px-3.5 py-2.5 text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-all hover:text-brand-900";
                String sidebarActiveClass = "flex items-center gap-3 rounded-lg px-3.5 py-2.5 text-sm font-bold bg-brand-50 text-brand-900 shadow-sm border border-brand-100/50";

                boolean sidebarIsHome = sidebarCurrentPath.equals("/") || sidebarCurrentPath.contains("index");
                boolean sidebarIsAnnouncements = sidebarCurrentPath.contains("announcements");
                boolean sidebarIsAgriculture = sidebarCurrentPath.contains("agriculture");
                boolean sidebarIsBudget = sidebarCurrentPath.contains("budget");
                boolean sidebarIsCrop = sidebarCurrentPath.contains("crop-advisory");
            %>

            <p class="px-3 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-2">EXPLORE</p>
            
            <a href="<%= request.getContextPath() %>/" class="<%= sidebarIsHome ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="home" class="h-5 w-5 flex-shrink-0"></i> 
                <span>Home</span>
            </a>
            <a href="<%= request.getContextPath() %>/announcements" class="<%= sidebarIsAnnouncements ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="megaphone" class="h-5 w-5 flex-shrink-0"></i> 
                <span>Announcements</span>
            </a>
            <a href="<%= request.getContextPath() %>/agriculture" class="<%= sidebarIsAgriculture ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="leaf" class="h-5 w-5 flex-shrink-0"></i> 
                <span>Agriculture</span>
            </a>
            
            <p class="px-3 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-6">RESOURCES</p>
            
            <a href="<%= request.getContextPath() %>/budget" class="<%= sidebarIsBudget ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="wallet" class="h-5 w-5 flex-shrink-0"></i> 
                <span>Budget</span>
            </a>
            <a href="<%= request.getContextPath() %>/crop-advisory" class="<%= sidebarIsCrop ? sidebarActiveClass : sidebarNormalClass %>">
                <i data-lucide="sprout" class="h-5 w-5 flex-shrink-0"></i> 
                <span>Crop Advisory</span>
            </a>
        </nav>

        <div class="mt-auto pt-6 border-t border-slate-100 space-y-2">
            <p class="px-3 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-3">ACCOUNT</p>
            <% if (session.getAttribute("citizenId") != null) { %>
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex items-center justify-center gap-2 w-full rounded-lg bg-brand-900 py-2.5 text-sm font-black text-white hover:bg-brand-800 transition-all shadow-sm">
                    <i data-lucide="layout-dashboard" class="h-4 w-4"></i> Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="flex items-center justify-center gap-2 w-full rounded-lg border border-slate-200 py-2.5 text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-all">
                    <i data-lucide="log-out" class="h-4 w-4"></i> Logout
                </a>
            <% } else if (session.getAttribute("adminId") != null) { %>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="flex items-center justify-center gap-2 w-full rounded-lg bg-brand-900 py-2.5 text-sm font-black text-white hover:bg-brand-800 transition-all shadow-sm">
                    <i data-lucide="layout-dashboard" class="h-4 w-4"></i> Admin Panel
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="flex items-center justify-center gap-2 w-full rounded-lg border border-slate-200 py-2.5 text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-all">
                    <i data-lucide="log-out" class="h-4 w-4"></i> Logout
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="flex items-center justify-center gap-2 w-full rounded-lg bg-brand-900 py-2.5 text-sm font-black text-white hover:bg-brand-800 transition-all shadow-sm">
                    <i data-lucide="log-in" class="h-4 w-4"></i> Login
                </a>
                <a href="<%= request.getContextPath() %>/register" class="flex items-center justify-center gap-2 w-full rounded-lg border border-brand-900 bg-white py-2.5 text-sm font-semibold text-brand-900 hover:bg-brand-50 transition-all">
                    <i data-lucide="user-plus" class="h-4 w-4"></i> Sign Up
                </a>
            <% } %>
        </div>
    </div>
</aside>
