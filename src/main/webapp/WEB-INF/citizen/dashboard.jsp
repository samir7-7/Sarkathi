<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="Model.Notification" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! 
    private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} 
    private String badgeClass(String status){
        if("approved".equals(status)) return "bg-emerald-50 text-emerald-600 border-emerald-200";
        if("rejected".equals(status)) return "bg-red-50 text-red-600 border-red-200";
        if("review".equals(status)) return "bg-amber-50 text-amber-600 border-amber-200";
        return "bg-blue-50 text-blue-600 border-blue-200";
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
                                100:'#e0ebf8',
                                500:'#3b82f6',
                                800:'#154a91',
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
            .mobile-submission-card { border: 1px solid #e2e8f0; border-radius: 16px; padding: 14px; background: #fff; }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/ui-improvements.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/typography.css">
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <%@ include file="../includes/mobile-nav-citizen.jsp" %>

            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            
            <%@ include file="../includes/sidebar-citizen.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">

                <!-- Desktop Header -->
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200/80 bg-white px-8 py-4">
                    <div>
                        <h1 class="text-xl font-extrabold text-slate-900 tracking-tight">Dashboard</h1>
                        <p class="text-xs text-slate-400 font-medium mt-0.5">Manage your applications and services</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2.5 text-slate-400 hover:text-brand-900 transition-colors border border-slate-200 rounded-xl hover:bg-slate-50">
                            <i data-lucide="bell" class="h-[18px] w-[18px]"></i>
                            <% if(unread>0){ %>
                                <span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span>
                            <% } %>
                        </a>
                        <div class="h-9 w-9 rounded-xl bg-brand-900 text-white flex items-center justify-center text-xs font-bold"><%= citizenName.substring(0,1).toUpperCase() %></div>
                    </div>
                </header>

                <!-- Mobile Header -->
                <div class="lg:hidden flex items-start justify-between gap-3 px-4 sm:px-5 pt-5 pb-4">
                     <div class="flex flex-col">
                        <h1 class="text-2xl font-black text-slate-900 tracking-tight leading-tight">SarkarSathi</h1>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-[0.2em]">Citizen Services</p>
                    </div>
                    <div class="flex items-center gap-2">
                         <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-11 w-11 items-center justify-center rounded-2xl bg-white text-slate-500 shadow-sm border border-slate-200 active:scale-95 transition-transform">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %>
                                <span class="absolute top-2.5 right-2.5 h-2.5 w-2.5 rounded-full bg-red-500 ring-2 ring-white"></span>
                            <% } %>
                        </a>
                    </div>
                </div>

                <main class="flex-1 px-3 py-4 sm:px-6 lg:px-8 overflow-y-auto w-full pb-24 lg:pb-8">

                    <!-- ── Gradient Stat Cards ── -->
                    <div class="grid gap-3 sm:gap-4 grid-cols-1 min-[420px]:grid-cols-2 lg:grid-cols-4 mb-6">
                        <div class="relative overflow-hidden rounded-2xl p-5 bg-gradient-to-br from-orange-400 via-orange-300 to-amber-200 shadow-sm">
                            <div class="absolute -right-4 -top-4 w-20 h-20 rounded-full bg-white/10"></div>
                            <div class="absolute right-3 bottom-3 w-10 h-10 rounded-full bg-white/5"></div>
                            <div class="relative">
                                <div class="h-9 w-9 rounded-xl bg-white/25 backdrop-blur flex items-center justify-center text-white mb-3">
                                    <i data-lucide="file-text" class="h-[18px] w-[18px]"></i>
                                </div>
                                <p class="text-white/80 text-[10px] font-bold uppercase tracking-widest">Applications</p>
                                <p class="text-2xl font-black text-white mt-0.5"><%= applicationCount %></p>
                            </div>
                        </div>
                        <div class="relative overflow-hidden rounded-2xl p-5 bg-gradient-to-br from-emerald-400 via-emerald-300 to-teal-200 shadow-sm">
                            <div class="absolute -right-4 -top-4 w-20 h-20 rounded-full bg-white/10"></div>
                            <div class="absolute right-3 bottom-3 w-10 h-10 rounded-full bg-white/5"></div>
                            <div class="relative">
                                <div class="h-9 w-9 rounded-xl bg-white/25 backdrop-blur flex items-center justify-center text-white mb-3">
                                    <i data-lucide="check-circle" class="h-[18px] w-[18px]"></i>
                                </div>
                                <p class="text-white/80 text-[10px] font-bold uppercase tracking-widest">Approved</p>
                                <p class="text-2xl font-black text-white mt-0.5"><%= approvedApplicationCount %></p>
                            </div>
                        </div>
                        <div class="relative overflow-hidden rounded-2xl p-5 bg-gradient-to-br from-violet-400 via-purple-300 to-fuchsia-200 shadow-sm">
                            <div class="absolute -right-4 -top-4 w-20 h-20 rounded-full bg-white/10"></div>
                            <div class="absolute right-3 bottom-3 w-10 h-10 rounded-full bg-white/5"></div>
                            <div class="relative">
                                <div class="h-9 w-9 rounded-xl bg-white/25 backdrop-blur flex items-center justify-center text-white mb-3">
                                    <i data-lucide="clock-3" class="h-[18px] w-[18px]"></i>
                                </div>
                                <p class="text-white/80 text-[10px] font-bold uppercase tracking-widest">Pending</p>
                                <p class="text-2xl font-black text-white mt-0.5"><%= pendingApplicationCount %></p>
                            </div>
                        </div>
                        <div class="relative overflow-hidden rounded-2xl p-5 bg-gradient-to-br from-sky-400 via-blue-300 to-indigo-200 shadow-sm">
                            <div class="absolute -right-4 -top-4 w-20 h-20 rounded-full bg-white/10"></div>
                            <div class="absolute right-3 bottom-3 w-10 h-10 rounded-full bg-white/5"></div>
                            <div class="relative">
                                <div class="h-9 w-9 rounded-xl bg-white/25 backdrop-blur flex items-center justify-center text-white mb-3">
                                    <i data-lucide="award" class="h-[18px] w-[18px]"></i>
                                </div>
                                <p class="text-white/80 text-[10px] font-bold uppercase tracking-widest">Certificates</p>
                                <p class="text-2xl font-black text-white mt-0.5"><%= certificateCount %></p>
                            </div>
                        </div>
                    </div>

                    <!-- ── Main Content Grid ── -->
                    <div class="grid gap-5 lg:grid-cols-3">

                        <!-- Recent Submissions Table -->
                        <section class="lg:col-span-2 rounded-2xl border border-slate-200/80 bg-white shadow-sm flex flex-col overflow-hidden">
                            <div class="px-4 sm:px-6 py-4 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                                <div>
                                    <h2 class="text-sm font-bold text-slate-900">Recent Submissions</h2>
                                    <p class="text-[11px] text-slate-400 font-medium mt-0.5">Your latest application activity</p>
                                </div>
                                <a href="<%= request.getContextPath() %>/citizen/tracking" class="inline-flex items-center gap-1.5 text-xs font-bold text-brand-900 hover:text-brand-800 bg-brand-50 px-3.5 py-2 rounded-lg transition-colors">
                                    View All
                                    <i data-lucide="arrow-right" class="h-3.5 w-3.5"></i>
                                </a>
                            </div>
                            <div class="space-y-3 p-3 sm:hidden">
                                <% if(applications.isEmpty()){ %>
                                    <div class="mobile-submission-card text-center text-slate-400 font-semibold">No activity recorded yet</div>
                                <% } else { for(Application a : applications.subList(0, Math.min(5, applications.size()))){ %>
                                    <article class="mobile-submission-card">
                                        <div class="flex items-start justify-between gap-3">
                                            <div>
                                                <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Tracking ID</p>
                                                <p class="mt-1 text-sm font-black text-slate-900">#<%= esc(a.getTrackingId()) %></p>
                                            </div>
                                            <span class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold uppercase border rounded-lg <%= badgeClass(a.getStatus()) %>"><%= esc(a.getStatus()) %></span>
                                        </div>
                                        <div class="mt-3 grid gap-2 text-sm">
                                            <div class="flex items-center justify-between gap-3">
                                                <span class="text-slate-400 font-semibold">Service</span>
                                                <span class="text-right text-slate-700 font-medium"><%= esc(a.getServiceTypeName()) %></span>
                                            </div>
                                            <div class="flex items-center justify-between gap-3">
                                                <span class="text-slate-400 font-semibold">Date</span>
                                                <span class="text-slate-500 text-xs"><%= a.getSubmittedAt()==null ? "-" : esc(a.getSubmittedAt().format(fmt)) %></span>
                                            </div>
                                        </div>
                                    </article>
                                <% }} %>
                            </div>
                            <div class="hidden sm:block overflow-x-auto">
                                <table class="w-full text-left text-sm whitespace-nowrap">
                                    <thead class="bg-slate-50/80 text-[10px] font-bold uppercase tracking-wider text-slate-400 border-b border-slate-100">
                                        <tr>
                                            <th class="px-6 py-3.5">Tracking ID</th>
                                            <th class="px-6 py-3.5">Service</th>
                                            <th class="px-6 py-3.5">Status</th>
                                            <th class="px-6 py-3.5 text-right">Date</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-100/80">
                                        <% if(applications.isEmpty()){ %>
                                            <tr><td colspan="4" class="px-6 py-14 text-center text-slate-300 font-semibold text-sm">
                                                <i data-lucide="inbox" class="h-8 w-8 mx-auto mb-2 text-slate-200"></i>
                                                No activity recorded yet
                                            </td></tr>
                                        <% } else { for(Application a : applications.subList(0, Math.min(5, applications.size()))){ %>
                                            <tr class="hover:bg-slate-50/50 transition-colors">
                                                <td class="px-6 py-4 font-bold text-slate-900 text-[13px]">#<%= esc(a.getTrackingId()) %></td>
                                                <td class="px-6 py-4 text-slate-500 font-medium text-[12px] truncate max-w-[200px]"><%= esc(a.getServiceTypeName()) %></td>
                                                <td class="px-6 py-4">
                                                    <span class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold uppercase border rounded-lg <%= badgeClass(a.getStatus()) %>"><%= esc(a.getStatus()) %></span>
                                                </td>
                                                <td class="px-6 py-4 text-right text-xs font-medium text-slate-400"><%= a.getSubmittedAt()==null ? "—" : esc(a.getSubmittedAt().format(fmt)) %></td>
                                            </tr>
                                        <% }} %>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                        <!-- Right Column -->
                        <div class="space-y-5 flex flex-col">
                            <!-- Quick Actions -->
                            <div class="bg-white p-4 sm:p-5 rounded-2xl border border-slate-200/80 shadow-sm lg:order-none order-first">
                                <h3 class="text-sm font-bold text-slate-900 mb-4">Quick Actions</h3>
                                <div class="grid grid-cols-2 gap-2 sm:gap-2.5">
                                    <a href="<%= request.getContextPath() %>/citizen/apply" class="group flex flex-col items-center justify-center gap-2.5 rounded-xl bg-brand-900 text-white px-3 py-4 text-center hover:bg-brand-800 transition-all hover:shadow-lg hover:shadow-brand-900/20 hover:-translate-y-0.5">
                                        <div class="h-9 w-9 rounded-lg bg-white/15 flex items-center justify-center group-hover:bg-white/25 transition-colors"><i data-lucide="plus-circle" class="h-5 w-5"></i></div>
                                        <span class="text-[10px] font-bold uppercase tracking-wider leading-tight">New<br/>Application</span>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="group flex flex-col items-center justify-center gap-2.5 rounded-xl border-2 border-brand-100 bg-brand-50/50 px-3 py-4 text-center text-brand-900 hover:bg-brand-100 transition-all hover:-translate-y-0.5">
                                        <div class="h-9 w-9 rounded-lg bg-brand-100 flex items-center justify-center group-hover:bg-brand-200 transition-colors"><i data-lucide="search-check" class="h-5 w-5"></i></div>
                                        <span class="text-[10px] font-bold uppercase tracking-wider leading-tight">Track<br/>Status</span>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/citizen/documents" class="group flex flex-col items-center justify-center gap-2.5 rounded-xl border border-slate-200 px-3 py-4 text-center text-slate-600 hover:bg-slate-50 transition-all hover:-translate-y-0.5">
                                        <div class="h-9 w-9 rounded-lg bg-slate-100 flex items-center justify-center group-hover:bg-slate-200 transition-colors"><i data-lucide="folder-open" class="h-5 w-5"></i></div>
                                        <span class="text-[10px] font-bold uppercase tracking-wider leading-tight">My<br/>Documents</span>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/citizen/certificates" class="group flex flex-col items-center justify-center gap-2.5 rounded-xl border border-slate-200 px-3 py-4 text-center text-slate-600 hover:bg-slate-50 transition-all hover:-translate-y-0.5">
                                        <div class="h-9 w-9 rounded-lg bg-slate-100 flex items-center justify-center group-hover:bg-slate-200 transition-colors"><i data-lucide="award" class="h-5 w-5"></i></div>
                                        <span class="text-[10px] font-bold uppercase tracking-wider leading-tight">My<br/>Certificates</span>
                                    </a>
                                </div>
                            </div>
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
