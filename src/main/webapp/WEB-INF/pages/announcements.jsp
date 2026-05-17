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
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',400:'#60a5fa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <%@ include file="../includes/responsive-scripts.jsp" %>
        <style>
            html{zoom:0.86}body{font-family:'Outfit',sans-serif}
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-16 lg:pb-0 overflow-x-hidden">
        <% String displayName = (String) session.getAttribute("displayName"); boolean loggedIn = displayName != null && !displayName.isBlank(); %>
        <%@ include file="../includes/navbar-public.jsp" %>

        <main>
            <div class="p-6 lg:p-12">
                <!-- Page Title -->
                <div class="max-w-4xl mx-auto mb-10">
                    <div class="flex items-center gap-3 text-blue-600 mb-2">
                        <i data-lucide="megaphone" class="h-6 w-6"></i>
                        <span class="text-xs font-black uppercase tracking-widest leading-none">News & Updates</span>
                    </div>
                    <h1 class="text-4xl lg:text-5xl font-black text-slate-900 tracking-tight leading-tight">Public Record</h1>
                    <p class="mt-4 text-slate-500 font-medium text-lg leading-relaxed max-w-2xl">
                        A decentralized hub for all municipal announcements, emergency alerts, and public interest notices.
                    </p>
                </div>

                <!-- Filtering & Sorting -->
                <div class="max-w-4xl mx-auto mb-8">
                    <div class="flex flex-col sm:flex-row gap-3 items-center justify-between bg-white p-4 rounded-xl border border-slate-200">
                        <div class="flex items-center gap-2 text-sm">
                            <i data-lucide="filter" class="h-4 w-4 text-slate-400"></i>
                            <span class="font-semibold text-slate-600">Showing <strong><%= announcements.size() %></strong> announcements</span>
                        </div>
                        <div class="flex gap-2">
                            <button class="px-3 py-2 text-xs font-bold rounded-lg bg-brand-900 text-white">Latest</button>
                            <button class="px-3 py-2 text-xs font-bold rounded-lg bg-slate-100 text-slate-700 hover:bg-slate-200">Popular</button>
                        </div>
                    </div>
                </div>

                <!-- Feed View -->
                <div class="max-w-4xl mx-auto">
                    <div class="grid gap-4 md:gap-6">
                        <% if(announcements.isEmpty()){ %>
                            <div class="flex flex-col items-center justify-center py-20 bg-white rounded-2xl border border-slate-100">
                                <i data-lucide="inbox" class="h-12 w-12 text-slate-200 mb-4"></i>
                                <h3 class="text-lg font-black text-slate-900">Silent Feed</h3>
                                <p class="text-slate-400 font-medium">There are no recent announcements to display.</p>
                            </div>
                        <% } else { for(Announcement a: announcements){ %>
                            <article class="group relative bg-white rounded-xl p-5 md:p-7 border border-slate-100 shadow-sm hover:shadow-md hover:border-brand-200 transition-all duration-300">
                                <div class="flex gap-4">
                                    <!-- Icon -->
                                    <div class="flex-shrink-0">
                                        <div class="h-12 w-12 rounded-lg bg-brand-50 flex items-center justify-center text-brand-900 group-hover:bg-brand-900 group-hover:text-white transition-all duration-300">
                                            <i data-lucide="megaphone" class="h-5 w-5"></i>
                                        </div>
                                    </div>

                                    <!-- Content -->
                                    <div class="flex-1 min-w-0">
                                        <div class="flex items-start justify-between gap-2 mb-2">
                                            <div class="flex-1">
                                                <h2 class="text-sm md:text-base font-black text-slate-900 group-hover:text-brand-900 transition-colors line-clamp-2"><%= esc(a.getTitle()) %></h2>
                                                <p class="text-[11px] font-semibold text-slate-400 mt-1">Published on <%= a.getPublishedAt()==null ? "Unspecified Date" : esc(a.getPublishedAt().format(fmt)) %></p>
                                            </div>
                                            <% if(a.getEventDate() != null) { %>
                                                <div class="flex-shrink-0 hidden sm:block">
                                                    <div class="inline-flex items-center gap-1.5 px-2.5 py-1.5 bg-emerald-50 text-emerald-700 rounded-lg text-[10px] font-bold whitespace-nowrap">
                                                        <i data-lucide="calendar-check" class="h-3 w-3"></i>
                                                        <%= esc(a.getEventDate().format(fmt)) %>
                                                    </div>
                                                </div>
                                            <% } %>
                                        </div>

                                        <p class="text-sm text-slate-600 font-medium leading-relaxed line-clamp-2 mb-3">
                                            <%= esc(a.getContent()) %>
                                        </p>

                                        <div class="flex items-center justify-between pt-3 border-t border-slate-50">
                                            <button class="flex items-center gap-1.5 text-xs font-bold uppercase tracking-wider text-brand-900 hover:text-brand-700 transition-colors">
                                                Read More
                                                <i data-lucide="arrow-right" class="h-3.5 w-3.5"></i>
                                            </button>
                                            <div class="flex items-center gap-3 text-slate-300">
                                                <button class="hover:text-brand-500 transition-colors"><i data-lucide="share-2" class="h-4 w-4"></i></button>
                                                <button class="hover:text-brand-500 transition-colors"><i data-lucide="bookmark" class="h-4 w-4"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </article>
                        <% }} %>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="../includes/mobile-nav-public.jsp" %>

        <script>lucide.createIcons();</script>
    </body>
</html>
