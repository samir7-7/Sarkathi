<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.CitizenDocumentVault" %>
<%@ page import="Model.ServiceType" %>
<%@ page import="Model.Ward" %>
<%@ page import="java.util.List" %>
<%!
    private String esc(Object value){if(value==null)return "";return value.toString().replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");}
%>
<%
    Integer citizenId = (Integer)request.getAttribute("citizenId");
    String citizenName = (String)request.getAttribute("citizenName");
    String pageError = (String)request.getAttribute("pageError");
    String formError = request.getParameter("error");
    String paymentCallbackState = (String)request.getAttribute("paymentCallbackState");
    String paymentCallbackMessage = (String)request.getAttribute("paymentCallbackMessage");
    Integer unread = (Integer)request.getAttribute("unreadCount");
    List<ServiceType> serviceTypes = (List<ServiceType>)request.getAttribute("serviceTypes");
    List<Ward> wards = (List<Ward>)request.getAttribute("wards");
    List<CitizenDocumentVault> documents = (List<CitizenDocumentVault>)request.getAttribute("documents");

    if(citizenName == null) citizenName = "Citizen";
    if(unread == null) unread = 0;
    if(serviceTypes == null) serviceTypes = List.of();
    if(wards == null) wards = List.of();
    if(documents == null) documents = List.of();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Apply for Service - SarkarSathi</title>
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
                            brand:{50:'#f0f5fc',100:'#e1eafa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 700; }
            @media (max-width: 1023px) { .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); } }
            .form-input {
                width: 100%;
                background: #f8fafc;
                border: 1.5px solid #cbd5e1;
                border-radius: 1rem;
                padding: 1rem 1.15rem;
                font-size: 0.875rem;
                font-weight: 600;
                color: #334155;
                outline: none;
                transition: all 0.2s ease;
            }
            .form-input::placeholder { color: #94a3b8; font-weight: 500; }
            .form-input:focus {
                border-color: #3b82f6;
                background: #fff;
                box-shadow: 0 0 0 3px rgba(59,130,246,0.10);
            }
            .form-textarea { resize: none; line-height: 1.6; min-height: 120px; }
            .dynamic-fields-panel { display: none; animation: fadeSlideIn 0.3s ease; }
            .dynamic-fields-panel.active { display: block; }
            .form-step { display: none; }
            .form-step.active { display: block; animation: fadeSlideIn 0.35s ease; }
            .step-pill { border: 1px solid #cbd5e1; background: #fff; color: #64748b; transition: all 0.2s ease; }
            .step-pill.active { border-color: #0b3d86; background: #eff6ff; color: #0b3d86; }
            .step-pill.complete { border-color: #bfdbfe; background: #f8fbff; color: #154a91; }
            .service-badge {
                display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.45rem 0.9rem;
                border-radius: 999px; font-size: 10px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.08em;
            }
            @keyframes fadeSlideIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/ui-improvements.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style/typography.css">
    </head>
    <body class="bg-[#fafafc] text-slate-800 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <%@ include file="../includes/mobile-nav-citizen.jsp" %>

            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            <%@ include file="../includes/sidebar-citizen.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">
                <header class="hidden lg:flex sticky top-0 z-40 items-center justify-between border-b border-slate-200/80 bg-white px-8 py-4">
                    <div>
                        <h1 class="text-xl font-extrabold text-slate-900 tracking-tight">Apply for Service</h1>
                        <p class="text-xs text-slate-400 font-medium mt-0.5">Submit a new municipal request through a guided form</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <a href="<%= request.getContextPath() %>/citizen/tracking" class="inline-flex items-center gap-2 rounded-xl border border-slate-200 px-3.5 py-2.5 text-[11px] font-black uppercase tracking-wider text-slate-700 hover:bg-slate-50 transition-colors">
                            <i data-lucide="search-check" class="h-4 w-4"></i>Track Status
                        </a>
                        <a href="<%= request.getContextPath() %>/citizen/notifications" class="relative p-2 text-slate-500 hover:text-brand-900 transition-colors border border-slate-200 rounded-xl">
                            <i data-lucide="bell" class="h-5 w-5"></i>
                            <% if(unread>0){ %><span class="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span><% } %>
                        </a>
                        <div class="h-9 w-9 rounded-xl bg-brand-900 text-white flex items-center justify-center text-xs font-bold"><%= citizenName.substring(0,1).toUpperCase() %></div>
                    </div>
                </header>

                <div class="lg:hidden flex items-center justify-between px-5 pt-6 pb-4">
                    <div class="flex flex-col">
                        <h1 class="text-2xl font-black text-slate-900 tracking-tight">Apply</h1>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-[0.2em]">Citizen Workflow</p>
                    </div>
                </div>

                <main class="flex-1 px-4 py-4 sm:px-6 lg:px-8 overflow-y-auto w-full pb-24 lg:pb-8">

                    <% if(pageError!=null || formError!=null){ %>
                        <div class="mb-5 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-semibold text-rose-700">
                            <%= esc(pageError!=null?pageError:formError) %>
                        </div>
                    <% } %>
                    <% if(paymentCallbackMessage != null && !paymentCallbackMessage.isBlank()){ %>
                        <div class="mb-5 rounded-xl border px-4 py-3 text-sm font-semibold <%= "success".equals(paymentCallbackState) ? "border-emerald-200 bg-emerald-50 text-emerald-700" : "border-rose-200 bg-rose-50 text-rose-700" %>">
                            <%= esc(paymentCallbackMessage) %>
                        </div>
                    <% } %>

                    <div id="clientErrorBanner" class="mb-5 hidden rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-semibold text-rose-700"></div>

                    <form method="post" action="<%= request.getContextPath() %>/api/applications" class="space-y-4">
                        <input type="hidden" name="redirectTo" value="/citizen/tracking">
                        <input type="hidden" name="citizenId" value="<%= citizenId %>">
                        <input type="hidden" name="formData" id="formDataHidden" value="{}">

                        <div class="bg-white rounded-2xl border border-slate-200/80 shadow-sm p-4">
                            <div class="grid grid-cols-4 gap-2">
                                <button type="button" data-step-target="1" class="step-pill active rounded-xl px-3 py-3 text-center">
                                    <p class="text-[10px] font-bold uppercase tracking-wider">Step 1</p><p class="mt-1 text-sm font-bold">Service</p>
                                </button>
                                <button type="button" data-step-target="2" class="step-pill rounded-xl px-3 py-3 text-center">
                                    <p class="text-[10px] font-bold uppercase tracking-wider">Step 2</p><p class="mt-1 text-sm font-bold">Details</p>
                                </button>
                                <button type="button" data-step-target="3" class="step-pill rounded-xl px-3 py-3 text-center">
                                    <p class="text-[10px] font-bold uppercase tracking-wider">Step 3</p><p class="mt-1 text-sm font-bold">Documents</p>
                                </button>
                                <button type="button" data-step-target="4" class="step-pill rounded-xl px-3 py-3 text-center">
                                    <p class="text-[10px] font-bold uppercase tracking-wider">Step 4</p><p class="mt-1 text-sm font-bold">Review</p>
                                </button>
                            </div>
                        </div>

                        <section id="step1" class="form-step active bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5">
                            <h3 class="text-base font-bold text-slate-900 mb-1">Choose Your Service</h3>
                            <p class="text-xs text-slate-400 font-medium mb-5">Select the service type and ward.</p>
                            <div class="grid gap-5 lg:grid-cols-2">
                                <div class="space-y-3">
                                    <label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Service Type</label>
                                    <select name="serviceTypeId" id="serviceTypeSelect" required class="form-input">
                                        <option value="" disabled selected>Select a service</option>
                                        <% for(ServiceType s: serviceTypes){ %>
                                            <option value="<%= s.getServiceTypeId() %>" data-name="<%= esc(s.getServiceName()) %>" data-fee="<%= esc(s.getBaseFee()) %>"><%= esc(s.getServiceName()) %> - Rs. <%= esc(s.getBaseFee()) %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="space-y-3">
                                    <label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Jurisdiction</label>
                                    <select name="wardId" id="wardSelect" required class="form-input">
                                        <% for(Ward w: wards){ %>
                                            <option value="<%= w.getWardId() %>">Ward <%= w.getWardNumber() %> - <%= esc(w.getMunicipalityName()) %></option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>
                            <div id="servicePrompt" class="mt-5 rounded-xl border border-dashed border-slate-200 bg-slate-50 px-6 py-8 text-center">
                                <i data-lucide="file-search" class="h-8 w-8 text-slate-200 mx-auto mb-3"></i>
                                <p class="text-xs font-bold text-slate-400">Select a service to continue</p>
                            </div>
                            <div class="mt-5 flex justify-end">
                                <button type="button" data-next-step="2" class="rounded-xl bg-brand-900 px-6 py-2.5 text-xs font-bold uppercase tracking-widest text-white hover:bg-brand-800 transition-colors">Next</button>
                            </div>
                        </section>

                        <section id="step2" class="form-step bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5">
                            <h3 class="text-base font-bold text-slate-900 mb-1">Service Details</h3>
                            <p class="text-xs text-slate-400 font-medium mb-5">Fill in the required fields.</p>

                            <div id="fields_birth" class="dynamic-fields-panel space-y-6">
                                <div class="flex items-center gap-3"><span class="service-badge bg-emerald-100 text-emerald-700"><i data-lucide="baby" class="h-3.5 w-3.5"></i>Birth Certificate</span></div>
                                <div class="grid gap-5 lg:grid-cols-2">
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Child's Full Name</label><input type="text" data-fd="childFullName" required placeholder="Full name of the child" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Date of Birth</label><input type="date" data-fd="dateOfBirth" required class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Time of Birth</label><input type="time" data-fd="timeOfBirth" placeholder="Time of birth" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Place of Birth</label><input type="text" data-fd="placeOfBirth" required placeholder="Hospital or home, city, district" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Gender of Child</label><select data-fd="genderOfChild" required class="form-input"><option value="" disabled selected>Select gender</option><option value="Male">Male</option><option value="Female">Female</option><option value="Other">Other</option></select></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Father's Full Name</label><input type="text" data-fd="fatherFullName" required placeholder="Father's full name" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Mother's Full Name</label><input type="text" data-fd="motherFullName" required placeholder="Mother's full name" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Parents' Nationality</label><input type="text" data-fd="parentsNationality" required placeholder="Nationality of both parents" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Parents' Occupation</label><input type="text" data-fd="parentsOccupation" placeholder="Occupation of parents" class="form-input"></div>
                                    <div class="space-y-3 lg:col-span-2"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Permanent Address of Parents</label><input type="text" data-fd="parentsPermanentAddress" required placeholder="Ward, city, district" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Informant's Name</label><input type="text" data-fd="informantName" required placeholder="Person reporting the birth" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Registration Number</label><input type="text" data-fd="registrationNumber" placeholder="Birth registration number" class="form-input"></div>
                                </div>
                            </div>

                            <div id="fields_marriage" class="dynamic-fields-panel space-y-6">
                                <div class="flex items-center gap-3"><span class="service-badge bg-pink-100 text-pink-700"><i data-lucide="heart" class="h-3.5 w-3.5"></i>Marriage Certificate</span></div>
                                <div class="grid gap-5 lg:grid-cols-2">
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Full Name of Husband</label><input type="text" data-fd="husbandFullName" required placeholder="Full legal name of husband" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Full Name of Wife</label><input type="text" data-fd="wifeFullName" required placeholder="Full legal name of wife" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Date of Birth of Husband</label><input type="date" data-fd="husbandDateOfBirth" required class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Date of Birth of Wife</label><input type="date" data-fd="wifeDateOfBirth" required class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Nationality of Husband</label><input type="text" data-fd="husbandNationality" required placeholder="Husband's nationality" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Nationality of Wife</label><input type="text" data-fd="wifeNationality" required placeholder="Wife's nationality" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Religion</label><input type="text" data-fd="religion" placeholder="Religion, if required" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Date of Marriage</label><input type="date" data-fd="dateOfMarriage" required class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Occupation of Husband</label><input type="text" data-fd="husbandOccupation" placeholder="Husband's occupation" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Occupation of Wife</label><input type="text" data-fd="wifeOccupation" placeholder="Wife's occupation" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Permanent Address of Husband</label><input type="text" data-fd="husbandPermanentAddress" required placeholder="Ward, city, district" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Permanent Address of Wife</label><input type="text" data-fd="wifePermanentAddress" required placeholder="Ward, city, district" class="form-input"></div>
                                    <div class="space-y-3 lg:col-span-2"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Place of Marriage</label><input type="text" data-fd="placeOfMarriage" required placeholder="Venue, city, district" class="form-input"></div>
                                    <div class="space-y-3 lg:col-span-2"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Witness Names and Signatures</label><textarea data-fd="witnessNamesAndSignatures" required rows="3" placeholder="List witness names and signature details" class="form-input form-textarea"></textarea></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Marriage Registration Number</label><input type="text" data-fd="marriageRegistrationNumber" placeholder="Registration number" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Photographs of Couple</label><input type="text" data-fd="couplePhotographReference" placeholder="Reference selected from vault" class="form-input"></div>
                                </div>
                            </div>

                            <div id="fields_residence" class="dynamic-fields-panel space-y-6">
                                <div class="flex items-center gap-3"><span class="service-badge bg-sky-100 text-sky-700"><i data-lucide="home" class="h-3.5 w-3.5"></i>Residence Certificate</span></div>
                                <div class="grid gap-5 lg:grid-cols-2">
                                    <div class="space-y-3 lg:col-span-2"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Applicant's Full Name</label><input type="text" data-fd="applicantFullName" required placeholder="Your full legal name" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Father's/Mother's Name</label><input type="text" data-fd="parentName" required placeholder="Parent or guardian name" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Date of Birth</label><input type="date" data-fd="dateOfBirth" required class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Permanent Address</label><input type="text" data-fd="permanentAddress" required placeholder="Permanent address" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Current Address</label><input type="text" data-fd="currentAddress" required placeholder="Current place of stay" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Duration of Stay at Current Address</label><input type="text" data-fd="durationOfStayAtCurrentAddress" required placeholder="e.g. 5 years" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Purpose of Certificate</label><input type="text" data-fd="purposeOfCertificate" required placeholder="School admission, job application, etc." class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Identification Number</label><input type="text" data-fd="identificationNumber" placeholder="National ID or other reference" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Photograph</label><input type="text" data-fd="photographReference" placeholder="Reference selected from vault" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Signature / Thumbprint</label><input type="text" data-fd="signatureOrThumbprintReference" placeholder="Reference selected from vault" class="form-input"></div>
                                </div>
                            </div>

                            <div id="fields_citizenship" class="dynamic-fields-panel space-y-6">
                                <div class="flex items-center gap-3"><span class="service-badge bg-amber-100 text-amber-700"><i data-lucide="shield-check" class="h-3.5 w-3.5"></i>Citizenship Recommendation</span></div>
                                <div class="grid gap-5 lg:grid-cols-2">
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Full Name</label><input type="text" data-fd="fullName" required placeholder="Applicant's full legal name" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Date of Birth</label><input type="date" data-fd="dateOfBirth" required class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Place of Birth</label><input type="text" data-fd="placeOfBirth" required placeholder="City or district of birth" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Gender</label><select data-fd="gender" required class="form-input"><option value="" disabled selected>Select gender</option><option value="Male">Male</option><option value="Female">Female</option><option value="Other">Other</option></select></div>
                                    <div class="space-y-3 lg:col-span-2"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Parent(s) Name(s)</label><input type="text" data-fd="parentNames" required placeholder="Father's and mother's names" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Nationality of Parents</label><input type="text" data-fd="nationalityOfParents" required placeholder="Nationality of parents" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Identification Number</label><input type="text" data-fd="identificationNumber" placeholder="National ID or other reference" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Permanent Address</label><input type="text" data-fd="permanentAddress" required placeholder="Permanent address" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Current Address</label><input type="text" data-fd="currentAddress" required placeholder="Current address" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Photograph</label><input type="text" data-fd="photographReference" placeholder="Reference selected from vault" class="form-input"></div>
                                    <div class="space-y-3"><label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Signature / Thumbprint</label><input type="text" data-fd="signatureOrThumbprintReference" placeholder="Reference selected from vault" class="form-input"></div>
                                </div>
                            </div>

                            <div id="commonFields" class="dynamic-fields-panel space-y-3 mt-6">
                                <label class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Purpose / Additional Details</label>
                                <textarea data-fd="purpose" rows="4" required placeholder="Describe the purpose of your application..." class="form-input form-textarea"></textarea>
                            </div>

                            <div class="mt-5 flex flex-col gap-3 sm:flex-row sm:justify-between">
                                <button type="button" data-prev-step="1" class="rounded-xl border border-slate-200 bg-white px-6 py-2.5 text-xs font-bold uppercase tracking-widest text-slate-500">Back</button>
                                <button type="button" data-next-step="3" class="rounded-xl bg-brand-900 px-6 py-2.5 text-xs font-bold uppercase tracking-widest text-white hover:bg-brand-800 transition-colors">Next</button>
                            </div>
                        </section>

                        <section id="step3" class="form-step bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5">
                            <h3 class="text-base font-bold text-slate-900 mb-1">Attach Documents</h3>
                            <p class="text-xs text-slate-400 font-medium mb-5">Select files from your vault.</p>
                            <% if(documents.isEmpty()){ %>
                                <div class="rounded-xl border border-dashed border-slate-200 bg-slate-50 px-6 py-10 text-center">
                                    <i data-lucide="cloud-off" class="h-12 w-12 text-slate-300 mx-auto mb-4"></i>
                                    <p class="text-sm font-bold text-slate-500">No vault documents found.</p>
                                    <a href="<%= request.getContextPath() %>/citizen/documents" class="inline-flex mt-4 text-[11px] font-black uppercase tracking-[0.2em] text-brand-900 underline underline-offset-4">Open My Documents</a>
                                </div>
                            <% } else { %>
                                <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
                                    <% for(CitizenDocumentVault d: documents){ %>
                                        <label class="relative group cursor-pointer">
                                            <input type="checkbox" name="reuseDocumentIds" value="<%= d.getVaultDocId() %>" class="peer sr-only">
                                            <div class="rounded-xl border-2 border-slate-200 bg-slate-50 p-4 transition-all peer-checked:border-brand-900 peer-checked:bg-brand-50/60 group-hover:bg-white">
                                                <div class="flex items-center justify-between gap-4">
                                                    <div class="flex items-center gap-3 min-w-0">
                                                        <div class="h-10 w-10 rounded-xl bg-white border border-slate-100 text-slate-400 flex items-center justify-center shrink-0">
                                                            <i data-lucide="file-text" class="h-5 w-5"></i>
                                                        </div>
                                                        <span class="document-label text-[11px] font-black uppercase tracking-[0.12em] text-slate-700 truncate"><%= esc(d.getDocumentType()) %></span>
                                                    </div>
                                                    <div class="h-6 w-6 rounded-full border-2 border-slate-300 peer-checked:border-brand-900 peer-checked:bg-brand-900 flex items-center justify-center shrink-0">
                                                        <i data-lucide="check" class="h-3 w-3 text-white"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </label>
                                    <% } %>
                                </div>
                            <% } %>
                            <div class="mt-5 flex flex-col gap-3 sm:flex-row sm:justify-between">
                                <button type="button" data-prev-step="2" class="rounded-xl border border-slate-200 bg-white px-6 py-2.5 text-xs font-bold uppercase tracking-widest text-slate-500">Back</button>
                                <button type="button" data-next-step="4" class="rounded-xl bg-brand-900 px-6 py-2.5 text-xs font-bold uppercase tracking-widest text-white hover:bg-brand-800 transition-colors">Next</button>
                            </div>
                        </section>

                        <section id="step4" class="form-step bg-white rounded-2xl border border-slate-200/80 shadow-sm p-5">
                            <h3 class="text-base font-bold text-slate-900 mb-1">Review & Submit</h3>
                            <p class="text-xs text-slate-400 font-medium mb-5">Confirm everything before creating the application and continuing to eSewa.</p>
                            <div class="grid gap-4 xl:grid-cols-2">
                                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4"><p class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Service</p><p id="reviewService" class="mt-2 text-sm font-black text-slate-900">Not selected</p></div>
                                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4"><p class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Jurisdiction</p><p id="reviewWard" class="mt-2 text-sm font-black text-slate-900">Not selected</p></div>
                                <div class="rounded-xl border border-emerald-200 bg-emerald-50 p-4"><p class="text-[10px] font-black uppercase tracking-[0.2em] text-emerald-600">Service Fee</p><p id="reviewFee" class="mt-2 text-sm font-black text-emerald-800">Rs. 0</p></div>
                                <div class="rounded-xl border border-[#60BB46]/20 bg-[#60BB46]/5 p-4"><p class="text-[10px] font-black uppercase tracking-[0.2em] text-[#60BB46]">Payment Method</p><p class="mt-2 text-sm font-black text-[#3f8f2e]">eSewa checkout</p></div>
                                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4 xl:col-span-2"><p class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Form Summary</p><div id="reviewFields" class="mt-4 grid gap-3 md:grid-cols-2"></div></div>
                                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4 xl:col-span-2"><p class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Selected Documents</p><div id="reviewDocuments" class="mt-4 flex flex-wrap gap-2"></div></div>
                            </div>
                            <div class="mt-5 flex flex-col gap-3 sm:flex-row sm:justify-between sm:items-center">
                                <button type="button" data-prev-step="3" class="rounded-xl border border-slate-200 bg-white px-6 py-2.5 text-xs font-bold uppercase tracking-widest text-slate-500">Back</button>
                                <button type="submit" id="esewaSubmitBtn" class="rounded-xl bg-[#60BB46] px-6 py-3 text-xs font-bold uppercase tracking-widest text-white hover:bg-[#4fa038] transition-colors">Submit & Pay with eSewa</button>
                            </div>
                        </section>
                    </form>

                    <form method="post" action="https://rc-epay.esewa.com.np/api/epay/main/v2/form" id="applicationEsewaForm" class="hidden" aria-hidden="true">
                        <input type="hidden" name="amount" id="applicationEsewaAmount" value="">
                        <input type="hidden" name="tax_amount" value="0">
                        <input type="hidden" name="total_amount" id="applicationEsewaTotalAmount" value="">
                        <input type="hidden" name="transaction_uuid" id="applicationEsewaUuid" value="">
                        <input type="hidden" name="product_code" value="EPAYTEST">
                        <input type="hidden" name="product_service_charge" value="0">
                        <input type="hidden" name="product_delivery_charge" value="0">
                        <input type="hidden" name="success_url" value="<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/citizen/apply">
                        <input type="hidden" name="failure_url" value="<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/citizen/apply?error=eSewa+payment+was+cancelled+or+failed">
                        <input type="hidden" name="signed_field_names" value="total_amount,transaction_uuid,product_code">
                        <input type="hidden" name="signature" id="applicationEsewaSignature" value="">
                    </form>
                </main>
            </div>
        </div>

        <script>
            const APP_CONTEXT = '<%= request.getContextPath() %>';
            const ESEWA_SECRET = '8gBm/:&EnhH.1/q';

            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                if (sidebar) sidebar.classList.toggle('-translate-x-full');
            }

            const SERVICE_PANELS = {
                'Birth Certificate': 'fields_birth',
                'Marriage Certificate': 'fields_marriage',
                'Residence Certificate': 'fields_residence',
                'Citizenship Recommendation': 'fields_citizenship'
            };

            const serviceSelect = document.getElementById('serviceTypeSelect');
            const wardSelect = document.getElementById('wardSelect');
            const servicePrompt = document.getElementById('servicePrompt');
            const commonFields = document.getElementById('commonFields');
            const allPanels = document.querySelectorAll('.dynamic-fields-panel');
            const applyForm = document.querySelector('form[action*="/api/applications"]');
            const clientErrorBanner = document.getElementById('clientErrorBanner');
            const stepSections = document.querySelectorAll('.form-step');
            const stepPills = document.querySelectorAll('[data-step-target]');
            let currentStep = 1;

            function getSelectedServiceName() {
                if (!serviceSelect || serviceSelect.selectedIndex < 0) return '';
                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                return selectedOption ? (selectedOption.getAttribute('data-name') || '') : '';
            }

            function getActivePanel() {
                return document.querySelector('.dynamic-fields-panel.active:not(#commonFields)');
            }

            function getSelectedServiceFee() {
                if (!serviceSelect || serviceSelect.selectedIndex < 0) return 0;
                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                return Number.parseFloat(selectedOption ? (selectedOption.getAttribute('data-fee') || '0') : '0') || 0;
            }

            function formatCurrency(amount) {
                return 'Rs. ' + amount.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }

            function showClientError(message) {
                if (!clientErrorBanner) return;
                clientErrorBanner.textContent = message;
                clientErrorBanner.classList.remove('hidden');
                clientErrorBanner.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }

            function clearClientError() {
                if (!clientErrorBanner) return;
                clientErrorBanner.textContent = '';
                clientErrorBanner.classList.add('hidden');
            }

            function setRequiredState() {
                allPanels.forEach(panel => {
                    const isActive = panel.classList.contains('active');
                    panel.querySelectorAll('[required]').forEach(field => {
                        field.disabled = !isActive;
                    });
                });
            }

            function activateServicePanel() {
                const serviceName = getSelectedServiceName();
                const panelId = SERVICE_PANELS[serviceName];
                allPanels.forEach(panel => panel.classList.remove('active'));

                if (panelId) {
                    const panel = document.getElementById(panelId);
                    if (panel) panel.classList.add('active');
                    if (commonFields) commonFields.classList.add('active');
                    if (servicePrompt) servicePrompt.style.display = 'none';
                } else {
                    if (commonFields) commonFields.classList.remove('active');
                    if (servicePrompt) servicePrompt.style.display = 'block';
                }

                setRequiredState();
                lucide.createIcons();
            }

            function setStep(stepNumber) {
                currentStep = stepNumber;
                stepSections.forEach((section, index) => section.classList.toggle('active', index + 1 === stepNumber));
                stepPills.forEach((pill, index) => {
                    const pillStep = index + 1;
                    pill.classList.toggle('active', pillStep === stepNumber);
                    pill.classList.toggle('complete', pillStep < stepNumber);
                });
                window.scrollTo({ top: 0, behavior: 'smooth' });
                lucide.createIcons();
            }

            function showFieldError(field, message) {
                clearFieldErrors();
                field.style.borderColor = '#f43f5e';
                field.focus();
                const errorDiv = document.createElement('p');
                errorDiv.className = 'text-rose-500 text-xs font-bold mt-2 ml-1 field-error-msg';
                errorDiv.textContent = message || 'This field is required';
                field.parentElement.appendChild(errorDiv);
                setTimeout(clearFieldErrors, 4000);
            }

            function clearFieldErrors() {
                document.querySelectorAll('.field-error-msg').forEach(el => el.remove());
                document.querySelectorAll('[style*="border-color"]').forEach(el => el.style.borderColor = '');
            }

            function validateStepOne() {
                clearFieldErrors();
                if (!serviceSelect || !serviceSelect.value) {
                    if (servicePrompt) {
                        servicePrompt.style.border = '2px solid #f43f5e';
                        servicePrompt.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        setTimeout(() => servicePrompt.style.border = '', 3000);
                    }
                    return false;
                }
                if (!wardSelect || !wardSelect.value) {
                    showFieldError(wardSelect, 'Jurisdiction is required');
                    return false;
                }
                activateServicePanel();
                return !!getActivePanel();
            }

            function validateStepTwo() {
                clearFieldErrors();
                const activePanel = getActivePanel();
                if (!activePanel) return false;
                const requiredFields = [
                    ...activePanel.querySelectorAll('[data-fd][required]:not([disabled])'),
                    ...commonFields.querySelectorAll('[data-fd][required]:not([disabled])')
                ];
                for (const field of requiredFields) {
                    const value = field.value ? field.value.trim() : '';
                    if (!value) {
                        const label = field.closest('.space-y-3')?.querySelector('label')?.textContent?.trim();
                        showFieldError(field, (label || 'This field') + ' is required');
                        return false;
                    }
                }
                return true;
            }

            function buildFormDataObject() {
                const activePanel = getActivePanel();
                const formDataObj = { serviceType: getSelectedServiceName() };
                [activePanel, commonFields].forEach(container => {
                    if (!container) return;
                    container.querySelectorAll('[data-fd]').forEach(field => {
                        const key = field.getAttribute('data-fd');
                        const value = field.value ? field.value.trim() : '';
                        if (value) formDataObj[key] = value;
                    });
                });
                return formDataObj;
            }

            function refreshReview() {
                const selectedServiceText = serviceSelect && serviceSelect.selectedIndex >= 0 ? serviceSelect.options[serviceSelect.selectedIndex].textContent.trim() : 'Not selected';
                const selectedWardText = wardSelect && wardSelect.selectedIndex >= 0 ? wardSelect.options[wardSelect.selectedIndex].textContent.trim() : 'Not selected';
                const selectedFee = getSelectedServiceFee();
                const reviewService = document.getElementById('reviewService');
                const reviewWard = document.getElementById('reviewWard');
                const reviewFee = document.getElementById('reviewFee');
                const reviewFields = document.getElementById('reviewFields');
                const reviewDocuments = document.getElementById('reviewDocuments');
                const formDataObj = buildFormDataObject();

                if (reviewService) reviewService.textContent = selectedServiceText || 'Not selected';
                if (reviewWard) reviewWard.textContent = selectedWardText || 'Not selected';
                if (reviewFee) reviewFee.textContent = formatCurrency(selectedFee);

                if (reviewFields) {
                    reviewFields.innerHTML = '';
                    Object.entries(formDataObj).forEach(([key, value]) => {
                        const item = document.createElement('div');
                        item.className = 'rounded-xl border border-slate-200 bg-white px-4 py-3';
                        const heading = document.createElement('p');
                        heading.className = 'text-[10px] font-black uppercase tracking-[0.2em] text-slate-400';
                        heading.textContent = key.replace(/([A-Z])/g, ' $1').trim();
                        const body = document.createElement('p');
                        body.className = 'mt-2 text-sm font-semibold text-slate-800';
                        body.textContent = value;
                        item.appendChild(heading);
                        item.appendChild(body);
                        reviewFields.appendChild(item);
                    });
                }

                if (reviewDocuments) {
                    reviewDocuments.innerHTML = '';
                    const checkedDocuments = document.querySelectorAll('input[name="reuseDocumentIds"]:checked');
                    if (!checkedDocuments.length) {
                        const empty = document.createElement('p');
                        empty.className = 'text-sm font-semibold text-slate-500';
                        empty.textContent = 'No vault documents selected.';
                        reviewDocuments.appendChild(empty);
                    } else {
                        checkedDocuments.forEach(input => {
                            const labelText = input.closest('label')?.querySelector('.document-label')?.textContent?.trim() || 'Document';
                            const badge = document.createElement('span');
                            badge.className = 'inline-flex items-center rounded-full bg-brand-50 px-3 py-2 text-[10px] font-black uppercase tracking-[0.2em] text-brand-900';
                            badge.textContent = labelText;
                            reviewDocuments.appendChild(badge);
                        });
                    }
                }
            }

            function validateBeforeEnteringStep(stepNumber) {
                if (stepNumber <= currentStep) return true;
                if (currentStep === 1 && !validateStepOne()) return false;
                if (currentStep <= 2 && stepNumber > 2 && !validateStepTwo()) return false;
                return true;
            }

            allPanels.forEach(panel => panel.querySelectorAll('[required]').forEach(field => field.disabled = true));
            if (serviceSelect) serviceSelect.addEventListener('change', activateServicePanel);

            document.querySelectorAll('[data-next-step]').forEach(button => {
                button.addEventListener('click', function() {
                    const targetStep = Number(this.getAttribute('data-next-step'));
                    if (!validateBeforeEnteringStep(targetStep)) return;
                    if (targetStep === 4) refreshReview();
                    setStep(targetStep);
                });
            });

            document.querySelectorAll('[data-prev-step]').forEach(button => {
                button.addEventListener('click', function() {
                    setStep(Number(this.getAttribute('data-prev-step')));
                });
            });

            stepPills.forEach(pill => {
                pill.addEventListener('click', function() {
                    const targetStep = Number(this.getAttribute('data-step-target'));
                    if (!validateBeforeEnteringStep(targetStep)) return;
                    if (targetStep === 4) refreshReview();
                    setStep(targetStep);
                });
            });

            async function generateEsewaSignature(message) {
                const encoder = new TextEncoder();
                const keyData = encoder.encode(ESEWA_SECRET);
                const msgData = encoder.encode(message);
                const cryptoKey = await crypto.subtle.importKey(
                    'raw', keyData, { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']
                );
                const sig = await crypto.subtle.sign('HMAC', cryptoKey, msgData);
                return btoa(String.fromCharCode(...new Uint8Array(sig)));
            }

            async function handleApplicationSubmit(event) {
                event.preventDefault();
                clearClientError();

                if (!validateStepOne()) { setStep(1); return; }
                if (!validateStepTwo()) { setStep(2); return; }

                const serviceFee = getSelectedServiceFee();
                if (!(serviceFee > 0)) {
                    showClientError('The selected service does not have a valid eSewa payment amount.');
                    setStep(4);
                    return;
                }

                document.getElementById('formDataHidden').value = JSON.stringify(buildFormDataObject());
                const submitButton = document.getElementById('esewaSubmitBtn');
                const originalButtonText = submitButton ? submitButton.textContent : '';
                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.textContent = 'Creating application...';
                    submitButton.classList.add('opacity-70', 'cursor-not-allowed');
                }

                try {
                    const body = new URLSearchParams(new FormData(applyForm));
                    body.delete('redirectTo');
                    const response = await fetch(applyForm.action, {
                        method: 'POST',
                        headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        credentials: 'same-origin',
                        body: body.toString()
                    });
                    const data = await response.json().catch(() => null);
                    if (!response.ok || !data || !data.application || !data.application.applicationId) {
                        throw new Error((data && (data.error || data.message)) || 'Unable to create the application before payment.');
                    }

                    const applicationId = data.application.applicationId;
                    const totalAmount = serviceFee.toFixed(2);
                    const transactionUuid = 'SARKAR-APP-' + applicationId + '-' + Date.now();
                    const message = 'total_amount=' + totalAmount + ',transaction_uuid=' + transactionUuid + ',product_code=EPAYTEST';
                    const signature = await generateEsewaSignature(message);

                    document.getElementById('applicationEsewaAmount').value = totalAmount;
                    document.getElementById('applicationEsewaTotalAmount').value = totalAmount;
                    document.getElementById('applicationEsewaUuid').value = transactionUuid;
                    document.getElementById('applicationEsewaSignature').value = signature;

                    if (submitButton) {
                        submitButton.textContent = 'Redirecting to eSewa...';
                    }
                    document.getElementById('applicationEsewaForm').submit();
                } catch (error) {
                    showClientError(error && error.message ? error.message : 'Unable to continue to eSewa right now.');
                    if (submitButton) {
                        submitButton.disabled = false;
                        submitButton.textContent = originalButtonText;
                        submitButton.classList.remove('opacity-70', 'cursor-not-allowed');
                    }
                }
            }

            if (applyForm) {
                applyForm.addEventListener('submit', handleApplicationSubmit);
            }

            lucide.createIcons();
        </script>
    </body>
</html>
