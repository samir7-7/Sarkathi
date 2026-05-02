<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="Model.ApplicationDocument" %>
<%@ page import="Model.Citizen" %>
<%@ page import="Model.CitizenDocumentVault" %>
<%@ page import="Model.ServiceType" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%! private String esc(Object value) { if (value == null) return ""; return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;"); } private String badgeClass(String status) { if ("approved".equals(status)) return "bg-green-50 text-green-700"; if ("rejected".equals(status)) return "bg-red-50 text-red-600"; if ("review".equals(status)) return "bg-amber-50 text-amber-700"; return "bg-blue-50 text-blue-700"; } private String label(String status) { if ("review".equals(status)) return "Under Review"; if (status == null || status.isBlank()) return "Submitted"; return status.substring(0,1).toUpperCase()+status.substring(1); } %>
<% Integer adminId=(Integer)request.getAttribute("adminId"); String adminName=(String)request.getAttribute("adminName"); String adminRole=(String)request.getAttribute("adminRole"); String pageError=(String)request.getAttribute("pageError"); String formError=request.getParameter("error"); String filter=request.getParameter("status"); List<Application> applications=(List<Application>)request.getAttribute("applications"); Map<Integer,Citizen> citizensById=(Map<Integer,Citizen>)request.getAttribute("citizensById"); Map<Integer,ServiceType> servicesById=(Map<Integer,ServiceType>)request.getAttribute("servicesById"); Map<Integer,List<ApplicationDocument>> docsByApp=(Map<Integer,List<ApplicationDocument>>)request.getAttribute("documentsByApplicationId"); Map<Integer,List<CitizenDocumentVault>> vaultDocsByCitizen=(Map<Integer,List<CitizenDocumentVault>>)request.getAttribute("vaultDocumentsByCitizenId"); DateTimeFormatter dateFormatter=DateTimeFormatter.ofPattern("MMM d, yyyy"); if(adminName==null)adminName="Admin"; if(adminRole==null)adminRole="admin"; if(applications==null)applications=List.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Review Applications - SarkarSathi Admin
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',500:'#3b82f6',900:'#0b3d86'}}}}}
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
            <!-- Mobile Bottom Nav (Admin) -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/90 backdrop-blur-lg px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/applications" class="flex flex-col items-center justify-center gap-1 text-brand-900 transition-all">
                    <i data-lucide="clipboard-list" class="h-5 w-5"></i>
                    <span class="text-[10px] font-bold">Review</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/announcements" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="megaphone" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Public</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Menu</span>
                </button>
            </nav>

            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>

            <aside id="sidebar" class="fixed inset-y-0 right-0 z-[70] flex w-[280px] translate-x-full flex-col border-l border-slate-200 bg-white transition-transform duration-300 lg:static lg:translate-x-0 lg:w-[240px] lg:border-l-0 lg:border-r">
                <div class="px-6 pt-6 pb-2 flex items-center justify-between">
                    <div class="flex items-center gap-1.5">
                        <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a>
                        <span class="text-xl font-bold text-brand-500">Admin</span>
                    </div>
                    <button onclick="toggleSidebar()" class="p-2 text-slate-500 lg:hidden rounded-full hover:bg-slate-100 transition-colors">
                        <i data-lucide="x" class="h-6 w-6"></i>
                    </button>
                </div>
                <div class="mx-5 mt-4 rounded-2xl bg-brand-900 px-4 py-4 text-white shadow-xl shadow-brand-900/10">
                    <p class="text-xs font-bold uppercase tracking-widest text-white/50 mb-1">Authenticated As</p>
                    <p class="text-sm font-semibold text-white truncate"><%= esc(adminName) %></p>
                    <p class="mt-1 text-[10px] font-bold text-brand-200 uppercase tracking-tighter bg-white/10 inline-block px-2 py-0.5 rounded-lg border border-white/10"><%= esc(adminRole) %></p>
                </div>
                <nav class="mt-8 flex-1 space-y-1.5 px-4 overflow-y-auto">
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="layout-dashboard" class="h-5 w-5 shrink-0"></i>
                        <span>Admin Console</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link active flex items-center gap-3 rounded-xl px-3 py-3 text-sm">
                        <i data-lucide="clipboard-list" class="h-5 w-5 shrink-0"></i>
                        <span>Process Stream</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="megaphone" class="h-5 w-5 shrink-0"></i>
                        <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="sprout" class="h-5 w-5 shrink-0"></i>
                        <span>Agri Hub</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-600">
                        <i data-lucide="banknote" class="h-5 w-5 shrink-0"></i>
                        <span>Budget Ledger</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-4 pb-20 lg:pb-6 pt-4">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-red-600 hover:bg-red-50">
                        <i data-lucide="log-out" class="h-5 w-5 shrink-0"></i>
                        <span>System Exit</span>
                    </a>
                </div>
            </aside>
            <div class="flex-1 flex flex-col min-h-screen w-full overflow-hidden pb-16 lg:pb-0">
                <header class="sticky top-0 z-40 flex flex-col border-b border-slate-200 bg-white/80 backdrop-blur-xl">
                    <div class="flex items-center justify-between px-6 py-4 sm:px-8">
                        <div>
                            <h1 class="text-lg font-bold text-slate-900 tracking-tight">Review Center</h1>
                            <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest leading-none mt-1">Operational Pipeline</p>
                        </div>
                    </div>
                    <div class="flex gap-2 p-2 sm:px-8 sm:pb-4 overflow-x-auto no-scrollbar scroll-smooth">
                        <a href="<%= request.getContextPath() %>/admin/applications" class="whitespace-nowrap px-4 py-2 text-[10px] font-bold uppercase tracking-widest rounded-full transition-all <%= filter==null?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"bg-slate-50 text-slate-500 hover:bg-slate-100" %>">All</a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=submitted" class="whitespace-nowrap px-4 py-2 text-[10px] font-bold uppercase tracking-widest rounded-full transition-all <%= "submitted".equals(filter)?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"bg-slate-50 text-slate-500 hover:bg-slate-100" %>">Pending</a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=review" class="whitespace-nowrap px-4 py-2 text-[10px] font-bold uppercase tracking-widest rounded-full transition-all <%= "review".equals(filter)?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"bg-slate-50 text-slate-500 hover:bg-slate-100" %>">Reviewing</a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=approved" class="whitespace-nowrap px-4 py-2 text-[10px] font-bold uppercase tracking-widest rounded-full transition-all <%= "approved".equals(filter)?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"bg-slate-50 text-slate-500 hover:bg-slate-100" %>">Cleared</a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=rejected" class="whitespace-nowrap px-4 py-2 text-[10px] font-bold uppercase tracking-widest rounded-full transition-all <%= "rejected".equals(filter)?"bg-brand-900 text-white shadow-lg shadow-brand-900/20":"bg-slate-50 text-slate-500 hover:bg-slate-100" %>">Rejected</a>
                    </div>
                </header>
                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-6xl mx-auto">
                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-6 rounded-2xl border-l-4 border-red-500 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700 shadow-sm animate-pulse">
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>
                    <div class="grid gap-6">
                        <% boolean any=false; for(Application app: applications){ if(filter!=null && !filter.isBlank() && !filter.equals(app.getStatus())) continue; any=true; Citizen citizen=citizensById==null?null:citizensById.get(app.getCitizenId()); ServiceType service=servicesById==null?null:servicesById.get(app.getServiceTypeId()); List<ApplicationDocument> docs=docsByApp==null?List.of():docsByApp.getOrDefault(app.getApplicationId(), List.of()); List<CitizenDocumentVault> vaultDocs=vaultDocsByCitizen==null?List.of():vaultDocsByCitizen.getOrDefault(app.getCitizenId(), List.of()); %>
                        <article class="group relative overflow-hidden rounded-[2.5rem] border border-slate-100 bg-white p-6 sm:p-8 shadow-sm transition-all hover:shadow-xl hover:shadow-brand-900/5">
                            <div class="flex flex-col lg:flex-row gap-8">
                                <div class="flex-1 min-w-0">
                                    <div class="flex flex-wrap items-center gap-3 mb-6">
                                        <h2 class="text-xl font-black text-slate-900 tracking-tight">#<%= esc(app.getTrackingId()) %></h2>
                                        <span class="inline-flex rounded-full <%= badgeClass(app.getStatus()) %> px-4 py-1.5 text-[10px] font-bold uppercase tracking-widest ring-1 ring-inset ring-brand-500/10">
                                            <%= esc(label(app.getStatus())) %>
                                        </span>
                                    </div>
                                    <div class="grid gap-4 sm:grid-cols-3 mb-8">
                                        <div class="rounded-2xl bg-slate-50/50 p-4 border border-slate-100">
                                            <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Applicant</p>
                                            <p class="text-xs font-extrabold text-slate-900 truncate"><%= esc(citizen==null?"ID: "+app.getCitizenId():citizen.getFullName()) %></p>
                                        </div>
                                        <div class="rounded-2xl bg-slate-50/50 p-4 border border-slate-100">
                                            <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Service Hub</p>
                                            <p class="text-xs font-extrabold text-slate-900 truncate"><%= esc(service==null?"ID: "+app.getServiceTypeId():service.getServiceName()) %></p>
                                        </div>
                                        <div class="rounded-2xl bg-slate-50/50 p-4 border border-slate-100">
                                            <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Received</p>
                                            <p class="text-xs font-extrabold text-slate-900 truncate"><%= app.getSubmittedAt()==null?"—":esc(app.getSubmittedAt().format(dateFormatter)) %></p>
                                        </div>
                                    </div>
                                    <div class="mb-8 overflow-hidden rounded-2xl bg-slate-900/5 p-5">
                                        <h3 class="text-[10px] font-bold uppercase tracking-widest text-slate-500 mb-2 flex items-center gap-2">
                                            <i data-lucide="scroll-text" class="h-3 w-3"></i>
                                            Metadata Content
                                        </h3>
                                        <p class="text-xs leading-relaxed font-medium text-slate-700 whitespace-pre-wrap"><%= esc(app.getFormData()) %></p>
                                    </div>
                                    <div class="grid gap-6 sm:grid-cols-2">
                                        <div>
                                            <h4 class="text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-3 ml-1 flex items-center gap-2">
                                                <i data-lucide="paperclip" class="h-3 w-3"></i>
                                                Attached Media
                                            </h4>
                                            <% if(docs.isEmpty()){ %>
                                                <div class="rounded-2xl border border-dashed border-slate-200 bg-slate-50 px-4 py-3">
                                                    <p class="text-[10px] font-bold text-slate-400 uppercase italic">No direct uploads</p>
                                                </div>
                                            <% } else { %>
                                                <div class="flex flex-wrap gap-2">
                                                    <% for(ApplicationDocument d: docs){ String path=d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); %>
                                                    <a href="<%= esc(path) %>" target="_blank" rel="noopener" class="rounded-xl border border-slate-100 bg-white px-3 py-2 text-[10px] font-bold text-brand-900 shadow-sm transition-all hover:bg-brand-50 hover:-translate-y-0.5"><%= esc(d.getDocumentType()) %></a>
                                                    <% } %>
                                                </div>
                                            <% } %>
                                        </div>
                                        <div>
                                            <h4 class="text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-3 ml-1 flex items-center gap-2">
                                                <i data-lucide="vault" class="h-3 w-3"></i>
                                                Citizen Vault Files
                                            </h4>
                                            <% if(vaultDocs.isEmpty()){ %>
                                                <div class="rounded-2xl border border-dashed border-slate-200 bg-slate-50 px-4 py-3">
                                                    <p class="text-[10px] font-bold text-slate-400 uppercase italic">No vault access</p>
                                                </div>
                                            <% } else { %>
                                                <div class="flex flex-wrap gap-2">
                                                    <% for(CitizenDocumentVault d: vaultDocs){ String path=d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); %>
                                                    <a href="<%= esc(path) %>" target="_blank" rel="noopener" class="rounded-xl border border-brand-100 bg-brand-50/30 px-3 py-2 text-[10px] font-bold text-brand-800 shadow-sm transition-all hover:bg-brand-100 hover:-translate-y-0.5"><%= esc(d.getDocumentType()) %></a>
                                                    <% } %>
                                                </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full lg:w-72 lg:shrink-0 lg:border-l lg:border-slate-100 lg:pl-8 flex flex-col justify-center">
                                    <form method="post" action="<%= request.getContextPath() %>/api/admin/applications" class="space-y-4">
                                        <input type="hidden" name="redirectTo" value="/admin/applications">
                                        <input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>">
                                        <input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
                                        <div class="relative">
                                            <h4 class="text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 ml-1">Decision Remarks</h4>
                                            <textarea name="remarks" rows="4" placeholder="Review feedback..." class="w-full rounded-2xl border-0 bg-slate-50 px-4 py-3 text-sm font-medium focus:ring-2 focus:ring-brand-500 outline-none transition-all resize-none shadow-inner"><%= esc(app.getRemarks()) %></textarea>
                                        </div>
                                        <div class="grid grid-cols-2 gap-2">
                                            <button name="status" value="review" class="rounded-xl bg-amber-50 py-3 text-[10px] font-black uppercase tracking-widest text-amber-700 transition-all hover:bg-amber-100 active:scale-95" type="submit">Wait</button>
                                            <button name="status" value="rejected" class="rounded-xl bg-red-50 py-3 text-[10px] font-black uppercase tracking-widest text-red-700 transition-all hover:bg-red-100 active:scale-95" type="submit">Halt</button>
                                        </div>
                                        <button name="status" value="approved" class="w-full rounded-xl bg-brand-900 py-4 text-xs font-bold text-white shadow-xl shadow-brand-900/20 transition-all hover:bg-brand-800 active:scale-95" type="submit">Clear & Approve</button>
                                    </form>
                                    <% if("approved".equals(app.getStatus())){ %>
                                        <div class="mt-4 pt-4 border-t border-slate-100">
                                            <form method="post" action="<%= request.getContextPath() %>/api/certificates">
                                                <input type="hidden" name="redirectTo" value="/admin/applications">
                                                <input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>">
                                                <input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
                                                <button class="w-full flex items-center justify-center gap-2 rounded-xl bg-green-500 py-4 text-xs font-bold text-white shadow-xl shadow-green-500/20 transition-all hover:bg-green-600 active:scale-95 underline-offset-4" type="submit">
                                                    <i data-lucide="award" class="h-4 w-4"></i>
                                                    Issue Certification
                                                </button>
                                            </form>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </article>
                    <% } if(!any){ %>
                        <div class="rounded-[2.5rem] border border-dashed border-slate-200 bg-slate-50/50 p-20 text-center shadow-sm">
                            <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-slate-100 text-slate-300 mb-6">
                                <i data-lucide="clipboard-x" class="h-8 w-8"></i>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900">Queue Empty</h3>
                            <p class="text-sm text-slate-500 mt-1">No applications matching current filters.</p>
                        </div>
                    <% } %>
                    </div>
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
</body>
</html>
