<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.TaxRecord" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%!
    private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");}
    private String taxLabel(String taxType){
        if(taxType == null || taxType.isBlank()) return "Municipal Tax";
        switch(taxType.toLowerCase()){
            case "house": return "House Tax";
            case "land": return "Land Tax";
            case "business": return "Business Tax";
            case "vehicle": return "Vehicle Tax";
            case "sanitation": return "Sanitation Fee";
            case "water": return "Water Charge";
            case "rental": return "Rental Tax";
            case "advertisement": return "Advertisement Tax";
            case "solidwaste": return "Solid Waste Fee";
            case "propertytransfer": return "Property Transfer Tax";
            default: return Character.toUpperCase(taxType.charAt(0)) + taxType.substring(1) + " Tax";
        }
    }
    private String taxDotClass(String taxType){
        if(taxType == null) return "bg-slate-400";
        switch(taxType.toLowerCase()){
            case "house": return "bg-blue-600";
            case "land": return "bg-emerald-500";
            case "business": return "bg-amber-500";
            case "vehicle": return "bg-indigo-500";
            case "sanitation": return "bg-pink-500";
            case "water": return "bg-cyan-500";
            case "rental": return "bg-orange-500";
            case "advertisement": return "bg-fuchsia-500";
            case "solidwaste": return "bg-lime-600";
            case "propertytransfer": return "bg-rose-500";
            case "other": return "bg-slate-900";
            default: return "bg-slate-400";
        }
    }
    private String taxTextClass(String taxType){
        if(taxType == null) return "text-slate-400";
        switch(taxType.toLowerCase()){
            case "house": return "text-blue-600";
            case "land": return "text-emerald-500";
            case "business": return "text-amber-500";
            case "vehicle": return "text-indigo-500";
            case "sanitation": return "text-pink-500";
            case "water": return "text-cyan-500";
            case "rental": return "text-orange-500";
            case "advertisement": return "text-fuchsia-500";
            case "solidwaste": return "text-lime-600";
            case "propertytransfer": return "text-rose-500";
            case "other": return "text-slate-900";
            default: return "text-slate-400";
        }
    }
    private String statusClass(TaxRecord record){
        return record.isPaid() ? "bg-emerald-100 text-emerald-700" : "bg-amber-100 text-amber-700";
    }
    private String statusLabel(TaxRecord record){
        return record.isPaid() ? "Paid" : "Pending";
    }
    private String taxIcon(String taxType){
        if(taxType == null) return "receipt";
        switch(taxType.toLowerCase()){
            case "house": return "home";
            case "land": return "map";
            case "business": return "briefcase";
            case "vehicle": return "car-front";
            case "sanitation": return "sparkles";
            case "water": return "droplets";
            case "rental": return "key-round";
            case "advertisement": return "megaphone";
            case "solidwaste": return "trash-2";
            case "propertytransfer": return "file-text";
            default: return "badge-indian-rupee";
        }
    }
