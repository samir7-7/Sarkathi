<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Budget Transparency - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}.bar{transition:width .8s ease-out}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<header class="border-b border-slate-200 bg-white px-6 lg:px-12">
    <nav class="mx-auto flex max-w-7xl items-center justify-between py-4">
        <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">Sarkar<span class="text-brand-500">Sathi</span></a>
        <div class="hidden items-center gap-8 text-sm font-medium text-slate-600 lg:flex">
            <a href="<%= request.getContextPath() %>/announcements" class="hover:text-brand-900 transition">Announcements</a>
            <a href="<%= request.getContextPath() %>/agriculture" class="hover:text-brand-900 transition">Agriculture</a>
            <a href="<%= request.getContextPath() %>/budget" class="text-brand-900 font-semibold">Budget</a>
            <a href="<%= request.getContextPath() %>/crop-advisory" class="hover:text-brand-900 transition">Crop Advisory</a>
        </div>
        <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-brand-800 transition">Login</a>
    </nav>
</header>
<main class="px-6 py-12 lg:px-12">
    <div class="mx-auto max-w-5xl">
        <div class="text-center mb-12"><h1 class="text-4xl font-bold text-slate-900">Budget Transparency</h1><p class="mt-3 text-lg text-slate-500">Ward-level financial allocations for the current fiscal year</p></div>
        <!-- Summary Cards -->
        <div class="grid grid-cols-3 gap-4 mb-10" id="summary-cards"></div>
        <!-- Budget Bars -->
        <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm mb-8">
            <h2 class="text-lg font-bold text-slate-900 mb-6">Department-wise Allocation</h2>
            <div id="bars" class="space-y-4"></div>
        </div>
        <!-- Table -->
        <div class="rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
            <div class="px-6 pt-6 pb-4"><h2 class="text-lg font-bold text-slate-900">Detailed Allocations</h2></div>
            <table class="w-full text-left text-sm">
                <thead><tr class="border-t border-b border-slate-100">
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Department</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Ward</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Fiscal Year</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Amount</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Description</th>
                </tr></thead>
                <tbody id="table-body" class="divide-y divide-slate-50"><tr><td colspan="5" class="px-6 py-8 text-center text-sm text-slate-400">Loading...</td></tr></tbody>
            </table>
        </div>
    </div>
</main>
<script>
lucide.createIcons();
const colors=['#3b82f6','#10b981','#f59e0b','#8b5cf6','#ef4444','#06b6d4','#ec4899'];
fetch('<%= request.getContextPath() %>/api/budgets').then(r=>r.json()).then(items=>{
    if(!Array.isArray(items)){items=[];}
    // Summary
    const total=items.reduce((s,b)=>s+Number(b.allocatedAmount),0);
    const depts=[...new Set(items.map(b=>b.department))];
    const wards=[...new Set(items.map(b=>b.wardId))];
    document.getElementById('summary-cards').innerHTML=
        '<div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm text-center"><p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Total Budget</p><p class="mt-2 text-2xl font-bold text-brand-900">Rs. '+total.toLocaleString()+'</p></div>'
        +'<div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm text-center"><p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Departments</p><p class="mt-2 text-2xl font-bold text-slate-900">'+depts.length+'</p></div>'
        +'<div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm text-center"><p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Wards Covered</p><p class="mt-2 text-2xl font-bold text-slate-900">'+wards.length+'</p></div>';

    // Department bars
    const deptTotals={};items.forEach(b=>{deptTotals[b.department]=(deptTotals[b.department]||0)+Number(b.allocatedAmount);});
    const maxAmt=Math.max(...Object.values(deptTotals),1);
    const barsEl=document.getElementById('bars');barsEl.innerHTML='';
    Object.entries(deptTotals).sort((a,b)=>b[1]-a[1]).forEach(([dept,amt],i)=>{
        const pct=Math.round(amt/maxAmt*100);
        barsEl.innerHTML+='<div><div class="flex justify-between mb-1"><span class="text-sm font-semibold text-slate-700">'+dept+'</span><span class="text-sm font-bold text-slate-900">Rs. '+amt.toLocaleString()+'</span></div>'
            +'<div class="h-4 rounded-full bg-slate-100 overflow-hidden"><div class="bar h-full rounded-full" style="width:0%;background:'+colors[i%colors.length]+'"></div></div></div>';
    });
    setTimeout(()=>document.querySelectorAll('.bar').forEach((b,i)=>{const entries=Object.entries(deptTotals).sort((a,b)=>b[1]-a[1]);b.style.width=Math.round(entries[i][1]/maxAmt*100)+'%';}),100);

    // Table
    const tbody=document.getElementById('table-body');tbody.innerHTML='';
    items.forEach(b=>{
        tbody.innerHTML+='<tr class="hover:bg-slate-50"><td class="px-6 py-4 font-medium text-slate-700">'+b.department+'</td>'
            +'<td class="px-6 py-4 text-slate-600">Ward '+b.wardId+'</td>'
            +'<td class="px-6 py-4 text-slate-600">'+b.fiscalYear+'</td>'
            +'<td class="px-6 py-4 font-semibold text-slate-900">Rs. '+Number(b.allocatedAmount).toLocaleString()+'</td>'
            +'<td class="px-6 py-4 text-slate-500 max-w-[250px] truncate">'+(b.description||'—')+'</td></tr>';
    });
});
</script>
</body></html>
