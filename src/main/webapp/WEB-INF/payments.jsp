<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId");String citizenName=(String)request.getAttribute("citizenName");if(citizenName==null)citizenName="Citizen"; %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Payments & Tax - SarkarSathi</title>
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
        <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="search" class="h-[18px] w-[18px]"></i>Track Application</a>
        <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="credit-card" class="h-[18px] w-[18px]"></i>Payments & Tax</a>
        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="ml-[220px] flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Payments & Tax Records</h1><p class="text-xs text-slate-500">Manage your tax payments and view receipts</p></div>
    </header>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
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
                <div class="flex items-center gap-3 mb-5"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-50 text-blue-600"><i data-lucide="home" class="h-5 w-5"></i></div><div><h3 class="text-base font-bold text-slate-900">House Tax</h3><p class="text-xs text-slate-500">Annual property tax payment</p></div></div>
                <div class="mb-4"><label class="text-xs font-semibold uppercase tracking-wider text-slate-400">Amount (Rs.)</label><input id="house-amount" type="number" value="5000" class="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500"></div>
                <button onclick="payTax('housetax','house-amount')" class="w-full rounded-xl bg-blue-600 py-3 text-sm font-semibold text-white hover:bg-blue-700 transition">Pay House Tax</button>
            </div>
            <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                <div class="flex items-center gap-3 mb-5"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-green-50 text-green-600"><i data-lucide="trees" class="h-5 w-5"></i></div><div><h3 class="text-base font-bold text-slate-900">Land Tax</h3><p class="text-xs text-slate-500">Annual land revenue payment</p></div></div>
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
    </main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const CID=<%= citizenId %>;
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
