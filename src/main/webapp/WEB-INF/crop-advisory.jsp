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
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <header class="border-b border-slate-200 bg-white px-6 lg:px-12">
            <nav class="mx-auto flex max-w-7xl items-center justify-between py-4">
                <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">
                    Sarkar<span class="text-brand-500">Sathi</span>
                </a>
                <div class="hidden items-center gap-8 text-sm font-medium text-slate-600 lg:flex">
                    <a href="<%= request.getContextPath() %>/announcements">
                        Announcements
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture">
                        Agriculture
                    </a>
                    <a href="<%= request.getContextPath() %>/budget">
                        Budget
                    </a>
                    <a href="<%= request.getContextPath() %>/crop-advisory" class="text-brand-900 font-semibold">
                        Crop Advisory
                    </a>
                </div>
                <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white">
                    Login
                </a>
            </nav>
        </header>
        <main class="px-6 py-12 lg:px-12">
            <div class="mx-auto max-w-5xl">
                <div class="text-center mb-8">
                    <h1 class="text-4xl font-bold text-slate-900">
                        Crop Advisory
                    </h1>
                    <p class="mt-3 text-lg text-slate-500">
                        Get crop recommendations based on your land type and season
                    </p>
                </div>
                <form method="get" action="<%= request.getContextPath() %>/crop-advisory" class="mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                    <div class="grid gap-4 md:grid-cols-3">
                        <div>
                            <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                Land Type
                            </label>
                            <select name="landType" required class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm">
                                <option value="">
                                    Choose land
                                </option>
                                <% for(String key: recommendations.keySet()){ %>
                                    <option value="<%= esc(key) %>" <%= key.equals(land)?"selected":"" %>
                                        >
                                        <%= esc(title(key)) %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                Season
                            </label>
                            <select name="season" required class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm">
                                <option value="">
                                    Choose season
                                </option>
                                <option value="spring" <%= "spring".equals(season)?"selected":"" %>
                                    >Spring
                                </option>
                                <option value="summer" <%= "summer".equals(season)?"selected":"" %>
                                    >Summer
                                </option>
                                <option value="autumn" <%= "autumn".equals(season)?"selected":"" %>
                                    >Autumn
                                </option>
                                <option value="winter" <%= "winter".equals(season)?"selected":"" %>
                                    >Winter
                                </option>
                            </select>
                        </div>
                        <div class="flex items-end">
                            <button class="w-full rounded-xl bg-brand-900 px-5 py-3 text-sm font-semibold text-white" type="submit">
                                Get Advice
                            </button>
                        </div>
                    </div>
                </form>
                <% List<String[]> crops=land==null||season==null||!recommendations.containsKey(land)?List.of():recommendations.get(land).getOrDefault(season,List.of()); if(land!=null&&season!=null){ %>
                    <section>
                        <h2 class="mb-4 text-xl font-bold text-slate-900">
                            <%= esc(title(season)) %>
                            crops for
                            <%= esc(title(land)) %>
                        </h2>
                        <div class="grid gap-4 md:grid-cols-3">
                            <% if(crops.isEmpty()){ %>
                                <div class="col-span-3 rounded-2xl border border-slate-100 bg-white p-12 text-center text-slate-500">
                                    No recommendations available
                                </div>
                            <% } else { for(String[] c:crops){ %>
                                <article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                                    <h3 class="text-lg font-bold text-slate-900">
                                        <%= esc(c[0]) %>
                                    </h3>
                                    <p class="mt-2 text-sm text-slate-600">
                                        <%= esc(c[1]) %>
                                    </p>
                                    <p class="mt-4 text-xs font-semibold text-brand-900">
                                        Growing period:
                                        <%= esc(c[2]) %>
                                    </p>
                                </article>
                            <% }} %>
                        </div>
                    </section>
                <% } %>
            </div>
        </main>
    </body>
</html>
