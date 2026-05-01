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
            body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <div class="flex min-h-screen">
            <aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
                <div class="flex items-center gap-1.5 px-5 pt-5 pb-2">
                    <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">
                        SarkarSathi
                    </a>
                    <span class="text-xl font-bold text-brand-500">
                        Admin
                    </span>
                </div>
                <div class="mx-5 mt-3 rounded-xl bg-brand-50 px-4 py-3">
                    <p class="text-sm font-semibold text-brand-900">
                        <%= esc(adminName) %>
                    </p>
                    <p class="text-[11px] text-slate-500">
                        <%= esc(adminRole) %>
                    </p>
                </div>
                <nav class="mt-6 flex-1 space-y-1 px-3">
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="layout-dashboard" class="h-4 w-4 shrink-0"></i>
                            <span>Dashboard</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
                        <i data-lucide="clipboard-list" class="h-4 w-4 shrink-0"></i>
                            <span>Applications</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="megaphone" class="h-4 w-4 shrink-0"></i>
                            <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="sprout" class="h-4 w-4 shrink-0"></i>
                            <span>Agri Notices</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="banknote" class="h-4 w-4 shrink-0"></i>
                            <span>Budgets</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600">
                        <i data-lucide="log-out" class="h-4 w-4 shrink-0"></i>
                            <span>Logout</span>
                    </a>
                </div>
            </aside>
            <div class="ml-[220px] flex-1 flex flex-col min-h-screen">
                <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900">
                            Application Review Panel
                        </h1>
                        <p class="text-xs text-slate-500">
                            Review, approve, or reject citizen applications
                        </p>
                    </div>
                    <div class="flex gap-2">
                        <a href="<%= request.getContextPath() %>/admin/applications" class="rounded-lg <%= filter==null?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-4 py-2 text-xs font-semibold">
                            All
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=submitted" class="rounded-lg <%= "submitted".equals(filter)?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-4 py-2 text-xs font-semibold">
                            Submitted
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=review" class="rounded-lg <%= "review".equals(filter)?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-4 py-2 text-xs font-semibold">
                            In Review
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=approved" class="rounded-lg <%= "approved".equals(filter)?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-4 py-2 text-xs font-semibold">
                            Approved
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/applications?status=rejected" class="rounded-lg <%= "rejected".equals(filter)?"bg-brand-900 text-white":"border border-slate-200 text-slate-600" %> px-4 py-2 text-xs font-semibold">
                            Rejected
                        </a>
                    </div>
                </header>
                <main class="flex-1 px-8 py-8 overflow-y-auto">
                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-6 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>
                    <div class="space-y-5">
                        <% boolean any=false; for(Application app: applications){ if(filter!=null && !filter.isBlank() && !filter.equals(app.getStatus())) continue; any=true; Citizen citizen=citizensById==null?null:citizensById.get(app.getCitizenId()); ServiceType service=servicesById==null?null:servicesById.get(app.getServiceTypeId()); List<ApplicationDocument> docs=docsByApp==null?List.of():docsByApp.getOrDefault(app.getApplicationId(), List.of()); List<CitizenDocumentVault> vaultDocs=vaultDocsByCitizen==null?List.of():vaultDocsByCitizen.getOrDefault(app.getCitizenId(), List.of()); %>
                        <article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                            <div class="flex items-start justify-between gap-5">
                                <div class="flex-1">
                                    <div class="flex items-center gap-3">
                                        <h2 class="text-base font-bold text-brand-900">
                                            #<%= esc(app.getTrackingId()) %>
                                        </h2>
                                        <span class="inline-flex rounded-full <%= badgeClass(app.getStatus()) %> px-3 py-1 text-xs font-semibold">
                                            <%= esc(label(app.getStatus())) %>
                                        </span>
                                    </div>
                                    <div class="mt-3 grid gap-3 text-sm text-slate-600 md:grid-cols-3">
                                        <p>
                                            <strong>
                                                Citizen:
                                            </strong>
                                            <%= esc(citizen==null?"Citizen #"+app.getCitizenId():citizen.getFullName()) %>
                                        </p>
                                        <p>
                                            <strong>
                                                Service:
                                            </strong>
                                            <%= esc(service==null?"Service #"+app.getServiceTypeId():service.getServiceName()) %>
                                        </p>
                                        <p>
                                            <strong>
                                                Date:
                                            </strong>
                                            <%= app.getSubmittedAt()==null?"":esc(app.getSubmittedAt().format(dateFormatter)) %>
                                        </p>
                                    </div>
                                    <div class="mt-4 rounded-xl bg-slate-50 p-4 text-xs text-slate-600">
                                        <strong>
                                            Form Data:
                                        </strong>
                                        <br>
                                        <%= esc(app.getFormData()) %>
                                    </div>
                                    <div class="mt-4">
                                        <p class="mb-2 text-xs font-semibold uppercase tracking-wider text-slate-400">
                                            Application Documents
                                        </p>
                                        <% if(docs.isEmpty()){ %>
                                            <p class="text-sm text-slate-400">
                                                No documents attached to this application.
                                            </p>
                                        <% } else { %>
                                            <div class="flex flex-wrap gap-2">
                                                <% for(ApplicationDocument d: docs){ String path=d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); %>
                                                <a class="rounded-lg border border-slate-200 px-3 py-2 text-xs font-semibold text-brand-900 hover:bg-brand-50" href="<%= esc(path) %>" target="_blank" rel="noopener">
                                                    <%= esc(d.getDocumentType()) %>
                                                </a>
                                            <% } %>
                                        </div>
                                    <% } %>
                                </div>
                                    <div class="mt-4">
                                        <p class="mb-2 text-xs font-semibold uppercase tracking-wider text-slate-400">
                                            Citizen Vault Documents
                                        </p>
                                        <% if(vaultDocs.isEmpty()){ %>
                                            <p class="text-sm text-slate-400">
                                                No reusable documents in this citizen's vault.
                                            </p>
                                        <% } else { %>
                                            <div class="flex flex-wrap gap-2">
                                                <% for(CitizenDocumentVault d: vaultDocs){ String path=d.getFilePath()==null?"#":(d.getFilePath().startsWith("/")?request.getContextPath()+d.getFilePath():request.getContextPath()+"/"+d.getFilePath()); %>
                                                    <a class="rounded-lg border border-slate-200 px-3 py-2 text-xs font-semibold text-brand-900 hover:bg-brand-50" href="<%= esc(path) %>" target="_blank" rel="noopener">
                                                        <%= esc(d.getDocumentType()) %>
                                                    </a>
                                                <% } %>
                                            </div>
                                        <% } %>
                                    </div>
                            </div>
                            <div class="w-72 shrink-0">
                                <form method="post" action="<%= request.getContextPath() %>/api/admin/applications" class="space-y-3">
                                    <input type="hidden" name="redirectTo" value="/admin/applications">
                                    <input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>">
                                    <input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
                                    <textarea name="remarks" rows="3" placeholder="Remarks" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                        <%= esc(app.getRemarks()) %>
                                    </textarea>
                                    <div class="grid grid-cols-3 gap-2">
                                        <button name="status" value="review" class="rounded-xl border border-amber-200 py-2 text-xs font-semibold text-amber-700 hover:bg-amber-50" type="submit">
                                            Review
                                        </button>
                                        <button name="status" value="approved" class="rounded-xl border border-green-200 py-2 text-xs font-semibold text-green-700 hover:bg-green-50" type="submit">
                                            Approve
                                        </button>
                                        <button name="status" value="rejected" class="rounded-xl border border-red-200 py-2 text-xs font-semibold text-red-600 hover:bg-red-50" type="submit">
                                            Reject
                                        </button>
                                    </div>
                                </form>
                                <% if("approved".equals(app.getStatus())){ %>
                                    <form method="post" action="<%= request.getContextPath() %>/api/certificates" class="mt-3">
                                        <input type="hidden" name="redirectTo" value="/admin/applications">
                                        <input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>">
                                        <input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
                                        <button class="w-full rounded-xl bg-green-600 py-2.5 text-xs font-semibold text-white hover:bg-green-700" type="submit">
                                            Issue Certificate
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                    </article>
                <% } if(!any){ %>
                    <div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm">
                        <p class="text-slate-500">
                            No applications found
                        </p>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</div>
</body>
</html>
