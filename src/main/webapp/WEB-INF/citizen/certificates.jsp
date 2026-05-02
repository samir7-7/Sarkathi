<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.IssuedCertificate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% 
    String citizenName = (String)request.getAttribute("citizenName"); 
    Integer unread = (Integer)request.getAttribute("unreadCount"); 
    List<IssuedCertificate> certificates = (List<IssuedCertificate>)request.getAttribute("certificates"); 
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy"); 
    
    if(citizenName == null) citizenName = "Citizen";
    if(unread == null) unread = 0;
    if(certificates == null) certificates = List.of();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Certificates - SarkarSathi</title>
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
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
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

            <!-- Sidebar -->
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
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
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
                            <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link active flex items-center gap-3 rounded-xl px-4 py-3 text-sm">
                                <i data-lucide="award" class="h-5 w-5 text-brand-900"></i>
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
                <!-- Header -->
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200 bg-white px-8 py-4">
                    <div>
                        <h1 class="text-xl font-bold text-slate-900 tracking-tight">Credentials Vault</h1>
                        <p class="text-xs text-slate-500 font-medium mt-0.5">Your officially issued digital certificates</p>
                    </div>
                    <div class="flex items-center gap-4">
                         <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2 text-slate-500 hover:text-brand-900 transition-colors border border-slate-100 rounded-xl">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %><span class="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span><% } %>
                        </a>
                    </div>
                </header>

                <!-- Mobile Header -->
                <div class="lg:hidden flex items-center justify-between px-5 pt-6 pb-4 bg-[#fafafc]">
                     <div class="flex flex-col">
                        <h1 class="text-2xl font-extrabold text-slate-900 tracking-tight leading-tight leading-tight">Certificates</h1>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em]">Official Vault</p>
                    </div>
                </div>

                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-7xl mx-auto pb-32 lg:pb-8">
                    <% if(certificates.isEmpty()){ %>
                        <div class="flex flex-col items-center justify-center py-20 bg-white rounded-3xl border border-dashed border-slate-200">
                            <div class="h-20 w-20 rounded-full bg-brand-50 flex items-center justify-center text-brand-900 mb-6">
                                <i data-lucide="award" class="h-10 w-10"></i>
                            </div>
                            <h3 class="text-lg font-bold text-slate-900">No Credentials Yet</h3>
                            <p class="text-slate-500 text-sm mt-1 max-w-xs text-center px-4 font-medium">Once your applications are approved, your certificates will be generated here.</p>
                            <a href="<%= request.getContextPath() %>/citizen/apply" class="mt-8 px-6 py-3 bg-brand-900 text-white text-xs font-bold uppercase tracking-widest rounded-2xl shadow-lg shadow-brand-900/10 hover:bg-brand-800 transition-colors">Start Application</a>
                        </div>
                    <% } else { %>
                        <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                            <% for(IssuedCertificate c : certificates){ %>
                                <article class="group relative bg-white rounded-3xl border border-slate-200 p-6 transition-all hover:shadow-xl hover:shadow-brand-900/5 overflow-hidden">
                                    <!-- Decorative background -->
                                    <div class="absolute -right-8 -top-8 h-32 w-32 rounded-full bg-brand-50/30 group-hover:scale-110 transition-transform duration-500"></div>
                                    
                                    <div class="relative">
                                        <div class="flex items-center justify-between mb-8">
                                            <div class="h-12 w-12 rounded-2xl bg-brand-900 flex items-center justify-center text-white shadow-lg shadow-brand-900/20">
                                                <i data-lucide="badge-check" class="h-6 w-6"></i>
                                            </div>
                                            <div class="text-right">
                                                <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Issued Date</p>
                                                <p class="text-xs font-bold text-slate-900"><%= c.getIssuedAt()==null?"—":esc(c.getIssuedAt().format(fmt)) %></p>
                                            </div>
                                        </div>

                                        <p class="text-[10px] font-bold text-brand-500 uppercase tracking-widest mb-1">Electronic Credential</p>
                                        <h3 class="text-lg font-bold text-slate-900 leading-tight mb-2 uppercase break-all"><%= esc(c.getCertificateNo()) %></h3>
                                        <p class="text-xs text-slate-500 font-medium mb-8">Issued via SarkarSathi Municipal Portal</p>

                                        <div class="grid grid-cols-2 gap-3 pt-2">
                                            <a href="<%= request.getContextPath() %>/api/certificates/view/<%= c.getApplicationId() %>" target="_blank" class="flex items-center justify-center py-3.5 px-4 bg-slate-50 rounded-2xl text-xs font-bold text-slate-600 hover:bg-slate-100 transition-colors">
                                                Preview
                                            </a>
                                            <a href="<%= request.getContextPath() %>/api/certificates/download/<%= c.getApplicationId() %>" class="flex items-center justify-center gap-2 py-3.5 px-4 bg-brand-900 text-white rounded-2xl text-xs font-bold shadow-lg shadow-brand-900/10 hover:bg-brand-800 transition-colors">
                                                <i data-lucide="download" class="h-4 w-4"></i>
                                                Download
                                            </a>
                                        </div>
                                    </div>
                                </article>
                            <% } %>
                        </div>
                    <% } %>
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