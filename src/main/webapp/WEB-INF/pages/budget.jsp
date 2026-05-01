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
    <body class="bg-[#fafafc] text-slate-800">
        <header class="border-b border-slate-200 bg-white px-6 lg:px-12">
            <nav class="mx-auto flex max-w-7xl items-center justify-between py-4">
                <a href="<%= request.getContextPath() %>/" class="text-2xl font-bold tracking-tight text-brand-900">
                    Sarkar<span class="text-brand-500">Sathi</span>
                </a>
                <div class="hidden items-center gap-8 text-sm font-medium text-slate-600 lg:flex">
                    <a href="<%= request.getContextPath() %>/announcements">
                        <i data-lucide="megaphone" class="h-4 w-4 shrink-0"></i>
                            <span>Announcements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/agriculture">
                        Agriculture
                    </a>
                    <a href="<%= request.getContextPath() %>/budget" class="text-brand-900 font-semibold">
                        Budget
                    </a>
                    <a href="<%= request.getContextPath() %>/crop-advisory">
                        Crop Advisory
                    </a>
                </div>
                <a href="<%= request.getContextPath() %>/login" class="rounded-xl bg-brand-900 px-6 py-2.5 text-sm font-semibold text-white">
                    Login
                </a>
            </nav>
        </header>
        <main class="px-6 py-12 lg:px-12">
            <div class="mx-auto max-w-6xl">
                <div class="text-center mb-12">
                    <h1 class="text-4xl font-bold text-slate-900">
                        Budget Transparency
                    </h1>
                    <p class="mt-3 text-lg text-slate-500">
                        Ward-level financial allocations for the current fiscal year
                    </p>
                </div>
                <div class="overflow-hidden rounded-2xl border border-slate-10０ bg-white shadow-sm">
                    <table class="w-full text-left text-sm">
                        <thead>
                            <tr class="border-b border-slate-1０ bg-slate-5０">
                                <th class="px-6 py-3">
                                    Department
                                </th>
                                <th class="px-6 py-3">
                                    Ward
                                </th>
                                <th class="px-6 py-3">
                                    Amount
                                </th>
                                <th class="px-6 py-3">
                                    Fiscal Year
                                </th>
                                <th class="px-6 py-3">
                                    Description
                                </th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-5０">
                            <% if(budgets.isEmpty()){ %>
                                <tr>
                                    <td colspan="5" class="px-6 py-8 text-center text-slate-4０">
                                        No allocations available
                                    </td>
                                </tr>
                            <% } else { for(BudgetAllocation b:budgets){ %>
                                <tr>
                                    <td class="px-6 py-4 font-medium">
                                        <%= esc(b.getDepartment()) %>
                                    </td>
                                    <td class="px-6 py-4">
                                        Ward
                                        <%= b.getWardId() %>
                                    </td>
                                    <td class="px-6 py_4 font-semibold">
                                        Rs. <%= esc(b.getAllocatedAmount()) %>
                                    </td>
                                    <td class="px-6 py_4">
                                        <%= esc(b.getFiscalYear()) %>
                                    </td>
                                    <td class="px_6 py_4 text-slate_5０">
                                        <%= esc(b.getDescription()==null?"-",b.getDescription()) %>
                                    </td>
                                </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </body>
</html>
