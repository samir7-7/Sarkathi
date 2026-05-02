<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="Model.Notification" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! 
    private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} 
    private String badgeClass(String status){
        if("approved".equals(status)) return "bg-emerald-500/10 text-emerald-500 border-emerald-500/20";
        if("rejected".equals(status)) return "bg-rose-500/10 text-rose-500 border-rose-500/20";
        if("review".equals(status)) return "bg-amber-500/10 text-amber-500 border-amber-500/20";
        return "bg-brand-500/10 text-brand-500 border-brand-500/20";
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
    if(citizenEmail == null) citizenEmail = "";
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
        <title>Dashboard - SarkarSathi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config={
                theme:{
                    extend:{
                        fontFamily:{sans:['Outfit','sans-serif']},
                        colors:{
                            brand:{
                                50:'#f0f5fc',
                                100:'#e1eafa',
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
            .glass-panel {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 700; }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#f8fafc] text-slate-900 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-brand-900">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Portal</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Track</span>
                </a>
                <div class="relative -top-3">
                    <a href="<%= request.getContextPath() %>/citizen/apply" class="flex h-14 w-14 items-center justify-center rounded-2xl bg-brand-900 text-white shadow-lg shadow-brand-900/30">
                        <i data-lucide="plus" class="h-6 w-6"></i>
                    </a>
                </div>
                 <a href="<%= request.getContextPath() %>/citizen/notifications" class="flex flex-col items-center justify-center gap-1 text-slate-400 relative">
                    <i data-lucide="bell" class="h-5 w-5"></i>
                    <% if(unread>0){ %>
                        <span class="absolute top-0 right-0 h-2 w-2 rounded-full bg-rose-500"></span>
                    <% } %>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Inbox</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Menu</span>
                </button>
            </nav>

            <!-- Desktop Sidebar -->
            <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-72 -translate-x-full border-r border-slate-100 bg-white transition-transform duration-300 lg:static lg:translate-x-0">
                <div class="flex h-full flex-col p-6">
                    <div class="flex items-center justify-between">
                        <a href="<%= request.getContextPath() %>/" class="text-2xl font-black text-brand-900 italic tracking-tighter">SarkarSathi</a>
                        <button onclick="toggleSidebar()" class="lg:hidden h-10 w-10 flex items-center justify-center rounded-xl bg-slate-50 text-slate-400">
                            <i data-lucide="x" class="h-5 w-5"></i>
                        </button>
                    </div>

                    <div class="mt-10 mb-6 px-4 py-8 rounded-[2rem] bg-brand-900 text-white shadow-2xl shadow-brand-900/20 relative overflow-hidden group">
                        <div class="absolute top-0 right-0 h-24 w-24 bg-white/5 rounded-bl-[3rem] -mr-8 -mt-8 rotate-12 group-hover:bg-white/10 transition-colors"></div>
                        <p class="text-[10px] font-black uppercase tracking-[0.3em] text-blue-300/80 mb-2">Authenticated Citizen</p>
                        <h4 class="text-xl font-black tracking-tight truncate"><%= esc(citizenName) %></h4>
                        <p class="text-[11px] font-medium text-blue-200/60 lowercase tracking-tight mt-1 opacity-80"><%= esc(citizenEmail) %></p>
                    </div>

                    <nav class="flex-1 space-y-2">
                        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link active group flex items-center gap-4 px-4 py-4 rounded-2xl text-[11px] font-black uppercase tracking-widest">
                            <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                            <span>Overview</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                            <i data-lucide="file-plus" class="h-5 w-5"></i>
                            <span>New Application</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                            <i data-lucide="search-check" class="h-5 w-5"></i>
                            <span>Registry Track</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                            <i data-lucide="award" class="h-5 w-5"></i>
                            <span>Issued Files</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                            <i data-lucide="folder-key" class="h-5 w-5"></i>
                            <span>Cloud Vault</span>
                        </a>
                    </nav>

                    <div class="pt-6 border-t border-slate-50">
                        <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-4 px-4 py-4 rounded-2xl text-rose-500 font-black uppercase tracking-widest text-[11px] hover:bg-rose-50 transition-colors">
                            <i data-lucide="log-out" class="h-5 w-5"></i>
                            <span>Terminate Session</span>
                        </a>
                    </div>
                </div>
            </aside>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <!-- Header -->
                <header class="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-slate-100 px-6 py-6 lg:px-12">
                    <div class="flex items-center justify-between max-w-7xl mx-auto">
                        <div>
                            <h1 class="text-2xl font-black text-slate-900 tracking-tighter uppercase italic">Registry.</h1>
                            <p class="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 mt-1">SarkarSathi Digital Ecosystem</p>
                        </div>
                        
                        <div class="flex items-center gap-4">
                            <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative h-12 w-12 flex items-center justify-center rounded-2xl border border-slate-100 text-slate-400 hover:text-brand-900 transition-colors group">
                                <i data-lucide="bell" class="h-5 w-5 group-hover:animate-swing"></i>
                                <% if(unread>0){ %>
                                    <span class="absolute top-3 right-3 h-2 w-2 rounded-full bg-rose-500 ring-2 ring-white"></span>
                                <% } %>
                            </a>
                            <div class="h-12 w-12 rounded-2xl bg-brand-50 flex items-center justify-center text-brand-900">
                                <i data-lucide="fingerprint" class="h-6 w-6"></i>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 p-6 lg:p-12 pb-32">
                    <div class="max-w-7xl mx-auto">
                        <!-- Identity Banner (Mobile Only) -->
                        <div class="lg:hidden mb-12 flex items-center justify-between">
                            <div>
                                <h2 class="text-3xl font-black text-slate-900 tracking-tighter uppercase font-black">Portal.</h2>
                                <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mt-1">Verified Unit #<%= citizenId %></p>
                            </div>
                            <div class="h-16 w-16 rounded-[2rem] bg-brand-900 text-white flex items-center justify-center text-xl font-black italic">
                                <%= citizenName.substring(0,1).toUpperCase() %>
                            </div>
                        </div>

                        <!-- Grid Metrics -->
                        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-8 mb-16">
                            <div class="bg-white p-8 rounded-[3rem] border border-slate-100 shadow-xl shadow-slate-200/50">
                                <div class="h-12 w-12 rounded-2xl bg-slate-50 text-slate-400 flex items-center justify-center mb-6">
                                    <i data-lucide="layers" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Entries</p>
                                <p class="text-3xl font-black text-slate-900 tracking-tighter mt-1"><%= applicationCount %></p>
                            </div>

                            <div class="bg-white p-8 rounded-[3rem] border border-slate-100 shadow-xl shadow-slate-200/50">
                                <div class="h-12 w-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center mb-6">
                                    <i data-lucide="clock" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-amber-400">Processing</p>
                                <p class="text-3xl font-black text-amber-600 tracking-tighter mt-1"><%= pendingApplicationCount %></p>
                            </div>

                            <div class="bg-white p-8 rounded-[3rem] border border-slate-100 shadow-xl shadow-slate-200/50 scale-105 ring-4 ring-brand-500/5">
                                <div class="h-12 w-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center mb-6">
                                    <i data-lucide="badge-check" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-emerald-400">Approved</p>
                                <p class="text-3xl font-black text-emerald-600 tracking-tighter mt-1"><%= approvedApplicationCount %></p>
                            </div>

                            <div class="bg-white p-8 rounded-[3rem] border border-slate-100 shadow-xl shadow-slate-200/50">
                                <div class="h-12 w-12 rounded-2xl bg-brand-50 text-brand-900 flex items-center justify-center mb-6">
                                    <i data-lucide="award" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-brand-400">Tokens</p>
                                <p class="text-3xl font-black text-brand-900 tracking-tighter mt-1"><%= certificateCount %></p>
                            </div>
                        </div>

                        <div class="grid lg:grid-cols-3 gap-8 lg:gap-12">
                            <!-- Queue Data -->
                            <section class="lg:col-span-2 bg-white rounded-[4rem] border border-slate-100 shadow-2xl shadow-slate-200/50 overflow-hidden">
                                <div class="p-10 lg:p-14 border-b border-slate-50 flex items-center justify-between">
                                    <div>
                                        <h3 class="text-2xl font-black text-slate-900 tracking-tighter italic">Latest Registry.</h3>
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mt-2">Personal Process Stream</p>
                                    </div>
                                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="h-12 w-12 rounded-2xl bg-slate-50 text-slate-400 flex items-center justify-center hover:bg-brand-900 hover:text-white transition-all">
                                        <i data-lucide="arrow-right" class="h-5 w-5"></i>
                                    </a>
                                </div>

                                <div class="divide-y divide-slate-50">
                                    <% if(applications.isEmpty()){ %>
                                        <div class="p-20 text-center">
                                            <i data-lucide="inbox" class="h-12 w-12 text-slate-200 mx-auto mb-6"></i>
                                            <p class="text-xs font-black uppercase tracking-widest text-slate-300 italic">No Process Data Detected</p>
                                        </div>
                                    <% } else { for(Application a : applications.subList(0, Math.min(5, applications.size()))){ %>
                                        <div class="p-8 lg:px-14 flex flex-col sm:flex-row sm:items-center justify-between gap-6 group hover:bg-slate-50 transition-colors">
                                            <div class="flex items-center gap-6">
                                                <div class="h-12 w-12 rounded-2xl bg-brand-50 text-brand-900 flex items-center justify-center font-black">#</div>
                                                <div>
                                                    <h4 class="text-[11px] font-black uppercase tracking-widest text-slate-900"><%= esc(a.getServiceTypeName()) %></h4>
                                                    <p class="text-[10px] font-bold text-slate-400 uppercase mt-1 tracking-tighter">REF: <%= esc(a.getTrackingId()) %></p>
                                                </div>
                                            </div>
                                            <div class="px-6 py-2.5 rounded-2xl border inline-flex items-center gap-3 <%= badgeClass(a.getStatus()) %>">
                                                <span class="h-1.5 w-1.5 rounded-full bg-current animate-pulse"></span>
                                                <span class="text-[10px] font-black uppercase tracking-widest"><%= esc(a.getStatus()) %></span>
                                            </div>
                                        </div>
                                    <% }} %>
                                </div>
                            </section>

                            <!-- Logic Feed -->
                            <section class="space-y-8">
                                <div class="bg-brand-900 p-10 rounded-[3.5rem] shadow-2xl shadow-brand-900/40 relative overflow-hidden group">
                                    <div class="absolute -top-10 -right-10 h-40 w-40 bg-white/5 rounded-full blur-3xl group-hover:bg-white/10 transition-colors"></div>
                                    <i data-lucide="zap" class="h-10 w-10 text-blue-400 mb-8"></i>
                                    <h3 class="text-2xl font-black text-white tracking-tighter mb-4 italic leading-tight">Apply for<br>Citizen Token.</h3>
                                    <p class="text-blue-200/60 text-xs font-bold uppercase tracking-widest mb-8">New Verification Protocol</p>
                                    <a href="<%= request.getContextPath() %>/citizen/apply" class="inline-flex items-center gap-4 bg-white text-brand-900 px-8 py-4 rounded-3xl text-[10px] font-black uppercase tracking-widest active:scale-95 transition-all">
                                        Genesis <i data-lucide="plus-circle" class="h-4 w-4"></i>
                                    </a>
                                </div>

                                <div class="bg-white p-10 rounded-[3.5rem] border border-slate-100 shadow-xl shadow-slate-200/50">
                                    <div class="flex items-center justify-between mb-10">
                                        <h4 class="text-sm font-black uppercase tracking-[0.2em] text-slate-900 italic">System Feed.</h4>
                                        <% if(unread>0){ %>
                                            <span class="bg-rose-500 text-white text-[9px] font-black px-2.5 py-1 rounded-full"><%= unread %></span>
                                        <% } %>
                                    </div>

                                    <div class="space-y-8">
                                        <% if(notifications.isEmpty()){ %>
                                            <p class="text-[10px] font-black uppercase tracking-widest text-slate-300 italic py-10 text-center">No Active Signals</p>
                                        <% } else { for(Notification n : notifications.subList(0, Math.min(3, notifications.size()))){ %>
                                            <div class="flex items-start gap-5 group">
                                                <div class="h-2 w-2 rounded-full bg-brand-500 mt-1.5 hidden group-first:block"></div>
                                                <div class="flex-1">
                                                    <p class="text-[10px] font-black text-slate-900 uppercase tracking-widest"><%= esc(n.getTitle()) %></p>
                                                    <p class="text-[10px] font-bold text-slate-400 uppercase mt-2 leading-relaxed line-clamp-2"><%= esc(n.getMessage()) %></p>
                                                </div>
                                            </div>
                                        <% }} %>
                                    </div>
                                    
                                    <a href="<%= request.getContextPath() %>/citizen/notifications" class="block w-full text-center mt-10 py-5 border-t border-slate-50 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-brand-900 transition-colors">Sync Feed</a>
                                </div>
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