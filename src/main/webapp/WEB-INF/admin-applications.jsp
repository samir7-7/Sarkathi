<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Integer adminId=(Integer)request.getAttribute("adminId");
String adminName=(String)request.getAttribute("adminName");
String adminRole=(String)request.getAttribute("adminRole");
if(adminName==null)adminName="Admin";
if(adminRole==null)adminRole="admin";
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Review Applications - SarkarSathi Admin</title>
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
        <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="clipboard-list" class="h-[18px] w-[18px]"></i>Applications</a>
        <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="megaphone" class="h-[18px] w-[18px]"></i>Announcements</a>
        <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="sprout" class="h-[18px] w-[18px]"></i>Agri Notices</a>
        <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="indian-rupee" class="h-[18px] w-[18px]"></i>Budgets</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="ml-[220px] flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Application Review Panel</h1><p class="text-xs text-slate-500">Review, approve, or reject citizen applications</p></div>
        <div class="flex gap-2">
            <button onclick="filterApps('all')" class="status-filter rounded-lg bg-brand-900 px-4 py-2 text-xs font-semibold text-white" data-f="all">All</button>
            <button onclick="filterApps('submitted')" class="status-filter rounded-lg border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50" data-f="submitted">Submitted</button>
            <button onclick="filterApps('review')" class="status-filter rounded-lg border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50" data-f="review">In Review</button>
            <button onclick="filterApps('approved')" class="status-filter rounded-lg border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50" data-f="approved">Approved</button>
            <button onclick="filterApps('rejected')" class="status-filter rounded-lg border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50" data-f="rejected">Rejected</button>
        </div>
    </header>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
        <!-- Review Modal -->
        <div id="review-modal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
            <div class="w-full max-w-lg rounded-2xl bg-white p-8 shadow-2xl">
                <h3 class="text-lg font-bold text-slate-900 mb-1">Review Application</h3>
                <p class="text-xs text-slate-500 mb-6" id="modal-tracking"></p>
                <div class="mb-4"><p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1">Form Data</p><pre id="modal-form" class="rounded-xl bg-slate-50 p-4 text-xs text-slate-600 max-h-40 overflow-auto whitespace-pre-wrap"></pre></div>
                <div class="mb-4"><p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1">Uploaded Documents</p><div id="modal-docs" class="space-y-2"></div></div>
                <div class="mb-4">
                    <label class="mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800">Decision</label>
                    <div class="grid grid-cols-3 gap-2">
                        <button onclick="setDecision('review')" data-d="review" class="decision-btn rounded-xl border-2 border-slate-100 py-2.5 text-sm font-semibold text-amber-600 transition hover:border-amber-400">In Review</button>
                        <button onclick="setDecision('approved')" data-d="approved" class="decision-btn rounded-xl border-2 border-slate-100 py-2.5 text-sm font-semibold text-green-600 transition hover:border-green-400">Approve</button>
                        <button onclick="setDecision('rejected')" data-d="rejected" class="decision-btn rounded-xl border-2 border-slate-100 py-2.5 text-sm font-semibold text-red-600 transition hover:border-red-400">Reject</button>
                    </div>
                </div>
                <div class="mb-6">
                    <label class="mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800">Remarks</label>
                    <textarea id="modal-remarks" rows="3" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></textarea>
                </div>
                <div class="flex gap-3">
                    <button onclick="closeModal()" class="flex-1 rounded-xl border border-slate-200 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-50">Cancel</button>
                    <button onclick="submitReview()" id="submit-review-btn" class="flex-1 rounded-xl bg-brand-900 py-3 text-sm font-semibold text-white hover:bg-brand-800">Submit Review</button>
                </div>
            </div>
        </div>

        <!-- Applications Table -->
        <div class="rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
            <table class="w-full text-left text-sm">
                <thead><tr class="border-b border-slate-100">
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Tracking ID</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Citizen</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Service</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Date</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Status</th>
                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Actions</th>
                </tr></thead>
                <tbody id="apps-body" class="divide-y divide-slate-50"><tr><td colspan="6" class="px-6 py-8 text-center text-sm text-slate-400">Loading...</td></tr></tbody>
            </table>
        </div>
    </main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const AID=<%= adminId == null ? "null" : adminId %>;
