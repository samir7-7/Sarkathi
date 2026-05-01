<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Integer citizenId=(Integer)request.getAttribute("citizenId");
String citizenName=(String)request.getAttribute("citizenName");
if(citizenName==null)citizenName="Citizen";
String initials="";
for(String p:citizenName.split(" ")){if(!p.isEmpty())initials+=p.charAt(0);}
if(initials.length()>2)initials=initials.substring(0,2);
initials=initials.toUpperCase();
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Notifications - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<%@ include file="includes/responsive-scripts.jsp" %>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{@keyframes fadeInUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}.fade-in{animation:fadeInUp .4s ease-out forwards}.sidebar-link{transition:all .2s}}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<div class="flex min-h-screen flex-col lg:flex-row">
<aside id="sidebar" class="fixed inset-y-0 left-0 z-30 flex w-[220px] -translate-x-full flex-col border-r border-slate-200 bg-white transition-transform duration-300 lg:static lg:flex lg:translate-x-0">
    <div class="flex items-center justify-between px-5 pt-5 pb-2"><a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a><button onclick="toggleSidebar()" class="p-2 text-slate-600 lg:hidden focus:outline-none"><i data-lucide="x" class="h-6 w-6"></i></button></div>
    <div class="mx-5 mt-3 flex items-center gap-3 rounded-xl bg-brand-50 px-4 py-3">
        <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-white text-xs font-bold"><%= initials %></div>
        <div><p class="text-sm font-semibold text-brand-900 truncate"><%= citizenName %></p><p class="text-[11px] text-slate-500">Citizen</p></div>
    </div>
    <nav class="mt-6 flex-1 space-y-1 px-3">
        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="layout-dashboard" class="h-[18px] w-[18px]"></i>Dashboard</a>
        <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="file-plus" class="h-[18px] w-[18px]"></i>Apply for Service</a>
        <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="search" class="h-[18px] w-[18px]"></i>Track Application</a>
        <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="credit-card" class="h-[18px] w-[18px]"></i>Payments & Tax</a>
        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
        <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="folder" class="h-[18px] w-[18px]"></i>My Documents</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-4 py-3.5 lg:px-8"><div class="flex items-center gap-4"><button onclick="toggleSidebar()" class="p-2 text-slate-600 lg:hidden focus:outline-none"><i data-lucide="menu" class="h-6 w-6"></i></button>
        <div><h1 class="text-lg font-bold text-slate-900">Notification Center</h1><p class="text-xs text-slate-500 hidden sm:block">Stay updated on your application status</p></div>
        <div class="flex items-center gap-3">
            <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-10 w-10 items-center justify-center rounded-xl border border-brand-200 bg-brand-50 text-brand-900">
                <i data-lucide="bell" class="h-4 w-4"></i>
                <span id="top-notif-badge" class="absolute -right-1 -top-1 hidden min-w-[18px] rounded-full bg-red-500 px-1.5 py-0.5 text-center text-[10px] font-bold text-white"></span>
            </a>
            <button onclick="markAllRead()" class="rounded-xl border border-slate-200 px-4 py-2 text-xs font-semibold text-brand-900 hover:bg-brand-50 transition">Mark All as Read</button>
        </div>
    </header>
    <main class="flex-1 px-4 py-6 md:px-8 md:py-8 overflow-y-auto"><div class="w-full fade-in">
        <div class="w-full">
            <div id="notif-container" class="space-y-3"><p class="text-center py-8 text-slate-400">Loading notifications...</p></div>
        </div>
    </div></main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const CID=<%= citizenId %>;
function fmtDate(d){if(!d)return'';const dt=new Date(d);const now=new Date();const diff=now-dt;if(diff<3600000)return Math.floor(diff/60000)+' min ago';if(diff<86400000)return Math.floor(diff/3600000)+' hrs ago';return dt.toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'});}

function loadNotifications(){
    fetch(CTX+'/api/notifications?citizenId='+CID).then(r=>r.json()).then(data=>{
        const notifs=data.notifications||[];
        const unread=data.unreadCount||0;
        const badge=document.getElementById('top-notif-badge');
        if(unread>0){badge.textContent=unread;badge.classList.remove('hidden');}else{badge.classList.add('hidden');}
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