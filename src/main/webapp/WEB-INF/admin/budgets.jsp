<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.BudgetAllocation" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value) { if (value == null) return ""; return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;"); } %>
<% Integer adminId=(Integer)request.getAttribute("adminId"); String adminName=(String)request.getAttribute("adminName"); String adminRole=(String)request.getAttribute("adminRole"); String pageError=(String)request.getAttribute("pageError"); String formError=request.getParameter("error"); List<BudgetAllocation> budgets=(List<BudgetAllocation>)request.getAttribute("budgets"); if(adminName==null)adminName="Admin"; if(adminRole==null)adminRole="admin"; if(budgets==null)budgets=List.of(); %>
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
            body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <div class="flex min-h-screen">
            <aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
                <div class="flex items-center gap-1.5 px-5 pt-5 pb-2">
                    <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">
                        SarkarSathi
                    </a>
                    <span class="text-xl font-bold text-brand-500">
                        Admin
                    </span>
                </div>
                <div class="mx-5 mt-3 rounded-xl bg-brand-50 px-4 py-3">
                    <p class="text-sm font-semibold text-brand-900">
                        <%= esc(adminName) %>
                    </p>
                    <p class="text-[11px] text-slate-500">
                        <%= esc(adminRole) %>
                    </p>
                </div>
                <nav class="mt-6 flex-1 space-y-1 px-3">
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="layout-dashboard" class="h-4 w-4 shrink-0"></i>
                            <span>Dashboard</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/applications" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="clipboard-list" class="h-4 w-4 shrink-0"></i>
                            <span>Applications</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/announcements" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="megaphone" class="h-4 w-4 shrink-0"></i>
                            <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/notices" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        <i data-lucide="sprout" class="h-4 w-4 shrink-0"></i>
                            <span>Agri Notices</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/budgets" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
                        <i data-lucide="banknote" class="h-4 w-4 shrink-0"></i>
                            <span>Budgets</span>
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600">
                        <i data-lucide="log-out" class="h-4 w-4 shrink-0"></i>
                            <span>Logout</span>
                    </a>
                </div>
            </aside>
            <div class="ml-[220px] flex-1 flex flex-col min-h-screen">
                <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <h1 class="text-lg font-bold text-slate-900">
                        Manage Budget Allocations
                    </h1>
                </header>
                <main class="flex-1 px-8 py-8 overflow-y-auto">
                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-6 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>
                    <section class="mb-8 rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                        <h3 class="text-base font-bold text-slate-900 mb-4">
                            New Budget Allocation
                        </h3>
                        <form method="post" action="<%= request.getContextPath() %>/api/budgets">
                            <input type="hidden" name="redirectTo" value="/admin/budgets">
                            <div class="grid md:grid-cols-2 gap-4">
                                <div>
                                    <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                        Department
                                    </label>
                                    <input name="department" type="text" required placeholder="e.g., Education, Health" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                </div>
                                <div>
                                    <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                        Ward ID
                                    </label>
                                    <input name="wardId" type="number" required value="1" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                </div>
                                <div>
                                    <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                        Allocated Amount (Rs.)
                                    </label>
                                    <input name="allocatedAmount" type="number" required min="1" placeholder="500000" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                </div>
                                <div>
                                    <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                        Fiscal Year
                                    </label>
                                    <input name="fiscalYear" type="text" required placeholder="2082/83" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                </div>
                                <div class="md:col-span-2">
                                    <label class="mb-1 block text-xs font-semibold uppercase tracking-wider text-slate-800">
                                        Description
                                    </label>
                                    <input name="description" type="text" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none focus:border-brand-500">
                                </div>
                            </div>
                            <button class="mt-4 rounded-xl bg-brand-900 px-5 py-3 text-sm font-semibold text-white hover:bg-brand-800" type="submit">
                                Add Allocation
                            </button>
                        </form>
                    </section>
                    <div class="rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
                        <table class="w-full text-left text-sm">
                            <thead>
                                <tr class="border-b border-slate-100">
                                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">
                                        Department
                                    </th>
                                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">
                                        Ward
                                    </th>
                                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">
                                        Amount
                                    </th>
                                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">
                                        Fiscal Year
                                    </th>
                                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">
                                        Description
                                    </th>
                                    <th class="px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">
                                        Actions
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-50">
                                <% if(budgets.isEmpty()){ %>
                                    <tr>
                                        <td colspan="6" class="px-6 py-8 text-center text-sm text-slate-400">
                                            No allocations
                                        </td>
                                    </tr>
                                <% } else { for(BudgetAllocation b: budgets){ %>
                                    <tr class="hover:bg-slate-50">
                                        <td class="px-6 py-4 font-medium text-slate-700">
                                            <%= esc(b.getDepartment()) %>
                                        </td>
                                        <td class="px-6 py-4 text-slate-600">
                                            Ward
                                            <%= b.getWardId() %>
                                        </td>
                                        <td class="px-6 py-4 font-semibold text-slate-900">
                                            Rs. <%= esc(b.getAllocatedAmount()) %>
                                        </td>
                                        <td class="px-6 py-4 text-slate-600">
                                            <%= esc(b.getFiscalYear()) %>
                                        </td>
                                        <td class="px-6 py-4 text-slate-500 max-w-[200px] truncate">
                                            <%= esc(b.getDescription()==null?"-":b.getDescription()) %>
                                        </td>
                                        <td class="px-6 py-4">
                                            <form method="post" action="<%= request.getContextPath() %>/api/budgets">
                                                <input type="hidden" name="redirectTo" value="/admin/budgets">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="budgetId" value="<%= b.getBudgetId() %>">
                                                <button class="rounded-lg border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-600 hover:bg-red-50" type="submit">
                                                    Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>
