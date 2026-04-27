<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Integer adminId=(Integer)request.getAttribute("adminId"); %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Manage Agriculture Notices - SarkarSathi Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',500:'#3b82f6',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<div class="flex min-h-screen">
<aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
    <div class="px-5 pt-5 pb-2"><a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a></div>
    <p class="px-5 text-[10px] font-semibold uppercase tracking-wider text-slate-400 mb-2">Admin Panel</p>
    <nav class="flex-1 space-y-1 px-3">
        <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="layout-dashboard" class="h-[18px] w-[18px]"></i>Dashboard</a>
        <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="clipboard-list" class="h-[18px] w-[18px]"></i>Applications</a>
        <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="megaphone" class="h-[18px] w-[18px]"></i>Announcements</a>
        <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="sprout" class="h-[18px] w-[18px]"></i>Agri Notices</a>
        <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="indian-rupee" class="h-[18px] w-[18px]"></i>Budgets</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="ml-[220px] flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Manage Agriculture Notices</h1></div>
        <button onclick="showForm()" class="inline-flex items-center gap-2 rounded-xl bg-brand-900 px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-800"><i data-lucide="plus" class="h-4 w-4"></i>New Notice</button>
    </header>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
        <div id="create-form" class="hidden mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
            <h3 class="text-base font-bold text-slate-900 mb-4">Create Agriculture Notice</h3>
            <div class="space-y-4">
                <div><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Title</label><input id="f-title" type="text" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <div><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Content</label><textarea id="f-content" rows="4" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></textarea></div>
                <div><label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">Category</label>
                    <select id="f-category" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                        <option value="subsidy">Subsidy</option><option value="training">Training</option><option value="scheme">Scheme</option>
                    </select></div>
                <div class="flex gap-3"><button onclick="hideForm()" class="flex-1 rounded-xl border border-slate-200 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-50">Cancel</button>
                <button onclick="createItem()" class="flex-1 rounded-xl bg-brand-900 py-3 text-sm font-semibold text-white hover:bg-brand-800">Publish</button></div>
            </div>
        </div>
        <div id="list" class="space-y-4"><p class="text-center py-8 text-slate-400">Loading...</p></div>
    </main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const AID=<%= adminId %>;
const catColors={subsidy:'bg-green-50 text-green-700',training:'bg-purple-50 text-purple-700',scheme:'bg-blue-50 text-blue-700'};
function showForm(){document.getElementById('create-form').classList.remove('hidden');}
function hideForm(){document.getElementById('create-form').classList.add('hidden');}

function loadItems(){
    fetch(CTX+'/api/agriculture-notices').then(r=>r.json()).then(items=>{
        const el=document.getElementById('list');
        if(!Array.isArray(items)||items.length===0){el.innerHTML='<div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm"><p class="text-slate-500">No notices</p></div>';return;}
        el.innerHTML='';
        items.forEach(n=>{
            const cc=catColors[n.category]||'bg-slate-50 text-slate-600';
            el.innerHTML+='<div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">'
                +'<div class="flex items-start justify-between"><div class="flex-1"><div class="flex items-center gap-3 mb-2"><h3 class="text-base font-bold text-slate-900">'+n.title+'</h3>'
                +'<span class="rounded-full '+cc+' px-3 py-1 text-[11px] font-bold uppercase tracking-wider">'+n.category+'</span></div>'
                +'<p class="text-sm text-slate-600">'+n.content+'</p>'
                +'<p class="mt-2 text-xs text-slate-400">'+(n.publishedAt?new Date(n.publishedAt).toLocaleDateString():'')+'</p></div>'
                +'<button onclick="deleteItem('+n.noticeId+')" class="ml-4 rounded-lg border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-600 hover:bg-red-50"><i data-lucide="trash-2" class="h-3 w-3 inline"></i></button>'
                +'</div></div>';
        });
        lucide.createIcons();
    });
}

async function createItem(){
    const params=new URLSearchParams();params.append('adminId',AID);
    params.append('title',document.getElementById('f-title').value);
    params.append('content',document.getElementById('f-content').value);
    params.append('category',document.getElementById('f-category').value);
    const res=await fetch(CTX+'/api/agriculture-notices',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:params.toString()});
    const data=await res.json();if(data.success){hideForm();loadItems();}else{alert(data.message||'Failed');}
}

async function deleteItem(id){
    if(!confirm('Delete this notice?'))return;
    await fetch(CTX+'/api/agriculture-notices',{method:'DELETE',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'noticeId='+id});
    loadItems();
}
loadItems();
</script>
</body></html>
