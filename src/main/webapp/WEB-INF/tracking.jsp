<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Integer citizenId=(Integer)request.getAttribute("citizenId");
String citizenName=(String)request.getAttribute("citizenName");
if(citizenName==null)citizenName="Citizen";
String initials="";
for(String p:citizenName.split(" ")){if(!p.isEmpty())initials+=p.charAt(0);}
if(initials.length()>2)initials=initials.substring(0,2);
initials=initials.toUpperCase();
boolean loggedIn=citizenId!=null;
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Track Application - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}@keyframes fadeInUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}.fade-in{animation:fadeInUp .4s ease-out forwards}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<div class="flex min-h-screen">
<% if(loggedIn){ %>
<aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
    <div class="px-5 pt-5 pb-2"><a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a></div>
    <div class="mx-5 mt-3 flex items-center gap-3 rounded-xl bg-brand-50 px-4 py-3">
        <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-white text-xs font-bold"><%= initials %></div>
        <div><p class="text-sm font-semibold text-brand-900 truncate"><%= citizenName %></p><p class="text-[11px] text-slate-500">Citizen</p></div>
    </div>
    <nav class="mt-6 flex-1 space-y-1 px-3">
        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="layout-dashboard" class="h-[18px] w-[18px]"></i>Dashboard</a>
        <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="file-plus" class="h-[18px] w-[18px]"></i>Apply for Service</a>
        <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="search" class="h-[18px] w-[18px]"></i>Track Application</a>
        <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="credit-card" class="h-[18px] w-[18px]"></i>Payments & Tax</a>
        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
        <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="folder" class="h-[18px] w-[18px]"></i>My Documents</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<% } %>
<div class="<%= loggedIn?"ml-[220px]":"" %> flex-1 flex flex-col min-h-screen">
    <% if(!loggedIn){ %>
    <header class="px-6 pt-6 lg:px-12"><nav class="mx-auto flex max-w-7xl items-center justify-between py-2">
        <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">Sarkar<span class="text-brand-500">Sathi</span></a>
        <a href="<%= request.getContextPath() %>/login" class="inline-flex items-center rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-brand-800">Login</a>
    </nav></header>
    <% } else { %>
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Track Application</h1><p class="text-xs text-slate-500">Check the status of your applications</p></div>
        <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 transition hover:bg-brand-50 hover:text-brand-900">
            <i data-lucide="bell" class="h-4 w-4"></i>
            <span id="top-notif-badge" class="absolute -right-1 -top-1 hidden min-w-[18px] rounded-full bg-red-500 px-1.5 py-0.5 text-center text-[10px] font-bold text-white"></span>
        </a>
    </header>
    <% } %>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
        <div class="w-full fade-in">
            <!-- Search Box -->
            <div class="mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                <h2 class="text-lg font-bold text-slate-900 mb-4">Search by Tracking ID</h2>
                <div class="flex flex-col gap-3 md:flex-row">
                    <input id="tracking-input" type="text" placeholder="Enter Tracking ID (e.g., UDAS-A1B2C3D4)" class="flex-1 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500 focus:ring-2 focus:ring-brand-100">
                    <button onclick="searchTracking()" class="rounded-xl bg-brand-900 px-6 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-brand-800">Search</button>
                </div>
            </div>

            <!-- Search Result -->
            <div id="search-result" class="hidden mb-8"></div>

            <% if(loggedIn){ %>
            <!-- My Applications List -->
            <div class="rounded-2xl border border-slate-100 bg-white shadow-sm">
                <div class="px-6 pt-6 pb-4"><h2 class="text-lg font-bold text-slate-900">All My Applications</h2></div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead><tr class="border-t border-b border-slate-100">
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Tracking ID</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Service</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Submitted</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Last Updated</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Status</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Remarks</th>
                        </tr></thead>
                        <tbody id="apps-body" class="divide-y divide-slate-50"><tr><td colspan="6" class="px-6 py-8 text-center text-sm text-slate-400">Loading...</td></tr></tbody>
                    </table>
                </div>
            </div>
            <% } %>
        </div>
    </main>
