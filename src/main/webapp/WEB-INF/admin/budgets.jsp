<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.BudgetAllocation" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value) { if (value == null) return ""; return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;"); } %>
<% Integer adminId=(Integer)request.getAttribute("adminId"); String adminName=(String)request.getAttribute("adminName"); String adminRole=(String)request.getAttribute("adminRole"); String pageError=(String)request.getAttribute("pageError"); String formError=request.getParameter("error"); List<BudgetAllocation> budgets=(List<BudgetAllocation>)request.getAttribute("budgets"); String editingBudgetId=(String)request.getAttribute("editingBudgetId"); if(adminName==null)adminName="Admin"; if(adminRole==null)adminRole="admin"; if(budgets==null)budgets=List.of(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Manage Budgets - SarkarSathi Admin
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',500:'#3b82f6',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif;-webkit-tap-highlight-color:transparent}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden uppercase-none">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav (Admin) -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/90 backdrop-blur-lg px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/applications" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="clipboard-list" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Review</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin/announcements" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="megaphone" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Public</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500 transition-all">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Menu</span>
                </button>
            </nav>

            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            
            <%@ include file="../includes/sidebar-admin.jsp" %>


            <div class="flex-1 flex flex-col min-h-screen w-full overflow-hidden pb-16 lg:pb-0">

                <header class="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-slate-200 px-6 py-4 sm:px-8">
                    <h1 class="text-lg font-bold text-slate-900 tracking-tight">Financial Governance</h1>
                    <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest leading-none mt-1">Budget Allocation Desk</p>
                </header>
                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-6xl mx-auto">
                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-6 rounded-2xl border-l-4 border-red-500 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700 shadow-sm animate-pulse">
                            <i data-lucide="alert-circle" class="inline-block h-4 w-4 mr-1"></i>
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>

                    <section class="mb-10 rounded-[2.5rem] border border-slate-100 bg-white p-6 sm:p-8 shadow-sm overflow-hidden">
                        <div class="flex items-center gap-3 mb-8">
                            <div class="h-10 w-10 rounded-xl bg-orange-100 text-orange-600 flex items-center justify-center">
                                <i data-lucide="plus-square" class="h-6 w-6"></i>
                            </div>
                            <h3 class="text-lg font-extrabold text-slate-900 tracking-tight">New Allocation</h3>
                        </div>
                        <form method="post" action="<%= request.getContextPath() %>/api/budgets" class="space-y-6">
                            <input type="hidden" name="redirectTo" value="/admin/budgets">
                            <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
                                <div class="col-span-full lg:col-span-2">
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Target Department</label>
                                    <input name="department" type="text" required placeholder="e.g., Infrastructure, Education" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-orange-500/20 outline-none">
                                </div>
                                <div class="lg:col-span-1">
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Ward Assignment</label>
                                    <div class="relative">
                                        <i data-lucide="map-pin" class="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400 pointer-events-none"></i>
                                        <input name="wardId" type="number" required value="1" class="w-full rounded-2xl border-0 bg-slate-50 pl-11 pr-5 py-4 text-sm font-bold focus:ring-2 focus:ring-orange-500/20 outline-none">
                                    </div>
                                </div>
                                <div class="lg:col-span-1">
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Fiscal Period</label>
                                    <input name="fiscalYear" type="text" required placeholder="2082/83" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold focus:ring-2 focus:ring-orange-500/20 outline-none">
                                </div>
                                <div class="sm:col-span-1 lg:col-span-1">
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Fund Amount (Rs.)</label>
                                    <input name="allocatedAmount" type="number" required min="1" placeholder="500000" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-black text-brand-900 focus:ring-2 focus:ring-orange-500/20 outline-none">
                                </div>
                                <div class="sm:col-span-1 lg:col-span-3">
                                    <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Allocation Purpose</label>
                                    <input name="description" type="text" placeholder="Brief note on fund utilization" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-orange-500/20 outline-none">
                                </div>
                                <div class="col-span-full pt-2">
                                    <button class="w-full rounded-2xl bg-brand-900 px-8 py-5 text-sm font-bold text-white shadow-xl shadow-brand-900/10 active:scale-[0.98] transition-transform" type="submit">
                                        Confirm Fund Allocation
                                    </button>
                                </div>
                            </div>
                        </form>
                    </section>

                    <!-- Desktop View (Large Screens) -->
                    <div class="hidden lg:block rounded-[2.5rem] border border-slate-100 bg-white shadow-sm overflow-hidden">
                        <table class="w-full text-left text-sm border-collapse">
                            <thead>
                                <tr class="bg-slate-50/50">
                                    <th class="px-8 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500">Department</th>
                                    <th class="px-8 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500 text-center">Ward</th>
                                    <th class="px-8 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500">Fiscal Year</th>
                                    <th class="px-8 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500 text-right">Fund Allocation</th>
                                    <th class="px-8 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500">Control</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <% if(budgets.isEmpty()){ %>
                                    <tr>
                                        <td colspan="5" class="px-8 py-20 text-center text-slate-400">
                                            <div class="flex flex-col items-center gap-3">
                                                <i data-lucide="database" class="h-10 w-10 opacity-20"></i>
                                                <span class="font-medium">No active budget entries found.</span>
                                            </div>
                                        </td>
                                    </tr>
                                <% } else { for(BudgetAllocation b: budgets){ %>
                                    <tr class="hover:bg-slate-50/50 transition-colors">
                                        <td class="px-8 py-6">
                                            <p class="font-black text-slate-900"><%= esc(b.getDepartment()) %></p>
                                            <p class="text-[10px] text-slate-400 font-bold uppercase truncate max-w-[250px]"><%= esc(b.getDescription()==null?"No description":b.getDescription()) %></p>
                                        </td>
                                        <td class="px-8 py-6 text-center">
                                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-50 text-[10px] font-black text-brand-700 ring-1 ring-brand-200">
                                                <%= b.getWardId() %>
                                            </span>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="text-xs font-bold text-slate-600 bg-slate-100 px-3 py-1 rounded-full"><%= esc(b.getFiscalYear()) %></span>
                                        </td>
                                        <td class="px-8 py-6 text-right">
                                            <p class="text-[10px] font-black text-slate-400 uppercase leading-none mb-1">Total Rs.</p>
                                            <p class="text-base font-black text-emerald-600 tracking-tight leading-none"><%= esc(b.getAllocatedAmount()) %></p>
                                        </td>
                                        <td class="px-8 py-6 flex gap-2 items-center justify-end">
                                            <form method="get" action="<%= request.getContextPath() %>/admin/budgets" class="inline">
                                                <input type="hidden" name="edit" value="<%= b.getBudgetId() %>">
                                                <button class="p-2 text-blue-300 hover:text-blue-600 transition-colors" title="Edit" type="submit">
                                                    <i data-lucide="edit-2" class="h-5 w-5"></i>
                                                </button>
                                            </form>
                                            <form method="post" action="<%= request.getContextPath() %>/api/budgets" onsubmit="return confirm('Are you sure you want to delete?')" class="inline">
                                                <input type="hidden" name="redirectTo" value="/admin/budgets">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>">
                                                <button class="p-2 text-red-300 hover:text-red-600 transition-colors" type="submit">
                                                    <i data-lucide="trash-2" class="h-5 w-5"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <tr <% if(editingBudgetId!=null && editingBudgetId.equals(String.valueOf(b.getBudgetId()))) { %> style="display:table-row" <% } else { %> style="display:none" <% } %> class="bg-slate-50/30">
                                        <td colspan="5" class="px-8 pb-8">
                                            <div class="mt-2 rounded-2xl border border-slate-200 bg-white p-6">
                                                <div class="mb-4 flex items-center justify-between">
                                                    <div>
                                                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Editing allocation</p>
                                                        <p class="text-sm font-black text-slate-900">#<%= b.getBudgetId() %> &mdash; <%= esc(b.getDepartment()) %></p>
                                                    </div>
                                                    <a href="<%= request.getContextPath() %>/admin/budgets" class="rounded-xl bg-slate-200 px-4 py-2 text-[10px] font-black uppercase tracking-widest text-slate-700 hover:bg-slate-300 transition-colors">Cancel</a>
                                                </div>
                                                <form method="post" action="<%= request.getContextPath() %>/api/budgets" class="space-y-4">
                                                    <input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>">
                                                    <input type="hidden" name="_method" value="PUT">
                                                    <input type="hidden" name="redirectTo" value="/admin/budgets">
                                                    <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                                                        <div class="col-span-full lg:col-span-2">
                                                            <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Department</label>
                                                            <input name="department" type="text" required value="<%= esc(b.getDepartment()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-orange-500/20 outline-none">
                                                        </div>
                                                        <div class="lg:col-span-1">
                                                            <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Ward</label>
                                                            <input name="wardId" type="number" required value="<%= b.getWardId() %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold focus:ring-2 focus:ring-orange-500/20 outline-none">
                                                        </div>
                                                        <div class="lg:col-span-1">
                                                            <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Fiscal Year</label>
                                                            <input name="fiscalYear" type="text" required value="<%= esc(b.getFiscalYear()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold focus:ring-2 focus:ring-orange-500/20 outline-none">
                                                        </div>
                                                        <div class="sm:col-span-1 lg:col-span-1">
                                                            <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Fund Amount (Rs.)</label>
                                                            <input name="allocatedAmount" type="number" required min="1" value="<%= esc(b.getAllocatedAmount().toString()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-black text-brand-900 focus:ring-2 focus:ring-orange-500/20 outline-none">
                                                        </div>
                                                        <div class="sm:col-span-1 lg:col-span-3">
                                                            <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Description</label>
                                                            <input name="description" type="text" value="<%= esc(b.getDescription()==null?"":b.getDescription()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-orange-500/20 outline-none">
                                                        </div>
                                                        <div class="col-span-full">
                                                            <button class="w-full rounded-2xl bg-brand-900 px-6 py-4 text-sm font-bold text-white hover:bg-brand-800 transition-colors" type="submit">Save Changes</button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Mobile View (Grid of Cards) -->
                    <div class="lg:hidden space-y-4">
                        <% if(budgets.isEmpty()){ %>
                            <div class="rounded-[2rem] border border-dashed border-slate-200 bg-slate-50/50 p-16 text-center">
                                <i data-lucide="inbox" class="mx-auto h-12 w-12 text-slate-300 mb-4"></i>
                                <p class="text-sm font-bold text-slate-400 uppercase tracking-widest">No allocations</p>
                            </div>
                        <% } else { for(BudgetAllocation b: budgets){ %>
                            <div class="rounded-3xl border border-slate-100 bg-white p-6 shadow-sm">
                                <div class="flex items-start justify-between mb-4">
                                    <div>
                                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Ward <%= b.getWardId() %></p>
                                        <h4 class="text-lg font-black text-slate-900 leading-tight"><%= esc(b.getDepartment()) %></h4>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-[10px] font-bold text-slate-400 uppercase mb-1"><%= esc(b.getFiscalYear()) %></p>
                                        <p class="text-lg font-black text-emerald-600">Rs. <%= esc(b.getAllocatedAmount()) %></p>
                                    </div>
                                </div>
                                <div class="mb-5 rounded-2xl bg-slate-50 p-4">
                                    <p class="text-xs font-semibold text-slate-600 leading-relaxed"><%= esc(b.getDescription()==null?"Official budget allocation for departmental projects.":b.getDescription()) %></p>
                                </div>
                                <div class="flex gap-3 justify-end">
                                    <form method="get" action="<%= request.getContextPath() %>/admin/budgets" class="inline">
                                        <input type="hidden" name="edit" value="<%= b.getBudgetId() %>">
                                        <button class="flex items-center gap-2 rounded-xl bg-blue-50 px-4 py-2.5 text-xs font-bold text-blue-600 transition-all active:scale-95" type="submit">
                                            <i data-lucide="edit-2" class="h-4 w-4"></i>
                                            Edit
                                        </button>
                                    </form>
                                    <form method="post" action="<%= request.getContextPath() %>/api/budgets" onsubmit="return confirm('Are you sure you want to delete?')" class="inline">
                                        <input type="hidden" name="redirectTo" value="/admin/budgets">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>">
                                        <button class="flex items-center gap-2 rounded-xl bg-red-50 px-4 py-2.5 text-xs font-bold text-red-600 transition-all active:scale-95" type="submit">
                                            <i data-lucide="trash-2" class="h-4 w-4"></i>
                                            Revoke Fund
                                        </button>
                                    </form>
                                </div>
                                <div <% if(editingBudgetId!=null && editingBudgetId.equals(String.valueOf(b.getBudgetId()))) { %> style="display:block" <% } else { %> style="display:none" <% } %> id="edit-budget-<%= b.getBudgetId() %>" class="mt-6 pt-6 border-t border-slate-200">
                                    <form method="post" action="<%= request.getContextPath() %>/api/budgets" class="space-y-4">
                                        <input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>">
                                        <input type="hidden" name="_method" value="PUT">
                                        <input type="hidden" name="redirectTo" value="/admin/budgets">
                                        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                                            <div class="col-span-full lg:col-span-2">
                                                <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Department</label>
                                                <input name="department" type="text" required value="<%= esc(b.getDepartment()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-orange-500/20 outline-none">
                                            </div>
                                            <div class="lg:col-span-1">
                                                <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Ward</label>
                                                <input name="wardId" type="number" required value="<%= b.getWardId() %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold focus:ring-2 focus:ring-orange-500/20 outline-none">
                                            </div>
                                            <div class="lg:col-span-1">
                                                <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Fiscal Year</label>
                                                <input name="fiscalYear" type="text" required value="<%= esc(b.getFiscalYear()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold focus:ring-2 focus:ring-orange-500/20 outline-none">
                                            </div>
                                            <div class="sm:col-span-1 lg:col-span-1">
                                                <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Fund Amount (Rs.)</label>
                                                <input name="allocatedAmount" type="number" required min="1" value="<%= esc(b.getAllocatedAmount().toString()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-black text-brand-900 focus:ring-2 focus:ring-orange-500/20 outline-none">
                                            </div>
                                            <div class="sm:col-span-1 lg:col-span-3">
                                                <label class="mb-1.5 ml-1 block text-[10px] font-bold uppercase tracking-widest text-slate-400">Description</label>
                                                <input name="description" type="text" value="<%= esc(b.getDescription()==null?"":b.getDescription()) %>" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-medium focus:ring-2 focus:ring-orange-500/20 outline-none">
                                            </div>
                                            <div class="col-span-full flex gap-2">
                                                <button class="flex-1 rounded-2xl bg-brand-900 px-6 py-4 text-sm font-bold text-white hover:bg-brand-800 transition-colors" type="submit">Save Changes</button>
                                                <a href="<%= request.getContextPath() %>/admin/budgets" class="flex-1 w-full rounded-2xl bg-slate-200 px-6 py-4 text-sm font-bold text-slate-700 hover:bg-slate-300 transition-colors text-center">Cancel</a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        <% }} %>
                    </div>
                </main>
            </div>
        </div>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebar-overlay');
                const isHidden = sidebar.classList.contains('translate-x-full');
                
                if (isHidden) {
                    sidebar.classList.remove('translate-x-full');
                    overlay.classList.remove('hidden');
                    document.body.style.overflow = 'hidden';
                } else {
                    sidebar.classList.add('translate-x-full');
                    overlay.classList.add('hidden');
                    document.body.style.overflow = '';
                }
            }
            function toggleBudgetEdit(budgetId) {
                const form = document.getElementById('edit-budget-' + budgetId);
                if (form) {
                    form.classList.toggle('hidden');
                    form.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                }
            }
            lucide.createIcons();
        </script>
    </body>
</html>
