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
        <title>New Application - SarkarSathi</title>
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
                            brand:{
                                50:'#f0f5fc',
                                100:'#e1eafa',
                                500:'#3b82f6',
                                800:'#154a91',
                                900:'#0b3d86'
                            }
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .glass-panel {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }
            .sidebar-link { transition: all 0.2s; }
            .sidebar-link:hover, .sidebar-link.active { background: #f0f5fc; color: #0b3d86; font-weight: 700; }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
            /* Visible input fields with soft borders */
            .form-input {
                width: 100%;
                background: #f8fafc;
                border: 1.5px solid #cbd5e1;
                border-radius: 1.25rem;
                padding: 1.1rem 1.5rem;
                font-size: 0.875rem;
                font-weight: 600;
                color: #334155;
                outline: none;
                transition: all 0.25s ease;
            }
            .form-input::placeholder { color: #94a3b8; font-weight: 500; }
            .form-input:focus {
                border-color: #3b82f6;
                background: #fff;
                box-shadow: 0 0 0 3px rgba(59,130,246,0.10);
            }
            .form-textarea { resize: none; line-height: 1.7; border-radius: 1.5rem; padding: 1.25rem 1.5rem; }
            /* Dynamic fields panel */
            .dynamic-fields-panel { display: none; animation: fadeSlideIn 0.35s ease; }
            .dynamic-fields-panel.active { display: block; }
            @keyframes fadeSlideIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .service-badge {
                display: inline-flex; align-items: center; gap: 0.5rem;
                padding: 0.4rem 1rem; border-radius: 1rem;
                font-size: 10px; font-weight: 800; text-transform: uppercase;
                letter-spacing: 0.1em;
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#f8fafc] text-slate-900 antialiased overflow-x-hidden">
        <div class="flex min-h-screen relative">
            <!-- Mobile Bottom Nav -->
            <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Portal</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/apply" class="flex flex-col items-center justify-center gap-1 text-brand-900">
                    <i data-lucide="plus-circle" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Genesis</span>
                </a>
                <a href="<%= request.getContextPath() %>/citizen/tracking" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="search-check" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Track</span>
                </a>
                <button onclick="toggleSidebar()" class="flex flex-col items-center justify-center gap-1 text-slate-400">
                    <i data-lucide="menu" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Menu</span>
                </button>
            </nav>

            <!-- Desktop Sidebar -->
            <!-- Sidebar Overlay -->
            <div id="sidebar-overlay" onclick="toggleSidebar()" class="fixed inset-0 z-[60] hidden bg-slate-900/60 backdrop-blur-sm lg:hidden transition-opacity"></div>
            
            <%@ include file="../includes/sidebar-citizen.jsp" %>

            <div class="flex-1 flex flex-col min-h-screen w-full relative">

                <!-- Header -->
                <header class="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-slate-100 px-6 py-6 lg:px-12">
                    <div class="flex items-center justify-between max-w-7xl mx-auto">
                        <div>
                            <h1 class="text-2xl font-black text-slate-900 tracking-tighter uppercase ">Genesis.</h1>
                            <p class="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 mt-1">Initiate New Resource Protocol</p>
                        </div>
                        
                        <div class="flex items-center gap-4">
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="h-12 w-12 flex items-center justify-center rounded-2xl border border-slate-100 text-slate-400 hover:text-brand-900 transition-colors">
                                <i data-lucide="chevron-left" class="h-5 w-5"></i>
                            </a>
                            <div class="h-12 w-12 rounded-2xl bg-brand-50 flex items-center justify-center text-brand-900">
                                <i data-lucide="fingerprint" class="h-6 w-6"></i>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 p-6 lg:p-12 pb-32">
                    <div class="max-w-4xl mx-auto">
                        <% if(pageError!=null || formError!=null){ %>
                            <div class="mb-10 bg-rose-50 text-rose-600 p-6 rounded-[2rem] border border-rose-100 flex items-center gap-4 animate-fade-in-up">
                                <i data-lucide="alert-triangle" class="h-6 w-6"></i>
                                <p class="text-xs font-black uppercase tracking-widest"><%= esc(pageError!=null?pageError:formError) %></p>
                            </div>
                        <% } %>

                        <form method="post" action="<%= request.getContextPath() %>/api/applications" class="space-y-12 animate-fade-in-up">
                            <input type="hidden" name="redirectTo" value="/citizen/tracking">
                            <input type="hidden" name="citizenId" value="<%= citizenId %>">

                            <section class="bg-white rounded-[4rem] border border-slate-100 p-10 lg:p-14 shadow-2xl shadow-slate-200/50 relative overflow-hidden">
                                <div class="absolute top-0 right-0 h-40 w-40 bg-brand-50 rounded-bl-[5rem] -mr-10 -mt-10 opacity-50"></div>
                                
                                <div class="relative z-10">
                                    <h3 class="text-2xl font-black text-brand-900 tracking-tighter mb-10 ">Process Definition.</h3>
                                    
                                    <div class="grid sm:grid-cols-2 gap-8 mb-10">
                                        <div class="space-y-4">
                                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 ml-2">Resource Type</label>
                                            <div class="relative group">
                                                <select name="serviceTypeId" id="serviceTypeSelect" required class="form-input appearance-none cursor-pointer font-black uppercase tracking-widest text-xs pr-12">
                                                    <option value="" disabled selected>— Select a service —</option>
                                                    <% for(ServiceType s: serviceTypes){ %>
                                                        <option value="<%= s.getServiceTypeId() %>" data-name="<%= esc(s.getServiceName()) %>">
                                                            <%= esc(s.getServiceName()) %> — RS. <%= esc(s.getBaseFee()) %>
                                                        </option>
                                                    <% } %>
                                                </select>
                                                <i data-lucide="chevron-down" class="absolute right-5 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-400 pointer-events-none"></i>
                                            </div>
                                        </div>

                                        <div class="space-y-4">
                                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-400 ml-2">Jurisdiction</label>
                                            <div class="relative group">
                                                <select name="wardId" required class="form-input appearance-none cursor-pointer font-black uppercase tracking-widest text-xs pr-12">
                                                    <% for(Ward w: wards){ %>
                                                        <option value="<%= w.getWardId() %>">
                                                            WARD #<%= w.getWardNumber() %> — <%= esc(w.getMunicipalityName()) %>
                                                        </option>
                                                    <% } %>
                                                </select>
                                                <i data-lucide="map-pin" class="absolute right-5 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-400 pointer-events-none"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <input type="hidden" name="formData" id="formDataHidden" value="{}">

                                    <!-- Prompt to select a service type -->
                                    <div id="servicePrompt" class="py-12 text-center rounded-[2rem] border-2 border-dashed border-slate-200 bg-slate-50/50">
                                        <i data-lucide="hand-metal" class="h-10 w-10 text-slate-300 mx-auto mb-4"></i>
                                        <p class="text-xs font-black uppercase tracking-widest text-slate-400">Select a resource type above to begin</p>
                                    </div>

                                    <!-- ═══ BIRTH CERTIFICATE FIELDS ═══ -->
                                    <div id="fields_birth" class="dynamic-fields-panel space-y-6">
                                        <div class="flex items-center gap-3 mb-2">
                                            <span class="service-badge bg-emerald-100 text-emerald-700"><i data-lucide="baby" class="h-3.5 w-3.5"></i> Birth Certificate</span>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Child's Full Name</label>
                                                <input type="text" data-fd="childFullName" required placeholder="Full name of the child" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Date of Birth</label>
                                                <input type="date" data-fd="dateOfBirth" required class="form-input">
                                            </div>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Father's Full Name</label>
                                                <input type="text" data-fd="fatherName" required placeholder="Father's full name" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Mother's Full Name</label>
                                                <input type="text" data-fd="motherName" required placeholder="Mother's full name" class="form-input">
                                            </div>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Place of Birth</label>
                                                <input type="text" data-fd="birthPlace" required placeholder="Hospital / Home address" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Gender</label>
                                                <select data-fd="gender" required class="form-input appearance-none cursor-pointer">
                                                    <option value="" disabled selected>— Select —</option>
                                                    <option value="Male">Male</option>
                                                    <option value="Female">Female</option>
                                                    <option value="Other">Other</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ═══ MARRIAGE CERTIFICATE FIELDS ═══ -->
                                    <div id="fields_marriage" class="dynamic-fields-panel space-y-6">
                                        <div class="flex items-center gap-3 mb-2">
                                            <span class="service-badge bg-pink-100 text-pink-700"><i data-lucide="heart" class="h-3.5 w-3.5"></i> Marriage Certificate</span>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Groom's Full Name</label>
                                                <input type="text" data-fd="groomName" required placeholder="Full legal name of groom" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Bride's Full Name</label>
                                                <input type="text" data-fd="brideName" required placeholder="Full legal name of bride" class="form-input">
                                            </div>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Date of Marriage</label>
                                                <input type="date" data-fd="marriageDate" required class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Marriage Place</label>
                                                <input type="text" data-fd="marriagePlace" required placeholder="Venue / Location" class="form-input">
                                            </div>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Witness 1 — Full Name</label>
                                                <input type="text" data-fd="witness1" required placeholder="First witness full name" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Witness 2 — Full Name</label>
                                                <input type="text" data-fd="witness2" required placeholder="Second witness full name" class="form-input">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ═══ RESIDENCE CERTIFICATE FIELDS ═══ -->
                                    <div id="fields_residence" class="dynamic-fields-panel space-y-6">
                                        <div class="flex items-center gap-3 mb-2">
                                            <span class="service-badge bg-sky-100 text-sky-700"><i data-lucide="home" class="h-3.5 w-3.5"></i> Residence Certificate</span>
                                        </div>
                                        <div class="space-y-3">
                                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Applicant Full Name</label>
                                            <input type="text" data-fd="applicantName" required placeholder="Your full legal name" class="form-input">
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Current Address</label>
                                                <input type="text" data-fd="currentAddress" required placeholder="Ward, Tole, Municipality" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Duration of Residence</label>
                                                <input type="text" data-fd="residenceDuration" required placeholder="e.g. 5 years" class="form-input">
                                            </div>
                                        </div>
                                        <div class="space-y-3">
                                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Contact Number</label>
                                            <input type="tel" data-fd="contactNumber" required placeholder="e.g. 9841234567" class="form-input">
                                        </div>
                                    </div>

                                    <!-- ═══ CITIZENSHIP RECOMMENDATION FIELDS ═══ -->
                                    <div id="fields_citizenship" class="dynamic-fields-panel space-y-6">
                                        <div class="flex items-center gap-3 mb-2">
                                            <span class="service-badge bg-amber-100 text-amber-700"><i data-lucide="shield-check" class="h-3.5 w-3.5"></i> Citizenship Recommendation</span>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Applicant Full Name</label>
                                                <input type="text" data-fd="applicantName" required placeholder="Full legal name" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Date of Birth</label>
                                                <input type="date" data-fd="dateOfBirth" required class="form-input">
                                            </div>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Father's Full Name</label>
                                                <input type="text" data-fd="fatherName" required placeholder="Father's full name" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Mother's Full Name</label>
                                                <input type="text" data-fd="motherName" required placeholder="Mother's full name" class="form-input">
                                            </div>
                                        </div>
                                        <div class="grid sm:grid-cols-2 gap-6">
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Permanent Address</label>
                                                <input type="text" data-fd="permanentAddress" required placeholder="Ward, Tole, Municipality" class="form-input">
                                            </div>
                                            <div class="space-y-3">
                                                <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Reason for Recommendation</label>
                                                <select data-fd="reason" required class="form-input appearance-none cursor-pointer">
                                                    <option value="" disabled selected>— Select —</option>
                                                    <option value="New Citizenship">New Citizenship</option>
                                                    <option value="Citizenship by Descent">Citizenship by Descent</option>
                                                    <option value="Duplicate/Lost">Duplicate / Lost</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ═══ COMMON PURPOSE FIELD (all types) ═══ -->
                                    <div id="commonFields" class="dynamic-fields-panel space-y-6 mt-8">
                                        <div class="space-y-3">
                                            <label class="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Purpose / Additional Details</label>
                                            <textarea data-fd="purpose" rows="3" required
                                                      placeholder="Describe the purpose of your application..."
                                                      class="form-input form-textarea"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <section class="bg-white rounded-[4rem] border border-slate-100 p-10 lg:p-14 shadow-2xl shadow-slate-200/50">
                                <h3 class="text-2xl font-black text-brand-900 tracking-tighter mb-4 ">Encrypted Files.</h3>
                                <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-10">Select binary assets from your vault</p>
                                
                                <% if(documents.isEmpty()){ %>
                                    <div class="py-16 text-center bg-slate-50 rounded-[3rem] border border-dashed border-slate-200">
                                        <i data-lucide="cloud-off" class="h-12 w-12 text-slate-200 mx-auto mb-6"></i>
                                        <p class="text-xs font-black uppercase tracking-widest text-slate-300  mb-4">No Vault Assets Detected</p>
                                        <a href="<%= request.getContextPath() %>/citizen/documents" class="text-brand-900 font-bold text-[10px] uppercase tracking-widest underline decoration-2 underline-offset-4">Sync Vault Metadata</a>
                                    </div>
                                <% } else { %>
                                    <div class="grid sm:grid-cols-2 gap-4">
                                        <% for(CitizenDocumentVault d: documents){ %>
                                            <label class="relative group cursor-pointer">
                                                <input type="checkbox" name="reuseDocumentIds" value="<%= d.getVaultDocId() %>" class="peer sr-only">
                                                <div class="p-6 rounded-3xl border-2 border-slate-200 bg-slate-50 group-hover:bg-white transition-all peer-checked:border-brand-900 peer-checked:bg-brand-50/50">
                                                    <div class="flex items-center justify-between">
                                                        <div class="flex items-center gap-4">
                                                            <div class="h-10 w-10 rounded-xl bg-white border border-slate-100 text-slate-400 flex items-center justify-center">
                                                                <i data-lucide="file-text" class="h-5 w-5"></i>
                                                            </div>
                                                            <span class="text-[11px] font-black uppercase tracking-widest text-slate-700"><%= esc(d.getDocumentType()) %></span>
                                                        </div>
                                                        <div class="h-6 w-6 rounded-full border-2 border-slate-300 peer-checked:border-brand-900 peer-checked:bg-brand-900 flex items-center justify-center transition-all">
                                                            <i data-lucide="check" class="h-3 w-3 text-white"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </label>
                                        <% } %>
                                    </div>
                                <% } %>
                            </section>

                            <div class="pt-6">
                                <button type="submit" class="w-full bg-brand-900 text-white rounded-[2.5rem] py-8 text-sm font-black uppercase tracking-[0.3em] shadow-2xl shadow-brand-900/30 active:scale-[0.98] transition-all relative overflow-hidden group">
                                    <span class="relative z-10 flex items-center justify-center gap-4">
                                        Transmit Official Request
                                        <i data-lucide="send" class="h-5 w-5 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform"></i>
                                    </span>
                                    <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-blue-800 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                                </button>
                                <p class="text-center text-[9px] font-black uppercase tracking-[0.4em] text-slate-300 mt-8">Secure End-to-End Administrative Handshake</p>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                if (sidebar) sidebar.classList.toggle('-translate-x-full');
            }

            // ── Service-type → panel mapping ──
            const SERVICE_PANELS = {
                'Birth Certificate':            'fields_birth',
                'Marriage Certificate':          'fields_marriage',
                'Residence Certificate':         'fields_residence',
                'Citizenship Recommendation':    'fields_citizenship'
            };

            const serviceSelect = document.getElementById('serviceTypeSelect');
            const servicePrompt = document.getElementById('servicePrompt');
            const commonFields  = document.getElementById('commonFields');
            const allPanels     = document.querySelectorAll('.dynamic-fields-panel');

            // Switch visible panel when service type changes
            if (serviceSelect) {
                serviceSelect.addEventListener('change', function() {
                    const selectedOption = this.options[this.selectedIndex];
                    const serviceName = selectedOption.getAttribute('data-name') || '';

                    // Hide prompt
                    if (servicePrompt) servicePrompt.style.display = 'none';

                    // Hide all panels and clear their required state
                    allPanels.forEach(p => {
                        p.classList.remove('active');
                        p.querySelectorAll('[required]').forEach(f => f.disabled = true);
                    });

                    // Show the matching panel
                    const panelId = SERVICE_PANELS[serviceName];
                    if (panelId) {
                        const panel = document.getElementById(panelId);
                        if (panel) {
                            panel.classList.add('active');
                            panel.querySelectorAll('[required]').forEach(f => f.disabled = false);
                        }
                    }

                    // Always show common fields when a service is selected
                    if (commonFields) {
                        commonFields.classList.add('active');
                        commonFields.querySelectorAll('[required]').forEach(f => f.disabled = false);
                    }

                    // Re-init icons for newly visible panels
                    lucide.createIcons();
                });

                // On page load: disable all dynamic required fields (no panel is active yet)
                allPanels.forEach(p => {
                    p.querySelectorAll('[required]').forEach(f => f.disabled = true);
                });
            }

            // ── Form submission: serialize active fields to JSON ──
            const applyForm = document.querySelector('form[action*="/api/applications"]');
            if (applyForm) {
                applyForm.addEventListener('submit', function(e) {
                    // Find the active service panel
                    const activePanel = document.querySelector('.dynamic-fields-panel.active:not(#commonFields)');
                    if (!activePanel) {
                        e.preventDefault();
                        if (servicePrompt) {
                            servicePrompt.style.border = '2px solid #f43f5e';
                            servicePrompt.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            setTimeout(() => servicePrompt.style.border = '', 3000);
                        }
                        return;
                    }

                    // Validate all visible required fields in the active panel + common
                    const requiredFields = [
                        ...activePanel.querySelectorAll('[data-fd][required]:not([disabled])'),
                        ...commonFields.querySelectorAll('[data-fd][required]:not([disabled])')
                    ];
                    for (const field of requiredFields) {
                        if (!field.value || !field.value.trim()) {
                            e.preventDefault();
                            showFieldError(field, field.closest('.space-y-3')
                                ?.querySelector('label')?.textContent?.trim() + ' is required');
                            return;
                        }
                    }

                    // Build JSON from all [data-fd] fields in active panel + common
                    const formDataObj = {};
                    const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                    formDataObj.serviceType = selectedOption.getAttribute('data-name') || '';

                    const collectFrom = [activePanel, commonFields];
                    collectFrom.forEach(container => {
                        if (!container) return;
                        container.querySelectorAll('[data-fd]').forEach(field => {
                            const key = field.getAttribute('data-fd');
                            const val = field.value ? field.value.trim() : '';
                            if (val) formDataObj[key] = val;
                        });
                    });

                    document.getElementById('formDataHidden').value = JSON.stringify(formDataObj);
                });
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

            lucide.createIcons();
        </script>
    </body>
</html>