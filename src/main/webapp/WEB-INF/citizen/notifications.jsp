<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Notification" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId");String citizenName=(String)request.getAttribute("citizenName");List<Notification> notifications=(List<Notification>)request.getAttribute("notifications");Integer unread=(Integer)request.getAttribute("unreadCount");DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMM d, yyyy HH:mm");if(citizenName==null)citizenName="Citizen";if(notifications==null)notifications=List.of();if(unread==null)unread=0;String initials=citizenName.isBlank()?"C":citizenName.substring(0,1).toUpperCase(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Notifications - SarkarSathi
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif;-webkit-tap-highlight-color:transparent}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav (Citizen) -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/90 backdrop-blur-lg px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Apply</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Track</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">More</span>
                </button>
            </nav>

            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>

            <aside id="sidebar" class="fixed inset-y-0 right-0 z-[70] flex w-[280px] translate-x-full flex-col border-l border-slate-200 bg-white transition-transform duration-300 lg:static lg:translate-x-0 lg:w-[240px] lg:border-l-0 lg:border-r">
                <div class="px-6 pt-6 pb-2 flex items-center justify-between">
                    <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">
                        SarkarSathi
                    </a>
                     <button onclick="toggleSidebar()" class="p-2 text-slate-500 lg:hidden rounded-full hover:bg-slate-100 transition-colors">
                        <i data-lucide="x" class="h-6 w-6"></i>
                    </button>
                </div>
                <div class="mx-5 mt-4 flex items-center gap-3 rounded-2xl bg-brand-900 px-4 py-4 text-white shadow-xl shadow-brand-900/10">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-white/10 text-white text-xs font-bold border border-white/10">
                        <%= esc(initials) %>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-white truncate"><%= esc(citizenName) %></p>
                        <p class="text-[10px] font-bold uppercase tracking-widest text-white/50 mb-0.5">Citizen Profile</p>
                    </div>
                </div>
                <nav class="mt-8 flex-1 space-y-1.5 px-4 overflow-y-auto">
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="layout-dashboard" class="h-5 w-5 shrink-0"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="file-plus-2" class="h-5 w-5 shrink-0"></i>
                        <span>Apply for Service</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="search-check" class="h-5 w-5 shrink-0"></i>
                        <span>Track Application</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="credit-card" class="h-5 w-5 shrink-0"></i>
                        <span>Payments & Tax</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="badge-check" class="h-5 w-5 shrink-0"></i>
                        <span>Certificates</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="folder-open" class="h-5 w-5 shrink-0"></i>
                        <span>My Documents</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-4 pb-20 lg:pb-6 pt-4">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-red-600 hover:bg-red-50">
                        <i data-lucide="log-out" class="h-5 w-5 shrink-0"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </aside>
            <div class="flex-1 flex flex-col min-h-screen w-full overflow-hidden pb-16 lg:pb-0">
                <header class="sticky top-0 z-40 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-xl px-6 py-4 sm:px-8">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900 tracking-tight">
                            Alert Center
                        </h1>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest leading-none mt-1">
                            System Communications
                        </p>
                    </div>
                    <% if(unread>0){ %>
                    <form method="post" action="<%= request.getContextPath() %>/api/notifications">
                        <input type="hidden" name="redirectTo" value="/citizen/notifications">
                        <input type="hidden" name="action" value="markAll">
                        <input type="hidden" name="citizenId" value="<%= citizenId %>">
                        <button class="rounded-2xl bg-brand-50 px-5 py-2.5 text-[10px] font-bold uppercase tracking-widest text-brand-900 transition-all active:scale-95" type="submit">
                            Clear All (
                            <%= unread %>
                            )
                        </button>
                    </form>
                    <% } %>
                </header>
                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-4xl mx-auto">
                    <div class="space-y-4">
                        <% if(notifications.isEmpty()){ %>
                            <div class="rounded-[2.5rem] border border-dashed border-slate-200 bg-slate-50/50 p-20 text-center shadow-sm">
                                <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-slate-300 mb-6">
                                    <i data-lucide="bell-off" class="h-8 w-8"></i>
                                </div>
                                <h3 class="text-xl font-bold text-slate-900">Quiet Environment</h3>
                                <p class="text-sm text-slate-500 mt-1">No new transmissions found in your inbox.</p>
                            </div>
                        <% } else { for(Notification n: notifications){ %>
                            <article class="group relative rounded-3xl border <%= n.isRead()?"border-slate-100 bg-white":"border-brand-100 bg-brand-50/50" %> p-6 shadow-sm transition-all hover:shadow-md">
                                <div class="flex items-start gap-4">
                                    <div class="h-10 w-10 shrink-0 flex items-center justify-center rounded-xl <%= n.isRead()?"bg-slate-50 text-slate-400":"bg-white text-brand-900 shadow-sm" %>">
                                        <i data-lucide="<%= n.isRead()?"mail-open":"mail" %>" class="h-5 w-5"></i>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <p class="text-sm font-semibold text-slate-800 leading-relaxed mb-1 pr-2">
                                            <%= esc(n.getMessage()) %>
                                        </p>
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="clock" class="h-3 w-3 text-slate-400"></i>
                                            <span class="text-[10px] font-bold text-slate-400 tracking-wider">
                                                <%= n.getCreatedAt()==null?"":esc(n.getCreatedAt().format(fmt)) %>
                                            </span>
                                        </div>
                                    </div>
                                    <% if(!n.isRead()){ %>
                                        <form method="post" action="<%= request.getContextPath() %>/api/notifications" class="shrink-0">
                                            <input type="hidden" name="redirectTo" value="/citizen/notifications">
                                            <input type="hidden" name="action" value="markRead">
                                            <input type="hidden" name="citizenId" value="<%= citizenId %>">
                                            <input type="hidden" name="notificationId" value="<%= n.getNotificationId() %>">
                                            <button class="h-10 w-10 flex items-center justify-center rounded-xl bg-brand-900 text-white shadow-lg shadow-brand-900/10 active:scale-95 transition-transform" type="submit" title="Mark Read">
                                                <i data-lucide="check" class="h-4 w-4"></i>
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </article>
                        <% }} %>
                    </div>
                </main>
            </div>
        </div>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebar-overlay');
                const isHidden = sidebar.classList.contains('translate-x-full');
                
                if (isHidden) {
                    sidebar.classList.remove('translate-x-full');
                    overlay.classList.remove('hidden');
                    document.body.style.overflow = 'hidden';
                } else {
                    sidebar.classList.add('translate-x-full');
                    overlay.classList.add('hidden');
                    document.body.style.overflow = '';
                }
            }
        </script>
    </body>
</html>
