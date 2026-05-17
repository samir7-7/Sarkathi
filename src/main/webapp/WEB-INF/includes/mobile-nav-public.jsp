<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String mobileCurrentPath = request.getServletPath();
    String mobileBaseClass = "flex min-w-0 flex-col items-center justify-center gap-1 px-1 text-slate-400 transition-all hover:text-brand-900";
    String mobileActiveClass = "flex min-w-0 flex-col items-center justify-center gap-1 px-1 text-brand-900";

    boolean mobileIsHome = mobileCurrentPath.equals("/") || mobileCurrentPath.contains("index");
    boolean mobileIsBudget = mobileCurrentPath.contains("budget");
    boolean mobileIsAnnouncements = mobileCurrentPath.contains("announcements");
    boolean mobileIsCropAdvisory = mobileCurrentPath.contains("crop-advisory");
    boolean mobileIsContact = mobileCurrentPath.contains("contact");
    boolean mobileIsAbout = mobileCurrentPath.contains("about");
%>
<nav class="fixed bottom-3 left-3 right-3 z-50 grid h-16 grid-cols-6 items-center rounded-2xl border border-slate-200 bg-white/95 px-1 shadow-[0_14px_32px_rgba(15,23,42,0.16)] backdrop-blur-md lg:hidden">
    <a href="<%= request.getContextPath() %>/" class="<%= mobileIsHome ? mobileActiveClass : mobileBaseClass %>">
        <i data-lucide="home" class="h-4.5 w-4.5"></i>
        <span class="text-[9px] font-black uppercase tracking-tight">Home</span>
    </a>
    <a href="<%= request.getContextPath() %>/budget" class="<%= mobileIsBudget ? mobileActiveClass : mobileBaseClass %>">
        <i data-lucide="wallet" class="h-4.5 w-4.5"></i>
        <span class="text-[9px] font-black uppercase tracking-tight">Budget</span>
    </a>
    <a href="<%= request.getContextPath() %>/announcements" class="<%= mobileIsAnnouncements ? mobileActiveClass : mobileBaseClass %>">
        <i data-lucide="megaphone" class="h-4.5 w-4.5"></i>
        <span class="text-[9px] font-black uppercase tracking-tight">Announcement</span>
    </a>
    <a href="<%= request.getContextPath() %>/crop-advisory" class="<%= mobileIsCropAdvisory ? mobileActiveClass : mobileBaseClass %>">
        <i data-lucide="sprout" class="h-4.5 w-4.5"></i>
        <span class="text-[9px] font-black uppercase tracking-tight leading-tight text-center">Agriculture<br>Advisory</span>
    </a>
    <a href="<%= request.getContextPath() %>/contact" class="<%= mobileIsContact ? mobileActiveClass : mobileBaseClass %>">
        <i data-lucide="mail" class="h-4.5 w-4.5"></i>
        <span class="text-[9px] font-black uppercase tracking-tight">Contact</span>
    </a>
    <a href="<%= request.getContextPath() %>/about" class="<%= mobileIsAbout ? mobileActiveClass : mobileBaseClass %>">
        <i data-lucide="info" class="h-4.5 w-4.5"></i>
        <span class="text-[9px] font-black uppercase tracking-tight">About</span>
    </a>
</nav>
