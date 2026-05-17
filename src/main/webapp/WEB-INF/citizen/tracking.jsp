<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%!
    private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");}
    private String badgeClass(String status){
        if("approved".equals(status)) return "bg-emerald-100 text-emerald-700 border-emerald-200";
        if("rejected".equals(status)) return "bg-rose-100 text-rose-700 border-rose-200";
        if("review".equals(status)) return "bg-amber-100 text-amber-700 border-amber-200";
        return "bg-blue-100 text-blue-700 border-blue-200";
    }
    private String progressWidth(String status){
        if("approved".equals(status)) return "100%";
        if("review".equals(status)) return "68%";
        if("rejected".equals(status)) return "0%";
        return "32%";
    }
    private String statusLabel(String status){
        if("review".equals(status)) return "Under Review";
        if(status==null || status.isBlank()) return "Submitted";
        return status.substring(0,1).toUpperCase()+status.substring(1);
    }
    private int progressStep(String status){
        if("approved".equals(status)) return 4;
        if("rejected".equals(status)) return 0;
        if("review".equals(status)) return 3;
        return 2;
    }
%>
<%
    String citizenName = (String)request.getAttribute("citizenName");
    Integer unread = (Integer)request.getAttribute("unreadCount");
    List<Application> applications = (List<Application>)request.getAttribute("applications");
    String formError = request.getParameter("error");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy HH:mm");

    if(citizenName == null) citizenName = "Citizen";
    if(unread == null) unread = 0;
    if(applications == null) applications = List.of();
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
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#eef5ff',100:'#dbeafe',500:'#3b82f6',700:'#1d4ed8',900:'#0f172a'}}}}}
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 700; }
            .tracker-step {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 2rem;
                height: 2rem;
                border-radius: 9999px;
                border: 2px solid #cbd5e1;
                background: #fff;
                color: #64748b;
                font-size: 0.75rem;
                font-weight: 900;
            }
            .tracker-step.active {
                border-color: #84cc16;
                background: #f7fee7;
                color: #84cc16;
            }
            .tracker-step.rejected {
                border-color: #f43f5e;
                background: #fff1f2;
                color: #f43f5e;
            }
            .tracker-line {
                flex: 1;
                height: 0.25rem;
                border-radius: 9999px;
                background: #e2e8f0;
            }
            .tracker-line.active { background: #a3e635; }
            .tracking-panel[hidden] { display: none !important; }
            @media (max-width: 1023px) { .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); } }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/ui-improvements.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/typography.css">
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <%@ include file="../includes/mobile-nav-citizen.jsp" %>

            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            <%@ include file="../includes/sidebar-citizen.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200/80 bg-white px-8 py-4">
                    <div>
                        <h1 class="text-xl font-extrabold text-slate-900 tracking-tight">Track Status</h1>
                        <p class="text-xs text-slate-400 font-medium mt-0.5">Open any application below to view its live progress.</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2.5 text-slate-400 hover:text-brand-900 transition-colors border border-slate-200 rounded-xl hover:bg-slate-50">
                            <i data-lucide="bell" class="h-[18px] w-[18px]"></i>
                            <% if(unread>0){ %><span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span><% } %>
                        </a>
                        <div class="h-9 w-9 rounded-xl bg-brand-900 text-white flex items-center justify-center text-xs font-bold"><%= citizenName.substring(0,1).toUpperCase() %></div>
                    </div>
                </header>

                <div class="lg:hidden flex items-center justify-between px-5 pt-6 pb-4">
                    <div class="flex flex-col">
                        <h1 class="text-2xl font-black text-slate-900 tracking-tight">Track Status</h1>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-[0.2em]">Application Monitor</p>
                    </div>
                </div>

                <main class="flex-1 px-4 py-4 sm:px-6 lg:px-8 overflow-y-auto w-full pb-24 lg:pb-8">
                    <% if(formError != null){ %>
                        <div class="mb-5 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-semibold text-rose-700"><%= esc(formError) %></div>
                    <% } %>

                    <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
                            <div>
                                <h2 class="text-sm font-bold text-slate-900">My Applications</h2>
                                <p class="mt-1 text-[11px] font-medium text-slate-400">Click any application card to reveal the progress bar and remarks.</p>
                            </div>
                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest"><%= applications.size() %> total</span>
                        </div>
                        <% if(applications.isEmpty()){ %>
                            <div class="px-5 py-12 text-center text-sm font-medium text-slate-400">No applications submitted yet.</div>
                        <% } else { %>
                            <div class="divide-y divide-slate-100">
                                <% for(Application a : applications){ 
                                    int step = progressStep(a.getStatus());
                                    boolean rejected = "rejected".equals(a.getStatus());
                                %>
                                    <div class="px-5 py-4">
                                        <button type="button" class="tracking-toggle flex w-full items-center justify-between gap-4 text-left" data-target="tracking-panel-<%= a.getApplicationId() %>">
                                            <div class="min-w-0">
                                                <p class="text-sm font-bold text-slate-800 truncate">#<%= esc(a.getTrackingId()) %></p>
                                                <p class="text-[11px] text-slate-400 font-medium mt-0.5"><%= esc(a.getServiceTypeName()==null ? "Municipal Service" : a.getServiceTypeName()) %></p>
                                            </div>
                                            <div class="flex items-center gap-3 shrink-0">
                                                <span class="inline-flex items-center rounded-lg border px-2.5 py-1 text-[10px] font-bold uppercase tracking-wider <%= badgeClass(a.getStatus()) %>"><%= esc(statusLabel(a.getStatus())) %></span>
                                                <i data-lucide="chevron-down" class="tracking-chevron h-4 w-4 text-slate-300 transition-transform"></i>
                                            </div>
                                        </button>

                                        <div id="tracking-panel-<%= a.getApplicationId() %>" class="tracking-panel mt-4 rounded-2xl border border-slate-200 bg-slate-50/80 p-4" hidden>
                                            <div class="flex items-center gap-3">
                                                <div class="tracker-step <%= step >= 1 ? "active" : (rejected ? "rejected" : "") %>">1</div>
                                                <div class="tracker-line <%= step >= 2 ? "active" : "" %>"></div>
                                                <div class="tracker-step <%= step >= 2 ? "active" : "" %>">2</div>
                                                <div class="tracker-line <%= step >= 3 ? "active" : "" %>"></div>
                                                <div class="tracker-step <%= rejected ? "rejected" : (step >= 3 ? "active" : "") %>">3</div>
                                                <div class="tracker-line <%= !rejected && step >= 4 ? "active" : "" %>"></div>
                                                <div class="tracker-step <%= rejected ? "rejected" : (step >= 4 ? "active" : "") %>">4</div>
                                            </div>

                                            <div class="mt-3 grid grid-cols-4 gap-2 text-center text-[10px] font-black uppercase tracking-wider text-slate-400">
                                                <span>Filed</span>
                                                <span>Queued</span>
                                                <span><%= rejected ? "Rejected" : "Review" %></span>
                                                <span><%= rejected ? "Closed" : "Approved" %></span>
                                            </div>

                                            <div class="mt-4 grid gap-3 sm:grid-cols-3">
                                                <div class="rounded-xl bg-white p-3.5">
                                                    <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Submitted</p>
                                                    <p class="mt-1 text-sm font-bold text-slate-800"><%= a.getSubmittedAt()==null ? "-" : esc(a.getSubmittedAt().format(fmt)) %></p>
                                                </div>
                                                <div class="rounded-xl bg-white p-3.5">
                                                    <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Last Updated</p>
                                                    <p class="mt-1 text-sm font-bold text-slate-800"><%= a.getLastUpdatedAt()==null ? "Pending" : esc(a.getLastUpdatedAt().format(fmt)) %></p>
                                                </div>
                                                <div class="rounded-xl bg-white p-3.5">
                                                    <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Progress</p>
                                                    <p class="mt-1 text-sm font-bold text-slate-800"><%= progressWidth(a.getStatus()).replace("%", "") %>%</p>
                                                </div>
                                            </div>

                                            <div class="mt-4 rounded-xl bg-white p-4">
                                                <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-2">Remarks</p>
                                                <p class="text-sm text-slate-600 font-medium leading-relaxed"><%= esc(a.getRemarks()==null ? "No remarks yet. Updates will appear here as your application progresses." : a.getRemarks()) %></p>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
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
            document.querySelectorAll('.tracking-toggle').forEach((button, index) => {
                const panel = document.getElementById(button.dataset.target);
                const chevron = button.querySelector('.tracking-chevron');
                if (!panel) return;
                if (index === 0) {
                    panel.hidden = false;
                    if (chevron) chevron.classList.add('rotate-180');
                }
                button.addEventListener('click', () => {
                    const isOpening = panel.hidden;
                    panel.hidden = !panel.hidden;
                    if (chevron) chevron.classList.toggle('rotate-180', isOpening);
                });
            });
            lucide.createIcons();
        </script>
    </body>
</html>
