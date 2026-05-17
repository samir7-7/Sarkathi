<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Application" %>
<%@ page import="Model.ApplicationDocument" %>
<%@ page import="Model.Citizen" %>
<%@ page import="Model.CitizenDocumentVault" %>
<%@ page import="Model.IssuedCertificate" %>
<%@ page import="Model.ServiceType" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%!
private String esc(Object value){ if(value==null)return ""; return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;"); }
private String badgeClass(String status){ if("approved".equals(status)) return "bg-emerald-50 text-emerald-700 border-emerald-200"; if("rejected".equals(status)) return "bg-rose-50 text-rose-700 border-rose-200"; if("review".equals(status)) return "bg-amber-50 text-amber-700 border-amber-200"; return "bg-blue-50 text-blue-700 border-blue-200"; }
private String label(String status){ if("review".equals(status)) return "Under Review"; if(status==null||status.isBlank()) return "Submitted"; return status.substring(0,1).toUpperCase()+status.substring(1); }
private java.util.Map<String,String> parseFormData(String raw){
    java.util.Map<String,String> map = new java.util.LinkedHashMap<>();
    if(raw == null) return map;
    String s = raw.trim();
    if(s.isBlank() || "{}".equals(s)) return map;
    if(s.startsWith("{")) s = s.substring(1);
    if(s.endsWith("}")) s = s.substring(0, s.length()-1);
    java.util.List<String> pairs = splitJsonTopLevel(s, ',');
    for(String pair : pairs){
        java.util.List<String> parts = splitJsonTopLevel(pair, ':');
        if(parts.size() < 2) continue;
        String key = unquoteJson(parts.get(0).trim());
        StringBuilder value = new StringBuilder();
        for(int i=1;i<parts.size();i++){
            if(i>1) value.append(":");
            value.append(parts.get(i));
        }
        map.put(key, unquoteJson(value.toString().trim()));
    }
    return map;
}
private java.util.List<String> splitJsonTopLevel(String input, char separator){
    java.util.List<String> parts = new java.util.ArrayList<>();
    StringBuilder current = new StringBuilder();
    boolean inQuotes = false;
    boolean escaped = false;
    for(int i=0;i<input.length();i++){
        char ch = input.charAt(i);
        if(escaped){
            current.append(ch);
            escaped = false;
            continue;
        }
        if(ch == '\\'){
            current.append(ch);
            escaped = true;
            continue;
        }
        if(ch == '"'){
            inQuotes = !inQuotes;
            current.append(ch);
            continue;
        }
        if(ch == separator && !inQuotes){
            parts.add(current.toString());
            current.setLength(0);
            continue;
        }
        current.append(ch);
    }
    if(!current.isEmpty()) parts.add(current.toString());
    return parts;
}
private String unquoteJson(String value){
    String cleaned = value;
    if(cleaned.startsWith("\"") && cleaned.endsWith("\"") && cleaned.length() >= 2){
        cleaned = cleaned.substring(1, cleaned.length()-1);
    }
    return cleaned.replace("\\\"", "\"").replace("\\n", "\n").replace("\\r", "").replace("\\t", " ").replace("\\\\", "\\");
}
private String field(java.util.Map<String,String> data, String key){
    if(data == null) return "";
    String value = data.get(key);
    return value == null ? "" : value;
}
private String humanizeKey(String key){
    if(key == null || key.isBlank()) return "";
    String spaced = key.replaceAll("([a-z])([A-Z])", "$1 $2").replace('_', ' ').trim();
    return Character.toUpperCase(spaced.charAt(0)) + spaced.substring(1);
}
private void reviewField(JspWriter out, String label, String value, boolean fullWidth) throws java.io.IOException {
    if(value == null || value.isBlank()) return;
    out.write("<div class=\"rounded-xl border border-slate-200 bg-white px-3 py-3" + (fullWidth ? " sm:col-span-2" : "") + "\">");
    out.write("<p class=\"text-[10px] font-black uppercase tracking-wider text-slate-400\">" + esc(label) + "</p>");
    out.write("<p class=\"mt-1 text-sm font-bold text-slate-800 whitespace-pre-wrap\">" + esc(value) + "</p>");
    out.write("</div>");
}
private void renderStructuredReview(JspWriter out, String serviceName, java.util.Map<String,String> data, Application app, Citizen c) throws java.io.IOException {
    if("Birth Certificate".equalsIgnoreCase(serviceName)){
        out.write("<div class=\"grid sm:grid-cols-2 gap-2\">");
        reviewField(out, "Child Full Name", field(data,"childFullName"), false);
        reviewField(out, "Date of Birth", field(data,"dateOfBirth"), false);
        reviewField(out, "Time of Birth", field(data,"timeOfBirth"), false);
        reviewField(out, "Gender", field(data,"genderOfChild"), false);
        reviewField(out, "Birth Place", field(data,"placeOfBirth"), false);
        reviewField(out, "Registration Number", field(data,"registrationNumber"), false);
        reviewField(out, "Father's Full Name", field(data,"fatherFullName"), false);
        reviewField(out, "Mother's Full Name", field(data,"motherFullName"), false);
        reviewField(out, "Parents' Nationality", field(data,"parentsNationality"), false);
        reviewField(out, "Parents' Occupation", field(data,"parentsOccupation"), false);
        reviewField(out, "Parents' Permanent Address", field(data,"parentsPermanentAddress"), true);
        reviewField(out, "Informant Name", field(data,"informantName"), false);
        out.write("</div>");
        return;
    }
    if("Marriage Certificate".equalsIgnoreCase(serviceName)){
        out.write("<div class=\"grid sm:grid-cols-2 gap-2\">");
        reviewField(out, "Husband Full Name", field(data,"husbandFullName"), false);
        reviewField(out, "Wife Full Name", field(data,"wifeFullName"), false);
        reviewField(out, "Husband Date of Birth", field(data,"husbandDateOfBirth"), false);
        reviewField(out, "Wife Date of Birth", field(data,"wifeDateOfBirth"), false);
        reviewField(out, "Husband Nationality", field(data,"husbandNationality"), false);
        reviewField(out, "Wife Nationality", field(data,"wifeNationality"), false);
        reviewField(out, "Date of Marriage", field(data,"dateOfMarriage"), false);
        reviewField(out, "Place of Marriage", field(data,"placeOfMarriage"), false);
        reviewField(out, "Husband Permanent Address", field(data,"husbandPermanentAddress"), true);
        reviewField(out, "Wife Permanent Address", field(data,"wifePermanentAddress"), true);
        reviewField(out, "Witness Details", field(data,"witnessNamesAndSignatures"), true);
        reviewField(out, "Marriage Registration Number", field(data,"marriageRegistrationNumber"), false);
        out.write("</div>");
        return;
    }
    if("Residence Certificate".equalsIgnoreCase(serviceName)){
        out.write("<div class=\"grid sm:grid-cols-2 gap-2\">");
        reviewField(out, "Applicant Full Name", field(data,"applicantFullName").isBlank() && c!=null ? c.getFullName() : field(data,"applicantFullName"), false);
        reviewField(out, "Parent / Guardian Name", field(data,"parentName"), false);
        reviewField(out, "Date of Birth", field(data,"dateOfBirth"), false);
        reviewField(out, "Identification Number", field(data,"identificationNumber"), false);
        reviewField(out, "Permanent Address", field(data,"permanentAddress"), true);
        reviewField(out, "Current Address", field(data,"currentAddress"), true);
        reviewField(out, "Duration of Stay", field(data,"durationOfStayAtCurrentAddress"), false);
        reviewField(out, "Purpose of Certificate", field(data,"purposeOfCertificate"), false);
        reviewField(out, "Photograph Reference", field(data,"photographReference"), false);
        reviewField(out, "Signature / Thumbprint Reference", field(data,"signatureOrThumbprintReference"), false);
        out.write("</div>");
        return;
    }
    if("Citizenship Recommendation".equalsIgnoreCase(serviceName)){
        out.write("<div class=\"grid sm:grid-cols-2 gap-2\">");
        reviewField(out, "Applicant Full Name", field(data,"fullName").isBlank() && c!=null ? c.getFullName() : field(data,"fullName"), false);
        reviewField(out, "Date of Birth", field(data,"dateOfBirth"), false);
        reviewField(out, "Place of Birth", field(data,"placeOfBirth"), false);
        reviewField(out, "Gender", field(data,"gender"), false);
        reviewField(out, "Parent Name(s)", field(data,"parentNames"), false);
        reviewField(out, "Parents' Nationality", field(data,"nationalityOfParents"), false);
        reviewField(out, "Identification Number", field(data,"identificationNumber"), false);
        reviewField(out, "Permanent Address", field(data,"permanentAddress"), true);
        out.write("</div>");
        return;
    }
    out.write("<div class=\"grid sm:grid-cols-2 gap-2\">");
    if(data != null && !data.isEmpty()){
        for(java.util.Map.Entry<String,String> entry : data.entrySet()){
            reviewField(out, humanizeKey(entry.getKey()), entry.getValue(), false);
        }
    } else {
        reviewField(out, "Application Data", app.getFormData(), true);
    }
    out.write("</div>");
}
%>
<%
Integer adminId=(Integer)request.getAttribute("adminId");
String adminName=(String)request.getAttribute("adminName");
String adminRole=(String)request.getAttribute("adminRole");
String pageError=(String)request.getAttribute("pageError");
String formError=request.getParameter("error");
String filter=request.getParameter("status");
List<Application> applications=(List<Application>)request.getAttribute("applications");
Map<Integer,Citizen> citizensById=(Map<Integer,Citizen>)request.getAttribute("citizensById");
Map<Integer,ServiceType> servicesById=(Map<Integer,ServiceType>)request.getAttribute("servicesById");
Map<Integer,List<ApplicationDocument>> docsByApp=(Map<Integer,List<ApplicationDocument>>)request.getAttribute("documentsByApplicationId");
Map<Integer,IssuedCertificate> certificatesByApplicationId=(Map<Integer,IssuedCertificate>)request.getAttribute("certificatesByApplicationId");
Map<Integer,List<CitizenDocumentVault>> vaultDocsByCitizen=(Map<Integer,List<CitizenDocumentVault>>)request.getAttribute("vaultDocumentsByCitizenId");
DateTimeFormatter fmt=DateTimeFormatter.ofPattern("MMM d, yyyy");
if(applications==null)applications=List.of();
if(adminName==null)adminName="Admin";
if(adminRole==null)adminRole="System Controller";
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Applications - Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"><script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{500:'#3b82f6',900:'#0b3d86'}}}}}</script>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:700}.safe-area-bottom{padding-bottom:env(safe-area-inset-bottom,1.5rem)}.filter-scroll{-ms-overflow-style:none;scrollbar-width:none}.filter-scroll::-webkit-scrollbar{display:none}@media (max-width:639px){.review-modal-panel{max-height:calc(100vh - 5rem);border-radius:1.25rem 1.25rem 0 0;margin-bottom:0}.review-modal-body{padding-left:.875rem;padding-right:.875rem;padding-bottom:1rem}.review-meta-grid{grid-template-columns:1fr}.review-action-grid{grid-template-columns:1fr}.review-doc-grid{grid-template-columns:1fr}}</style>
<%@ include file="../includes/lucide-icons.jsp" %></head>
<body class="bg-slate-100 text-slate-900 antialiased overflow-x-hidden">
<div class="flex min-h-screen relative">
<div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden"></div>
<%@ include file="../includes/sidebar-admin.jsp" %>
<div class="flex-1 flex flex-col min-h-screen">
<header class="sticky top-0 z-40 bg-white/90 backdrop-blur border-b border-slate-200 px-4 pt-3.5 pb-2 lg:px-7">
  <!-- Row 1: hamburger + title + profile badge -->
  <div class="flex items-center justify-between gap-3">
    <div class="flex items-center gap-3">
      <button onclick="toggleSidebar()" class="inline-flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 shadow-sm transition hover:bg-slate-50 lg:hidden"><i data-lucide="menu" class="h-5 w-5"></i></button>
      <div>
        <h1 class="text-lg font-black tracking-tight text-slate-900">Application Review Center</h1>
        <p class="text-[11px] font-semibold text-slate-500">Inspect documents, add remarks, and publish decisions.</p>
      </div>
    </div>
    <div class="hidden sm:flex items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2">
      <div class="h-9 w-9 rounded-full bg-brand-900 flex items-center justify-center text-white text-sm font-bold"><%= adminName.length() > 0 ? adminName.substring(0,1).toUpperCase() : "A" %></div>
      <div>
        <p class="text-sm font-bold text-slate-900"><%= esc(adminName) %></p>
        <p class="text-[11px] font-semibold text-slate-500"><%= esc(adminRole) %></p>
      </div>
    </div>
  </div>
  <!-- Row 2: filter pills (always in their own row) -->
  <div class="filter-scroll mt-3 flex gap-2 overflow-x-auto pb-1">
    <a href="<%= request.getContextPath() %>/admin/applications" class="whitespace-nowrap px-3 py-1.5 rounded-full text-[10px] font-black uppercase tracking-wider <%= filter==null?"bg-brand-900 text-white":"bg-slate-100 text-slate-600" %>">All</a>
    <a href="<%= request.getContextPath() %>/admin/applications?status=submitted" class="whitespace-nowrap px-3 py-1.5 rounded-full text-[10px] font-black uppercase tracking-wider <%= "submitted".equals(filter)?"bg-brand-900 text-white":"bg-slate-100 text-slate-600" %>">Submitted</a>
    <a href="<%= request.getContextPath() %>/admin/applications?status=review" class="whitespace-nowrap px-3 py-1.5 rounded-full text-[10px] font-black uppercase tracking-wider <%= "review".equals(filter)?"bg-brand-900 text-white":"bg-slate-100 text-slate-600" %>">Review</a>
    <a href="<%= request.getContextPath() %>/admin/applications?status=approved" class="whitespace-nowrap px-3 py-1.5 rounded-full text-[10px] font-black uppercase tracking-wider <%= "approved".equals(filter)?"bg-brand-900 text-white":"bg-slate-100 text-slate-600" %>">Approved</a>
    <a href="<%= request.getContextPath() %>/admin/applications?status=rejected" class="whitespace-nowrap px-3 py-1.5 rounded-full text-[10px] font-black uppercase tracking-wider <%= "rejected".equals(filter)?"bg-brand-900 text-white":"bg-slate-100 text-slate-600" %>">Rejected</a>
  </div>
</header>
<main class="flex-1 w-full p-3 sm:p-4 lg:p-6">
<div class="space-y-4 max-w-7xl">
<% if(pageError!=null || formError!=null){ %><div class="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-xs font-bold text-rose-700"><%= esc(pageError!=null?pageError:formError) %></div><% } %>
<% boolean any=false; for(Application app:applications){ if(filter!=null && !filter.isBlank() && !filter.equals(app.getStatus())) continue; any=true; Citizen c=citizensById==null?null:citizensById.get(app.getCitizenId()); ServiceType s=servicesById==null?null:servicesById.get(app.getServiceTypeId()); List<ApplicationDocument> docs=docsByApp==null?List.of():docsByApp.getOrDefault(app.getApplicationId(),List.of()); IssuedCertificate issuedCertificate=certificatesByApplicationId==null?null:certificatesByApplicationId.get(app.getApplicationId()); boolean certificateIssued=issuedCertificate!=null; List<CitizenDocumentVault> vdocs=vaultDocsByCitizen==null?List.of():vaultDocsByCitizen.getOrDefault(app.getCitizenId(),List.of()); java.util.Map<String,String> structuredData = parseFormData(app.getFormData()); String serviceName = s==null?null:s.getServiceName(); %>
<article class="rounded-2xl border border-slate-200 bg-white shadow-sm overflow-hidden">
  <div class="p-4 lg:p-5">
    <!-- Tracking ID + Badge -->
    <div class="flex flex-wrap items-center justify-between gap-2">
      <h2 class="text-base font-black text-slate-900">#<%= esc(app.getTrackingId()) %></h2>
      <span class="px-2.5 py-1 rounded-lg border text-[10px] font-black uppercase tracking-wider <%= badgeClass(app.getStatus()) %>"><%= esc(label(app.getStatus())) %></span>
    </div>
    <!-- Meta fields: stacked on mobile, 3-col on desktop -->
    <div class="mt-3 grid grid-cols-1 sm:grid-cols-3 gap-2">
      <div class="rounded-xl bg-slate-50 border border-slate-200 px-3 py-2.5">
        <p class="text-[10px] font-black text-slate-400 uppercase tracking-wider">Citizen</p>
        <p class="mt-1 text-sm font-bold text-slate-800"><%= esc(c==null?("ID: "+app.getCitizenId()):c.getFullName()) %></p>
      </div>
      <div class="rounded-xl bg-slate-50 border border-slate-200 px-3 py-2.5">
        <p class="text-[10px] font-black text-slate-400 uppercase tracking-wider">Service</p>
        <p class="mt-1 text-sm font-bold text-slate-800"><%= esc(s==null?("ID: "+app.getServiceTypeId()):s.getServiceName()) %></p>
      </div>
      <div class="rounded-xl bg-slate-50 border border-slate-200 px-3 py-2.5">
        <p class="text-[10px] font-black text-slate-400 uppercase tracking-wider">Submitted</p>
        <p class="mt-1 text-sm font-bold text-slate-800"><%= app.getSubmittedAt()==null?"-":esc(app.getSubmittedAt().format(fmt)) %></p>
      </div>
    </div>
    <!-- Actions: certificate status + open button -->
    <div class="mt-3 flex flex-col gap-2">
      <% if(certificateIssued){ %>
      <span class="inline-flex w-full items-center justify-center rounded-xl bg-blue-50 border border-blue-200 px-3 py-2 text-[10px] font-black uppercase tracking-wider text-blue-700">Certificate Issued</span>
      <% } else if("approved".equals(app.getStatus())){ %>
      <span class="inline-flex w-full items-center justify-center rounded-xl bg-emerald-50 border border-emerald-200 px-3 py-2 text-[10px] font-black uppercase tracking-wider text-emerald-700">Ready To Issue</span>
      <% } %>
      <button type="button" onclick="openApplicationModal('application-modal-<%= app.getApplicationId() %>')" class="inline-flex w-full items-center justify-center rounded-xl bg-brand-900 px-4 py-3 text-xs font-black uppercase tracking-wider text-white transition hover:bg-slate-800">Open Application</button>
    </div>
  </div>
</article>

<div id="application-modal-<%= app.getApplicationId() %>" class="fixed inset-0 z-[90] hidden">
<div class="absolute inset-0 bg-slate-950/65 backdrop-blur-sm" onclick="closeApplicationModal('application-modal-<%= app.getApplicationId() %>')"></div>
<div class="relative z-[91] flex min-h-screen items-end justify-center p-0 sm:items-center sm:p-6">
<div class="review-modal-panel flex max-h-[100vh] sm:max-h-[92vh] w-full max-w-6xl flex-col overflow-hidden rounded-t-[28px] sm:rounded-[28px] border border-slate-200 bg-white shadow-2xl">
<div class="flex items-start justify-between gap-4 border-b border-slate-200 px-4 py-4 sm:px-6">
<div>
<div class="flex flex-wrap items-center gap-2"><h3 class="text-lg font-black text-slate-900">Application #<%= esc(app.getTrackingId()) %></h3><span class="px-2.5 py-1 rounded-lg border text-[10px] font-black uppercase tracking-wider <%= badgeClass(app.getStatus()) %>"><%= esc(label(app.getStatus())) %></span></div>
<p class="mt-1 text-[11px] font-semibold text-slate-500">Review documents, update status, and issue certificates from one focused panel.</p>
</div>
<button type="button" onclick="closeApplicationModal('application-modal-<%= app.getApplicationId() %>')" class="flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 text-slate-500 hover:bg-slate-50"><i data-lucide="x" class="h-4 w-4"></i></button>
</div>
<div class="review-modal-body overflow-y-auto px-4 py-4 sm:px-6 sm:py-6">
<div class="grid lg:grid-cols-3 gap-4">
<div class="lg:col-span-2 space-y-4">
<div class="review-meta-grid grid sm:grid-cols-3 gap-2">
<div class="rounded-xl bg-slate-50 border border-slate-200 px-3 py-2"><p class="text-[10px] font-black text-slate-400 uppercase">Citizen</p><p class="text-sm font-bold text-slate-800"><%= esc(c==null?("ID: "+app.getCitizenId()):c.getFullName()) %></p></div>
<div class="rounded-xl bg-slate-50 border border-slate-200 px-3 py-2"><p class="text-[10px] font-black text-slate-400 uppercase">Service</p><p class="text-sm font-bold text-slate-800"><%= esc(s==null?("ID: "+app.getServiceTypeId()):s.getServiceName()) %></p></div>
<div class="rounded-xl bg-slate-50 border border-slate-200 px-3 py-2"><p class="text-[10px] font-black text-slate-400 uppercase">Citizen ID</p><p class="text-sm font-bold text-slate-800"><%= app.getCitizenId() %></p></div>
</div>
<div class="rounded-xl border border-slate-200 bg-slate-50 p-3">
<div class="flex items-center justify-between gap-2 mb-3">
<p class="text-[10px] font-black uppercase tracking-wider text-slate-400">Application Details</p>
<span class="rounded-full bg-white px-2.5 py-1 text-[10px] font-black uppercase tracking-wider text-slate-500"><%= esc(serviceName==null?"Application":serviceName) %></span>
</div>
<% renderStructuredReview(out, serviceName, structuredData, app, c); %>
</div>
<div class="review-doc-grid grid sm:grid-cols-2 gap-2">
<div class="rounded-xl border border-slate-200 p-3"><p class="text-[10px] font-black uppercase tracking-wider text-slate-400 mb-2">Application Documents</p><div class="flex flex-wrap gap-2"><% if(docs.isEmpty()){ %><span class="text-xs font-semibold text-slate-400">None</span><% } else { for(ApplicationDocument d:docs){ String p=d.getFilePath()==null?"#":request.getContextPath()+"/api/files/view?path="+URLEncoder.encode(d.getFilePath(),"UTF-8"); %><a href="<%= esc(p) %>" target="_blank" rel="noopener" class="px-2.5 py-1.5 rounded-lg bg-blue-50 text-blue-700 text-[11px] font-bold"><%= esc(d.getDocumentType()) %></a><% }} %></div></div>
<div class="rounded-xl border border-slate-200 p-3"><p class="text-[10px] font-black uppercase tracking-wider text-slate-400 mb-2">Vault Documents</p><div class="flex flex-wrap gap-2"><% if(vdocs.isEmpty()){ %><span class="text-xs font-semibold text-slate-400">None</span><% } else { for(CitizenDocumentVault d:vdocs){ String p=d.getFilePath()==null?"#":request.getContextPath()+"/api/files/view?path="+URLEncoder.encode(d.getFilePath(),"UTF-8"); %><a href="<%= esc(p) %>" target="_blank" rel="noopener" class="px-2.5 py-1.5 rounded-lg bg-emerald-50 text-emerald-700 text-[11px] font-bold"><%= esc(d.getDocumentType()) %></a><% }} %></div></div>
</div></div>
<div class="order-first lg:order-none rounded-xl border border-slate-200 bg-slate-50 p-3">
<form method="post" action="<%= request.getContextPath() %>/api/admin/applications" class="space-y-2.5">
<input type="hidden" name="redirectTo" value="/admin/applications"><input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>"><input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>">
<label class="text-[10px] font-black uppercase tracking-wider text-slate-400">Review Remarks</label>
<textarea name="remarks" rows="4" placeholder="Write review remarks..." class="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm resize-none"><%= esc(app.getRemarks()) %></textarea>
<% if("approved".equals(app.getStatus())){ %>
<div class="rounded-xl border border-emerald-200 bg-emerald-50 px-3 py-3 text-xs font-bold text-emerald-700">This application has already been approved and updated in the approved section.</div>
<button class="w-full rounded-xl bg-slate-200 text-slate-500 py-3 text-xs font-black uppercase tracking-wider cursor-not-allowed" type="button" disabled>Application Approved</button>
<% } else if("rejected".equals(app.getStatus())){ %>
<div class="rounded-xl border border-rose-200 bg-rose-50 px-3 py-3 text-xs font-bold text-rose-700">This application is rejected. The citizen must edit and resubmit it before it can be reviewed again.</div>
<button class="w-full rounded-xl bg-slate-200 text-slate-500 py-3 text-xs font-black uppercase tracking-wider cursor-not-allowed" type="button" disabled>Application Rejected</button>
<% } else { %>
<div class="review-action-grid grid grid-cols-2 gap-2"><button name="status" value="review" class="rounded-xl bg-amber-100 text-amber-700 py-2.5 text-[10px] font-black uppercase" type="submit">Mark Review</button><button name="status" value="rejected" class="rounded-xl bg-rose-100 text-rose-700 py-2.5 text-[10px] font-black uppercase" type="submit">Reject</button></div>
<button name="status" value="approved" class="w-full rounded-xl bg-brand-900 text-white py-3 text-xs font-black uppercase tracking-wider" type="submit">Approve Application</button>
<% } %>
</form>
<% if("approved".equals(app.getStatus())){ %>
<% if(certificateIssued){ %>
<div class="mt-2.5 rounded-xl border border-blue-200 bg-blue-50 px-3 py-3 text-xs font-bold text-blue-700">Certificate already issued for this application. Certificate no: <%= esc(issuedCertificate.getCertificateNo()) %>.</div>
<button class="mt-2.5 w-full rounded-xl bg-slate-200 text-slate-500 py-3 text-xs font-black uppercase tracking-wider cursor-not-allowed" type="button" disabled>Certificate Issued</button>
<a href="<%= request.getContextPath() %>/api/certificates/view/<%= app.getApplicationId() %>" target="_blank" rel="noopener" class="mt-2.5 flex w-full items-center justify-center rounded-xl border border-emerald-200 bg-white py-3 text-xs font-black uppercase tracking-wider text-emerald-700">View Issued Certificate</a>
<% } else { %>
<div class="mt-2.5 rounded-xl border border-emerald-200 bg-emerald-50 px-3 py-3 text-xs font-bold text-emerald-700">This application is approved. You can issue the certificate now.</div>
<form method="post" action="<%= request.getContextPath() %>/api/certificates" class="mt-2.5"><input type="hidden" name="redirectTo" value="/admin/applications"><input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>"><input type="hidden" name="adminId" value="<%= adminId==null?"":adminId %>"><button class="w-full rounded-xl bg-emerald-600 text-white py-3 text-xs font-black uppercase tracking-wider" type="submit">Issue Certificate</button></form>
<% } %>
<% } %></div></div>
</div>
</div>
</div>
</div><% } if(!any){ %>
<div class="rounded-2xl border border-dashed border-slate-300 bg-slate-50 p-12 text-center text-sm font-semibold text-slate-500">No applications match this filter.</div><% } %>
</div></main></div></div>
<%@ include file="../includes/responsive-scripts.jsp" %>
<script>
function openApplicationModal(modalId){
  const modal = document.getElementById(modalId);
  if(!modal) return;
  modal.classList.remove("hidden");
  document.body.classList.add("overflow-hidden");
}

function closeApplicationModal(modalId){
  const modal = document.getElementById(modalId);
  if(!modal) return;
  modal.classList.add("hidden");
  if(!document.querySelector('[id^="application-modal-"]:not(.hidden)')){
    document.body.classList.remove("overflow-hidden");
  }
}

document.addEventListener("keydown", function(event){
  if(event.key !== "Escape") return;
  const openModal = document.querySelector('[id^="application-modal-"]:not(.hidden)');
  if(openModal){
    closeApplicationModal(openModal.id);
  }
});

lucide.createIcons();
</script>
</body></html>
