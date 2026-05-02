<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
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
    List<Application> applications = (List<Application>)request.getAttribute("applications"); 
    Application trackingResult = (Application)request.getAttribute("trackingResult"); 
    Boolean trackingSearched = (Boolean)request.getAttribute("trackingSearched"); 
    String formError = request.getParameter("error"); 
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy HH:mm"); 
    boolean loggedIn = citizenId != null; 
    if(citizenName == null) citizenName = "Citizen";
    if(applications == null) applications = List.of(); 
    String action = loggedIn ? request.getContextPath() + "/citizen/tracking" : request.getContextPath() + "/track"; 
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Track Status - SarkarSathi</title>
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
            <% if(loggedIn){ %>
                <!-- Mobile Bottom Nav (Citizen Mode) -->
                <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                        <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                        <span class="text-[10px] font-black uppercase tracking-tighter">Portal</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-brand-900">
                        <i data-lucide="search-check" class="h-5 w-5"></i>
                        <span class="text-[10px] font-black uppercase tracking-tighter">Track</span>
                    </a>
                    <div class="relative -top-3">
                        <a href="<%= request.getContextPath() %>/citizen/apply" class="flex h-14 w-14 items-center justify-center rounded-2xl bg-brand-900 text-white shadow-lg shadow-brand-900/30">
                            <i data-lucide="plus" class="h-6 w-6"></i>
                        </a>
                    </div>
                     <a href="<%= request.getContextPath() %>/citizen/documents" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                        <i data-lucide="folder-key" class="h-5 w-5"></i>
                        <span class="text-[10px] font-black uppercase tracking-tighter">Files</span>
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
                            <p class="text-[10px] font-black uppercase tracking-[0.3em] text-blue-300/80 mb-2">Verified Citizen</p>
                            <h4 class="text-xl font-black tracking-tight truncate"><%= esc(citizenName) %></h4>
                        </div>

                        <nav class="flex-1 space-y-2">
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                                <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                                <span>Overview</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link active group flex items-center gap-4 px-4 py-4 rounded-2xl text-[11px] font-black uppercase tracking-widest">
                                <i data-lucide="search-check" class="h-5 w-5"></i>
                                <span>Query Tracking</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                                <i data-lucide="file-plus" class="h-5 w-5"></i>
                                <span>New Service</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                                <i data-lucide="award" class="h-5 w-5"></i>
                                <span>Certificates</span>
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
            <% } %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <!-- Header -->
                <header class="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-slate-100 px-6 py-6 lg:px-12">
                    <div class="flex items-center justify-between max-w-7xl mx-auto">
                        <div>
                            <h1 class="text-2xl font-black text-slate-900 tracking-tighter">Status Terminal.</h1>
                            <p class="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 mt-1">Real-time Application Intelligence</p>
                        </div>
                        
                        <div class="flex items-center gap-4">
                            <% if(!loggedIn) { %>
                                <a href="<%= request.getContextPath() %>/" class="h-12 w-12 flex items-center justify-center rounded-2xl border border-slate-100 text-slate-400 hover:text-brand-900 transition-colors">
                                    <i data-lucide="home" class="h-5 w-5"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/login" class="bg-brand-900 text-white px-8 py-3.5 rounded-2xl text-xs font-black uppercase tracking-widest shadow-xl shadow-brand-900/20 active:scale-95 transition-all">Identity Entry</a>
                            <% } else { %>
                                <div class="h-12 w-12 rounded-2xl bg-brand-50 flex items-center justify-center text-brand-900">
                                    <i data-lucide="fingerprint" class="h-6 w-6"></i>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </header>

                <main class="flex-1 p-6 lg:p-12 pb-32">
                    <div class="max-w-4xl mx-auto">
                        <!-- Search Box -->
                        <div class="relative group mb-12">
                            <div class="absolute -inset-1 bg-gradient-to-r from-brand-500 to-brand-900 rounded-[3rem] blur opacity-10 group-focus-within:opacity-25 transition duration-500"></div>
                            <div class="relative bg-white rounded-[2.5rem] border border-slate-100 p-2 shadow-xl">
                                <form method="get" action="<%= action %>" class="flex flex-col sm:flex-row gap-2">
                                    <div class="relative flex-1">
                                        <i data-lucide="search" class="absolute left-6 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-400"></i>
                                        <input type="text" name="trackingId" value="<%= esc(request.getParameter("trackingId")) %>"
                                               placeholder="ENTER REFERENCE HASH / ID" 
                                               class="w-full bg-slate-50/50 rounded-[2rem] pl-16 pr-6 py-5 text-sm font-black uppercase tracking-widest outline-none focus:bg-white transition-all ring-0 border-0 focus:ring-2 focus:ring-brand-500/20">
                                    </div>
                                    <button type="submit" class="bg-brand-900 text-white px-10 py-5 rounded-[2rem] text-sm font-black uppercase tracking-widest shadow-lg active:scale-95 transition-all">
                                        Inquire
                                    </button>
                                </form>
                            </div>
                        </div>

                        <% if(formError != null){ %>
                            <div class="mb-10 bg-rose-50 text-rose-600 p-6 rounded-[2rem] border border-rose-100 flex items-center gap-4 animate-fade-in-up">
                                <i data-lucide="alert-octagon" class="h-6 w-6"></i>
                                <p class="text-xs font-black uppercase tracking-widest"><%= esc(formError) %></p>
                            </div>
                        <% } %>

                        <% if(Boolean.TRUE.equals(trackingSearched)){ 
                             if(trackingResult == null){ 
                        %>
                            <!-- Empty State -->
                            <div class="text-center py-20 bg-white border border-dashed border-slate-200 rounded-[4rem] animate-fade-in-up">
                                <div class="inline-flex h-20 w-20 items-center justify-center rounded-[2.5rem] bg-slate-50 text-slate-300 mb-8">
                                    <i data-lucide="database-zap" class="h-10 w-10"></i>
                                </div>
                                <h3 class="text-2xl font-black text-slate-900 italic">No Node Found</h3>
                                <p class="text-slate-400 font-bold uppercase tracking-widest text-[10px] mt-4">Verification cycle returned null for this ID</p>
                            </div>
                        <% } else { %>
                            <!-- Tracking Result Card -->
                            <article class="bg-white rounded-[4rem] border border-slate-100 p-10 lg:p-14 shadow-2xl shadow-slate-200/50 animate-fade-in-up relative overflow-hidden">
                                <div class="absolute top-0 right-0 h-40 w-40 bg-brand-50 rounded-bl-[5rem] -mr-10 -mt-10 opacity-50"></div>
                                
                                <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-8 mb-16 relative z-10">
                                    <div>
                                        <p class="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 mb-2">Process Stream</p>
                                        <h2 class="text-4xl lg:text-5xl font-black text-brand-900 tracking-tighter italic">#<%= esc(trackingResult.getTrackingId()) %></h2>
                                    </div>
                                    <div class="px-8 py-4 rounded-3xl border <%= badgeClass(trackingResult.getStatus()) %> inline-flex items-center gap-3">
                                        <span class="h-2 w-2 rounded-full bg-current animate-pulse"></span>
                                        <span class="text-sm font-black uppercase tracking-widest"><%= esc(trackingResult.getStatus()) %></span>
                                    </div>
                                </div>

                                <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8 mb-16 relative z-10">
                                    <div class="bg-slate-50/50 p-6 rounded-[2.5rem] border border-slate-100">
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-3">Service Logic</p>
                                        <p class="text-sm font-black text-slate-900 uppercase truncate">GENERIC_ADMIN_SVC</p>
                                    </div>
                                    <div class="bg-slate-50/50 p-6 rounded-[2.5rem] border border-slate-100">
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-3">Genesis Date</p>
                                        <p class="text-sm font-black text-slate-900 uppercase"><%= trackingResult.getSubmittedAt()==null ? "UNKNOWN" : esc(trackingResult.getSubmittedAt().format(fmt)) %></p>
                                    </div>
                                    <div class="bg-slate-50/50 p-6 rounded-[2.5rem] border border-slate-100">
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-3">Last Sync</p>
                                        <p class="text-sm font-black text-slate-900 uppercase"><%= trackingResult.getLastUpdatedAt()==null ? "PENDING" : esc(trackingResult.getLastUpdatedAt().format(fmt)) %></p>
                                    </div>
                                </div>

                                <div class="relative z-10">
                                    <h4 class="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 mb-6">Administrative Ledger</h4>
                                    <div class="bg-brand-50 p-8 rounded-[3rem] border border-brand-100">
                                        <p class="text-sm font-bold text-slate-700 leading-relaxed">
                                            "<%= esc(trackingResult.getRemarks()==null ? "Application is currently circulating within the internal verification nodes. Expected latency: 2-3 business cycles." : trackingResult.getRemarks()) %>"
                                        </p>
                                    </div>
                                </div>
                            </article>
                        <% }} %>

                        <% if(loggedIn && !applications.isEmpty()){ %>
                            <section class="mt-20">
                                <div class="flex items-end justify-between mb-10 px-6">
                                    <div>
                                        <h3 class="text-2xl font-black text-slate-900 tracking-tighter">History.</h3>
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mt-1">Previous Process Iterations</p>
                                    </div>
                                </div>

                                <div class="space-y-4">
                                    <% for(Application a : applications){ %>
                                        <a href="<%= request.getContextPath() %>/citizen/tracking?trackingId=<%= esc(a.getTrackingId()) %>" 
                                           class="group block bg-white border border-slate-100 p-8 rounded-[2.5rem] hover:shadow-2xl hover:shadow-brand-900/5 transition-all duration-500">
                                            <div class="flex items-center justify-between">
                                                <div class="flex items-center gap-6">
                                                    <div class="h-14 w-14 rounded-2xl bg-brand-50 text-brand-900 flex items-center justify-center group-hover:bg-brand-900 group-hover:text-white transition-colors">
                                                        <i data-lucide="hash" class="h-6 w-6"></i>
                                                    </div>
                                                    <div>
                                                        <h4 class="text-sm font-black uppercase tracking-widest text-slate-900 italic">#<%= esc(a.getTrackingId()) %></h4>
                                                        <p class="text-[10px] font-bold text-slate-400 uppercase mt-1 tracking-widest"><%= a.getSubmittedAt()==null ? "—" : esc(a.getSubmittedAt().format(fmt)) %></p>
                                                    </div>
                                                </div>
                                                <div class="flex items-center gap-6">
                                                    <div class="hidden sm:block text-right">
                                                        <span class="text-[10px] font-black uppercase tracking-widest <%= a.getStatus().equals("approved") ? "text-emerald-500" : "text-slate-400" %>">
                                                            <%= esc(a.getStatus()) %>
                                                        </span>
                                                        <p class="text-[9px] font-bold text-slate-300 uppercase mt-0.5 tracking-tighter italic">LATEST STATUS</p>
                                                    </div>
                                                    <i data-lucide="arrow-right" class="h-5 w-5 text-slate-200 group-hover:text-brand-900 group-hover:translate-x-1 transition-all"></i>
                                                </div>
                                            </div>
                                        </a>
                                    <% } %>
                                </div>
                            </section>
                        <% } %>
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