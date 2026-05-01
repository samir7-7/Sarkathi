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
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="layout-dashboard" class="h-4 w-4 shrink-0"></i>
                            <span>Dashboard</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="clipboard-list" class="h-4 w-4 shrink-0"></i>
                            <span>Applications</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
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
                        Manage Announcements
                    </h1>
                </header>
                <main class="flex-1 px-8 py-8 overflow-y-auto">
                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-6 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>
                    <section class="mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                        <h3 class="text-base font-bold text-slate-900 mb-4">
                            Create Announcement
                        </h3>
                        <form method="post" action="<%= request.getContextPath() %>/api/announcements" class="space-y-4">
                            <input type="hidden" name="redirectTo" value="/admin/announcements">
                            <input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
                            <div>
                                <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                    Title
                                </label>
                                <input name="title" type="text" required class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                            </div>
                            <div>
                                <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                    Content
                                </label>
                                <textarea name="content" rows="4" required class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                </textarea>
                            </div>
                            <div>
                                <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                    Event Date (optional)
                                </label>
                                <input name="eventDate" type="date" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                            </div>
                            <button class="rounded-xl bg-brand-900 px-5 py-3 text-sm font-semibold text-white hover:bg-brand-800" type="submit">
                                Publish
                            </button>
                        </form>
                    </section>
                    <div class="space-y-4">
                        <% if(announcements.isEmpty()){ %>
                            <div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm">
                                <p class="text-slate-500">
                                    No announcements
                                </p>
                            </div>
                        <% } else { for(Announcement a: announcements){ %>
                            <article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                                <div class="flex items-start justify-between gap-4">
                                    <div>
                                        <h3 class="text-base font-bold text-slate-900">
                                            <%= esc(a.getTitle()) %>
                                        </h3>
                                        <p class="mt-2 text-sm text-slate-600">
                                            <%= esc(a.getContent()) %>
                                        </p>
                                        <p class="mt-2 text-xs text-slate-400">
                                            <%= a.getPublishedAt()==null?"":esc(a.getPublishedAt().format(dateFormatter)) %>
                                            <%= a.getEventDate()==null?"":" | Event: "+esc(a.getEventDate()) %>
                                        </p>
                                    </div>
                                    <form method="post" action="<%= request.getContextPath() %>/api/announcements">
                                        <input type="hidden" name="redirectTo" value="/admin/announcements">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="announcementId" value="<%= a.getAnnouncementId() %>">
                                        <button class="rounded-lg border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-600 hover:bg-red-50" type="submit">
                                            Delete
                                        </button>
                                    </form>
                                </div>
                            </article>
                        <% }} %>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>
