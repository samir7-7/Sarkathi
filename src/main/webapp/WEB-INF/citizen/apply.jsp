<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.CitizenDocumentVault" %>
<%@ page import="Model.ServiceType" %>
<%@ page import="Model.Ward" %>
<%@ page import="java.util.List" %>
<%! 
    private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} 
%>
<% 
    Integer citizenId = (Integer)request.getAttribute("citizenId"); 
    String citizenName = (String)request.getAttribute("citizenName"); 
    String pageError = (String)request.getAttribute("pageError"); 
    String formError = request.getParameter("error"); 
    Integer unread = (Integer)request.getAttribute("unreadCount"); 
    List<ServiceType> serviceTypes = (List<ServiceType>)request.getAttribute("serviceTypes"); 
    List<Ward> wards = (List<Ward>)request.getAttribute("wards"); 
    List<CitizenDocumentVault> documents = (List<CitizenDocumentVault>)request.getAttribute("documents"); 
    
    if(citizenName == null) citizenName = "Citizen"; 
    if(unread == null) unread = 0; 
    if(serviceTypes == null) serviceTypes = List.of(); 
    if(wards == null) wards = List.of(); 
    if(documents == null) documents = List.of(); 
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>New Application - SarkarSathi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config={
                theme:{
                    extend:{
                        fontFamily:{sans:['Outfit','sans-serif']},
                        colors:{
                            brand:{
                                50:'#f0f5fc',
                                100:'#e1eafa',
                                500:'#3b82f6',
                                800:'#154a91',
                                900:'#0b3d86'
                            }
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .glass-panel {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 700; }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#f8fafc] text-slate-900 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Portal</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="flex flex-col items-center justify-center gap-1 text-brand-900">
                    <i data-lucide="plus-circle" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Genesis</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Track</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Menu</span>
                </button>
            </nav>

            <!-- Desktop Sidebar -->
            <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-72 -translate-x-full border-r border-slate-100 bg-white transition-transform duration-300 lg:static lg:translate-x-0">
                <div class="flex h-full flex-col p-6">
                    <div class="flex items-center justify-between">
                        <a href="<%= request.getContextPath() %>/" class="text-2xl font-black text-brand-900 italic tracking-tighter">SarkarSathi</a>
                        <button onclick="toggleSidebar()" class="lg:hidden h-10 w-10 flex items-center justify-center rounded-xl bg-slate-50 text-slate-400">
                            <i data-lucide="x" class="h-5 w-5"></i>
                        </button>
                    </div>

                    <div class="mt-10 mb-6 px-4 py-8 rounded-[2rem] bg-brand-900 text-white shadow-2xl shadow-brand-900/20 relative overflow-hidden group">
                        <div class="absolute top-0 right-0 h-24 w-24 bg-white/5 rounded-bl-[3rem] -mr-8 -mt-8 rotate-12 group-hover:bg-white/10 transition-colors"></div>
                        <p class="text-[10px] font-black uppercase tracking-[0.3em] text-blue-300/80 mb-2">Authenticated Citizen</p>
                        <h4 class="text-xl font-black tracking-tight truncate"><%= esc(citizenName) %></h4>
                        <p class="text-[9px] font-black uppercase tracking-widest text-slate-400 mt-1 italic">Verified Unit #<%= citizenId %></p>
                    </div>

                    <nav class="flex-1 space-y-2">
                        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                            <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                            <span>Overview</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link active group flex items-center gap-4 px-4 py-4 rounded-2xl text-[11px] font-black uppercase tracking-widest">
                            <i data-lucide="file-plus" class="h-5 w-5"></i>
                            <span>Apply for Service</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                            <i data-lucide="search-check" class="h-5 w-5"></i>
                            <span>Registry Track</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link group flex items-center gap-4 px-4 py-4 rounded-2xl text-slate-500 font-bold uppercase tracking-widest text-[11px]">
                            <i data-lucide="award" class="h-5 w-5"></i>
                            <span>Issued Files</span>
                        </a>
                    </nav>

                    <div class="pt-6 border-t border-slate-50">
                        <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-4 px-4 py-4 rounded-2xl text-rose-500 font-black uppercase tracking-widest text-[11px] hover:bg-rose-50 transition-colors">
                            <i data-lucide="log-out" class="h-5 w-5"></i>
                            <span>Terminate Session</span>
                        </a>
                    </div>
                </div>
            </aside>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <!-- Header -->
                <header class="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-slate-100 px-6 py-6 lg:px-12">
                    <div class="flex items-center justify-between max-w-7xl mx-auto">
                        <div>
                            <h1 class="text-2xl font-black text-slate-900 tracking-tighter uppercase italic">Genesis.</h1>
                            <p class="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 mt-1">Initiate New Resource Protocol</p>
                        </div>
                        
                        <div class="flex items-center gap-4">
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="h-12 w-12 flex items-center justify-center rounded-2xl border border-slate-100 text-slate-400 hover:text-brand-900 transition-colors">
                                <i data-lucide="chevron-left" class="h-5 w-5"></i>
                            </a>
                            <div class="h-12 w-12 rounded-2xl bg-brand-50 flex items-center justify-center text-brand-900">
                                <i data-lucide="fingerprint" class="h-6 w-6"></i>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 p-6 lg:p-12 pb-32">
                    <div class="max-w-4xl mx-auto">
                        <% if(pageError!=null || formError!=null){ %>
                            <div class="mb-10 bg-rose-50 text-rose-600 p-6 rounded-[2rem] border border-rose-100 flex items-center gap-4 animate-fade-in-up">
                                <i data-lucide="alert-triangle" class="h-6 w-6"></i>
                                <p class="text-xs font-black uppercase tracking-widest"><%= esc(pageError!=null?pageError:formError) %></p>
                            </div>
                        <% } %>

                        <form method="post" action="<%= request.getContextPath() %>/api/applications" class="space-y-12 animate-fade-in-up">
                            <input type="hidden" name="redirectTo" value="/citizen/tracking">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">

                            <section class="bg-white rounded-[4rem] border border-slate-100 p-10 lg:p-14 shadow-2xl shadow-slate-200/50 relative overflow-hidden">
                                <div class="absolute top-0 right-0 h-40 w-40 bg-brand-50 rounded-bl-[5rem] -mr-10 -mt-10 opacity-50"></div>
                                
                                <div class="relative z-10">
                                    <h3 class="text-2xl font-black text-brand-900 tracking-tighter mb-10 italic">Process Definition.</h3>
                                    
                                    <div class="grid sm:grid-cols-2 gap-8 mb-10">
                                        <div class="space-y-4">
                                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 ml-2">Resource Type</label>
                                            <div class="relative group">
                                                <select name="serviceTypeId" required class="w-full bg-slate-50 rounded-[1.5rem] px-6 py-5 text-sm font-black uppercase tracking-widest outline-none border-2 border-transparent focus:border-brand-500/20 focus:bg-white transition-all appearance-none cursor-pointer">
                                                    <% for(ServiceType s: serviceTypes){ %>
                                                        <option value="<%= s.getServiceTypeId() %>">
                                                            <%= esc(s.getServiceName()) %> — RS. <%= esc(s.getBaseFee()) %>
                                                        </option>
                                                    <% } %>
                                                </select>
                                                <i data-lucide="chevron-down" class="absolute right-6 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-400 pointer-events-none"></i>
                                            </div>
                                        </div>

                                        <div class="space-y-4">
                                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 ml-2">Jurisdiction</label>
                                            <div class="relative group">
                                                <select name="wardId" required class="w-full bg-slate-50 rounded-[1.5rem] px-6 py-5 text-sm font-black uppercase tracking-widest outline-none border-2 border-transparent focus:border-brand-500/20 focus:bg-white transition-all appearance-none cursor-pointer">
                                                    <% for(Ward w: wards){ %>
                                                        <option value="<%= w.getWardId() %>">
                                                            WARD #<%= w.getWardNumber() %> — <%= esc(w.getMunicipalityName()) %>
                                                        </option>
                                                    <% } %>
                                                </select>
                                                <i data-lucide="map-pin" class="absolute right-6 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-400 pointer-events-none"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="space-y-4">
                                        <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 ml-2">Digital Declaration / Form Data</label>
                                        <textarea name="formData" rows="8" required 
                                                  placeholder="Detail the parameters of your request. Include all necessary qualitative data for administrative review..." 
                                                  class="w-full bg-slate-50 rounded-[2.5rem] px-8 py-8 text-sm font-bold text-slate-700 outline-none border-2 border-transparent focus:border-brand-500/20 focus:bg-white transition-all resize-none leading-relaxed"></textarea>
                                    </div>
                                </div>
                            </section>

                            <section class="bg-white rounded-[4rem] border border-slate-100 p-10 lg:p-14 shadow-2xl shadow-slate-200/50">
                                <h3 class="text-2xl font-black text-brand-900 tracking-tighter mb-4 italic">Encrypted Files.</h3>
                                <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-10">Select binary assets from your vault</p>
                                
                                <% if(documents.isEmpty()){ %>
                                    <div class="py-16 text-center bg-slate-50 rounded-[3rem] border border-dashed border-slate-200">
                                        <i data-lucide="cloud-off" class="h-12 w-12 text-slate-200 mx-auto mb-6"></i>
                                        <p class="text-xs font-black uppercase tracking-widest text-slate-300 italic mb-4">No Vault Assets Detected</p>
                                        <a href="<%= request.getContextPath() %>/citizen/documents" class="text-brand-900 font-bold text-[10px] uppercase tracking-widest underline decoration-2 underline-offset-4">Sync Vault Metadata</a>
                                    </div>
                                <% } else { %>
                                    <div class="grid sm:grid-cols-2 gap-4">
                                        <% for(CitizenDocumentVault d: documents){ %>
                                            <label class="relative group cursor-pointer">
                                                <input type="checkbox" name="reuseDocumentIds" value="<%= d.getVaultDocId() %>" class="peer sr-only">
                                                <div class="p-6 rounded-3xl border-2 border-slate-50 bg-slate-50 group-hover:bg-white transition-all peer-checked:border-brand-900 peer-checked:bg-brand-50/50">
                                                    <div class="flex items-center justify-between">
                                                        <div class="flex items-center gap-4">
                                                            <div class="h-10 w-10 rounded-xl bg-white text-slate-400 peer-checked:text-brand-900 flex items-center justify-center">
                                                                <i data-lucide="file-text" class="h-5 w-5"></i>
                                                            </div>
                                                            <span class="text-[11px] font-black uppercase tracking-widest text-slate-700"><%= esc(d.getDocumentType()) %></span>
                                                        </div>
                                                        <div class="h-6 w-6 rounded-full border-2 border-slate-200 peer-checked:border-brand-900 peer-checked:bg-brand-900 flex items-center justify-center transition-all">
                                                            <i data-lucide="check" class="h-3 w-3 text-white"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </label>
                                        <% } %>
                                    </div>
                                <% } %>
                            </section>

                            <div class="pt-6">
                                <button type="submit" class="w-full bg-brand-900 text-white rounded-[2.5rem] py-8 text-sm font-black uppercase tracking-[0.3em] shadow-2xl shadow-brand-900/30 active:scale-[0.98] transition-all relative overflow-hidden group">
                                    <span class="relative z-10 flex items-center justify-center gap-4">
                                        Transmit Official Request
                                        <i data-lucide="send" class="h-5 w-5 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform"></i>
                                    </span>
                                    <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-blue-800 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                                </button>
                                <p class="text-center text-[9px] font-black uppercase tracking-[0.4em] text-slate-300 mt-8">Secure End-to-End Administrative Handshake</p>
                            </div>
                        </form>
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