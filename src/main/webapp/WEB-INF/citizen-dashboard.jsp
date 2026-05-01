<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="Model.Notification" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} private String badgeClass(String status){if("approved".equals(status))return"bg-green-50 text-green-700";if("rejected".equals(status))return"bg-red-50 text-red-600";if("review".equals(status))return"bg-amber-50 text-amber-700";return"bg-blue-50 text-blue-700";} %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId"); String citizenName=(String)request.getAttribute("citizenName"); String citizenEmail=(String)request.getAttribute("citizenEmail"); Integer unread=(Integer)request.getAttribute("unreadCount"); Number applicationCount=(Number)request.getAttribute("applicationCount"); Number approvedApplicationCount=(Number)request.getAttribute("approvedApplicationCount"); Number pendingApplicationCount=(Number)request.getAttribute("pendingApplicationCount"); Number certificateCount=(Number)request.getAttribute("certificateCount"); List<Application> applications=(List<Application>)request.getAttribute("applications"); List<Notification> notifications=(List<Notification>)request.getAttribute("sharedNotifications"); DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMM d, yyyy"); if(citizenName==null)citizenName="Citizen";if(citizenEmail==null)citizenEmail="";if(unread==null)unread=0;if(applicationCount==null)applicationCount=0;if(approvedApplicationCount==null)approvedApplicationCount=0;if(pendingApplicationCount==null)pendingApplicationCount=0;if(certificateCount==null)certificateCount=0;if(applications==null)applications=List.of();if(notifications==null)notifications=List.of();String initials=citizenName.isBlank()?"C":citizenName.substring(0,1).toUpperCase(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Citizen Dashboard - SarkarSathi
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
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <div class="flex min-h-screen">
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
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
                        Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Apply for Service
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Track Application
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Payments & Tax
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Certificates
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        My Documents
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600">
                        Logout
                    </a>
                </div>
            </aside>
            <div class="ml-[220px] flex-1 flex flex-col min-h-screen">
                <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900">
                            Welcome back,
                            <%= esc(citizenName) %>
                        </h1>
                        <p class="text-xs text-slate-500">
                            <%= esc(citizenEmail) %>
                        </p>
                    </div>
                    <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600">
                        Bell
                        <% if(unread>0){ %>
                            <span class="absolute -right-1 -top-1 min-w-[18px] rounded-full bg-red-500 px-1.5 py-0.5 text-center text-[10px] font-bold text-white">
                                <%= unread %>
                            </span>
                        <% } %>
                    </a>
                </header>
                <main class="flex-1 px-8 py-8 overflow-y-auto">
                    <div class="grid gap-4 md:grid-cols-4">
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                My Applications
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= applicationCount %>
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Approved
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= approvedApplicationCount %>
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Pending
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= pendingApplicationCount %>
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Certificates
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= certificateCount %>
                            </p>
                        </div>
                    </div>
                    <div class="mt-8 grid gap-6 lg:grid-cols-3">
                        <section class="lg:col-span-2 rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
                            <div class="px-6 pt-6 pb-4 flex items-center justify-between">
                                <h2 class="text-lg font-bold text-slate-900">
                                    My Applications
                                </h2>
                                <a href="<%= request.getContextPath() %>/citizen/tracking" class="text-sm font-semibold text-brand-500">
                                    View All
                                </a>
                            </div>
                            <table class="w-full text-left text-sm">
                                <thead>
                                    <tr class="border-y border-slate-100">
                                        <th class="px-6 py-3">
                                            Tracking
                                        </th>
                                        <th class="px-6 py-3">
                                            Status
                                        </th>
                                        <th class="px-6 py-3">
                                            Date
                                        </th>
                                        <th class="px-6 py-3">
                                            Remarks
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(applications.isEmpty()){ %>
                                        <tr>
                                            <td colspan="4" class="px-6 py-8 text-center text-slate-400">
                                                No applications yet
                                            </td>
                                        </tr>
                                    <% } else { int shown=0; for(Application a: applications){ if(shown++>=10)break; %>
                                    <tr class="border-b border-slate-50">
                                        <td class="px-6 py-4 font-semibold text-brand-900">
                                            #<%= esc(a.getTrackingId()) %>
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
                                            <%= esc(a.getRemarks()==null?"-":a.getRemarks()) %>
                                        </td>
                                    </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </section>
                    <section class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                        <div class="flex items-center justify-between">
                            <h2 class="text-lg font-bold text-slate-900">
                                Recent Notifications
                            </h2>
                            <a href="<%= request.getContextPath() %>/citizen/notifications" class="text-sm font-semibold text-brand-500">
                                View All
                            </a>
                        </div>
                        <div class="mt-4 space-y-3">
                            <% if(notifications.isEmpty()){ %>
                                <p class="text-sm text-slate-400 py-4 text-center">
                                    No notifications
                                </p>
                            <% } else { int nShown=0; for(Notification n: notifications){ if(nShown++>=5)break; %>
                            <div class="rounded-xl px-4 py-3 <%= n.isRead()?"bg-slate-50":"bg-blue-50/70" %>">
                                <p class="text-sm text-slate-700">
                                    <%= esc(n.getMessage()) %>
                                </p>
                            </div>
                        <% }} %>
                    </div>
                </section>
            </div>
        </main>
    </div>
</div>
</body>
</html>
