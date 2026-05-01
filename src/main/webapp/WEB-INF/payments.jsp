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
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Payments & Tax - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<%@ include file="includes/responsive-scripts.jsp" %>
<style>body{font-family:'Outfit',sans-serif}@keyframes fadeInUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}.fade-in{animation:fadeInUp .4s ease-out forwards}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}</style>
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
        <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="credit-card" class="h-[18px] w-[18px]"></i>Payments & Tax</a>
        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
        <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="folder" class="h-[18px] w-[18px]"></i>My Documents</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-4 py-3.5 lg:px-8"><div class="flex items-center gap-4"><button onclick="toggleSidebar()" class="p-2 text-slate-600 lg:hidden focus:outline-none"><i data-lucide="menu" class="h-6 w-6"></i></button>
        <div><h1 class="text-lg font-bold text-slate-900">Payments & Tax Records</h1><p class="text-xs text-slate-500 hidden sm:block">Manage your tax payments and view receipts</p></div></div><a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 transition hover:bg-brand-50 hover:text-brand-900">
            <i data-lucide="bell" class="h-4 w-4"></i>
            <span id="top-notif-badge" class="absolute -right-1 -top-1 hidden min-w-[18px] rounded-full bg-red-500 px-1.5 py-0.5 text-center text-[10px] font-bold text-white"></span>
        </a>
    </header>
    <main class="flex-1 px-4 py-6 md:px-8 md:py-8 overflow-y-auto"><div class="w-full fade-in">
        <!-- Payment Success Modal -->
        <div id="receipt-modal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
            <div class="w-full max-w-md rounded-2xl bg-white p-8 shadow-2xl text-center">
                <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-green-50"><i data-lucide="check-circle-2" class="h-8 w-8 text-green-600"></i></div>
                <h3 class="mt-4 text-xl font-bold text-slate-900">Payment Successful!</h3>
                <p class="mt-2 text-sm text-slate-500">Receipt No: <span id="receipt-no" class="font-bold text-brand-900"></span></p>
                <div id="receipt-details" class="mt-4 rounded-xl bg-slate-50 p-4 text-left text-sm space-y-2"></div>
                <button onclick="document.getElementById('receipt-modal').classList.add('hidden');location.reload();" class="mt-6 w-full rounded-xl bg-brand-900 py-3 text-sm font-semibold text-white hover:bg-brand-800">Close</button>
            </div>
        </div>

        <!-- Pay Tax Section -->
        <div class="grid gap-6 lg:grid-cols-2 mb-8">
            <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                <div class="flex items-center gap-3 mb-5"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-50 text-blue-600"><i data-lucide="home" class="h-5 w-5"></i></div><div><h3 class="text-base font-bold text-slate-900">House Tax</h3><p class="text-xs text-slate-500 hidden sm:block">Annual property tax payment</p></div></div>
                <div class="mb-4"><label class="text-xs font-semibold uppercase tracking-wider text-slate-400">Amount (Rs.)</label><input id="house-amount" type="number" value="5000" class="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <button onclick="payTax('housetax','house-amount')" class="w-full rounded-xl bg-blue-600 py-3 text-sm font-semibold text-white hover:bg-blue-700 transition">Pay House Tax</button>
            </div>
            <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                <div class="flex items-center gap-3 mb-5"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-green-50 text-green-600"><i data-lucide="trees" class="h-5 w-5"></i></div><div><h3 class="text-base font-bold text-slate-900">Land Tax</h3><p class="text-xs text-slate-500 hidden sm:block">Annual land revenue payment</p></div></div>
                <div class="mb-4"><label class="text-xs font-semibold uppercase tracking-wider text-slate-400">Amount (Rs.)</label><input id="land-amount" type="number" value="3000" class="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <button onclick="payTax('landtax','land-amount')" class="w-full rounded-xl bg-green-600 py-3 text-sm font-semibold text-white hover:bg-green-700 transition">Pay Land Tax</button>
            </div>
        </div>

        <!-- Tax Records -->
        <div class="rounded-2xl border border-slate-100 bg-white shadow-sm">
            <div class="px-6 pt-6 pb-4"><h2 class="text-lg font-bold text-slate-900">Tax Records</h2></div>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead><tr class="border-t border-b border-slate-100">
                        <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Type</th>
                        <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Fiscal Year</th>
                        <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Amount</th>
                        <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Status</th>
                    </tr></thead>
                    <tbody id="tax-body" class="divide-y divide-slate-50"><tr><td colspan="4" class="px-6 py-8 text-center text-sm text-slate-400">Loading...</td></tr></tbody>
                </table>
            </div>
        </div>
    </div></main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const CID=<%= citizenId %>;
