<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content="Contact SarkarSathi for municipal support and citizen service help."/>
    <title>Contact Us - SarkarSathi</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config={theme:{extend:{fontFamily:{sans:['Outfit','sans-serif']},colors:{brand:{50:'#f0f5fc',100:'#e1eafa',400:'#60a5fa',500:'#3b82f6',800:'#154a91',900:'#0b3d86'}}}}}
    </script>
    <%@ include file="../includes/responsive-scripts.jsp" %>
    <%@ include file="../includes/lucide-icons.jsp" %>
    <style>
        html{zoom:0.86}body{font-family:'Outfit',sans-serif}
        .fade-up{opacity:0;transform:translateY(24px);transition:all .6s ease}
        .fade-up.visible{opacity:1;transform:translateY(0)}
    </style>
</head>
<body class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-16 lg:pb-0 overflow-x-hidden">
    <% String displayName = (String) session.getAttribute("displayName"); boolean loggedIn = displayName != null && !displayName.isBlank(); %>

    <%@ include file="../includes/mobile-nav-public.jsp" %>

    <div class="relative isolate">
    <%@ include file="../includes/navbar-public.jsp" %>

    <main>
        <!-- ===== HERO ===== -->
        <section class="relative overflow-hidden bg-gradient-to-br from-brand-900 via-brand-800 to-[#1e5bab] px-5 py-14 lg:px-12 lg:py-24">
            <div class="absolute inset-0 opacity-[0.03]" style="background-image:url(&quot;data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23fff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E&quot;)"></div>
            <div class="mx-auto max-w-7xl text-center relative z-10">
                <div class="inline-flex items-center gap-2 rounded-full border border-white/20 bg-white/[0.15] px-5 py-2 text-[11px] font-extrabold uppercase tracking-[0.2em] text-white/90 backdrop-blur-sm mb-5"><i data-lucide="mail" class="h-3.5 w-3.5"></i> Get In Touch</div>
                <h1 class="text-3xl sm:text-4xl lg:text-6xl font-black tracking-tight text-white">Contact Us</h1>
                <p class="mx-auto mt-4 max-w-2xl text-sm sm:text-lg leading-relaxed text-white/70">SarkarSathi is ready to provide the right solution for citizens, municipal offices, and public service support needs.</p>
            </div>
            <div class="absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-[#f8fafc] to-transparent"></div>
        </section>

        <!-- ===== CONTACT CARDS ===== -->
        <section class="relative z-10 -mt-16 px-5 lg:px-12">
            <div class="mx-auto max-w-7xl grid gap-4 sm:grid-cols-3">
                <div class="group rounded-2xl bg-white border border-slate-100 p-6 shadow-xl shadow-slate-200/50 text-center transition-all hover:-translate-y-1 hover:shadow-2xl fade-up">
                    <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 group-hover:bg-brand-900 group-hover:text-white transition-colors"><i data-lucide="building-2" class="h-6 w-6"></i></div>
                    <h3 class="font-extrabold text-slate-900">Head Office</h3>
                    <p class="mt-2 text-sm text-slate-500 leading-relaxed">Palika Administration Center<br/>Ward No. 7, Lalitpur, Nepal</p>
                </div>
                <div class="group rounded-2xl bg-white border border-slate-100 p-6 shadow-xl shadow-slate-200/50 text-center transition-all hover:-translate-y-1 hover:shadow-2xl fade-up" style="transition-delay:.1s">
                    <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 group-hover:bg-brand-900 group-hover:text-white transition-colors"><i data-lucide="mail" class="h-6 w-6"></i></div>
                    <h3 class="font-extrabold text-slate-900">Email Us</h3>
                    <p class="mt-2 text-sm text-slate-500 leading-relaxed">support@sarkarsathi.gov.np<br/>helpdesk@sarkarsathi.gov.np</p>
                </div>
                <div class="group rounded-2xl bg-white border border-slate-100 p-6 shadow-xl shadow-slate-200/50 text-center transition-all hover:-translate-y-1 hover:shadow-2xl fade-up" style="transition-delay:.2s">
                    <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-brand-50 text-brand-900 group-hover:bg-brand-900 group-hover:text-white transition-colors"><i data-lucide="phone-call" class="h-6 w-6"></i></div>
                    <h3 class="font-extrabold text-slate-900">Call Us</h3>
                    <p class="mt-2 text-sm text-slate-500 leading-relaxed">Phone: +977-1-4XXXXXX<br/>Fax: +977-1-4XXXXXY</p>
                </div>
            </div>
        </section>

        <!-- ===== FORM + MAP ===== -->
        <section class="px-5 py-14 lg:px-12 lg:py-20">
            <div class="mx-auto max-w-7xl grid gap-8 lg:grid-cols-[1.1fr_1fr]">
                <!-- Contact Form -->
                <div class="rounded-2xl bg-white border border-slate-100 shadow-xl p-6 sm:p-8 fade-up">
                    <p class="text-xs font-black uppercase tracking-[0.35em] text-brand-500 mb-2">Send A Message</p>
                    <h2 class="text-2xl sm:text-3xl font-black tracking-tight text-slate-900">We'd Love to Hear From You</h2>
                    <form class="mt-6 space-y-4">
                        <div class="grid gap-4 sm:grid-cols-2">
                            <div class="space-y-1.5">
                                <label class="text-[10px] font-black uppercase tracking-[0.15em] text-slate-400 ml-1">Full Name</label>
                                <input type="text" placeholder="Your name" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm font-medium text-slate-900 outline-none focus:border-brand-500 focus:bg-white transition-all"/>
                            </div>
                            <div class="space-y-1.5">
                                <label class="text-[10px] font-black uppercase tracking-[0.15em] text-slate-400 ml-1">Email</label>
                                <input type="email" placeholder="you@email.com" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm font-medium text-slate-900 outline-none focus:border-brand-500 focus:bg-white transition-all"/>
                            </div>
                        </div>
                        <div class="grid gap-4 sm:grid-cols-2">
                            <div class="space-y-1.5">
                                <label class="text-[10px] font-black uppercase tracking-[0.15em] text-slate-400 ml-1">Phone</label>
                                <input type="text" placeholder="+977-XXXXXXXXXX" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm font-medium text-slate-900 outline-none focus:border-brand-500 focus:bg-white transition-all"/>
                            </div>
                            <div class="space-y-1.5">
                                <label class="text-[10px] font-black uppercase tracking-[0.15em] text-slate-400 ml-1">Subject</label>
                                <input type="text" placeholder="How can we help?" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm font-medium text-slate-900 outline-none focus:border-brand-500 focus:bg-white transition-all"/>
                            </div>
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-black uppercase tracking-[0.15em] text-slate-400 ml-1">Message</label>
                            <textarea placeholder="Write your message..." class="min-h-[120px] w-full rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm font-medium text-slate-900 outline-none focus:border-brand-500 focus:bg-white resize-none transition-all"></textarea>
                        </div>
                        <button type="submit" class="w-full rounded-xl bg-brand-900 py-3.5 text-sm font-black text-white shadow-lg shadow-brand-900/20 hover:bg-slate-900 transition-all active:scale-[0.98] flex items-center justify-center gap-2">
                            <i data-lucide="send" class="h-4 w-4"></i> Send Message
                        </button>
                    </form>
                </div>

                <!-- Map + Social -->
                <div class="flex flex-col gap-6">
                    <div class="rounded-2xl bg-white border border-slate-100 shadow-xl overflow-hidden flex-1 fade-up" style="transition-delay:.15s">
                        <iframe
                            src="https://www.google.com/maps?q=Itahari%20International%20College&z=17&output=embed"
                           
                            class="h-[420px] w-full border-0"
                            loading="lazy"
                            referrerpolicy="no-referrer-when-downgrade"
                            allowfullscreen>
                        </iframe>
                    </div>

                    <!-- Social Media -->
                    <div class="rounded-2xl bg-white border border-slate-100 shadow-xl p-6 fade-up" style="transition-delay:.25s">
                        <h3 class="font-extrabold text-slate-900 mb-4">Follow Us On Social Media</h3>
                        <div class="flex items-center gap-3">
                            <a href="#" class="flex h-11 w-11 items-center justify-center rounded-xl bg-[#1877F2] text-white hover:opacity-80 transition-all" title="Facebook">
                                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
                            </a>
                            <a href="#" class="flex h-11 w-11 items-center justify-center rounded-xl bg-gradient-to-br from-[#f09433] via-[#e6683c] to-[#bc1888] text-white hover:opacity-80 transition-all" title="Instagram">
                                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/></svg>
                            </a>
                            <a href="#" class="flex h-11 w-11 items-center justify-center rounded-xl bg-black text-white hover:opacity-80 transition-all" title="X (Twitter)">
                                <svg class="h-4.5 w-4.5" fill="currentColor" viewBox="0 0 24 24"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>
                            </a>
                            <a href="#" class="flex h-11 w-11 items-center justify-center rounded-xl bg-[#FF0000] text-white hover:opacity-80 transition-all" title="YouTube">
                                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24"><path d="M23.498 6.186a3.016 3.016 0 00-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 00.502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 002.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 002.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg>
                            </a>
                            <a href="#" class="flex h-11 w-11 items-center justify-center rounded-xl bg-[#0A66C2] text-white hover:opacity-80 transition-all" title="LinkedIn">
                                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- ===== FOOTER (matches homepage) ===== -->
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
                    <a href="<%= request.getContextPath() %>/" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Home</a>
                    <a href="<%= request.getContextPath() %>/about" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">About Us</a>
                    <a href="<%= request.getContextPath() %>/contact" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Contact</a>
                    <a href="<%= request.getContextPath() %>/announcements" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Announcements</a>
                </div>
                <div>
                    <h5 class="mb-6 text-[11px] font-black uppercase tracking-[0.25em] text-white/35">Services</h5>
                    <a href="<%= request.getContextPath() %>/agriculture" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Agriculture Notices</a>
                    <a href="<%= request.getContextPath() %>/budget" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Budget Transparency</a>
                    <a href="<%= request.getContextPath() %>/track" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Track Application</a>
                </div>
                <div>
                    <h5 class="mb-6 text-[11px] font-black uppercase tracking-[0.25em] text-white/35">Account</h5>
                    <a href="<%= request.getContextPath() %>/login" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Login</a>
                    <a href="<%= request.getContextPath() %>/register" class="block py-1.5 text-sm font-semibold text-slate-400 no-underline hover:text-brand-500">Register</a>
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
    </script>
</body>
</html>
