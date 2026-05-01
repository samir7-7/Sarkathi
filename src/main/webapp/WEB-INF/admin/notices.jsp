<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.AgricultureNotice" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value) { if (value == null) return ""; return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;"); } private String categoryClass(String category) { if ("subsidy".equals(category)) return "bg-emerald-50 text-emerald-700"; if ("training".equals(category)) return "bg-violet-50 text-violet-700"; if ("scheme".equals(category)) return "bg-blue-50 text-blue-700"; return "bg-slate-50 text-slate-600"; } %>
<% Integer adminId = (Integer) request.getAttribute("adminId"); String adminName = (String) request.getAttribute("adminName"); String adminRole = (String) request.getAttribute("adminRole"); String pageError = (String) request.getAttribute("pageError"); String noticeError = (String) request.getAttribute("noticeError"); String formError = request.getParameter("error"); List<AgricultureNotice> notices = (List<AgricultureNotice>) request.getAttribute("notices"); DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM d, yyyy"); if (adminName == null) adminName = "Admin"; if (adminRole == null) adminRole = "admin"; if (notices == null) notices = List.of(); String error = pageError != null ? pageError : (noticeError != null ? noticeError : formError); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Manage Agriculture Notices - SarkarSathi Admin
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
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
                    <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="megaphone" class="h-4 w-4 shrink-0"></i>
                            <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
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
            <div class="ml-[220px] flex min-h-screen flex-1 flex-col">
                <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <h1 class="text-lg font-bold text-slate-900">
                        Manage Agriculture Notices
                    </h1>
                </header>
                <main class="flex-1 overflow-y-auto px-8 py-8">
                    <% if (error != null) { %>
                        <div class="mb-6 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <%= esc(error) %>
                        </div>
                    <% } %>
                    <section class="mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                        <h3 class="mb-4 text-base font-bold text-slate-900">
                            Create Agriculture Notice
                        </h3>
                        <form method="post" action="<%= request.getContextPath() %>/api/agriculture-notices" class="space-y-4">
                            <input type="hidden" name="redirectTo" value="/admin/notices">
                            <input type="hidden" name="adminId" value="<%= adminId == null ? "" : adminId %>">
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
                                <textarea name="content" rows="4" required class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></textarea>
                            </div>
                            <div>
                                <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                    Category
                                </label>
                                <select name="category" required class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                    <option value="subsidy">Subsidy</option>
                                    <option value="training">Training</option>
                                    <option value="scheme">Scheme</option>
                                </select>
                            </div>
                            <button class="rounded-xl bg-brand-900 px-5 py-3 text-sm font-semibold text-white hover:bg-brand-800" type="submit">
                                Publish Notice
                            </button>
                        </form>
                    </section>
                    <div class="space-y-4">
                        <% if (notices.isEmpty()) { %>
                            <div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm">
                                <p class="text-slate-500">
                                    No notices
                                </p>
                            </div>
                        <% } else { for (AgricultureNotice notice : notices) { %>
                            <article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                                <div class="flex items-start justify-between gap-4">
                                    <div>
                                        <div class="flex flex-wrap items-center gap-3">
                                            <h3 class="text-base font-bold text-slate-900">
                                                <%= esc(notice.getTitle()) %>
                                            </h3>
                                            <span class="rounded-full <%= categoryClass(notice.getCategory()) %> px-3 py-1 text-xs font-semibold uppercase tracking-wide">
                                                <%= esc(notice.getCategory()) %>
                                            </span>
                                        </div>
                                        <p class="mt-2 text-sm leading-6 text-slate-600">
                                            <%= esc(notice.getContent()) %>
                                        </p>
                                        <p class="mt-2 text-xs text-slate-400">
                                            <%= notice.getPublishedAt() == null ? "" : esc(notice.getPublishedAt().format(dateFormatter)) %>
                                        </p>
                                    </div>
                                    <form method="post" action="<%= request.getContextPath() %>/api/agriculture-notices">
                                        <input type="hidden" name="redirectTo" value="/admin/notices">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="noticeId" value="<%= notice.getNoticeId() %>">
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
