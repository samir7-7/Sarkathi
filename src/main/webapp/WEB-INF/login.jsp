<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SarkarSathi - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-100 text-slate-900">
    <% String error = request.getParameter("error"); %>
    <% String registered = request.getParameter("registered"); %>
    <div class="flex min-h-screen flex-col">
        <main class="grid flex-1 lg:grid-cols-2">
            <section class="relative hidden overflow-hidden lg:flex">
                <img
                    src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1600&auto=format&fit=crop"
                    alt="City skyline"
                    class="absolute inset-0 h-full w-full object-cover"
                >
                <div class="absolute inset-0 bg-[#0f4ea8]/85"></div>
                <div class="absolute inset-0 bg-gradient-to-b from-[#0f4ea8]/55 via-[#0f4ea8]/60 to-[#062e69]/90"></div>

                <div class="relative flex h-full w-full flex-col justify-between px-12 py-16 text-white">
                    <div class="max-w-xl pt-12">
                        <h1 class="text-4xl lg:text-5xl font-bold leading-tight tracking-tight">
                            Empowering<br>
                            Citizens, Building<br>
                            Cities.
                        </h1>
                        <p class="mt-6 max-w-lg text-lg leading-relaxed text-blue-100/90">
                            Connecting you to municipal excellence through a unified digital gateway. Experience governance that works for you.
                        </p>
                    </div>

                    <div class="pb-8">
                        <div class="inline-flex items-center gap-2 rounded-full border border-white/25 bg-white/10 px-5 py-2.5 text-xs font-semibold uppercase tracking-widest text-white shadow-lg shadow-slate-950/20 backdrop-blur-sm">
                            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                            Official Portal
                        </div>
                    </div>
                </div>
            </section>

            <section class="flex items-center justify-center bg-[#f7f7fb] px-6 py-12 lg:px-12">
                <div class="w-full max-w-md">
                    <div>
                        <div class="flex h-16 w-16 items-center justify-center rounded-full bg-[#154a91] text-white shadow-lg shadow-blue-950/20">
                            <svg class="h-8 w-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <path d="M3 21h18"></path>
                                <path d="M5 21v-4"></path>
                                <path d="M19 21v-4"></path>
                                <path d="M7 17v-4"></path>
                                <path d="M17 17v-4"></path>
                                <path d="M12 17v-4"></path>
                                <path d="M3 13L12 4l9 9"></path>
                            </svg>
                        </div>
                        <h2 class="mt-8 text-4xl font-bold tracking-tight text-[#0b3d86]">SarkarSathi</h2>
                        <p class="mt-4 text-base text-slate-700">
                            Access your municipal services with ease. Please login to your account.
                        </p>
                    </div>

                    <div class="mt-8 rounded-2xl bg-white px-6 py-8 shadow-[0_20px_60px_rgba(15,23,42,0.08)] sm:px-8">
                        <% if ("1".equals(registered)) { %>
                            <div class="mb-6 rounded-xl border border-green-200 bg-green-50 px-4 py-3 text-sm font-medium text-green-800">
                                Registration completed. Please log in with your new citizen account.
                            </div>
                        <% } %>
                        <% if (error != null && !error.isBlank()) { %>
                            <div class="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-800">
                                <%= error %>
                            </div>
                        <% } %>
                        <form action="${pageContext.request.contextPath}/api/auth/login" method="post" class="space-y-6">
                            <input type="hidden" name="userType" value="citizen">
                            <div>
                                <label for="email" class="mb-2 block text-xs font-semibold uppercase tracking-wider text-slate-800">Email Address</label>
                                <input
                                    id="email"
                                    type="email"
                                    name="email"
                                    placeholder="name@example.com"
                                    required
                                    class="w-full rounded-xl border border-slate-200 bg-[#f4f5fa] px-4 py-3 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100"
                                >
                            </div>

                            <div>
                                <div class="mb-2 flex items-center justify-between gap-4">
                                    <label for="password" class="block text-xs font-semibold uppercase tracking-wider text-slate-800">Password</label>
                                    <a href="#" class="text-xs font-semibold text-[#0b3d86] transition hover:text-[#154a91]">Forgot Password?</a>
                                </div>
                                <div class="relative">
                                    <input
                                        id="password"
                                        type="password"
                                        name="password"
                                        placeholder="Password"
                                        required
                                        class="w-full rounded-xl border border-slate-200 bg-[#f4f5fa] px-4 py-3 pr-16 text-sm text-slate-800 outline-none transition focus:border-[#154a91] focus:ring-2 focus:ring-blue-100"
                                    >
                                    <button
                                        type="button"
                                        class="password-toggle absolute right-3 top-1/2 -translate-y-1/2 text-xs font-semibold uppercase tracking-wider text-slate-500 transition hover:text-[#154a91]"
                                        data-target="password"
                                        aria-label="Show password"
                                        aria-pressed="false"
                                    >
                                        Show
                                    </button>
                                </div>
                            </div>

                            <button
                                type="submit"
                                class="inline-flex w-full items-center justify-center gap-2 rounded-xl bg-[#154a91] px-5 py-3 text-base font-semibold text-white shadow-md transition hover:bg-[#103b74] focus:outline-none focus:ring-2 focus:ring-blue-200 focus:ring-offset-1"
                            >
                                Login to Dashboard
                                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </button>
                        </form>

                        <div class="mt-8 border-t border-slate-100 pt-6 text-center text-sm text-slate-600">
                            Don't have an account?
                            <a href="register.jsp" class="ml-1 font-semibold text-[#157a2f] transition hover:text-[#0f5d24]">Register as a Citizen</a>
                        </div>
                    </div>

                    <div class="mt-8 flex items-center justify-center gap-2 text-[10px] font-semibold uppercase tracking-widest text-slate-400">
                        <svg class="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        Secure Government Portal &bull; Data Encrypted
                    </div>
                </div>
            </section>
        </main>
    </div>
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
    </script>
</body>
</html>