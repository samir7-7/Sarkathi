<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Crop Advisory - SarkarSathi</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}</script>
<script src="https://unpkg.com/lucide@latest"></script>
<style>body{font-family:'Outfit',sans-serif}@keyframes fadeInUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}.fade-in{animation:fadeInUp .4s ease-out forwards}</style>
</head><body class="bg-[#fafafc] text-slate-800">
<header class="border-b border-slate-200 bg-white px-6 lg:px-12">
    <nav class="mx-auto flex max-w-7xl items-center justify-between py-4">
        <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">Sarkar<span class="text-brand-500">Sathi</span></a>
        <div class="hidden items-center gap-8 text-sm font-medium text-slate-600 lg:flex">
            <a href="<%= request.getContextPath() %>/announcements" class="hover:text-brand-900 transition">Announcements</a>
            <a href="<%= request.getContextPath() %>/agriculture" class="hover:text-brand-900 transition">Agriculture</a>
            <a href="<%= request.getContextPath() %>/budget" class="hover:text-brand-900 transition">Budget</a>
            <a href="<%= request.getContextPath() %>/crop-advisory" class="text-brand-900 font-semibold">Crop Advisory</a>
        </div>
        <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-brand-800 transition">Login</a>
    </nav>
</header>
<main class="px-6 py-12 lg:px-12">
    <div class="mx-auto max-w-4xl">
        <div class="text-center mb-12">
            <div class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-2xl bg-emerald-50"><i data-lucide="sprout" class="h-8 w-8 text-emerald-600"></i></div>
            <h1 class="text-4xl font-bold text-slate-900">Crop Advisory System</h1>
            <p class="mt-3 text-lg text-slate-500">Get crop recommendations based on your land type and current season</p>
        </div>

        <!-- Selection -->
        <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm mb-8">
            <div class="grid md:grid-cols-2 gap-6">
                <div>
                    <label class="mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800">Land Type</label>
                    <div class="grid grid-cols-3 gap-3" id="land-grid">
                        <button onclick="selectLand('flatland')" data-land="flatland" class="land-btn flex flex-col items-center gap-2 rounded-xl border-2 border-slate-100 p-4 transition hover:border-emerald-400">
                            <i data-lucide="waves" class="h-6 w-6 text-emerald-600"></i><span class="text-xs font-semibold text-slate-700">Flatland (Terai)</span>
                        </button>
                        <button onclick="selectLand('hilly')" data-land="hilly" class="land-btn flex flex-col items-center gap-2 rounded-xl border-2 border-slate-100 p-4 transition hover:border-emerald-400">
                            <i data-lucide="mountain" class="h-6 w-6 text-emerald-600"></i><span class="text-xs font-semibold text-slate-700">Hilly</span>
                        </button>
                        <button onclick="selectLand('mountain')" data-land="mountain" class="land-btn flex flex-col items-center gap-2 rounded-xl border-2 border-slate-100 p-4 transition hover:border-emerald-400">
                            <i data-lucide="mountain-snow" class="h-6 w-6 text-emerald-600"></i><span class="text-xs font-semibold text-slate-700">Mountain</span>
                        </button>
                    </div>
                </div>
                <div>
                    <label class="mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800">Season</label>
                    <div class="grid grid-cols-2 gap-3" id="season-grid">
                        <button onclick="selectSeason('spring')" data-season="spring" class="season-btn flex items-center gap-2 rounded-xl border-2 border-slate-100 p-3 transition hover:border-emerald-400">
                            <i data-lucide="flower-2" class="h-5 w-5 text-pink-500"></i><span class="text-xs font-semibold text-slate-700">Spring</span>
                        </button>
                        <button onclick="selectSeason('summer')" data-season="summer" class="season-btn flex items-center gap-2 rounded-xl border-2 border-slate-100 p-3 transition hover:border-emerald-400">
                            <i data-lucide="sun" class="h-5 w-5 text-amber-500"></i><span class="text-xs font-semibold text-slate-700">Summer</span>
                        </button>
                        <button onclick="selectSeason('autumn')" data-season="autumn" class="season-btn flex items-center gap-2 rounded-xl border-2 border-slate-100 p-3 transition hover:border-emerald-400">
                            <i data-lucide="leaf" class="h-5 w-5 text-orange-500"></i><span class="text-xs font-semibold text-slate-700">Autumn</span>
                        </button>
                        <button onclick="selectSeason('winter')" data-season="winter" class="season-btn flex items-center gap-2 rounded-xl border-2 border-slate-100 p-3 transition hover:border-emerald-400">
                            <i data-lucide="snowflake" class="h-5 w-5 text-blue-500"></i><span class="text-xs font-semibold text-slate-700">Winter</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Results -->
        <div id="results" class="hidden">
            <h2 class="text-xl font-bold text-slate-900 mb-4">Recommended Crops</h2>
            <div id="crop-grid" class="grid gap-4 md:grid-cols-3"></div>
        </div>
    </div>
</main>
<script>
lucide.createIcons();const CTX='<%= request.getContextPath() %>';
let selectedLand=null,selectedSeason=null;
const cropIcons={'Rice':'wheat','Maize':'wheat','Wheat':'wheat','Potato':'carrot','Apple':'apple','Sugarcane':'candy','default':'sprout'};

function selectLand(t){
    selectedLand=t;
    document.querySelectorAll('.land-btn').forEach(b=>b.classList.remove('border-emerald-500','bg-emerald-50'));
    document.querySelector('[data-land="'+t+'"]').classList.add('border-emerald-500','bg-emerald-50');
    if(selectedSeason)fetchCrops();
}
function selectSeason(s){
    selectedSeason=s;
    document.querySelectorAll('.season-btn').forEach(b=>b.classList.remove('border-emerald-500','bg-emerald-50'));
    document.querySelector('[data-season="'+s+'"]').classList.add('border-emerald-500','bg-emerald-50');
    if(selectedLand)fetchCrops();
}
function fetchCrops(){
    fetch(CTX+'/api/crop-advisory?landType='+selectedLand+'&season='+selectedSeason).then(r=>r.json()).then(data=>{
        const grid=document.getElementById('crop-grid');
        const results=document.getElementById('results');
        results.classList.remove('hidden');
        if(!data.recommendations||data.recommendations.length===0){grid.innerHTML='<p class="col-span-3 text-center py-8 text-slate-400">No recommendations available</p>';return;}
        grid.innerHTML='';
        data.recommendations.forEach((c,i)=>{
            grid.innerHTML+='<div class="fade-in rounded-2xl border border-slate-100 bg-white p-6 shadow-sm hover:shadow-md transition" style="animation-delay:'+i*0.1+'s">'
                +'<div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600 mb-4"><i data-lucide="sprout" class="h-6 w-6"></i></div>'
                +'<h3 class="text-base font-bold text-slate-900 mb-2">'+c.name+'</h3>'
                +'<p class="text-sm text-slate-600 mb-3">'+c.description+'</p>'
                +'<div class="flex items-center gap-2 text-xs"><i data-lucide="clock" class="h-3 w-3 text-slate-400"></i><span class="font-semibold text-slate-500">'+c.growingPeriod+'</span></div>'
                +'</div>';
        });
        lucide.createIcons();
    });
}
</script>
</body></html>