</div>
</div>
<script>
lucide.createIcons();
const CTX='<%= request.getContextPath() %>';
<% if(loggedIn){ %>
fetch(CTX+'/api/notifications?citizenId=<%= citizenId %>').then(r=>r.json()).then(data=>{const unread=data.unreadCount||0;if(unread>0){const b=document.getElementById('top-notif-badge');b.textContent=unread;b.classList.remove('hidden');}}).catch(()=>{});
<% } %>
const STATUS={submitted:{bg:'bg-blue-50',text:'text-blue-700',label:'Submitted'},review:{bg:'bg-amber-50',text:'text-amber-700',label:'Under Review'},approved:{bg:'bg-green-50',text:'text-green-700',label:'Approved'},rejected:{bg:'bg-red-50',text:'text-red-600',label:'Rejected'}};
function badge(s){const st=STATUS[s]||{bg:'bg-slate-100',text:'text-slate-600',label:s};return '<span class="inline-flex rounded-full '+st.bg+' px-3 py-1 text-xs font-semibold '+st.text+'">'+st.label+'</span>';}
function fmtDate(d){if(!d)return'—';return new Date(d).toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric',hour:'2-digit',minute:'2-digit'});}

function searchTracking(){
    const tid=document.getElementById('tracking-input').value.trim();if(!tid)return;
    const container=document.getElementById('search-result');
    container.classList.remove('hidden');container.innerHTML='<p class="text-center py-4 text-slate-400">Searching...</p>';
    fetch(CTX+'/api/applications?trackingId='+encodeURIComponent(tid)).then(r=>r.json()).then(data=>{
        const app=data.application;
        if(!app){container.innerHTML='<div class="rounded-2xl border border-red-100 bg-red-50 p-6 text-center"><p class="text-sm text-red-600 font-semibold">No application found with that tracking ID</p></div>';return;}
        const st=STATUS[app.status]||{bg:'bg-slate-100',text:'text-slate-600',label:app.status};
        container.innerHTML='<div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">'
            +'<div class="flex items-center justify-between mb-6"><h3 class="text-lg font-bold text-slate-900">#'+app.trackingId+'</h3>'+badge(app.status)+'</div>'
            +'<div class="grid grid-cols-2 gap-4 text-sm">'
            +'<div><p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1">Submitted</p><p class="font-medium text-slate-700">'+fmtDate(app.submittedAt)+'</p></div>'
            +'<div><p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1">Last Updated</p><p class="font-medium text-slate-700">'+fmtDate(app.lastUpdatedAt)+'</p></div>'
            +'<div><p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1">Service Type</p><p class="font-medium text-slate-700">'+(app.serviceName||('Service #'+app.serviceTypeId))+'</p></div>'
            +'<div><p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1">Ward</p><p class="font-medium text-slate-700">'+(app.wardLabel||('Ward #'+app.wardId))+'</p></div>'
            +'</div>'
            +(app.remarks?'<div class="mt-4 rounded-xl bg-slate-50 p-4"><p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1">Admin Remarks</p><p class="text-sm text-slate-700">'+app.remarks+'</p></div>':'')
            +'<div class="mt-6 flex gap-3">'
            +'<div class="flex-1 text-center rounded-xl py-3 '+(app.status==='submitted'||app.status==='review'||app.status==='approved'?'bg-blue-500 text-white':'bg-slate-100 text-slate-400')+'"><p class="text-xs font-bold">Submitted</p></div>'
            +'<div class="flex-1 text-center rounded-xl py-3 '+(app.status==='review'||app.status==='approved'?'bg-amber-500 text-white':'bg-slate-100 text-slate-400')+'"><p class="text-xs font-bold">In Review</p></div>'
            +'<div class="flex-1 text-center rounded-xl py-3 '+(app.status==='approved'?'bg-green-500 text-white':(app.status==='rejected'?'bg-red-500 text-white':'bg-slate-100 text-slate-400'))+'"><p class="text-xs font-bold">'+(app.status==='rejected'?'Rejected':'Approved')+'</p></div>'
            +'</div></div>';
    }).catch(()=>{container.innerHTML='<p class="text-center py-4 text-red-400">Error searching</p>';});
}

<% if(loggedIn){ %>
// Load all applications
fetch(CTX+'/api/applications?citizenId=<%= citizenId %>').then(r=>r.json()).then(apps=>{
    const tbody=document.getElementById('apps-body');
    if(!Array.isArray(apps)||apps.length===0){tbody.innerHTML='<tr><td colspan="6" class="px-6 py-8 text-center text-sm text-slate-400">No applications found</td></tr>';return;}
    tbody.innerHTML='';
    apps.forEach(a=>{
        const tr=document.createElement('tr');tr.className='hover:bg-slate-50 transition cursor-pointer';
        tr.onclick=()=>{document.getElementById('tracking-input').value=a.trackingId;searchTracking();window.scrollTo({top:0,behavior:'smooth'});};
        tr.innerHTML='<td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#'+a.trackingId+'</td>'
            +'<td class="whitespace-nowrap px-6 py-4 text-slate-600">'+(a.serviceName||('Service #'+a.serviceTypeId))+'</td>'
            +'<td class="whitespace-nowrap px-6 py-4 text-slate-500">'+fmtDate(a.submittedAt)+'</td>'
            +'<td class="whitespace-nowrap px-6 py-4 text-slate-500">'+fmtDate(a.lastUpdatedAt)+'</td>'
            +'<td class="whitespace-nowrap px-6 py-4">'+badge(a.status)+'</td>'
            +'<td class="whitespace-nowrap px-6 py-4 text-slate-500 max-w-[200px] truncate">'+(a.remarks||'—')+'</td>';
        tbody.appendChild(tr);
    });
});
<% } %>
</script>
</body></html>