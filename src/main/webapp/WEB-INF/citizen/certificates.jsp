<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.IssuedCertificate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId");String citizenName=(String)request.getAttribute("citizenName");Integer unread=(Integer)request.getAttribute("unreadCount");List<IssuedCertificate> certificates=(List<IssuedCertificate>)request.getAttribute("certificates");DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMMM d, yyyy");if(citizenName==null)citizenName="Citizen";if(unread==null)unread=0;if(certificates==null)certificates=List.of();String initials=citizenName.isBlank()?"C":citizenName.substring(0,1).toUpperCase(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Certificates - SarkarSathi
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
            <%@ include file="../includes/lucide-icons.jsp" %>
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
                    <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-xs font-bold text-white">
                        <%= esc(initials) %>
                    </div>
                    <div>
                        <p class="truncate text-sm font-semibold text-brand-900">
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
                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="search-check" class="h-4 w-4 shrink-0"></i>
                            <span>Track Application</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="credit-card" class="h-4 w-4 shrink-0"></i>
                            <span>Payments & Tax</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
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
            <div class="ml-[220px] flex min-h-screen flex-1 flex-col">
                <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900">
                            My Certificates
                        </h1>
                        <p class="text-xs text-slate-500">
                            Download your approved certificates
                        </p>
                    </div>
                    <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600">
                        <i data-lucide="bell" class="h-5 w-5"></i>
                        <% if(unread>0){ %>
                            <span class="absolute -right-1 -top-1 min-w-[18px] rounded-full bg-red-500 px-1.5 py-0.5 text-center text-[10px] font-bold text-white">
                                <%= unread %>
                            </span>
                        <% } %>
                    </a>
                </header>
                <main class="flex-1 overflow-y-auto px-8 py-8">
                    <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
                        <% if(certificates.isEmpty()){ %>
                            <div class="col-span-full rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm">
                                <p class="text-slate-500">
                                    No certificates issued yet
                                </p>
                            </div>
                        <% } else { for(IssuedCertificate c: certificates){ %>
                            <article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                                <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-brand-50 text-brand-900">
                                    <i data-lucide="badge-check" class="h-5 w-5"></i>
                                </div>
                                <h3 class="mt-5 text-base font-bold text-slate-900">
                                    <%= esc(c.getCertificateNo()) %>
                                </h3>
                                <p class="mt-2 text-xs text-slate-500">
                                    Issued: <%= c.getIssuedAt()==null?"":esc(c.getIssuedAt().format(fmt)) %>
                                </p>
                                <div class="mt-5 flex gap-2">
                                    <a class="rounded-lg bg-brand-50 px-3 py-2 text-xs font-semibold text-brand-900 hover:bg-brand-100" href="<%= request.getContextPath() %>/api/certificates/view/<%= c.getApplicationId() %>" target="_blank" rel="noopener">
                                        View
                                    </a>
                                    <a class="rounded-lg bg-brand-900 px-3 py-2 text-xs font-semibold text-white hover:bg-brand-800" href="<%= request.getContextPath() %>/api/certificates/download/<%= c.getApplicationId() %>">
                                        Download
                                    </a>
                                </div>
                            </article>
                        <% }} %>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>
