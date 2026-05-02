<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.ApplicationDocument" %>
<%@ page import="Model.CitizenDocumentVault" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId"); String citizenName=(String)request.getAttribute("citizenName"); Integer unread=(Integer)request.getAttribute("unreadCount"); String pageError=(String)request.getAttribute("pageError"); String formError=request.getParameter("error"); List<CitizenDocumentVault> documents=(List<CitizenDocumentVault>)request.getAttribute("documents"); List<ApplicationDocument> applicationDocuments=(List<ApplicationDocument>)request.getAttribute("applicationDocuments"); DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMM d, yyyy"); if(citizenName==null)citizenName="Citizen"; if(unread==null)unread=0; if(documents==null)documents=List.of(); if(applicationDocuments==null)applicationDocuments=List.of(); String initials=citizenName.isBlank()?"C":citizenName.substring(0,1).toUpperCase(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Documents - SarkarSathi
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif;-webkit-tap-highlight-color:transparent}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav (Citizen) -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/90 backdrop-blur-lg px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Apply</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Track</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">More</span>
                </button>
            </nav>

            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>

            <aside id="sidebar" class="fixed inset-y-0 right-0 z-[70] flex w-[280px] translate-x-full flex-col border-l border-slate-200 bg-white transition-transform duration-300 lg:static lg:translate-x-0 lg:w-[240px] lg:border-l-0 lg:border-r">
                <div class="px-6 pt-6 pb-2 flex items-center justify-between">
                    <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">
                        SarkarSathi
                    </a>
                     <button onclick="toggleSidebar()" class="p-2 text-slate-500 lg:hidden rounded-full hover:bg-slate-100 transition-colors">
                        <i data-lucide="x" class="h-6 w-6"></i>
                    </button>
                </div>
                <div class="mx-5 mt-4 flex items-center gap-3 rounded-2xl bg-brand-900 px-4 py-4 text-white shadow-xl shadow-brand-900/10">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-white/10 text-white text-xs font-bold border border-white/10">
                        <%= esc(initials) %>
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-white truncate"><%= esc(citizenName) %></p>
                        <p class="text-[10px] font-bold uppercase tracking-widest text-white/50 mb-0.5">Citizen Profile</p>
                    </div>
                </div>
                <nav class="mt-8 flex-1 space-y-1.5 px-4 overflow-y-auto">
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="layout-dashboard" class="h-5 w-5 shrink-0"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="file-plus-2" class="h-5 w-5 shrink-0"></i>
                        <span>Apply for Service</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="search-check" class="h-5 w-5 shrink-0"></i>
                        <span>Track Application</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="credit-card" class="h-5 w-5 shrink-0"></i>
                        <span>Payments & Tax</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="badge-check" class="h-5 w-5 shrink-0"></i>
                        <span>Certificates</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link active flex items-center gap-3 rounded-xl px-3 py-3 text-sm">
                        <i data-lucide="folder-open" class="h-5 w-5 shrink-0"></i>
                        <span>My Documents</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-4 pb-20 lg:pb-6 pt-4">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-red-600 hover:bg-red-50">
                        <i data-lucide="log-out" class="h-5 w-5 shrink-0"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </aside>
            <div class="flex-1 flex flex-col min-h-screen w-full overflow-hidden pb-16 lg:pb-0">
                <header class="sticky top-0 z-40 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-xl px-6 py-4 sm:px-8">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900 tracking-tight">
                            Document Vault
                        </h1>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest leading-none mt-1">
                            Digital Repository
                        </p>
                    </div>
                    <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-11 w-11 items-center justify-center rounded-2xl border border-slate-100 bg-white text-slate-600 shadow-sm active:scale-95 transition-transform">
                        <i data-lucide="bell" class="h-5 w-5"></i>
                        <% if(unread>0){ %>
                            <span class="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-red-500 text-[10px] font-bold text-white ring-2 ring-white">
                                <%= unread %>
                            </span>
                        <% } %>
                    </a>
                </header>
                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-6xl mx-auto">
                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-6 rounded-2xl border-l-4 border-red-500 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700 shadow-sm animate-pulse">
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>
                    <section class="mb-10 rounded-[2.5rem] border border-slate-100 bg-white p-6 sm:p-8 shadow-sm">
                        <h2 class="text-lg font-extrabold text-slate-900 tracking-tight flex items-center gap-2 mb-6">
                            <i data-lucide="upload-cloud" class="h-5 w-5 text-brand-500"></i>
                            Upload Official Material
                        </h2>
                        <form method="post" action="<%= request.getContextPath() %>/api/upload" enctype="multipart/form-data" class="flex flex-col md:flex-row gap-4">
                            <input type="hidden" name="redirectTo" value="/citizen/documents">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">
                            <input type="hidden" name="saveToVault" value="true">
                            <div class="relative flex-1">
                                <i data-lucide="tag" class="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400"></i>
                                <input name="documentType" required placeholder="Document Type (e.g., Citizenship)" class="w-full rounded-2xl border-0 bg-slate-50 pl-11 pr-4 py-4 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none">
                            </div>
                            <div class="relative flex-1">
                                <input name="file" type="file" required accept=".pdf,.jpg,.jpeg,.png" class="w-full rounded-2xl border-0 bg-slate-50 px-4 py-4 text-xs font-bold text-slate-500 file:mr-4 file:py-1 file:px-3 file:rounded-lg file:border-0 file:text-[10px] file:font-bold file:bg-brand-900 file:text-white file:uppercase hover:file:bg-brand-800 focus:ring-2 focus:ring-brand-500 outline-none">
                            </div>
                            <button class="rounded-2xl bg-brand-900 px-8 py-4 text-sm font-bold text-white shadow-xl shadow-brand-900/10 active:scale-95 transition-transform" type="submit">
                                Store in Vault
                            </button>
                        </form>
                    </section>

                    <section class="mb-10">
                        <div class="flex items-center justify-between px-2 mb-6">
                            <h2 class="text-xl font-extrabold text-slate-900 tracking-tight">Reusable Vault</h2>
                        </div>
                        <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                        <% if(documents.isEmpty()){ %>
                            <div class="col-span-full rounded-[2.5rem] border border-dashed border-slate-200 bg-slate-50/50 p-16 text-center shadow-sm">
                                <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-slate-300 mb-4">
                                    <i data-lucide="inbox" class="h-8 w-8"></i>
                                </div>
                                <h3 class="text-base font-bold text-slate-900">Vault Empty</h3>
                                <p class="text-sm text-slate-500 mt-1">Upload files to reuse them in multiple applications.</p>
                            </div>
                        <% } else { for(CitizenDocumentVault d: documents){ String path=d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); %>
                        <article class="group rounded-[2.5rem] border border-slate-100 bg-white p-6 shadow-sm transition-all hover:shadow-xl hover:shadow-brand-900/5">
                            <div class="flex items-start justify-between mb-4">
                                <div class="h-12 w-12 flex items-center justify-center rounded-2xl bg-brand-50 text-brand-900 ring-4 ring-brand-50/50">
                                    <i data-lucide="file-text" class="h-6 w-6"></i>
                                </div>
                                <div class="text-right">
                                    <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Stored</p>
                                    <p class="text-xs font-bold text-slate-900"><%= d.getUploadedAt()==null?"—":esc(d.getUploadedAt().format(fmt)) %></p>
                                </div>
                            </div>
                            <h3 class="font-extrabold text-slate-900 mb-6 truncate"><%= esc(d.getDocumentType()) %></h3>
                            <a href="<%= esc(path) %>" target="_blank" rel="noopener" class="flex items-center justify-center gap-2 w-full rounded-2xl bg-slate-50 py-3.5 text-xs font-bold text-brand-900 transition-all hover:bg-brand-50 hover:text-brand-900 active:scale-95">
                                <i data-lucide="eye" class="h-3.5 w-3.5"></i>
                                Preview Resource
                            </a>
                        </article>
                    <% }} %>
                        </div>
                    </section>

                    <section>
                        <div class="flex items-center justify-between px-2 mb-6">
                            <h2 class="text-xl font-extrabold text-slate-900 tracking-tight">Active Application Files</h2>
                        </div>
                        <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                            <% if(applicationDocuments.isEmpty()){ %>
                                <div class="col-span-full rounded-[2.5rem] border border-dashed border-slate-200 bg-slate-50/50 p-16 text-center shadow-sm">
                                    <p class="text-sm font-bold text-slate-400 italic">No files linked to active processes</p>
                                </div>
                            <% } else { for(ApplicationDocument d: applicationDocuments){ String path=d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); %>
                                <article class="group rounded-[2.5rem] border border-slate-100 bg-white p-6 shadow-sm transition-all">
                                    <div class="flex items-start justify-between mb-4">
                                        <div class="h-12 w-12 flex items-center justify-center rounded-2xl bg-slate-50 text-slate-500">
                                            <i data-lucide="paperclip" class="h-6 w-6"></i>
                                        </div>
                                        <% if(d.isReusable()){ %>
                                            <span class="rounded-full bg-brand-50 px-3 py-1 text-[10px] font-bold text-brand-900 uppercase tracking-widest ring-1 ring-inset ring-brand-200">
                                                Linked
                                            </span>
                                        <% } %>
                                    </div>
                                    <h3 class="font-bold text-slate-900 mb-1 truncate"><%= esc(d.getDocumentType()) %></h3>
                                    <p class="text-[10px] font-bold text-slate-400 mb-6 uppercase tracking-widest"><%= d.getUploadedAt()==null?"—":esc(d.getUploadedAt().format(fmt)) %></p>
                                    <a href="<%= esc(path) %>" target="_blank" rel="noopener" class="flex items-center justify-center gap-2 w-full rounded-2xl bg-slate-50 py-3.5 text-xs font-bold text-slate-600 transition-all hover:bg-slate-100 active:scale-95">
                                        <i data-lucide="external-link" class="h-3.5 w-3.5"></i>
                                        View Process File
                                    </a>
                                </article>
                            <% }} %>
                        </div>
                    </section>
                </main>
            </div>
        </div>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebar-overlay');
                const isHidden = sidebar.classList.contains('translate-x-full');
                
                if (isHidden) {
                    sidebar.classList.remove('translate-x-full');
                    overlay.classList.remove('hidden');
                    document.body.style.overflow = 'hidden';
                } else {
                    sidebar.classList.add('translate-x-full');
                    overlay.classList.add('hidden');
                    document.body.style.overflow = '';
                }
            }
        </script>
    </body>
</html>
