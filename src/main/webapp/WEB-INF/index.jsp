<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SarkarSathi - Governance for a Better Tomorrow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
                            500: '#3b82f6',
                            800: '#154a91',
                            900: '#0b3d86',
                        }
                    }
                }
            }
        }
    </script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <%@ include file="includes/responsive-scripts.jsp" %>
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>
<body class="bg-[#fafafc] text-slate-800">
    <% String displayName = (String) session.getAttribute("displayName"); %>
    <% boolean loggedIn = displayName != null && !displayName.isBlank(); %>
    <% String login = request.getParameter("login"); %>
    <div class="relative isolate overflow-hidden">
        <!-- Subtle background gradients -->
        <div class="absolute inset-0 -z-10 bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-blue-100/50 via-white to-white"></div>
        <div class="absolute -left-40 top-20 -z-10 h-96 w-96 rounded-full bg-blue-100/40 blur-3xl"></div>

        <header class="px-6 pt-6 lg:px-12">
            <nav class="mx-auto flex max-w-7xl items-center justify-between py-2">
                <a href="<%= request.getContextPath() %>" class="text-2xl font-bold tracking-tight text-brand-900">Sarkar<span class="text-brand-500">Sathi</span></a>

                <div class="hidden items-center gap-10 text-[15px] font-medium text-slate-600 lg:flex">
                    <a href="<%= request.getContextPath() %>/announcements" class="transition hover:text-brand-900">Announcements</a>
                    <a href="<%= request.getContextPath() %>/agriculture" class="transition hover:text-brand-900">Agriculture</a>
                    <a href="<%= request.getContextPath() %>/budget" class="transition hover:text-brand-900">Budget</a>
                    <a href="<%= request.getContextPath() %>/crop-advisory" class="transition hover:text-brand-900">Crop Advisory</a>
                    <a href="<%= request.getContextPath() %>/track" class="transition hover:text-brand-900">Track</a>
                </div>

                <div class="flex items-center gap-4 sm:gap-6">
                    <% if (loggedIn) { %>
                        <a href="<%= request.getContextPath() %>/citizen/dashboard" class="hidden text-[15px] font-semibold text-brand-900 sm:inline-block">Welcome, <%= displayName %></a>
                        <a href="<%= request.getContextPath() %>/logout" class="inline-flex items-center rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-600 transition hover:bg-slate-50 sm:px-5">Logout</a>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/login" class="hidden text-[15px] font-semibold text-brand-900 transition hover:text-brand-500 sm:inline-block">Login</a>
                        <a href="<%= request.getContextPath() %>/register" class="inline-flex items-center rounded-xl bg-brand-900 px-5 py-2.5 text-[15px] font-semibold text-white shadow-sm transition hover:bg-brand-800 sm:px-6">Register</a>
                    <% } %>
                    <button onclick="toggleMobileMenu()" class="inline-flex items-center justify-center p-2 text-slate-600 transition hover:bg-slate-100 hover:text-brand-900 lg:hidden">
                        <i data-lucide="menu" class="h-6 w-6"></i>
                    </button>
                </div>
            </nav>

            <!-- Mobile Menu -->
            <div id="mobile-menu" class="hidden border-t border-slate-100 py-6 space-y-4 lg:hidden">
                <a href="<%= request.getContextPath() %>/announcements" class="block text-base font-medium text-slate-600 hover:text-brand-900">Announcements</a>
                <a href="<%= request.getContextPath() %>/agriculture" class="block text-base font-medium text-slate-600 hover:text-brand-900">Agriculture</a>
                <a href="<%= request.getContextPath() %>/budget" class="block text-base font-medium text-slate-600 hover:text-brand-900">Budget</a>
                <a href="<%= request.getContextPath() %>/crop-advisory" class="block text-base font-medium text-slate-600 hover:text-brand-900">Crop Advisory</a>
                <a href="<%= request.getContextPath() %>/track" class="block text-base font-medium text-slate-600 hover:text-brand-900">Track</a>
                <% if (!loggedIn) { %>
                    <a href="<%= request.getContextPath() %>/login" class="block text-base font-medium text-slate-600 hover:text-brand-900">Login</a>
                <% } %>
            </div>
        </header>

        <main>
            <section class="px-6 pb-16 pt-16 lg:px-12 lg:pb-24 lg:pt-20">
                <div class="mx-auto grid max-w-7xl items-center gap-16 lg:grid-cols-[1fr_1fr]">
                    <div class="max-w-2xl">
                        <% if ("success".equals(login) && loggedIn) { %>
                            <div class="mb-6 inline-flex items-center gap-2 rounded-full border border-green-200 bg-green-50 px-4 py-2 text-xs font-semibold uppercase tracking-wider text-green-800 shadow-sm">
                                Citizen login successful
                            </div>
                        <% } %>
                        <div class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-brand-900 shadow-sm">
                            <span class="h-1.5 w-1.5 rounded-full bg-green-500"></span>
                            Official Portal of Nepal Municipality
                        </div>

                        <h1 class="mt-8 text-5xl font-bold leading-[1.1] text-slate-900 sm:text-6xl lg:text-[64px]">
                            Governance for a<br>
                            <span class="text-brand-900 italic">Better Tomorrow.</span>
                        </h1>

                        <p class="mt-6 text-lg leading-relaxed text-slate-600">
                            Experience a seamless bridge between citizens and administration. Access public services, track progress, and contribute to your community's growth effortlessly.
                        </p>

                        <div class="mt-10 flex flex-col gap-4 sm:flex-row">
                            <% if (loggedIn) { %>
                            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-900 px-8 py-4 text-base font-semibold text-white shadow-lg shadow-brand-900/20 transition hover:bg-brand-800">
                                Go to Dashboard
                                <i data-lucide="arrow-right" class="h-4 w-4"></i>
                            </a>
                            <% } else { %>
                            <a href="<%= request.getContextPath() %>/register" class="inline-flex items-center justify-center gap-2 rounded-xl bg-brand-900 px-8 py-4 text-base font-semibold text-white shadow-lg shadow-brand-900/20 transition hover:bg-brand-800">
                                Get Started
                                <i data-lucide="arrow-right" class="h-4 w-4"></i>
                            </a>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/track" class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-8 py-4 text-base font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50">
                                Track Application
                            </a>
                        </div>
                    </div>

                    <div class="relative">
                        <div class="absolute -right-10 -top-10 h-64 w-64 rounded-full border border-slate-200 bg-transparent"></div>
                        <div class="absolute -right-4 -top-4 h-64 w-64 rounded-full border border-slate-200 bg-transparent"></div>
                        
                        <div class="relative overflow-hidden rounded-[2rem] bg-white p-2 shadow-2xl shadow-slate-200">
                            <img class="h-[500px] w-full rounded-[1.5rem] object-cover" src="https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=800&auto=format&fit=crop" alt="Himalayas">

                            <div class="absolute -left-6 bottom-12 rounded-2xl border border-white/40 bg-white/60 p-4 pr-12 shadow-xl backdrop-blur-md">
                                <div class="flex items-start gap-4">
                                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-green-50 text-green-600 shadow-sm">
                                        <i data-lucide="shield-check" class="h-5 w-5"></i>
                                    </div>
                                    <div>
                                        <h4 class="text-[15px] font-bold text-slate-900">99.9% Transparent</h4>
                                        <p class="mt-1 text-xs font-medium text-slate-600">Blocks chain-verified records ensure<br>complete administrative honesty.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="px-6 lg:px-12">
                <div class="mx-auto max-w-7xl">
                    <div class="flex flex-col gap-4 rounded-xl border border-red-100 bg-red-50/50 px-6 py-4 sm:flex-row sm:items-center sm:justify-between">
                        <div class="flex items-center gap-4">
                            <span class="inline-flex rounded-md bg-red-100 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-red-800">Latest</span>
                            <p class="text-[15px] font-medium text-slate-700">Land ownership re-verification starts from next Sunday. Please bring original deeds.</p>
                        </div>
                        <a href="<%= request.getContextPath() %>/announcements" class="shrink-0 text-sm font-bold text-brand-900 transition hover:text-brand-800">
                            View All Announcements &rsaquo;
                        </a>
                    </div>
                </div>
            </section>

            <section class="px-6 py-20 lg:px-12 lg:py-28">
                <div class="mx-auto max-w-7xl text-center">
                    <h2 class="text-3xl font-bold text-slate-900 sm:text-4xl">Empowerment in 3 Steps</h2>
                    <p class="mt-4 text-base text-slate-600">Digitizing your civic duties should be effortless and natural.</p>

                    <div class="mt-16 grid gap-8 md:grid-cols-3 relative">
                        <!-- Connecting line for desktop -->
                        <div class="hidden md:block absolute top-[28px] left-[16%] right-[16%] h-[1px] bg-slate-200 -z-10"></div>

                        <div class="flex flex-col items-center">
                            <div class="flex h-14 w-14 items-center justify-center rounded-full bg-white shadow-md shadow-slate-200/50 text-slate-800">
                                <i data-lucide="user-plus" class="h-6 w-6"></i>
                            </div>
                            <h3 class="mt-6 text-xl font-bold text-slate-900">Create Profile</h3>
                            <p class="mt-3 max-w-xs text-sm leading-relaxed text-slate-500">Register with your citizenship ID to access a personalized civic dashboard.</p>
                        </div>

                        <div class="flex flex-col items-center">
                            <div class="flex h-14 w-14 items-center justify-center rounded-full bg-white shadow-md shadow-slate-200/50 text-slate-800">
                                <i data-lucide="mouse-pointer-click" class="h-6 w-6"></i>
                            </div>
                            <h3 class="mt-6 text-xl font-bold text-slate-900">Select Service</h3>
                            <p class="mt-3 max-w-xs text-sm leading-relaxed text-slate-500">Browse through tax payments, registrations, or building permits effortlessly.</p>
                        </div>

                        <div class="flex flex-col items-center">
                            <div class="flex h-14 w-14 items-center justify-center rounded-full bg-white shadow-md shadow-slate-200/50 text-slate-800">
                                <i data-lucide="check-circle-2" class="h-6 w-6"></i>
                            </div>
                            <h3 class="mt-6 text-xl font-bold text-slate-900">Get Results</h3>
                            <p class="mt-3 max-w-xs text-sm leading-relaxed text-slate-500">Track your applications in real-time and download certified documents digitally.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="px-6 pb-20 lg:px-12 lg:pb-28">
                <div class="mx-auto max-w-7xl">
                    <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between mb-12">
                        <div>
                            <h2 class="text-3xl font-bold text-slate-900 sm:text-4xl">Service Ecosystem</h2>
                            <p class="mt-3 text-base text-slate-600">Integrated solutions designed for your everyday civic needs.</p>
                        </div>
                        <a href="#" class="text-sm font-bold text-brand-900 transition hover:text-brand-800">Explore Full Directory</a>
                    </div>

                    <div class="grid gap-6 md:grid-cols-3">
                        <article class="flex flex-col rounded-3xl border border-slate-100 bg-white p-8 shadow-sm transition hover:shadow-md">
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-50 text-brand-900">
                                <i data-lucide="home" class="h-6 w-6"></i>
                            </div>
                            <h3 class="mt-8 text-xl font-bold text-slate-900">Property Tax</h3>
                            <p class="mt-3 flex-1 text-sm leading-relaxed text-slate-500">Calculate, file, and pay your municipal property taxes securely online. View your payment history and download receipts.</p>
                            <a href="<%= request.getContextPath() %>/citizen/payments" class="mt-8 inline-flex items-center gap-2 text-sm font-bold text-brand-900 transition hover:text-brand-800">
                                Pay Now
                                <i data-lucide="arrow-right" class="h-4 w-4"></i>
                            </a>
                        </article>

                        <article class="flex flex-col rounded-3xl bg-brand-900 p-8 shadow-lg shadow-brand-900/20 text-white">
                            <div class="flex items-start justify-between gap-4">
                                <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-white/10 text-white">
                                    <i data-lucide="clipboard-list" class="h-6 w-6"></i>
                                </div>
                                <span class="rounded-full bg-green-500 px-3 py-1 text-[10px] font-bold uppercase tracking-wider text-white">Essential</span>
                            </div>
                            <h3 class="mt-8 text-xl font-bold">Vital Registration</h3>
                            <p class="mt-3 flex-1 text-sm leading-relaxed text-white/80">Register births, deaths, marriages, and other vital events. Request certified copies of certificates digitally.</p>
                            <a href="<%= request.getContextPath() %>/citizen/apply" class="mt-8 inline-flex items-center gap-2 text-sm font-bold text-white transition hover:text-white/80">
                                Register Event
                                <i data-lucide="arrow-right" class="h-4 w-4"></i>
                            </a>
                        </article>

                        <article class="flex flex-col rounded-3xl border border-slate-100 bg-white p-8 shadow-sm transition hover:shadow-md">
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-50 text-brand-900">
                                <i data-lucide="hard-hat" class="h-6 w-6"></i>
                            </div>
                            <h3 class="mt-8 text-xl font-bold text-slate-900">Building Permits</h3>
                            <p class="mt-3 flex-1 text-sm leading-relaxed text-slate-500">Submit building plans, track approval status, and request inspections through our streamlined permit portal.</p>
                            <a href="<%= request.getContextPath() %>/citizen/apply" class="mt-8 inline-flex items-center gap-2 text-sm font-bold text-brand-900 transition hover:text-brand-800">
                                Apply for Permit
                                <i data-lucide="arrow-right" class="h-4 w-4"></i>
                            </a>
                        </article>
                    </div>
                </div>
            </section>
        </main>

        <footer class="border-t border-slate-200 bg-white px-6 py-16 lg:px-12">
            <div class="mx-auto grid max-w-7xl gap-12 lg:grid-cols-[1.5fr_1fr_1fr_1fr]">
                <div>
                    <a href="#" class="text-2xl font-bold tracking-tight text-brand-900">Sarkar<span class="text-brand-500">Sathi</span></a>
                    <p class="mt-4 max-w-xs text-xs leading-relaxed text-slate-500">Building the foundation of digital Nepal through transparent and accessible civic engagement.</p>
                    <div class="mt-6 flex items-center gap-3">
                        <a href="#" class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-slate-600 transition hover:bg-slate-200">
                            <i data-lucide="share-2" class="h-4 w-4"></i>
                        </a>
                        <a href="#" class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-slate-600 transition hover:bg-slate-200">
                            <i data-lucide="mail" class="h-4 w-4"></i>
                        </a>
                    </div>
                </div>

                <div>
                    <h4 class="text-xs font-bold uppercase tracking-wider text-slate-900">Legal</h4>
                    <ul class="mt-6 space-y-4 text-xs font-medium text-slate-500">
                        <li><a href="#" class="transition hover:text-brand-900">Privacy Policy</a></li>
                        <li><a href="#" class="transition hover:text-brand-900">Terms of Service</a></li>
                        <li><a href="#" class="transition hover:text-brand-900">Accessibility</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="text-xs font-bold uppercase tracking-wider text-slate-900">Support</h4>
                    <ul class="mt-6 space-y-4 text-xs font-medium text-slate-500">
                        <li><a href="#" class="transition hover:text-brand-900">Grievance Redressal</a></li>
                        <li><a href="#" class="transition hover:text-brand-900">Directory</a></li>
                        <li><a href="#" class="transition hover:text-brand-900">Citizen Charter</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="text-xs font-bold uppercase tracking-wider text-slate-900">Connect</h4>
                    <ul class="mt-6 space-y-4 text-xs font-medium text-slate-500">
                        <li>Central Ward Office,</li>
                        <li>Kathmandu, Nepal</li>
                        <li><a href="tel:+97714200000" class="font-bold text-brand-900 transition hover:text-brand-800">+977 1 4200000</a></li>
                    </ul>
                </div>
            </div>

            <div class="mx-auto mt-16 flex max-w-7xl flex-col gap-4 border-t border-slate-100 pt-8 text-xs font-medium text-slate-400 sm:flex-row sm:items-center sm:justify-between">
                <p>&copy; 2024 SarkarSathi Municipal Council. All Rights Reserved.</p>
                <p>Version 2.4.0 (Lumbini)</p>
            </div>
        </footer>
    </div>

    <script>
      lucide.createIcons();
    </script>
  </body>
</html>