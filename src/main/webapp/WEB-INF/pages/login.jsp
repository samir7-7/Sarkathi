<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
            SarkarSathi - Login
        </title>
        <script src="https://cdn.tailwindcss.com">
        </script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap');
            body { font-family: 'Outfit', sans-serif; }
            /* Role toggle */
            .role-toggle {
            position: relative;
            display: flex;
            background: #eef1f6;
            border-radius: 14px;
            padding: 4px;
            }
            .role-toggle input[type="radio"] { display: none; }
            .role-toggle label {
            flex: 1;
            text-align: center;
            padding: 10px 0;
            font-size: 14px;
            font-weight: 600;
            color: #64748b;
            cursor: pointer;
            border-radius: 11px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1;
            user-select: none;
            }
            .role-toggle input[type="radio"]:checked + label {
            color: #fff;
            background: #154a91;
            box-shadow: 0 2px 12px rgba(21, 74, 145, 0.35);
            }
            /* Shake animation for error */
            @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-6px); }
            40%, 80% { transform: translateX(6px); }
            }
            .shake { animation: shake 0.4s ease-in-out; }
            /* Fade in */
            @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
            }
            .fade-in { animation: fadeInUp 0.5s ease-out forwards; }
        </style>
            <%@ include file="../includes/lucide-icons.jsp" %>
    </head>
    <body class="min-h-screen bg-slate-50 text-slate-900 antialiased overflow-x-hidden selection:bg-brand-100 selection:text-brand-900">
        <% 
            String error = (String) request.getAttribute("error"); 
            if (error == null) { error = request.getParameter("error"); } 
            String userType = (String) request.getAttribute("userType"); 
            if (userType == null || userType.isBlank()) { userType = request.getParameter("userType"); } 
            if (userType == null || userType.isBlank()) { userType = "citizen"; } 
            String email = (String) request.getAttribute("email"); 
            if (email == null) { email = request.getParameter("email"); } 
            if (email == null) { email = ""; } 
            String registered = request.getParameter("registered"); 
        %>
        <div class="flex min-h-screen flex-col lg:flex-row">
            <!-- Left Branding Section -->
            <section class="relative hidden overflow-hidden lg:flex lg:w-1/2">
                <img src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1600&auto=format&fit=crop" alt="City infrastructure" class="absolute inset-0 h-full w-full object-cover">
                <div class="absolute inset-0 bg-[#0b3d86]/90"></div>
                <div class="absolute inset-0 bg-gradient-to-br from-[#0b3d86]/60 via-transparent to-[#0b3d86]/90"></div>
                <div class="relative flex h-full w-full flex-col justify-between px-16 py-20 text-white">
                    <div class="max-w-xl">
                        <a href="<%= request.getContextPath() %>" class="flex items-center gap-2 text-3xl font-black tracking-tight text-white mb-12">
                            Sarkar<span class="text-blue-300">Sathi</span>
                        </a>
                        <h1 class="text-5xl font-black leading-tight tracking-[0.02em] mb-8">
                            Empowering<br/>Citizens,<br/>Elevating Cities.
                        </h1>
                        <p class="text-xl leading-relaxed text-blue-100/80 font-medium max-w-md">
                            Connect with your municipal government through our unified platform. Modern governance, simplified for you.
                        </p>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="h-1px flex-1 bg-white/20"></div>
                        <span class="text-[10px] font-bold uppercase tracking-[0.3em] text-white/40">Official Portal Access</span>
                        <div class="h-1px flex-1 bg-white/20"></div>
                    </div>
                </div>
            </section>

            <!-- Right Login Section -->
            <section class="flex flex-1 flex-col items-center justify-center p-6 sm:p-12 lg:p-20 relative">
                <!-- Mobile Branding -->
                <div class="w-full max-w-md lg:hidden mb-12 text-center">
                    <a href="<%= request.getContextPath() %>" class="text-3xl font-black tracking-tight text-brand-900">
                        Sarkar<span class="text-blue-600">Sathi</span>
                    </a>
                </div>

                <div class="w-full max-w-[420px] fade-in">
                    <div class="mb-10 text-center lg:text-left">
                        <div class="mx-auto lg:mx-0 h-16 w-16 flex items-center justify-center rounded-[1.5rem] bg-brand-900 text-white shadow-2xl shadow-brand-900/20 mb-8">
                            <i data-lucide="shield-check" class="h-8 w-8 text-blue-100"></i>
                        </div>
                        <h2 class="text-3xl font-black text-slate-900 tracking-tight mb-3">Identification Required</h2>
                        <p class="text-slate-500 font-medium leading-relaxed">Secure gateway to administrative services. Please verify your credentials to continue.</p>
                    </div>

                    <div class="rounded-[2.5rem] bg-white p-8 sm:p-10 shadow-2xl shadow-slate-200/60 border border-slate-100">
                        <% if ("success".equals(registered)) { %>
                            <div class="mb-6 flex items-center gap-3 rounded-2xl border border-emerald-100 bg-emerald-50 px-4 py-3 text-sm font-bold text-emerald-700">
                                <i data-lucide="check-circle-2" class="h-5 w-5 text-emerald-600"></i>
                                Registration successful. Please login.
                            </div>
                        <% } %>

                        <% if (error != null) { %>
                            <div id="error-alert" class="mb-6 flex items-center gap-3 rounded-2xl border border-red-100 bg-red-50 px-4 py-4 text-sm font-bold text-red-700 shake">
                                <i data-lucide="alert-circle" class="h-5 w-5 text-red-600"></i>
                                <%= error %>
                            </div>
                        <% } %>

                        <!-- Action Selection Toggle -->
                        <div class="mb-8">
                            <label class="mb-2 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Access Tier</label>
                            <div class="role-toggle bg-slate-100 rounded-2xl p-1.5 flex gap-1 border border-slate-200/50">
                                <input type="radio" name="roleToggle" id="role-citizen" value="citizen" <%= "citizen".equalsIgnoreCase(userType) ? "checked" : "" %> class="hidden peer/citizen">
                                <label for="role-citizen" class="flex-1 py-3 text-center text-sm font-bold text-slate-500 rounded-xl cursor-pointer transition-all peer-checked/citizen:bg-white peer-checked/citizen:text-brand-900 peer-checked/citizen:shadow-sm">
                                    Citizen
                                </label>
                                
                                <input type="radio" name="roleToggle" id="role-admin" value="admin" <%= "admin".equalsIgnoreCase(userType) ? "checked" : "" %> class="hidden peer/admin">
                                <label for="role-admin" class="flex-1 py-3 text-center text-sm font-bold text-slate-500 rounded-xl cursor-pointer transition-all peer-checked/admin:bg-white peer-checked/admin:text-brand-900 peer-checked/admin:shadow-sm">
                                    Admin
                                </label>
                            </div>
                        </div>

                        <form id="login-form" action="<%= request.getContextPath() %>/login" method="post" class="space-y-5">
                            <input type="hidden" name="userType" id="userType" value="<%= userType %>">
                            
                            <div>
                                <label for="email" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Digital ID (Email)</label>
                                <div class="relative group">
                                    <i data-lucide="mail" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                    <input id="email" type="email" name="email" value="<%= email %>" placeholder="user@domain.com" required class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20">
                                </div>
                            </div>

                            <div>
                                <div class="mb-1.5 flex items-center justify-between ml-1">
                                    <label for="password" class="block text-[10px] font-extrabold uppercase tracking-widest text-slate-400">Security Key</label>
                                    <a href="#" class="text-[10px] font-extrabold uppercase tracking-widest text-brand-600 hover:text-brand-900">Recovery</a>
                                </div>
                                <div class="relative group">
                                    <i data-lucide="lock" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                    <input id="password" type="password" name="password" placeholder="••••••••••••" required class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-16 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20">
                                    <button type="button" class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-brand-900" data-target="password">Show</button>
                                </div>
                            </div>

                            <button type="submit" id="login-btn" class="w-full rounded-2xl bg-[#154A91] py-5 text-sm font-black text-white shadow-xl shadow-brand-900/20 active:scale-[0.98] transition-all hover:bg-slate-900 flex items-center justify-center gap-3">
                                <span id="btn-text">Authenticate Access</span>
                                <i data-lucide="arrow-right" class="h-4 w-4"></i>
                            </button>
                        </form>

                        <div id="register-link" class="mt-8 pt-8 border-t border-slate-50 text-center" <%= "admin".equalsIgnoreCase(userType) ? "style='display: none;'" : "" %>>
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-4">New to the platform?</p>
                            <a href="<%= request.getContextPath() %>/register.jsp" class="inline-flex items-center gap-2 rounded-xl bg-brand-50 px-6 py-3 text-xs font-xl text-[#0c8ce9] hover:bg-brand-100 transition-colors">
                                <i data-lucide="user-plus" class="h-4 w-4"></i>
                                Create Citizen Account
                            </a>
                        </div>
                    </div>

                    <div class="mt-12 flex items-center justify-center gap-3 text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400 opacity-60">
                        <i data-lucide="globe" class="h-3 w-3"></i>
                        Unified Systems &bull; High Encryption
                    </div>
                </div>
            </section>
        </div>
        <script>
            document.querySelectorAll(".password-toggle").forEach((button) => {
                button.addEventListener("click", () => {
                    const input = document.getElementById(button.dataset.target);
                    const isPass = input.type === "password";
                    input.type = isPass ? "text" : "password";
                    button.textContent = isPass ? "Hide" : "Show";
                });
            });

            const citizenRadio = document.getElementById('role-citizen');
            const adminRadio = document.getElementById('role-admin');
            const userTypeInput = document.getElementById('userType');
            const btnText = document.getElementById('btn-text');
            const registerLink = document.getElementById('register-link');

            function updateRole() {
                if (adminRadio.checked) {
                    userTypeInput.value = 'admin';
                    btnText.textContent = 'Admin Verification';
                    registerLink.style.display = 'none';
                } else {
                    userTypeInput.value = 'citizen';
                    btnText.textContent = 'Authenticate Access';
                    registerLink.style.display = 'block';
                }
            }

            citizenRadio.addEventListener('change', updateRole);
            adminRadio.addEventListener('change', updateRole);
            updateRole();

            lucide.createIcons();
        </script>
    </body>
        <script>
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
            // Role toggle logic
            const citizenRadio = document.getElementById('role-citizen');
            const adminRadio = document.getElementById('role-admin');
            const userTypeInput = document.getElementById('userType');
            const btnText = document.getElementById('btn-text');
            const registerLink = document.getElementById('register-link');
            function updateRole() {
            if (adminRadio.checked) {
            userTypeInput.value = 'admin';
            btnText.textContent = 'Login as Admin';
            registerLink.style.display = 'none';
            } else {
            userTypeInput.value = 'citizen';
            btnText.textContent = 'Login to Dashboard';
            registerLink.style.display = 'block';
            }
            }
            citizenRadio.addEventListener('change', updateRole);
            adminRadio.addEventListener('change', updateRole);
            // Preserve selection after error
            updateRole();
            var userType = '<%= userType %>';
            if (userType === 'admin') {
            adminRadio.checked = true;
            updateRole();
            }
        </script>
    </body>
</html>
