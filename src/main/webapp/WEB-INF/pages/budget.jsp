<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.BudgetAllocation" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% List<BudgetAllocation> budgets=(List<BudgetAllocation>)request.getAttribute("budgets");if(budgets==null)budgets=List.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Budget Transparency - SarkarSathi
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',400:'#60a5fa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <%@ include file="../includes/responsive-scripts.jsp" %>
        <style>
            html{zoom:0.86}body{font-family:'Outfit',sans-serif}
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-16 lg:pb-0 overflow-x-hidden">
        <% String displayName = (String) session.getAttribute("displayName"); boolean loggedIn = displayName != null && !displayName.isBlank(); %>
        <%@ include file="../includes/navbar-public.jsp" %>

        <main>
            <div class="p-6 lg:p-12">
                <!-- Page Title -->
                <div class="max-w-7xl mx-auto mb-10">
                    <div class="flex flex-col lg:flex-row lg:items-end justify-between gap-6">
                        <div class="flex-1 text-center lg:text-left">
                            <div class="flex items-center justify-center lg:justify-start gap-3 text-brand-500 mb-2">
                                <i data-lucide="wallet" class="h-6 w-6"></i>
                                <span class="text-xs font-black uppercase tracking-widest">Financial Sovereignty</span>
                            </div>
                            <h1 class="text-4xl lg:text-5xl font-black text-slate-900 tracking-tight leading-tight">Budget Transparency</h1>
                            <p class="mt-4 text-slate-500 font-medium text-lg leading-relaxed max-w-2xl mx-auto lg:mx-0">
                                Public ledger of fiscal allocations across municipal wards and departments. Empowering citizens through financial clarity.
                            </p>
                        </div>
                    </div>
                </div>

                <%
                    java.util.Set<Integer> wardSet = new java.util.TreeSet<>();
                    java.util.Set<String> deptSet = new java.util.TreeSet<>();
                    double totalBudget = 0;
                    for (BudgetAllocation b : budgets) {
                        wardSet.add(b.getWardId());
                        if (b.getDepartment() != null) deptSet.add(b.getDepartment());
                        if (b.getAllocatedAmount() != null) totalBudget += b.getAllocatedAmount().doubleValue();
                    }
                %>

                <!-- Filter & Stats Bar -->
                <div class="max-w-7xl mx-auto mb-8">
                    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 flex flex-col lg:flex-row lg:items-center gap-4">
                        <!-- Dropdowns -->
                        <div class="flex flex-col sm:flex-row gap-3 flex-1">
                            <div class="relative group flex-1">
                                <label class="block text-[10px] font-black uppercase tracking-[0.15em] text-slate-400 mb-1.5 ml-1">Ward / Location</label>
                                <div class="relative">
                                    <i data-lucide="map-pin" class="absolute left-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-300 pointer-events-none"></i>
                                    <select id="ward-filter" class="w-full rounded-xl border border-slate-200 bg-slate-50 pl-10 pr-4 py-3 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 focus:border-transparent appearance-none transition-all outline-none cursor-pointer">
                                        <option value="all">All Wards</option>
                                        <% for (Integer wid : wardSet) { %>
                                            <option value="<%= wid %>">Ward <%= wid %></option>
                                        <% } %>
                                    </select>
                                    <i data-lucide="chevron-down" class="absolute right-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none"></i>
                                </div>
                            </div>
                            <div class="relative group flex-1">
                                <label class="block text-[10px] font-black uppercase tracking-[0.15em] text-slate-400 mb-1.5 ml-1">Department</label>
                                <div class="relative">
                                    <i data-lucide="building-2" class="absolute left-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-300 pointer-events-none"></i>
                                    <select id="dept-filter" class="w-full rounded-xl border border-slate-200 bg-slate-50 pl-10 pr-4 py-3 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 focus:border-transparent appearance-none transition-all outline-none cursor-pointer">
                                        <option value="all">All Departments</option>
                                        <% for (String dept : deptSet) { %>
                                            <option value="<%= esc(dept) %>"><%= esc(dept) %></option>
                                        <% } %>
                                    </select>
                                    <i data-lucide="chevron-down" class="absolute right-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none"></i>
                                </div>
                            </div>
                        </div>
                        <!-- Quick Stats -->
                        <div class="hidden lg:flex items-center gap-6 pl-6 border-l border-slate-100">
                            <div class="text-center">
                                <p class="text-2xl font-black text-brand-900" id="stat-total">Rs. <%= String.format("%,.0f", totalBudget) %></p>
                                <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Total Budget</p>
                            </div>
                            <div class="text-center">
                                <p class="text-2xl font-black text-slate-900"><%= wardSet.size() %></p>
                                <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Wards</p>
                            </div>
                            <div class="text-center">
                                <p class="text-2xl font-black text-slate-900" id="stat-count"><%= budgets.size() %></p>
                                <p class="text-[10px] font-bold uppercase tracking-widest text-slate-400">Allocations</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Mobile Summary Stats -->
                <div class="max-w-7xl mx-auto mb-6 grid grid-cols-3 gap-3 lg:hidden">
                    <div class="bg-white rounded-xl p-4 border border-slate-100 text-center">
                        <p class="text-lg font-black text-brand-900">Rs. <%= String.format("%,.0f", totalBudget) %></p>
                        <p class="text-[9px] font-bold uppercase tracking-widest text-slate-400 mt-1">Total</p>
                    </div>
                    <div class="bg-white rounded-xl p-4 border border-slate-100 text-center">
                        <p class="text-lg font-black text-slate-900"><%= wardSet.size() %></p>
                        <p class="text-[9px] font-bold uppercase tracking-widest text-slate-400 mt-1">Wards</p>
                    </div>
                    <div class="bg-white rounded-xl p-4 border border-slate-100 text-center">
                        <p class="text-lg font-black text-slate-900"><%= budgets.size() %></p>
                        <p class="text-[9px] font-bold uppercase tracking-widest text-slate-400 mt-1">Allocations</p>
                    </div>
                </div>

                <!-- Ledger View -->
                <div class="max-w-7xl mx-auto">
                    <!-- Cards for Mobile -->
                    <div id="mobile-cards" class="grid gap-4 lg:hidden">
                        <% if(budgets.isEmpty()){ %>
                            <div class="bg-white rounded-2xl p-12 text-center border-2 border-dashed border-slate-200">
                                <i data-lucide="info" class="mx-auto h-12 w-12 text-slate-200 mb-4"></i>
                                <h3 class="text-lg font-black text-slate-900 mb-1">No Public Disclosures</h3>
                                <p class="text-slate-400 font-medium">Budget records are awaiting official publication.</p>
                            </div>
                        <% } else { for(BudgetAllocation b : budgets){ %>
                            <div class="budget-card bg-white rounded-2xl p-5 shadow-sm border border-slate-100 flex flex-col gap-3" data-ward="<%= b.getWardId() %>" data-dept="<%= esc(b.getDepartment()) %>">
                                <div class="flex items-center justify-between">
                                    <span class="text-[10px] font-black uppercase tracking-widest text-brand-500 px-3 py-1 bg-brand-50 rounded-full">
                                        <%= esc(b.getDepartment()) %>
                                    </span>
                                    <span class="text-xs font-black text-slate-400 uppercase tracking-widest">FY <%= b.getFiscalYear() %></span>
                                </div>
                                <div>
                                    <h3 class="text-base font-black text-slate-900 mb-0.5">Ward <%= b.getWardId() %> Allocation</h3>
                                    <p class="text-slate-500 text-sm font-medium line-clamp-2"><%= esc(b.getDescription()==null ? "General ward development fund" : b.getDescription()) %></p>
                                </div>
                                <div class="pt-3 border-t border-slate-50 flex items-center justify-between">
                                    <span class="text-xs font-bold text-slate-400 uppercase tracking-widest">Amount</span>
                                    <span class="text-lg font-black text-emerald-600">Rs. <%= String.format("%,.2f", b.getAllocatedAmount()) %></span>
                                </div>
                            </div>
                        <% }} %>
                    </div>
                    <!-- No results message -->
                    <div id="no-results" class="hidden flex-col items-center justify-center py-20 bg-white rounded-2xl border border-dashed border-slate-200">
                        <i data-lucide="search-x" class="h-12 w-12 text-slate-200 mb-4"></i>
                        <h3 class="text-lg font-black text-slate-900 mb-1">No Matching Records</h3>
                        <p class="text-slate-400 font-medium">Try selecting a different ward or department.</p>
                    </div>

                    <!-- Modern Table for Desktop -->
                    <div class="hidden lg:block overflow-hidden bg-white rounded-2xl shadow-xl shadow-slate-200/40 border border-slate-100">
                        <table class="w-full text-left border-collapse" id="budget-table">
                            <thead>
                                <tr class="bg-slate-50/50">
                                    <th class="px-8 py-5 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Department Profile</th>
                                    <th class="px-8 py-5 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Territory</th>
                                    <th class="px-8 py-5 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Fiscal Period</th>
                                    <th class="px-8 py-5 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 text-right">Allocation (NPR)</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-50">
                                <% if(budgets.isEmpty()){ %>
                                    <tr>
                                        <td colspan="4" class="px-8 py-20 text-center">
                                            <div class="flex flex-col items-center justify-center gap-3">
                                                <i data-lucide="folder-search" class="h-10 w-10 text-slate-200"></i>
                                                <p class="text-slate-400 font-bold uppercase tracking-widest text-xs">Ledger records not found</p>
                                            </div>
                                        </td>
                                    </tr>
                                <% } else { for(BudgetAllocation b : budgets){ %>
                                    <tr class="budget-row hover:bg-brand-50/30 transition-colors group cursor-default" data-ward="<%= b.getWardId() %>" data-dept="<%= esc(b.getDepartment()) %>" data-amount="<%= b.getAllocatedAmount() %>">
                                        <td class="px-8 py-5">
                                            <div class="flex items-center gap-4">
                                                <div class="h-10 w-10 rounded-xl bg-slate-50 flex items-center justify-center text-slate-400 group-hover:bg-brand-900 group-hover:text-white transition-all">
                                                    <i data-lucide="building-2" class="h-5 w-5"></i>
                                                </div>
                                                <div>
                                                    <p class="text-sm font-black text-slate-900"><%= esc(b.getDepartment()) %></p>
                                                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest line-clamp-1 max-w-[200px]"><%= b.getDescription()==null ? "Standard Allocation" : b.getDescription() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-8 py-5">
                                            <span class="inline-flex items-center gap-2 text-xs font-black text-slate-600 uppercase tracking-widest">
                                                <i data-lucide="map-pin" class="h-3 w-3 text-brand-500"></i>
                                                Ward <%= b.getWardId() %>
                                            </span>
                                        </td>
                                        <td class="px-8 py-5">
                                            <span class="text-xs font-black text-slate-400 uppercase tracking-widest">FY <%= b.getFiscalYear() %></span>
                                        </td>
                                        <td class="px-8 py-5 text-right">
                                            <span class="text-sm font-black text-emerald-600 font-sans tracking-tight">Rs. <%= String.format("%,.2f", b.getAllocatedAmount()) %></span>
                                        </td>
                                    </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="../includes/mobile-nav-public.jsp" %>

        <script>
            lucide.createIcons();

            /* ── Budget Filtering ── */
            (function(){
                const wardSel = document.getElementById('ward-filter');
                const deptSel = document.getElementById('dept-filter');
                const rows = document.querySelectorAll('.budget-row');
                const cards = document.querySelectorAll('.budget-card');
                const noResults = document.getElementById('no-results');
                const statTotal = document.getElementById('stat-total');
                const statCount = document.getElementById('stat-count');

                function applyFilter() {
                    const ward = wardSel.value;
                    const dept = deptSel.value;
                    let visible = 0;
                    let total = 0;

                    rows.forEach(r => {
                        const wMatch = ward === 'all' || r.dataset.ward === ward;
                        const dMatch = dept === 'all' || r.dataset.dept === dept;
                        const show = wMatch && dMatch;
                        r.style.display = show ? '' : 'none';
                        if (show) { visible++; total += parseFloat(r.dataset.amount || 0); }
                    });

                    cards.forEach(c => {
                        const wMatch = ward === 'all' || c.dataset.ward === ward;
                        const dMatch = dept === 'all' || c.dataset.dept === dept;
                        c.style.display = (wMatch && dMatch) ? '' : 'none';
                    });

                    if (noResults) {
                        noResults.style.display = visible === 0 ? 'flex' : 'none';
                    }
                    if (statTotal) statTotal.textContent = 'Rs. ' + Math.round(total).toLocaleString();
                    if (statCount) statCount.textContent = visible;
                }

                wardSel.addEventListener('change', applyFilter);
                deptSel.addEventListener('change', applyFilter);
            })();
        </script>
    </body>
</html>
