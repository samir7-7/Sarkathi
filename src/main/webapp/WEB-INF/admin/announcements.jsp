<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Announcement" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value) { if (value == null) return ""; return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;"); } %>
<% Integer adminId=(Integer)request.getAttribute("adminId"); String adminName=(String)request.getAttribute("adminName"); String adminRole=(String)request.getAttribute("adminRole"); String pageError=(String)request.getAttribute("pageError"); String formError=request.getParameter("error"); List<Announcement> announcements=(List<Announcement>)request.getAttribute("announcements"); DateTimeFormatter dateFormatter=DateTimeFormatter.ofPattern("MMM d, yyyy"); if(adminName==null)adminName="Admin"; if(adminRole==null)adminRole="admin"; if(announcements==null)announcements=List.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Manage Announcements - SarkarSathi Admin
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',500:'#3b82f6',900:'#0b3d86'}}}}}
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
            <!-- Mobile Bottom Nav (Admin) -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/90 backdrop-blur-lg px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/applications" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="clipboard-list" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Review</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/announcements" class="flex flex-col items-center justify-center gap-1 text-brand-900 transition-all">
                    <i data-lucide="megaphone" class="h-5 w-5"></i>
                    <span class="text-[10px] font-bold">Public</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Menu</span>
                </button>
            </nav>

            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            
            <%@ include file="../includes/sidebar-admin.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full overflow-hidden pb-16 lg:pb-0">
                <header class="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-slate-200 px-6 py-4 sm:px-8">
                    <h1 class="text-lg font-bold text-slate-900 tracking-tight">Public Announcements</h1>
                    <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest leading-none mt-1">Information Broadcast</p>
                </header>
                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-4xl mx-auto">
                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-6 rounded-2xl border-l-4 border-red-500 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700 shadow-sm animate-pulse">
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>
                    <section class="mb-10 rounded-[2.5rem] border border-slate-100 bg-white p-6 sm:p-8 shadow-sm">
                        <h3 class="text-lg font-extrabold text-slate-900 tracking-tight flex items-center gap-2 mb-6">
                            <i data-lucide="plus-circle" class="h-5 w-5 text-brand-500"></i>
                            New Broadcast
                        </h3>
                        <form method="post" action="<%= request.getContextPath() %>/api/announcements" class="space-y-4">
                            <input type="hidden" name="redirectTo" value="/admin/announcements">
                            <input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
                            <div class="grid gap-4 sm:grid-cols-2">
                                <div class="col-span-full">
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Headline</label>
                                    <input name="title" type="text" required placeholder="Announcement Title" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none">
                                </div>
                                <div class="col-span-full">
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Full Content</label>
                                    <textarea name="content" rows="4" required placeholder="Broadcast details..." class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none resize-none"></textarea>
                                </div>
                                <div>
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Target Date</label>
                                    <input name="eventDate" type="date" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none">
                                </div>
                                <div class="flex items-end">
                                    <button class="w-full rounded-2xl bg-brand-900 px-8 py-4 text-sm font-bold text-white shadow-xl shadow-brand-900/10 active:scale-95 transition-transform" type="submit">
                                        Release Notice
                                    </button>
                                </div>
                            </div>
                        </form>
                    </section>
                    <div class="space-y-4">
                        <h2 class="px-2 text-xl font-extrabold text-slate-900 tracking-tight mb-4">Published History</h2>
                        <% if(announcements.isEmpty()){ %>
                            <div class="rounded-[2.5rem] border border-dashed border-slate-200 bg-slate-50/50 p-20 text-center shadow-sm">
                                <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-slate-300 mb-6">
                                    <i data-lucide="megaphone" class="h-8 w-8"></i>
                                </div>
                                <h3 class="text-xl font-bold text-slate-900">Archives Empty</h3>
                                <p class="text-sm text-slate-500 mt-1">No announcements currently active in the system.</p>
                            </div>
                        <% } else { for(Announcement a: announcements){ %>
                            <article class="group relative overflow-hidden rounded-[2rem] border border-slate-100 bg-white p-6 shadow-sm transition-all hover:shadow-xl hover:shadow-brand-900/5">
                                <div class="flex items-start justify-between gap-6">
                                    <div class="flex-1 min-w-0">
                                        <div class="flex items-center gap-2 mb-2">
                                            <i data-lucide="calendar" class="h-3 w-3 text-brand-500"></i>
                                            <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">
                                                <%= a.getPublishedAt()==null?"":esc(a.getPublishedAt().format(dateFormatter)) %>
                                            </span>
                                            <% if(a.getEventDate()!=null && !a.getEventDate().toString().isBlank()){ %>
                                                <span class="mx-2 h-1 w-1 rounded-full bg-slate-200"></span>
                                                <span class="rounded-full bg-blue-50 px-2 py-0.5 text-[9px] font-black text-blue-600 uppercase tracking-tighter">Event: <%= esc(a.getEventDate()) %></span>
                                            <% } %>
                                        </div>
                                        <h3 class="text-lg font-black text-slate-900 mb-2 truncate"><%= esc(a.getTitle()) %></h3>
                                        <p class="text-sm leading-relaxed text-slate-600 font-medium line-clamp-2"><%= esc(a.getContent()) %></p>
                                    </div>
                                    <form method="post" action="<%= request.getContextPath() %>/api/announcements" class="shrink-0">
                                        <input type="hidden" name="redirectTo" value="/admin/announcements">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="announcementId" value="<%= a.getAnnouncementId() %>">
                                        <button class="h-10 w-10 flex items-center justify-center rounded-xl bg-red-50 text-red-600 transition-all hover:bg-red-100 active:scale-95" type="submit" title="Archive Notice">
                                            <i data-lucide="trash-2" class="h-4 w-4"></i>
                                        </button>
                                    </form>
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
    </body>
</html>
