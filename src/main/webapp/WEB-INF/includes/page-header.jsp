<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Page Header Component
     Usage: Set pageTitle, pageDescription, showBreadcrumbs as page attributes before including this file
-->
<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    String pageDescription = (String) request.getAttribute("pageDescription");
    String pageIcon = (String) request.getAttribute("pageIcon");
    Boolean showBreadcrumbs = (Boolean) request.getAttribute("showBreadcrumbs");
    
    if (pageTitle == null) pageTitle = "";
    if (pageDescription == null) pageDescription = "";
    if (pageIcon == null) pageIcon = "layout-dashboard";
    if (showBreadcrumbs == null) showBreadcrumbs = true;
%>

<div class="lg:flex sticky top-0 z-30 items-center justify-between border-b border-slate-200 bg-white/95 backdrop-blur px-6 py-4 gap-4 hidden">
    <div class="min-w-0">
        <div class="flex items-center gap-3 mb-1.5">
            <div class="h-5 w-5 text-brand-600">
                <i data-lucide="<%= pageIcon %>" class="h-5 w-5"></i>
            </div>
            <h1 class="text-lg font-black text-slate-900 tracking-tight">
                <%= pageTitle %>
            </h1>
        </div>
        <% if (!pageDescription.isEmpty()) { %>
            <p class="text-[11px] text-slate-500 font-semibold">
                <%= pageDescription %>
            </p>
        <% } %>
    </div>
    <div class="flex items-center gap-3 flex-shrink-0">
        <slot name="actions"></slot>
    </div>
</div>

<div class="lg:hidden flex items-center justify-between px-5 pt-6 pb-4 bg-slate-50 border-b border-slate-200">
    <div class="flex-1">
        <div class="flex items-center gap-2 mb-2">
            <div class="h-4 w-4 text-brand-600">
                <i data-lucide="<%= pageIcon %>" class="h-4 w-4"></i>
            </div>
            <h1 class="text-lg font-black text-slate-900 tracking-tight">
                <%= pageTitle %>
            </h1>
        </div>
        <% if (!pageDescription.isEmpty()) { %>
            <p class="text-[10px] text-slate-500 font-semibold uppercase tracking-[0.1em]">
                <%= pageDescription %>
            </p>
        <% } %>
    </div>
</div>
