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
    <body class="bg-[#fafafc] text-slate-800">
        <header class="border-b border-slate-200 bg-white px-6 lg:px-12">
            <nav class="mx-auto flex max-w-7xl items-center justify-between py-4">
                <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">
                    Sarkar<span class="text-brand-500">Sathi</span>
                </a>
                <div class="hidden items-center gap-8 text-sm font-medium text-slate-600 lg:flex">
                    <a href="<%= request.getContextPath() %>/announcements">
                        <i data-lucide="megaphone" class="h-4 w-4 shrink-0"></i>
                            <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture" class="text-brand-900 font-semibold">
                        Agriculture
                    </a>
                    <a href="<%= request.getContextPath() %>/budget">
                        Budget
                    </a>
                    <a href="<%= request.getContextPath() %>/crop-advisory">
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
                        Agriculture Notices
                    </h1>
                    <p class="mt-3 text-lg text-slate-500">
                        Government schemes, subsidies, and training programs
                    </p>
                </div>
                <div class="mb-8 flex justify-center gap-3">
                    <a href="<%= request.getContextPath() %>/agriculture" class="rounded-full <%= category==null?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-5 py-2 text-sm font-semibold">
                        All
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture?category=subsidy" class="rounded-full <%= "subsidy".equals(category)?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-5 py-2 text-sm font-semibold">
                        Subsidies
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture?category=training" class="rounded-full <%= "training".equals(category)?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-5 py-2 text-sm font-semibold">
                        Training
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture?category=scheme" class="rounded-full <%= "scheme".equals(category)?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-5 py-2 text-sm font-semibold">
                        Schemes
                    </a>
                </div>
                <div class="space-y-4">
                    <% boolean any=false; for(AgricultureNotice n:notices){ if(category!=null&&!category.isBlank()&&!category.equals(n.getCategory()))continue; any=true; %>
                    <article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                        <div class="flex items-center gap-3 mb-2">
                            <h2 class="text-lg font-bold text-slate-900">
                                <%= esc(n.getTitle()) %>
                            </h2>
                            <span class="rounded-full <%= tag(n.getCategory()) %> px-3 py-1 text-[11px] font-bold uppercase tracking-wider">
                                <%= esc(n.getCategory()) %>
                            </span>
                        </div>
                        <p class="text-sm leading-relaxed text-slate-600">
                            <%= esc(n.getContent()) %>
                        </p>
                        <p class="mt-3 text-xs text-slate-400">
                            <%= n.getPublishedAt()==null?"":esc(n.getPublishedAt().format(fmt)) %>
                        </p>
                    </article>
                <% } if(!any){ %>
                    <div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm">
                        <p class="text-slate-500">
                            No notices found
                        </p>
                    </div>
                <% } %>
            </div>
        </div>
    </main>
</body>
</html>
