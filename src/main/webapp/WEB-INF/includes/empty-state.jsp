<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Empty State Component - for empty lists and no-data scenarios
     Usage:
     Set attributes: emptyIcon (lucide icon name), emptyTitle, emptyDescription, emptyAction (link)
-->
<%
    String emptyIcon = (String) request.getAttribute("emptyIcon");
    String emptyTitle = (String) request.getAttribute("emptyTitle");
    String emptyDescription = (String) request.getAttribute("emptyDescription");
    String emptyAction = (String) request.getAttribute("emptyAction");
    String emptyActionLabel = (String) request.getAttribute("emptyActionLabel");
    
    if (emptyIcon == null) emptyIcon = "inbox";
    if (emptyTitle == null) emptyTitle = "No data found";
    if (emptyDescription == null) emptyDescription = "There's nothing to display right now.";
%>

<div class="flex flex-col items-center justify-center py-16 px-6 text-center">
    <div class="mb-4">
        <i data-lucide="<%= emptyIcon %>" class="h-16 w-16 text-slate-200 mx-auto"></i>
    </div>
    <h3 class="text-lg font-black text-slate-900 mb-2">
        <%= emptyTitle %>
    </h3>
    <p class="text-slate-500 font-medium max-w-sm mb-6">
        <%= emptyDescription %>
    </p>
    <% if (emptyAction != null && !emptyAction.isEmpty()) { %>
        <a href="<%= emptyAction %>" class="inline-flex items-center gap-2 rounded-lg bg-brand-900 text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-brand-800 transition-colors shadow-sm">
            <i data-lucide="arrow-right" class="h-4 w-4"></i>
            <%= emptyActionLabel != null ? emptyActionLabel : "Go Back" %>
        </a>
    <% } %>
</div>
