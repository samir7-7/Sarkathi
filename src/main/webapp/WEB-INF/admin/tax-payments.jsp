<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Citizen" %>
<%@ page import="Model.Payment" %>
<%@ page import="Model.TaxRecord" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%!
    private String esc(Object v){if(v==null)return "";return v.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");}
    private String taxLabel(String s){
        if(s == null || s.isBlank()) return "Municipal Tax";
        return switch (s.toLowerCase()) {
            case "house" -> "House Tax";
            case "land" -> "Land Tax";
            case "business" -> "Business Tax";
            case "vehicle" -> "Vehicle Tax";
            case "sanitation" -> "Sanitation Tax";
            case "water" -> "Water Tax";
            case "rental" -> "Rental Tax";
            case "advertisement" -> "Advertisement Tax";
            case "solidwaste" -> "Solid Waste Tax";
            case "propertytransfer" -> "Property Transfer Tax";
            default -> Character.toUpperCase(s.charAt(0)) + s.substring(1) + " Tax";
        };
    }
%>
<%
    String adminName = (String)request.getAttribute("adminName");
    String adminRole = (String)request.getAttribute("adminRole");
    String pageError = (String)request.getAttribute("pageError");
    Number paidTaxCount = (Number)request.getAttribute("paidTaxCount");
    List<TaxRecord> recentPaidTaxes = (List<TaxRecord>)request.getAttribute("recentPaidTaxes");
    Map<Integer, Citizen> paidTaxCitizensById = (Map<Integer, Citizen>)request.getAttribute("paidTaxCitizensById");
    Map<Integer, Payment> paidTaxPaymentsById = (Map<Integer, Payment>)request.getAttribute("paidTaxPaymentsById");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy");

    if(adminName == null) adminName = "Admin";
    if(adminRole == null) adminRole = "System Controller";
    if(paidTaxCount == null) paidTaxCount = 0;
    if(recentPaidTaxes == null) recentPaidTaxes = List.of();
    if(paidTaxCitizensById == null) paidTaxCitizensById = Map.of();
    if(paidTaxPaymentsById == null) paidTaxPaymentsById = Map.of();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Tax Payments - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ["Outfit", "sans-serif"] },
                    colors: {
                        brand: { 50:"#eff6ff", 100:"#dbeafe", 500:"#3b82f6", 700:"#1d4ed8", 800:"#154a91", 900:"#0b3d86" }
                    }
                }
            }
        };
    </script>
    <%@ include file="../includes/lucide-icons.jsp" %>
    <style>
        body { font-family: "Outfit", sans-serif; }
        .data-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .data-table thead th { padding: 10px 16px; font-size: 12px; font-weight: 600; color: #64748b; text-align: left; border-bottom: 1px solid #e2e8f0; background: #fafbfc; }
        .data-table thead th:first-child { border-radius: 8px 0 0 0; }
        .data-table thead th:last-child { border-radius: 0 8px 0 0; }
        .data-table tbody td { padding: 12px 16px; font-size: 13px; color: #334155; border-bottom: 1px solid #f1f5f9; }
        .data-table tbody tr:hover { background: #f8fafc; }
        .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
        .mobile-record-card { border: 1px solid #e2e8f0; border-radius: 1rem; background: #fff; padding: 1rem; }
    </style>
</head>
<body class="bg-slate-100 text-slate-900 antialiased overflow-x-hidden">
    <div class="flex min-h-screen relative">
        <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden"></div>
        <%@ include file="../includes/sidebar-admin.jsp" %>

        <div class="flex-1 flex flex-col min-h-screen w-full">
            <header class="sticky top-0 z-40 bg-white/90 backdrop-blur border-b border-slate-200 px-4 py-3.5 lg:px-7">
                <div class="flex items-start justify-between gap-3 sm:items-center">
                    <div class="flex items-start gap-3">
                        <button onclick="toggleSidebar()" class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 shadow-sm transition hover:bg-slate-50 lg:hidden">
                            <i data-lucide="menu" class="h-5 w-5"></i>
                        </button>
                        <div>
                        <h1 class="text-lg font-black tracking-tight text-slate-900">Tax Payment Records</h1>
                        <p class="text-[11px] font-semibold text-slate-500">Review municipal tax payments completed by citizens</p>
                        </div>
                    </div>
                    <div class="hidden sm:flex items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2">
                        <div class="h-9 w-9 rounded-full bg-brand-900 flex items-center justify-center text-white text-sm font-bold">
                            <%= adminName.length() > 0 ? adminName.substring(0,1).toUpperCase() : "A" %>
                        </div>
                        <div>
                            <p class="text-sm font-bold text-slate-900"><%= esc(adminName) %></p>
                            <p class="text-[11px] font-semibold text-slate-500"><%= esc(adminRole) %></p>
                        </div>
                    </div>
                </div>
            </header>

            <main class="flex-1 p-3 sm:p-4 lg:p-6">
                <% if(pageError != null){ %>
                <div class="bg-rose-50 text-rose-700 px-4 py-3 rounded-xl border border-rose-200 flex items-center gap-2 mb-4 text-sm font-medium">
                    <i data-lucide="alert-circle" class="h-4 w-4 flex-shrink-0"></i>
                    <%= esc(pageError) %>
                </div>
                <% } %>

                <section class="mb-6 grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 p-5 shadow-sm">
                        <div class="flex items-center gap-3">
                            <div class="h-10 w-10 rounded-xl bg-white text-emerald-700 flex items-center justify-center shadow-sm">
                                <i data-lucide="receipt" class="h-5 w-5"></i>
                            </div>
                            <div>
                                <p class="text-2xl font-black text-emerald-800"><%= paidTaxCount.intValue() %></p>
                                <p class="text-xs font-semibold uppercase tracking-wider text-emerald-700/80">Paid Tax Records</p>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden">
                    <div class="px-5 py-4 border-b border-slate-100">
                        <h2 class="text-[15px] font-bold text-slate-900">Tax Payment Ledger</h2>
                        <p class="text-xs text-slate-400 mt-0.5">Latest 100 completed tax payments</p>
                    </div>
                    <div class="space-y-3 p-3 sm:hidden">
                        <% if(recentPaidTaxes.isEmpty()){ %>
                        <div class="mobile-record-card text-center text-sm font-semibold text-slate-500">No tax payment records found</div>
                        <% } else { for(TaxRecord taxRecord : recentPaidTaxes){
                            Citizen citizen = paidTaxCitizensById.get(taxRecord.getCitizenId());
                            Payment payment = paidTaxPaymentsById.get(taxRecord.getPaymentId());
                        %>
                        <article class="mobile-record-card">
                            <div class="flex items-start justify-between gap-3">
                                <div>
                                    <p class="text-sm font-black text-slate-900"><%= esc(citizen == null ? "Citizen #" + taxRecord.getCitizenId() : citizen.getFullName()) %></p>
                                    <p class="mt-1 text-xs text-slate-500"><%= esc(citizen == null ? "" : citizen.getEmail()) %></p>
                                </div>
                                <span class="text-emerald-700 font-black text-sm">Rs. <%= esc(taxRecord.getDueAmount()) %></span>
                            </div>
                            <div class="mt-3 grid gap-2 text-sm">
                                <div class="flex items-center justify-between gap-3"><span class="text-slate-400 font-semibold">Tax Type</span><span class="text-slate-700 font-medium"><%= esc(taxLabel(taxRecord.getTaxType())) %></span></div>
                                <div class="flex items-center justify-between gap-3"><span class="text-slate-400 font-semibold">Fiscal Year</span><span class="text-slate-700 font-medium"><%= esc(taxRecord.getFiscalYear()) %></span></div>
                                <div class="flex items-center justify-between gap-3"><span class="text-slate-400 font-semibold">Payment ID</span><span class="text-slate-700 font-medium">#<%= taxRecord.getPaymentId() %></span></div>
                                <div class="flex items-center justify-between gap-3"><span class="text-slate-400 font-semibold">Date</span><span class="text-slate-500 text-xs"><%= payment == null || payment.getPaidAt() == null ? "N/A" : esc(payment.getPaidAt().format(fmt)) %></span></div>
                            </div>
                        </article>
                        <% }} %>
                    </div>
                    <div class="hidden sm:block overflow-x-auto">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Citizen</th>
                                    <th>Tax Type</th>
                                    <th>Fiscal Year</th>
                                    <th>Amount</th>
                                    <th>Payment ID</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(recentPaidTaxes.isEmpty()){ %>
                                <tr>
                                    <td colspan="6" class="!py-16 text-center">
                                        <div class="flex flex-col items-center">
                                            <div class="h-12 w-12 rounded-xl bg-slate-100 flex items-center justify-center mb-3">
                                                <i data-lucide="receipt" class="h-6 w-6 text-slate-300"></i>
                                            </div>
                                            <p class="text-sm font-medium text-slate-400">No tax payment records found</p>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { for(TaxRecord taxRecord : recentPaidTaxes){
                                    Citizen citizen = paidTaxCitizensById.get(taxRecord.getCitizenId());
                                    Payment payment = paidTaxPaymentsById.get(taxRecord.getPaymentId());
                                %>
                                <tr>
                                    <td>
                                        <div class="flex flex-col">
                                            <span class="font-semibold text-slate-900"><%= esc(citizen == null ? "Citizen #" + taxRecord.getCitizenId() : citizen.getFullName()) %></span>
                                            <span class="text-xs text-slate-500"><%= esc(citizen == null ? "" : citizen.getEmail()) %></span>
                                        </div>
                                    </td>
                                    <td><span class="font-medium text-slate-700"><%= esc(taxLabel(taxRecord.getTaxType())) %></span></td>
                                    <td><span class="text-slate-500"><%= esc(taxRecord.getFiscalYear()) %></span></td>
                                    <td><span class="font-semibold text-emerald-700">Rs. <%= esc(taxRecord.getDueAmount()) %></span></td>
                                    <td><span class="text-slate-500">#<%= taxRecord.getPaymentId() %></span></td>
                                    <td><span class="text-slate-500 tabular-nums text-xs"><%= payment == null || payment.getPaidAt() == null ? "N/A" : esc(payment.getPaidAt().format(fmt)) %></span></td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </section>
            </main>
        </div>
    </div>

    <%@ include file="../includes/responsive-scripts.jsp" %>
    <script>lucide.createIcons();</script>
</body>
</html>
