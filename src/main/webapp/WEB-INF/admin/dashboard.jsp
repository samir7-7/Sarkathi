<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} private String badgeClass(String status){if("approved".equals(status))return"bg-green-50 text-green-700";if("rejected".equals(status))return"bg-red-50 text-red-600";if("review".equals(status))return"bg-amber-50 text-amber-700";return"bg-blue-50 text-blue-700";} %>
<% String adminName=(String)request.getAttribute("adminName");String adminRole=(String)request.getAttribute("adminRole");String adminEmail=(String)request.getAttribute("adminEmail");String pageError=(String)request.getAttribute("pageError");Number total=(Number)request.getAttribute("totalApplications");Number submitted=(Number)request.getAttribute("submittedApplications");Number review=(Number)request.getAttribute("reviewApplications");Number approved=(Number)request.getAttribute("approvedApplications");Number rejected=(Number)request.getAttribute("rejectedApplications");List<Application> recent=(List<Application>)request.getAttribute("recentApplications");DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMM d, yyyy");if(adminName==null)adminName="Admin";if(adminRole==null)adminRole="admin";if(adminEmail==null)adminEmail="";if(total==null)total=0;if(submitted==null)submitted=0;if(review==null)review=0;if(approved==null)approved=0;if(rejected==null)rejected=0;if(recent==null)recent=List.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Admin Dashboard - SarkarSathi
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',500:'#3b82f6',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <div class="flex min-h-screen">
            <aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
                <div class="flex items-center gap-1.5 px-5 pt-5 pb-2">
                    <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">
                        SarkarSathi
                    </a>
                    <span class="text-xl font-bold text-brand-500">
                        Admin
                    </span>
                </div>
                <div class="mx-5 mt-3 rounded-xl bg-brand-50 px-4 py-3">
                    <p class="text-sm font-semibold text-brand-900">
                        <%= esc(adminName) %>
                    </p>
                    <p class="text-[11px] text-slate-500">
                        <%= esc(adminRole) %>
                    </p>
                </div>
                <nav class="mt-6 flex-1 space-y-1 px-3">
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
                        <i data-lucide="layout-dashboard" class="h-4 w-4 shrink-0"></i>
                            <span>Dashboard</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="clipboard-list" class="h-4 w-4 shrink-0"></i>
                            <span>Applications</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="megaphone" class="h-4 w-4 shrink-0"></i>
                            <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="sprout" class="h-4 w-4 shrink-0"></i>
                            <span>Agri Notices</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="banknote" class="h-4 w-4 shrink-0"></i>
                            <span>Budgets</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600">
                        <i data-lucide="log-out" class="h-4 w-4 shrink-0"></i>
                            <span>Logout</span>
                    </a>
                </div>
            </aside>
            <div class="ml-[220px] flex-1 flex flex-col min-h-screen">
                <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <h1 class="text-lg font-bold text-slate-900">
                        Admin Dashboard
                    </h1>
                    <p class="text-xs text-slate-500">
                        <%= esc(adminEmail) %>
                    </p>
                </header>
                <main class="flex-1 px-8 py-8 overflow-y-auto">
                    <% if(pageError!=null){ %>
                        <div class="mb-6 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <%= esc(pageError) %>
                        </div>
                    <% } %>
                    <div class="grid gap-4 md:grid-cols-5">
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Total
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= total %>
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Submitted
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= submitted %>
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Review
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= review %>
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Approved
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= approved %>
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                            <p class="text-xs font-semibold uppercase text-slate-400">
                                Rejected
                            </p>
                            <p class="mt-3 text-3xl font-bold">
                                <%= rejected %>
                            </p>
                        </div>
                    </div>
                    <section class="mt-8 rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
                        <div class="px-6 py-4 flex items-center justify-between">
                            <h2 class="text-lg font-bold text-slate-900">
                                Recent Applications
                            </h2>
                            <a href="<%= request.getContextPath() %>/admin/applications" class="text-sm font-semibold text-brand-500">
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
                                        Citizen ID
                                    </th>
                                    <th class="px-6 py-3">
                                        Service ID
                                    </th>
                                    <th class="px-6 py-3">
                                        Status
                                    </th>
                                    <th class="px-6 py-3">
                                        Submitted
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(recent.isEmpty()){ %>
                                    <tr>
                                        <td colspan="5" class="px-6 py-8 text-center text-slate-400">
                                            No applications
                                        </td>
                                    </tr>
                                <% } else { int shown=0; for(Application a:recent){ if(shown++>=10)break; %>
                                <tr class="border-b border-slate-50">
                                    <td class="px-6 py-4 font-semibold text-brand-900">
                                        #<%= esc(a.getTrackingId()) %>
                                    </td>
                                    <td class="px-6 py-4">
                                        <%= a.getCitizenId() %>
                                    </td>
                                    <td class="px-6 py-4">
                                        <%= a.getServiceTypeId() %>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="rounded-full <%= badgeClass(a.getStatus()) %> px-3 py-1 text-xs font-semibold">
                                            <%= esc(a.getStatus()) %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <%= a.getSubmittedAt()==null?"":esc(a.getSubmittedAt().format(fmt)) %>
                                    </td>
                                </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </section>
            </main>
        </div>
    </div>
</body>
</html>
