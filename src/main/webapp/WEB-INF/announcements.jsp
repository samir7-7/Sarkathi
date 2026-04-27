<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Announcements - SarkarSathi</title>
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
            <a href="<%= request.getContextPath() %>/announcements" class="text-brand-900 font-semibold">Announcements</a>
            <a href="<%= request.getContextPath() %>/agriculture" class="hover:text-brand-900 transition">Agriculture</a>
            <a href="<%= request.getContextPath() %>/budget" class="hover:text-brand-900 transition">Budget</a>
            <a href="<%= request.getContextPath() %>/crop-advisory" class="hover:text-brand-900 transition">Crop Advisory</a>
        </div>
        <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-brand-800 transition">Login</a>
    </nav>
</header>
<main class="px-6 py-12 lg:px-12">
    <div class="mx-auto max-w-4xl">
        <div class="text-center mb-12"><h1 class="text-4xl font-bold text-slate-900">Public Announcements</h1><p class="mt-3 text-lg text-slate-500">Stay informed about municipal events and updates</p></div>
        <div id="list" class="space-y-4"><p class="text-center py-8 text-slate-400">Loading announcements...</p></div>
    </div>
</main>
<script>
lucide.createIcons();
fetch('<%= request.getContextPath() %>/api/announcements').then(r=>r.json()).then(items=>{
    const el=document.getElementById('list');
    if(!Array.isArray(items)||items.length===0){el.innerHTML='<div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm"><i data-lucide="radio" class="h-12 w-12 mx-auto text-slate-300 mb-4"></i><p class="text-slate-500">No announcements at this time</p></div>';lucide.createIcons();return;}
    el.innerHTML='';
    items.forEach(a=>{
        el.innerHTML+='<article class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm hover:shadow-md transition">'
            +'<div class="flex items-start gap-4"><div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-blue-50 text-blue-600"><i data-lucide="megaphone" class="h-5 w-5"></i></div>'
            +'<div class="flex-1"><h3 class="text-lg font-bold text-slate-900">'+a.title+'</h3>'
            +'<p class="mt-2 text-sm text-slate-600 leading-relaxed">'+a.content+'</p>'
            +'<div class="mt-3 flex items-center gap-4 text-xs text-slate-400">'
            +'<span><i data-lucide="calendar" class="h-3 w-3 inline mr-1"></i>'+(a.publishedAt?new Date(a.publishedAt).toLocaleDateString('en-US',{month:'long',day:'numeric',year:'numeric'}):'')+'</span>'
            +(a.eventDate?'<span class="inline-flex items-center gap-1 rounded-full bg-amber-50 px-2.5 py-1 font-semibold text-amber-700"><i data-lucide="clock" class="h-3 w-3"></i>Event: '+new Date(a.eventDate).toLocaleDateString()+'</span>':'')
            +'</div></div></div></article>';
    });
    lucide.createIcons();
});
</script>
</body></html>
