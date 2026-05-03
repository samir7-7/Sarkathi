<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.ApplicationDocument" %>
<%@ page import="Model.CitizenDocumentVault" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% 
    Integer citizenId = (Integer)request.getAttribute("citizenId"); 
    String citizenName = (String)request.getAttribute("citizenName"); 
    Integer unread = (Integer)request.getAttribute("unreadCount"); 
    String pageError = (String)request.getAttribute("pageError"); 
    String formError = request.getParameter("error"); 
    List<CitizenDocumentVault> documents = (List<CitizenDocumentVault>)request.getAttribute("documents"); 
    List<ApplicationDocument> applicationDocuments = (List<ApplicationDocument>)request.getAttribute("applicationDocuments"); 
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy"); 
    
    if(citizenName == null) citizenName = "Citizen";
    if(unread == null) unread = 0;
    if(documents == null) documents = List.of();
    if(applicationDocuments == null) applicationDocuments = List.of();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Documents - SarkarSathi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config={
                theme:{
                    extend:{
                        fontFamily:{sans:['Outfit','sans-serif']},
                        colors:{
                            brand:{
                                50:'#f0f5fc',
                                500:'#3b82f6',
                                900:'#0b3d86'
                            }
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 600; }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Apply</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Track</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/notifications" class="flex flex-col items-center justify-center gap-1 text-slate-500 relative">
                    <i data-lucide="bell" class="h-5 w-5"></i>
                    <% if(unread>0){ %><span class="absolute top-0 right-1 h-2 w-2 rounded-full bg-red-500"></span><% } %>
                    <span class="text-[10px] font-medium">Inbox</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Menu</span>
                </button>
            </nav>

            <!-- Sidebar -->
            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            
            <%@ include file="../includes/sidebar-citizen.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">

                <!-- Header -->
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200 bg-white px-8 py-4">
                    <h1 class="text-xl font-bold text-slate-900 tracking-tight">Document Vault</h1>
                    <div class="flex items-center gap-4">
                         <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2 text-slate-500 hover:text-brand-900 border border-slate-100 rounded-xl transition-colors">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %><span class="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span><% } %>
                        </a>
                    </div>
                </header>

                <div class="lg:hidden px-5 pt-6 pb-2">
                    <h1 class="text-2xl font-extrabold text-slate-900 tracking-tight">Documents</h1>
                    <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest mt-1">Personal Repository</p>
                </div>

                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-7xl mx-auto pb-32 lg:pb-8">
                    <% if(pageError != null || formError != null){ %>
                        <div class="mb-6 p-4 bg-red-50 border border-red-100 rounded-2xl text-red-700 text-sm font-medium">
                            <%= esc(pageError != null ? pageError : formError) %>
                        </div>
                    <% } %>

                    <!-- Upload Form -->
                    <section class="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm mb-8">
                        <div class="flex items-center gap-3 mb-6">
                            <div class="h-10 w-10 bg-brand-50 text-brand-900 rounded-xl flex items-center justify-center">
                                <i data-lucide="upload-cloud" class="h-5 w-5"></i>
                            </div>
                            <h3 class="text-lg font-bold text-slate-900">Upload to Vault</h3>
                        </div>
                        <form method="post" action="<%= request.getContextPath() %>/api/upload" enctype="multipart/form-data" class="grid gap-4 md:grid-cols-3">
                            <input type="hidden" name="redirectTo" value="/citizen/documents">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">
                            <input type="hidden" name="saveToVault" value="true">
                            <div class="md:col-span-1">
                                <input name="documentType" required placeholder="Document Type (e.g. Citizenship)" class="w-full px-4 py-3 bg-slate-50 border-0 rounded-2xl text-sm font-medium focus:ring-2 focus:ring-brand-900 outline-none">
                            </div>
                            <div class="md:col-span-1">
                                <input name="file" type="file" required accept=".pdf,.jpg,.jpeg,.png" class="w-full px-4 py-2.5 bg-slate-50 border-0 rounded-2xl text-xs font-bold text-slate-500 file:mr-4 file:py-1 file:px-3 file:rounded-lg file:border-0 file:text-[10px] file:font-bold file:bg-brand-900 file:text-white file:uppercase">
                            </div>
                            <button type="submit" class="md:col-span-1 py-3 bg-brand-900 text-white rounded-2xl text-xs font-bold uppercase tracking-widest hover:bg-brand-800 transition-colors">Store Securely</button>
                        </form>
                    </section>

                    <!-- Documents Grid -->
                    <div class="space-y-8">
                        <section>
                            <h3 class="text-base font-bold text-slate-900 px-2 mb-4 uppercase tracking-wider text-[11px] text-slate-400">Reusable Vault Files</h3>
                            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                                <% if(documents.isEmpty()){ %>
                                    <div class="sm:col-span-2 lg:col-span-3 py-12 text-center bg-white rounded-3xl border border-dashed border-slate-200 text-slate-400 ">No files in vault</div>
                                <% } else { for(CitizenDocumentVault d : documents){ 
                                    String path = d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); 
                                %>
                                    <article class="bg-white p-5 rounded-3xl border border-slate-200 flex flex-col items-start gap-4 shadow-sm hover:shadow-md transition-shadow">
                                        <div class="h-10 w-10 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center">
                                            <i data-lucide="file-text" class="h-5 w-5"></i>
                                        </div>
                                        <div class="w-full overflow-hidden">
                                            <h4 class="text-sm font-bold text-slate-900 truncate uppercase tracking-tight mb-1"><%= esc(d.getDocumentType()) %></h4>
                                            <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest leading-none">Stored <%= d.getUploadedAt()==null?"—":esc(d.getUploadedAt().format(fmt)) %></p>
                                        </div>
                                        <a href="<%= esc(path) %>" target="_blank" class="w-full py-2.5 bg-slate-50 text-slate-600 rounded-xl text-[11px] font-bold uppercase text-center hover:bg-slate-100 transition-colors">View File</a>
                                    </article>
                                <% }} %>
                            </div>
                        </section>

                        <section>
                            <h3 class="text-base font-bold text-slate-900 px-2 mb-4 uppercase tracking-wider text-[11px] text-slate-400">Application Attachments</h3>
                            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                                <% if(applicationDocuments.isEmpty()){ %>
                                    <div class="sm:col-span-2 lg:col-span-3 py-12 text-center bg-white rounded-3xl border border-dashed border-slate-200 text-slate-400 ">No linked documents</div>
                                <% } else { for(ApplicationDocument d : applicationDocuments){ 
                                    String path = d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); 
                                %>
                                    <article class="bg-white p-5 rounded-3xl border border-slate-200 flex items-center gap-4 shadow-sm">
                                        <div class="h-10 w-10 bg-slate-50 text-slate-400 rounded-xl flex items-center justify-center flex-shrink-0">
                                            <i data-lucide="paperclip" class="h-5 w-5"></i>
                                        </div>
                                        <div class="flex-1 overflow-hidden">
                                            <h4 class="text-[11px] font-bold text-slate-900 truncate uppercase mb-0.5"><%= esc(d.getDocumentType()) %></h4>
                                            <p class="text-[9px] text-slate-400 font-bold uppercase opacity-70">App #<%= d.getApplicationId() %></p>
                                        </div>
                                        <a href="<%= esc(path) %>" target="_blank" class="p-2 text-brand-900 hover:bg-brand-50 rounded-lg transition-colors"><i data-lucide="external-link" class="h-4 w-4"></i></a>
                                    </article>
                                <% }} %>
                            </div>
                        </section>
                    </div>
                </main>
            </div>
        </div>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                if (sidebar) sidebar.classList.toggle('-translate-x-full');
            }
            lucide.createIcons();
        </script>
    </body>
</html>