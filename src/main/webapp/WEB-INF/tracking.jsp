<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} private String badgeClass(String status){if("approved".equals(status))return"bg-green-50 text-green-700";if("rejected".equals(status))return"bg-red-50 text-red-600";if("review".equals(status))return"bg-amber-50 text-amber-700";return"bg-blue-50 text-blue-700";} %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId"); String citizenName=(String)request.getAttribute("citizenName"); Integer unread=(Integer)request.getAttribute("unreadCount"); List<Application> applications=(List<Application>)request.getAttribute("applications"); Application trackingResult=(Application)request.getAttribute("trackingResult"); Boolean trackingSearched=(Boolean)request.getAttribute("trackingSearched"); String formError=request.getParameter("error"); DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMM d, yyyy HH:mm"); boolean loggedIn=citizenId!=null; if(citizenName==null)citizenName="Citizen";if(unread==null)unread=0;if(applications==null)applications=List.of(); String action=loggedIn?request.getContextPath()+"/citizen/tracking":request.getContextPath()+"/track"; String initials=citizenName.isBlank()?"C":citizenName.substring(0,1).toUpperCase(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Track Application - SarkarSathi
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
        </style>
            <%@ include file="includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <div class="flex min-h-screen">
            <% if(loggedIn){ %>
                <aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
                    <div class="px-5 pt-5 pb-2">
                        <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">
                            SarkarSathi
                        </a>
                    </div>
                    <div class="mx-5 mt-3 flex items-center gap-3 rounded-xl bg-brand-50 px-4 py-3">
                        <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-white text-xs font-bold">
                            <%= esc(initials) %>
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-brand-900 truncate">
                                <%= esc(citizenName) %>
                            </p>
                            <p class="text-[11px] text-slate-500">
                                Citizen
                            </p>
                        </div>
                    </div>
                    <nav class="mt-6 flex-1 space-y-1 px-3">
                        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                            <i data-lucide="layout-dashboard" class="h-4 w-4 shrink-0"></i>
                            <span>Dashboard</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                            <i data-lucide="file-plus-2" class="h-4 w-4 shrink-0"></i>
                            <span>Apply for Service</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
                            <i data-lucide="search-check" class="h-4 w-4 shrink-0"></i>
                            <span>Track Application</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                            <i data-lucide="credit-card" class="h-4 w-4 shrink-0"></i>
                            <span>Payments & Tax</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                            <i data-lucide="badge-check" class="h-4 w-4 shrink-0"></i>
                            <span>Certificates</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                            <i data-lucide="folder-open" class="h-4 w-4 shrink-0"></i>
                            <span>My Documents</span>
                        </a>
                    </nav>
                    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3">
                        <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600">
                            <i data-lucide="log-out" class="h-4 w-4 shrink-0"></i>
                            <span>Logout</span>
                        </a>
                    </div>
                </aside>
            <% } %>
            <div class="<%= loggedIn?"ml-[220px]":"" %> flex-1 flex flex-col min-h-screen">
                <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900">
                            Track Application
                        </h1>
                        <p class="text-xs text-slate-500">
                            Check the status of your applications
                        </p>
                    </div>
                    <% if(loggedIn){ %>
                        <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %>
                                <span class="absolute -right-1 -top-1 min-w-[18px] rounded-full bg-red-500 px-1.5 py-0.5 text-center text-[10px] font-bold text-white">
                                    <%= unread %>
                                </span>
                            <% } %>
                        </a>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white">
                            Login
                        </a>
                    <% } %>
                </header>
                <main class="flex-1 px-8 py-8 overflow-y-auto">
                    <% if(formError!=null){ %>
                        <div class="mb-6 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <%= esc(formError) %>
                        </div>
                    <% } %>
                    <section class="mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                        <form method="get" action="<%= action %>" class="flex gap-3">
                            <input name="trackingId" value="<%= esc(request.getParameter("trackingId")) %>" placeholder="Enter Tracking ID" class="flex-1 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm">
                            <button class="rounded-xl bg-brand-900 px-6 py-3 text-sm font-semibold text-white" type="submit">
                                Search
                            </button>
                        </form>
                    </section>
                    <% if(Boolean.TRUE.equals(trackingSearched)){ if(trackingResult==null){ %>
                        <div class="mb-8 rounded-2xl border border-red-100 bg-red-50 p-6 text-center">
                            <p class="text-sm font-semibold text-red-600">
                                No application found
                            </p>
                        </div>
                    <% } else { %>
                        <article class="mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                            <div class="flex items-center justify-between">
                                <h2 class="text-lg font-bold text-brand-900">
                                    #<%= esc(trackingResult.getTrackingId()) %>
                                </h2>
                                <span class="rounded-full <%= badgeClass(trackingResult.getStatus()) %> px-3 py-1 text-xs font-semibold">
                                    <%= esc(trackingResult.getStatus()) %>
                                </span>
                            </div>
                            <div class="mt-4 grid gap-3 text-sm text-slate-600 md:grid-cols-3">
                                <p>
                                    <strong>
                                        Application ID:
                                    </strong>
                                    <%= trackingResult.getApplicationId() %>
                                </p>
                                <p>
                                    <strong>
                                        Submitted:
                                    </strong>
                                    <%= trackingResult.getSubmittedAt()==null?"":esc(trackingResult.getSubmittedAt().format(fmt)) %>
                                </p>
                                <p>
                                    <strong>
                                        Updated:
                                    </strong>
                                    <%= trackingResult.getLastUpdatedAt()==null?"":esc(trackingResult.getLastUpdatedAt().format(fmt)) %>
                                </p>
                            </div>
                            <p class="mt-4 text-sm text-slate-600">
                                <strong>
                                    Remarks:
                                </strong>
                                <%= esc(trackingResult.getRemarks()==null?"-":trackingResult.getRemarks()) %>
                            </p>
                        </article>
                    <% }} %>
                    <% if(loggedIn){ %>
                        <section class="rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
                            <table class="w-full text-left text-sm">
                                <thead>
                                    <tr class="border-b border-slate-100">
                                        <th class="px-6 py-3">
                                            Tracking ID
                                        </th>
                                        <th class="px-6 py-3">
                                            Status
                                        </th>
                                        <th class="px-6 py-3">
                                            Submitted
                                        </th>
                                        <th class="px-6 py-3">
                                            Updated
                                        </th>
                                        <th class="px-6 py-3">
                                            Remarks
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(applications.isEmpty()){ %>
                                        <tr>
                                            <td colspan="5" class="px-6 py-8 text-center text-slate-400">
                                                No applications
                                            </td>
                                        </tr>
                                    <% } else { for(Application a:applications){ %>
                                        <tr class="border-b border-slate-50">
                                            <td class="px-6 py-4 font-semibold text-brand-900">
                                                <a href="<%= request.getContextPath() %>/citizen/tracking?trackingId=<%= esc(a.getTrackingId()) %>">
                                                    #<%= esc(a.getTrackingId()) %>
                                                </a>
                                            </td>
                                            <td class="px-6 py-4">
                                                <span class="rounded-full <%= badgeClass(a.getStatus()) %> px-3 py-1 text-xs font-semibold">
                                                    <%= esc(a.getStatus()) %>
                                                </span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <%= a.getSubmittedAt()==null?"":esc(a.getSubmittedAt().format(fmt)) %>
                                            </td>
                                            <td class="px-6 py-4">
                                                <%= a.getLastUpdatedAt()==null?"":esc(a.getLastUpdatedAt().format(fmt)) %>
                                            </td>
                                            <td class="px-6 py-4">
                                                <%= esc(a.getRemarks()==null?"-":a.getRemarks()) %>
                                            </td>
                                        </tr>
                                    <% }} %>
                                </tbody>
                            </table>
                        </section>
                    <% } %>
                </main>
            </div>
        </div>
    </body>
</html>
