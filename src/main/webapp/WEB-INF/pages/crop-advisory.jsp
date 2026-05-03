<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} private String title(String value){if(value==null||value.isBlank())return "";return value.substring(0,1).toUpperCase()+value.substring(1);} %>
<% Map<String, Map<String, List<String[]>>> recommendations=(Map<String, Map<String, List<String[]>>>)request.getAttribute("recommendations"); String land=request.getParameter("landType"); String season=request.getParameter("season"); if(recommendations==null)recommendations=Map.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Crop Advisory - SarkarSathi
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
                <div class="max-w-5xl mx-auto mb-10 text-center lg:text-left">
                    <div class="flex items-center justify-center lg:justify-start gap-3 text-brand-500 mb-2">
                        <i data-lucide="sprout" class="h-6 w-6"></i>
                        <span class="text-xs font-black uppercase tracking-widest text-center">Agricultural Intelligence</span>
                    </div>
                    <h1 class="text-4xl lg:text-5xl font-black text-slate-900 tracking-tight leading-tight">Crop Advisory</h1>
                    <p class="mt-4 text-slate-500 font-medium text-lg leading-relaxed max-w-2xl mx-auto lg:mx-0">
                        Intelligent cultivation planning. Select your terrain and seasonal parameters to receive scientifically backed crop recommendations.
                    </p>
                </div>

                <!-- Input form -->
                <div class="max-w-5xl mx-auto mb-12">
                    <form method="get" action="<%= request.getContextPath() %>/crop-advisory" class="bg-white rounded-[2.5rem] p-8 sm:p-10 shadow-2xl shadow-slate-200/50 border border-slate-100">
                        <div class="grid gap-8 md:grid-cols-3">
                            <div class="space-y-2">
                                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 ml-1">Terrestrial Profile</label>
                                <div class="relative group">
                                    <i data-lucide="map" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 pointer-events-none group-focus-within:text-brand-500 transition-colors"></i>
                                    <select name="landType" required class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 appearance-none transition-all outline-none">
                                        <option value="">Select Land Type</option>
                                        <% for(String key: recommendations.keySet()){ %>
                                            <option value="<%= esc(key) %>" <%= key.equals(land)?"selected":"" %>><%= esc(title(key)) %></option>
                                        <% } %>
                                    </select>
                                    <i data-lucide="chevron-down" class="absolute right-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none"></i>
                                </div>
                            </div>

                            <div class="space-y-2">
                                <label class="block text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 ml-1">Seasonal Cycle</label>
                                <div class="relative group">
                                    <i data-lucide="calendar" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 pointer-events-none group-focus-within:text-brand-500 transition-colors"></i>
                                    <select name="season" required class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 appearance-none transition-all outline-none">
                                        <option value="">Select Season</option>
                                        <option value="spring" <%= "spring".equals(season)?"selected":"" %>>Spring Cycle</option>
                                        <option value="summer" <%= "summer".equals(season)?"selected":"" %>>Summer Cycle</option>
                                        <option value="autumn" <%= "autumn".equals(season)?"selected":"" %>>Autumn Cycle</option>
                                        <option value="winter" <%= "winter".equals(season)?"selected":"" %>>Winter Cycle</option>
                                    </select>
                                    <i data-lucide="chevron-down" class="absolute right-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none"></i>
                                </div>
                            </div>

                            <div class="flex items-end">
                                <button class="w-full rounded-2xl bg-brand-900 py-4 text-sm font-black text-white shadow-xl shadow-brand-900/20 active:scale-[0.98] transition-all hover:bg-slate-900 flex items-center justify-center gap-2" type="submit">
                                    <i data-lucide="sparkles" class="h-4 w-4"></i>
                                    Filter Advice
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Results -->
                <% 
                List<String[]> crops = land==null||season==null||!recommendations.containsKey(land)?List.of():recommendations.get(land).getOrDefault(season,List.of()); 
                if(land!=null && season!=null) { 
                %>
                <section class="max-w-5xl mx-auto">
                    <div class="flex items-center gap-3 mb-8">
                        <div class="h-8 w-1px bg-brand-200"></div>
                        <h2 class="text-sm font-black uppercase tracking-[0.3em] text-slate-400">
                            Available Recommendations for <span class="text-brand-900"><%= esc(title(season)) %> &bull; <%= esc(title(land)) %></span>
                        </h2>
                    </div>

                    <% if(crops.isEmpty()) { %>
                        <div class="flex flex-col items-center justify-center py-24 bg-white rounded-[3rem] border border-dashed border-slate-200">
                            <i data-lucide="file-warning" class="h-10 w-10 text-slate-200 mb-4"></i>
                            <h3 class="text-lg font-black text-slate-900 mb-1">No Data Records</h3>
                            <p class="text-slate-400 font-medium">No scientific recommendations found for this specific criterion.</p>
                        </div>
                    <% } else { %>
                        <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
                            <% for(String[] c : crops) { %>
                            <article class="group relative bg-white rounded-[2.5rem] p-8 border border-slate-100 shadow-xl shadow-slate-200/50 hover:shadow-2xl hover:shadow-brand-900/5 transition-all duration-300 overflow-hidden">
                                <div class="absolute top-0 right-0 w-32 h-32 bg-brand-50/50 rounded-bl-[4rem] group-hover:bg-brand-900 group-hover:text-white transition-all duration-500 -mr-16 -mt-16 flex items-end justify-start p-6">
                                    <i data-lucide="wheat" class="h-6 w-6 opacity-0 group-hover:opacity-100 transition-opacity"></i>
                                </div>

                                <div class="relative z-10">
                                    <h3 class="text-2xl font-black text-slate-900 mb-3 group-hover:text-brand-900 transition-colors"><%= esc(c[0]) %></h3>
                                    <p class="text-slate-600 font-medium leading-relaxed mb-8 line-clamp-3">
                                        <%= esc(c[1]) %>
                                    </p>
                                    
                                    <div class="pt-6 border-t border-slate-50 flex items-center justify-between">
                                        <div>
                                            <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1">Duration</p>
                                            <p class="text-xs font-black text-brand-900 uppercase tracking-widest"><%= esc(c[2]) %></p>
                                        </div>
                                        <div class="h-10 w-10 rounded-full border border-slate-100 flex items-center justify-center text-slate-300 group-hover:bg-brand-50 group-hover:text-brand-900 group-hover:border-transparent transition-all">
                                            <i data-lucide="plus" class="h-4 w-4"></i>
                                        </div>
                                    </div>
                                </div>
                            </article>
                            <% } %>
                        </div>
                    <% } %>
                </section>
                <% } %>
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
                <a href="<%= request.getContextPath() %>/agriculture" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="leaf" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Agri</span>
                </a>
                <a href="<%= request.getContextPath() %>/budget" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="wallet" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Budget</span>
                </a>
                <a href="<%= request.getContextPath() %>/crop-advisory" class="flex flex-col items-center gap-1 text-brand-900">
                    <div class="bg-brand-100/50 p-2 rounded-xl">
                        <i data-lucide="sprout" class="h-5 w-5"></i>
                    </div>
                    <span class="text-[10px] font-black uppercase tracking-tighter leading-none mt-1">Advisory</span>
                </a>
            </div>
        </nav>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>
