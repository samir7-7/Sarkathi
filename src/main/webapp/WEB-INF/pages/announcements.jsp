<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Announcement" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% List<Announcement> announcements=(List<Announcement>)request.getAttribute("announcements"); DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMMM d, yyyy"); if(announcements==null)announcements=List.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Announcements - SarkarSathi
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif}
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <header class="border-b border-slate-200 bg-white px-6 lg:px-12">
            <nav class="mx-auto flex max-w-7xl items-center justify-between py-4">
                <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">
                    Sarkar<span class="text-brand-500">Sathi</span>
                </a>
                <div class="hidden items-center gap-8 text-sm font-medium text-slate-600 lg:flex">
                    <a href="<%= request.getContextPath() %>/announcements" class="text-brand-900 font-semibold">
                        <i data-lucide="megaphone" class="h-4 w-4 shrink-0"></i>
                            <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture" class="hover:text-brand-900 transition">
                        Agriculture
                    </a>
                    <a href="<%= request.getContextPath() %>/budget" class="hover:text-brand-900 transition">
                        Budget
                    </a>
                    <a href="<%= request.getContextPath() %>/crop-advisory" class="hover:text-brand-900 transition">
                        Crop Advisory
                    </a>
                </div>
                <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white">
                    Login
                </a>
            </nav>
        </header>
        <main class="px-6 py-12 lg:px-12">
            <div class="mx-auto max-w-4xl">
                <div class="text-center mb-8">
                    <h1 class="text-4xl font-bold text-slate-900">
                        Announcements
                    </h1>
                    <p class="mt-3 text-lg text-slate-500">
                        Latest municipal notices and public updates
                    </p>
                </div>
                <div class="space-y-4">
                    <% if(announcements.isEmpty()){ %>
                        <div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm">
                            <p class="text-slate-500">
                                No announcements at this time
                            </p>
                        </div>
                    <% } else { for(Announcement a: announcements){ %>
                        <article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                            <h2 class="text-lg font-bold text-slate-900">
                                <%= esc(a.getTitle()) %>
                            </h2>
                            <p class="mt-3 text-sm leading-relaxed text-slate-600">
                                <%= esc(a.getContent()) %>
                            </p>
                            <p class="mt-4 text-xs text-slate-400">
                                <%= a.getPublishedAt()==null?"":esc(a.getPublishedAt().format(fmt)) %>
                                <%= a.getEventDate()==null?"":" | Event: "+esc(a.getEventDate()) %>
                            </p>
                        </article>
                    <% }} %>
                </div>
            </div>
        </main>
    </body>
</html>
