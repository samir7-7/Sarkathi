<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer citizenId = (Integer) request.getAttribute("citizenId");
    String citizenName = (String) request.getAttribute("citizenName");
    String citizenEmail = (String) request.getAttribute("citizenEmail");
    if (citizenName == null) citizenName = "Citizen";
    if (citizenEmail == null) citizenEmail = "";
    String initials = "";
    for (String p : citizenName.split(" ")) { if (!p.isEmpty()) initials += p.charAt(0); }
    if (initials.length() > 2) initials = initials.substring(0, 2);
    initials = initials.toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citizen Dashboard - SarkarSathi</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body{font-family:'Outfit',sans-serif}
        .sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
        .card-hover{transition:all .25s}.card-hover:hover{transform:translateY(-2px);box-shadow:0 8px 25px -5px rgba(0,0,0,.08)}
        @keyframes fadeInUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
        .fade-in{animation:fadeInUp .4s ease-out forwards}
    </style>
</head>
<body class="bg-[#fafafc] text-slate-800">
<div class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
        <div class="flex items-center gap-1.5 px-5 pt-5 pb-2">
            <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a>
        </div>
        <div class="mx-5 mt-3 flex items-center gap-3 rounded-xl bg-brand-50 px-4 py-3">
            <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-white text-xs font-bold"><%= initials %></div>
            <div><p class="text-sm font-semibold text-brand-900 truncate"><%= citizenName %></p><p class="text-[11px] text-slate-500">Citizen</p></div>
        </div>
        <nav class="mt-6 flex-1 space-y-1 px-3">
            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="layout-dashboard" class="h-[18px] w-[18px]"></i>Dashboard</a>
            <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="file-plus" class="h-[18px] w-[18px]"></i>Apply for Service</a>
            <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="search" class="h-[18px] w-[18px]"></i>Track Application</a>
            <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="credit-card" class="h-[18px] w-[18px]"></i>Payments & Tax</a>
            <a href="<%= request.getContextPath() %>/citizen/notifications" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="bell" class="h-[18px] w-[18px]"></i>Notifications <span id="notif-badge" class="ml-auto hidden rounded-full bg-red-500 px-2 py-0.5 text-[10px] font-bold text-white"></span></a>
            <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
            <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="folder" class="h-[18px] w-[18px]"></i>My Documents</a>
        </nav>
        <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3">
            <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="ml-[220px] flex-1 flex flex-col min-h-screen">
        <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
            <div><h1 class="text-lg font-bold text-slate-900">Welcome back, <%= citizenName %></h1><p class="text-xs text-slate-500"><%= citizenEmail %></p></div>
            <div class="flex items-center gap-3">
                <a href="<%= request.getContextPath() %>/citizen/apply" class="inline-flex items-center gap-2 rounded-xl bg-brand-900 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-brand-800"><i data-lucide="plus" class="h-4 w-4"></i>New Application</a>
            </div>
        </header>
        <main class="flex-1 px-8 py-8 overflow-y-auto">
            <!-- Stats -->
            <div class="mb-8 grid grid-cols-2 gap-4 lg:grid-cols-4 fade-in">
                <div class="card-hover rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                    <div class="flex items-center justify-between"><p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">My Applications</p><div class="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-50 text-blue-500"><i data-lucide="file-text" class="h-4 w-4"></i></div></div>
                    <span class="mt-3 block text-3xl font-bold text-slate-900" id="stat-apps">—</span>
                </div>
                <div class="card-hover rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                    <div class="flex items-center justify-between"><p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Approved</p><div class="flex h-8 w-8 items-center justify-center rounded-lg bg-green-50 text-green-500"><i data-lucide="check-circle-2" class="h-4 w-4"></i></div></div>
                    <span class="mt-3 block text-3xl font-bold text-green-600" id="stat-approved">—</span>
                </div>
                <div class="card-hover rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                    <div class="flex items-center justify-between"><p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Pending</p><div class="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-50 text-amber-500"><i data-lucide="clock" class="h-4 w-4"></i></div></div>
                    <span class="mt-3 block text-3xl font-bold text-amber-600" id="stat-pending">—</span>
                </div>
                <div class="card-hover rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
                    <div class="flex items-center justify-between"><p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Certificates</p><div class="flex h-8 w-8 items-center justify-center rounded-lg bg-purple-50 text-purple-500"><i data-lucide="award" class="h-4 w-4"></i></div></div>
                    <span class="mt-3 block text-3xl font-bold text-purple-600" id="stat-certs">—</span>
                </div>
            </div>

            <!-- Quick Actions + Recent Applications -->
            <div class="mb-8 grid gap-6 lg:grid-cols-[340px_1fr]">
                <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm fade-in">
                    <h2 class="text-lg font-bold text-slate-900">Quick Actions</h2>
                    <div class="mt-5 space-y-2">
                        <a href="<%= request.getContextPath() %>/citizen/apply" class="flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3.5 transition hover:bg-brand-50">
                            <div class="flex items-center gap-3"><div class="flex h-9 w-9 items-center justify-center rounded-lg bg-blue-50 text-blue-600"><i data-lucide="file-plus" class="h-4 w-4"></i></div><span class="text-sm font-medium text-slate-700">Apply for Certificate</span></div>
                            <i data-lucide="arrow-right" class="h-4 w-4 text-slate-400"></i>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3.5 transition hover:bg-brand-50">
                            <div class="flex items-center gap-3"><div class="flex h-9 w-9 items-center justify-center rounded-lg bg-amber-50 text-amber-600"><i data-lucide="search" class="h-4 w-4"></i></div><span class="text-sm font-medium text-slate-700">Track Application</span></div>
                            <i data-lucide="arrow-right" class="h-4 w-4 text-slate-400"></i>
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/payments" class="flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3.5 transition hover:bg-brand-50">
                            <div class="flex items-center gap-3"><div class="flex h-9 w-9 items-center justify-center rounded-lg bg-green-50 text-green-600"><i data-lucide="credit-card" class="h-4 w-4"></i></div><span class="text-sm font-medium text-slate-700">Pay Taxes</span></div>
                            <i data-lucide="arrow-right" class="h-4 w-4 text-slate-400"></i>
                        </a>
                        <a href="<%= request.getContextPath() %>/crop-advisory" class="flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3.5 transition hover:bg-brand-50">
                            <div class="flex items-center gap-3"><div class="flex h-9 w-9 items-center justify-center rounded-lg bg-emerald-50 text-emerald-600"><i data-lucide="sprout" class="h-4 w-4"></i></div><span class="text-sm font-medium text-slate-700">Crop Advisory</span></div>
                            <i data-lucide="arrow-right" class="h-4 w-4 text-slate-400"></i>
                        </a>
                    </div>
                </div>

                <!-- Recent Notifications -->
                <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm fade-in">
                    <div class="flex items-center justify-between"><h2 class="text-lg font-bold text-slate-900">Recent Notifications</h2><a href="<%= request.getContextPath() %>/citizen/notifications" class="text-sm font-semibold text-brand-500 hover:text-brand-900">View All</a></div>
                    <div class="mt-5 space-y-1" id="notif-list"><p class="text-sm text-slate-400 py-4 text-center">Loading...</p></div>
                </div>
            </div>

            <!-- Recent Applications Table -->
            <div class="rounded-2xl border border-slate-100 bg-white shadow-sm fade-in">
                <div class="px-6 pt-6 pb-4 flex items-center justify-between"><h2 class="text-lg font-bold text-slate-900">My Applications</h2><a href="<%= request.getContextPath() %>/citizen/tracking" class="text-sm font-semibold text-brand-500 hover:text-brand-900">View All</a></div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm">
                        <thead><tr class="border-t border-b border-slate-100">
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Tracking ID</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Service</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Date</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Status</th>
                            <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Remarks</th>
                        </tr></thead>
                        <tbody id="apps-body" class="divide-y divide-slate-50"><tr><td colspan="5" class="px-6 py-8 text-center text-sm text-slate-400">Loading applications...</td></tr></tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>
