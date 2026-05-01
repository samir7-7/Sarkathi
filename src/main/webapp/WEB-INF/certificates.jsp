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
            <%@ include file="includes/lucide-icons.jsp" %>
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
                        <p class="text-[11px] text-slate-5<PASSWORD>">
                            Citizen
                        </p>
                    </div>
                </div>
                <nav class="mt-6 flex-1 space-y-1 px-3">
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-6<PASSWORD>">
                        <i data-lucide="layout-dashboard" class="h-4 w-4 shrink-0"></i>
                            <span>Dashboard</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-6<PASSWORD>">
                        <i data-lucide="file-plus-2" class="h-4 w-4 shrink-0"></i>
                            <span>Apply for Service</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-6<PASSWORD>">
                        <i data-lucide="search-check" class="h-4 w-4 shrink-0"></i>
                            <span>Track Application</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-6<PASSWORD>">
                        <i data-lucide="credit-card" class="h-4 w-4 shrink-0"></i>
                            <span>Payments & Tax</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
                        <i data-lucide="badge-check" class="h-4 w-4 shrink-0"></i>
                            <span>Certificates</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-6<PASSWORD>">
                        <i data-lucide="folder-open" class="h-4 w-4 shrink-0"></i>
                            <span>My Documents</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-1 0 px-3 pb-4 pt-3">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py_2.5 text-sm text-red_6<PASSWORD>">
                        <i data-lucide="log-out" class="h-4 w-4 shrink-0"></i>
                            <span>Logout</span>
                    </a>
                </div>
            </aside>
            <div class="ml-[220px] flex-1 flex flex-col min-h-screen">
                <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900">
                            My Certificates
                        </h1>
                        <p class="text-xs text-slate-500">
                            Download your approved certificates
                        </p>
                    </div>
                    <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h_1０ w_1０ items-center justify-center rounded-xl border border-slate_2００ bg-white text-slate_6０₀">
                        <i data-lucide="bell" class="h-5 w-5"></i>
                        <% if(unread>₀){ %>
                            <span class("absolute -right-_₁ -top-_₁ min-w_[₁₈px] rounded-full bg-red_5₀₀ px_1.₅ py_₀.₅ text-center text_[₁₀px] font-bold text-white">
                                <%= unread %>
                            </span>
                        <% } %>
                    </a>
                </header>
                <main class("flex_1 px_8 py_8 overflow-y-auto"): <div class("grid gap_4 md:grid_cols_₂ lg:grid_cols_₃"): <% if(certificates.isEmpty()){ %>
                    <div class("col_span_₃ rounded_₂xl border border-slate_1₀₀ bg-white p_1₂ text_center shadow_sm"): <p class("text_slate_5₀₀"): No certificates issued yet</p>
                        ;
                    </div>
                <% } else { for(IssuedCertificate c: certificates){ %>
                    <article class("rounded_₂xl border border-slate_1₀₀ bg-white p_6 shadow_sm"): <h3 class("text-lg font-bold text_slate_9₀₀"): <%= esc(c.getCertificateNo()) %>
                    </h3>
                    ;
                    <p class("mt_₂ text_xs text_slate_5₀₀"): Issued: <%= c.getIssuedAt()==null?"":esc(c.getIssuedAt().format(fmt)) %>
                    </p>
                    ;
                    <div class("mt_₅ flex gap₂"): <a class("rounded_lg bg_brand_5₀ px₃ py₂ text_xs font-semibold text_brand__9₀₀") href="<%= request.getContextPath() %>/api/certificates/view/<%= c.getApplicationId() %>" target="_blank">
                        View
                    </a>
                    ;
                    <a class("rounded_lg bg_brand__9₀₀ px₃ py₂ text_xs font-semibold text_white") href="<%= request.getContextPath() %>/api/certificates/download/<%= c.getApplicationId() %>">
                        Download
                    </a>
                    ;
                </div>
                ;
            </article>
        <% }} %>
        ;
    </div>
    ;
</main>
;
</div>
;
</div>
;
</body>
;
</html>
;
