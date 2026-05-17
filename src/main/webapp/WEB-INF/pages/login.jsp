<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SarkarSathi Login - Access citizen and admin portals securely.">
    <title>SarkarSathi - Sign In</title>
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
    <%@ include file="../includes/lucide-icons.jsp" %>
    <style>
        body{font-family:'Outfit',sans-serif}
        /* carousel */
        .carousel-slide{position:absolute;inset:0;opacity:0;transition:opacity .5s ease;pointer-events:none;display:flex;flex-direction:column}
        .carousel-slide.active{opacity:1;pointer-events:auto;position:relative}
        /* role toggle */
        .role-toggle input[type="radio"]{display:none}
        .role-toggle input:checked+label{background:#fff;color:#0f2b5b;box-shadow:0 1px 6px rgba(0,0,0,.08);font-weight:700}
        /* shake animation */
        @keyframes shake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-5px)}40%,80%{transform:translateX(5px)}}
        .shake{animation:shake .4s ease-in-out}
        /* fade in */
        @keyframes fadeInUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
        .fade-in{animation:fadeInUp .6s ease-out forwards}
        .fade-in-d1{animation-delay:.1s;opacity:0}
        .fade-in-d2{animation-delay:.2s;opacity:0}
        .fade-in-d3{animation-delay:.3s;opacity:0}
        .divider-disabled{color:#fff !important}
        .divider-disabled::before,.divider-disabled::after{background:#fff !important}
        .register-disabled,.register-disabled span{color:#fff !important}
        .register-disabled a{color:#fff !important;pointer-events:none;cursor:default}
        .register-disabled a:hover{text-decoration:none}
    </style>
</head>
<body class="bg-[#f0f4f8] text-slate-900 antialiased h-screen overflow-hidden">
    <%
        String error = (String) request.getAttribute("error");
        if (error == null) { error = request.getParameter("error"); }
        String userType = (String) request.getAttribute("userType");
        if (userType == null || userType.isBlank()) { userType = request.getParameter("userType"); }
        if (userType == null || userType.isBlank()) { userType = "citizen"; }
        String email = (String) request.getAttribute("email");
        if (email == null) { email = request.getParameter("email"); }
        if (email == null) { email = ""; }
        Object rememberMeAttr = request.getAttribute("rememberMe");
        boolean rememberMe = rememberMeAttr instanceof Boolean
                ? (Boolean) rememberMeAttr
                : "true".equalsIgnoreCase(String.valueOf(rememberMeAttr));
        String registered = request.getParameter("registered");
    %>

    <div class="grid grid-cols-1 lg:grid-cols-2 min-h-screen">
        <!-- ═══ LEFT: Form Panel ═══ -->
        <section class="flex flex-col justify-center items-center px-6 py-8 sm:px-10 bg-white">
            <div class="w-full max-w-[420px] fade-in">
                <a href="<%= request.getContextPath() %>/" class="flex items-center gap-2 -mt-1 mb-5 text-slate-500 text-sm font-semibold hover:text-blue-600 transition-colors no-underline">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i>
                    <span>Back to Home</span>
                </a>

                <h1 class="text-[2rem] font-black tracking-tight leading-[1.1] text-slate-900 mb-1">Sign in</h1>

                <% if ("success".equals(registered)) { %>
                <div class="flex items-center gap-2.5 px-4 py-2.5 rounded-xl bg-green-50 border border-green-200 text-green-600 text-sm font-semibold mb-3">
                    <i data-lucide="check-circle-2" class="w-[18px] h-[18px] shrink-0"></i>
                    <span>Registration successful! Please sign in.</span>
                </div>
                <% } %>

                <% if (error != null) { %>
                <div class="flex items-center gap-2.5 px-4 py-2.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-sm font-semibold mb-3 shake" id="error-alert">
                    <i data-lucide="alert-circle" class="w-[18px] h-[18px] shrink-0"></i>
                    <span><%= error %></span>
                </div>
                <% } %>

                <form id="login-form" action="<%= request.getContextPath() %>/login" method="post" novalidate>
                    <input type="hidden" name="userType" id="userType" value="<%= userType %>">

                    <!-- Role Toggle -->
                    <div class="mb-4">
                        <label class="block text-[0.8rem] font-semibold text-slate-500 mb-1.5">Access Tier</label>
                        <div class="role-toggle flex bg-slate-100 rounded-[10px] p-[3px] gap-[3px]">
                            <input type="radio" name="roleToggle" id="role-citizen" value="citizen" <%= "citizen".equalsIgnoreCase(userType) ? "checked" : "" %>>
                            <label for="role-citizen" class="flex-1 text-center py-[7px] text-[0.8rem] font-semibold text-slate-500 rounded-lg cursor-pointer transition-all select-none">Citizen</label>
                            <input type="radio" name="roleToggle" id="role-admin" value="admin" <%= "admin".equalsIgnoreCase(userType) ? "checked" : "" %>>
                            <label for="role-admin" class="flex-1 text-center py-[7px] text-[0.8rem] font-semibold text-slate-500 rounded-lg cursor-pointer transition-all select-none">Admin</label>
                        </div>
                    </div>

                    <!-- Email -->
                    <label for="email" class="block text-[0.8rem] font-semibold text-slate-500 mb-1.5">E-mail</label>
                    <div class="relative mb-3">
                        <input id="email" type="email" name="email" value="<%= email %>" placeholder="example@gmail.com" required maxlength="254" autocomplete="email" aria-describedby="email-error"
                               class="w-full px-4 py-[0.7rem] border-[1.5px] border-slate-200 rounded-xl text-[0.88rem] font-medium text-slate-900 bg-slate-50 outline-none placeholder:text-slate-400 placeholder:font-normal focus:border-blue-500 focus:bg-white focus:ring-[3px] focus:ring-blue-500/10 transition-all">
                    </div>
                    <p id="email-error" class="text-[0.72rem] font-semibold text-red-600 mt-1 ml-1 hidden"></p>

                    <!-- Password -->
                    <label for="password" class="block text-[0.8rem] font-semibold text-slate-500 mb-1.5">Password</label>
                    <div class="relative mb-3">
                        <input id="password" type="password" name="password" placeholder="@#*%" required maxlength="72" autocomplete="current-password" aria-describedby="password-error"
                               class="w-full px-4 py-[0.7rem] border-[1.5px] border-slate-200 rounded-xl text-[0.88rem] font-medium text-slate-900 bg-slate-50 outline-none placeholder:text-slate-400 placeholder:font-normal focus:border-blue-500 focus:bg-white focus:ring-[3px] focus:ring-blue-500/10 transition-all">
                        <button type="button" class="toggle-pw absolute right-3.5 top-1/2 -translate-y-1/2 bg-transparent border-none cursor-pointer p-1 rounded-md text-slate-400 hover:text-blue-500 transition-colors" data-target="password" aria-label="Show password">
                            <i data-lucide="eye" class="w-[18px] h-[18px]"></i>
                        </button>
                    </div>
                    <p id="password-error" class="text-[0.72rem] font-semibold text-red-600 mt-1 ml-1 hidden"></p>

                    <!-- Options Row -->
                    <div class="flex items-center justify-between mb-4 text-[0.8rem]">
                        <label class="flex items-center gap-2 text-slate-500 cursor-pointer font-medium">
                            <input type="checkbox" name="rememberMe" <%= rememberMe ? "checked" : "" %> class="w-4 h-4 accent-blue-500 rounded"> Remember me
                        </label>
                        <a href="#" class="text-blue-500 font-semibold hover:underline no-underline">Forgot Password?</a>
                    </div>

                    <!-- Submit -->
                    <button type="submit" class="w-full py-3 border-none rounded-xl bg-gradient-to-br from-blue-800 to-blue-600 text-white text-[0.9rem] font-bold cursor-pointer flex items-center justify-center gap-2 tracking-[0.01em] hover:from-blue-900 hover:to-blue-700 hover:-translate-y-px hover:shadow-lg hover:shadow-blue-500/30 active:scale-[0.98] transition-all" id="login-btn">
                        <span id="btn-text">Sign in</span>
                        <i data-lucide="arrow-right" class="w-4 h-4"></i>
                    </button>

                    <!-- OR Divider + Register -->
                    <div class="flex items-center gap-3.5 my-4 text-[0.72rem] text-slate-400 font-semibold uppercase tracking-widest before:content-[''] before:flex-1 before:h-px before:bg-slate-200 after:content-[''] after:flex-1 after:h-px after:bg-slate-200 <%= "admin".equalsIgnoreCase(userType) ? "divider-disabled" : "" %>" id="register-divider">OR</div>
                    <div class="text-center text-[0.88rem] text-slate-500 font-medium <%= "admin".equalsIgnoreCase(userType) ? "register-disabled" : "" %>" id="register-link">
                        <span>New to the platform?</span>
                        <a href="<%= request.getContextPath() %>/register" class="text-blue-600 font-bold hover:underline no-underline">
                            Create Citizen Account
                        </a>
                    </div>
                </form>
            </div>
        </section>

        <!-- ═══ RIGHT: Hero Panel ═══ -->
        <section class="relative hidden lg:flex flex-col justify-between bg-gradient-to-br from-[#0c2d6b] via-[#143d8a] to-[#1e5bb5] p-9 overflow-hidden">
            <div class="absolute -top-[120px] -right-[120px] w-[400px] h-[400px] bg-[radial-gradient(circle,rgba(96,165,250,.15),transparent_70%)] rounded-full pointer-events-none"></div>
            <div class="absolute -bottom-20 -left-[60px] w-[300px] h-[300px] bg-[radial-gradient(circle,rgba(59,130,246,.1),transparent_70%)] rounded-full pointer-events-none"></div>

            <div class="relative z-[2] flex items-center justify-between fade-in fade-in-d1">
                <a href="<%= request.getContextPath() %>/" class="text-2xl font-black tracking-tight text-white no-underline">Sarkar<span class="text-brand-400">Sathi</span></a>
                <div class="inline-flex items-center gap-2 text-white/70 text-sm font-semibold">
                    <i data-lucide="headphones" class="w-[18px] h-[18px]"></i> Support
                </div>
            </div>

            <div class="relative z-[2] flex-1 flex flex-col justify-center">
                <!-- Slide 1 -->
                <div class="carousel-slide active" data-slide="0">
                    <div class="relative bg-gradient-to-br from-white/[0.12] to-white/[0.04] backdrop-blur-xl border border-white/[0.12] rounded-3xl p-9 mt-5 overflow-hidden">
                        <h2 class="text-[2rem] font-extrabold text-white leading-[1.15] mb-4 tracking-tight">Access municipal<br>services faster</h2>
                        <p class="text-[0.92rem] text-white/70 leading-relaxed mb-6 max-w-[300px]">Use SarkarSathi to apply for certificates, pay taxes, and track your applications — all from one unified portal.</p>
                        <a href="<%= request.getContextPath() %>/about" class="inline-flex items-center gap-2 bg-white/[0.15] border border-white/20 text-white px-6 py-2.5 rounded-xl text-[0.82rem] font-bold hover:bg-white/25 hover:-translate-y-px transition-all no-underline">
                            Learn more <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
                        </a>
                        <div class="absolute bottom-6 right-6 bg-white rounded-2xl py-3.5 px-5 shadow-lg shadow-black/15 flex items-center gap-3">
                            <div class="w-9 h-9 bg-gradient-to-br from-blue-600 to-blue-500 rounded-[10px] flex items-center justify-center text-white"><i data-lucide="bar-chart-3" class="w-[18px] h-[18px]"></i></div>
                            <div><div class="text-[0.68rem] font-semibold text-slate-400 uppercase tracking-wider">Applications</div><div class="text-xl font-extrabold text-slate-900">4,700+</div></div>
                        </div>
                    </div>
                </div>
                <!-- Slide 2 -->
                <div class="carousel-slide" data-slide="1">
                    <div class="relative bg-gradient-to-br from-white/[0.12] to-white/[0.04] backdrop-blur-xl border border-white/[0.12] rounded-3xl p-9 mt-5 overflow-hidden">
                        <h2 class="text-[2rem] font-extrabold text-white leading-[1.15] mb-4 tracking-tight">Digital certificates<br>in minutes</h2>
                        <p class="text-[0.92rem] text-white/70 leading-relaxed mb-6 max-w-[300px]">Apply for birth, marriage, death, and citizenship certificates online — track progress in real-time without visiting any office.</p>
                        <a href="<%= request.getContextPath() %>/about" class="inline-flex items-center gap-2 bg-white/[0.15] border border-white/20 text-white px-6 py-2.5 rounded-xl text-[0.82rem] font-bold hover:bg-white/25 hover:-translate-y-px transition-all no-underline">
                            Explore services <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
                        </a>
                        <div class="absolute bottom-6 right-6 bg-white rounded-2xl py-3.5 px-5 shadow-lg shadow-black/15 flex items-center gap-3">
                            <div class="w-9 h-9 bg-gradient-to-br from-blue-600 to-blue-500 rounded-[10px] flex items-center justify-center text-white"><i data-lucide="file-check-2" class="w-[18px] h-[18px]"></i></div>
                            <div><div class="text-[0.68rem] font-semibold text-slate-400 uppercase tracking-wider">Certificates</div><div class="text-xl font-extrabold text-slate-900">2,300+</div></div>
                        </div>
                    </div>
                </div>
                <!-- Slide 3 -->
                <div class="carousel-slide" data-slide="2">
                    <div class="relative bg-gradient-to-br from-white/[0.12] to-white/[0.04] backdrop-blur-xl border border-white/[0.12] rounded-3xl p-9 mt-5 overflow-hidden">
                        <h2 class="text-[2rem] font-extrabold text-white leading-[1.15] mb-4 tracking-tight">Transparent<br>governance for all</h2>
                        <p class="text-[0.92rem] text-white/70 leading-relaxed mb-6 max-w-[300px]">View municipal budgets, agriculture notices, and public announcements — empowering citizens through open data and accountability.</p>
                        <a href="<%= request.getContextPath() %>/budget" class="inline-flex items-center gap-2 bg-white/[0.15] border border-white/20 text-white px-6 py-2.5 rounded-xl text-[0.82rem] font-bold hover:bg-white/25 hover:-translate-y-px transition-all no-underline">
                            View budgets <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
                        </a>
                        <div class="absolute bottom-6 right-6 bg-white rounded-2xl py-3.5 px-5 shadow-lg shadow-black/15 flex items-center gap-3">
                            <div class="w-9 h-9 bg-gradient-to-br from-blue-600 to-blue-500 rounded-[10px] flex items-center justify-center text-white"><i data-lucide="shield-check" class="w-[18px] h-[18px]"></i></div>
                            <div><div class="text-[0.68rem] font-semibold text-slate-400 uppercase tracking-wider">Citizens</div><div class="text-xl font-extrabold text-slate-900">10,000+</div></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="relative z-[2] fade-in fade-in-d3">
                <div class="flex items-center justify-center gap-2 mt-8" id="login-carousel-dots">
                    <span class="w-7 h-7 rounded-full border border-white/20 bg-transparent text-white/50 flex items-center justify-center cursor-pointer text-[0.7rem] hover:bg-white/10 hover:text-white transition-all" id="login-prev">&lt;</span>
                    <span class="dot w-6 h-2.5 rounded-full bg-white cursor-pointer transition-all" data-slide="0"></span>
                    <span class="dot w-2 h-2 rounded-full bg-white/25 cursor-pointer transition-all hover:bg-white/40" data-slide="1"></span>
                    <span class="dot w-2 h-2 rounded-full bg-white/25 cursor-pointer transition-all hover:bg-white/40" data-slide="2"></span>
                    <span class="w-7 h-7 rounded-full border border-white/20 bg-transparent text-white/50 flex items-center justify-center cursor-pointer text-[0.7rem] hover:bg-white/10 hover:text-white transition-all" id="login-next">&gt;</span>
                </div>
            </div>
        </section>
    </div>

    <script>
        /* ── Form Logic ── */
        const loginForm = document.getElementById("login-form");
        const emailInput = document.getElementById("email");
        const passwordInput = document.getElementById("password");
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        function setFieldError(input, msg) {
            const err = document.getElementById(input.id + "-error");
            if (err) { err.textContent = msg; err.style.display = msg ? "block" : "none"; }
            input.style.borderColor = msg ? "#dc2626" : "";
        }
        function validate(input) {
            const v = input.value.trim();
            if (input === emailInput) {
                if (!v) { setFieldError(input, "Email is required."); return false; }
                if (!emailPattern.test(v)) { setFieldError(input, "Enter a valid email."); return false; }
            }
            if (input === passwordInput && !v) { setFieldError(input, "Password is required."); return false; }
            setFieldError(input, ""); return true;
        }
        [emailInput, passwordInput].forEach(i => {
            i.addEventListener("input", () => validate(i));
            i.addEventListener("blur", () => validate(i));
        });
        loginForm.addEventListener("submit", e => {
            const ok = [emailInput, passwordInput].every(validate);
            if (!ok) { e.preventDefault(); [emailInput, passwordInput].find(i => !validate(i))?.focus(); }
        });

        /* ── Password Toggle ── */
        document.querySelectorAll(".toggle-pw").forEach(btn => {
            btn.addEventListener("click", () => {
                const inp = document.getElementById(btn.dataset.target);
                const show = inp.type === "password";
                inp.type = show ? "text" : "password";
                btn.innerHTML = show
                    ? '<i data-lucide="eye-off" class="w-[18px] h-[18px]"></i>'
                    : '<i data-lucide="eye" class="w-[18px] h-[18px]"></i>';
                lucide.createIcons();
            });
        });

        /* ── Role Toggle ── */
        const citizenRadio = document.getElementById("role-citizen");
        const adminRadio = document.getElementById("role-admin");
        const userTypeInput = document.getElementById("userType");
        const btnText = document.getElementById("btn-text");
        const registerDivider = document.getElementById("register-divider");
        const registerLink = document.getElementById("register-link");

        function updateRole() {
            if (adminRadio.checked) {
                userTypeInput.value = "admin";
                btnText.textContent = "Sign in as Admin";
                registerDivider.classList.add("divider-disabled");
                registerLink.classList.add("register-disabled");
            } else {
                userTypeInput.value = "citizen";
                btnText.textContent = "Sign in";
                registerDivider.classList.remove("divider-disabled");
                registerLink.classList.remove("register-disabled");
            }
        }
        citizenRadio.addEventListener("change", updateRole);
        adminRadio.addEventListener("change", updateRole);
        updateRole();

        lucide.createIcons();

        /* ── Hero Carousel ── */
        (function(){
            const slides = document.querySelectorAll('.carousel-slide');
            const dots = document.querySelectorAll('#login-carousel-dots .dot');
            const prevBtn = document.getElementById('login-prev');
            const nextBtn = document.getElementById('login-next');
            if(!slides.length) return;
            let current = 0, timer;

            function goTo(idx){
                slides.forEach(s => s.classList.remove('active'));
                dots.forEach((d,i) => {
                    if(i === idx){ d.className = 'dot w-6 h-2.5 rounded-full bg-white cursor-pointer transition-all'; }
                    else { d.className = 'dot w-2 h-2 rounded-full bg-white/25 cursor-pointer transition-all hover:bg-white/40'; }
                });
                slides[idx].classList.add('active');
                current = idx;
                lucide.createIcons();
            }
            function next(){ goTo((current + 1) % slides.length); }
            function prev(){ goTo((current - 1 + slides.length) % slides.length); }
            function resetAuto(){ clearInterval(timer); timer = setInterval(next, 4000); }

            prevBtn.addEventListener('click', () => { prev(); resetAuto(); });
            nextBtn.addEventListener('click', () => { next(); resetAuto(); });
            dots.forEach(d => d.addEventListener('click', () => { goTo(+d.dataset.slide); resetAuto(); }));
            resetAuto();
        })();
    </script>
</body>
</html>
