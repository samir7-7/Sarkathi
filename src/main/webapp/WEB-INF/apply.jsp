<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId");String citizenName=(String)request.getAttribute("citizenName");if(citizenName==null)citizenName="Citizen"; %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Apply for Service - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
@keyframes fadeInUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}.fade-in{animation:fadeInUp .4s ease-out forwards}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<div class="flex min-h-screen">
<aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
    <div class="px-5 pt-5 pb-2"><a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a></div>
    <nav class="mt-6 flex-1 space-y-1 px-3">
        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="layout-dashboard" class="h-[18px] w-[18px]"></i>Dashboard</a>
        <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="file-plus" class="h-[18px] w-[18px]"></i>Apply for Service</a>
        <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="search" class="h-[18px] w-[18px]"></i>Track Application</a>
        <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="credit-card" class="h-[18px] w-[18px]"></i>Payments & Tax</a>
        <a href="<%= request.getContextPath() %>/citizen/notifications" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="bell" class="h-[18px] w-[18px]"></i>Notifications</a>
        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="ml-[220px] flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Apply for Service</h1><p class="text-xs text-slate-500">Submit a new application for certificates or registrations</p></div>
    </header>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
        <!-- Success Message -->
        <div id="success-msg" class="hidden mb-6 flex items-center gap-3 rounded-xl border border-green-200 bg-green-50 px-5 py-4">
            <i data-lucide="check-circle-2" class="h-5 w-5 text-green-600"></i>
            <div><p class="text-sm font-semibold text-green-800">Application Submitted Successfully!</p><p class="text-xs text-green-600 mt-1">Tracking ID: <span id="tracking-id" class="font-bold"></span></p></div>
        </div>

        <div class="max-w-3xl fade-in">
            <form id="apply-form" class="space-y-6">
                <!-- Step 1: Service Type Selection -->
                <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                    <h2 class="text-lg font-bold text-slate-900 mb-1">Select Service Type</h2>
                    <p class="text-sm text-slate-500 mb-5">Choose the type of certificate or service you need</p>
                    <div class="grid grid-cols-2 gap-3" id="service-grid">
                        <p class="col-span-2 text-sm text-slate-400 text-center py-4">Loading services...</p>
                    </div>
                    <input type="hidden" id="serviceTypeId" name="serviceTypeId" required>
                </div>

                <!-- Step 2: Ward Selection -->
                <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                    <h2 class="text-lg font-bold text-slate-900 mb-4">Select Ward</h2>
                    <select id="wardId" name="wardId" required class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500 focus:ring-2 focus:ring-brand-100">
                        <option value="">Loading wards...</option>
                    </select>
                </div>

                <!-- Step 3: Dynamic Form Fields -->
                <div id="dynamic-fields" class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm hidden">
                    <h2 class="text-lg font-bold text-slate-900 mb-4">Application Details</h2>
                    <div id="fields-container" class="space-y-4"></div>
                </div>

                <!-- Step 4: Document Upload -->
                <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                    <h2 class="text-lg font-bold text-slate-900 mb-1">Upload Documents</h2>
                    <p class="text-sm text-slate-500 mb-4">Upload required supporting documents</p>

                    <!-- Reuse existing documents -->
                    <div id="vault-docs" class="mb-4 hidden">
                        <p class="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-2">Reuse from your vault</p>
                        <div id="vault-list" class="space-y-2"></div>
                    </div>

                    <div class="border-2 border-dashed border-slate-200 rounded-xl p-6 text-center hover:border-brand-500 transition cursor-pointer" id="drop-zone">
                        <i data-lucide="upload-cloud" class="h-8 w-8 mx-auto text-slate-400 mb-2"></i>
                        <p class="text-sm text-slate-600">Click or drag files here to upload</p>
                        <p class="text-xs text-slate-400 mt-1">PDF, JPG, PNG (max 10MB)</p>
                        <input type="file" id="file-input" class="hidden" multiple accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                    <div id="file-list" class="mt-3 space-y-2"></div>
                </div>

                <!-- Submit -->
                <button type="submit" id="submit-btn" class="w-full rounded-xl bg-brand-900 px-6 py-4 text-base font-semibold text-white shadow-lg shadow-brand-900/20 transition hover:bg-brand-800 disabled:opacity-50 disabled:cursor-not-allowed">
                    Submit Application
                </button>
            </form>
        </div>
    </main>
