<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Announcement" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){ if(value==null) return ""; return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;"); } %>
<%
Integer adminId=(Integer)request.getAttribute("adminId");
String adminName=(String)request.getAttribute("adminName");
String adminRole=(String)request.getAttribute("adminRole");
String pageError=(String)request.getAttribute("pageError");
String formError=request.getParameter("error");
List<Announcement> announcements=(List<Announcement>)request.getAttribute("announcements");
String editingAnnouncementId=(String)request.getAttribute("editingAnnouncementId");
DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMM d, yyyy");
if(announcements==null)announcements=List.of();
if(adminName==null)adminName="Admin";
if(adminRole==null)adminRole="System Controller";
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Announcements - Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{500:'#3b82f6',900:'#0b3d86'}}}}}</script>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:700}.safe-area-bottom{padding-bottom:env(safe-area-inset-bottom,1.5rem)}.mobile-record-card{border:1px solid #e2e8f0;border-radius:1.5rem;background:#fff;padding:1.25rem;box-shadow:0 10px 30px rgba(15,23,42,.06)}.mobile-meta-box{border:1px solid #e2e8f0;border-radius:1rem;background:#f8fafc;padding:.9rem 1rem}.mobile-action-button{display:inline-flex;align-items:center;justify-content:center;width:100%;border-radius:1rem;padding:.9rem 1rem;font-size:.72rem;font-weight:900;letter-spacing:.08em;text-transform:uppercase}.mobile-action-button.secondary{background:#eff6ff;color:#2563eb}.mobile-action-button.danger{background:#fff1f2;color:#e11d48}@media (max-width:639px){.mobile-compose-card{border:none;background:transparent;box-shadow:none;padding:0}.mobile-compose-form{display:grid;gap:1rem}}</style>
<%@ include file="../includes/lucide-icons.jsp" %>
</head>
<body class="bg-slate-100 text-slate-900 antialiased overflow-x-hidden">
<div class="flex min-h-screen relative">
<div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden"></div>
<%@ include file="../includes/sidebar-admin.jsp" %>
<div class="flex-1 flex flex-col min-h-screen">
<header class="sticky top-0 z-40 bg-white/90 backdrop-blur border-b border-slate-200 px-4 py-3.5 lg:px-7">
<div class="flex items-start justify-between gap-4 sm:items-center">
<div class="flex items-start gap-3">
<button onclick="toggleSidebar()" class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 shadow-sm transition hover:bg-slate-50 lg:hidden"><i data-lucide="menu" class="h-5 w-5"></i></button>
<div>
<h1 class="text-lg font-black tracking-tight text-slate-900">Announcement Center</h1><p class="text-[11px] font-semibold text-slate-500">Create and manage citizen-facing updates</p>
</div></div>
<div class="flex items-center gap-3 rounded-full sm:rounded-xl sm:border sm:border-slate-200 sm:bg-slate-50 sm:px-3 sm:py-2">
<div class="h-11 w-11 rounded-full bg-brand-900 flex items-center justify-center text-white text-sm font-bold shadow-sm sm:h-9 sm:w-9"><%= adminName.length() > 0 ? adminName.substring(0,1).toUpperCase() : "A" %></div>
<div class="hidden sm:block">
<p class="text-sm font-bold text-slate-900"><%= esc(adminName) %></p>
<p class="text-[11px] font-semibold text-slate-500"><%= esc(adminRole) %></p>
</div>
</div>
</div></header>
<main class="flex-1 w-full p-3 sm:p-4 lg:p-6">
<div class="space-y-5 max-w-6xl">
<% if(pageError!=null || formError!=null){ %><div class="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-xs font-bold text-rose-700"><%= esc(pageError!=null?pageError:formError) %></div><% } %>
<section class="mobile-compose-card rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
<div class="flex flex-col items-start gap-3 sm:flex-row sm:items-start sm:justify-between">
<div class="min-w-0">
<h2 class="text-sm font-black uppercase tracking-wider text-slate-900">Publish Announcement</h2>
<p class="mt-1 text-sm text-slate-500">Share public-facing updates, event reminders, and important municipal notices.</p>
</div>
<span class="rounded-full bg-brand-50 px-3 py-1 text-[10px] font-black uppercase tracking-wider text-brand-900"><%= announcements.size() %> Active</span>
</div>
<form method="post" action="<%= request.getContextPath() %>/api/announcements" class="mobile-compose-form mt-5 grid gap-4">
<input type="hidden" name="redirectTo" value="/admin/announcements"><input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
<div class="grid gap-4 lg:grid-cols-[1.2fr_0.8fr]">
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Headline</span><input name="title" type="text" required placeholder="Ward meeting, road closure, health camp..." class="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none"></label>
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Event Date</span><input name="eventDate" type="date" class="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none"></label>
</div>
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Announcement Body</span><textarea name="content" rows="5" required placeholder="Add the details citizens should know, including timings, location, and next steps." class="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none resize-none"></textarea></label>
<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
<p class="text-xs font-semibold text-slate-400">Published announcements appear on the citizen announcements page immediately.</p>
<button class="rounded-xl bg-brand-900 px-5 py-3 text-xs font-black uppercase tracking-wider text-white hover:bg-brand-800" type="submit">Publish Announcement</button>
</div>
</form></section>

<section class="rounded-2xl border border-slate-200 bg-white shadow-sm overflow-hidden">
<div class="flex flex-col gap-2 border-b border-slate-200 px-5 py-4 sm:flex-row sm:items-center sm:justify-between">
<div class="min-w-0"><h2 class="text-sm font-black uppercase tracking-wider text-slate-900">Announcement Records</h2><p class="mt-1 text-xs font-semibold text-slate-500">Review, edit, and remove published announcements.</p></div>
</div>
<div class="space-y-3 p-3 sm:hidden">
<% if(announcements.isEmpty()){ %><div class="mobile-record-card text-center text-sm font-semibold text-slate-500">No announcements published yet.</div>
<% } else { for(Announcement a: announcements){ %>
<article class="mobile-record-card">
<div class="flex items-start justify-between gap-3">
<div class="min-w-0"><p class="text-lg font-black leading-tight text-slate-900"><%= esc(a.getTitle()) %></p></div>
<span class="shrink-0 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-1 text-[10px] font-black uppercase tracking-wider text-emerald-700">Published</span>
</div>
<div class="mt-4 grid gap-3">
<div class="mobile-meta-box"><p class="text-[10px] font-black uppercase tracking-wider text-slate-400">Published</p><p class="mt-1 text-sm font-bold text-slate-800"><%= a.getPublishedAt()==null?"-":esc(a.getPublishedAt().format(fmt)) %></p></div>
<div class="mobile-meta-box"><p class="text-[10px] font-black uppercase tracking-wider text-slate-400">Event Date</p><p class="mt-1 text-sm font-bold text-slate-800"><%= a.getEventDate()==null?"-":esc(a.getEventDate()) %></p></div>
<div class="mobile-meta-box"><p class="text-[10px] font-black uppercase tracking-wider text-slate-400">Announcement Body</p><p class="mt-1 whitespace-pre-wrap text-sm font-bold leading-6 text-slate-800"><%= esc(a.getContent()) %></p></div>
</div>
<div class="mt-4 grid gap-3">
<form method="get" action="<%= request.getContextPath() %>/admin/announcements"><input type="hidden" name="edit" value="<%= a.getAnnouncementId() %>"><button class="mobile-action-button secondary" type="submit">Edit Announcement</button></form>
<form method="post" action="<%= request.getContextPath() %>/api/announcements" onsubmit="return confirm('Delete this announcement?')"><input type="hidden" name="redirectTo" value="/admin/announcements"><input type="hidden" name="action" value="delete"><input type="hidden" name="announcementId" value="<%= a.getAnnouncementId() %>"><button class="mobile-action-button danger" type="submit">Delete Announcement</button></form>
</div>
</article>
<% if(editingAnnouncementId!=null && editingAnnouncementId.equals(String.valueOf(a.getAnnouncementId()))){ %>
<div class="mobile-record-card bg-slate-50"><form method="post" action="<%= request.getContextPath() %>/api/announcements" class="grid gap-3"><input type="hidden" name="announcementId" value="<%= a.getAnnouncementId() %>"><input type="hidden" name="_method" value="PUT"><input type="hidden" name="redirectTo" value="/admin/announcements"><label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Headline</span><input name="title" type="text" required value="<%= esc(a.getTitle()) %>" class="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm"></label><label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Event Date</span><input name="eventDate" type="date" value="<%= a.getEventDate()==null?"":a.getEventDate() %>" class="rounded-xl border border-slate-200 px-4 py-3 text-sm"></label><label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Announcement Body</span><textarea name="content" rows="4" required class="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm resize-none"><%= esc(a.getContent()) %></textarea></label><div class="flex flex-col gap-2"><button class="rounded-xl bg-brand-900 px-5 py-3 text-xs font-black uppercase text-white" type="submit">Save Changes</button><a href="<%= request.getContextPath() %>/admin/announcements" class="rounded-xl bg-slate-200 px-5 py-3 text-xs font-black uppercase text-slate-700 text-center">Cancel</a></div></form></div>
<% } %>
<% }} %></div>
<div class="hidden sm:block overflow-x-auto">
<table class="w-full text-left"><thead><tr class="bg-slate-50"><th class="px-5 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Headline</th><th class="px-5 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Published</th><th class="px-5 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Event Date</th><th class="px-5 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Summary</th><th class="px-5 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Actions</th></tr></thead><tbody class="divide-y divide-slate-100">
<% if(announcements.isEmpty()){ %><tr><td colspan="5" class="px-5 py-14 text-center text-sm font-semibold text-slate-500">No announcements published yet.</td></tr>
<% } else { for(Announcement a: announcements){ %>
<tr class="align-top"><td class="px-5 py-4"><p class="text-sm font-black text-slate-900"><%= esc(a.getTitle()) %></p></td><td class="px-5 py-4 text-sm font-semibold text-slate-600"><%= a.getPublishedAt()==null?"-":esc(a.getPublishedAt().format(fmt)) %></td><td class="px-5 py-4 text-sm font-semibold text-slate-600"><%= a.getEventDate()==null?"-":esc(a.getEventDate()) %></td><td class="px-5 py-4"><p class="max-w-md text-sm leading-6 text-slate-600"><%= esc(a.getContent()) %></p></td><td class="px-5 py-4"><div class="flex gap-2"><form method="get" action="<%= request.getContextPath() %>/admin/announcements"><input type="hidden" name="edit" value="<%= a.getAnnouncementId() %>"><button class="h-9 w-9 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center" type="submit"><i data-lucide="edit-2" class="h-4 w-4"></i></button></form><form method="post" action="<%= request.getContextPath() %>/api/announcements" onsubmit="return confirm('Delete this announcement?')"><input type="hidden" name="redirectTo" value="/admin/announcements"><input type="hidden" name="action" value="delete"><input type="hidden" name="announcementId" value="<%= a.getAnnouncementId() %>"><button class="h-9 w-9 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center" type="submit"><i data-lucide="trash-2" class="h-4 w-4"></i></button></form></div></td></tr>
<% if(editingAnnouncementId!=null && editingAnnouncementId.equals(String.valueOf(a.getAnnouncementId()))){ %>
<tr><td colspan="5" class="bg-slate-50 px-5 py-5"><form method="post" action="<%= request.getContextPath() %>/api/announcements" class="grid gap-3 lg:grid-cols-2"><input type="hidden" name="announcementId" value="<%= a.getAnnouncementId() %>"><input type="hidden" name="_method" value="PUT"><input type="hidden" name="redirectTo" value="/admin/announcements"><label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Headline</span><input name="title" type="text" required value="<%= esc(a.getTitle()) %>" class="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm"></label><label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Event Date</span><input name="eventDate" type="date" value="<%= a.getEventDate()==null?"":a.getEventDate() %>" class="rounded-xl border border-slate-200 px-4 py-3 text-sm"></label><label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500 lg:col-span-2"><span>Announcement Body</span><textarea name="content" rows="4" required class="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm resize-none"><%= esc(a.getContent()) %></textarea></label><div class="flex gap-2 lg:col-span-2"><button class="rounded-xl bg-brand-900 px-5 py-3 text-xs font-black uppercase text-white" type="submit">Save Changes</button><a href="<%= request.getContextPath() %>/admin/announcements" class="rounded-xl bg-slate-200 px-5 py-3 text-xs font-black uppercase text-slate-700 text-center">Cancel</a></div></form></td></tr>
<% } %>
<% }} %></tbody></table></div></section></div></main></div></div>
<%@ include file="../includes/responsive-scripts.jsp" %>
<script>lucide.createIcons();</script></body></html>
