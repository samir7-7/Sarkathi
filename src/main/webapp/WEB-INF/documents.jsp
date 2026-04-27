<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId"); %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>My Documents - SarkarSathi</title>
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
        <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600"><i data-lucide="award" class="h-[18px] w-[18px]"></i>Certificates</a>
        <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm"><i data-lucide="folder" class="h-[18px] w-[18px]"></i>My Documents</a>
    </nav>
    <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3"><a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600"><i data-lucide="log-out" class="h-[18px] w-[18px]"></i>Logout</a></div>
</aside>
<div class="ml-[220px] flex-1 flex flex-col min-h-screen">
    <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
        <div><h1 class="text-lg font-bold text-slate-900">Document Vault</h1><p class="text-xs text-slate-500">Your uploaded documents for reuse across applications</p></div>
        <label class="inline-flex items-center gap-2 rounded-xl bg-brand-900 px-5 py-2.5 text-sm font-semibold text-white shadow-sm cursor-pointer hover:bg-brand-800 transition">
            <i data-lucide="upload" class="h-4 w-4"></i>Upload New
            <input type="file" id="upload-input" class="hidden" accept=".pdf,.jpg,.jpeg,.png">
        </label>
    </header>
    <main class="flex-1 px-8 py-8 overflow-y-auto">
        <div id="doc-grid" class="grid gap-4 md:grid-cols-2 lg:grid-cols-3"><p class="col-span-3 text-center py-8 text-slate-400">Loading documents...</p></div>
    </main>
</div>
</div>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';const CID=<%= citizenId %>;
const icons={citizenship:'id-card',photo:'image',general:'file',default:'file-text'};

function loadDocs(){
    fetch(CTX+'/api/citizens/'+CID+'/documents').then(r=>r.json()).then(docs=>{
        const grid=document.getElementById('doc-grid');
        if(!Array.isArray(docs)||docs.length===0){grid.innerHTML='<div class="col-span-3 rounded-2xl border border-slate-100 bg-white p-12 text-center shadow-sm"><i data-lucide="folder-open" class="h-12 w-12 mx-auto text-slate-300 mb-4"></i><p class="text-slate-500">No documents uploaded yet</p></div>';lucide.createIcons();return;}
        grid.innerHTML='';
        docs.forEach(d=>{
            const icon=icons[d.documentType]||icons.default;
            const ext=d.filePath?d.filePath.split('.').pop().toUpperCase():'FILE';
            grid.innerHTML+='<div class="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm hover:shadow-md transition">'
                +'<div class="flex items-center gap-3"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-50 text-blue-600"><i data-lucide="'+icon+'" class="h-5 w-5"></i></div>'
                +'<div class="flex-1 min-w-0"><p class="text-sm font-semibold text-slate-900 capitalize truncate">'+d.documentType+'</p>'
                +'<p class="text-[11px] text-slate-400">'+ext+' &bull; '+new Date(d.uploadedAt).toLocaleDateString()+'</p></div></div>'
                +'<div class="mt-3 flex items-center gap-2 text-xs"><span class="inline-flex items-center gap-1 rounded-full bg-green-50 px-2.5 py-1 font-semibold text-green-600"><i data-lucide="check" class="h-3 w-3"></i>Reusable</span></div></div>';
        });
        lucide.createIcons();
    });
}
loadDocs();

document.getElementById('upload-input').onchange=async function(){
    const file=this.files[0];if(!file)return;
    const docType=prompt('Document type (e.g., citizenship, photo, general):','general');if(!docType)return;
    const fd=new FormData();fd.append('file',file);fd.append('citizenId',CID);fd.append('documentType',docType);fd.append('saveToVault','true');
    const res=await fetch(CTX+'/api/upload',{method:'POST',body:fd});
    const data=await res.json();
    if(data.success){loadDocs();}else{alert(data.message||'Upload failed');}
    this.value='';
};
</script>
</body></html>
