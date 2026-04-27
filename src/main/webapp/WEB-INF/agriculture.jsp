<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Agriculture Notices - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<header class="border-b border-slate-200 bg-white px-6 lg:px-12">
    <nav class="mx-auto flex max-w-7xl items-center justify-between py-4">
        <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">Sarkar<span class="text-brand-500">Sathi</span></a>
        <div class="hidden items-center gap-8 text-sm font-medium text-slate-600 lg:flex">
            <a href="<%= request.getContextPath() %>/announcements" class="hover:text-brand-900 transition">Announcements</a>
            <a href="<%= request.getContextPath() %>/agriculture" class="text-brand-900 font-semibold">Agriculture</a>
            <a href="<%= request.getContextPath() %>/budget" class="hover:text-brand-900 transition">Budget</a>
            <a href="<%= request.getContextPath() %>/crop-advisory" class="hover:text-brand-900 transition">Crop Advisory</a>
        </div>
        <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-brand-800 transition">Login</a>
    </nav>
</header>
<main class="px-6 py-12 lg:px-12">
    <div class="mx-auto max-w-4xl">
        <div class="text-center mb-8"><h1 class="text-4xl font-bold text-slate-900">Agriculture Notices</h1><p class="mt-3 text-lg text-slate-500">Government schemes, subsidies, and training programs</p></div>
        <!-- Category Filter -->
        <div class="flex justify-center gap-3 mb-8">
            <button onclick="filter('all')" class="filter-btn active rounded-full bg-brand-900 px-5 py-2 text-sm font-semibold text-white" data-cat="all">All</button>
            <button onclick="filter('subsidy')" class="filter-btn rounded-full border border-slate-200 px-5 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50" data-cat="subsidy">Subsidies</button>
            <button onclick="filter('training')" class="filter-btn rounded-full border border-slate-200 px-5 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50" data-cat="training">Training</button>
            <button onclick="filter('scheme')" class="filter-btn rounded-full border border-slate-200 px-5 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50" data-cat="scheme">Schemes</button>
        </div>
        <div id="list" class="space-y-4"><p class="text-center py-8 text-slate-400">Loading...</p></div>
    </div>
</main>
<script>
lucide.createIcons();let allNotices=[];
const catColors={subsidy:{bg:'bg-green-50',text:'text-green-700'},training:{bg:'bg-purple-50',text:'text-purple-700'},scheme:{bg:'bg-blue-50',text:'text-blue-700'}};

fetch('<%= request.getContextPath() %>/api/agriculture-notices').then(r=>r.json()).then(items=>{
    allNotices=Array.isArray(items)?items:[];renderNotices(allNotices);
});

function renderNotices(items){
    const el=document.getElementById('list');
    if(items.length===0){el.innerHTML='<div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm"><p class="text-slate-500">No notices found</p></div>';return;}
    el.innerHTML='';
    items.forEach(n=>{
        const cc=catColors[n.category]||{bg:'bg-slate-50',text:'text-slate-600'};
        el.innerHTML+='<article class="notice-card rounded-2xl border border-slate-100 bg-white p-6 shadow-sm hover:shadow-md transition" data-category="'+n.category+'">'
            +'<div class="flex items-start gap-4"><div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600"><i data-lucide="sprout" class="h-5 w-5"></i></div>'
            +'<div class="flex-1"><div class="flex items-center gap-3 mb-2"><h3 class="text-lg font-bold text-slate-900">'+n.title+'</h3>'
            +'<span class="rounded-full '+cc.bg+' px-3 py-1 text-[11px] font-bold uppercase tracking-wider '+cc.text+'">'+n.category+'</span></div>'
            +'<p class="text-sm text-slate-600 leading-relaxed">'+n.content+'</p>'
            +'<p class="mt-3 text-xs text-slate-400">'+(n.publishedAt?new Date(n.publishedAt).toLocaleDateString('en-US',{month:'long',day:'numeric',year:'numeric'}):'')+'</p>'
            +'</div></div></article>';
    });
    lucide.createIcons();
}

function filter(cat){
    document.querySelectorAll('.filter-btn').forEach(b=>{b.className='filter-btn rounded-full border border-slate-200 px-5 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50';});
    document.querySelector('[data-cat="'+cat+'"]').className='filter-btn active rounded-full bg-brand-900 px-5 py-2 text-sm font-semibold text-white';
    renderNotices(cat==='all'?allNotices:allNotices.filter(n=>n.category===cat));
}
</script>
</body></html>
