<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%!
    private String esc(Object v){if(v==null)return "";return v.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");}
    private String badgeClass(String s){
        if("approved".equals(s)) return "status-approved";
        if("rejected".equals(s)) return "status-rejected";
        if("review".equals(s)) return "status-review";
        return "status-submitted";
    }
    private String statusLabel(String s){
        if("review".equals(s)) return "Pending Review";
        if("approved".equals(s)) return "Completed";
        if("rejected".equals(s)) return "Cancelled";
        return "Submitted";
    }
%>
<%
    String adminName = (String)request.getAttribute("adminName");
    String adminRole = (String)request.getAttribute("adminRole");
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
    if(total == null) total = 0;
    if(submitted == null) submitted = 0;
    if(review == null) review = 0;
    if(approved == null) approved = 0;
    if(rejected == null) rejected = 0;
    if(recent == null) recent = List.of();

    int totalInt = total.intValue();
    int submittedInt = submitted.intValue();
    int reviewInt = review.intValue();
    int approvedInt = approved.intValue();
    int rejectedInt = rejected.intValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Dashboard - SarkarSathi Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ["Outfit", "sans-serif"] },
                    colors: {
                        brand: { 50:"#eff6ff", 100:"#dbeafe", 500:"#3b82f6", 700:"#1d4ed8", 800:"#154a91", 900:"#0b3d86" }
                    }
                }
            }
        };
    </script>
    <%@ include file="../includes/lucide-icons.jsp" %>
    <style>
        body { font-family: "Outfit", sans-serif; }
        @media (max-width: 1023px) {
            .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
        }

        /* Summary cards with soft gradient backgrounds */
        .summary-card { position: relative; border-radius: 16px; padding: 20px 22px; overflow: hidden; transition: transform 0.2s, box-shadow 0.2s; }
        .summary-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
        .card-total { background: linear-gradient(135deg, #f8fafc 0%, #e8ecf1 100%); border: 1px solid #e2e8f0; }
        .card-submitted { background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 50%, #bfdbfe 100%); border: 1px solid #bfdbfe; }
        .card-review { background: linear-gradient(135deg, #fefce8 0%, #fef3c7 50%, #fde68a 100%); border: 1px solid #fde68a; }
        .card-approved { background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 50%, #bbf7d0 100%); border: 1px solid #bbf7d0; }
        .card-rejected { background: linear-gradient(135deg, #fff1f2 0%, #ffe4e6 50%, #fecdd3 100%); border: 1px solid #fecdd3; }

        /* Status badges */
        .status-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 600; }
        .status-submitted { background: #dbeafe; color: #1e40af; }
        .status-review { background: #fef3c7; color: #92400e; }
        .status-approved { background: #dcfce7; color: #166534; }
        .status-rejected { background: #ffe4e6; color: #9f1239; }

        /* Table */
        .data-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .data-table thead th { padding: 10px 16px; font-size: 12px; font-weight: 600; color: #64748b; text-align: left; border-bottom: 1px solid #e2e8f0; background: #fafbfc; }
        .data-table thead th:first-child { border-radius: 8px 0 0 0; }
        .data-table thead th:last-child { border-radius: 0 8px 0 0; }
        .data-table tbody td { padding: 12px 16px; font-size: 13px; color: #334155; border-bottom: 1px solid #f1f5f9; }
        .data-table tbody tr { transition: background 0.15s; }
        .data-table tbody tr:hover { background: #f8fafc; }
        .data-table tbody tr:last-child td { border-bottom: none; }

        /* Fade-in animation */
        @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeUp 0.4s ease forwards; }
        .delay-1 { animation-delay: 0.05s; opacity: 0; }
        .delay-2 { animation-delay: 0.1s; opacity: 0; }
        .delay-3 { animation-delay: 0.15s; opacity: 0; }
        .delay-4 { animation-delay: 0.2s; opacity: 0; }
        .delay-5 { animation-delay: 0.25s; opacity: 0; }
        .mobile-app-card { border: 1px solid #e2e8f0; border-radius: 16px; padding: 14px; background: #fff; }
    </style>
</head>
<body class="bg-slate-100 text-slate-900 antialiased overflow-x-hidden">
    <div class="flex min-h-screen relative">
        <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden"></div>
        <%@ include file="../includes/sidebar-admin.jsp" %>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col min-h-screen w-full">
            <!-- Top Bar -->
            <header class="sticky top-0 z-40 bg-white/90 backdrop-blur border-b border-slate-200 px-4 py-3.5 lg:px-7">
                <div class="flex items-start justify-between gap-3 sm:items-center">
                    <div class="flex items-start gap-3">
                        <button onclick="toggleSidebar()" class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 shadow-sm transition hover:bg-slate-50 lg:hidden">
                            <i data-lucide="menu" class="h-5 w-5"></i>
                        </button>
                        <div>
                        <h1 class="text-lg font-black tracking-tight text-slate-900">Admin Dashboard</h1>
                        <p class="text-[11px] font-semibold text-slate-500">Review activity, monitor volume, and move work forward</p>
                        </div>
                    </div>
                    <div class="hidden sm:flex items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2">
                        <div class="h-9 w-9 rounded-full bg-brand-900 flex items-center justify-center text-white text-sm font-bold">
                            <%= adminName.length() > 0 ? adminName.substring(0,1).toUpperCase() : "A" %>
                        </div>
                        <div>
                            <p class="text-sm font-bold text-slate-900"><%= esc(adminName) %></p>
                            <p class="text-[11px] font-semibold text-slate-500"><%= esc(adminRole) %></p>
                        </div>
                    </div>
                </div>
            </header>

            <main class="flex-1 p-3 sm:p-4 lg:p-6">
                <% if(pageError != null){ %>
                <div class="bg-rose-50 text-rose-700 px-4 py-3 rounded-xl border border-rose-200 flex items-center gap-2 mb-4 text-sm font-medium animate-in">
                    <i data-lucide="alert-circle" class="h-4 w-4 flex-shrink-0"></i>
                    <%= esc(pageError) %>
                </div>
                <% } %>

                <!-- Summary Cards -->
                <section class="grid grid-cols-1 min-[420px]:grid-cols-2 lg:grid-cols-5 gap-3 lg:gap-4 mb-6">
                    <div class="summary-card card-total animate-in delay-1">
                        <div class="flex items-center gap-2 mb-3">
                            <div class="h-8 w-8 rounded-lg bg-white/80 flex items-center justify-center text-slate-500 shadow-sm">
                                <i data-lucide="database" class="h-4 w-4"></i>
                            </div>
                        </div>
                        <p class="text-2xl font-bold text-slate-800 tracking-tight"><%= totalInt %></p>
                        <p class="text-[11px] font-medium text-slate-500 mt-1">Total Applications</p>
                    </div>
                    <div class="summary-card card-submitted animate-in delay-2">
                        <div class="flex items-center gap-2 mb-3">
                            <div class="h-8 w-8 rounded-lg bg-white/60 flex items-center justify-center text-blue-600 shadow-sm">
                                <i data-lucide="inbox" class="h-4 w-4"></i>
                            </div>
                        </div>
                        <p class="text-2xl font-bold text-blue-700 tracking-tight"><%= submittedInt %></p>
                        <p class="text-[11px] font-medium text-blue-600/70 mt-1">Submitted</p>
                    </div>
                    <div class="summary-card card-review animate-in delay-3">
                        <div class="flex items-center gap-2 mb-3">
                            <div class="h-8 w-8 rounded-lg bg-white/60 flex items-center justify-center text-amber-600 shadow-sm">
                                <i data-lucide="clock" class="h-4 w-4"></i>
                            </div>
                        </div>
                        <p class="text-2xl font-bold text-amber-700 tracking-tight"><%= reviewInt %></p>
                        <p class="text-[11px] font-medium text-amber-600/70 mt-1">Pending Review</p>
                    </div>
                    <div class="summary-card card-approved animate-in delay-4">
                        <div class="flex items-center gap-2 mb-3">
                            <div class="h-8 w-8 rounded-lg bg-white/60 flex items-center justify-center text-emerald-600 shadow-sm">
                                <i data-lucide="check-circle" class="h-4 w-4"></i>
                            </div>
                        </div>
                        <p class="text-2xl font-bold text-emerald-700 tracking-tight"><%= approvedInt %></p>
                        <p class="text-[11px] font-medium text-emerald-600/70 mt-1">Approved</p>
                    </div>
                    <div class="summary-card card-rejected min-[420px]:col-span-2 lg:col-span-1 animate-in delay-5">
                        <div class="flex items-center gap-2 mb-3">
                            <div class="h-8 w-8 rounded-lg bg-white/60 flex items-center justify-center text-rose-500 shadow-sm">
                                <i data-lucide="x-circle" class="h-4 w-4"></i>
                            </div>
                        </div>
                        <p class="text-2xl font-bold text-rose-600 tracking-tight"><%= rejectedInt %></p>
                        <p class="text-[11px] font-medium text-rose-500/70 mt-1">Rejected</p>
                    </div>
                </section>

                <!-- Applications Table -->
                <section class="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden animate-in delay-5">
                    <div class="px-5 py-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-100">
                        <div>
                            <h3 class="text-[15px] font-bold text-slate-900">Recent Applications</h3>
                            <p class="text-xs text-slate-400 mt-0.5">Latest submissions waiting in the admin workflow</p>
                        </div>
                        <div class="flex items-center gap-2">
                            <a href="<%= request.getContextPath() %>/admin/applications" class="flex items-center gap-1.5 text-xs font-semibold text-white bg-slate-900 px-3 py-1.5 rounded-lg hover:bg-slate-800 transition-colors">
                                <i data-lucide="external-link" class="h-3 w-3"></i>
                                View All
                            </a>
                        </div>
                    </div>
                    <div class="space-y-3 p-3 sm:hidden">
                        <% if(recent.isEmpty()){ %>
                        <div class="mobile-app-card text-center text-slate-400 font-semibold">No applications found</div>
                        <% } else { for(Application a : recent){ %>
                        <article class="mobile-app-card">
                            <div class="flex items-start justify-between gap-3">
                                <div>
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-400">Tracking ID</p>
                                    <p class="mt-1 text-sm font-black text-slate-900"><%= esc(a.getTrackingId()) %></p>
                                </div>
                                <span class="status-badge <%= badgeClass(a.getStatus()) %>"><%= esc(statusLabel(a.getStatus())) %></span>
                            </div>
                            <div class="mt-3 grid gap-2 text-sm">
                                <div class="flex items-center justify-between gap-3">
                                    <span class="text-slate-400 font-semibold">Citizen</span>
                                    <span class="text-slate-700 font-medium">Citizen #<%= a.getCitizenId() %></span>
                                </div>
                                <div class="flex items-center justify-between gap-3">
                                    <span class="text-slate-400 font-semibold">Date</span>
                                    <span class="text-slate-500 text-xs"><%= a.getSubmittedAt()==null ? "N/A" : esc(a.getSubmittedAt().format(fmt)) %></span>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/admin/applications" class="mt-3 inline-flex items-center gap-1 text-xs font-bold text-brand-900">Open review <i data-lucide="arrow-right" class="h-3.5 w-3.5"></i></a>
                        </article>
                        <% }} %>
                    </div>
                    <div class="hidden sm:block overflow-x-auto">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Tracking ID</th>
                                    <th>Citizen</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th class="text-right w-10"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(recent.isEmpty()){ %>
                                <tr>
                                    <td colspan="5" class="!py-16 text-center">
                                        <div class="flex flex-col items-center">
                                            <div class="h-12 w-12 rounded-xl bg-slate-100 flex items-center justify-center mb-3">
                                                <i data-lucide="inbox" class="h-6 w-6 text-slate-300"></i>
                                            </div>
                                            <p class="text-sm font-medium text-slate-400">No applications found</p>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { for(Application a : recent){ %>
                                <tr>
                                    <td>
                                        <div class="flex items-center gap-2.5">
                                            <div class="h-7 w-7 rounded-md bg-slate-100 flex items-center justify-center text-slate-500 text-[10px] font-bold">#</div>
                                            <span class="font-semibold text-slate-900"><%= esc(a.getTrackingId()) %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="text-slate-600">Citizen #<%= a.getCitizenId() %></span>
                                    </td>
                                    <td>
                                        <span class="status-badge <%= badgeClass(a.getStatus()) %>"><%= esc(statusLabel(a.getStatus())) %></span>
                                    </td>
                                    <td>
                                        <span class="text-slate-500 tabular-nums text-xs"><%= a.getSubmittedAt()==null ? "N/A" : esc(a.getSubmittedAt().format(fmt)) %></span>
                                    </td>
                                    <td class="text-right">
                                        <a href="<%= request.getContextPath() %>/admin/applications" class="h-7 w-7 rounded-md bg-slate-50 border border-slate-200 inline-flex items-center justify-center text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-colors">
                                            <i data-lucide="chevron-right" class="h-3.5 w-3.5"></i>
                                        </a>
                                    </td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </section>
            </main>
        </div>
    </div>

    <%@ include file="../includes/responsive-scripts.jsp" %>
    <script>lucide.createIcons();</script>
</body>
</html>