fetch(CTX+'/api/notifications?citizenId='+CID).then(r=>r.json()).then(data=>{const unread=data.unreadCount||0;if(unread>0){const b=document.getElementById('top-notif-badge');b.textContent=unread;b.classList.remove('hidden');}}).catch(()=>{});
let taxRecords=[];

// Load tax records
function loadTaxes(){
fetch(CTX+'/api/taxes?citizenId='+CID).then(r=>r.json()).then(taxes=>{
    taxRecords=Array.isArray(taxes)?taxes:[];
    const tbody=document.getElementById('tax-body');
    if(taxRecords.length===0){tbody.innerHTML='<tr><td colspan="4" class="px-6 py-8 text-center text-sm text-slate-400">No tax records found</td></tr>';return;}
    tbody.innerHTML='';
    taxRecords.forEach(t=>{
        tbody.innerHTML+='<tr class="hover:bg-slate-50"><td class="px-6 py-4 font-medium text-slate-700 capitalize">'+t.taxType+' Tax</td>'
            +'<td class="px-6 py-4 text-slate-600">'+t.fiscalYear+'</td>'
            +'<td class="px-6 py-4 text-slate-700 font-semibold">Rs. '+Number(t.dueAmount).toLocaleString()+'</td>'
            +'<td class="px-6 py-4">'+(t.paid?'<span class="inline-flex rounded-full bg-green-50 px-3 py-1 text-xs font-semibold text-green-700">Paid</span>':'<span class="inline-flex rounded-full bg-red-50 px-3 py-1 text-xs font-semibold text-red-600">Unpaid</span>')+'</td></tr>';
    });
    const houseRecord=getLatestTax('house');
    const landRecord=getLatestTax('land');
    if(houseRecord){document.getElementById('house-amount').value=houseRecord.dueAmount;}
    if(landRecord){document.getElementById('land-amount').value=landRecord.dueAmount;}
});
}
loadTaxes();

function getLatestTax(type){
    return taxRecords.find(t=>t.taxType===type&&!t.paid)||taxRecords.find(t=>t.taxType===type)||null;
}

async function payTax(type,amountId){
    const amount=document.getElementById(amountId).value;
    if(!amount||amount<=0){alert('Enter valid amount');return;}
    const normalizedType=type==='housetax'?'house':'land';
    const taxRecord=getLatestTax(normalizedType);
    if(taxRecord&&taxRecord.paid){alert('This tax record is already marked as paid.');return;}
    const params=new URLSearchParams();params.append('amount',amount);params.append('paymentType',type);params.append('status','completed');params.append('citizenId',CID);
    if(taxRecord){params.append('taxId',taxRecord.taxId);params.append('fiscalYear',taxRecord.fiscalYear);}
    const res=await fetch(CTX+'/api/payments',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:params.toString()});
    const data=await res.json();
    if(data.success){
        document.getElementById('receipt-no').textContent=data.receiptNumber;
        document.getElementById('receipt-details').innerHTML='<div class="flex justify-between"><span class="text-slate-500">Type:</span><span class="font-semibold capitalize">'+type.replace('tax',' Tax')+'</span></div>'
            +'<div class="flex justify-between"><span class="text-slate-500">Amount:</span><span class="font-semibold">Rs. '+Number(amount).toLocaleString()+'</span></div>'
            +'<div class="flex justify-between"><span class="text-slate-500">Fiscal Year:</span><span class="font-semibold">'+((data.taxRecord&&data.taxRecord.fiscalYear)||'Current')+'</span></div>'
            +'<div class="flex justify-between"><span class="text-slate-500">Status:</span><span class="font-semibold text-green-600">Completed</span></div>'
            +'<div class="flex justify-between"><span class="text-slate-500">Date:</span><span class="font-semibold">'+new Date().toLocaleDateString()+'</span></div>';
        document.getElementById('receipt-modal').classList.remove('hidden');
        loadTaxes();
        lucide.createIcons();
    }else{alert(data.message||'Payment failed');}
}
</script>
</body></html>
