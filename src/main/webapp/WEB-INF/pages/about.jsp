<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%! 
    private String teamImageUrl(jakarta.servlet.http.HttpServletRequest request, String fileName) {
        return request.getContextPath() + "/assets/team/" + fileName;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="About SarkarSathi - Learn about our mission to transform municipal governance through technology." />
    <title>About Us - SarkarSathi</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
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
        @media(max-width:1023px){.safe-area-bottom{padding-bottom:env(safe-area-inset-bottom,1.5rem)}}
    </style>
</head>
<body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-16 lg:pb-0 overflow-x-hidden">
    <%
        String displayName = (String) session.getAttribute("displayName");
        boolean loggedIn = displayName != null && !displayName.isBlank();
        String teamImageFallback = "data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 480 640'%3E%3Crect width='480' height='640' fill='%23dbeafe'/%3E%3Ccircle cx='240' cy='210' r='92' fill='%2394a3b8'/%3E%3Cpath d='M110 520c18-84 84-132 130-132s112 48 130 132' fill='%2394a3b8'/%3E%3Ctext x='50%25' y='584' text-anchor='middle' font-family='Arial,sans-serif' font-size='28' font-weight='700' fill='%230b3d86'%3ETeam Member%3C/text%3E%3C/svg%3E";
    %>

    <%@ include file="../includes/mobile-nav-public.jsp" %>

    <div class="relative isolate">
    <%@ include file="../includes/navbar-public.jsp" %>

    <main>
        <!-- ===== HERO ===== -->
        <section class="relative overflow-hidden bg-gradient-to-br from-brand-900 via-brand-800 to-[#1e5bab] px-6 py-20 lg:px-12 lg:py-28">
            <div class="absolute inset-0 opacity-[0.03]" style="background-image:url(&quot;data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23fff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E&quot;)"></div>
            <div class="relative z-10 mx-auto max-w-4xl text-center">
                <div class="inline-flex items-center gap-2 rounded-full border border-white/20 bg-white/[0.12] px-5 py-2 text-[11px] font-extrabold uppercase tracking-[0.2em] text-white/90 backdrop-blur-sm mb-6">
                    <i data-lucide="sparkles" class="h-3.5 w-3.5"></i> About SarkarSathi
                </div>
                <h1 class="text-4xl sm:text-5xl lg:text-[4.2rem] font-black leading-[1.05] tracking-tight text-white">
                    Empowering Citizens<br/>through <span class="text-brand-400">Digital Governance.</span>
                </h1>
                <p class="mx-auto mt-6 max-w-2xl text-lg leading-relaxed text-white/70">
                    SarkarSathi is more than just a platform it's a commitment to transparency, efficiency, and accessibility in public administration.
                </p>
            </div>
            <div class="absolute bottom-0 left-0 right-0 h-28 bg-gradient-to-t from-[#f8fafc] to-transparent"></div>
        </section>

        <!-- ===== WHAT WE DO (3 service cards) ===== -->
        <section class="px-6 py-20 lg:px-12">
            <div class="mx-auto max-w-7xl">
                <div class="text-center fade-up">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-3">What We Do</p>
                    <h2 class="text-3xl font-black tracking-tight text-slate-900 lg:text-5xl">Core Pillars</h2>
                    <p class="mx-auto mt-4 max-w-xl text-slate-500 leading-relaxed">Three foundational principles that drive every feature in the SarkarSathi platform.</p>
                </div>
                <div class="mt-12 grid gap-6 md:grid-cols-3">
                    <div class="group rounded-3xl border border-slate-100 bg-white p-9 text-center shadow-xl shadow-slate-200/50 transition-all duration-400 hover:-translate-y-1 hover:border-brand-500 hover:shadow-2xl hover:shadow-brand-900/10 fade-up">
                        <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 transition-colors group-hover:bg-brand-900 group-hover:text-white"><i data-lucide="file-check-2" class="h-7 w-7"></i></div>
                        <h4 class="text-lg font-extrabold text-slate-900 mb-2">Certificate Services</h4>
                        <p class="text-sm text-slate-500 leading-relaxed">Digital processing for birth, marriage, death, and citizenship certificates with real-time status tracking.</p>
                    </div>
                    <div class="group rounded-3xl border border-slate-100 bg-white p-9 text-center shadow-xl shadow-slate-200/50 transition-all duration-400 hover:-translate-y-1 hover:border-brand-500 hover:shadow-2xl hover:shadow-brand-900/10 fade-up" style="transition-delay:0.1s;">
                        <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 transition-colors group-hover:bg-brand-900 group-hover:text-white"><i data-lucide="wallet" class="h-7 w-7"></i></div>
                        <h4 class="text-lg font-extrabold text-slate-900 mb-2">Tax & Payments</h4>
                        <p class="text-sm text-slate-500 leading-relaxed">Secure online payments for property tax, business tax, and other municipal fees via eSewa integration.</p>
                    </div>
                    <div class="group rounded-3xl border border-slate-100 bg-white p-9 text-center shadow-xl shadow-slate-200/50 transition-all duration-400 hover:-translate-y-1 hover:border-brand-500 hover:shadow-2xl hover:shadow-brand-900/10 fade-up" style="transition-delay:0.2s;">
                        <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 transition-colors group-hover:bg-brand-900 group-hover:text-white"><i data-lucide="sprout" class="h-7 w-7"></i></div>
                        <h4 class="text-lg font-extrabold text-slate-900 mb-2">Agriculture Advisory</h4>
                        <p class="text-sm text-slate-500 leading-relaxed">Seasonal crop advisories, pest alerts, and modern farming technique guidance for local farmers.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== MISSION QUOTE ===== -->
        <section class="px-6 pb-20 lg:px-12">
            <div class="mx-auto max-w-7xl">
                <div class="rounded-3xl border border-slate-100 bg-white px-8 py-14 lg:px-20 shadow-md text-center fade-up">
                    <i data-lucide="quote" class="h-10 w-10 text-brand-400 mx-auto mb-6"></i>
                    <blockquote class="text-2xl lg:text-4xl font-black leading-snug tracking-tight text-slate-800 max-w-4xl mx-auto">
                        To create a seamless digital bridge between the government and its citizens,
                        ensuring that every service is <span class="text-brand-900">just a click away.</span>
                    </blockquote>
                    <p class="mt-6 text-sm font-semibold text-slate-400 uppercase tracking-widest">Our Vision Statement</p>
                </div>
            </div>
        </section>

        <!-- ===== STATS ===== -->
        <section class="relative overflow-hidden bg-gradient-to-br from-brand-900 to-brand-800 px-6 py-16 lg:px-12">
            <div class="absolute -right-[20%] -top-1/2 h-[600px] w-[600px] rounded-full bg-brand-400/20 blur-3xl"></div>
            <div class="relative z-10 mx-auto max-w-5xl">
                <div class="grid grid-cols-2 gap-6 sm:grid-cols-4">
                    <div class="text-center"><p class="text-4xl font-black text-white">10k+</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Active Citizens</p></div>
                    <div class="text-center"><p class="text-4xl font-black text-white">50+</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Services</p></div>
                    <div class="text-center"><p class="text-4xl font-black text-white">4,700+</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Applications</p></div>
                    <div class="text-center"><p class="text-4xl font-black text-white">100%</p><p class="mt-1 text-[11px] font-bold uppercase tracking-[0.2em] text-white/50">Transparency</p></div>
                </div>
            </div>
        </section>

        <!-- ===== HOW IT WORKS (Gallery-style) ===== -->
        <section class="px-6 py-20 lg:px-12">
            <div class="mx-auto max-w-7xl">
                <div class="text-center fade-up">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-3">How It Works</p>
                    <h2 class="text-3xl font-black tracking-tight text-slate-900 lg:text-5xl">Simple Steps</h2>
                    <p class="mx-auto mt-4 max-w-xl text-slate-500 leading-relaxed">From registration to receiving your documents a streamlined digital experience.</p>
                </div>
                <div class="mt-14 grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
                    <div class="relative fade-up">
                        <div class="rounded-2xl bg-brand-900 p-6 text-center">
                            <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-white text-brand-900 shadow-lg"><span class="text-xl font-black">01</span></div>
                            <h4 class="font-extrabold text-white mb-1.5">Register</h4>
                            <p class="text-xs text-white/60 leading-relaxed">Create your citizen account with basic details</p>
                        </div>
                    </div>
                    <div class="relative fade-up" style="transition-delay:0.1s;">
                        <div class="rounded-2xl bg-white border border-slate-200 p-6 text-center shadow-sm">
                            <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-brand-50 text-brand-900"><span class="text-xl font-black">02</span></div>
                            <h4 class="font-extrabold text-slate-900 mb-1.5">Apply</h4>
                            <p class="text-xs text-slate-500 leading-relaxed">Select a service and submit your application</p>
                        </div>
                    </div>
                    <div class="relative fade-up" style="transition-delay:0.2s;">
                        <div class="rounded-2xl bg-white border border-slate-200 p-6 text-center shadow-sm">
                            <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-brand-50 text-brand-900"><span class="text-xl font-black">03</span></div>
                            <h4 class="font-extrabold text-slate-900 mb-1.5">Track</h4>
                            <p class="text-xs text-slate-500 leading-relaxed">Monitor your application status in real-time</p>
                        </div>
                    </div>
                    <div class="relative fade-up" style="transition-delay:0.3s;">
                        <div class="rounded-2xl bg-white border border-slate-200 p-6 text-center shadow-sm">
                            <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-brand-50 text-brand-900"><span class="text-xl font-black">04</span></div>
                            <h4 class="font-extrabold text-slate-900 mb-1.5">Receive</h4>
                            <p class="text-xs text-slate-500 leading-relaxed">Download your approved certificates digitally</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== TEAM CAROUSEL ===== -->
        <section class="px-6 pb-20 lg:px-12">
            <div class="mx-auto max-w-7xl">
                <div class="text-center fade-up mb-14">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-3">Meet The Team</p>
                    <h2 class="text-3xl font-black tracking-tight text-slate-900 lg:text-5xl">Our Expert Members</h2>
                </div>

                <div class="relative fade-up" id="team-carousel">
                    <!-- Carousel Viewport -->
                    <div class="overflow-hidden rounded-3xl bg-white border border-slate-100 shadow-xl">
                        <div class="relative" style="min-height:380px;">
                            <!-- Slides -->
                            <!-- Slide 0: Prajwal Koirala -->
                            <div class="team-slide absolute inset-0 flex flex-col md:flex-row items-stretch transition-all duration-500" data-index="0">
                                <div class="md:w-[38%] bg-slate-100 flex-shrink-0 relative overflow-hidden">
                                    <img src="<%= teamImageUrl(request, "prajwal-koirala.jpg") %>" alt="Prajwal Koirala" loading="lazy" decoding="async" onerror="this.onerror=null;this.src='<%= teamImageFallback %>';" class="h-56 md:h-full w-full object-cover object-top"/>
                                    <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/50 to-transparent px-4 py-3 md:hidden">
                                        <p class="text-white text-sm font-black">Prajwal Koirala</p>
                                        <p class="text-white/70 text-[10px] font-semibold uppercase tracking-wider">Full Stack Developer · Member 01</p>
                                    </div>
                                </div>
                                <div class="flex-1 flex flex-col justify-center px-8 py-8 md:px-12 md:py-10">
                                    <h3 class="text-2xl lg:text-3xl font-black text-slate-900 tracking-tight">Prajwal Koirala, <span class="font-medium text-slate-500 text-xl lg:text-2xl">Full Stack Developer</span></h3>
                                    <p class="mt-4 text-slate-500 leading-relaxed">Prajwal leads end-to-end development of the SarkarSathi platform architecting the Java servlet backend, designing the database schema, and crafting the responsive Tailwind-based UI that powers the citizen and admin portals.</p>
                                    <div class="mt-5 flex flex-wrap gap-2">
                                        <span class="rounded-full bg-brand-50 border border-brand-200 px-3 py-1 text-[11px] font-bold text-brand-800">Java</span>
                                        <span class="rounded-full bg-brand-50 border border-brand-200 px-3 py-1 text-[11px] font-bold text-brand-800">JSP / Servlet</span>
                                        <span class="rounded-full bg-brand-50 border border-brand-200 px-3 py-1 text-[11px] font-bold text-brand-800">Tailwind CSS</span>
                                        <span class="rounded-full bg-brand-50 border border-brand-200 px-3 py-1 text-[11px] font-bold text-brand-800">MySQL</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Slide 1: Minkumar Pandey -->
                            <div class="team-slide absolute inset-0 flex flex-col md:flex-row items-stretch transition-all duration-500 opacity-0 pointer-events-none" data-index="1">
                                <div class="md:w-[38%] bg-slate-100 flex-shrink-0 relative overflow-hidden">
                                    <img src="<%= teamImageUrl(request, "minkumar-pandey.png") %>" alt="Minkumar Pandey" loading="lazy" decoding="async" onerror="this.onerror=null;this.src='<%= teamImageFallback %>';" class="h-56 md:h-full w-full object-cover object-top"/>
                                    <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/50 to-transparent px-4 py-3 md:hidden">
                                        <p class="text-white text-sm font-black">Minkumar Pandey</p>
                                        <p class="text-white/70 text-[10px] font-semibold uppercase tracking-wider">Backend Developer · Member 02</p>
                                    </div>
                                </div>
                                <div class="flex-1 flex flex-col justify-center px-8 py-8 md:px-12 md:py-10">
                                    <h3 class="text-2xl lg:text-3xl font-black text-slate-900 tracking-tight">Minkumar Pandey, <span class="font-medium text-slate-500 text-xl lg:text-2xl">Backend Developer</span></h3>
                                    <p class="mt-4 text-slate-500 leading-relaxed">Minkumar is responsible for server-side logic, RESTful API design, and database optimisation. He ensures that citizen data is handled securely and that the application processing pipeline performs reliably under load.</p>
                                    <div class="mt-5 flex flex-wrap gap-2">
                                        <span class="rounded-full bg-slate-100 border border-slate-200 px-3 py-1 text-[11px] font-bold text-slate-700">Java Servlets</span>
                                        <span class="rounded-full bg-slate-100 border border-slate-200 px-3 py-1 text-[11px] font-bold text-slate-700">REST APIs</span>
                                        <span class="rounded-full bg-slate-100 border border-slate-200 px-3 py-1 text-[11px] font-bold text-slate-700">SQL</span>
                                        <span class="rounded-full bg-slate-100 border border-slate-200 px-3 py-1 text-[11px] font-bold text-slate-700">Security</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Slide 2: Nabin Adhikari -->
                            <div class="team-slide absolute inset-0 flex flex-col md:flex-row items-stretch transition-all duration-500 opacity-0 pointer-events-none" data-index="2">
                                <div class="md:w-[38%] bg-slate-100 flex-shrink-0 relative overflow-hidden">
                                    <img src="<%= teamImageUrl(request, "nabin-adhikari.png") %>" alt="Nabin Adhikari" loading="lazy" decoding="async" onerror="this.onerror=null;this.src='<%= teamImageFallback %>';" class="h-56 md:h-full w-full object-cover object-top"/>
                                    <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/50 to-transparent px-4 py-3 md:hidden">
                                        <p class="text-white text-sm font-black">Nabin Adhikari</p>
                                        <p class="text-white/70 text-[10px] font-semibold uppercase tracking-wider">Frontend Developer · Member 03</p>
                                    </div>
                                </div>
                                <div class="flex-1 flex flex-col justify-center px-8 py-8 md:px-12 md:py-10">
                                    <h3 class="text-2xl lg:text-3xl font-black text-slate-900 tracking-tight">Nabin Adhikari, <span class="font-medium text-slate-500 text-xl lg:text-2xl">Frontend Developer</span></h3>
                                    <p class="mt-4 text-slate-500 leading-relaxed">Nabin crafts the citizen-facing interface of SarkarSathitranslating design specifications into polished, accessible JSP pages. His work ensures citizens have an intuitive experience when applying for and tracking their documents.</p>
                                    <div class="mt-5 flex flex-wrap gap-2">
                                        <span class="rounded-full bg-indigo-50 border border-indigo-200 px-3 py-1 text-[11px] font-bold text-indigo-800">HTML / CSS</span>
                                        <span class="rounded-full bg-indigo-50 border border-indigo-200 px-3 py-1 text-[11px] font-bold text-indigo-800">JavaScript</span>
                                        <span class="rounded-full bg-indigo-50 border border-indigo-200 px-3 py-1 text-[11px] font-bold text-indigo-800">Tailwind CSS</span>
                                        <span class="rounded-full bg-indigo-50 border border-indigo-200 px-3 py-1 text-[11px] font-bold text-indigo-800">Responsive UI</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Slide 3: Rhythm Shrestha -->
                            <div class="team-slide absolute inset-0 flex flex-col md:flex-row items-stretch transition-all duration-500 opacity-0 pointer-events-none" data-index="3">
                                <div class="md:w-[38%] bg-slate-100 flex-shrink-0 relative overflow-hidden">
                                    <img src="<%= teamImageUrl(request, "rhythm-shrestha.png") %>" alt="Rhythm Shrestha" loading="lazy" decoding="async" onerror="this.onerror=null;this.src='<%= teamImageFallback %>';" class="h-56 md:h-full w-full object-cover object-center"/>
                                    <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/50 to-transparent px-4 py-3 md:hidden">
                                        <p class="text-white text-sm font-black">Rhythm Shrestha</p>
                                        <p class="text-white/70 text-[10px] font-semibold uppercase tracking-wider">QA Engineer · Member 04</p>
                                    </div>
                                </div>
                                <div class="flex-1 flex flex-col justify-center px-8 py-8 md:px-12 md:py-10">
                                    <h3 class="text-2xl lg:text-3xl font-black text-slate-900 tracking-tight">Rhythm Shrestha, <span class="font-medium text-slate-500 text-xl lg:text-2xl">QA Engineer</span></h3>
                                    <p class="mt-4 text-slate-500 leading-relaxed">Rhythm ensures the quality and correctness of every SarkarSathi feature through rigorous test plans, regression cycles, and edge-case analysis. His disciplined approach prevents critical bugs from reaching citizens.</p>
                                    <div class="mt-5 flex flex-wrap gap-2">
                                        <span class="rounded-full bg-emerald-50 border border-emerald-200 px-3 py-1 text-[11px] font-bold text-emerald-800">Test Plans</span>
                                        <span class="rounded-full bg-emerald-50 border border-emerald-200 px-3 py-1 text-[11px] font-bold text-emerald-800">Regression Testing</span>
                                        <span class="rounded-full bg-emerald-50 border border-emerald-200 px-3 py-1 text-[11px] font-bold text-emerald-800">Bug Tracking</span>
                                        <span class="rounded-full bg-emerald-50 border border-emerald-200 px-3 py-1 text-[11px] font-bold text-emerald-800">Automation</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Slide 4: Samir Nepal -->
                            <div class="team-slide absolute inset-0 flex flex-col md:flex-row items-stretch transition-all duration-500 opacity-0 pointer-events-none" data-index="4">
                                <div class="md:w-[38%] bg-slate-100 flex-shrink-0 relative overflow-hidden">
                                    <img src="<%= teamImageUrl(request, "samir-nepal.png") %>" alt="Samir Nepal" loading="lazy" decoding="async" onerror="this.onerror=null;this.src='<%= teamImageFallback %>';" class="h-56 md:h-full w-full object-cover object-top"/>
                                    <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/50 to-transparent px-4 py-3 md:hidden">
                                        <p class="text-white text-sm font-black">Samir Nepal</p>
                                        <p class="text-white/70 text-[10px] font-semibold uppercase tracking-wider">Tester · Member 05</p>
                                    </div>
                                </div>
                                <div class="flex-1 flex flex-col justify-center px-8 py-8 md:px-12 md:py-10">
                                    <h3 class="text-2xl lg:text-3xl font-black text-slate-900 tracking-tight">Samir Nepal, <span class="font-medium text-slate-500 text-xl lg:text-2xl">Tester</span></h3>
                                    <p class="mt-4 text-slate-500 leading-relaxed">Samir conducts hands-on functional and user-acceptance testing across all citizen workflows from registration and application submission to payment verification and certificate download  ensuring a seamless experience.</p>
                                    <div class="mt-5 flex flex-wrap gap-2">
                                        <span class="rounded-full bg-amber-50 border border-amber-200 px-3 py-1 text-[11px] font-bold text-amber-800">Functional Testing</span>
                                        <span class="rounded-full bg-amber-50 border border-amber-200 px-3 py-1 text-[11px] font-bold text-amber-800">UAT</span>
                                        <span class="rounded-full bg-amber-50 border border-amber-200 px-3 py-1 text-[11px] font-bold text-amber-800">Manual Testing</span>
                                        <span class="rounded-full bg-amber-50 border border-amber-200 px-3 py-1 text-[11px] font-bold text-amber-800">Defect Reports</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Navigation Arrows -->
                    <button id="team-prev" class="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-5 h-12 w-12 rounded-full border-2 border-brand-500 bg-white text-brand-500 flex items-center justify-center shadow-lg hover:bg-brand-500 hover:text-white transition-all z-10">
                        <i data-lucide="chevron-left" class="h-5 w-5"></i>
                    </button>
                    <button id="team-next" class="absolute right-0 top-1/2 -translate-y-1/2 translate-x-5 h-12 w-12 rounded-full border-2 border-brand-500 bg-white text-brand-500 flex items-center justify-center shadow-lg hover:bg-brand-500 hover:text-white transition-all z-10">
                        <i data-lucide="chevron-right" class="h-5 w-5"></i>
                    </button>

                    <!-- Dots -->
                    <div class="flex items-center justify-center gap-2 mt-6" id="team-dots">
                        <span class="team-dot h-2.5 w-8 rounded-full bg-brand-900 cursor-pointer transition-all" data-index="0"></span>
                        <span class="team-dot h-2.5 w-2.5 rounded-full bg-slate-300 cursor-pointer transition-all hover:bg-slate-400" data-index="1"></span>
                        <span class="team-dot h-2.5 w-2.5 rounded-full bg-slate-300 cursor-pointer transition-all hover:bg-slate-400" data-index="2"></span>
                        <span class="team-dot h-2.5 w-2.5 rounded-full bg-slate-300 cursor-pointer transition-all hover:bg-slate-400" data-index="3"></span>
                        <span class="team-dot h-2.5 w-2.5 rounded-full bg-slate-300 cursor-pointer transition-all hover:bg-slate-400" data-index="4"></span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ===== CTA ===== -->
        <section class="relative overflow-hidden bg-gradient-to-br from-brand-900 via-brand-800 to-[#1e5bab] px-6 py-20 lg:px-12">
            <div class="absolute -right-[15%] -top-1/3 h-[500px] w-[500px] rounded-full bg-brand-400/20 blur-3xl"></div>
            <div class="absolute -left-[10%] bottom-0 h-[300px] w-[300px] rounded-full bg-brand-400/10 blur-3xl"></div>
            <div class="relative z-10 mx-auto max-w-7xl text-center fade-up">
                <h2 class="text-3xl lg:text-5xl font-black text-white tracking-tight mb-4">Ready to Get Started?</h2>
                <p class="text-white/70 max-w-xl mx-auto mb-10 text-lg leading-relaxed">Join thousands of citizens already using SarkarSathi for seamless municipal services.</p>
                <div class="flex flex-wrap justify-center gap-4">
                    <% if (!loggedIn) { %>
                    <a href="<%= request.getContextPath() %>/register" class="inline-flex items-center gap-2.5 rounded-2xl bg-white px-10 py-4 text-[13px] font-extrabold uppercase tracking-[0.15em] text-brand-900 shadow-2xl transition-all hover:-translate-y-0.5 active:scale-95">Create Account <i data-lucide="user-plus" class="h-4 w-4"></i></a>
                    <% } %>
                    <a href="<%= request.getContextPath() %>/contact" class="inline-flex items-center gap-2.5 rounded-2xl border-2 border-white/30 px-10 py-4 text-[13px] font-extrabold uppercase tracking-[0.15em] text-white transition-all hover:border-white hover:bg-white/10">Contact Us</a>
                </div>
            </div>
        </section>
    </main>

    <!-- ===== FOOTER ===== -->
    <footer class="relative overflow-hidden bg-slate-900 px-6 pb-10 pt-20 text-white lg:px-12">
        <div class="absolute left-1/4 top-0 h-96 w-96 rounded-full bg-brand-900 opacity-20 blur-[160px]"></div>
        <div class="relative z-10 mx-auto max-w-7xl">
            <div class="grid gap-12 border-b border-white/5 pb-12 lg:grid-cols-[1.5fr_1fr_1fr_1fr]">
                <div>
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
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); observer.unobserve(e.target); } });
        }, { threshold: 0.15 });
        document.querySelectorAll('.fade-up').forEach(el => observer.observe(el));

        /* ── Team Carousel ── */
        (function(){
            const slides = document.querySelectorAll('.team-slide');
            const dots = document.querySelectorAll('.team-dot');
            const prevBtn = document.getElementById('team-prev');
            const nextBtn = document.getElementById('team-next');
            if (!slides.length) return;
            let current = 0;
            let autoTimer;

            function goTo(idx) {
                slides.forEach(s => { s.classList.add('opacity-0','pointer-events-none'); s.classList.remove('opacity-100'); });
                dots.forEach(d => { d.className = 'team-dot h-2.5 w-2.5 rounded-full bg-slate-300 cursor-pointer transition-all hover:bg-slate-400'; });
                slides[idx].classList.remove('opacity-0','pointer-events-none');
                slides[idx].classList.add('opacity-100');
                dots[idx].className = 'team-dot h-2.5 w-8 rounded-full bg-brand-900 cursor-pointer transition-all';
                current = idx;
            }

            function next() { goTo((current + 1) % slides.length); }
            function prev() { goTo((current - 1 + slides.length) % slides.length); }

            prevBtn.addEventListener('click', () => { prev(); resetAuto(); });
            nextBtn.addEventListener('click', () => { next(); resetAuto(); });
            dots.forEach(d => d.addEventListener('click', () => { goTo(+d.dataset.index); resetAuto(); }));

            function resetAuto() { clearInterval(autoTimer); autoTimer = setInterval(next, 5000); }
            resetAuto();

            const carousel = document.getElementById('team-carousel');
            carousel.addEventListener('mouseenter', () => clearInterval(autoTimer));
            carousel.addEventListener('mouseleave', resetAuto);
        })();
    </script>
</body>
</html>
