<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.AgricultureNotice" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} private String tag(String category){if("subsidy".equals(category))return"bg-green-50 text-green-700";if("training".equals(category))return"bg-purple-50 text-purple-700";if("scheme".equals(category))return"bg-blue-50 text-blue-700";return"bg-slate-50 text-slate-600";} %>
<% List<AgricultureNotice> notices=(List<AgricultureNotice>)request.getAttribute("notices"); String category=request.getParameter("category"); DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMMM d, yyyy"); if(notices==null)notices=List.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Agriculture Notices - SarkarSathi
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
        <%@ include file="../includes/sidebar-public.jsp" %>


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
                    <div class="flex items-center gap-3 text-brand-500 mb-2">
                        <i data-lucide="leaf" class="h-6 w-6"></i>
                        <span class="text-xs font-black uppercase tracking-widest">Public Service</span>
                    </div>
                    <h1 class="text-4xl lg:text-5xl font-black text-slate-900 tracking-tight leading-tight">Agriculture Notices</h1>
                    <p class="mt-4 text-slate-500 font-medium text-lg leading-relaxed max-w-2xl">
                        Stay informed about government schemes, agricultural subsidies, and training programs designed to empower our farming community.
                    </p>
                </div>

                <!-- Filter View -->
                <div class="max-w-4xl mx-auto mb-12">
                    <div class="bg-white/50 p-1.5 rounded-2xl border border-slate-200 inline-flex gap-1">
                        <a href="<%= request.getContextPath() %>/agriculture" class="px-6 py-2.5 text-xs font-black uppercase tracking-widest rounded-xl transition-all <%= category==null?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"text-slate-500 hover:bg-slate-100" %>">
                            ALL
                        </a>
                        <a href="<%= request.getContextPath() %>/agriculture?category=subsidy" class="px-6 py-2.5 text-xs font-black uppercase tracking-widest rounded-xl transition-all <%= "subsidy".equals(category)?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"text-slate-500 hover:bg-slate-100" %>">
                            Subsidies
                        </a>
                        <a href="<%= request.getContextPath() %>/agriculture?category=training" class="px-6 py-2.5 text-xs font-black uppercase tracking-widest rounded-xl transition-all <%= "training".equals(category)?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"text-slate-500 hover:bg-slate-100" %>">
                            Training
                        </a>
                        <a href="<%= request.getContextPath() %>/agriculture?category=scheme" class="px-6 py-2.5 text-xs font-black uppercase tracking-widest rounded-xl transition-all <%= "scheme".equals(category)?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"text-slate-500 hover:bg-slate-100" %>">
                            Schemes
                        </a>
                    </div>
                </div>

                <!-- Grid of Notices -->
                <div class="max-w-4xl mx-auto">
                    <div class="grid gap-6">
                        <% 
                        boolean any = false; 
                        for(AgricultureNotice n : notices) { 
                            if(category != null && !category.isBlank() && !category.equals(n.getCategory())) continue; 
                            any = true; 
                        %>
                        <article class="group relative bg-white rounded-[2rem] p-8 border border-slate-100 shadow-xl shadow-slate-200/50 hover:shadow-2xl hover:shadow-brand-900/5 transition-all duration-300">
                            <div class="flex flex-wrap items-start justify-between gap-4 mb-6">
                                <div class="flex items-center gap-3">
                                    <div class="h-12 w-12 rounded-2xl bg-brand-50 flex items-center justify-center text-brand-900 group-hover:bg-brand-900 group-hover:text-white transition-colors duration-300">
                                        <i data-lucide="<%= "subsidy".equals(n.getCategory()) ? "banknote" : ("training".equals(n.getCategory()) ? "users" : "scrollText") %>" class="h-6 w-6"></i>
                                    </div>
                                    <div>
                                        <h2 class="text-xl font-black text-slate-900 group-hover:text-brand-900 transition-colors"><%= esc(n.getTitle()) %></h2>
                                        <div class="flex items-center gap-2 mt-1">
                                            <span class="text-[10px] font-black uppercase tracking-widest text-slate-400"><%= n.getPublishedAt()==null?"UNDEFINED":esc(n.getPublishedAt().format(fmt)) %></span>
                                            <span class="h-1 w-1 rounded-full bg-slate-200"></span>
                                            <span class="text-[10px] font-black uppercase tracking-widest <%= tag(n.getCategory()) %>"><%= esc(n.getCategory()) %></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <p class="text-slate-600 font-medium leading-relaxed mb-8">
                                <%= esc(n.getContent()) %>
                            </p>

                            <div class="flex items-center justify-between">
                                <button class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-brand-900 hover:gap-3 transition-all">
                                    Read Detailed notice
                                    <i data-lucide="arrow-right" class="h-4 w-4"></i>
                                </button>
                                <div class="h-10 w-10 rounded-full border border-slate-100 flex items-center justify-center text-slate-300 group-hover:border-brand-100 group-hover:text-brand-500 transition-all">
                                    <i data-lucide="share-2" class="h-4 w-4"></i>
                                </div>
                            </div>
                        </article>
                        <% } 
                        if(!any) { %>
                        <div class="flex flex-col items-center justify-center py-24 bg-white rounded-[3rem] border border-dashed border-slate-200">
                            <div class="h-20 w-20 rounded-full bg-slate-50 flex items-center justify-center text-slate-300 mb-6">
                                <i data-lucide="search-x" class="h-10 w-10"></i>
                            </div>
                            <h3 class="text-xl font-black text-slate-900 mb-2 text-center">No Active Listings</h3>
                            <p class="text-slate-400 font-medium text-center">There are no notices matching the selected criteria.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Footer Graphic -->
            <div class="max-w-4xl mx-auto px-6 pb-20 mt-12">
                <div class="bg-brand-900 rounded-[2rem] p-8 lg:p-12 overflow-hidden relative">
                    <div class="relative z-10 flex flex-col lg:flex-row lg:items-center justify-between gap-8">
                        <div>
                            <h2 class="text-2xl font-black text-white mb-2">Need Direct Assistance?</h2>
                            <p class="text-blue-100/70 font-medium ">Contact the Agriculture Development Office at Ward No. 4</p>
                        </div>
                        <a href="tel:123" class="inline-flex items-center gap-3 bg-white text-brand-900 px-8 py-4 rounded-2xl font-black text-sm uppercase tracking-widest hover:bg-blue-50 transition-all">
                            <i data-lucide="phone-call" class="h-5 w-5"></i>
                            Call Support
                        </a>
                    </div>
                    <div class="absolute -right-10 -bottom-10 h-64 w-64 bg-white/5 rounded-full blur-3xl text-white"></div>
                </div>
            </div>
        </main>

        <!-- Mobile Global Navigation -->
        <nav class="fixed bottom-0 left-0 right-0 z-50 border-t border-slate-200 bg-white/95 px-6 pb-safe backdrop-blur-md lg:hidden">
            <div class="flex h-16 items-center justify-between">
                <a href="<%= request.getContextPath() %>/" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="home" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/announcements" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="megaphone" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">News</span>
                </a>
                <a href="<%= request.getContextPath() %>/agriculture" class="flex flex-col items-center gap-1 text-brand-900">
                    <div class="bg-brand-100/50 p-2 rounded-xl">
                        <i data-lucide="leaf" class="h-5 w-5"></i>
                    </div>
                    <span class="text-[10px] font-black uppercase tracking-tighter leading-none mt-1">Agri</span>
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