</div>
</div>
<script>
lucide.createIcons();
const CTX='<%= request.getContextPath() %>';const CID=<%= citizenId %>;
let citizenProfile=null;
let citizenDocuments=[];
let previousApplications=[];
let fieldSuggestions={};
const SERVICE_FIELDS={
    1:[{n:'childName',l:'Child Full Name',t:'text'},{n:'dateOfBirth',l:'Date of Birth',t:'date'},{n:'birthPlace',l:'Place of Birth',t:'text'},{n:'fatherName',l:"Father's Name",t:'text'},{n:'motherName',l:"Mother's Name",t:'text'}],
    2:[{n:'groomName',l:'Groom Full Name',t:'text'},{n:'brideName',l:'Bride Full Name',t:'text'},{n:'marriageDate',l:'Date of Marriage',t:'date'},{n:'marriagePlace',l:'Place of Marriage',t:'text'},{n:'witnessName',l:'Witness Name',t:'text'}],
    3:[{n:'fullAddress',l:'Full Address',t:'text'},{n:'residingSince',l:'Residing Since',t:'date'},{n:'purpose',l:'Purpose of Certificate',t:'text'},{n:'landmarkNear',l:'Nearest Landmark',t:'text'}],
    4:[{n:'citizenshipType',l:'Citizenship Type',t:'select',opts:['By Descent','By Birth','Naturalized']},{n:'fatherCitizenshipNo',l:"Father's Citizenship No.",t:'text'},{n:'motherCitizenshipNo',l:"Mother's Citizenship No.",t:'text'},{n:'permanentAddress',l:'Permanent Address',t:'text'}]
};
let selectedService=null;

fetch(CTX+'/api/citizens/'+CID)
    .then(r=>r.json())
    .then(data=>{
        citizenProfile=data.citizen||null;
        citizenDocuments=Array.isArray(data.documents)?data.documents:[];
        buildFieldSuggestions();
    });

fetch(CTX+'/api/applications?citizenId='+CID)
    .then(r=>r.json())
    .then(apps=>{
        previousApplications=Array.isArray(apps)?apps:[];
        buildFieldSuggestions();
    });

// Load services
fetch(CTX+'/api/services?activeOnly=true').then(r=>r.json()).then(services=>{
    const grid=document.getElementById('service-grid');grid.innerHTML='';
    if(!Array.isArray(services)||services.length===0){
        // Default services
        services=[{serviceTypeId:1,serviceName:'Birth Certificate',description:'Register a birth event',baseFee:100},
            {serviceTypeId:2,serviceName:'Marriage Certificate',description:'Register a marriage',baseFee:200},
            {serviceTypeId:3,serviceName:'Residence Certificate',description:'Proof of residence',baseFee:150},
            {serviceTypeId:4,serviceName:'Citizenship Application',description:'Apply for citizenship',baseFee:500}];
    }
    const icons=['baby','heart','home','id-card','file-text','building'];
    services.forEach((s,i)=>{
        const div=document.createElement('div');
        div.className='service-card flex flex-col items-center gap-2 rounded-xl border-2 border-slate-100 p-5 cursor-pointer transition hover:border-brand-500 hover:bg-brand-50 text-center';
        div.dataset.id=s.serviceTypeId;
        div.innerHTML='<i data-lucide="'+(icons[i%icons.length]||'file-text')+'" class="h-6 w-6 text-brand-900"></i><p class="text-sm font-semibold text-slate-800">'+s.serviceName+'</p><p class="text-[11px] text-slate-400">Fee: Rs. '+s.baseFee+'</p>';
        div.onclick=()=>{
            document.querySelectorAll('.service-card').forEach(c=>c.classList.remove('border-brand-500','bg-brand-50'));
            div.classList.add('border-brand-500','bg-brand-50');
            document.getElementById('serviceTypeId').value=s.serviceTypeId;
            selectedService=s.serviceTypeId;
            showDynamicFields(s.serviceTypeId);
        };
        grid.appendChild(div);
    });
    lucide.createIcons();
});

function showDynamicFields(sid){
    const container=document.getElementById('fields-container');
    const wrapper=document.getElementById('dynamic-fields');
    const fields=SERVICE_FIELDS[sid]||[{n:'details',l:'Additional Details',t:'textarea'}];
    container.innerHTML='';
    fields.forEach(f=>{
        let input='';
        if(f.t==='select'){
            input='<select name="'+f.n+'" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500 focus:ring-2 focus:ring-brand-100">';
            input+='<option value="">Select...</option>';
            f.opts.forEach(o=>{input+='<option value="'+o+'">'+o+'</option>';});
            input+='</select>';
        } else if(f.t==='textarea'){
            input='<textarea name="'+f.n+'" rows="3" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500 focus:ring-2 focus:ring-brand-100"></textarea>';
        } else {
            input='<input type="'+f.t+'" name="'+f.n+'" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500 focus:ring-2 focus:ring-brand-100">';
        }
        container.innerHTML+='<div><label class="mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800">'+f.l+'</label>'+input+'</div>';
    });
    wrapper.classList.remove('hidden');
    container.querySelectorAll('input, select, textarea').forEach(el=>{
        const suggested=getSuggestedValue(el.name);
        if(suggested){el.value=suggested;}
    });
}

function buildFieldSuggestions(){
    const merged={};
    [...previousApplications].reverse().forEach(app=>{
        if(!app.formData)return;
        try{
            const parsed=JSON.parse(app.formData);
            Object.keys(parsed||{}).forEach(key=>{
                if(parsed[key]!==null&&parsed[key]!==undefined&&String(parsed[key]).trim()!==''&&!merged[key]){
                    merged[key]=parsed[key];
                }
            });
        }catch(e){}
    });
    if(citizenProfile){
        if(citizenProfile.fullName){merged.fullName=merged.fullName||citizenProfile.fullName;}
        if(citizenProfile.dateOfBirth){merged.dateOfBirth=merged.dateOfBirth||citizenProfile.dateOfBirth;}
    }
    fieldSuggestions=merged;
}