%>
<%
    Integer citizenId = (Integer)request.getAttribute("citizenId");
    String citizenName = (String)request.getAttribute("citizenName");
    Integer unread = (Integer)request.getAttribute("unreadCount");
    String formError = request.getParameter("error");
    String paymentCallbackState = (String)request.getAttribute("paymentCallbackState");
    String paymentCallbackMessage = (String)request.getAttribute("paymentCallbackMessage");
    List<TaxRecord> taxRecords = (List<TaxRecord>)request.getAttribute("taxRecords");

    if(citizenName == null) citizenName = "Citizen";
    if(unread == null) unread = 0;
    if(taxRecords == null) taxRecords = List.of();

    BigDecimal outstandingTotal = BigDecimal.ZERO;
    BigDecimal paidTotal = BigDecimal.ZERO;
    BigDecimal houseTotal = BigDecimal.ZERO;
    BigDecimal landTotal = BigDecimal.ZERO;
    BigDecimal businessTotal = BigDecimal.ZERO;
    BigDecimal vehicleTotal = BigDecimal.ZERO;
    BigDecimal sanitationTotal = BigDecimal.ZERO;
    BigDecimal waterTotal = BigDecimal.ZERO;
    BigDecimal rentalTotal = BigDecimal.ZERO;
    BigDecimal advertisementTotal = BigDecimal.ZERO;
    BigDecimal solidWasteTotal = BigDecimal.ZERO;
    BigDecimal propertyTransferTotal = BigDecimal.ZERO;
    BigDecimal otherTotal = BigDecimal.ZERO;
    int unpaidCount = 0;
    int paidCount = 0;

    for(TaxRecord r : taxRecords){
        BigDecimal amount = r.getDueAmount() == null ? BigDecimal.ZERO : r.getDueAmount();
        String taxType = r.getTaxType() == null ? "" : r.getTaxType().toLowerCase();
        if("house".equals(taxType)) houseTotal = houseTotal.add(amount);
        else if("land".equals(taxType)) landTotal = landTotal.add(amount);
        else if("business".equals(taxType)) businessTotal = businessTotal.add(amount);
        else if("vehicle".equals(taxType)) vehicleTotal = vehicleTotal.add(amount);
        else if("sanitation".equals(taxType)) sanitationTotal = sanitationTotal.add(amount);
        else if("water".equals(taxType)) waterTotal = waterTotal.add(amount);
        else if("rental".equals(taxType)) rentalTotal = rentalTotal.add(amount);
        else if("advertisement".equals(taxType)) advertisementTotal = advertisementTotal.add(amount);
        else if("solidwaste".equals(taxType)) solidWasteTotal = solidWasteTotal.add(amount);
        else if("propertytransfer".equals(taxType)) propertyTransferTotal = propertyTransferTotal.add(amount);
        else otherTotal = otherTotal.add(amount);

        if(r.isPaid()){
            paidTotal = paidTotal.add(amount);
            paidCount++;
        } else {
            outstandingTotal = outstandingTotal.add(amount);
            unpaidCount++;
        }
    }

    BigDecimal totalAssessed = outstandingTotal.add(paidTotal);
    double totalValue = totalAssessed.doubleValue();
    double housePct = totalValue == 0 ? 0 : (houseTotal.doubleValue() / totalValue) * 100d;
    double landPct = totalValue == 0 ? 0 : (landTotal.doubleValue() / totalValue) * 100d;
    double businessPct = totalValue == 0 ? 0 : (businessTotal.doubleValue() / totalValue) * 100d;
    double vehiclePct = totalValue == 0 ? 0 : (vehicleTotal.doubleValue() / totalValue) * 100d;
    double sanitationPct = totalValue == 0 ? 0 : (sanitationTotal.doubleValue() / totalValue) * 100d;
    double waterPct = totalValue == 0 ? 0 : (waterTotal.doubleValue() / totalValue) * 100d;
    double rentalPct = totalValue == 0 ? 0 : (rentalTotal.doubleValue() / totalValue) * 100d;
    double advertisementPct = totalValue == 0 ? 0 : (advertisementTotal.doubleValue() / totalValue) * 100d;
    double solidWastePct = totalValue == 0 ? 0 : (solidWasteTotal.doubleValue() / totalValue) * 100d;
    double propertyTransferPct = totalValue == 0 ? 0 : (propertyTransferTotal.doubleValue() / totalValue) * 100d;
    double otherPct = totalValue == 0 ? 0 : (otherTotal.doubleValue() / totalValue) * 100d;

    double startHouse = 0d;
    double endHouse = housePct;
    double startLand = endHouse;
    double endLand = startLand + landPct;
    double startBusiness = endLand;
    double endBusiness = startBusiness + businessPct;
    double startVehicle = endBusiness;
    double endVehicle = startVehicle + vehiclePct;
    double startSanitation = endVehicle;
    double endSanitation = startSanitation + sanitationPct;
    double startWater = endSanitation;
    double endWater = startWater + waterPct;
    double startRental = endWater;
    double endRental = startRental + rentalPct;
    double startAdvertisement = endRental;
    double endAdvertisement = startAdvertisement + advertisementPct;
    double startSolidWaste = endAdvertisement;
    double endSolidWaste = startSolidWaste + solidWastePct;
    double startPropertyTransfer = endSolidWaste;
    double endPropertyTransfer = startPropertyTransfer + propertyTransferPct;
    double startOther = endPropertyTransfer;
    double endOther = startOther + otherPct;
    String fiscalYearLabel = taxRecords.isEmpty() ? "-" : taxRecords.get(0).getFiscalYear();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Payments & Tax - SarkarSathi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config={
                theme:{
                    extend:{
                        fontFamily:{sans:['Outfit','sans-serif']},
                        colors:{
                            brand:{600:'#2563eb',700:'#1d4ed8',800:'#1e40af'},
                            ink:{900:'#081224',800:'#10203f'}
                        },
                        boxShadow:{
                            panel:'0 24px 60px rgba(15, 23, 42, 0.12)'
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #e8f0ff; color: #1d4ed8; font-weight: 600; }
            .tax-shell {
                background:
                    radial-gradient(circle at top right, rgba(59, 130, 246, 0.18), transparent 22rem),
                    linear-gradient(180deg, #eff4ff 0%, #f8fafc 28%, #f8fafc 100%);
            }
            .tax-hero {
                background:
                    radial-gradient(circle at top right, rgba(96, 165, 250, 0.25), transparent 16rem),
                    linear-gradient(135deg, #09152d 0%, #10244e 55%, #17306a 100%);
            }
            .planner-ring {
                background: conic-gradient(
                    #2563eb 0% <%= endHouse %>%,
                    #10b981 <%= startLand %>% <%= endLand %>%,
                    #f59e0b <%= startBusiness %>% <%= endBusiness %>%,
                    #6366f1 <%= startVehicle %>% <%= endVehicle %>%,
                    #ec4899 <%= startSanitation %>% <%= endSanitation %>%,
                    #06b6d4 <%= startWater %>% <%= endWater %>%,
                    #f97316 <%= startRental %>% <%= endRental %>%,
                    #d946ef <%= startAdvertisement %>% <%= endAdvertisement %>%,
                    #65a30d <%= startSolidWaste %>% <%= endSolidWaste %>%,
                    #f43f5e <%= startPropertyTransfer %>% <%= endPropertyTransfer %>%,
                    #0f172a <%= startOther %>% <%= endOther %>%,
                    #e2e8f0 <%= endOther %>% 100%
                );
            }
            .planner-ring::after {
                content: "";
                position: absolute;
                inset: 1rem;
                border-radius: 9999px;
                background: white;
                box-shadow: inset 0 0 0 1px rgba(226,232,240,.9);
            }
            @media (max-width: 1023px) { .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); } }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/ui-improvements.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/typography.css">
    </head>
    <body class="tax-shell text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <%@ include file="../includes/mobile-nav-citizen.jsp" %>

            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            <%@ include file="../includes/sidebar-citizen.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200/80 bg-white/90 px-8 py-4 backdrop-blur">
                    <div class="flex items-center gap-4">
                        
                        <div>
                            <h1 class="text-xl font-extrabold text-slate-900 tracking-tight">Tax and Payments</h1>
                            <p class="text-sm text-slate-500">Municipal tax summary and payment desk</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-4">
                        
                        <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2.5 text-slate-400 hover:text-brand-800 border border-slate-200 rounded-xl transition-colors hover:bg-slate-50">
                            <i data-lucide="bell" class="h-[18px] w-[18px]"></i>
                            <% if(unread>0){ %><span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span><% } %>
                        </a>
                        <div class="h-9 w-9 rounded-xl bg-brand-900 text-white flex items-center justify-center text-xs font-bold"><%= citizenName.substring(0,1).toUpperCase() %></div>
                    </div>
                </header>

                <div class="lg:hidden px-5 pt-6 pb-4">
                    <p class="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-400">Tax and Payment</p>
                    <h1 class="mt-1 text-2xl font-black text-slate-900 tracking-tight">Payments & Taxes</h1>
                    <p class="mt-1 text-sm text-slate-500">Municipal summary and payment desk</p>
                </div>

                <main class="flex-1 px-4 py-4 sm:px-6 lg:px-8 overflow-y-auto w-full pb-24 lg:pb-8">
                    <% if(formError != null){ %>
                        <div class="mb-5 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-medium text-rose-700">
                            <%= esc(formError) %>
                        </div>
                    <% } %>

                    <% if(paymentCallbackMessage != null && !paymentCallbackMessage.isBlank()){ %>
                        <div class="mb-5 rounded-2xl border px-4 py-3 text-sm font-semibold <%= "success".equals(paymentCallbackState) ? "border-emerald-200 bg-emerald-50 text-emerald-700" : "border-rose-200 bg-rose-50 text-rose-700" %>">
                            <%= esc(paymentCallbackMessage) %>
                        </div>
                    <% } %>

                    <section class="tax-hero rounded-[1.75rem] px-5 py-5 text-white shadow-panel sm:px-7 sm:py-6">
                        <div class="flex items-center justify-between gap-3">
                            <p class="text-[11px] font-black uppercase tracking-[0.28em] text-white/60">Fiscal Year</p>
                            <span class="inline-flex items-center rounded-2xl border border-white/15 bg-white/8 px-3.5 py-2.5 text-sm font-bold text-white">
                                <%= esc(fiscalYearLabel) %>
                            </span>
                        </div>
                    </section>

                    <section class="mt-6">
                        <div class="rounded-[1.75rem] border border-slate-200/80 bg-white p-5 shadow-panel sm:p-6">
                            <div class="flex items-center justify-between gap-3">
                                <div>
                                    <h3 class="text-xl font-black text-slate-900">Tax Breakdown</h3>
                                    <p class="mt-1 text-sm font-medium text-slate-500">Distribution of all recorded tax categories</p>
                                </div>
                                <span class="rounded-2xl bg-slate-100 px-3 py-1.5 text-[11px] font-black uppercase tracking-[0.18em] text-slate-500">This Financial Year</span>
                            </div>

                            <div class="mt-6 grid gap-6 lg:grid-cols-[14rem_1fr] lg:items-center">
                                <div class="mx-auto flex flex-col items-center">
                                    <div class="planner-ring relative h-52 w-52 rounded-full sm:h-56 sm:w-56">
                                        <div class="absolute inset-0 z-10 flex flex-col items-center justify-center text-center">
                                            <p class="text-2xl font-black tracking-tight text-slate-900 sm:text-3xl">Rs. <%= totalAssessed %></p>
                                            <p class="mt-2 text-xs font-black uppercase tracking-[0.22em] text-slate-400">Total Assessed</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="grid gap-4 sm:grid-cols-2">
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("house") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">House Tax</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= houseTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("land") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Land Tax</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= landTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("business") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Business Tax</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= businessTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("vehicle") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Vehicle Tax</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= vehicleTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4 sm:col-span-2">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("sanitation") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Sanitation Fee</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= sanitationTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("water") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Water Charge</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= waterTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("rental") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Rental Tax</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= rentalTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("advertisement") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Advertisement Tax</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= advertisementTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("solidwaste") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Solid Waste Fee</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= solidWasteTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4 sm:col-span-2">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("propertytransfer") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Property Transfer Tax</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= propertyTransferTotal %></p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4 sm:col-span-2">
                                        <div class="flex items-center gap-3">
                                            <span class="h-3 w-3 rounded-full <%= taxDotClass("other") %>"></span>
                                            <p class="text-sm font-semibold text-slate-500">Other Taxes</p>
                                        </div>
                                        <p class="mt-2 text-2xl font-black text-slate-900">Rs. <%= otherTotal %></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="tax-records" class="mt-6 rounded-[1.75rem] border border-slate-200/80 bg-white shadow-panel overflow-hidden">
                        <div class="flex flex-col gap-3 border-b border-slate-100 px-6 py-5 sm:flex-row sm:items-center sm:justify-between">
                            <div>
                                <h3 class="text-xl font-black text-slate-900">Detailed Entries</h3>
                                <p class="mt-1 text-sm font-medium text-slate-500">Tax categories, current amounts, and payment status</p>
                            </div>
                            <span class="text-sm font-bold text-brand-700"><%= taxRecords.size() %> record(s)</span>
                        </div>

                        <% if(taxRecords.isEmpty()){ %>
                            <div class="px-6 py-16 text-center">
                                <i data-lucide="wallet-cards" class="mx-auto h-10 w-10 text-slate-200"></i>
                                <p class="mt-4 text-base font-bold text-slate-900">No tax records found</p>
                                <p class="mt-1 text-sm font-medium text-slate-500">When tax records are generated for your account, they will appear here.</p>
                            </div>
                        <% } else { %>
                            <div class="hidden md:block overflow-x-auto">
                                <table class="w-full min-w-[760px] text-left">
                                    <thead class="bg-slate-50 text-[11px] font-black uppercase tracking-[0.18em] text-slate-400">
                                        <tr>
                                            <th class="px-6 py-4">Category</th>
                                            <th class="px-6 py-4">Amount</th>
                                            <th class="px-6 py-4">Status</th>
                                            <th class="px-6 py-4">Reference</th>
                                            <th class="px-6 py-4 text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-100">
                                        <% for(TaxRecord r : taxRecords){ %>
                                            <tr class="hover:bg-slate-50/70">
                                                <td class="px-6 py-5">
                                                    <div class="flex items-center gap-4">
                                                        <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-100 <%= taxTextClass(r.getTaxType()) %>">
                                                            <i data-lucide="<%= taxIcon(r.getTaxType()) %>" class="h-5 w-5"></i>
                                                        </div>
                                                        <div>
                                                            <p class="text-base font-black text-slate-900"><%= esc(taxLabel(r.getTaxType())) %></p>
                                                            <p class="mt-1 text-sm font-medium text-slate-500">Fiscal Year <%= esc(r.getFiscalYear()) %></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-5 text-lg font-black text-slate-900">Rs. <%= r.getDueAmount() %></td>
                                                <td class="px-6 py-5">
                                                    <span class="inline-flex rounded-full px-3 py-1 text-xs font-black uppercase tracking-[0.16em] <%= statusClass(r) %>"><%= statusLabel(r) %></span>
                                                </td>
                                                <td class="px-6 py-5 text-sm font-bold text-slate-500">TAX-<%= r.getTaxId() %></td>
                                                <td class="px-6 py-5 text-right">
                                                    <% if(r.isPaid()){ %>
                                                        <span class="inline-flex rounded-2xl bg-slate-100 px-4 py-2 text-sm font-bold text-slate-500">Receipt Recorded</span>
                                                    <% } else { %>
                                                        <button type="button" onclick="submitEsewa('<%= esc(r.getTaxType()) %>', '<%= r.getTaxId() %>', '<%= r.getDueAmount() %>')" class="inline-flex items-center rounded-2xl bg-brand-700 px-4 py-2 text-sm font-black text-white shadow-lg shadow-brand-700/20 hover:bg-brand-800 transition-colors">
                                                            Pay with eSewa
                                                        </button>
                                                    <% } %>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                            <div class="divide-y divide-slate-100 md:hidden">
                                <% for(TaxRecord r : taxRecords){ %>
                                    <div class="px-5 py-5">
                                        <div class="flex items-start gap-4">
                                            <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-slate-100 <%= taxTextClass(r.getTaxType()) %>">
                                                <i data-lucide="<%= taxIcon(r.getTaxType()) %>" class="h-5 w-5"></i>
                                            </div>
                                            <div class="min-w-0 flex-1">
                                                <div class="flex items-start justify-between gap-3">
                                                    <div>
                                                        <p class="text-base font-black text-slate-900"><%= esc(taxLabel(r.getTaxType())) %></p>
                                                        <p class="mt-1 text-sm text-slate-500">Fiscal Year <%= esc(r.getFiscalYear()) %></p>
                                                    </div>
                                                    <span class="inline-flex rounded-full px-3 py-1 text-[11px] font-black uppercase tracking-[0.16em] <%= statusClass(r) %>"><%= statusLabel(r) %></span>
                                                </div>
                                                <div class="mt-4 flex items-center justify-between gap-3">
                                                    <div>
                                                        <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Amount</p>
                                                        <p class="mt-1 text-lg font-black text-slate-900">Rs. <%= r.getDueAmount() %></p>
                                                    </div>
                                                    <% if(r.isPaid()){ %>
                                                        <span class="inline-flex rounded-2xl bg-slate-100 px-4 py-2 text-sm font-bold text-slate-500">Recorded</span>
                                                    <% } else { %>
                                                        <button type="button" onclick="submitEsewa('<%= esc(r.getTaxType()) %>', '<%= r.getTaxId() %>', '<%= r.getDueAmount() %>')" class="inline-flex items-center rounded-2xl bg-brand-700 px-4 py-2 text-sm font-black text-white">
                                                            Pay Now
                                                        </button>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </section>

                  

                    <form method="POST" action="https://rc-epay.esewa.com.np/api/epay/main/v2/form" id="taxEsewaForm" class="hidden" aria-hidden="true">
                        <input type="hidden" name="amount" id="taxEsewaAmount" value="">
                        <input type="hidden" name="tax_amount" value="0">
                        <input type="hidden" name="total_amount" id="taxEsewaTotalAmount" value="">
                        <input type="hidden" name="transaction_uuid" id="taxEsewaUuid" value="">
                        <input type="hidden" name="product_code" value="EPAYTEST">
                        <input type="hidden" name="product_service_charge" value="0">
                        <input type="hidden" name="product_delivery_charge" value="0">
                        <input type="hidden" name="success_url" value="<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/citizen/payments">
                        <input type="hidden" name="failure_url" value="<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/citizen/payments?error=eSewa+payment+was+cancelled+or+failed">
                        <input type="hidden" name="signed_field_names" value="total_amount,transaction_uuid,product_code">
                        <input type="hidden" name="signature" id="taxEsewaSignature" value="">
                    </form>
                </main>
            </div>
        </div>
        <script>
            const ESEWA_SECRET = '8gBm/:&EnhH.1/q';

            async function generateEsewaSignature(message) {
                const encoder = new TextEncoder();
                const keyData = encoder.encode(ESEWA_SECRET);
                const msgData = encoder.encode(message);
                const cryptoKey = await crypto.subtle.importKey('raw', keyData, { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
                const sig = await crypto.subtle.sign('HMAC', cryptoKey, msgData);
                return btoa(String.fromCharCode(...new Uint8Array(sig)));
            }

            async function submitEsewa(type, taxId, amount) {
                const totalAmount = Number.parseFloat(amount).toFixed(2);
                const uuid = 'SARKAR-' + String(type).toUpperCase() + '-TAX-' + taxId + '-' + Date.now();
                const message = 'total_amount=' + totalAmount + ',transaction_uuid=' + uuid + ',product_code=EPAYTEST';
                const signature = await generateEsewaSignature(message);

                document.getElementById('taxEsewaAmount').value = totalAmount;
                document.getElementById('taxEsewaTotalAmount').value = totalAmount;
                document.getElementById('taxEsewaUuid').value = uuid;
                document.getElementById('taxEsewaSignature').value = signature;
                document.getElementById('taxEsewaForm').submit();
            }

            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                if (sidebar) sidebar.classList.toggle('-translate-x-full');
            }
            lucide.createIcons();
        </script>
    </body>
</html>
