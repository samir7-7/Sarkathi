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
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif}
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-20 lg:pb-0">
        <!-- Modern Sidebar for Desktop -->
        <aside class="fixed left-0 top-0 hidden h-full w-64 border-r border-slate-200 bg-white lg:block z-50">
            <div class="flex h-full flex-col p-6">
                <a href="<%= request.getContextPath() %>" class="flex items-center gap-2 text-2xl font-black tracking-tight text-brand-900 mb-10">
                    Sarkar<span class="text-brand-500">Sathi</span>
                </a>
                
                <nav class="flex-1 space-y-2">
                    <a href="<%= request.getContextPath() %>/index.jsp" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="home" class="h-5 w-5"></i> Home
                    </a>
                    <a href="<%= request.getContextPath() %>/announcements" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="megaphone" class="h-5 w-5"></i> Announcements
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="leaf" class="h-5 w-5"></i> Agriculture
                    </a>
                    <a href="<%= request.getContextPath() %>/budget" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-black bg-brand-50 text-brand-900 shadow-sm border border-brand-100/50">
                        <i data-lucide="wallet" class="h-5 w-5"></i> Budget
                    </a>
                    <a href="<%= request.getContextPath() %>/crop-advisory" class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 transition-all">
                        <i data-lucide="sprout" class="h-5 w-5"></i> Crop Advisory
                    </a>
                </nav>

                <div class="mt-auto pt-6 border-t border-slate-100">
                    <a href="<%= request.getContextPath() %>/login" class="flex items-center justify-center gap-2 w-full rounded-xl bg-slate-900 py-3 text-sm font-black text-white hover:bg-brand-900 transition-all">
                        <i data-lucide="log-in" class="h-4 w-4"></i> Login
                    </a>
                </div>
            </div>
        </aside>

        <!-- Mobile Header -->
        <header class="sticky top-0 z-40 flex h-16 items-center justify-between border-b border-slate-200 bg-white/80 px-6 backdrop-blur-md lg:hidden">
            <a href="<%= request.getContextPath() %>" class="text-xl font-black tracking-tight text-brand-900">
                Sarkar<span class="text-brand-500">Sathi</span>
            </a>
            <a href="<%= request.getContextPath() %>/login" class="rounded-lg bg-brand-50 p-2 text-brand-900">
                <i data-lucide="user" class="h-5 w-5"></i>
            </a>
        </header>

        <main class="min-h-screen lg:ml-64 relative">
            <div class="p-6 lg:p-12">
                <!-- Page Title -->
                <div class="max-w-6xl mx-auto mb-12 flex flex-col lg:flex-row lg:items-end justify-between gap-6">
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

                <!-- Ledger View -->
                <div class="max-w-6xl mx-auto">
                    <!-- Cards for Mobile -->
                    <div class="grid gap-6 lg:hidden">
                        <% if(budgets.isEmpty()){ %>
                            <div class="bg-white rounded-[2.5rem] p-12 text-center border-2 border-dashed border-slate-200">
                                <i data-lucide="info" class="mx-auto h-12 w-12 text-slate-200 mb-4"></i>
                                <h3 class="text-lg font-black text-slate-900 mb-1">No Public Disclosures</h3>
                                <p class="text-slate-400 font-medium italic">Budget records are awaiting official publication.</p>
                            </div>
                        <% } else { for(BudgetAllocation b : budgets){ %>
                            <div class="bg-white rounded-[2rem] p-6 shadow-xl shadow-slate-200/50 border border-slate-100 flex flex-col gap-4">
                                <div class="flex items-center justify-between">
                                    <span class="text-[10px] font-black uppercase tracking-widest text-brand-500 px-3 py-1 bg-brand-50 rounded-full">
                                        <%= esc(b.getDepartment()) %>
                                    </span>
                                    <span class="text-xs font-black text-slate-400 uppercase tracking-widest">FY <%= b.getFiscalYear() %></span>
                                </div>
                                <div>
                                    <h3 class="text-lg font-black text-slate-900 mb-1">Ward <%= b.getWardId() %> Allocation</h3>
                                    <p class="text-slate-500 text-sm font-medium line-clamp-2"><%= esc(b.getDescription()==null ? "General ward development fund" : b.getDescription()) %></p>
                                </div>
                                <div class="pt-4 border-t border-slate-50 flex items-center justify-between">
                                    <span class="text-xs font-bold text-slate-400 uppercase tracking-widest">Amount Disbursed</span>
                                    <span class="text-xl font-black text-emerald-600">Rs. <%= String.format("%,.2f", Double.parseDouble(b.getAllocatedAmount())) %></span>
                                </div>
                            </div>
                        <% }} %>
                    </div>

                    <!-- Modern Table for Desktop -->
                    <div class="hidden lg:block overflow-hidden bg-white rounded-[2.5rem] shadow-2xl shadow-slate-200/40 border border-slate-100">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50/50">
                                    <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Department Profile</th>
                                    <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Territory</th>
                                    <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Fiscal Period</th>
                                    <th class="px-8 py-6 text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 text-right">Allocation (NPR)</th>
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
                                    <tr class="hover:bg-brand-50/30 transition-colors group cursor-default">
                                        <td class="px-8 py-6">
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
                                        <td class="px-8 py-6">
                                            <span class="inline-flex items-center gap-2 text-xs font-black text-slate-600 uppercase tracking-widest">
                                                <i data-lucide="map-pin" class="h-3 w-3 text-brand-500"></i>
                                                Ward <%= b.getWardId() %>
                                            </span>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="text-xs font-black text-slate-400 uppercase tracking-widest">FY <%= b.getFiscalYear() %></span>
                                        </td>
                                        <td class="px-8 py-6 text-right">
                                            <span class="text-sm font-black text-emerald-600 font-sans tracking-tight">Rs. <%= String.format("%,.2f", Double.parseDouble(b.getAllocatedAmount())) %></span>
                                        </td>
                                    </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <!-- Mobile Global Navigation -->
        <nav class="fixed bottom-0 left-0 right-0 z-50 border-t border-slate-200 bg-white/95 px-6 pb-safe backdrop-blur-md lg:hidden">
            <div class="flex h-16 items-center justify-between">
                <a href="<%= request.getContextPath() %>/index.jsp" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="home" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/announcements" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="megaphone" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">News</span>
                </a>
                <a href="<%= request.getContextPath() %>/agriculture" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="leaf" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Agri</span>
                </a>
                <a href="<%= request.getContextPath() %>/budget" class="flex flex-col items-center gap-1 text-brand-900">
                    <div class="bg-brand-100/50 p-2 rounded-xl">
                        <i data-lucide="wallet" class="h-5 w-5"></i>
                    </div>
                    <span class="text-[10px] font-black uppercase tracking-tighter leading-none mt-1">Budget</span>
                </a>
                <a href="<%= request.getContextPath() %>/crop-advisory" class="flex flex-col items-center gap-1 text-slate-400 hover:text-brand-900">
                    <i data-lucide="sprout" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Advisory</span>
                </a>
            </div>
        </nav>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>
