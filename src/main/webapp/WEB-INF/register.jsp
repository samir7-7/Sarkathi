<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SarkarSathi - Register</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-100 text-slate-900">
    <% String error = request.getParameter("error"); %>
    <div class="flex min-h-screen flex-col">
        <main class="grid flex-1 lg:grid-cols-2">
            <section class="relative hidden overflow-hidden lg:flex">
                <img
                    src="https://images.unsplash.com/photo-1511818966892-d7d671e672a2?q=80&w=1600&auto=format&fit=crop"
                    alt="Municipal building"
                    class="absolute inset-0 h-full w-full object-cover"
                >
                <div class="absolute inset-0 bg-[#0f63a8]/78"></div>
                <div class="absolute inset-0 bg-gradient-to-b from-[#2c86ca]/30 via-[#0b5ea8]/35 to-[#083d76]/88"></div>

                <div class="relative flex h-full w-full flex-col justify-between px-12 py-16 text-white">
                    <div class="max-w-xl pt-8">
                        <h1 class="text-5xl lg:text-6xl font-bold leading-tight tracking-tight">
                            Join<br>
                            SarkarSathi:<br>
                            Empowering<br>
                            Your Civic<br>
                            Journey
                        </h1>
                        <p class="mt-8 max-w-lg text-lg leading-relaxed text-blue-100/90">
                            A modern bridge between citizens and municipal excellence. Secure, fast, and accessible for everyone.
                        </p>
                    </div>

                    <div class="flex items-center gap-4 pb-8">
                        <div class="flex -space-x-2">
                            <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=120&auto=format&fit=crop" alt="Citizen" class="h-10 w-10 rounded-full border-2 border-white/90 object-cover">
                            <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=120&auto=format&fit=crop" alt="Citizen" class="h-10 w-10 rounded-full border-2 border-white/90 object-cover">
                            <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=120&auto=format&fit=crop" alt="Citizen" class="h-10 w-10 rounded-full border-2 border-white/90 object-cover">
                        </div>
                        <p class="text-sm font-semibold tracking-wide text-white">+10k Citizens Joined This Week</p>
                    </div>
                </div>
            </section>

            <section class="flex items-center justify-center bg-[#f7f7fb] px-6 py-10 lg:px-12">
                <div class="w-full max-w-lg">
                    <div>
                        <h2 class="text-3xl font-bold tracking-tight text-slate-900 sm:text-4xl">Create Your Citizen Account</h2>
                        <p class="mt-3 text-base text-slate-600">Complete the form below to access municipal services.</p>
                    </div>

                    <div class="mt-8">
                        <% if (error != null && !error.isBlank()) { %>
                            <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-800">
                                <%= error %>
                            </div>
                        <% } %>
                        <form action="${pageContext.request.contextPath}/api/auth/register/citizen" method="post" class="space-y-5">
                            <div>
                                <label for="fullName" class="mb-2 block text-sm font-medium text-slate-700">Full Name</label>
                                <input
                                    id="fullName"
                                    type="text"
                                    name="fullName"
                                    placeholder="John Doe"
                                    required
                                    class="w-full rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100"
                                >
                            </div>

                            <div>
                                <label for="email" class="mb-2 block text-sm font-medium text-slate-700">Email Address</label>
                                <div class="relative">
                                    <input
                                        id="email"
                                        type="email"
                                        name="email"
                                        placeholder="name@domain.com"
                                        required
                                        class="w-full rounded-xl border border-slate-200 bg-white px-4 py-3 pr-12 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100"
                                    >
                                    <span class="pointer-events-none absolute right-3 top-1/2 flex h-6 w-6 -translate-y-1/2 items-center justify-center rounded-full bg-[#1f7a2e] text-white">
                                        <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                    </span>
                                </div>
                            </div>

                            <div>
                                <label for="phone" class="mb-2 block text-sm font-medium text-slate-700">Phone Number</label>
                                <input
                                    id="phone"
                                    type="tel"
                                    name="phone"
                                    placeholder="+977-9800000000"
                                    required
                                    class="w-full rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100"
                                >
                            </div>

                            <div>
                                <label for="password" class="mb-2 block text-sm font-medium text-slate-700">Password</label>
                                <div class="relative">
                                    <input
                                        id="password"
                                        type="password"
                                        name="password"
                                        required
                                        class="w-full rounded-xl border border-slate-200 bg-white px-4 py-3 pr-16 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100"
                                    >
                                    <button
                                        type="button"
                                        class="password-toggle absolute right-3 top-1/2 -translate-y-1/2 text-sm font-semibold text-slate-500 transition hover:text-[#154a91]"
                                        data-target="password"
                                        aria-label="Show password"
                                        aria-pressed="false"
                                    >
                                        Show
                                    </button>
                                </div>
                                <p class="mt-2 text-xs text-slate-500">Must be at least 8 characters, with one uppercase and one symbol.</p>
                            </div>

                            <div class="grid gap-5 md:grid-cols-[1fr_1.1fr]">
                                <div>
                                    <label for="dateOfBirth" class="mb-2 block text-sm font-medium text-slate-700">Date of Birth</label>
                                    <div class="relative">
                                        <span class="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">
                                            <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                        </span>
                                        <input
                                            id="dateOfBirth"
                                            type="date"
                                            name="dateOfBirth"
                                            required
                                            class="w-full rounded-xl border border-slate-200 bg-white py-3 pl-10 pr-3 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100"
                                        >
                                    </div>
                                </div>

                                <div>
                                    <span class="mb-2 block text-sm font-medium text-slate-700">Gender</span>
                                    <div class="grid grid-cols-3 rounded-xl bg-slate-100 p-1">
                                        <button type="button" class="gender-toggle rounded-lg bg-white px-2 py-2 text-sm font-medium text-slate-800 shadow-sm transition" data-value="M">Male</button>
                                        <button type="button" class="gender-toggle rounded-lg px-2 py-2 text-sm font-medium text-slate-500 hover:text-slate-700 transition" data-value="F">Female</button>
                                        <button type="button" class="gender-toggle rounded-lg px-2 py-2 text-sm font-medium text-slate-500 hover:text-slate-700 transition" data-value="O">Other</button>
                                        <input type="hidden" name="gender" id="gender-input" value="M">
                                    </div>
                                </div>
                            </div>

                            <button
                                type="submit"
                                class="inline-flex w-full items-center justify-center rounded-xl bg-[#154a91] px-5 py-3 text-base font-semibold text-white shadow-md transition hover:bg-[#103b74] focus:outline-none focus:ring-2 focus:ring-blue-200 focus:ring-offset-1"
                            >
                                Register
                            </button>
                        </form>

                        <div class="mt-8 text-center text-sm text-slate-600">
                            Already have an account?
                            <a href="login.jsp" class="ml-1 font-semibold text-[#0b3d86] transition hover:text-[#154a91]">Login</a>
                        </div>
                    </div>
                </div>
            </section>
        </main>


    </div>

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
