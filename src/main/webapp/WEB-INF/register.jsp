<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SarkarSathi - Register</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: "#eff6ff",
                            100: "#dbeafe",
                            500: "#2563eb",
                            600: "#1d4ed8",
                            700: "#1e40af",
                            900: "#172554"
                        }
                    },
                    boxShadow: {
                        soft: "0 24px 80px rgba(15, 23, 42, 0.14)"
                    }
                }
            }
        };
    </script>
</head>
<body class="min-h-screen bg-slate-950 text-slate-900">
    <div class="relative isolate overflow-hidden">
        <div class="absolute inset-0 bg-[radial-gradient(circle_at_top_right,_rgba(37,99,235,0.26),_transparent_34%),radial-gradient(circle_at_bottom_left,_rgba(16,185,129,0.18),_transparent_28%),linear-gradient(155deg,_#020617_0%,_#0f172a_48%,_#111827_100%)]"></div>
        <div class="relative mx-auto flex min-h-screen max-w-7xl flex-col px-6 py-8 lg:px-10">
            <div class="grid flex-1 overflow-hidden rounded-[2rem] border border-white/10 bg-white/8 shadow-soft backdrop-blur xl:grid-cols-[0.95fr_1.05fr]">
                <section class="flex flex-col justify-between border-b border-white/10 px-8 py-10 text-white xl:border-b-0 xl:border-r xl:px-12 xl:py-12">
                    <div>
                        <div class="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-4 py-2 text-xs font-semibold uppercase tracking-[0.24em] text-sky-100">
                            <span class="h-2 w-2 rounded-full bg-sky-300"></span>
                            Citizen Onboarding
                        </div>
                        <h1 class="mt-8 max-w-md text-4xl font-semibold leading-tight sm:text-5xl">Join SarkarSathi and power your civic journey.</h1>
                        <p class="mt-6 max-w-xl text-base leading-7 text-slate-200 sm:text-lg">
                            A modern bridge between citizens and municipal excellence. Secure, fast, and accessible for everyone.
                        </p>
                    </div>

                    <div class="space-y-6">
                        <div class="flex items-center gap-4">
                            <div class="flex -space-x-3">
                                <img src="images/avatar.png" alt="Citizen" class="h-12 w-12 rounded-full border-2 border-slate-900/80 object-cover">
                                <img src="images/avatar.png" alt="Citizen" class="h-12 w-12 rounded-full border-2 border-slate-900/80 object-cover">
                                <img src="images/avatar.png" alt="Citizen" class="h-12 w-12 rounded-full border-2 border-slate-900/80 object-cover">
                            </div>
                            <p class="text-sm font-medium text-slate-200">+10k citizens joined this week</p>
                        </div>

                        <div class="grid gap-3 text-sm text-slate-200 sm:grid-cols-2">
                            <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                                <p class="font-semibold text-white">Single Account</p>
                                <p class="mt-2 leading-6 text-slate-300">Access permits, registrations, notices, and local updates from one secure profile.</p>
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                                <p class="font-semibold text-white">Citizen Ready</p>
                                <p class="mt-2 leading-6 text-slate-300">Designed for quick onboarding with mobile-friendly forms and transparent workflows.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="bg-white px-6 py-10 sm:px-10 xl:px-12">
                    <div class="mx-auto w-full max-w-2xl">
                        <div class="text-center xl:text-left">
                            <h2 class="text-3xl font-semibold tracking-tight text-slate-900">Create Your Citizen Account</h2>
                            <p class="mt-3 text-sm leading-6 text-slate-600">Complete the form below to access municipal services.</p>
                        </div>

                        <div class="mt-8 rounded-3xl border border-slate-200 bg-white p-6 shadow-2xl shadow-slate-200/70 sm:p-8">
                            <form action="${pageContext.request.contextPath}/api/auth/register/citizen" method="post" class="space-y-5">
                                <div>
                                    <label for="fullName" class="mb-2 block text-sm font-medium text-slate-700">Full Name</label>
                                    <input id="fullName" type="text" name="fullName" placeholder="John Doe" required
                                           class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3.5 text-sm text-slate-900 outline-none transition focus:border-brand-500 focus:bg-white focus:ring-4 focus:ring-brand-100">
                                </div>

                                <div>
                                    <label for="email" class="mb-2 block text-sm font-medium text-slate-700">Email Address</label>
                                    <div class="relative">
                                        <input id="email" type="email" name="email" placeholder="name@domain.com" required
                                               class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3.5 pr-12 text-sm text-slate-900 outline-none transition focus:border-brand-500 focus:bg-white focus:ring-4 focus:ring-brand-100">
                                        <svg class="pointer-events-none absolute right-4 top-1/2 h-5 w-5 -translate-y-1/2 text-brand-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                    </div>
                                </div>

                                <div>
                                    <label for="phone" class="mb-2 block text-sm font-medium text-slate-700">Phone Number</label>
                                    <input id="phone" type="tel" name="phone" placeholder="+977-9800000000" required
                                           class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3.5 text-sm text-slate-900 outline-none transition focus:border-brand-500 focus:bg-white focus:ring-4 focus:ring-brand-100">
                                </div>

                                <div>
                                    <label for="password" class="mb-2 block text-sm font-medium text-slate-700">Password</label>
                                    <input id="password" type="password" name="password" required
                                           class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3.5 text-sm text-slate-900 outline-none transition focus:border-brand-500 focus:bg-white focus:ring-4 focus:ring-brand-100">
                                    <p class="mt-2 text-xs leading-5 text-slate-500">Must be at least 8 characters, with one uppercase and one symbol.</p>
                                </div>

                                <div class="grid gap-5 md:grid-cols-2">
                                    <div>
                                        <label for="dateOfBirth" class="mb-2 block text-sm font-medium text-slate-700">Date of Birth</label>
                                        <input id="dateOfBirth" type="date" name="dateOfBirth" required
                                               class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3.5 text-sm text-slate-900 outline-none transition focus:border-brand-500 focus:bg-white focus:ring-4 focus:ring-brand-100">
                                    </div>

                                    <div>
                                        <span class="mb-2 block text-sm font-medium text-slate-700">Gender</span>
                                        <div class="grid grid-cols-3 gap-2 rounded-2xl bg-slate-100 p-1">
                                            <button type="button" class="gender-toggle rounded-xl bg-brand-600 px-3 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-brand-700" data-value="Male">Male</button>
                                            <button type="button" class="gender-toggle rounded-xl px-3 py-3 text-sm font-semibold text-slate-600 transition hover:bg-white hover:text-slate-900" data-value="Female">Female</button>
                                            <button type="button" class="gender-toggle rounded-xl px-3 py-3 text-sm font-semibold text-slate-600 transition hover:bg-white hover:text-slate-900" data-value="Other">Other</button>
                                            <input type="hidden" name="gender" id="gender-input" value="Male">
                                        </div>
                                    </div>
                                </div>

                                <button type="submit"
                                        class="inline-flex w-full items-center justify-center rounded-2xl bg-slate-950 px-4 py-3.5 text-sm font-semibold text-white transition hover:bg-brand-700 focus:outline-none focus:ring-4 focus:ring-slate-300">
                                    Register
                                </button>
                            </form>

                            <p class="mt-6 text-center text-sm text-slate-600">
                                Already have an account?
                                <a href="login.jsp" class="font-semibold text-brand-600 transition hover:text-brand-700">Login</a>
                            </p>
                        </div>
                    </div>
                </section>
            </div>

            <footer class="mt-6 flex flex-col items-center justify-between gap-3 px-2 text-center text-sm text-slate-300 sm:flex-row sm:text-left">
                <div class="text-lg font-semibold text-white">SarkarSathi</div>
                <div class="flex flex-wrap items-center justify-center gap-4">
                    <a href="#" class="transition hover:text-white">Privacy Policy</a>
                    <a href="#" class="transition hover:text-white">Terms of Service</a>
                    <a href="#" class="transition hover:text-white">Accessibility</a>
                    <a href="#" class="transition hover:text-white">Sitemap</a>
                </div>
                <div>&copy; 2024 SarkarSathi Municipal Services. All rights reserved.</div>
            </footer>
        </div>
    </div>

    <script>
        const toggleButtons = document.querySelectorAll(".gender-toggle");
        const genderInput = document.getElementById("gender-input");

        function setActiveGender(activeButton) {
            toggleButtons.forEach((button) => {
                const isActive = button === activeButton;
                button.classList.toggle("bg-brand-600", isActive);
                button.classList.toggle("text-white", isActive);
                button.classList.toggle("shadow-sm", isActive);
                button.classList.toggle("hover:bg-brand-700", isActive);
                button.classList.toggle("text-slate-600", !isActive);
                button.classList.toggle("hover:bg-white", !isActive);
                button.classList.toggle("hover:text-slate-900", !isActive);
            });

            genderInput.value = activeButton.dataset.value;
        }

        toggleButtons.forEach((button) => {
            button.addEventListener("click", () => setActiveGender(button));
        });
    </script>
</body>
</html>
