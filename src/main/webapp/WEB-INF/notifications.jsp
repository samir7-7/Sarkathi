<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId");String citizenName=(String)request.getAttribute("citizenName");if(citizenName==null)citizenName="Citizen"; %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Notifications - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<div class="flex min-h-screen">
<aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
    <div class="px-5 pt-5 pb-2"><a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a></div>
    <nav class="mt-6 flex-1 space-y-1 px-3">
        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="layout-dashboard" class="h-[18px] w-[18px]"></i>Dashboard</a>
        <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="file-plus" class="h-[18px] w-[18px]"></i>Apply for Service</a>
        <a href="<%= request.getContextPath() %>/citizen/notifications" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="bell" class="h-[18px] w-[18px]"></i>Notifications</a>
        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="ml-[220px] flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Notification Center</h1><p class="text-xs text-slate-500">Stay updated on your application status</p></div>
        <button onclick="markAllRead()" class="rounded-xl border border-slate-200 px-4 py-2 text-xs font-semibold text-brand-900 hover:bg-brand-50 transition">Mark All as Read</button>
    </header>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
        <div class="max-w-2xl mx-auto">
            <div id="notif-container" class="space-y-3"><p class="text-center py-8 text-slate-400">Loading notifications...</p></div>
        </div>
    </main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const CID=<%= citizenId %>;
function fmtDate(d){if(!d)return'';const dt=new Date(d);const now=new Date();const diff=now-dt;if(diff<3600000)return Math.floor(diff/60000)+' min ago';if(diff<86400000)return Math.floor(diff/3600000)+' hrs ago';return dt.toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'});}

function loadNotifications(){
    fetch(CTX+'/api/notifications?citizenId='+CID).then(r=>r.json()).then(data=>{
        const notifs=data.notifications||[];
        const container=document.getElementById('notif-container');
        if(notifs.length===0){container.innerHTML='<div class="rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm"><i data-lucide="bell-off" class="h-12 w-12 mx-auto text-slate-300 mb-4"></i><p class="text-slate-500">No notifications yet</p></div>';lucide.createIcons();return;}
        container.innerHTML='';
        notifs.forEach(n=>{
            container.innerHTML+='<div class="flex items-start gap-4 rounded-2xl border '+(n.read?'border-slate-100 bg-white':'border-blue-100 bg-blue-50/40')+' p-5 shadow-sm transition hover:shadow-md cursor-pointer" onclick="markRead('+n.notificationId+')">'
                +'<div class="mt-0.5 flex h-10 w-10 shrink-0 items-center justify-center rounded-xl '+(n.read?'bg-slate-100 text-slate-400':'bg-brand-900 text-white')+'"><i data-lucide="'+(n.applicationId>0?'file-text':'megaphone')+'" class="h-5 w-5"></i></div>'
                +'<div class="flex-1"><p class="text-sm '+(n.read?'text-slate-600':'text-slate-800 font-semibold')+'">'+n.message+'</p>'
                +'<p class="mt-1.5 text-[11px] text-slate-400">'+fmtDate(n.createdAt)+(n.applicationId>0?' &bull; Application #'+n.applicationId:'')+'</p></div>'
                +(n.read?'':'<span class="mt-1 h-2.5 w-2.5 rounded-full bg-brand-500 shrink-0"></span>')
                +'</div>';
        });
        lucide.createIcons();
    });
}

function markRead(id){
    fetch(CTX+'/api/notifications',{method:'PUT',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'notificationId='+id+'&citizenId='+CID}).then(()=>loadNotifications());
}
function markAllRead(){
    fetch(CTX+'/api/notifications',{method:'PUT',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'markAll=true&citizenId='+CID}).then(()=>loadNotifications());
}
loadNotifications();
</script>
</body></html>