function getSuggestedValue(fieldName){
    if(fieldSuggestions[fieldName])return fieldSuggestions[fieldName];
    if(!citizenProfile)return '';
    const lower=fieldName.toLowerCase();
    if(['fullname','childname','groomname','bridename'].includes(lower)){return citizenProfile.fullName||'';}
    if(lower.includes('dateofbirth')){return citizenProfile.dateOfBirth||'';}
    if(lower.includes('email')){return citizenProfile.email||'';}
    if(lower.includes('phone')){return citizenProfile.phone||'';}
    return '';
}

// Load wards
fetch(CTX+'/api/wards').then(r=>r.json()).then(wards=>{
    const sel=document.getElementById('wardId');sel.innerHTML='<option value="">Select Ward</option>';
    if(Array.isArray(wards))wards.forEach(w=>{sel.innerHTML+='<option value="'+w.wardId+'">Ward '+w.wardNumber+' - '+w.municipalityName+'</option>';});
});

// Load vault docs for reuse
fetch(CTX+'/api/citizens/'+CID+'/documents').then(r=>r.json()).then(docs=>{
    if(Array.isArray(docs)&&docs.length>0){
        document.getElementById('vault-docs').classList.remove('hidden');
        const list=document.getElementById('vault-list');
        docs.forEach(d=>{list.innerHTML+='<label class="flex items-center gap-3 rounded-lg border border-slate-100 px-4 py-2.5 cursor-pointer hover:bg-slate-50"><input type="checkbox" name="reuseDocs" value="'+d.vaultDocId+'" class="rounded border-slate-300"><span class="text-sm text-slate-700">'+d.documentType+'</span><span class="text-xs text-slate-400 ml-auto">Uploaded '+new Date(d.uploadedAt).toLocaleDateString()+'</span></label>';});
    }
});

function getSelectedReuseIds(){
    return Array.from(document.querySelectorAll('input[name="reuseDocs"]:checked')).map(el=>el.value);
}

// File upload
const dropZone=document.getElementById('drop-zone'),fileInput=document.getElementById('file-input');
dropZone.onclick=()=>fileInput.click();
dropZone.ondragover=e=>{e.preventDefault();dropZone.classList.add('border-brand-500');};
dropZone.ondragleave=()=>dropZone.classList.remove('border-brand-500');
dropZone.ondrop=e=>{e.preventDefault();dropZone.classList.remove('border-brand-500');handleFiles(e.dataTransfer.files);};
fileInput.onchange=()=>handleFiles(fileInput.files);
let uploadedFiles=[];
function handleFiles(files){
    const list=document.getElementById('file-list');
    Array.from(files).forEach(f=>{
        uploadedFiles.push(f);
        list.innerHTML+='<div class="flex items-center gap-3 rounded-lg bg-slate-50 px-4 py-2.5"><i data-lucide="file" class="h-4 w-4 text-slate-500"></i><span class="text-sm text-slate-700 flex-1">'+f.name+'</span><span class="text-xs text-slate-400">'+(f.size/1024).toFixed(1)+' KB</span></div>';
    });
    lucide.createIcons();
}

// Submit form
document.getElementById('apply-form').onsubmit=async function(e){
    e.preventDefault();
    const btn=document.getElementById('submit-btn');btn.disabled=true;btn.textContent='Submitting...';
    // Collect form data
    const formFields={};
    document.querySelectorAll('#fields-container input, #fields-container select, #fields-container textarea').forEach(el=>{formFields[el.name]=el.value;});
    const params=new URLSearchParams();
    params.append('citizenId',CID);
    params.append('serviceTypeId',document.getElementById('serviceTypeId').value);
    params.append('wardId',document.getElementById('wardId').value);
    params.append('formData',JSON.stringify(formFields));
    const reuseIds=getSelectedReuseIds();
    if(reuseIds.length>0){params.append('reuseDocumentIds',reuseIds.join(','));}
    try{
        const res=await fetch(CTX+'/api/applications',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:params.toString()});
        const data=await res.json();
        if(data.success&&data.application){
            // Upload files
            for(const f of uploadedFiles){
                const fd=new FormData();fd.append('file',f);fd.append('citizenId',CID);fd.append('applicationId',data.application.applicationId);fd.append('documentType',f.name.split('.')[0]);fd.append('saveToVault','true');
                await fetch(CTX+'/api/upload',{method:'POST',body:fd});
            }
            document.getElementById('tracking-id').textContent=data.application.trackingId;
            document.getElementById('success-msg').classList.remove('hidden');
            this.reset();uploadedFiles=[];document.getElementById('file-list').innerHTML='';
            document.querySelectorAll('input[name="reuseDocs"]').forEach(el=>el.checked=false);
            window.scrollTo({top:0,behavior:'smooth'});
        }else{alert(data.message||'Submission failed');}
    }catch(err){alert('Error: '+err.message);}
    btn.disabled=false;btn.textContent='Submit Application';
};
</script>
</body></html>
