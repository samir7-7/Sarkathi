<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
            SarkarSathi - Register
        </title>
        <script src="https://cdn.tailwindcss.com">
        </script>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="min-h-screen bg-slate-50 text-slate-900 antialiased overflow-x-hidden selection:bg-brand-100 selection:text-brand-900">
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
        <div class="flex min-h-screen flex-col lg:flex-row">
            <!-- Left Branding Section -->
            <section class="relative hidden overflow-hidden lg:flex lg:w-1/2">
                <img src="https://images.unsplash.com/photo-1511818966892-d7d671e672a2?q=80&w=1600&auto=format&fit=crop" alt="Municipal landscape" class="absolute inset-0 h-full w-full object-cover">
                <div class="absolute inset-0 bg-[#0b3d86]/85"></div>
                <div class="absolute inset-0 bg-gradient-to-br from-[#0b3d86]/70 via-[#3b82f6]/20 to-[#0b3d86]/90"></div>
                
                <div class="relative flex h-full w-full flex-col justify-between px-16 py-20 text-white">
                    <div class="max-w-xl">
                        <a href="<%= request.getContextPath() %>" class="flex items-center gap-2 text-3xl font-black tracking-tight text-white mb-16">
                            Sarkar<span class="text-blue-300">Sathi</span>
                        </a>
                        <h1 class="text-6xl font-black leading-[1.05] tracking-tight mb-10">
                            The Future of<br/>Citizen-City<br/>Interaction.
                        </h1>
                        <p class="text-xl leading-relaxed text-blue-100/90 font-medium max-w-md mb-12">
                            Join over 10,000 residents already using SarkarSathi to access municipal services, track requests, and power their community.
                        </p>
                        
                        <div class="flex items-center gap-6">
                            <div class="flex -space-x-3">
                                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=120&auto=format&fit=crop" class="h-12 w-12 rounded-full border-2 border-white/20 object-cover">
                                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=120&auto=format&fit=crop" class="h-12 w-12 rounded-full border-2 border-white/20 object-cover">
                                <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=120&auto=format&fit=crop" class="h-12 w-12 rounded-full border-2 border-white/20 object-cover">
                            </div>
                            <div class="h-8 w-1px bg-white/20"></div>
                            <p class="text-sm font-black uppercase tracking-widest text-white/70">Social Contract Secured</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Right Registration Section -->
            <section class="flex flex-1 flex-col items-center justify-center p-6 sm:p-12 lg:p-20 relative overflow-y-auto">
                <!-- Mobile Branding -->
                <div class="w-full max-w-md lg:hidden mb-12 text-center">
                    <a href="<%= request.getContextPath() %>" class="text-3xl font-black tracking-tight text-brand-900">
                        Sarkar<span class="text-blue-600">Sathi</span>
                    </a>
                </div>

                <div class="w-full max-w-[480px] fade-in py-8">
                    <div class="mb-10 text-center lg:text-left">
                        <h2 class="text-3xl font-black text-slate-900 tracking-tight mb-3">Enlistment Portal</h2>
                        <p class="text-slate-500 font-medium whitespace-nowrap overflow-hidden text-ellipsis">Begin your journey as an active municipal participant.</p>
                    </div>

                    <div class="rounded-[2.5rem] bg-white p-8 sm:p-10 shadow-2xl shadow-slate-200/60 border border-slate-100">
                        <% if (error != null && !error.isBlank()) { %>
                            <div class="mb-8 flex items-center gap-3 rounded-2xl border border-red-100 bg-red-50 px-4 py-4 text-sm font-bold text-red-700">
                                <i data-lucide="alert-circle" class="h-5 w-5 text-red-600"></i>
                                <%= error %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/register" method="post" class="space-y-6">
                            <div class="grid gap-6 sm:grid-cols-2">
                                <div class="sm:col-span-2">
                                    <label for="fullName" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Legal Full Name</label>
                                    <div class="relative group">
                                        <i data-lucide="user" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                        <input id="fullName" type="text" name="fullName" value="<%= fullName %>" placeholder="Johnathan Doe" required class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20">
                                    </div>
                                </div>

                                <div class="sm:col-span-2">
                                    <label for="email" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Digital Identity (Email)</label>
                                    <div class="relative group">
                                        <i data-lucide="mail" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                        <input id="email" type="email" name="email" value="<%= email %>" placeholder="name@domain.com" required class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-12 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20">
                                        <div class="absolute right-4 top-1/2 -translate-y-1/2 h-5 w-5 rounded-full bg-brand-900 flex items-center justify-center">
                                            <i data-lucide="check" class="h-2.5 w-2.5 text-white stroke-[4]"></i>
                                        </div>
                                    </div>
                                </div>

                                <div class="sm:col-span-1">
                                    <label for="phone" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Phone Line</label>
                                    <input id="phone" type="tel" name="phone" value="<%= phone %>" placeholder="98XXXXXXXX" required class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20">
                                </div>

                                <div class="sm:col-span-1">
                                    <label for="dateOfBirth" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Birth Record</label>
                                    <input id="dateOfBirth" type="date" name="dateOfBirth" value="<%= dateOfBirth %>" required class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20">
                                </div>

                                <div class="sm:col-span-2">
                                    <label class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Gender Identification</label>
                                    <div class="role-toggle bg-slate-100 rounded-2xl p-1.5 flex gap-1 border border-slate-200/50">
                                        <button type="button" class="gender-toggle flex-1 py-3 text-center text-xs font-black rounded-xl transition-all" data-value="M">MALE</button>
                                        <button type="button" class="gender-toggle flex-1 py-3 text-center text-xs font-black rounded-xl transition-all" data-value="F">FEMALE</button>
                                        <button type="button" class="gender-toggle flex-1 py-3 text-center text-xs font-black rounded-xl transition-all" data-value="O">OTHER</button>
                                        <input type="hidden" name="gender" id="gender-input" value="<%= gender %>">
                                    </div>
                                </div>

                                <div class="sm:col-span-2">
                                    <label for="password" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Security Key (Password)</label>
                                    <div class="relative group">
                                        <i data-lucide="shield-check" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                        <input id="password" type="password" name="password" required class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-16 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20">
                                        <button type="button" class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-brand-900" data-target="password">Show</button>
                                    </div>
                                    <p class="mt-3 text-[10px] font-bold text-slate-400 uppercase tracking-widest leading-none flex items-center gap-1.5 ml-1">
                                        <i data-lucide="info" class="h-3 w-3"></i>
                                        Complexity: Multi-character minimum
                                    </p>
                                </div>
                            </div>

                            <button type="submit" class="w-full rounded-2xl bg-brand-900 py-5 text-sm font-black text-white shadow-xl shadow-brand-900/20 active:scale-[0.98] transition-all hover:bg-slate-900 flex items-center justify-center gap-3 mt-4">
                                Complete Enlistment
                                <i data-lucide="chevron-right" class="h-4 w-4"></i>
                            </button>
                        </form>

                        <div class="mt-10 pt-8 border-t border-slate-50 text-center">
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-4">Already enlisted?</p>
                            <a href="<%= request.getContextPath() %>/login" class="inline-flex items-center gap-2 rounded-xl bg-brand-50 px-8 py-3.5 text-xs font-black text-brand-900 hover:bg-brand-100 transition-colors">
                                Identity Verification (Login)
                            </a>
                        </div>
                    </div>

                    <div class="mt-12 flex items-center justify-center gap-3 text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400 opacity-60">
                        <i data-lucide="shield" class="h-3 w-3"></i>
                        Administrative Sovereignty &bull; AES-256
                    </div>
                </div>
            </section>
        </div>
        <script>
            const toggleButtons = document.querySelectorAll(".gender-toggle");
            const genderInput = document.getElementById("gender-input");
            
            function setActiveGender(activeButton) {
                toggleButtons.forEach((button) => {
                    const isActive = button === activeButton;
                    button.classList.toggle("bg-white", isActive);
                    button.classList.toggle("text-brand-900", isActive);
                    button.classList.toggle("shadow-sm", isActive);
                    button.classList.toggle("text-slate-400", !isActive);
                });
                genderInput.value = activeButton.dataset.value;
            }

            toggleButtons.forEach((button) => {
                button.addEventListener("click", () => setActiveGender(button));
                if (button.dataset.value === "<%= gender %>") {
                    setActiveGender(button);
                }
            });

            document.querySelectorAll(".password-toggle").forEach((button) => {
                button.addEventListener("click", () => {
                    const input = document.getElementById(button.dataset.target);
                    const isPass = input.type === "password";
                    input.type = isPass ? "text" : "password";
                    button.textContent = isPass ? "Hide" : "Show";
                });
            });

            lucide.createIcons();
        </script>
    </body>
        <script>
            const toggleButtons = document.querySelectorAll(".gender-toggle");
            const genderInput = document.getElementById("gender-input");
            function setActiveGender(activeButton) {
            toggleButtons.forEach((button) => {
            const isActive = button === activeButton;
            button.classList.toggle("bg-white", isActive);
            button.classList.toggle("text-slate-800", isActive);
            button.classList.toggle("shadow-sm", isActive);
            button.classList.toggle("text-slate-500", !isActive);
            button.classList.toggle("hover:text-slate-700", !isActive);
            });
            genderInput.value = activeButton.dataset.value;
            }
            toggleButtons.forEach((button) => {
            button.addEventListener("click", () => setActiveGender(button));
            if (button.dataset.value === "
            <%= gender %>
            ") {
            setActiveGender(button);
            }
            });
            document.querySelectorAll(".password-toggle").forEach((button) => {
            button.addEventListener("click", () => {
            const input = document.getElementById(button.dataset.target);
            const showPassword = input.type === "password";
            input.type = showPassword ? "text" : "password";
            button.textContent = showPassword ? "Hide" : "Show";
            button.setAttribute("aria-label", showPassword ? "Hide password" : "Show password");
            button.setAttribute("aria-pressed", String(showPassword));
            });
            });
        </script>
    </body>
</html>