const STATUS={submitted:{bg:'bg-blue-50',text:'text-blue-700',label:'Submitted'},review:{bg:'bg-amber-50',text:'text-amber-700',label:'Under Review'},approved:{bg:'bg-green-50',text:'text-green-700',label:'Approved'},rejected:{bg:'bg-red-50',text:'text-red-600',label:'Rejected'}};
function badge(s){const st=STATUS[s]||{bg:'bg-slate-100',text:'text-slate-600',label:s};return '<span class="inline-flex rounded-full '+st.bg+' px-3 py-1 text-xs font-semibold '+st.text+'">'+st.label+'</span>';}
function fmtDate(d){if(!d)return'—';return new Date(d).toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'});}

function requireAdminSession(){if(AID!==null)return true;alert('Your admin session has expired. Please log in again.');window.location.href=CTX+'/login?userType=admin';return false;}
function docHref(path){if(!path)return'#';return path.startsWith('/')?CTX+path:CTX+'/'+path.replace(/^\/+/,'');}
let allApps=[],currentApp=null,currentDecision=null;

function loadApps(){
    fetch(CTX+'/api/applications').then(r=>r.json()).then(apps=>{
        allApps=Array.isArray(apps)?apps:[];renderApps(allApps);
    });
}

function renderApps(apps){
    const tbody=document.getElementById('apps-body');
    if(apps.length===0){tbody.innerHTML='<tr><td colspan="6" class="px-6 py-8 text-center text-sm text-slate-400">No applications found</td></tr>';return;}
    tbody.innerHTML='';
    apps.forEach((a,index)=>{
        tbody.innerHTML+='<tr class="hover:bg-slate-50 transition">'
            +'<td class="px-6 py-4 font-semibold text-brand-900">#'+a.trackingId+'</td>'
            +'<td class="px-6 py-4 text-slate-600">'+(a.citizenName||('Citizen #'+a.citizenId))+'</td>'
            +'<td class="px-6 py-4 text-slate-600">'+(a.serviceName||('Service #'+a.serviceTypeId))+'</td>'
            +'<td class="px-6 py-4 text-slate-500">'+fmtDate(a.submittedAt)+'</td>'
            +'<td class="px-6 py-4">'+badge(a.status)+'</td>'
            +'<td class="px-6 py-4"><button onclick="openReviewByIndex('+index+')" class="rounded-lg bg-brand-50 px-3 py-1.5 text-xs font-semibold text-brand-900 hover:bg-brand-100 transition">Review</button>'
            +(a.status==='approved'?' <button onclick="issueCert('+a.applicationId+')" class="ml-1 rounded-lg bg-green-50 px-3 py-1.5 text-xs font-semibold text-green-700 hover:bg-green-100 transition">Issue Cert</button>':'')
            +'</td></tr>';
    });
}

function filterApps(status){
    document.querySelectorAll('.status-filter').forEach(b=>{b.className='status-filter rounded-lg border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-600 hover:bg-slate-50';});
    document.querySelector('[data-f="'+status+'"]').className='status-filter rounded-lg bg-brand-900 px-4 py-2 text-xs font-semibold text-white';
    renderApps(status==='all'?allApps:allApps.filter(a=>a.status===status));
}

function openReviewByIndex(index){
    const app=allApps[index];
    if(!app)return;
    currentApp=app;currentDecision=null;
    document.getElementById('modal-tracking').textContent='Tracking ID: '+app.trackingId+' • '+(app.citizenName||('Citizen #'+app.citizenId))+' • '+(app.serviceName||('Service #'+app.serviceTypeId));
    document.getElementById('modal-form').textContent=app.formData||'No form data';
    const docs=Array.isArray(app.documents)?app.documents:[];
    document.getElementById('modal-docs').innerHTML=docs.length===0
        ?'<p class="rounded-xl bg-slate-50 px-4 py-3 text-sm text-slate-500">No uploaded documents for this application.</p>'
        :docs.map(d=>'<a class="flex items-center justify-between rounded-xl border border-slate-200 px-4 py-3 text-sm text-slate-700 hover:bg-slate-50" href="'+docHref(d.filePath)+'" target="_blank" rel="noopener"><span>'+d.documentType+'</span><span class="text-xs text-brand-900 font-semibold">Open</span></a>').join('');
    document.getElementById('modal-remarks').value=app.remarks||'';
    document.querySelectorAll('.decision-btn').forEach(b=>b.classList.remove('border-green-500','border-amber-500','border-red-500','bg-green-50','bg-amber-50','bg-red-50'));
    document.getElementById('review-modal').classList.remove('hidden');
}
function closeModal(){document.getElementById('review-modal').classList.add('hidden');}
function setDecision(d){
    currentDecision=d;
    const colors={review:['border-amber-500','bg-amber-50'],approved:['border-green-500','bg-green-50'],rejected:['border-red-500','bg-red-50']};
    document.querySelectorAll('.decision-btn').forEach(b=>b.classList.remove('border-green-500','border-amber-500','border-red-500','bg-green-50','bg-amber-50','bg-red-50'));
    const btn=document.querySelector('[data-d="'+d+'"]');
    if(colors[d])colors[d].forEach(c=>btn.classList.add(c));
}
async function submitReview(){
    if(!requireAdminSession())return;
    if(!currentDecision){alert('Select a decision');return;}
    const remarks=document.getElementById('modal-remarks').value;
    const params=new URLSearchParams();
    params.append('applicationId',currentApp.applicationId);params.append('status',currentDecision);params.append('remarks',remarks);params.append('adminId',AID);
    const res=await fetch(CTX+'/api/admin/applications',{method:'PUT',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:params.toString()});
    const data=await res.json();
    if(data.success){
        // Send notification to citizen
        const notifParams=new URLSearchParams();notifParams.append('citizenId',currentApp.citizenId);notifParams.append('applicationId',currentApp.applicationId);
        notifParams.append('message','Your application #'+currentApp.trackingId+' has been '+currentDecision+(remarks?' — '+remarks:''));
        fetch(CTX+'/api/notifications',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:notifParams.toString()});
        closeModal();loadApps();
    }else{alert(data.message||'Failed');}
}
async function issueCert(appId){
    if(!requireAdminSession())return;
    if(!confirm('Issue certificate for this application?'))return;
    const params=new URLSearchParams();params.append('applicationId',appId);params.append('adminId',AID);
    const res=await fetch(CTX+'/api/certificates',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:params.toString()});
    const data=await res.json();
    if(data.success){alert('Certificate issued: '+data.certificate.certificateNo);loadApps();}else{alert(data.message||'Failed');}
}
loadApps();
</script>
</body></html>