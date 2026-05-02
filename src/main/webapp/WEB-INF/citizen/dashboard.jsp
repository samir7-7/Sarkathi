<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="Model.Notification" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! 
    private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} 
    private String badgeClass(String status){
        if("approved".equals(status)) return "bg-green-100 text-green-700 border-green-200";
        if("rejected".equals(status)) return "bg-red-100 text-red-700 border-red-200";
        if("review".equals(status)) return "bg-amber-100 text-amber-700 border-amber-200";
        return "bg-blue-100 text-blue-700 border-blue-200";
    } 
%>
<% 
    Integer citizenId = (Integer)request.getAttribute("citizenId"); 
    String citizenName = (String)request.getAttribute("citizenName"); 
    String citizenEmail = (String)request.getAttribute("citizenEmail"); 
    Integer unread = (Integer)request.getAttribute("unreadCount"); 
    Number applicationCount = (Number)request.getAttribute("applicationCount"); 
    Number approvedApplicationCount = (Number)request.getAttribute("approvedApplicationCount"); 
    Number pendingApplicationCount = (Number)request.getAttribute("pendingApplicationCount"); 
    Number certificateCount = (Number)request.getAttribute("certificateCount"); 
    List<Application> applications = (List<Application>)request.getAttribute("applications"); 
    List<Notification> notifications = (List<Notification>)request.getAttribute("sharedNotifications"); 
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy"); 
    
    if(citizenName == null) citizenName = "Citizen";
    if(unread == null) unread = 0;
    if(applicationCount == null) applicationCount = 0;
    if(approvedApplicationCount == null) approvedApplicationCount = 0;
    if(pendingApplicationCount == null) pendingApplicationCount = 0;
    if(certificateCount == null) certificateCount = 0;
    if(applications == null) applications = List.of();
    if(notifications == null) notifications = List.of();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Citizen Dashboard - SarkarSathi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config={
                theme:{
                    extend:{
                        fontFamily:{sans:['Outfit','sans-serif']},
                        colors:{
                            brand:{
                                50:'#f0f5fc',
                                500:'#3b82f6',
                                900:'#0b3d86'
                            }
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 600; }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-brand-900">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-bold">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Apply</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Track</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/notifications" class="flex flex-col items-center justify-center gap-1 text-slate-500 relative">
                    <i data-lucide="bell" class="h-5 w-5"></i>
                    <% if(unread>0){ %>
                        <span class="absolute top-0 right-1 h-2 w-2 rounded-full bg-red-500"></span>
                    <% } %>
                    <span class="text-[10px] font-medium">Inbox</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Menu</span>
                </button>
            </nav>

            <!-- Sidebar (Laptop: Simple, Mobile: Drawer) -->
            <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 -translate-x-full border-r border-slate-200 bg-white transition-transform duration-300 lg:static lg:translate-x-0">
                <div class="flex h-full flex-col">
                    <div class="p-6 border-b border-slate-100 flex items-center justify-between">
                        <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a>
                        <button onclick="toggleSidebar()" class="lg:hidden p-2 text-slate-400"><i data-lucide="x" class="h-5 w-5"></i></button>
                    </div>

                    <div class="p-6">
                        <div class="flex items-center gap-3 p-4 rounded-2xl bg-slate-50 border border-slate-100 mb-8">
                            <div class="h-10 w-10 flex items-center justify-center rounded-xl bg-brand-900 text-white font-bold uppercase text-xs">
                                <%= citizenName.substring(0,1).toUpperCase() %>
                            </div>
                            <div class="overflow-hidden">
                                <p class="text-sm font-bold text-slate-900 truncate uppercase tracking-tight text-ellipsis"><%= esc(citizenName) %></p>
                                <p class="text-[10px] font-medium text-slate-500 uppercase tracking-widest">Citizen Profile</p>
                            </div>
                        </div>

                        <nav class="space-y-1">
                            <p class="px-2 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-4">CORE</p>
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link active flex items-center gap-3 rounded-xl px-4 py-3 text-sm">
                                <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                                <span>Home Board</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                                <span>Apply for Service</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="search-check" class="h-5 w-5"></i>
                                <span>Track Status</span>
                            </a>
                            <p class="px-2 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-8">RECORDS</p>
                            <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="credit-card" class="h-5 w-5"></i>
                                <span>Payments & Tax</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="award" class="h-5 w-5"></i>
                                <span>My Certificates</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="folder-open" class="h-5 w-5"></i>
                                <span>My Documents</span>
                            </a>
                        </nav>
                    </div>

                    <div class="mt-auto p-6 border-t border-slate-100 pb-20 lg:pb-6">
                        <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-3 px-4 py-3 text-sm font-medium text-red-600 hover:bg-red-50 rounded-xl transition-colors">
                            <i data-lucide="log-out" class="h-5 w-5"></i>
                            <span>Logout Session</span>
                        </a>
                    </div>
                </div>
            </aside>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <!-- Laptop Header: Simple -->
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200 bg-white px-8 py-4">
                    <div>
                        <h1 class="text-xl font-bold text-slate-900 tracking-tight">Citizen Portal</h1>
                        <p class="text-xs text-slate-500 font-medium mt-0.5">Manage your municipal services and track applications</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2 text-slate-500 hover:text-brand-900 transition-colors border border-slate-100 rounded-xl">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %>
                                <span class="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span>
                            <% } %>
                        </a>
                    </div>
                </header>

                <!-- Mobile Header: Modern -->
                <div class="lg:hidden flex items-center justify-between px-5 pt-6 pb-4 bg-[#fafafc]">
                     <div class="flex flex-col">
                        <h1 class="text-2xl font-extrabold text-slate-900 tracking-tight leading-tight">SarkarSathi</h1>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em]">Government Hub</p>
                    </div>
                    <div class="flex items-center gap-2">
                         <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-11 w-11 items-center justify-center rounded-2xl bg-white text-slate-600 shadow-sm border border-slate-100 active:scale-95 transition-transform">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %>
                                <span class="absolute top-2.5 right-2.5 h-2.5 w-2.5 rounded-full bg-red-500 ring-2 ring-white"></span>
                            <% } %>
                        </a>
                    </div>
                </div>

                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-7xl mx-auto pb-32 lg:pb-8">
                    <!-- Metric Cards: Consistent Grid -->
                    <div class="grid gap-4 grid-cols-2 lg:grid-cols-4">
                        <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                            <div class="h-10 w-10 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 mb-4">
                                <i data-lucide="file-text" class="h-5 w-5"></i>
                            </div>
                            <p class="text-[11px] font-bold uppercase tracking-wider text-slate-400">Applications</p>
                            <p class="mt-1 text-2xl font-bold text-slate-900"><%= applicationCount %></p>
                        </div>
                        <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                             <div class="h-10 w-10 rounded-2xl bg-green-50 flex items-center justify-center text-green-600 mb-4">
                                <i data-lucide="check-circle" class="h-5 w-5"></i>
                            </div>
                            <p class="text-[11px] font-bold uppercase tracking-wider text-slate-400">Approved</p>
                            <p class="mt-1 text-2xl font-bold text-green-600"><%= approvedApplicationCount %></p>
                        </div>
                        <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                            <div class="h-10 w-10 rounded-2xl bg-amber-50 flex items-center justify-center text-amber-600 mb-4">
                                <i data-lucide="clock" class="h-5 w-5"></i>
                            </div>
                            <p class="text-[11px] font-bold uppercase tracking-wider text-slate-400">Pending</p>
                            <p class="mt-1 text-2xl font-bold text-amber-600"><%= pendingApplicationCount %></p>
                        </div>
                        <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                            <div class="h-10 w-10 rounded-2xl bg-brand-50 flex items-center justify-center text-brand-900 mb-4">
                                <i data-lucide="award" class="h-5 w-5"></i>
                            </div>
                            <p class="text-[11px] font-bold uppercase tracking-wider text-slate-400">Certificates</p>
                            <p class="mt-1 text-2xl font-bold text-brand-900"><%= certificateCount %></p>
                        </div>
                    </div>

                    <div class="mt-8 grid gap-6 lg:grid-cols-3">
                        <!-- Table Section -->
                        <section class="lg:col-span-2 rounded-3xl border border-slate-200 bg-white shadow-sm flex flex-col h-fit">
                            <div class="px-6 py-5 border-b border-slate-100 flex items-center justify-between bg-white rounded-t-3xl">
                                <h2 class="text-base font-bold text-slate-800 uppercase tracking-tight">Recent Submissions</h2>
                                <a href="<%= request.getContextPath() %>/citizen/tracking" class="text-xs font-bold text-brand-500 hover:underline">View All</a>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left text-sm whitespace-nowrap">
                                    <thead class="bg-slate-50 text-[10px] font-bold uppercase tracking-widest text-slate-400 border-b border-slate-100">
                                        <tr>
                                            <th class="px-6 py-4">ID</th>
                                            <th class="px-6 py-4">Service</th>
                                            <th class="px-6 py-4">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-50">
                                        <% if(applications.isEmpty()){ %>
                                            <tr><td colspan="3" class="px-6 py-12 text-center text-slate-400 italic">No activity recorded yet</td></tr>
                                        <% } else { for(Application a : applications.subList(0, Math.min(5, applications.size()))){ %>
                                            <tr class="hover:bg-slate-50/50 transition-colors">
                                                <td class="px-6 py-5 font-bold text-slate-900">#<%= esc(a.getTrackingId()) %></td>
                                                <td class="px-6 py-5 text-slate-600 font-medium uppercase text-[11px] tracking-tight truncate max-w-[200px]"><%= esc(a.getServiceTypeName()) %></td>
                                                <td class="px-6 py-5">
                                                    <span class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold uppercase border rounded-lg <%= badgeClass(a.getStatus()) %>"><%= esc(a.getStatus()) %></span>
                                                </td>
                                            </tr>
                                        <% }} %>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                        <!-- Updates Section -->
                        <div class="space-y-6 flex flex-col h-full">
                            <div class="bg-brand-900 p-8 rounded-3xl shadow-lg border border-brand-800 lg:order-none order-first">
                                <h3 class="text-white text-lg font-bold mb-2">Need a Service?</h3>
                                <p class="text-blue-100/70 text-sm mb-6 font-medium leading-relaxed">Initiate a new municipal request or upload verification documents.</p>
                                <a href="<%= request.getContextPath() %>/citizen/apply" class="block w-full text-center bg-white text-brand-900 py-4 rounded-2xl text-xs font-bold uppercase tracking-widest shadow-sm hover:bg-slate-50 transition-colors">Apply New</a>
                            </div>

                            <section class="rounded-3xl border border-slate-200 bg-white shadow-sm p-6 flex-1">
                                <div class="flex items-center justify-between mb-6">
                                    <h2 class="text-base font-bold text-slate-800 uppercase tracking-tight leading-none">News & Feed</h2>
                                    <% if(unread>0){ %><span class="bg-red-500 text-white text-[10px] font-bold px-2 py-1 rounded-full"><%= unread %></span><% } %>
                                </div>
                                <div class="space-y-6">
                                    <% if(notifications.isEmpty()){ %>
                                        <p class="text-center py-12 text-slate-400 text-xs italic font-medium">No new updates found</p>
                                    <% } else { for(Notification n : notifications.subList(0, Math.min(3, notifications.size()))){ %>
                                        <div class="group border-b border-slate-50 pb-4 last:border-0 last:pb-0">
                                            <p class="text-sm font-bold text-slate-900 group-hover:text-brand-500 transition-colors truncate"><%= esc(n.getTitle()) %></p>
                                            <p class="mt-1 text-xs text-slate-500 font-medium line-clamp-2 leading-relaxed"><%= esc(n.getMessage()) %></p>
                                        </div>
                                    <% }} %>
                                </div>
                                <a href="<%= request.getContextPath() %>/citizen/notifications" class="block text-center mt-6 text-xs font-bold text-slate-400 hover:text-brand-900 uppercase tracking-widest">Full Inbox</a>
                            </section>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                if (sidebar) sidebar.classList.toggle('-translate-x-full');
            }
            lucide.createIcons();
        </script>
    </body>
</html>