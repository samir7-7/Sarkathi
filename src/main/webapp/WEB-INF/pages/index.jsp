<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>SarkarSathi - Governance for a Better Tomorrow</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            sans: ['Outfit', 'sans-serif'],
                        },
                        colors: {
                            brand: {
                                50: '#f0f5fc',
                                100: '#e1eafa',
                                400: '#60a5fa',
                                500: '#3b82f6',
                                800: '#154a91',
                                900: '#0b3d86',
                            }
                        }
                    }
                }
            }
        </script>
        <%@ include file="../includes/responsive-scripts.jsp" %>
        <style>
            body { font-family: 'Outfit', sans-serif; -webkit-tap-highlight-color: transparent; }
            .glass-morphism {
                background: rgba(255, 255, 255, 0.2);
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
            }
            @media (max-width: 1023px) {
                .safe-area-bottom { padding-bottom: env(safe-area-inset-bottom, 1.5rem); }
            }
            .animate-fade-in-up {
                animation: fadeInUp 0.5s ease-out forwards;
            }
            @keyframes fadeInUp {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
        </style>
        <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-16 lg:pb-0 overflow-x-hidden">
        <% 
            String displayName = (String) session.getAttribute("displayName"); 
            boolean loggedIn = displayName != null && !displayName.isBlank(); 
            String loginStatus = (String) request.getAttribute("login");
            if(loginStatus == null) loginStatus = request.getParameter("login");
        %>
        
        <!-- Mobile Bottom Navigation (Persistent) -->
        <nav class="fixed bottom-0 left-0 right-0 z-50 flex h-16 items-center justify-around border-t border-slate-200 bg-white/95 backdrop-blur-md px-2 lg:hidden safe-area-bottom">
            <a href="<%= request.getContextPath() %>/" class="flex flex-col items-center justify-center gap-1 text-brand-900 transition-all">
                <i data-lucide="home" class="h-5 w-5"></i>
                <span class="text-[10px] font-black uppercase tracking-tighter">Home</span>
            </a>
            <a href="<%= request.getContextPath() %>/announcements" class="flex flex-col items-center justify-center gap-1 text-slate-400 hover:text-brand-900 transition-all">
                <i data-lucide="megaphone" class="h-5 w-5"></i>
                <span class="text-[10px] font-black uppercase tracking-tighter">News</span>
            </a>
            <div class="relative -top-3">
                <a href="<%= request.getContextPath() %>/track" class="flex h-14 w-14 items-center justify-center rounded-2xl bg-brand-900 text-white shadow-lg shadow-brand-900/30">
                    <i data-lucide="search-check" class="h-6 w-6"></i>
                </a>
            </div>
            <a href="<%= request.getContextPath() %>/agriculture" class="flex flex-col items-center justify-center gap-1 text-slate-400 hover:text-brand-900 transition-all">
                <i data-lucide="leaf" class="h-5 w-5"></i>
                <span class="text-[10px] font-black uppercase tracking-tighter">Agri</span>
            </a>
            <% if (loggedIn) { %>
                <a href="<%= request.getContextPath() %>/citizen/dashboard" class="flex flex-col items-center justify-center gap-1 text-slate-400 hover:text-brand-900 transition-all">
                    <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Account</span>
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="flex flex-col items-center justify-center gap-1 text-slate-400 hover:text-brand-900 transition-all">
                    <i data-lucide="user-circle" class="h-5 w-5"></i>
                    <span class="text-[10px] font-black uppercase tracking-tighter">Login</span>
                </a>
            <% } %>
        </nav>

        <div class="relative isolate">
            <!-- Dynamic Background -->
            <div class="absolute inset-0 -z-10 bg-[radial-gradient(circle_at_top_right,rgba(59,130,246,0.08),transparent_50%),radial-gradient(circle_at_bottom_left,rgba(11,61,134,0.05),transparent_50%)]"></div>
            
            <!-- Desktop/Tablet Header -->
            <header class="px-6 py-6 lg:px-12 relative z-10 transition-all duration-300">
                <nav class="mx-auto flex max-w-7xl items-center justify-between">
                    <a href="<%= request.getContextPath() %>" class="flex items-center gap-2 text-2xl font-black tracking-tight text-brand-900">
                        Sarkar<span class="text-brand-500">Sathi</span>
                    </a>
                    
                    <div class="hidden lg:flex items-center gap-10">
                        <div class="flex items-center gap-8 text-sm font-black uppercase tracking-widest text-slate-500">
                            <a href="<%= request.getContextPath() %>/announcements" class="hover:text-brand-900 transition-colors">Announcements</a>
                            <a href="<%= request.getContextPath() %>/agriculture" class="hover:text-brand-900 transition-colors">Agriculture</a>
                            <a href="<%= request.getContextPath() %>/budget" class="hover:text-brand-900 transition-colors">Budget</a>
                            <a href="<%= request.getContextPath() %>/crop-advisory" class="hover:text-brand-900 transition-colors">Crop Advisory</a>
                        </div>
                        <div class="h-6 w-px bg-slate-200"></div>
                        <div class="flex items-center gap-4">
                            <% if (loggedIn) { %>
                                <div class="flex items-center gap-4">
                                    <span class="text-xs font-black text-slate-400 uppercase tracking-widest">Digital Citizen</span>
                                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="h-10 w-10 rounded-xl bg-brand-50 text-brand-900 flex items-center justify-center hover:bg-brand-900 hover:text-white transition-all">
                                        <i data-lucide="layout-dashboard" class="h-5 w-5"></i>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/logout" class="h-10 w-10 rounded-xl bg-slate-100 text-slate-600 flex items-center justify-center hover:bg-red-50 hover:text-red-600 transition-all">
                                        <i data-lucide="log-out" class="h-5 w-5"></i>
                                    </a>
                                </div>
                            <% } else { %>
                                <a href="<%= request.getContextPath() %>/login" class="text-xs font-black uppercase tracking-[0.2em] text-brand-900 hover:text-brand-500 transition-colors">Identity Verification</a>
                                <a href="<%= request.getContextPath() %>/register" class="rounded-xl bg-brand-900 px-8 py-3.5 text-xs font-black uppercase tracking-[0.2em] text-white shadow-xl shadow-brand-900/20 hover:bg-slate-900 transition-all active:scale-95">Enroll Now</a>
                            <% } %>
                        </div>
                    </div>

                    <!-- Mobile/Small Screen Actions -->
                    <div class="lg:hidden">
                        <% if (!loggedIn) { %>
                            <a href="<%= request.getContextPath() %>/register" class="rounded-xl bg-brand-900 px-5 py-2.5 text-[10px] font-black uppercase tracking-widest text-white shadow-lg active:scale-95 transition-transform">Enlist</a>
                        <% } else { %>
                            <span class="h-10 w-10 rounded-xl bg-brand-50 text-brand-900 flex items-center justify-center">
                                <i data-lucide="user-check" class="h-5 w-5"></i>
                            </span>
                        <% } %>
                    </div>
                </nav>
            </header>

            <main>
                <!-- Hero Section -->
                <section class="px-6 pb-20 pt-8 lg:px-12 lg:pb-32 lg:pt-20 overflow-hidden">
                    <div class="mx-auto max-w-7xl">
                        <div class="grid lg:grid-cols-[1.2fr_1fr] gap-16 items-center">
                            <div class="relative z-10 text-center lg:text-left">
                                <% if ("success".equals(loginStatus) && loggedIn) { %>
                                    <div class="mb-8 inline-flex items-center gap-3 rounded-2xl border border-emerald-100 bg-emerald-50 px-5 py-3 text-xs font-black uppercase tracking-widest text-emerald-700 shadow-sm animate-fade-in-up">
                                        <i data-lucide="waves" class="h-4 w-4 animate-pulse"></i>
                                        Identity Authenticated &bull; Welcome back
                                    </div>
                                <% } %>
                                
                                <div class="inline-flex items-center gap-3 rounded-full border border-slate-200 bg-white px-5 py-2 text-[10px] font-black uppercase tracking-[0.3em] text-brand-900 shadow-sm mx-auto lg:mx-0">
                                    <span class="relative flex h-2 w-2">
                                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-brand-400 opacity-75"></span>
                                        <span class="relative inline-flex rounded-full h-2 w-2 bg-brand-500"></span>
                                    </span>
                                    Digital Sovereignty Initiated
                                </div>

                                <h1 class="mt-8 text-5xl font-black leading-[0.95] text-slate-900 sm:text-7xl lg:text-[100px] tracking-tighter">
                                    Unified<br/>
                                    <span class="text-brand-900">Civic Flow.</span>
                                </h1>
                                
                                <p class="mt-8 text-lg font-medium text-slate-500 leading-relaxed max-w-xl mx-auto lg:mx-0">
                                    Experience the modern bridge between citizens and administration. Transparent, decentralized, and accessible.
                                </p>

                                <div class="mt-12 flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4">
                                    <% if (loggedIn) { %>
                                        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="w-full sm:w-auto flex items-center justify-center gap-3 rounded-2xl bg-brand-900 px-10 py-5 text-sm font-black uppercase tracking-widest text-white shadow-2xl shadow-brand-900/30 transition-all hover:bg-slate-900 active:scale-95">
                                            Access Portal
                                            <i data-lucide="arrow-right" class="h-4 w-4"></i>
                                        </a>
                                    <% } else { %>
                                        <a href="<%= request.getContextPath() %>/login" class="w-full sm:w-auto flex items-center justify-center gap-3 rounded-2xl bg-brand-900 px-10 py-5 text-sm font-black uppercase tracking-widest text-white shadow-2xl shadow-brand-900/30 transition-all hover:bg-slate-900 active:scale-95">
                                            Identify Self
                                            <i data-lucide="fingerprint" class="h-4 w-4"></i>
                                        </a>
                                    <% } %>
                                    <a href="<%= request.getContextPath() %>/track" class="w-full sm:w-auto flex items-center justify-center gap-3 rounded-2xl border-2 border-slate-200 bg-white px-10 py-5 text-sm font-black uppercase tracking-widest text-slate-900 hover:border-brand-900 transition-all active:scale-95">
                                        Track Progress
                                    </a>
                                </div>
                                
                                <div class="mt-16 pt-8 border-t border-slate-100 flex items-center justify-center lg:justify-start gap-8">
                                    <div>
                                        <p class="text-2xl font-black text-brand-900">10k+</p>
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Citizens</p>
                                    </div>
                                    <div class="h-8 w-px bg-slate-200"></div>
                                    <div>
                                        <p class="text-2xl font-black text-brand-900">100%</p>
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Digital</p>
                                    </div>
                                    <div class="h-8 w-px bg-slate-200"></div>
                                    <div>
                                        <p class="text-2xl font-black text-brand-900">24/7</p>
                                        <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Services</p>
                                    </div>
                                </div>
                            </div>

                            <div class="relative lg:block hidden">
                                <div class="absolute inset-0 bg-brand-900 rounded-[3rem] rotate-3 scale-95 opacity-5"></div>
                                <div class="relative rounded-[3rem] overflow-hidden shadow-[0_50px_100px_-20px_rgba(11,61,134,0.25)] border-8 border-white p-2 group transition-all duration-700 hover:-rotate-1">
                                    <img src="https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=1200" class="w-full h-[640px] object-cover rounded-[2.5rem] group-hover:scale-110 transition-transform duration-[2s]">
                                    <div class="absolute inset-0 bg-gradient-to-t from-brand-900/60 via-transparent to-transparent"></div>
                                    <div class="absolute bottom-10 left-10 right-10 p-8 glass-morphism rounded-[2.5rem] border border-white/20 translate-y-4 group-hover:translate-y-0 transition-transform">
                                        <div class="flex items-center gap-6">
                                            <div class="h-16 w-16 rounded-2xl bg-white shadow-xl flex items-center justify-center text-brand-900">
                                                <i data-lucide="shield-check" class="h-8 w-8"></i>
                                            </div>
                                            <div>
                                                <h4 class="text-xl font-black text-white tracking-tight">Standardized Governance</h4>
                                                <p class="text-sm font-medium text-blue-100/80">AES-256 Encrypted Records</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Core Modules Grid -->
                <section class="px-6 pb-32 lg:px-12">
                    <div class="mx-auto max-w-7xl">
                        <div class="flex flex-col lg:flex-row lg:items-end justify-between gap-6 mb-16 px-4">
                            <div>
                                <h2 class="text-sm font-black uppercase tracking-[0.4em] text-brand-500 mb-4">Core Operatives</h2>
                                <h3 class="text-4xl lg:text-5xl font-black text-slate-900 tracking-tighter italic">Administrative Modules.</h3>
                            </div>
                            <p class="text-slate-400 font-bold uppercase tracking-widest text-xs hidden lg:block">System Version 4.0.2-RELEASE</p>
                        </div>

                        <div class="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
                            <!-- Revenue Module -->
                            <article class="group relative bg-white rounded-[3rem] p-10 border border-slate-100 shadow-xl shadow-slate-200/50 hover:shadow-2xl hover:shadow-brand-900/10 transition-all duration-500 overflow-hidden">
                                <div class="absolute top-0 right-0 h-40 w-40 bg-brand-50 rounded-bl-[5rem] -mr-10 -mt-10 group-hover:bg-brand-900 transition-colors duration-500"></div>
                                <div class="relative z-10">
                                    <div class="h-14 w-14 rounded-2xl bg-white shadow-lg flex items-center justify-center text-brand-900 group-hover:scale-110 transition-transform">
                                        <i data-lucide="wallet" class="h-7 w-7"></i>
                                    </div>
                                    <h4 class="mt-10 text-2xl font-black text-slate-900 group-hover:text-brand-900 transition-colors tracking-tight">Financial Hub</h4>
                                    <p class="mt-4 text-slate-500 font-medium leading-relaxed group-hover:text-slate-600">Electronic tax submission, revenue tracking, and automated receipt generation.</p>
                                    <div class="mt-10 pt-8 border-t border-slate-50 flex items-center justify-between">
                                        <span class="text-[10px] font-black uppercase tracking-widest text-brand-900 group-hover:tracking-[0.2em] transition-all">Initiate Payment</span>
                                        <i data-lucide="arrow-up-right" class="h-5 w-5 text-slate-300 group-hover:text-brand-900 transition-colors"></i>
                                    </div>
                                </div>
                            </article>

                            <!-- Vital Records Module -->
                            <article class="group relative bg-brand-900 rounded-[3rem] p-10 shadow-2xl shadow-brand-900/30 transition-all duration-500 overflow-hidden">
                                <div class="absolute top-0 right-0 h-40 w-40 bg-white/5 rounded-bl-[5rem] -mr-10 -mt-10 group-hover:bg-white/10 transition-colors duration-500"></div>
                                <div class="relative z-10">
                                    <div class="h-14 w-14 rounded-2xl bg-white shadow-lg flex items-center justify-center text-brand-900 group-hover:scale-110 transition-transform">
                                        <i data-lucide="file-check-2" class="h-7 w-7"></i>
                                    </div>
                                    <h4 class="mt-10 text-2xl font-black text-white tracking-tight">Vital Registry</h4>
                                    <p class="mt-4 text-blue-100/70 font-medium leading-relaxed">Secure registration for births, marriages, and citizenship certifications.</p>
                                    <div class="mt-10 pt-8 border-t border-white/10 flex items-center justify-between">
                                        <span class="text-[10px] font-black uppercase tracking-widest text-white group-hover:tracking-[0.2em] transition-all">Record Event</span>
                                        <i data-lucide="arrow-up-right" class="h-5 w-5 text-white/30 group-hover:text-white transition-colors"></i>
                                    </div>
                                </div>
                            </article>

                            <!-- Urban Development -->
                            <article class="group relative bg-white rounded-[3rem] p-10 border border-slate-100 shadow-xl shadow-slate-200/50 hover:shadow-2xl hover:shadow-brand-900/10 transition-all duration-500 overflow-hidden">
                                <div class="absolute top-0 right-0 h-40 w-40 bg-slate-50 rounded-bl-[5rem] -mr-10 -mt-10 group-hover:bg-brand-900 transition-colors duration-500"></div>
                                <div class="relative z-10">
                                    <div class="h-14 w-14 rounded-2xl bg-white shadow-lg flex items-center justify-center text-slate-800 group-hover:scale-110 transition-transform">
                                        <i data-lucide="hard-hat" class="h-7 w-7"></i>
                                    </div>
                                    <h4 class="mt-10 text-2xl font-black text-slate-900 group-hover:text-brand-900 transition-colors tracking-tight">Urban Intel</h4>
                                    <p class="mt-4 text-slate-500 font-medium leading-relaxed">Infrastructure status, building permit data, and environmental monitoring tools.</p>
                                    <div class="mt-10 pt-8 border-t border-slate-50 flex items-center justify-between">
                                        <span class="text-[10px] font-black uppercase tracking-widest text-brand-900 group-hover:tracking-[0.2em] transition-all">Apply for Permit</span>
                                        <i data-lucide="arrow-up-right" class="h-5 w-5 text-slate-300 group-hover:text-brand-900 transition-colors"></i>
                                    </div>
                                </div>
                            </article>
                        </div>
                    </div>
                </section>
            </main>

            <!-- Global Footer -->
            <footer class="bg-slate-900 text-white px-6 py-24 lg:px-12 relative overflow-hidden">
                <div class="absolute top-0 left-1/4 w-96 h-96 bg-brand-900 rounded-full blur-[160px] opacity-20"></div>
                
                <div class="mx-auto max-w-7xl relative z-10">
                    <div class="grid lg:grid-cols-[1.5fr_1fr_1fr_1fr] gap-16 pb-20 border-b border-white/5">
                        <div>
                            <a href="#" class="text-3xl font-black tracking-tight">Sarkar<span class="text-brand-500">Sathi</span></a>
                            <p class="mt-8 text-slate-400 font-medium max-w-sm leading-relaxed text-sm">
                                Standardizing digital governance across municipal domains through encrypted records management and real-time public interest monitoring.
                            </p>
                            <div class="mt-10 flex gap-4">
                                <a href="#" class="h-12 w-12 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"><i data-lucide="twitter" class="h-5 w-5"></i></a>
                                <a href="#" class="h-12 w-12 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"><i data-lucide="linkedin" class="h-5 w-5"></i></a>
                            </div>
                        </div>

                        <div>
                            <h5 class="text-xs font-black uppercase tracking-[0.3em] mb-10 text-white/40">Nexus Hub</h5>
                            <ul class="space-y-6 text-sm font-bold text-slate-400 uppercase tracking-widest">
                                <li><a href="#" class="hover:text-brand-500 transition-colors">Core Nodes</a></li>
                                <li><a href="#" class="hover:text-brand-500 transition-colors">Public Ledger</a></li>
                            </ul>
                        </div>

                        <div>
                            <h5 class="text-xs font-black uppercase tracking-[0.3em] mb-10 text-white/40">Governance</h5>
                            <ul class="space-y-6 text-sm font-bold text-slate-400 uppercase tracking-widest">
                                <li><a href="#" class="hover:text-brand-500 transition-colors">Legal Framework</a></li>
                                <li><a href="#" class="hover:text-brand-500 transition-colors">Privacy Ops</a></li>
                            </ul>
                        </div>

                        <div>
                            <h5 class="text-xs font-black uppercase tracking-[0.3em] mb-10 text-white/40">Terminal</h5>
                            <ul class="space-y-6 text-sm font-bold text-slate-400 uppercase tracking-widest">
                                <li><a href="<%= request.getContextPath() %>/login" class="hover:text-brand-500 transition-colors">Admin Entry</a></li>
                                <li><a href="#" class="hover:text-brand-500 transition-colors">System Status</a></li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="pt-12 flex flex-col sm:flex-row justify-between items-center gap-6">
                        <p class="text-[10px] font-black uppercase tracking-[0.3em] text-slate-500">&copy; 2024 SARKARSATHI FOUNDATION &bull; ALL RIGHTS RESERVED</p>
                        <div class="flex items-center gap-2 px-4 py-2 bg-white/5 rounded-full border border-white/5">
                            <span class="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
                            <span class="text-[10px] font-black uppercase tracking-widest text-slate-400">Node: PRD-KTM-01</span>
                        </div>
                    </div>
                </div>
            </footer>
        </div>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>