<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.TaxRecord" %>
<%@ page import="java.util.List" %>
<%! private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");} %>
<% 
    Integer citizenId = (Integer)request.getAttribute("citizenId"); 
    String citizenName = (String)request.getAttribute("citizenName"); 
    Integer unread = (Integer)request.getAttribute("unreadCount"); 
    String formError = request.getParameter("error"); 
    List<TaxRecord> taxRecords = (List<TaxRecord>)request.getAttribute("taxRecords"); 
    
    if(citizenName == null) citizenName = "Citizen";
    if(unread == null) unread = 0;
    if(taxRecords == null) taxRecords = List.of();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Payments - SarkarSathi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config={
                theme:{
                    extend:{
                        fontFamily:{sans:['Outfit','sans-serif']},
                        colors:{
                            brand:{
                                50:'#f0f5fc',
                                500:'#3b82f6',
                                900:'#0b3d86'
                            }
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 600; }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Home</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Apply</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Track</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/notifications" class="flex flex-col items-center justify-center gap-1 text-slate-500 relative">
                    <i data-lucide="bell" class="h-5 w-5"></i>
                    <% if(unread>0){ %><span class="absolute top-0 right-1 h-2 w-2 rounded-full bg-red-500"></span><% } %>
                    <span class="text-[10px] font-medium">Inbox</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-500">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-medium">Menu</span>
                </button>
            </nav>

            <!-- Sidebar -->
            <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 -translate-x-full border-r border-slate-200 bg-white transition-transform duration-300 lg:static lg:translate-x-0">
                <div class="flex h-full flex-col">
                    <div class="p-6 border-b border-slate-100 flex items-center justify-between">
                        <a href="<%= request.getContextPath() %>/" class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</a>
                        <button onclick="toggleSidebar()" class="lg:hidden p-2 text-slate-400"><i data-lucide="x" class="h-5 w-5"></i></button>
                    </div>

                    <div class="p-6">
                        <div class="flex items-center gap-3 p-4 rounded-2xl bg-slate-50 border border-slate-100 mb-8">
                            <div class="h-10 w-10 flex items-center justify-center rounded-xl bg-brand-900 text-white font-bold uppercase text-xs">
                                <%= citizenName.substring(0,1).toUpperCase() %>
                            </div>
                            <div class="overflow-hidden">
                                <p class="text-sm font-bold text-slate-900 truncate tracking-tight"><%= esc(citizenName) %></p>
                                <p class="text-[10px] font-medium text-slate-500 uppercase tracking-widest">Citizen Profile</p>
                            </div>
                        </div>

                        <nav class="space-y-1">
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                                <span>Home Board</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/apply" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="file-plus-2" class="h-5 w-5"></i>
                                <span>Apply for Service</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/tracking" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="search-check" class="h-5 w-5"></i>
                                <span>Track Status</span>
                            </a>
                            <p class="px-2 text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-2 mt-8">RECORDS</p>
                            <a href="<%= request.getContextPath() %>/citizen/payments" class="sidebar-link active flex items-center gap-3 rounded-xl px-4 py-3 text-sm">
                                <i data-lucide="credit-card" class="h-5 w-5"></i>
                                <span>Payments & Tax</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/certificates" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="award" class="h-5 w-5"></i>
                                <span>My Certificates</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/citizen/documents" class="sidebar-link flex items-center gap-3 rounded-xl px-4 py-3 text-sm text-slate-600">
                                <i data-lucide="folder-open" class="h-5 w-5"></i>
                                <span>My Documents</span>
                            </a>
                        </nav>
                    </div>

                    <div class="mt-auto p-6 border-t border-slate-100 pb-20 lg:pb-6">
                        <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-3 px-4 py-3 text-sm font-medium text-red-600 hover:bg-red-50 rounded-xl transition-colors">
                            <i data-lucide="log-out" class="h-5 w-5"></i>
                            <span>Logout Session</span>
                        </a>
                    </div>
                </div>
            </aside>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <!-- Header -->
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200 bg-white px-8 py-4">
                    <h1 class="text-xl font-bold text-slate-900 tracking-tight">Payments & Tax</h1>
                    <div class="flex items-center gap-4">
                         <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2 text-slate-500 hover:text-brand-900 border border-slate-100 rounded-xl transition-colors">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %><span class="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span><% } %>
                        </a>
                    </div>
                </header>

                <div class="lg:hidden px-5 pt-6 pb-2">
                    <h1 class="text-2xl font-extrabold text-slate-900 tracking-tight">Payments</h1>
                    <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest mt-1">SarkarSathi Ledger</p>
                </div>

                <main class="flex-1 px-4 py-6 sm:px-8 sm:py-8 overflow-y-auto w-full max-w-7xl mx-auto pb-32 lg:pb-8">
                    <% if(formError != null){ %>
                        <div class="mb-6 p-4 bg-red-50 border border-red-100 rounded-2xl text-red-700 text-sm font-medium">
                            <%= esc(formError) %>
                        </div>
                    <% } %>

                    <div class="grid gap-6 lg:grid-cols-2">
                        <!-- House Tax Form -->
                        <form method="post" action="<%= request.getContextPath() %>/api/payments" class="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
                            <input type="hidden" name="redirectTo" value="/citizen/payments">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">
                            <input type="hidden" name="paymentType" value="housetax">
                            <div class="flex items-center gap-4 mb-6">
                                <div class="h-12 w-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center">
                                    <i data-lucide="home" class="h-6 w-6"></i>
                                </div>
                                <h3 class="text-lg font-bold text-slate-900">House Tax</h3>
                            </div>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-1.5">Amount (NPR)</label>
                                    <input name="amount" type="number" value="5000" required class="w-full px-4 py-3.5 bg-slate-50 border-0 rounded-2xl text-slate-900 font-bold focus:ring-2 focus:ring-brand-900 outline-none">
                                </div>
                                <button type="submit" class="w-full py-4 bg-brand-900 text-white rounded-2xl text-xs font-bold uppercase tracking-widest hover:bg-brand-800 transition-colors">Pay Now</button>
                            </div>
                        </form>

                        <!-- Land Tax Form -->
                        <form method="post" action="<%= request.getContextPath() %>/api/payments" class="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
                            <input type="hidden" name="redirectTo" value="/citizen/payments">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">
                            <input type="hidden" name="paymentType" value="landtax">
                            <div class="flex items-center gap-4 mb-6">
                                <div class="h-12 w-12 bg-green-50 text-green-600 rounded-2xl flex items-center justify-center">
                                    <i data-lucide="mountain" class="h-6 w-6"></i>
                                </div>
                                <h3 class="text-lg font-bold text-slate-900">Land Tax</h3>
                            </div>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-1.5">Amount (NPR)</label>
                                    <input name="amount" type="number" value="3000" required class="w-full px-4 py-3.5 bg-slate-50 border-0 rounded-2xl text-slate-900 font-bold focus:ring-2 focus:ring-brand-900 outline-none">
                                </div>
                                <button type="submit" class="w-full py-4 bg-brand-900 text-white rounded-2xl text-xs font-bold uppercase tracking-widest hover:bg-brand-800 transition-colors">Pay Now</button>
                            </div>
                        </form>
                    </div>

                    <div class="mt-8 bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="px-6 py-5 border-b border-slate-100 flex items-center justify-between">
                            <h3 class="text-base font-bold text-slate-900">Payment Ledger</h3>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left text-sm whitespace-nowrap">
                                <thead class="bg-slate-50 text-[10px] font-bold text-slate-400 uppercase tracking-widest border-b border-slate-100">
                                    <tr>
                                        <th class="px-6 py-4">Tax Type</th>
                                        <th class="px-6 py-4">Fiscal Year</th>
                                        <th class="px-6 py-4">Amount</th>
                                        <th class="px-6 py-4">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-50">
                                    <% if(taxRecords.isEmpty()){ %>
                                        <tr><td colspan="4" class="px-6 py-12 text-center text-slate-400 italic">No records found</td></tr>
                                    <% } else { for(TaxRecord r : taxRecords){ %>
                                        <tr>
                                            <td class="px-6 py-5 font-bold text-slate-900 uppercase text-[11px] tracking-tight"><%= esc(r.getTaxType()) %></td>
                                            <td class="px-6 py-5 text-slate-600 font-medium"><%= esc(r.getFiscalYear()) %></td>
                                            <td class="px-6 py-5 font-bold text-slate-900">Rs. <%= r.getAmount() %></td>
                                            <td class="px-6 py-5">
                                                <span class="inline-flex px-2 py-1 rounded-lg text-[10px] font-bold uppercase border <%= r.isPaid() ? "bg-green-100 text-green-700 border-green-200" : "bg-red-100 text-red-700 border-red-200" %>">
                                                    <%= r.isPaid() ? "Paid" : "Unpaid" %>
                                                </span>
                                            </td>
                                        </tr>
                                    <% }} %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                if (sidebar) sidebar.classList.toggle('-translate-x-full');
            }
            lucide.createIcons();
        </script>
    </body>
</html>