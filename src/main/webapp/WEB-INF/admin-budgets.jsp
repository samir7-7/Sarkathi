<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Integer adminId=(Integer)request.getAttribute("adminId");
String adminName=(String)request.getAttribute("adminName");
String adminRole=(String)request.getAttribute("adminRole");
if(adminName==null)adminName="Admin";
if(adminRole==null)adminRole="admin";
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Manage Budgets - SarkarSathi Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',500:'#3b82f6',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<div class="flex min-h-screen">
<aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
    <div class="flex items-center gap-1.5 px-5 pt-5 pb-2">
        <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a>
        <span class="text-xl font-bold text-brand-500">Admin</span>
    </div>
    <div class="mx-5 mt-3 flex items-center gap-3 rounded-xl bg-brand-50 px-4 py-3">
        <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-white">
            <i data-lucide="landmark" class="h-4 w-4"></i>
        </div>
        <div>
            <p class="text-sm font-semibold text-brand-900"><%= adminName %></p>
            <p class="text-[11px] text-slate-500"><%= adminRole.substring(0,1).toUpperCase()+adminRole.substring(1) %></p>
        </div>
    </div>
    <nav class="mt-6 flex-1 space-y-1 px-3">
        <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="layout-dashboard" class="h-[18px] w-[18px]"></i>Dashboard</a>
        <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="clipboard-list" class="h-[18px] w-[18px]"></i>Applications</a>
        <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="megaphone" class="h-[18px] w-[18px]"></i>Announcements</a>
        <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="sprout" class="h-[18px] w-[18px]"></i>Agri Notices</a>
        <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="indian-rupee" class="h-[18px] w-[18px]"></i>Budgets</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="ml-[220px] flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Manage Budget Allocations</h1></div>
        <button onclick="showForm()" class="inline-flex items-center gap-2 rounded-xl bg-brand-900 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-800"><i data-lucide="plus" class="h-4 w-4"></i>Add Allocation</button>
    </header>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
        <div id="create-form" class="hidden mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
            <h3 class="text-base font-bold text-slate-900 mb-4">New Budget Allocation</h3>
            <div class="grid md:grid-cols-2 gap-4">
                <div><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Department</label><input id="f-dept" type="text" placeholder="e.g., Education, Health" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <div><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Ward ID</label><input id="f-ward" type="number" value="1" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <div><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Allocated Amount (Rs.)</label><input id="f-amount" type="number" placeholder="500000" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <div><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Fiscal Year</label><input id="f-fy" type="text" placeholder="2082/83" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <div class="md:col-span-2"><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Description</label><input id="f-desc" type="text" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
            </div>
            <div class="flex gap-3 mt-4"><button onclick="hideForm()" class="flex-1 rounded-xl border border-slate-200 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-50">Cancel</button>
            <button onclick="createItem()" class="flex-1 rounded-xl bg-brand-900 py-3 text-sm font-semibold text-white hover:bg-brand-800">Add Allocation</button></div>
        </div>
        <!-- Table -->
        <div class="rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
            <table class="w-full text-left text-sm">
                <thead><tr class="border-b border-slate-100">
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Department</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Ward</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Amount</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Fiscal Year</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Description</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Actions</th>
                </tr></thead>
                <tbody id="table-body" class="divide-y divide-slate-50"><tr><td colspan="6" class="px-6 py-8 text-center text-sm text-slate-400">Loading...</td></tr></tbody>
            </table>
        </div>
    </main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const AID=<%= adminId == null ? "null" : adminId %>;
function showForm(){document.getElementById('create-form').classList.remove('hidden');}
function hideForm(){document.getElementById('create-form').classList.add('hidden');}
function requireAdminSession(){if(AID!==null)return true;alert('Your admin session has expired. Please log in again.');window.location.href=CTX+'/login?userType=admin';return false;}

function loadItems(){
    fetch(CTX+'/api/budgets').then(r=>r.json()).then(items=>{
        const tbody=document.getElementById('table-body');
        if(!Array.isArray(items)||items.length===0){tbody.innerHTML='<tr><td colspan="6" class="px-6 py-8 text-center text-sm text-slate-400">No allocations</td></tr>';return;}
        tbody.innerHTML='';
        items.forEach(b=>{
            tbody.innerHTML+='<tr class="hover:bg-slate-50">'
                +'<td class="px-6 py-4 font-medium text-slate-700">'+b.department+'</td>'
                +'<td class="px-6 py-4 text-slate-600">Ward '+b.wardId+'</td>'
                +'<td class="px-6 py-4 font-semibold text-slate-900">Rs. '+Number(b.allocatedAmount).toLocaleString()+'</td>'
                +'<td class="px-6 py-4 text-slate-600">'+b.fiscalYear+'</td>'
                +'<td class="px-6 py-4 text-slate-500 max-w-[200px] truncate">'+(b.description||'—')+'</td>'
                +'<td class="px-6 py-4"><button onclick="deleteItem('+b.budgetId+')" class="rounded-lg border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-600 hover:bg-red-50"><i data-lucide="trash-2" class="h-3 w-3 inline"></i></button></td></tr>';
        });
        lucide.createIcons();
    });
}

async function createItem(){
    if(!requireAdminSession())return;
    const params=new URLSearchParams();
    params.append('wardId',document.getElementById('f-ward').value);
    params.append('department',document.getElementById('f-dept').value);
    params.append('allocatedAmount',document.getElementById('f-amount').value);
    params.append('fiscalYear',document.getElementById('f-fy').value);
    params.append('description',document.getElementById('f-desc').value);
    const res=await fetch(CTX+'/api/budgets',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:params.toString()});
    const data=await res.json();if(data.success){hideForm();loadItems();}else{alert(data.message||'Failed');}
}

async function deleteItem(id){
    if(!requireAdminSession())return;
    if(!confirm('Delete this allocation?'))return;
    await fetch(CTX+'/api/budgets',{method:'DELETE',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'budgetId='+id});
    loadItems();
}
loadItems();
</script>
</body></html>