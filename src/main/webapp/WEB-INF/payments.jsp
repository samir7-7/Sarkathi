<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.TaxRecord" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% Integer citizenId=(Integer)request.getAttribute("citizenId");String citizenName=(String)request.getAttribute("citizenName");Integer unread=(Integer)request.getAttribute("unreadCount");String formError=request.getParameter("error");List<TaxRecord> taxRecords=(List<TaxRecord>)request.getAttribute("taxRecords");if(citizenName==null)citizenName="Citizen";if(unread==null)unread=0;if(taxRecords==null)taxRecords=List.of();String initials=citizenName.isBlank()?"C":citizenName.substring(0,1).toUpperCase(); %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>
            Payments - SarkarSathi
        </title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com">
        </script>
        <script>
            tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
        </script>
        <style>
            body{font-family:'Outfit',sans-serif}.sidebar-link{transition:all .2s}.sidebar-link:hover,.sidebar-link.active{background:#f0f5fc;color:#0b3d86;font-weight:600}
        </style>
    </head>
    <body class="bg-[#fafafc] text-slate-800">
        <div class="flex min-h-screen">
            <aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
                <div class="px-5 pt-5 pb-2">
                    <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">
                        SarkarSathi
                    </a>
                </div>
                <div class="mx-5 mt-3 flex items-center gap-3 rounded-xl bg-brand-50 px-4 py-3">
                    <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-white text-xs font-bold">
                        <%= esc(initials) %>
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-brand-900 truncate">
                            <%= esc(citizenName) %>
                        </p>
                        <p class="text-[11px] text-slate-500">
                            Citizen
                        </p>
                    </div>
                </div>
                <nav class="mt-6 flex-1 space-y-1 px-3">
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Apply for Service
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Track Application
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
                        Payments & Tax
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        Certificates
                    </a>
                    <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
                        My Documents
                    </a>
                </nav>
                <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3">
                    <a href="<%= request.getContextPath() %>/logout" class="sidebar-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-red-600">
                        Logout
                    </a>
                </div>
            </aside>
            <div class="ml-[220px] flex-1 flex flex-col min-h-screen">
                <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 px-8 py-3.5">
                    <div>
                        <h1 class="text-lg font-bold text-slate-900">
                            Payments & Tax Records
                        </h1>
                        <p class="text-xs text-slate-500">
                            Manage your tax payments and view receipts
                        </p>
                    </div>
                    <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600">
                        Bell
                        <% if(unread>0){ %>
                            <span class="absolute -right-1 -top-1 min-w-[18px] rounded-full bg-red-500 px-1.5 py-0.5 text-center text-[10px] font-bold text-white">
                                <%= unread %>
                            </span>
                        <% } %>
                    </a>
                </header>
                <main class="flex-1 px-8 py-8 overflow-y-auto">
                    <% if(formError!=null){ %>
                        <div class="mb-6 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                            <%= esc(formError) %>
                        </div>
                    <% } %>
                    <div class="grid gap-6 lg:grid-cols-2 mb-8">
                        <form method="post" action="<%= request.getContextPath() %>/api/payments" class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                            <input type="hidden" name="redirectTo" value="/citizen/payments">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">
                            <input type="hidden" name="paymentType" value="housetax">
                            <h3 class="text-base font-bold text-slate-900">
                                House Tax
                            </h3>
                            <label class="mt-5 block text-xs font-semibold uppercase tracking-wider text-slate-400">
                                Amount (Rs.)
                            </label>
                            <input name="amount" type="number" value="5000" required class="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm">
                            <button class="mt-4 w-full rounded-xl bg-blue-600 py-3 text-sm font-semibold text-white" type="submit">
                                Pay House Tax
                            </button>
                        </form>
                        <form method="post" action="<%= request.getContextPath() %>/api/payments" class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                            <input type="hidden" name="redirectTo" value="/citizen/payments">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">
                            <input type="hidden" name="paymentType" value="landtax">
                            <h3 class="text-base font-bold text-slate-900">
                                Land Tax
                            </h3>
                            <label class="mt-5 block text-xs font-semibold uppercase tracking-wider text-slate-400">
                                Amount (Rs.)
                            </label>
                            <input name="amount" type="number" value="3000" required class="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm">
                            <button class="mt-4 w-full rounded-xl bg-green-600 py-3 text-sm font-semibold text-white" type="submit">
                                Pay Land Tax
                            </button>
                        </form>
                    </div>
                    <div class="rounded-2xl border border-slate-100 bg-white shadow-sm overflow-hidden">
                        <table class="w-full text-left text-sm">
                            <thead>
                                <tr class="border-b border-slate-100">
                                    <th class="px-6 py-3">
                                        Type
                                    </th>
                                    <th class="px-6 py-3">
                                        Fiscal Year
                                    </th>
                                    <th class="px-6 py-3">
                                        Amount
                                    </th>
                                    <th class="px-6 py-3">
                                        Status
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(taxRecords.isEmpty()){ %>
                                    <tr>
                                        <td colspan="4" class="px-6 py-8 text-center text-slate-400">
                                            No tax records
                                        </td>
                                    </tr>
                                <% } else { for(TaxRecord t:taxRecords){ %>
                                    <tr class="border-b border-slate-50">
                                        <td class="px-6 py-4 capitalize">
                                            <%= esc(t.getTaxType()) %>
                                        </td>
                                        <td class="px-6 py-4">
                                            <%= esc(t.getFiscalYear()) %>
                                        </td>
                                        <td class="px-6 py-4">
                                            Rs. <%= esc(t.getDueAmount()) %>
                                        </td>
                                        <td class="px-6 py-4">
                                            <%= t.isPaid()?"Paid":"Due" %>
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
