<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Notification" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% 
    Integer citizenId = (Integer)request.getAttribute("citizenId");
    String citizenName = (String)request.getAttribute("citizenName");
    List<Notification> notifications = (List<Notification>)request.getAttribute("notifications");
    Integer unread = (Integer)request.getAttribute("unreadCount");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy HH:mm");
    
    if(citizenName == null) citizenName = "Citizen";
    if(notifications == null) notifications = List.of();
    if(unread == null) unread = 0;
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Notifications - SarkarSathi</title>
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
                <a href="<%= request.getContextPath() %>/citizen/notifications" class="flex flex-col items-center justify-center gap-1 text-brand-900 relative">
                    <i data-lucide="bell" class="h-5 w-5"></i>
                    <% if(unread>0){ %><span class="absolute top-0 right-1 h-2 w-2 rounded-full bg-red-500"></span><% } %>
                    <span class="text-[10px] font-bold">Inbox</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Menu</span>
                </button>
            </nav>

            <!-- Sidebar -->
            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            
            <%@ include file="../includes/sidebar-citizen.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">

                <!-- Header -->
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200 bg-white px-8 py-4">
                    <h1 class="text-xl font-bold text-slate-900 tracking-tight">Inbox Notifications</h1>
                    <% if(unread>0){ %>
                    <form method="post" action="<%= request.getContextPath() %>/api/notifications">
                        <input type="hidden" name="redirectTo" value="/citizen/notifications">
                        <input type="hidden" name="action" value="markAll">
                        <input type="hidden" name="citizenId" value="<%= citizenId %>">
                        <button type="submit" class="bg-brand-50 text-brand-900 text-[11px] font-bold uppercase tracking-widest px-5 py-2.5 rounded-xl hover:bg-brand-100 transition-colors">Clear All (<%= unread %>)</button>
                    </form>
                    <% } %>
                </header>

                <div class="lg:hidden px-5 pt-6 pb-2 flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-extrabold text-slate-900 tracking-tight">Alerts</h1>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest mt-1">Inbox Feed</p>
                    </div>
                    <% if(unread>0){ %>
                    <form method="post" action="<%= request.getContextPath() %>/api/notifications">
                        <input type="hidden" name="redirectTo" value="/citizen/notifications">
                        <input type="hidden" name="action" value="markAll">
                        <input type="hidden" name="citizenId" value="<%= citizenId %>">
                        <button type="submit" class="h-10 w-10 flex items-center justify-center bg-brand-50 text-brand-900 rounded-xl"><i data-lucide="check-check" class="h-5 w-5"></i></button>
                    </form>
                    <% } %>
                </div>

                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-4xl mx-auto pb-32 lg:pb-8">
                    <div class="space-y-3">
                        <% if(notifications.isEmpty()){ %>
                            <div class="py-20 text-center bg-white rounded-3xl border border-dashed border-slate-200">
                                <div class="h-16 w-16 bg-slate-50 text-slate-300 rounded-full flex items-center justify-center mx-auto mb-4">
                                    <i data-lucide="bell-off" class="h-8 w-8"></i>
                                </div>
                                <h3 class="text-slate-900 font-bold">Inbox is Clear</h3>
                                <p class="text-slate-400 text-sm mt-1">No pending updates found</p>
                            </div>
                        <% } else { for(Notification n : notifications){ %>
                            <article class="bg-white p-5 rounded-3xl border <%= n.isRead() ? "border-slate-100 opacity-80" : "border-brand-100 bg-brand-50/20" %> shadow-sm flex items-start gap-4">
                                <div class="h-10 w-10 bg-slate-50 text-slate-400 rounded-xl flex items-center justify-center flex-shrink-0">
                                    <i data-lucide="<%= n.isRead() ? "mail-open" : "mail" %>" class="h-5 w-5 <%= n.isRead() ? "" : "text-brand-900" %>"></i>
                                </div>
                                <div class="flex-1">
                                    <p class="text-sm font-medium text-slate-700 leading-relaxed mb-1.5"><%= esc(n.getMessage()) %></p>
                                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest flex items-center gap-1.5">
                                        <i data-lucide="clock" class="h-3 w-3"></i>
                                        <%= n.getCreatedAt()==null?"—":esc(n.getCreatedAt().format(fmt)) %>
                                    </p>
                                </div>
                                <% if(!n.isRead()){ %>
                                    <form method="post" action="<%= request.getContextPath() %>/api/notifications">
                                        <input type="hidden" name="redirectTo" value="/citizen/notifications">
                                        <input type="hidden" name="action" value="markRead">
                                        <input type="hidden" name="notificationId" value="<%= n.getNotificationId() %>">
                                        <input type="hidden" name="citizenId" value="<%= citizenId %>">
                                        <button type="submit" class="h-8 w-8 flex items-center justify-center bg-brand-900 text-white rounded-lg"><i data-lucide="check" class="h-4 w-4"></i></button>
                                    </form>
                                <% } %>
                            </article>
                        <% }} %>
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