<script>
    lucide.createIcons();
    const CTX = '<%= request.getContextPath() %>';
    const CID = <%= citizenId %>;
    const STATUS_MAP = {submitted:{bg:'bg-blue-50',text:'text-blue-700',label:'Submitted'},review:{bg:'bg-amber-50',text:'text-amber-700',label:'Under Review'},approved:{bg:'bg-green-50',text:'text-green-700',label:'Approved'},rejected:{bg:'bg-red-50',text:'text-red-600',label:'Rejected'}};
    function badge(s){const st=STATUS_MAP[s]||{bg:'bg-slate-100',text:'text-slate-600',label:s};return '<span class="inline-flex rounded-full '+st.bg+' px-3 py-1 text-xs font-semibold '+st.text+'">'+st.label+'</span>';}
    function fmtDate(d){if(!d)return '—';return new Date(d).toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'});}

    // Load applications
    fetch(CTX+'/api/applications?citizenId='+CID).then(r=>r.json()).then(apps=>{
        if(!Array.isArray(apps)){apps=[];}
        document.getElementById('stat-apps').textContent=apps.length;
        document.getElementById('stat-approved').textContent=apps.filter(a=>a.status==='approved').length;
        document.getElementById('stat-pending').textContent=apps.filter(a=>a.status==='submitted'||a.status==='review').length;
        const tbody=document.getElementById('apps-body');
        if(apps.length===0){tbody.innerHTML='<tr><td colspan="5" class="px-6 py-8 text-center text-sm text-slate-400">No applications yet. <a href="'+CTX+'/citizen/apply" class="text-brand-500 font-semibold">Apply now</a></td></tr>';return;}
        tbody.innerHTML='';
        apps.slice(0,10).forEach(a=>{
            const tr=document.createElement('tr');tr.className='hover:bg-slate-50 transition';
            tr.innerHTML='<td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#'+a.trackingId+'</td>'
                +'<td class="whitespace-nowrap px-6 py-4 text-slate-600">'+(a.serviceName||('Service #'+a.serviceTypeId))+'</td>'
                +'<td class="whitespace-nowrap px-6 py-4 text-slate-500">'+fmtDate(a.submittedAt)+'</td>'
                +'<td class="whitespace-nowrap px-6 py-4">'+badge(a.status)+'</td>'
                +'<td class="whitespace-nowrap px-6 py-4 text-slate-500 max-w-[200px] truncate">'+(a.remarks||'—')+'</td>';
            tbody.appendChild(tr);
        });
    }).catch(()=>{document.getElementById('apps-body').innerHTML='<tr><td colspan="5" class="px-6 py-8 text-center text-sm text-red-400">Failed to load</td></tr>';});

    // Load certificates count
    fetch(CTX+'/api/certificates/citizen/'+CID).then(r=>r.json()).then(certs=>{
        document.getElementById('stat-certs').textContent=Array.isArray(certs)?certs.length:0;
    }).catch(()=>{document.getElementById('stat-certs').textContent='0';});

    // Load notifications
    fetch(CTX+'/api/notifications?citizenId='+CID).then(r=>r.json()).then(data=>{
        const notifs=data.notifications||[];const unread=data.unreadCount||0;
        if(unread>0){const b=document.getElementById('notif-badge');b.textContent=unread;b.classList.remove('hidden');}
        const container=document.getElementById('notif-list');
        if(notifs.length===0){container.innerHTML='<p class="text-sm text-slate-400 py-4 text-center">No notifications</p>';return;}
        container.innerHTML='';
        notifs.slice(0,5).forEach(n=>{
            container.innerHTML+='<div class="flex items-start gap-3 rounded-xl px-4 py-3 '+(n.read?'':'bg-blue-50/50')+'">'
                +'<div class="mt-0.5 flex h-7 w-7 shrink-0 items-center justify-center rounded-full '+(n.read?'bg-slate-100 text-slate-400':'bg-brand-900 text-white')+'"><i data-lucide="bell" class="h-3.5 w-3.5"></i></div>'
                +'<div><p class="text-sm text-slate-700">'+n.message+'</p><p class="mt-1 text-[11px] text-slate-400">'+fmtDate(n.createdAt)+'</p></div></div>';
        });
        lucide.createIcons();
    }).catch(()=>{});
</script>
</body>
</html>
