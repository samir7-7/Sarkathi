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
    <body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-20 lg:pb-0">
        <!-- Modern Sidebar for Desktop -->
        <aside class="fixed left-0 top-0 hidden h-full w-64 border-r border-slate-200 bg-white lg:block z-50">
            <div class="flex h-full flex-col p-6">
                <a href="<%= request.getContextPath() %>" class="flex items-center gap-2 text-2xl font-black tracking-tight text-brand-900 mb-10">
                    Sarkar<span class="text-brand-500">Sathi</span>
                </a>
                
                <nav class="flex-1 space-y-2">
                    <a href="<%= request.getContextPath() %>/index.jsp" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="home" class="h-5 w-5"></i> Home
                    </a>
                    <a href="<%= request.getContextPath() %>/announcements" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-black bg-brand-50 text-brand-900 shadow-sm border border-brand-100/50">
                        <i data-lucide="megaphone" class="h-5 w-5"></i> Announcements
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="leaf" class="h-5 w-5"></i> Agriculture
                    </a>
                    <a href="<%= request.getContextPath() %>/budget" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="wallet" class="h-5 w-5"></i> Budget
                    </a>
                    <a href="<%= request.getContextPath() %>/crop-advisory" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="sprout" class="h-5 w-5"></i> Crop Advisory
                    </a>
                </nav>

                <div class="mt-auto pt-6 border-t border-slate-100">
                    <a href="<%= request.getContextPath() %>/login" class="flex items-center justify-center gap-2 w-full rounded-xl bg-slate-900 py-3 text-sm font-black text-white hover:bg-brand-900 transition-all">
                        <i data-lucide="log-in" class="h-4 w-4"></i> Login
                    </a>
                </div>
            </div>
        </aside>

        <!-- Mobile Header -->
        <header class="sticky top-0 z-40 flex h-16 items-center justify-between border-b border-slate-200 bg-white/80 px-6 backdrop-blur-md lg:hidden">
            <a href="<%= request.getContextPath() %>" class="text-xl font-black tracking-tight text-brand-900">
                Sarkar<span class="text-brand-500">Sathi</span>
            </a>
            <a href="<%= request.getContextPath() %>/login" class="rounded-lg bg-brand-50 p-2 text-brand-900">
                <i data-lucide="user" class="h-5 w-5"></i>
            </a>
        </header>

        <main class="min-h-screen lg:ml-64 relative">
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

                <!-- Feed View -->
                <div class="max-w-4xl mx-auto">
                    <div class="grid gap-6">
                        <% if(announcements.isEmpty()){ %>
                            <div class="flex flex-col items-center justify-center py-20 bg-white rounded-[2.5rem] border border-slate-100">
                                <i data-lucide="inbox" class="h-12 w-12 text-slate-200 mb-4"></i>
                                <h3 class="text-lg font-black text-slate-900">Silent Feed</h3>
                                <p class="text-slate-400 font-medium">There are no recent announcements to display.</p>
                            </div>
                        <% } else { for(Announcement a: announcements){ %>
                            <article class="group relative bg-white rounded-[2.5rem] p-8 border border-slate-100 shadow-xl shadow-slate-200/50 hover:shadow-2xl hover:shadow-brand-900/5 transition-all duration-300">
                                <div class="flex items-start justify-between gap-4 mb-6">
                                    <div class="flex items-center gap-4">
                                        <div class="h-12 w-12 rounded-2xl bg-brand-50 flex items-center justify-center text-brand-900 group-hover:bg-brand-900 group-hover:text-white transition-all duration-300">
                                            <i data-lucide="megaphone" class="h-6 w-6"></i>
                                        </div>
                                        <div>
                                            <h2 class="text-xl font-black text-slate-900 group-hover:text-brand-900 transition-colors"><%= esc(a.getTitle()) %></h2>
                                            <div class="flex items-center gap-2 mt-1">
                                                <span class="text-[10px] font-black uppercase tracking-widest text-slate-400">Published on <%= a.getPublishedAt()==null ? "Unspecified Date" : esc(a.getPublishedAt().format(fmt)) %></span>
                                            </div>
                                        </div>
                                    </div>
                                    <% if(a.getEventDate() != null && !a.getEventDate().isBlank()) { %>
                                        <div class="hidden sm:block text-right">
                                            <p class="text-[10px] font-black uppercase tracking-widest text-emerald-600 mb-1">Event Date</p>
                                            <div class="flex items-center gap-2 justify-end text-sm font-black text-slate-700 uppercase tracking-tighter">
                                                <i data-lucide="calendar-check" class="h-3.5 w-3.5"></i>
                                                <%= esc(a.getEventDate()) %>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>

                                <p class="text-slate-600 font-medium leading-relaxed mb-8">
                                    <%= esc(a.getContent()) %>
                                </p>

                                <div class="flex items-center justify-between pt-6 border-t border-slate-50">
                                    <button class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-brand-900 hover:gap-3 transition-all">
                                        View Full Transcript
                                        <i data-lucide="arrow-right" class="h-4 w-4"></i>
                                    </button>
                                    <div class="flex items-center gap-4 text-slate-300">
                                        <button class="hover:text-brand-500 transition-colors"><i data-lucide="share" class="h-4 w-4"></i></button>
                                        <button class="hover:text-brand-500 transition-colors"><i data-lucide="bookmark" class="h-4 w-4"></i></button>
                                    </div>
                                </div>
                            </article>
                        <% }} %>
                    </div>
                </div>
            </div>
        </main>

        <!-- Mobile Global Navigation -->
        <nav class="fixed bottom-0 left-0 right-0 z-50 border-t border-slate-200 bg-white/95 px-6 pb-safe backdrop-blur-md lg:hidden">
            <div class="flex h-16 items-center justify-between">
                <a href="<%= request.getContextPath() %>/index.jsp" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="home" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/announcements" class="flex flex-col items-center gap-1 text-brand-900">
                    <div class="bg-brand-100/50 p-2 rounded-xl">
                        <i data-lucide="megaphone" class="h-5 w-5"></i>
                    </div>
                    <span class="text-[10px] font-black uppercase tracking-tighter leading-none mt-1">News</span>
                </a>
                <a href="<%= request.getContextPath() %>/agriculture" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="leaf" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Agri</span>
                </a>
                <a href="<%= request.getContextPath() %>/budget" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="wallet" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Budget</span>
                </a>
                <a href="<%= request.getContextPath() %>/crop-advisory" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="sprout" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Advisory</span>
                </a>
            </div>
        </nav>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>
