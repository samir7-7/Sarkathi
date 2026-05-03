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
    String adminName = (String)request.getAttribute("adminName");
    String adminRole = (String)request.getAttribute("adminRole");
    String adminEmail = (String)request.getAttribute("adminEmail");
    String pageError = (String)request.getAttribute("pageError");
    Number total = (Number)request.getAttribute("totalApplications");
    Number submitted = (Number)request.getAttribute("submittedApplications");
    Number review = (Number)request.getAttribute("reviewApplications");
    Number approved = (Number)request.getAttribute("approvedApplications");
    Number rejected = (Number)request.getAttribute("rejectedApplications");
    List<Application> recent = (List<Application>)request.getAttribute("recentApplications");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy");
    
    if(adminName == null) adminName = "Admin";
    if(adminRole == null) adminRole = "System Controller";
    if(adminEmail == null) adminEmail = "root@sarkarsathi.gov";
    if(total == null) total = 0;
    if(submitted == null) submitted = 0;
    if(review == null) review = 0;
    if(approved == null) approved = 0;
    if(rejected == null) rejected = 0;
    if(recent == null) recent = List.of(); 
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Admin Terminal - SarkarSathi</title>
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
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="flex flex-col items-center justify-center gap-1 text-brand-900">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Console</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/applications" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="clipboard-list" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Registry</span>
                </a>
                <div class="relative -top-3">
                    <button onclick="toggleSidebar()" class="flex h-14 w-14 items-center justify-center rounded-[5px] bg-brand-900 text-white shadow-lg shadow-brand-900/30">
                        <i data-lucide="layers" class="h-6 w-6"></i>
                    </button>
                </div>
                 <a href="<%= request.getContextPath() %>/admin/analytics" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="bar-chart-3" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Stats</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/services" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="settings" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Config</span>
                </a>
            </nav>

            <!-- Desktop Sidebar -->
            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            
            <%@ include file="../includes/sidebar-admin.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">

                <!-- Header -->
                <header class="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-slate-100 px-6 py-6 lg:px-12">
                    <div class="flex items-center justify-between max-w-7xl mx-auto">
                        <div>
                            <h1 class="text-2xl font-black text-slate-900 tracking-tighter uppercase  ">Control.</h1>
                            <p class="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 mt-1">SarkarSathi Governing Logic</p>
                        </div>
                        
                        <div class="flex items-center gap-4">
                            <div class="hidden sm:flex flex-col items-end">
                                <span class="text-[9px] font-black uppercase tracking-widest text-slate-400">Authenticated As</span>
                                <span class="text-[11px] font-black text-brand-900 uppercase"><%= esc(adminEmail) %></span>
                            </div>
                            <div class="h-12 w-12 rounded-[5px] bg-brand-50 flex items-center justify-center text-brand-900 animate-pulse">
                                <i data-lucide="radio" class="h-6 w-6"></i>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 p-6 lg:p-12 pb-32">
                    <div class="max-w-7xl mx-auto">
                        <% if(pageError!=null){ %>
                            <div class="mb-10 bg-rose-50 text-rose-600 p-6 rounded-[2rem] border border-rose-100 flex items-center gap-4 animate-fade-in-up">
                                <i data-lucide="shield-alert" class="h-6 w-6"></i>
                                <p class="text-xs font-black uppercase tracking-widest"><%= esc(pageError) %></p>
                            </div>
                        <% } %>

                        <!-- Stats Grid -->
                        <div class="grid grid-cols-2 lg:grid-cols-5 gap-4 lg:gap-8 mb-16">
                            <div class="bg-white p-8 rounded-[15px] border border-slate-100 shadow-xl shadow-slate-200/50">
                                <div class="h-12 w-12 rounded-[5px] bg-slate-50 text-slate-400 flex items-center justify-center mb-6">
                                    <i data-lucide="database" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Database</p>
                                <p class="text-3xl font-black text-slate-900 tracking-tighter mt-1"><%= total %></p>
                            </div>

                            <div class="bg-white p-8 rounded-[15px] border border-slate-100 shadow-xl shadow-slate-200/50 scale-105 ring-4 ring-brand-500/5">
                                <div class="h-12 w-12 rounded-[5px] bg-blue-50 text-blue-600 flex items-center justify-center mb-6">
                                    <i data-lucide="activity" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-blue-400">Active Queue</p>
                                <p class="text-3xl font-black text-blue-600 tracking-tighter mt-1"><%= submitted %></p>
                            </div>

                            <div class="bg-white p-8 rounded-[15px] border border-slate-100 shadow-xl shadow-slate-200/50">
                                <div class="h-12 w-12 rounded-[5px] bg-amber-50 text-amber-600 flex items-center justify-center mb-6">
                                    <i data-lucide="eye" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-amber-400">Reviewing</p>
                                <p class="text-3xl font-black text-amber-600 tracking-tighter mt-1"><%= review %></p>
                            </div>

                            <div class="bg-white p-8 rounded-[15px] border border-slate-100 shadow-xl shadow-slate-200/50">
                                <div class="h-12 w-12 rounded-[5px] bg-emerald-50 text-emerald-600 flex items-center justify-center mb-6">
                                    <i data-lucide="check-circle" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-emerald-400">Validated</p>
                                <p class="text-3xl font-black text-emerald-600 tracking-tighter mt-1"><%= approved %></p>
                            </div>

                            <div class="bg-white p-8 rounded-[15px] border border-slate-100 shadow-xl shadow-slate-200/50 col-span-2 lg:col-span-1">
                                <div class="h-12 w-12 rounded-[5px] bg-rose-50 text-rose-600 flex items-center justify-center mb-6">
                                    <i data-lucide="x-circle" class="h-6 w-6"></i>
                                </div>
                                <p class="text-[10px] font-black uppercase tracking-widest text-rose-400">Terminated</p>
                                <p class="text-3xl font-black text-rose-600 tracking-tighter mt-1"><%= rejected %></p>
                            </div>
                        </div>

                        <!-- Main Table -->
                        <section class="bg-white rounded-[25px] border border-slate-100 shadow-2xl shadow-slate-200/50 overflow-hidden">
                            <div class="p-10 lg:p-14 border-b border-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-6">
                                <div>
                                    <h3 class="text-2xl font-black text-slate-900 tracking-tighter  ">Process Ledger.</h3>
                                    <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mt-2">Latest Recursive Applications</p>
                                </div>
                                <a href="<%= request.getContextPath() %>/admin/applications" class="bg-brand-900 text-white px-8 py-4 rounded-3xl text-[10px] font-black uppercase tracking-[0.2em] shadow-xl shadow-brand-900/20 active:scale-95 transition-all text-center">Open Full Registry</a>
                            </div>

                            <div class="overflow-x-auto">
                                <table class="w-full text-left">
                                    <thead>
                                        <tr class="bg-slate-50/50">
                                            <th class="px-10 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Logic Hash</th>
                                            <th class="px-10 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Node Identifier</th>
                                            <th class="px-10 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">State</th>
                                            <th class="px-10 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 text-right">Genesis</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-50">
                                        <% if(recent.isEmpty()){ %>
                                            <tr>
                                                <td colspan="4" class="px-10 py-24 text-center">
                                                    <i data-lucide="box-select" class="h-12 w-12 text-slate-200 mx-auto mb-6"></i>
                                                    <p class="text-xs font-black uppercase tracking-widest text-slate-300  ">No Registry Data Detected</p>
                                                </td>
                                            </tr>
                                        <% } else { for(Application a:recent){ %>
                                            <tr class="group hover:bg-slate-50 transition-colors cursor-pointer">
                                                <td class="px-10 py-8">
                                                    <div class="flex items-center gap-4">
                                                        <div class="h-10 w-10 rounded-[5px] bg-brand-50 text-brand-900 flex items-center justify-center font-black text-xs group-hover:bg-brand-900 group-hover:text-white transition-colors">#</div>
                                                        <span class="text-sm font-black text-slate-900 tracking-tight"><%= esc(a.getTrackingId()) %></span>
                                                    </div>
                                                </td>
                                                <td class="px-10 py-8">
                                                    <div class="flex flex-col">
                                                        <span class="text-xs font-black uppercase tracking-widest text-slate-900">CITIZEN.UNIT_<%= a.getCitizenId() %></span>
                                                        <span class="text-[9px] font-bold text-slate-400 uppercase mt-1">INTERNAL_RELAY</span>
                                                    </div>
                                                </td>
                                                <td class="px-10 py-8">
                                                    <div class="px-4 py-2 rounded-[5px] border w-fit <%= badgeClass(a.getStatus()) %>">
                                                        <span class="text-[10px] font-black uppercase tracking-widest"><%= esc(a.getStatus()) %></span>
                                                    </div>
                                                </td>
                                                <td class="px-10 py-8 text-right">
                                                    <span class="text-[11px] font-black text-slate-500 tabular-nums uppercase"><%= a.getSubmittedAt()==null?"UNDEFINED":esc(a.getSubmittedAt().format(fmt)) %></span>
                                                </td>
                                            </tr>
                                        <% }} %>
                                    </tbody>
                                </table>
                            </div>
                        </section>
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