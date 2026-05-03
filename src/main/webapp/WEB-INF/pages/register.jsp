<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SarkarSathi - Register</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            .field-error {
            margin: 0.5rem 0 0 0.25rem;
            font-size: 0.75rem;
            font-weight: 700;
            color: #dc2626;
            }
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
                                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=120&auto=format&fit=crop" alt="" class="h-12 w-12 rounded-full border-2 border-white/20 object-cover">
                                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=120&auto=format&fit=crop" alt="" class="h-12 w-12 rounded-full border-2 border-white/20 object-cover">
                                <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=120&auto=format&fit=crop" alt="" class="h-12 w-12 rounded-full border-2 border-white/20 object-cover">
                            </div>
                            <div class="h-8 w-1px bg-white/20"></div>
                            <p class="text-sm font-black uppercase tracking-widest text-white/70">Social Contract Secured</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="flex flex-1 flex-col items-center justify-center p-6 sm:p-12 lg:p-20 relative overflow-y-auto">
                <div class="w-full max-w-md lg:hidden mb-12 text-center">
                    <a href="<%= request.getContextPath() %>" class="text-3xl font-black tracking-tight text-brand-900">
                        Sarkar<span class="text-blue-600">Sathi</span>
                    </a>
                </div>

                <div class="w-full max-w-[480px] fade-in py-8">
                    <div class="mb-10 text-center lg:text-left">
                        <h2 class="text-3xl font-black text-slate-900 tracking-tight mb-3">Register Portal</h2>
                        <p class="text-slate-500 font-medium whitespace-nowrap overflow-hidden text-ellipsis">Begin your journey as an active municipal participant.</p>
                    </div>

                    <div class="rounded-[2.5rem] bg-white p-8 sm:p-10 shadow-2xl shadow-slate-200/60 border border-slate-100">
                        <% if (error != null && !error.isBlank()) { %>
                            <div class="mb-8 flex items-center gap-3 rounded-2xl border border-red-100 bg-red-50 px-4 py-4 text-sm font-bold text-red-700">
                                <i data-lucide="alert-circle" class="h-5 w-5 text-red-600"></i>
                                <%= error %>
                            </div>
                        <% } %>

                        <form id="register-form" action="<%= request.getContextPath() %>/register" method="post" class="space-y-6" novalidate>
                            <div class="grid gap-6 sm:grid-cols-2">
                                <div class="sm:col-span-2">
                                    <label for="fullName" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Legal Full Name</label>
                                    <div class="relative group">
                                        <i data-lucide="user" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                        <input id="fullName" type="text" name="fullName" value="<%= fullName %>" placeholder="Sujan Subedi" required minlength="3" maxlength="100" autocomplete="name" class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20" aria-describedby="fullName-error">
                                    </div>
                                    <p id="fullName-error" class="field-error hidden"></p>
                                </div>

                                <div class="sm:col-span-2">
                                    <label for="email" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Digital Identity (Email)</label>
                                    <div class="relative group">
                                        <i data-lucide="mail" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                        <input id="email" type="email" name="email" value="<%= email %>" placeholder="name@domain.com" required maxlength="254" autocomplete="email" class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-12 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20" aria-describedby="email-error">
                                        <div class="absolute right-4 top-1/2 -translate-y-1/2 h-5 w-5 rounded-full bg-brand-900 flex items-center justify-center">
                                            <i data-lucide="check" class="h-2.5 w-2.5 text-white stroke-[4]"></i>
                                        </div>
                                    </div>
                                    <p id="email-error" class="field-error hidden"></p>
                                </div>

                                <div class="sm:col-span-1">
                                    <label for="phone" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Phone Line</label>
                                    <input id="phone" type="tel" name="phone" value="<%= phone %>" placeholder="98XXXXXXXX" required inputmode="numeric" minlength="10" maxlength="10" pattern="\d{10}" autocomplete="tel" class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20" aria-describedby="phone-error">
                                    <p id="phone-error" class="field-error hidden"></p>
                                </div>

                                <div class="sm:col-span-1">
                                    <label for="dateOfBirth" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Birth Record</label>
                                    <input id="dateOfBirth" type="date" name="dateOfBirth" value="<%= dateOfBirth %>" required class="w-full rounded-2xl border-0 bg-slate-50 px-5 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20" aria-describedby="dateOfBirth-error">
                                    <p id="dateOfBirth-error" class="field-error hidden"></p>
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
                                        <input id="password" type="password" name="password" required minlength="8" maxlength="72" autocomplete="new-password" class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-16 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20" aria-describedby="password-error password-hint">
                                        <button type="button" class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-brand-900" data-target="password" aria-label="Show password" aria-pressed="false">Show</button>
                                    </div>
                                    <p id="password-error" class="field-error hidden"></p>
                                    <p id="password-hint" class="mt-3 text-[10px] font-bold text-slate-400 uppercase tracking-widest leading-none flex items-center gap-1.5 ml-1">
                                        <i data-lucide="info" class="h-3 w-3"></i>
                                        Minimum 8 characters with letters and numbers
                                    </p>
                                </div>

                                <div class="sm:col-span-2">
                                    <label for="confirmPassword" class="mb-1.5 block text-[10px] font-extrabold uppercase tracking-widest text-slate-400 ml-1">Confirm Security Key</label>
                                    <div class="relative group">
                                        <i data-lucide="lock-keyhole" class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-300 group-focus-within:text-brand-500 transition-colors"></i>
                                        <input id="confirmPassword" type="password" name="confirmPassword" required minlength="8" maxlength="72" autocomplete="new-password" class="w-full rounded-2xl border-0 bg-slate-50 pl-12 pr-16 py-4 text-sm font-bold text-slate-900 focus:bg-white focus:ring-2 focus:ring-brand-500 transition-all outline-none border border-transparent focus:border-brand-500/20" aria-describedby="confirmPassword-error">
                                        <button type="button" class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-brand-900" data-target="confirmPassword" aria-label="Show password" aria-pressed="false">Show</button>
                                    </div>
                                    <p id="confirmPassword-error" class="field-error hidden"></p>
                                </div>
                            </div>

                            <button type="submit" class="w-full rounded-2xl bg-[#154A91] py-5 text-sm font-black text-white shadow-xl shadow-brand-900/20 active:scale-[0.98] transition-all hover:bg-slate-900 flex items-center justify-center gap-3 mt-4">
                                Complete Signup
                                <i data-lucide="chevron-right" class="h-4 w-4"></i>
                            </button>
                        </form>

                        <div class="mt-10 pt-8 border-t border-slate-50 text-center">
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-4">Already enlisted?</p>
                            <a href="<%= request.getContextPath() %>/login" class="inline-flex items-center gap-2 rounded-xl bg-brand-50 px-8 py-3.5 text-xs font-black text-[#0c8ce9] hover:bg-brand-100 transition-colors">
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
            const registerForm = document.getElementById("register-form");
            const fullNameInput = document.getElementById("fullName");
            const emailInput = document.getElementById("email");
            const phoneInput = document.getElementById("phone");
            const dateOfBirthInput = document.getElementById("dateOfBirth");
            const passwordInput = document.getElementById("password");
            const confirmPasswordInput = document.getElementById("confirmPassword");
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const namePattern = /^[A-Za-z][A-Za-z\s'.-]{1,98}[A-Za-z]$/;
            const phonePattern = /^[0-9]{10}$/;
            const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d).{8,72}$/;

            function formatDate(date) {
            const month = String(date.getMonth() + 1).padStart(2, "0");
            const day = String(date.getDate()).padStart(2, "0");
            return date.getFullYear() + "-" + month + "-" + day;
            }

            function addYears(date, years) {
            const copy = new Date(date);
            copy.setFullYear(copy.getFullYear() + years);
            return copy;
            }

            const today = new Date();
            dateOfBirthInput.max = formatDate(addYears(today, -16));
            dateOfBirthInput.min = formatDate(addYears(today, -120));

            function setFieldError(input, message) {
            const error = document.getElementById(input.id + "-error");
            input.classList.toggle("ring-2", Boolean(message));
            input.classList.toggle("ring-red-500", Boolean(message));
            input.classList.toggle("bg-white", Boolean(message));
            input.setAttribute("aria-invalid", String(Boolean(message)));
            if (error) {
            error.textContent = message;
            error.classList.toggle("hidden", !message);
            }
            }

            function validateRegisterField(input) {
            const value = input.value.trim();
            if (input === fullNameInput) {
            if (!value) return setInvalid(input, "Full name is required.");
            if (value.length < 3 || value.length > 100) return setInvalid(input, "Full name must be 3 to 100 characters.");
            if (!namePattern.test(value)) return setInvalid(input, "Use letters, spaces, apostrophes, periods, or hyphens only.");
            }
            if (input === emailInput) {
            if (!value) return setInvalid(input, "Email is required.");
            if (!emailPattern.test(value)) return setInvalid(input, "Enter a valid email address.");
            }
            if (input === phoneInput) {
            input.value = input.value.replace(/\D/g, "").slice(0, 10);
            if (!input.value) return setInvalid(input, "Phone number is required.");
            if (!phonePattern.test(input.value)) return setInvalid(input, "Phone number must contain exactly 10 digits.");
            }
            if (input === dateOfBirthInput) {
            if (!value) return setInvalid(input, "Date of birth is required.");
            if (value < dateOfBirthInput.min || value > dateOfBirthInput.max) return setInvalid(input, "Citizen age must be between 16 and 120 years.");
            }
            if (input === passwordInput) {
            if (!input.value) return setInvalid(input, "Password is required.");
            if (!passwordPattern.test(input.value)) return setInvalid(input, "Use at least 8 characters with letters and numbers.");
            if (confirmPasswordInput.value) validateRegisterField(confirmPasswordInput);
            }
            if (input === confirmPasswordInput) {
            if (!input.value) return setInvalid(input, "Please confirm your password.");
            if (input.value !== passwordInput.value) return setInvalid(input, "Passwords do not match.");
            }
            setFieldError(input, "");
            return true;
            }

            function setInvalid(input, message) {
            setFieldError(input, message);
            return false;
            }

            [fullNameInput, emailInput, phoneInput, dateOfBirthInput, passwordInput, confirmPasswordInput].forEach((input) => {
            input.addEventListener("input", () => validateRegisterField(input));
            input.addEventListener("blur", () => validateRegisterField(input));
            });

            registerForm.addEventListener("submit", (event) => {
            const fields = [fullNameInput, emailInput, phoneInput, dateOfBirthInput, passwordInput, confirmPasswordInput];
            const valid = fields.every(validateRegisterField);
            if (!valid) {
            event.preventDefault();
            const firstInvalid = fields.find((input) => input.getAttribute("aria-invalid") === "true");
            if (firstInvalid) firstInvalid.focus();
            }
            });

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
            const showPassword = input.type === "password";
            input.type = showPassword ? "text" : "password";
            button.textContent = showPassword ? "Hide" : "Show";
            button.setAttribute("aria-label", showPassword ? "Hide password" : "Show password");
            button.setAttribute("aria-pressed", String(showPassword));
            });
            });

            lucide.createIcons();
        </script>
    </body>
</html>
