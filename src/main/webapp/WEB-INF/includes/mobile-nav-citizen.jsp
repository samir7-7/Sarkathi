<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String citizenNavPath = request.getServletPath();
    Integer citizenNavUnread = (Integer)request.getAttribute("unreadCount");
    if(citizenNavUnread == null) citizenNavUnread = 0;

    String cnBase = "flex flex-col items-center justify-center gap-1 text-slate-500";
    String cnActive = "flex flex-col items-center justify-center gap-1 text-brand-900";

    boolean cnIsDash = citizenNavPath.contains("dashboard");
    boolean cnIsApply = citizenNavPath.contains("apply");
    boolean cnIsTrack = citizenNavPath.contains("tracking");
    boolean cnIsNotif = citizenNavPath.contains("notifications");
%>
<nav class="fixed bottom-3 left-3 right-3 z-50 flex h-16 items-center justify-around rounded-2xl border border-slate-200 bg-white/95 px-2 shadow-[0_14px_32px_rgba(15,23,42,0.16)] backdrop-blur-md lg:hidden safe-area-bottom">
    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="<%= cnIsDash ? cnActive : cnBase %>">
        <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
        <span class="text-[10px] <%= cnIsDash ? "font-bold" : "font-medium" %>">Home</span>
    </a>
    <a href="<%= request.getContextPath() %>/citizen/apply" class="<%= cnIsApply ? cnActive : cnBase %>">
        <i data-lucide="file-plus-2" class="h-5 w-5"></i>
        <span class="text-[10px] <%= cnIsApply ? "font-bold" : "font-medium" %>">Apply</span>
    </a>
    <a href="<%= request.getContextPath() %>/citizen/tracking" class="<%= cnIsTrack ? cnActive : cnBase %>">
        <i data-lucide="search-check" class="h-5 w-5"></i>
        <span class="text-[10px] <%= cnIsTrack ? "font-bold" : "font-medium" %>">Track</span>
    </a>
    <a href="<%= request.getContextPath() %>/citizen/notifications" class="<%= cnIsNotif ? cnActive : cnBase %> relative">
        <i data-lucide="bell" class="h-5 w-5"></i>
        <% if(citizenNavUnread > 0){ %>
            <span class="absolute top-0 right-1 h-2 w-2 rounded-full bg-red-500"></span>
        <% } %>
        <span class="text-[10px] <%= cnIsNotif ? "font-bold" : "font-medium" %>">Inbox</span>
    </a>
    <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500">
        <i data-lucide="menu" class="h-5 w-5"></i>
        <span class="text-[10px] font-medium">Menu</span>
    </button>
</nav>
