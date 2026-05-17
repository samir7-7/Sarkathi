<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SarkarSathi Registration - Create your citizen account to access municipal services online.">
    <title>SarkarSathi - Create Account</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: { fontFamily: { sans: ['Outfit','sans-serif'] }, colors: { brand: { 50:'#f0f5fc',100:'#e1eafa',400:'#60a5fa',500:'#3b82f6',800:'#154a91',900:'#0b3d86' }}}}}
    </script>
    <%@ include file="../includes/lucide-icons.jsp" %>
    <style>
        body{font-family:'Outfit',sans-serif}
        .carousel-slide{position:absolute;inset:0;opacity:0;transition:opacity .5s ease;pointer-events:none;display:flex;flex-direction:column}
        .carousel-slide.active{opacity:1;pointer-events:auto;position:relative}
        .gender-btn.active{background:#fff;color:#0f2b5b;box-shadow:0 1px 6px rgba(0,0,0,.08)}
        .field-error{display:none}
        @keyframes fadeInUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
        .fade-in{animation:fadeInUp .6s ease-out forwards}
        .fade-in-d1{animation-delay:.1s;opacity:0}.fade-in-d2{animation-delay:.2s;opacity:0}.fade-in-d3{animation-delay:.3s;opacity:0}
        .tw-input{width:100%;padding:0.82rem 1rem;border:1.5px solid #e2e8f0;border-radius:12px;font-size:0.9rem;font-family:inherit;font-weight:500;color:#1e293b;background:#f8fafc;outline:none;transition:all .25s ease}
        .tw-input::placeholder{color:#94a3b8;font-weight:400}
        .tw-input:focus{border-color:#3b82f6;background:#fff;box-shadow:0 0 0 3px rgba(59,130,246,.12)}
    </style>
</head>
<body class="bg-[#f0f4f8] text-slate-900 antialiased min-h-screen overflow-x-hidden">
    <%
        String error = (String) request.getAttribute("error");
        if (error == null) { error = request.getParameter("error"); }
        String fullName = (String) request.getAttribute("fullName");
        if (fullName == null) fullName = "";
        String email = (String) request.getAttribute("email");
        if (email == null) email = "";
        String phone = (String) request.getAttribute("phone");
        if (phone == null) phone = "";
        String dateOfBirth = (String) request.getAttribute("dateOfBirth");
        if (dateOfBirth == null) dateOfBirth = "";
        String gender = (String) request.getAttribute("gender");
        if (gender == null || gender.isBlank()) gender = "M";
    %>

    <div class="grid grid-cols-1 lg:grid-cols-2 min-h-screen">
        <!-- ═══ LEFT: Hero Panel ═══ -->
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
                <div class="carousel-slide active" data-slide="0">
                    <div class="relative bg-gradient-to-br from-white/[0.12] to-white/[0.04] backdrop-blur-xl border border-white/[0.12] rounded-3xl p-9 mt-5 overflow-hidden">
                        <h2 class="text-[2rem] font-extrabold text-white leading-[1.15] mb-4 tracking-tight">Join 10,000+<br>active citizens</h2>
                        <p class="text-[0.92rem] text-white/70 leading-relaxed mb-6 max-w-[300px]">Create your free account and gain instant access to certificates, tax payments, application tracking, and agriculture notices.</p>
                        <a href="<%= request.getContextPath() %>/about" class="inline-flex items-center gap-2 bg-white/[0.15] border border-white/20 text-white px-6 py-2.5 rounded-xl text-[0.82rem] font-bold hover:bg-white/25 hover:-translate-y-px transition-all no-underline">Learn more <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i></a>
                        <div class="absolute bottom-6 right-6 bg-white rounded-2xl py-3.5 px-5 shadow-lg shadow-black/15 flex items-center gap-3">
                            <div class="w-9 h-9 bg-gradient-to-br from-blue-600 to-blue-500 rounded-[10px] flex items-center justify-center text-white"><i data-lucide="users" class="w-[18px] h-[18px]"></i></div>
                            <div><div class="text-[0.68rem] font-semibold text-slate-400 uppercase tracking-wider">Citizens</div><div class="text-xl font-extrabold text-slate-900">10,000+</div></div>
                        </div>
                    </div>
                </div>
                <div class="carousel-slide" data-slide="1">
                    <div class="relative bg-gradient-to-br from-white/[0.12] to-white/[0.04] backdrop-blur-xl border border-white/[0.12] rounded-3xl p-9 mt-5 overflow-hidden">
                        <h2 class="text-[2rem] font-extrabold text-white leading-[1.15] mb-4 tracking-tight">Secure &amp;<br>trusted platform</h2>
                        <p class="text-[0.92rem] text-white/70 leading-relaxed mb-6 max-w-[300px]">Enterprise-grade encryption protects all your personal data. Every transaction and application is logged and verified for complete transparency.</p>
                        <a href="<%= request.getContextPath() %>/about" class="inline-flex items-center gap-2 bg-white/[0.15] border border-white/20 text-white px-6 py-2.5 rounded-xl text-[0.82rem] font-bold hover:bg-white/25 hover:-translate-y-px transition-all no-underline">Our security <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i></a>
                        <div class="absolute bottom-6 right-6 bg-white rounded-2xl py-3.5 px-5 shadow-lg shadow-black/15 flex items-center gap-3">
                            <div class="w-9 h-9 bg-gradient-to-br from-blue-600 to-blue-500 rounded-[10px] flex items-center justify-center text-white"><i data-lucide="shield-check" class="w-[18px] h-[18px]"></i></div>
                            <div><div class="text-[0.68rem] font-semibold text-slate-400 uppercase tracking-wider">Uptime</div><div class="text-xl font-extrabold text-slate-900">99.9%</div></div>
                        </div>
                    </div>
                </div>
                <div class="carousel-slide" data-slide="2">
                    <div class="relative bg-gradient-to-br from-white/[0.12] to-white/[0.04] backdrop-blur-xl border border-white/[0.12] rounded-3xl p-9 mt-5 overflow-hidden">
                        <h2 class="text-[2rem] font-extrabold text-white leading-[1.15] mb-4 tracking-tight">Agriculture<br>advisory hub</h2>
                        <p class="text-[0.92rem] text-white/70 leading-relaxed mb-6 max-w-[300px]">Get seasonal crop recommendations, subsidy alerts, and training notifications — empowering farmers with timely, data-driven guidance.</p>
                        <a href="<%= request.getContextPath() %>/agriculture" class="inline-flex items-center gap-2 bg-white/[0.15] border border-white/20 text-white px-6 py-2.5 rounded-xl text-[0.82rem] font-bold hover:bg-white/25 hover:-translate-y-px transition-all no-underline">View notices <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i></a>
                        <div class="absolute bottom-6 right-6 bg-white rounded-2xl py-3.5 px-5 shadow-lg shadow-black/15 flex items-center gap-3">
                            <div class="w-9 h-9 bg-gradient-to-br from-blue-600 to-blue-500 rounded-[10px] flex items-center justify-center text-white"><i data-lucide="sprout" class="w-[18px] h-[18px]"></i></div>
                            <div><div class="text-[0.68rem] font-semibold text-slate-400 uppercase tracking-wider">Notices</div><div class="text-xl font-extrabold text-slate-900">120+</div></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="relative z-[2] fade-in fade-in-d3">
                <div class="flex items-center justify-center gap-2 mt-8" id="reg-carousel-dots">
                    <span class="w-7 h-7 rounded-full border border-white/20 text-white/50 flex items-center justify-center cursor-pointer text-[0.7rem] hover:bg-white/10 hover:text-white transition-all" id="reg-prev">&lt;</span>
                    <span class="dot w-6 h-2.5 rounded-full bg-white cursor-pointer transition-all" data-slide="0"></span>
                    <span class="dot w-2 h-2 rounded-full bg-white/25 cursor-pointer transition-all hover:bg-white/40" data-slide="1"></span>
                    <span class="dot w-2 h-2 rounded-full bg-white/25 cursor-pointer transition-all hover:bg-white/40" data-slide="2"></span>
                    <span class="w-7 h-7 rounded-full border border-white/20 text-white/50 flex items-center justify-center cursor-pointer text-[0.7rem] hover:bg-white/10 hover:text-white transition-all" id="reg-next">&gt;</span>
                </div>
            </div>
        </section>

        <!-- ═══ RIGHT: Form Panel ═══ -->
        <section class="flex flex-col items-center px-5 py-8 sm:px-10 lg:px-14 bg-white overflow-y-auto">
            <div class="w-full max-w-[560px] fade-in">
                <a href="<%= request.getContextPath() %>/" class="flex items-center gap-2 text-slate-500 text-sm font-semibold hover:text-blue-600 transition-colors no-underline mb-4">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i><span>Back to Home</span>
                </a>
            </div>
            <div class="w-full max-w-[560px] my-auto fade-in">
                <h1 class="text-[1.95rem] font-black tracking-tight leading-[1.1] text-slate-900 mb-1">Create account</h1>

                <% if (error != null && !error.isBlank()) { %>
                <div class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-sm font-semibold mb-4">
                    <i data-lucide="alert-circle" class="w-[18px] h-[18px] shrink-0"></i><span><%= error %></span>
                </div>
                <% } %>

                <form id="register-form" action="<%= request.getContextPath() %>/register" method="post" novalidate>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-x-4 gap-y-1">
                        <div>
                            <label for="fullName" class="block text-[0.79rem] font-semibold text-slate-500 mb-1">Full Name</label>
                            <div class="relative mb-2"><input id="fullName" type="text" name="fullName" value="<%= fullName %>" placeholder="Sujan Subedi" required minlength="3" maxlength="100" autocomplete="name" class="tw-input" aria-describedby="fullName-error"></div>
                            <p id="fullName-error" class="field-error text-[0.68rem] font-semibold text-red-600 -mt-1 mb-2 ml-1"></p>
                        </div>
                        <div>
                            <label for="email" class="block text-[0.79rem] font-semibold text-slate-500 mb-1">E-mail</label>
                            <div class="relative mb-2"><input id="email" type="email" name="email" value="<%= email %>" placeholder="name@domain.com" required maxlength="254" autocomplete="email" class="tw-input" aria-describedby="email-error"></div>
                            <p id="email-error" class="field-error text-[0.68rem] font-semibold text-red-600 -mt-1 mb-2 ml-1"></p>
                        </div>
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-x-4 gap-y-1">
                        <div>
                            <label for="phone" class="block text-[0.79rem] font-semibold text-slate-500 mb-1">Phone Number</label>
                            <div class="relative mb-2"><input id="phone" type="tel" name="phone" value="<%= phone %>" placeholder="98XXXXXXXX" required inputmode="numeric" minlength="10" maxlength="10" pattern="\d{10}" autocomplete="tel" class="tw-input" aria-describedby="phone-error"></div>
                            <p id="phone-error" class="field-error text-[0.68rem] font-semibold text-red-600 -mt-1 mb-2 ml-1"></p>
                        </div>
                        <div>
                            <label for="dateOfBirth" class="block text-[0.79rem] font-semibold text-slate-500 mb-1">Date of Birth</label>
                            <div class="relative mb-2"><input id="dateOfBirth" type="date" name="dateOfBirth" value="<%= dateOfBirth %>" required class="tw-input" aria-describedby="dateOfBirth-error"></div>
                            <p id="dateOfBirth-error" class="field-error text-[0.68rem] font-semibold text-red-600 -mt-1 mb-2 ml-1"></p>
                        </div>
                    </div>

                    <label class="block text-[0.79rem] font-semibold text-slate-500 mb-1">Gender</label>
                    <div class="flex bg-slate-100 rounded-xl p-1 gap-1 mb-3">
                        <button type="button" class="gender-btn flex-1 text-center py-2.5 text-[0.74rem] font-bold text-slate-500 rounded-[9px] cursor-pointer border-none bg-transparent transition-all uppercase tracking-wider" data-value="M">Male</button>
                        <button type="button" class="gender-btn flex-1 text-center py-2.5 text-[0.74rem] font-bold text-slate-500 rounded-[9px] cursor-pointer border-none bg-transparent transition-all uppercase tracking-wider" data-value="F">Female</button>
                        <button type="button" class="gender-btn flex-1 text-center py-2.5 text-[0.74rem] font-bold text-slate-500 rounded-[9px] cursor-pointer border-none bg-transparent transition-all uppercase tracking-wider" data-value="O">Other</button>
                        <input type="hidden" name="gender" id="gender-input" value="<%= gender %>">
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-x-4 gap-y-1">
                        <div>
                            <label for="password" class="block text-[0.79rem] font-semibold text-slate-500 mb-1">Password</label>
                            <div class="relative mb-2">
                                <input id="password" type="password" name="password" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" required minlength="8" maxlength="72" autocomplete="new-password" class="tw-input" aria-describedby="password-error password-hint">
                                <button type="button" class="toggle-pw absolute right-3.5 top-1/2 -translate-y-1/2 bg-transparent border-none cursor-pointer p-1 rounded-md text-slate-400 hover:text-blue-500 transition-colors" data-target="password" aria-label="Show password"><i data-lucide="eye" class="w-[18px] h-[18px]"></i></button>
                            </div>
                            <p id="password-error" class="field-error text-[0.68rem] font-semibold text-red-600 -mt-1 mb-2 ml-1"></p>
                        </div>
                        <div>
                            <label for="confirmPassword" class="block text-[0.79rem] font-semibold text-slate-500 mb-1">Confirm Password</label>
                            <div class="relative mb-2">
                                <input id="confirmPassword" type="password" name="confirmPassword" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" required minlength="8" maxlength="72" autocomplete="new-password" class="tw-input" aria-describedby="confirmPassword-error">
                                <button type="button" class="toggle-pw absolute right-3.5 top-1/2 -translate-y-1/2 bg-transparent border-none cursor-pointer p-1 rounded-md text-slate-400 hover:text-blue-500 transition-colors" data-target="confirmPassword" aria-label="Show password"><i data-lucide="eye" class="w-[18px] h-[18px]"></i></button>
                            </div>
                            <p id="confirmPassword-error" class="field-error text-[0.68rem] font-semibold text-red-600 -mt-1 mb-2 ml-1"></p>
                        </div>
                    </div>
                    <p class="flex items-center gap-1.5 text-[0.68rem] font-medium text-slate-400 -mt-0.5 mb-3 ml-0.5" id="password-hint">
                        <i data-lucide="info" class="w-3 h-3"></i> Min 8 characters with letters and numbers
                    </p>

                    <button type="submit" class="w-full py-3.5 border-none rounded-xl bg-gradient-to-br from-blue-800 to-blue-600 text-white text-[0.92rem] font-bold cursor-pointer flex items-center justify-center gap-2 mt-1 hover:from-blue-900 hover:to-blue-700 hover:-translate-y-px hover:shadow-lg hover:shadow-blue-500/30 active:scale-[0.98] transition-all">
                        <span>Create Account</span><i data-lucide="arrow-right" class="w-4 h-4"></i>
                    </button>

                    <div class="flex items-center gap-3.5 my-4 text-[0.72rem] text-slate-400 font-semibold uppercase tracking-widest before:content-[''] before:flex-1 before:h-px before:bg-slate-200 after:content-[''] after:flex-1 after:h-px after:bg-slate-200">OR</div>
                    <div class="text-center text-[0.88rem] text-slate-500 font-medium">
                        Already registered? <a href="<%= request.getContextPath() %>/login" class="text-blue-600 font-bold hover:underline no-underline">Sign in instead</a>
                    </div>
                </form>
            </div>
        </section>
    </div>

    <script>
        /* ── Validation ── */
        const form = document.getElementById("register-form");
        const fullNameInput = document.getElementById("fullName");
        const emailInput = document.getElementById("email");
        const phoneInput = document.getElementById("phone");
        const dateOfBirthInput = document.getElementById("dateOfBirth");
        const passwordInput = document.getElementById("password");
        const confirmPasswordInput = document.getElementById("confirmPassword");

        const emailPat = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const namePat = /^[A-Za-z][A-Za-z\s'.-]{1,98}[A-Za-z]$/;
        const phonePat = /^[0-9]{10}$/;
        const pwPat = /^(?=.*[A-Za-z])(?=.*\d).{8,72}$/;

        function formatD(d){return d.getFullYear()+"-"+String(d.getMonth()+1).padStart(2,"0")+"-"+String(d.getDate()).padStart(2,"0")}
        function addY(d,y){const c=new Date(d);c.setFullYear(c.getFullYear()+y);return c}
        const today=new Date();
        dateOfBirthInput.max=formatD(addY(today,-16));
        dateOfBirthInput.min=formatD(addY(today,-120));

        function setErr(inp,msg){
            const el=document.getElementById(inp.id+"-error");
            if(el){el.textContent=msg;el.style.display=msg?"block":"none"}
            inp.style.borderColor=msg?"#dc2626":"";
        }
        function setInv(inp,msg){setErr(inp,msg);return false}

        function validate(inp){
            const v=inp.value.trim();
            if(inp===fullNameInput){
                if(!v)return setInv(inp,"Full name is required.");
                if(v.length<3||v.length>100)return setInv(inp,"Must be 3-100 characters.");
                if(!namePat.test(v))return setInv(inp,"Letters, spaces, apostrophes, periods, hyphens only.");
            }
            if(inp===emailInput){
                if(!v)return setInv(inp,"Email is required.");
                if(!emailPat.test(v))return setInv(inp,"Enter a valid email.");
            }
            if(inp===phoneInput){
                inp.value=inp.value.replace(/\D/g,"").slice(0,10);
                if(!inp.value)return setInv(inp,"Phone is required.");
                if(!phonePat.test(inp.value))return setInv(inp,"Must be exactly 10 digits.");
            }
            if(inp===dateOfBirthInput){
                if(!v)return setInv(inp,"Date of birth is required.");
                if(v<dateOfBirthInput.min||v>dateOfBirthInput.max)return setInv(inp,"Age must be 16-120.");
            }
            if(inp===passwordInput){
                if(!inp.value)return setInv(inp,"Password is required.");
                if(!pwPat.test(inp.value))return setInv(inp,"8+ chars with letters & numbers.");
                if(confirmPasswordInput.value)validate(confirmPasswordInput);
            }
            if(inp===confirmPasswordInput){
                if(!inp.value)return setInv(inp,"Please confirm password.");
                if(inp.value!==passwordInput.value)return setInv(inp,"Passwords don't match.");
            }
            setErr(inp,"");return true;
        }

        [fullNameInput,emailInput,phoneInput,dateOfBirthInput,passwordInput,confirmPasswordInput].forEach(i=>{
            i.addEventListener("input",()=>validate(i));
            i.addEventListener("blur",()=>validate(i));
        });

        form.addEventListener("submit",e=>{
            const fields=[fullNameInput,emailInput,phoneInput,dateOfBirthInput,passwordInput,confirmPasswordInput];
            const ok=fields.every(validate);
            if(!ok){e.preventDefault();fields.find(i=>!validate(i))?.focus()}
        });

        /* ── Gender Toggle ── */
        const genderBtns=document.querySelectorAll(".gender-btn");
        const genderInput=document.getElementById("gender-input");
        function setGender(btn){
            genderBtns.forEach(b=>b.classList.toggle("active",b===btn));
            genderInput.value=btn.dataset.value;
        }
        genderBtns.forEach(btn=>{
            btn.addEventListener("click",()=>setGender(btn));
            if(btn.dataset.value==="<%= gender %>")setGender(btn);
        });

        /* ── Password Toggle ── */
        document.querySelectorAll(".toggle-pw").forEach(btn=>{
            btn.addEventListener("click",()=>{
                const inp=document.getElementById(btn.dataset.target);
                const show=inp.type==="password";
                inp.type=show?"text":"password";
                btn.innerHTML=show
                    ?'<i data-lucide="eye-off" class="w-[18px] h-[18px]"></i>'
                    :'<i data-lucide="eye" class="w-[18px] h-[18px]"></i>';
                lucide.createIcons();
            });
        });

        lucide.createIcons();

        /* ── Hero Carousel ── */
        (function(){
            const slides = document.querySelectorAll('.carousel-slide');
            const dots = document.querySelectorAll('#reg-carousel-dots .dot');
            const prevBtn = document.getElementById('reg-prev');
            const nextBtn = document.getElementById('reg-next');
            if(!slides.length) return;
            let current = 0, timer;
            function goTo(idx){
                slides.forEach(s => s.classList.remove('active'));
                dots.forEach((d,i) => {
                    if(i===idx){ d.className='dot w-6 h-2.5 rounded-full bg-white cursor-pointer transition-all'; }
                    else { d.className='dot w-2 h-2 rounded-full bg-white/25 cursor-pointer transition-all hover:bg-white/40'; }
                });
                slides[idx].classList.add('active');
                current = idx;
                lucide.createIcons();
            }
            function next(){ goTo((current+1)%slides.length); }
            function prev(){ goTo((current-1+slides.length)%slides.length); }
            function resetAuto(){ clearInterval(timer); timer=setInterval(next,4000); }
            prevBtn.addEventListener('click',()=>{prev();resetAuto();});
            nextBtn.addEventListener('click',()=>{next();resetAuto();});
            dots.forEach(d=>d.addEventListener('click',()=>{goTo(+d.dataset.slide);resetAuto();}));
            resetAuto();
        })();
    </script>
</body>
</html>
