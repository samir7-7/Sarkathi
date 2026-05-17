<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.BudgetAllocation" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object v){ if(v==null)return ""; return v.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;"); } %>
<%
String adminName=(String)request.getAttribute("adminName");
String adminRole=(String)request.getAttribute("adminRole");
String pageError=(String)request.getAttribute("pageError");
String formError=request.getParameter("error");
List<BudgetAllocation> budgets=(List<BudgetAllocation>)request.getAttribute("budgets");
String editingBudgetId=(String)request.getAttribute("editingBudgetId");
if(budgets==null)budgets=List.of();
if(adminName==null)adminName="Admin";
if(adminRole==null)adminRole="System Controller";
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Budgets - Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"><script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{500:'#3b82f6',900:'#0b3d86'}}}}}</script>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:700}.safe-area-bottom{padding-bottom:env(safe-area-inset-bottom,1.5rem)}.mobile-record-card{border:1px solid #e2e8f0;border-radius:1rem;background:#fff;padding:1rem}</style>
<%@ include file="../includes/lucide-icons.jsp" %></head>
<body class="bg-slate-100 text-slate-900 antialiased overflow-x-hidden">
<div class="flex min-h-screen relative">
<div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden"></div>
<%@ include file="../includes/sidebar-admin.jsp" %>
<div class="flex-1 flex flex-col min-h-screen">
<header class="sticky top-0 z-40 bg-white/90 backdrop-blur border-b border-slate-200 px-4 py-3.5 lg:px-7"><div class="flex items-start justify-between gap-4 sm:items-center"><div class="flex items-start gap-3"><button onclick="toggleSidebar()" class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 shadow-sm transition hover:bg-slate-50 lg:hidden"><i data-lucide="menu" class="h-5 w-5"></i></button><div><h1 class="text-lg font-black tracking-tight text-slate-900">Budget Management</h1><p class="text-[11px] font-semibold text-slate-500">Allocate and track municipal departmental budgets</p></div></div><div class="hidden sm:flex items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2"><div class="h-9 w-9 rounded-full bg-brand-900 flex items-center justify-center text-white text-sm font-bold"><%= adminName.length() > 0 ? adminName.substring(0,1).toUpperCase() : "A" %></div><div><p class="text-sm font-bold text-slate-900"><%= esc(adminName) %></p><p class="text-[11px] font-semibold text-slate-500"><%= esc(adminRole) %></p></div></div></div></header>
<main class="flex-1 w-full p-3 sm:p-4 lg:p-6">
<div class="space-y-5 max-w-6xl">
<% if(pageError!=null || formError!=null){ %><div class="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-xs font-bold text-rose-700"><%= esc(pageError!=null?pageError:formError) %></div><% } %>
<section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
<div class="flex flex-col items-start gap-3 sm:flex-row sm:items-start sm:justify-between"><div class="min-w-0"><h2 class="text-sm font-black uppercase tracking-wider text-slate-900">Create Budget Allocation</h2><p class="mt-1 text-sm text-slate-500">Record department allocations with ward and fiscal-year details in one place.</p></div><span class="rounded-full bg-emerald-50 px-3 py-1 text-[10px] font-black uppercase tracking-wider text-emerald-700"><%= budgets.size() %> Records</span></div>
<form method="post" action="<%= request.getContextPath() %>/api/budgets" class="mt-5 grid gap-4 lg:grid-cols-2 js-budget-form" novalidate>
<input type="hidden" name="redirectTo" value="/admin/budgets">
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Department</span><input name="department" type="text" required maxlength="100" placeholder="Health, Roads, Education..." class="rounded-xl border border-slate-200 px-4 py-3 text-sm"></label>
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Ward ID</span><input name="wardId" type="number" required min="1" step="1" value="1" placeholder="1" class="rounded-xl border border-slate-200 px-4 py-3 text-sm"></label>
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Fiscal Year</span><input name="fiscalYear" type="text" required maxlength="20" pattern="^[0-9]{4}\\/[0-9]{2}$" placeholder="2082/83" class="rounded-xl border border-slate-200 px-4 py-3 text-sm"></label>
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500"><span>Allocated Amount</span><input name="allocatedAmount" type="number" required min="1" step="0.01" placeholder="1000000" class="rounded-xl border border-slate-200 px-4 py-3 text-sm font-semibold"></label>
<label class="grid gap-2 text-xs font-black uppercase tracking-wider text-slate-500 lg:col-span-2"><span>Description</span><input name="description" type="text" maxlength="255" placeholder="Road repair, health outreach, classroom expansion..." class="rounded-xl border border-slate-200 px-4 py-3 text-sm"></label>
<div class="lg:col-span-2 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between"><p class="text-xs font-semibold text-slate-400">Use clear department names and fiscal years to keep the ledger consistent.</p><button class="rounded-xl bg-brand-900 px-5 py-3 text-xs font-black uppercase tracking-wider text-white hover:bg-brand-800" type="submit">Save Allocation</button></div>
</form></section>
<section class="rounded-2xl border border-slate-200 bg-white shadow-sm overflow-hidden">
<div class="border-b border-slate-200 px-5 py-4"><h2 class="text-sm font-black uppercase tracking-wider text-slate-900">Budget Ledger</h2><p class="mt-1 text-xs font-semibold text-slate-500">View, edit, and remove saved budget allocation records.</p></div>
<div class="space-y-3 p-3 sm:hidden"><% if(budgets.isEmpty()){ %><div class="mobile-record-card text-center text-sm font-semibold text-slate-500">No budget records found.</div>
<% } else { for(BudgetAllocation b:budgets){ %>
<article class="mobile-record-card"><div class="flex items-start justify-between gap-3"><div><p class="text-sm font-black text-slate-900"><%= esc(b.getDepartment()) %></p><p class="mt-1 text-[11px] text-slate-500"><%= esc(b.getDescription()==null?"":b.getDescription()) %></p></div><div class="flex gap-2 shrink-0"><form method="get" action="<%= request.getContextPath() %>/admin/budgets"><input type="hidden" name="edit" value="<%= b.getBudgetId() %>"><button class="h-8 w-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center" type="submit"><i data-lucide="edit-2" class="h-4 w-4"></i></button></form><form method="post" action="<%= request.getContextPath() %>/api/budgets" onsubmit="return confirm('Delete this budget record?')"><input type="hidden" name="redirectTo" value="/admin/budgets"><input type="hidden" name="action" value="delete"><input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>"><button class="h-8 w-8 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center" type="submit"><i data-lucide="trash-2" class="h-4 w-4"></i></button></form></div></div><div class="mt-3 grid gap-2 text-sm"><div class="flex items-center justify-between gap-3"><span class="text-slate-400 font-semibold">Ward</span><span class="text-slate-700 font-bold"><%= b.getWardId() %></span></div><div class="flex items-center justify-between gap-3"><span class="text-slate-400 font-semibold">Fiscal Year</span><span class="text-slate-700 font-semibold"><%= esc(b.getFiscalYear()) %></span></div><div class="flex items-center justify-between gap-3"><span class="text-slate-400 font-semibold">Amount</span><span class="text-emerald-600 font-black">Rs. <%= esc(b.getAllocatedAmount()) %></span></div></div></article>
<% if(editingBudgetId!=null && editingBudgetId.equals(String.valueOf(b.getBudgetId()))){ %>
<div class="mobile-record-card bg-slate-50"><form method="post" action="<%= request.getContextPath() %>/api/budgets" class="grid gap-2 js-budget-form" novalidate><input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>"><input type="hidden" name="_method" value="PUT"><input type="hidden" name="redirectTo" value="/admin/budgets"><input name="department" type="text" required maxlength="100" value="<%= esc(b.getDepartment()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="wardId" type="number" required min="1" step="1" value="<%= b.getWardId() %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="fiscalYear" type="text" required maxlength="20" pattern="^[0-9]{4}\\/[0-9]{2}$" value="<%= esc(b.getFiscalYear()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="allocatedAmount" type="number" required min="1" step="0.01" value="<%= esc(b.getAllocatedAmount()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="description" type="text" maxlength="255" value="<%= esc(b.getDescription()==null?"":b.getDescription()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><button class="rounded-xl bg-brand-900 text-white py-2.5 text-xs font-black uppercase">Update</button><a href="<%= request.getContextPath() %>/admin/budgets" class="rounded-xl bg-slate-200 text-slate-700 py-2.5 text-xs font-black uppercase text-center">Cancel</a></form></div>
<% } %>
<% }} %></div>
<div class="hidden sm:block overflow-x-auto"><table class="w-full text-left"><thead><tr class="bg-slate-50"><th class="px-4 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Department</th><th class="px-4 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Ward</th><th class="px-4 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Fiscal</th><th class="px-4 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500 text-right">Amount</th><th class="px-4 py-3 text-[10px] font-black uppercase tracking-wider text-slate-500">Actions</th></tr></thead><tbody class="divide-y divide-slate-100">
<% if(budgets.isEmpty()){ %><tr><td colspan="5" class="px-4 py-12 text-center text-sm font-semibold text-slate-500">No budget records found.</td></tr>
<% } else { for(BudgetAllocation b:budgets){ %>
<tr><td class="px-4 py-3.5"><p class="text-sm font-black text-slate-900"><%= esc(b.getDepartment()) %></p><p class="text-[11px] text-slate-500"><%= esc(b.getDescription()==null?"":b.getDescription()) %></p></td><td class="px-4 py-3.5 text-sm font-bold text-slate-700"><%= b.getWardId() %></td><td class="px-4 py-3.5 text-sm font-semibold text-slate-700"><%= esc(b.getFiscalYear()) %></td><td class="px-4 py-3.5 text-right text-sm font-black text-emerald-600">Rs. <%= esc(b.getAllocatedAmount()) %></td><td class="px-4 py-3.5"><div class="flex gap-2"><form method="get" action="<%= request.getContextPath() %>/admin/budgets"><input type="hidden" name="edit" value="<%= b.getBudgetId() %>"><button class="h-8 w-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center" type="submit"><i data-lucide="edit-2" class="h-4 w-4"></i></button></form><form method="post" action="<%= request.getContextPath() %>/api/budgets" onsubmit="return confirm('Delete this budget record?')"><input type="hidden" name="redirectTo" value="/admin/budgets"><input type="hidden" name="action" value="delete"><input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>"><button class="h-8 w-8 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center" type="submit"><i data-lucide="trash-2" class="h-4 w-4"></i></button></form></div></td></tr>
<% if(editingBudgetId!=null && editingBudgetId.equals(String.valueOf(b.getBudgetId()))){ %>
<tr><td colspan="5" class="px-4 py-4 bg-slate-50"><form method="post" action="<%= request.getContextPath() %>/api/budgets" class="grid gap-2 lg:grid-cols-3 js-budget-form" novalidate><input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>"><input type="hidden" name="_method" value="PUT"><input type="hidden" name="redirectTo" value="/admin/budgets"><input name="department" type="text" required maxlength="100" value="<%= esc(b.getDepartment()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="wardId" type="number" required min="1" step="1" value="<%= b.getWardId() %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="fiscalYear" type="text" required maxlength="20" pattern="^[0-9]{4}\\/[0-9]{2}$" value="<%= esc(b.getFiscalYear()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="allocatedAmount" type="number" required min="1" step="0.01" value="<%= esc(b.getAllocatedAmount()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm"><input name="description" type="text" maxlength="255" value="<%= esc(b.getDescription()==null?"":b.getDescription()) %>" class="rounded-xl border border-slate-200 px-3 py-2.5 text-sm lg:col-span-2"><button class="rounded-xl bg-brand-900 text-white py-2.5 text-xs font-black uppercase">Update</button><a href="<%= request.getContextPath() %>/admin/budgets" class="rounded-xl bg-slate-200 text-slate-700 py-2.5 text-xs font-black uppercase text-center">Cancel</a></form></td></tr>
<% } %>
<% }} %></tbody></table></div></section></div></main></div></div>
<%@ include file="../includes/responsive-scripts.jsp" %>
<script>
lucide.createIcons();

document.querySelectorAll('.js-budget-form').forEach(function(form){
  form.addEventListener('submit', function(event){
    var wardIdInput = form.querySelector('input[name="wardId"]');
    var amountInput = form.querySelector('input[name="allocatedAmount"]');
    var fiscalYearInput = form.querySelector('input[name="fiscalYear"]');

    if(wardIdInput){
      var wardIdValue = Number(wardIdInput.value);
      if(!Number.isInteger(wardIdValue) || wardIdValue < 1){
        wardIdInput.setCustomValidity('Ward ID must be a positive whole number.');
      } else {
        wardIdInput.setCustomValidity('');
      }
    }

    if(amountInput){
      var amountValue = Number(amountInput.value);
      if(!Number.isFinite(amountValue) || amountValue <= 0){
        amountInput.setCustomValidity('Allocated amount must be greater than zero.');
      } else {
        amountInput.setCustomValidity('');
      }
    }

    if(fiscalYearInput){
      var fiscalYearValue = fiscalYearInput.value.trim();
      if(fiscalYearValue !== '' && !/^\d{4}\/\d{2}$/.test(fiscalYearValue)){
        fiscalYearInput.setCustomValidity('Fiscal year must be in the format 2082/83.');
      } else {
        fiscalYearInput.setCustomValidity('');
      }
    }

    if(!form.checkValidity()){
      event.preventDefault();
      form.reportValidity();
    }
  });
});
</script>
</body></html>
