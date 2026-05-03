<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% 
    String displayNameTop = (String) session.getAttribute("displayName"); 
    boolean loggedInTop = displayNameTop != null && !displayNameTop.isBlank(); 
    String currentPathTop = request.getServletPath();
%>
<!-- Desktop Header -->
<header class="hidden lg:block px-6 py-6 lg:px-12 relative z-10 transition-all duration-300">
    <nav class="mx-auto flex max-w-7xl items-center justify-between">
        <a href="<%= request.getContextPath() %>/" class="flex items-center gap-2 text-2xl font-black tracking-tight text-brand-900">
            Sarkar<span class="text-brand-500">Sathi</span>
        </a>
        
        <div class="flex items-center gap-10">
            <div class="flex items-center gap-8 text-[11px] font-black uppercase tracking-[0.2em] text-slate-500">
                <% 
                    String linkBaseClass = "hover:text-brand-900 transition-colors";
                    String linkActiveClass = "text-brand-900 border-b-2 border-brand-900 pb-1";
                %>
                <a href="<%= request.getContextPath() %>/" class="<%= currentPathTop.equals("/") || currentPathTop.contains("index") ? linkActiveClass : linkBaseClass %>">Home</a>
                <a href="<%= request.getContextPath() %>/announcements" class="<%= currentPathTop.contains("announcements") ? linkActiveClass : linkBaseClass %>">Announcements</a>
                <a href="<%= request.getContextPath() %>/agriculture" class="<%= currentPathTop.contains("agriculture") ? linkActiveClass : linkBaseClass %>">Agriculture</a>
                <a href="<%= request.getContextPath() %>/about" class="<%= currentPathTop.contains("about") ? linkActiveClass : linkBaseClass %>">About Us</a>
                <a href="<%= request.getContextPath() %>/contact" class="<%= currentPathTop.contains("contact") ? linkActiveClass : linkBaseClass %>">Contact</a>
            </div>
            <div class="h-6 w-px bg-slate-200"></div>
            <div class="flex items-center gap-4">
                <% if (loggedInTop) { %>
                    <div class="flex items-center gap-4">
                        <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Digital Citizen</span>
                        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="h-10 w-10 rounded-xl bg-brand-50 text-brand-900 flex items-center justify-center hover:bg-brand-900 hover:text-white transition-all shadow-sm">
                            <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                        </a>
                        <a href="<%= request.getContextPath() %>/logout" class="h-10 w-10 rounded-xl bg-slate-100 text-slate-600 flex items-center justify-center hover:bg-red-50 hover:text-red-600 transition-all shadow-sm">
                            <i data-lucide="log-out" class="h-5 w-5"></i>
                        </a>
                    </div>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/login" class="text-[11px] font-black uppercase tracking-[0.2em] text-brand-900 hover:text-brand-500 transition-colors">Identity Verification</a>
                    <a href="<%= request.getContextPath() %>/register" class="rounded-xl bg-brand-900 px-8 py-3.5 text-[11px] font-black uppercase tracking-[0.2em] text-white shadow-xl shadow-brand-900/20 hover:bg-slate-900 transition-all active:scale-95">Enroll Now</a>
                <% } %>
            </div>
        </div>
    </nav>
</header>

<!-- Mobile Header -->
<header class="sticky top-0 z-40 flex h-16 items-center justify-between border-b border-slate-200 bg-white/80 px-6 backdrop-blur-md lg:hidden">
    <a href="<%= request.getContextPath() %>" class="text-xl font-black tracking-tight text-brand-900">
        Sarkar<span class="text-brand-500">Sathi</span>
    </a>
    <div class="flex items-center gap-3">
        <% if (loggedInTop) { %>
            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="h-9 w-9 rounded-lg bg-brand-50 text-brand-900 flex items-center justify-center">
                <i data-lucide="layout-dashboard" class="h-4 w-4"></i>
            </a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login" class="h-9 w-9 rounded-lg bg-brand-50 text-brand-900 flex items-center justify-center">
                <i data-lucide="user" class="h-4 w-4"></i>
            </a>
        <% } %>
    </div>
</header>
