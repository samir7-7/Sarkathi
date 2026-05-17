<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="SarkarSathi - Your trusted digital governance platform connecting citizens with municipal services. Apply, track, and manage civic services online." />
    <title>SarkarSathi - Governance for a Better Tomorrow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Outfit', 'sans-serif'] },
                    colors: {
                        brand: { 50:'#f0f5fc', 100:'#e1eafa', 400:'#60a5fa', 500:'#3b82f6', 800:'#154a91', 900:'#0b3d86' }
                    }
                }
            }
        }
    </script>
    <%@ include file="../includes/responsive-scripts.jsp" %>
    <%@ include file="../includes/lucide-icons.jsp" %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style/ui-improvements.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style/typography.css">
    <style>
        html{zoom:0.86}body{font-family:'Outfit',sans-serif}
        .fade-up{opacity:0;transform:translateY(24px);transition:all 0.6s ease}
        .fade-up.visible{opacity:1;transform:translateY(0)}
        @keyframes pulse-ring{0%{transform:scale(1);opacity:.8}100%{transform:scale(2.5);opacity:0}}
        .pulse-dot{position:relative;display:inline-block;width:8px;height:8px}
        .pulse-dot::before{content:'';position:absolute;inset:0;border-radius:50%;background:#60a5fa;animation:pulse-ring 2s infinite}
        .pulse-dot::after{content:'';position:absolute;inset:0;border-radius:50%;background:#3b82f6}
        @media(max-width:1023px){.safe-area-bottom{padding-bottom:env(safe-area-inset-bottom,1.5rem)}}
    </style>
</head>
<body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-16 lg:pb-0 overflow-x-hidden">
    <% 
        String displayName = (String) session.getAttribute("displayName"); 
        boolean loggedIn = displayName != null && !displayName.isBlank(); 
        String loginStatus = (String) request.getAttribute("login");
        if(loginStatus == null) loginStatus = request.getParameter("login");
    %>

    <%@ include file="../includes/mobile-nav-public.jsp" %>

    <div class="relative isolate">
    <%@ include file="../includes/navbar-public.jsp" %>

    <main>
        <!-- ===== HERO SECTION ===== -->
        <section class="relative overflow-hidden bg-gradient-to-br from-brand-900 via-brand-800 to-[#1e5bab] px-5 py-14 lg:px-12 lg:py-28">
            <div class="absolute inset-0 opacity-[0.03]" style="background-image:url(\"data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23fff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E\")"></div>
            <div class="mx-auto max-w-7xl">
                <div class="grid items-center gap-16 lg:grid-cols-[1.2fr_1fr]">
                    <div class="relative z-10 text-center lg:text-left">
                        <% if ("success".equals(loginStatus) && loggedIn) { %>
                        <div class="mb-6 inline-flex items-center gap-2.5 rounded-xl border border-emerald-400/30 bg-emerald-500/15 px-5 py-2.5 text-xs font-extrabold uppercase tracking-widest text-emerald-200">
                            <i data-lucide="check-circle" class="h-4 w-4"></i> Welcome back, <%= displayName %>
                        </div>
                        <% } %>
                        <div class="inline-flex items-center gap-2 rounded-full border border-white/20 bg-white/[0.15] px-5 py-2 text-[11px] font-extrabold uppercase tracking-[0.2em] text-white/90 backdrop-blur-sm"><span class="pulse-dot"></span> Digital Municipal Portal</div>
                        <h1 class="mt-5 text-3xl font-black leading-[1.1] tracking-tight text-white sm:text-5xl lg:text-[5rem]">One Step Ahead<br/><span class="text-brand-400">This Season.</span></h1>
                        <p class="mx-auto mt-4 max-w-xl text-sm sm:text-lg leading-relaxed text-white/70 lg:mx-0">Experience seamless digital governance. Apply for certificates, pay taxes, track applications & access agriculture notices — all from one unified platform.</p>
                        <div class="mt-6 flex flex-wrap justify-center gap-3 lg:justify-start">
                            <% if (loggedIn) { %>
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="inline-flex items-center gap-2 rounded-2xl bg-white px-6 py-3 sm:px-9 sm:py-4 text-[12px] sm:text-[13px] font-extrabold uppercase tracking-[0.15em] text-brand-900 shadow-2xl transition-all hover:-translate-y-0.5 active:scale-95">Access Portal <i data-lucide="arrow-right" class="h-4 w-4"></i></a>
                            <% } else { %>
                            <a href="<%= request.getContextPath() %>/login?userType=citizen" class="inline-flex items-center gap-2 rounded-2xl bg-white px-6 py-3 sm:px-9 sm:py-4 text-[12px] sm:text-[13px] font-extrabold uppercase tracking-[0.15em] text-brand-900 shadow-2xl transition-all hover:-translate-y-0.5 active:scale-95">Get Started <i data-lucide="arrow-right" class="h-4 w-4"></i></a>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/about" class="inline-flex items-center gap-2 rounded-2xl border-2 border-white/30 px-6 py-3 sm:px-9 sm:py-4 text-[12px] sm:text-[13px] font-extrabold uppercase tracking-[0.15em] text-white transition-all hover:border-white hover:bg-white/10">Learn More</a>
                        </div>
                        <div class="mt-8 grid grid-cols-3 gap-4 lg:flex lg:justify-start lg:gap-10">
                            <div class="text-center lg:text-left"><p class="text-2xl sm:text-3xl font-black text-white">10k+</p><p class="text-[9px] sm:text-[10px] font-extrabold uppercase tracking-[0.2em] text-white/50">Citizens</p></div>
                            <div class="text-center lg:text-left"><p class="text-2xl sm:text-3xl font-black text-white">100%</p><p class="text-[9px] sm:text-[10px] font-extrabold uppercase tracking-[0.2em] text-white/50">Digital</p></div>
                            <div class="text-center lg:text-left"><p class="text-2xl sm:text-3xl font-black text-white">24/7</p><p class="text-[9px] sm:text-[10px] font-extrabold uppercase tracking-[0.2em] text-white/50">Services</p></div>
                        </div>
                    </div>
                    <div class="hidden lg:block">
                        <div class="relative overflow-hidden rounded-3xl border-[6px] border-white/15 shadow-[0_40px_80px_rgba(0,0,0,0.3)]">
                            <img src="https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=1200" alt="Municipal governance" class="h-[500px] w-full object-cover" />
                            <div class="absolute bottom-4 left-4 right-4 flex items-center gap-4 rounded-2xl border border-white/20 bg-white/15 p-5 backdrop-blur-xl">
                                <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-white text-brand-900 shadow-lg"><i data-lucide="shield-check" class="h-6 w-6"></i></div>
                                <div><p class="font-extrabold text-white">Trusted Governance</p><p class="text-sm text-white/70">Secure & Transparent Services</p></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="absolute bottom-0 left-0 right-0 h-28 bg-gradient-to-t from-[#f8fafc] to-transparent"></div>
        </section>

        <!-- ===== FEATURES SECTION ===== -->
        <section class="px-5 py-12 lg:px-12 lg:py-20">
            <div class="mx-auto max-w-7xl">
                <div class="text-center fade-up">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-3">Why Choose Us</p>
                    <h2 class="text-2xl sm:text-3xl font-black tracking-tight text-slate-900 lg:text-5xl">Awesome Features</h2>
                    <p class="mx-auto mt-4 max-w-xl text-slate-500 leading-relaxed">Empowering citizens through technology-driven municipal services and transparent governance.</p>
                </div>
                <div class="mt-12 grid gap-6 md:grid-cols-3">
                    <div class="group rounded-3xl border border-slate-100 bg-white p-9 text-center shadow-xl shadow-slate-200/50 transition-all duration-400 hover:-translate-y-1 hover:border-brand-500 hover:shadow-2xl hover:shadow-brand-900/10 fade-up">
                        <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 transition-colors group-hover:bg-brand-900 group-hover:text-white"><i data-lucide="globe" class="h-7 w-7"></i></div>
                        <h4 class="text-lg font-extrabold text-slate-900 mb-2">Access Anywhere</h4>
                        <p class="text-sm text-slate-500 leading-relaxed">Submit applications and access services from anywhere, anytime. No queues, no waiting.</p>
                    </div>
                    <div class="group rounded-3xl border border-slate-100 bg-white p-9 text-center shadow-xl shadow-slate-200/50 transition-all duration-400 hover:-translate-y-1 hover:border-brand-500 hover:shadow-2xl hover:shadow-brand-900/10 fade-up" style="transition-delay:0.1s;">
                        <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 transition-colors group-hover:bg-brand-900 group-hover:text-white"><i data-lucide="file-check-2" class="h-7 w-7"></i></div>
                        <h4 class="text-lg font-extrabold text-slate-900 mb-2">Fast Certifications</h4>
                        <p class="text-sm text-slate-500 leading-relaxed">Get birth, marriage, and citizenship certificates processed digitally with real-time tracking.</p>
                    </div>
                    <div class="group rounded-3xl border border-slate-100 bg-white p-9 text-center shadow-xl shadow-slate-200/50 transition-all duration-400 hover:-translate-y-1 hover:border-brand-500 hover:shadow-2xl hover:shadow-brand-900/10 fade-up" style="transition-delay:0.2s;">
                        <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 transition-colors group-hover:bg-brand-900 group-hover:text-white"><i data-lucide="shield-check" class="h-7 w-7"></i></div>
                        <h4 class="text-lg font-extrabold text-slate-900 mb-2">Secure & Trusted</h4>
                        <p class="text-sm text-slate-500 leading-relaxed">Enterprise-grade encryption protects all your data. Privacy-first architecture you can trust.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== OUR SERVICES SECTION ===== -->
        <section class="px-5 pt-8 pb-14 lg:px-12 lg:pt-16 lg:pb-20">
            <div class="mx-auto max-w-7xl">
                <div class="text-center fade-up">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-3">What We Offer</p>
                    <h2 class="text-2xl sm:text-3xl font-black tracking-tight text-slate-900 lg:text-5xl">Our Popular Services</h2>
                    <p class="mx-auto mt-4 max-w-xl text-slate-500 leading-relaxed">Comprehensive municipal services designed for modern citizens — all available online.</p>
                </div>
                <div class="mt-12 grid gap-6 md:grid-cols-3">
                    <div class="group overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-md transition-all duration-400 hover:-translate-y-1 hover:shadow-xl fade-up">
                        <div class="relative h-52 overflow-hidden"><img src="https://images.unsplash.com/photo-1554224155-6726b3ff858f?q=80&w=600" alt="Tax payments" class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"/><span class="absolute top-3 left-3 rounded-lg bg-brand-900 px-3 py-1.5 text-[11px] font-extrabold uppercase tracking-wider text-white">Popular</span></div>
                        <div class="p-6"><h4 class="text-lg font-extrabold text-slate-900 mb-2">Tax Payment Portal</h4><p class="text-sm text-slate-500 leading-relaxed mb-4">Pay property tax, business tax, and other municipal fees securely online with eSewa integration.</p><a href="<%= request.getContextPath() %>/login?userType=citizen" class="inline-flex items-center gap-1.5 text-xs font-extrabold uppercase tracking-[0.15em] text-brand-900 transition-all hover:gap-3">Access Now <i data-lucide="arrow-right" class="h-3 w-3"></i></a></div>
                    </div>
                    <div class="group overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-md transition-all duration-400 hover:-translate-y-1 hover:shadow-xl fade-up" style="transition-delay:0.1s;">
                        <div class="relative h-52 overflow-hidden"><img src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=600" alt="Certificate services" class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"/><span class="absolute top-3 left-3 rounded-lg bg-brand-900 px-3 py-1.5 text-[11px] font-extrabold uppercase tracking-wider text-white">Essential</span></div>
                        <div class="p-6"><h4 class="text-lg font-extrabold text-slate-900 mb-2">Certificate Services</h4><p class="text-sm text-slate-500 leading-relaxed mb-4">Apply for birth, death, marriage, and citizenship certificates with end-to-end digital processing.</p><a href="<%= request.getContextPath() %>/login?userType=citizen" class="inline-flex items-center gap-1.5 text-xs font-extrabold uppercase tracking-[0.15em] text-brand-900 transition-all hover:gap-3">Apply Now <i data-lucide="arrow-right" class="h-3 w-3"></i></a></div>
                    </div>
                    <div class="group overflow-hidden rounded-3xl border border-slate-100 bg-white shadow-md transition-all duration-400 hover:-translate-y-1 hover:shadow-xl fade-up" style="transition-delay:0.2s;">
                        <div class="relative h-52 overflow-hidden"><img src="https://images.unsplash.com/photo-1574943320219-553eb213f72d?q=80&w=600" alt="Agriculture notices" class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"/><span class="absolute top-3 left-3 rounded-lg bg-brand-900 px-3 py-1.5 text-[11px] font-extrabold uppercase tracking-wider text-white">New</span></div>
                        <div class="p-6"><h4 class="text-lg font-extrabold text-slate-900 mb-2">Agriculture Advisory</h4><p class="text-sm text-slate-500 leading-relaxed mb-4">Stay updated with crop advisories, seasonal farming tips, and agriculture-related government notices.</p><a href="<%= request.getContextPath() %>/agriculture" class="inline-flex items-center gap-1.5 text-xs font-extrabold uppercase tracking-[0.15em] text-brand-900 transition-all hover:gap-3">View Notices <i data-lucide="arrow-right" class="h-3 w-3"></i></a></div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== REGISTER CTA + STATS ===== -->
        <section class="relative overflow-hidden bg-gradient-to-br from-brand-900 to-brand-800 px-5 py-14 lg:px-12 lg:py-20">
            <div class="absolute -right-[20%] -top-1/2 h-[600px] w-[600px] rounded-full bg-brand-400/20 blur-3xl"></div>
            <div class="relative z-10 mx-auto max-w-7xl">
                <div class="grid items-center gap-16 lg:grid-cols-2">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-400 mb-3">Join Our Community</p>
                        <h2 class="text-3xl font-black tracking-tight text-white lg:text-5xl">Register Now</h2>
                        <p class="mt-4 max-w-md text-white/70 leading-relaxed">Join thousands of citizens already enjoying seamless digital governance. Create your account and access all municipal services instantly.</p>
                        <% if (!loggedIn) { %>
                        <a href="<%= request.getContextPath() %>/register" class="mt-8 inline-flex items-center gap-2.5 rounded-2xl bg-white px-9 py-4 text-[13px] font-extrabold uppercase tracking-[0.15em] text-brand-900 shadow-2xl transition-all hover:-translate-y-0.5 active:scale-95">Create Account <i data-lucide="user-plus" class="h-4 w-4"></i></a>
                        <% } %>
                    </div>
                    <div class="grid grid-cols-2 gap-6 sm:grid-cols-4 lg:grid-cols-2">
                        <div class="text-center"><p class="text-4xl font-black text-white" id="stat1">0</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Citizens</p></div>
                        <div class="text-center"><p class="text-4xl font-black text-white" id="stat2">0</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Services</p></div>
                        <div class="text-center"><p class="text-4xl font-black text-white" id="stat3">0</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Applications</p></div>
                        <div class="text-center"><p class="text-4xl font-black text-white" id="stat4">0</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Notices</p></div>
                    </div>
                </div>
            </div>
        </section>



        <!-- ===== UPCOMING EVENTS ===== -->
        <section class="px-5 pt-10 pb-14 lg:px-12 lg:pb-20">
            <div class="mx-auto max-w-7xl">
                <div class="text-center fade-up">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-3">Stay Informed</p>
                    <h2 class="text-2xl sm:text-3xl font-black tracking-tight text-slate-900 lg:text-5xl">Upcoming Events</h2>
                    <p class="mx-auto mt-4 max-w-xl text-slate-500 leading-relaxed">Important municipal events, public hearings, and community programs.</p>
                </div>
                <div class="mx-auto mt-12 grid max-w-3xl gap-4 sm:grid-cols-2">
                    <div class="group flex items-center gap-5 rounded-2xl border border-slate-100 bg-white p-5 transition-all hover:border-brand-500 hover:shadow-lg fade-up">
                        <div class="flex h-16 w-16 shrink-0 flex-col items-center justify-center rounded-2xl bg-brand-50 transition-colors group-hover:bg-brand-900"><span class="text-xl font-black leading-none text-brand-900 group-hover:text-white">15</span><span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-500 group-hover:text-white/70">Jun</span></div>
                        <div><h4 class="font-extrabold text-slate-900">Municipal Budget Hearing</h4><p class="text-sm text-slate-500">Annual public budget presentation and citizen feedback session</p></div>
                    </div>
                    <div class="group flex items-center gap-5 rounded-2xl border border-slate-100 bg-white p-5 transition-all hover:border-brand-500 hover:shadow-lg fade-up" style="transition-delay:0.05s;">
                        <div class="flex h-16 w-16 shrink-0 flex-col items-center justify-center rounded-2xl bg-brand-50 transition-colors group-hover:bg-brand-900"><span class="text-xl font-black leading-none text-brand-900 group-hover:text-white">22</span><span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-500 group-hover:text-white/70">Jun</span></div>
                        <div><h4 class="font-extrabold text-slate-900">Agriculture Workshop</h4><p class="text-sm text-slate-500">Seasonal crop advisory and modern farming techniques seminar</p></div>
                    </div>
                    <div class="group flex items-center gap-5 rounded-2xl border border-slate-100 bg-white p-5 transition-all hover:border-brand-500 hover:shadow-lg fade-up" style="transition-delay:0.1s;">
                        <div class="flex h-16 w-16 shrink-0 flex-col items-center justify-center rounded-2xl bg-brand-50 transition-colors group-hover:bg-brand-900"><span class="text-xl font-black leading-none text-brand-900 group-hover:text-white">01</span><span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-500 group-hover:text-white/70">Jul</span></div>
                        <div><h4 class="font-extrabold text-slate-900">Tax Filing Deadline</h4><p class="text-sm text-slate-500">Last date for submitting annual property and business tax returns</p></div>
                    </div>
                    <div class="group flex items-center gap-5 rounded-2xl border border-slate-100 bg-white p-5 transition-all hover:border-brand-500 hover:shadow-lg fade-up" style="transition-delay:0.15s;">
                        <div class="flex h-16 w-16 shrink-0 flex-col items-center justify-center rounded-2xl bg-brand-50 transition-colors group-hover:bg-brand-900"><span class="text-xl font-black leading-none text-brand-900 group-hover:text-white">10</span><span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-500 group-hover:text-white/70">Jul</span></div>
                        <div><h4 class="font-extrabold text-slate-900">Digital Literacy Camp</h4><p class="text-sm text-slate-500">Free training on using online municipal services for senior citizens</p></div>
                    </div>
                </div>
                <div class="mt-8 text-center">
                    <a href="<%= request.getContextPath() %>/announcements" class="inline-flex items-center gap-1.5 text-[13px] font-extrabold uppercase tracking-[0.15em] text-brand-900 transition-all hover:gap-3">View All Announcements <i data-lucide="arrow-right" class="h-4 w-4"></i></a>
                </div>
            </div>
        </section>

        <!-- ===== TESTIMONIALS ===== -->
        <section class="px-5 pb-14 lg:px-12 lg:pb-20">
            <div class="mx-auto max-w-7xl">
                <div class="text-center fade-up">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-3">Citizen Voices</p>
                    <h2 class="text-2xl sm:text-3xl font-black tracking-tight text-slate-900 lg:text-5xl">What Citizens Say</h2>
                    <p class="mx-auto mt-4 max-w-xl text-slate-500 leading-relaxed">Real experiences from real citizens using SarkarSathi services.</p>
                </div>
                <div class="mt-12 grid gap-6 md:grid-cols-3">
                    <div class="rounded-3xl border border-slate-100 bg-white p-8 transition-all hover:shadow-xl fade-up">
                        <div class="mb-3 text-brand-500"><i data-lucide="quote" class="h-6 w-6"></i></div>
                        <p class="text-[0.95rem] italic leading-relaxed text-slate-600 mb-5">"SarkarSathi made my birth certificate application so easy. I tracked the entire process online without visiting any office!"</p>
                        <div class="flex items-center gap-3"><img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100" alt="Ram Bahadur" class="h-11 w-11 rounded-xl object-cover"/><div><p class="font-extrabold text-slate-900 text-sm">Ram Bahadur</p><p class="text-xs font-semibold text-slate-400">Ward 5, Citizen</p></div></div>
                    </div>
                    <div class="rounded-3xl border border-slate-100 bg-white p-8 transition-all hover:shadow-xl fade-up" style="transition-delay:0.1s;">
                        <div class="mb-3 text-brand-500"><i data-lucide="quote" class="h-6 w-6"></i></div>
                        <p class="text-[0.95rem] italic leading-relaxed text-slate-600 mb-5">"The agriculture notices feature keeps me updated on seasonal advisories. It's like having an extension officer in my pocket."</p>
                        <div class="flex items-center gap-3"><img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=100" alt="Kamala Devi" class="h-11 w-11 rounded-xl object-cover"/><div><p class="font-extrabold text-slate-900 text-sm">Kamala Devi</p><p class="text-xs font-semibold text-slate-400">Ward 3, Farmer</p></div></div>
                    </div>
                    <div class="rounded-3xl border border-slate-100 bg-white p-8 transition-all hover:shadow-xl fade-up" style="transition-delay:0.2s;">
                        <div class="mb-3 text-brand-500"><i data-lucide="quote" class="h-6 w-6"></i></div>
                        <p class="text-[0.95rem] italic leading-relaxed text-slate-600 mb-5">"Paying municipal taxes through eSewa on this platform saved me hours. The transparency in governance is truly commendable."</p>
                        <div class="flex items-center gap-3"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=100" alt="Suresh Poudel" class="h-11 w-11 rounded-xl object-cover"/><div><p class="font-extrabold text-slate-900 text-sm">Suresh Poudel</p><p class="text-xs font-semibold text-slate-400">Ward 7, Business Owner</p></div></div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- ===== FOOTER ===== -->
    <footer class="relative overflow-hidden bg-slate-900 px-5 pb-20 pt-14 text-white lg:px-12 lg:pb-10 lg:pt-20">
        <div class="absolute left-1/4 top-0 h-96 w-96 rounded-full bg-brand-900 opacity-20 blur-[160px]"></div>
        <div class="relative z-10 mx-auto max-w-7xl">
            <div class="grid grid-cols-2 gap-8 border-b border-white/5 pb-10 sm:gap-12 lg:grid-cols-[1.5fr_1fr_1fr_1fr] lg:pb-12">
                <div class="col-span-2 lg:col-span-1">
                    <a href="<%= request.getContextPath() %>/" class="text-3xl font-black tracking-tight text-white no-underline">Sarkar<span class="text-brand-500">Sathi</span></a>
                    <p class="mt-5 max-w-xs text-sm leading-relaxed text-slate-400">Standardizing digital governance across municipal domains through secure records management and real-time public monitoring.</p>
                    <div class="mt-6 flex flex-wrap items-center gap-3">
                        <a href="https://x.com/SarkarSathi" target="_blank" rel="noreferrer" aria-label="Follow SarkarSathi on X" title="@SarkarSathi on X" class="flex h-11 w-11 items-center justify-center rounded-xl bg-white/5 text-slate-400 transition-colors hover:bg-white/10 hover:text-white"><i data-lucide="twitter" class="h-5 w-5"></i></a>
                        <a href="https://facebook.com/SarkarSathi" target="_blank" rel="noreferrer" aria-label="Follow SarkarSathi on Facebook" title="SarkarSathi on Facebook" class="flex h-11 w-11 items-center justify-center rounded-xl bg-white/5 text-slate-400 transition-colors hover:bg-white/10 hover:text-white"><i data-lucide="facebook" class="h-5 w-5"></i></a>
                        <a href="https://linkedin.com/company/sarkarsathi" target="_blank" rel="noreferrer" aria-label="Follow SarkarSathi on LinkedIn" title="SarkarSathi on LinkedIn" class="flex h-11 w-11 items-center justify-center rounded-xl bg-white/5 text-slate-400 transition-colors hover:bg-white/10 hover:text-white"><i data-lucide="linkedin" class="h-5 w-5"></i></a>
                        <span class="text-xs font-semibold tracking-wide text-slate-400">@SarkarSathi</span>
                    </div>
                </div>
                <div>
                    <h5 class="mb-6 text-[11px] font-black uppercase tracking-[0.25em] text-white/35">Quick Links</h5>
                    <a href="<%= request.getContextPath() %>/" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Home</a>
                    <a href="<%= request.getContextPath() %>/about" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">About Us</a>
                    <a href="<%= request.getContextPath() %>/contact" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Contact</a>
                    <a href="<%= request.getContextPath() %>/announcements" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Announcements</a>
                </div>
                <div>
                    <h5 class="mb-6 text-[11px] font-black uppercase tracking-[0.25em] text-white/35">Services</h5>
                    <a href="<%= request.getContextPath() %>/agriculture" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Agriculture Notices</a>
                    <a href="<%= request.getContextPath() %>/track" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Track Application</a>
                    <a href="<%= request.getContextPath() %>/login?userType=citizen" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Citizen Portal</a>
                </div>
                <div>
                    <h5 class="mb-6 text-[11px] font-black uppercase tracking-[0.25em] text-white/35">Account</h5>
                    <a href="<%= request.getContextPath() %>/login" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Login</a>
                    <a href="<%= request.getContextPath() %>/register" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Register</a>
                    <a href="<%= request.getContextPath() %>/login?userType=admin" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline transition-colors hover:text-brand-500">Admin Portal</a>
                </div>
            </div>
            <div class="flex flex-wrap items-center justify-between gap-4 pt-8">
                <p class="text-[11px] font-extrabold uppercase tracking-[0.25em] text-slate-500">&copy; 2026 SarkarSathi Foundation &bull; All Rights Reserved</p>
                <div class="flex items-center gap-2 rounded-full border border-white/5 bg-white/5 px-4 py-2">
                    <span class="inline-block h-2 w-2 animate-pulse rounded-full bg-emerald-500"></span>
                    <span class="text-[11px] font-bold text-slate-400">All Systems Operational</span>
                </div>
            </div>
        </div>
    </footer>
    </div>

    <script>
        lucide.createIcons();
        // Scroll-triggered fade-in
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); observer.unobserve(e.target); } });
        }, { threshold: 0.15 });
        document.querySelectorAll('.fade-up').forEach(el => observer.observe(el));
        // Counter animation
        function animateCounter(id, target, suffix) {
            const el = document.getElementById(id);
            if (!el) return;
            let current = 0;
            const step = Math.max(1, Math.floor(target / 60));
            const timer = setInterval(() => {
                current += step;
                if (current >= target) { current = target; clearInterval(timer); }
                el.textContent = current.toLocaleString() + (suffix || '');
            }, 25);
        }
        const statsObserver = new IntersectionObserver((entries) => {
            entries.forEach(e => {
                if (e.isIntersecting) {
                    animateCounter('stat1', 10000, '+');
                    animateCounter('stat2', 50, '+');
                    animateCounter('stat3', 4700, '+');
                    animateCounter('stat4', 120, '+');
                    statsObserver.unobserve(e.target);
                }
            });
        }, { threshold: 0.3 });
        const statEl = document.getElementById('stat1');
        if (statEl) statsObserver.observe(statEl.closest('div'));
    </script>
</body>
</html>
