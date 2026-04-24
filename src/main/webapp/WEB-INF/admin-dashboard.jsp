<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String adminName = (String) request.getAttribute("adminName");
    String adminEmail = (String) request.getAttribute("adminEmail");
    String adminRole = (String) request.getAttribute("adminRole");
    if (adminName == null) adminName = "Admin";
    if (adminEmail == null) adminEmail = "";
    if (adminRole == null) adminRole = "admin";
    String initials = "";
    String[] parts = adminName.split(" ");
    for (String p : parts) { if (!p.isEmpty()) initials += p.charAt(0); }
    if (initials.length() > 2) initials = initials.substring(0, 2);
    initials = initials.toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - SarkarSathi</title>
    <meta name="description" content="SarkarSathi Admin Dashboard — Real-time metrics, application reviews, and municipal service management." />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap"
      rel="stylesheet"
    />
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: {
              sans: ["Outfit", "sans-serif"],
            },
            colors: {
              brand: {
                50: "#f0f5fc",
                100: "#e1eafa",
                500: "#3b82f6",
                800: "#154a91",
                900: "#0b3d86",
              },
            },
          },
        },
      };
    </script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
      body {
        font-family: "Outfit", sans-serif;
      }
      /* Custom scrollbar */
      ::-webkit-scrollbar { width: 6px; }
      ::-webkit-scrollbar-track { background: transparent; }
      ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 9999px; }
      ::-webkit-scrollbar-thumb:hover { background: #94a3b8; }

      /* Sidebar link active state */
      .nav-link {
        transition: all 0.2s ease;
      }
      .nav-link:hover {
        background: #f0f5fc;
        color: #0b3d86;
      }
      .nav-link.active {
        background: #f0f5fc;
        color: #0b3d86;
        font-weight: 600;
      }

      /* Stat card hover */
      .stat-card {
        transition: all 0.25s ease;
      }
      .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px -5px rgba(0,0,0,0.08);
      }

      /* Table row hover */
      .activity-row {
        transition: background 0.15s ease;
      }
      .activity-row:hover {
        background: #f8fafc;
      }

      /* Review item hover */
      .review-item {
        transition: background 0.15s ease;
      }
      .review-item:hover {
        background: #f8fafc;
      }

      /* Quick action hover */
      .quick-action {
        transition: all 0.2s ease;
      }
      .quick-action:hover {
        background: #f0f5fc;
      }

      /* Subtle pulse for system alert */
      @keyframes subtle-pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.85; }
      }
      .alert-pulse {
        animation: subtle-pulse 3s ease-in-out infinite;
      }

      /* Skeleton loading shimmer */
      @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
      }
      .skeleton {
        background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s ease-in-out infinite;
        border-radius: 8px;
      }

      /* Fade-in animation */
      @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(12px); }
        to { opacity: 1; transform: translateY(0); }
      }
      .fade-in {
        animation: fadeInUp 0.4s ease-out forwards;
      }
      .fade-in-delay-1 { animation-delay: 0.05s; opacity: 0; }
      .fade-in-delay-2 { animation-delay: 0.1s; opacity: 0; }
      .fade-in-delay-3 { animation-delay: 0.15s; opacity: 0; }
      .fade-in-delay-4 { animation-delay: 0.2s; opacity: 0; }
      .fade-in-delay-5 { animation-delay: 0.25s; opacity: 0; }
    </style>
  </head>

  <body class="bg-[#fafafc] text-slate-800">
    <div class="flex min-h-screen">

      <!-- ========== SIDEBAR ========== -->
      <aside class="fixed inset-y-0 left-0 z-30 flex w-[220px] flex-col border-r border-slate-200 bg-white">
        <!-- Logo -->
        <div class="flex items-center gap-1.5 px-5 pt-5 pb-2">
          <span class="text-xl font-bold tracking-tight text-brand-900">SarkarSathi</span>
          <span class="text-xl font-bold text-brand-500">Admin</span>
        </div>

        <!-- Admin Portal Badge -->
        <div class="mx-5 mt-3 flex items-center gap-3 rounded-xl bg-brand-50 px-4 py-3">
          <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-brand-900 text-white">
            <i data-lucide="landmark" class="h-4 w-4"></i>
          </div>
          <div>
            <p class="text-sm font-semibold text-brand-900"><%= adminName %></p>
            <p class="text-[11px] text-slate-500"><%= adminRole.substring(0,1).toUpperCase() + adminRole.substring(1) %></p>
          </div>
        </div>

        <!-- Navigation -->
        <nav class="mt-6 flex-1 space-y-1 px-3">
          <a href="#" id="nav-applications" class="nav-link active flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm">
            <i data-lucide="file-text" class="h-[18px] w-[18px]"></i>
            Applications
          </a>
          <a href="#" id="nav-services" class="nav-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
            <i data-lucide="building-2" class="h-[18px] w-[18px]"></i>
            Services
          </a>
          <a href="#" id="nav-users" class="nav-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
            <i data-lucide="users" class="h-[18px] w-[18px]"></i>
            Users
          </a>
          <a href="#" id="nav-reports" class="nav-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
            <i data-lucide="bar-chart-3" class="h-[18px] w-[18px]"></i>
            Reports
          </a>
        </nav>

        <!-- Bottom Section -->
        <div class="mt-auto border-t border-slate-100 px-3 pb-4 pt-3 space-y-2">
          <a href="#" id="nav-settings" class="nav-link flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-slate-600">
            <i data-lucide="settings" class="h-[18px] w-[18px]"></i>
            Settings
          </a>
          <!-- System Alert -->
          <div class="alert-pulse mt-2 flex items-center gap-3 rounded-xl bg-slate-800 px-4 py-3 text-white">
            <div class="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-blue-500/20">
              <i data-lucide="info" class="h-3.5 w-3.5 text-blue-400"></i>
            </div>
            <div>
              <p class="text-xs font-semibold">New System Alert</p>
              <p class="text-[10px] text-slate-400">Scheduled maintenance tonight.</p>
            </div>
          </div>
        </div>
      </aside>

      <!-- ========== MAIN CONTENT ========== -->
      <div class="ml-[220px] flex-1 flex flex-col min-h-screen">

        <!-- Top Bar -->
        <header class="sticky top-0 z-20 flex items-center justify-between border-b border-slate-200 bg-white/80 backdrop-blur-md px-8 py-3.5">
          <!-- Search -->
          <div class="relative w-full max-w-md">
            <i data-lucide="search" class="absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400"></i>
            <input
              id="search-input"
              type="text"
              placeholder="Search applications, users..."
              class="w-full rounded-xl border border-slate-200 bg-slate-50 py-2.5 pl-10 pr-4 text-sm text-slate-700 placeholder-slate-400 outline-none transition focus:border-brand-500 focus:ring-2 focus:ring-brand-100"
            />
          </div>

          <!-- Right actions -->
          <div class="flex items-center gap-4">
            <button id="btn-notifications" class="relative flex h-9 w-9 items-center justify-center rounded-lg text-slate-500 transition hover:bg-slate-100">
              <i data-lucide="bell" class="h-[18px] w-[18px]"></i>
              <span class="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-red-500"></span>
            </button>
            <button id="btn-settings-top" class="flex h-9 w-9 items-center justify-center rounded-lg text-slate-500 transition hover:bg-slate-100">
              <i data-lucide="settings" class="h-[18px] w-[18px]"></i>
            </button>
            <div class="h-5 w-px bg-slate-200"></div>
            <div class="flex items-center gap-3">
              <div class="flex h-9 w-9 items-center justify-center overflow-hidden rounded-full bg-brand-900 text-white text-xs font-bold ring-2 ring-slate-200 ring-offset-2">
                <%= initials %>
              </div>
              <div class="hidden sm:block">
                <p class="text-sm font-semibold text-slate-800 leading-none"><%= adminName %></p>
                <p class="text-[11px] text-slate-400 mt-0.5"><%= adminEmail %></p>
              </div>
            </div>
            <a href="<%= request.getContextPath() %>/logout" id="btn-logout" class="flex items-center gap-1.5 rounded-lg border border-slate-200 bg-white px-3 py-2 text-xs font-semibold text-red-600 transition hover:bg-red-50 hover:border-red-200">
              <i data-lucide="log-out" class="h-3.5 w-3.5"></i>
              Logout
            </a>
          </div>
        </header>

        <!-- Page Content -->
        <main class="flex-1 px-8 py-8 overflow-y-auto">

          <!-- Page Header -->
          <div class="mb-8 fade-in">
            <h1 class="text-2xl font-bold text-slate-900">Dashboard Overview</h1>
            <p class="mt-1 text-sm text-slate-500">Real-time metrics and municipal service updates.</p>
          </div>

          <!-- ===== STAT CARDS ===== -->
          <div class="mb-8 grid grid-cols-2 gap-4 lg:grid-cols-5" id="stats-grid">
            <!-- Total Applications -->
            <div class="stat-card rounded-2xl border border-slate-100 bg-white p-5 shadow-sm fade-in fade-in-delay-1">
              <div class="flex items-center justify-between">
                <p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Total Applications</p>
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-50 text-slate-500">
                  <i data-lucide="layers" class="h-4 w-4"></i>
                </div>
              </div>
              <div class="mt-3 flex items-end gap-2">
                <span class="text-3xl font-bold text-slate-900" id="stat-total">
                  <span class="skeleton inline-block h-8 w-20"></span>
                </span>
                <span class="mb-1 inline-flex items-center gap-0.5 rounded-full bg-green-50 px-2 py-0.5 text-[11px] font-semibold text-green-600">
                  <i data-lucide="trending-up" class="h-3 w-3"></i>
                  2.4%
                </span>
              </div>
            </div>

            <!-- Submitted -->
            <div class="stat-card rounded-2xl border border-slate-100 bg-white p-5 shadow-sm fade-in fade-in-delay-2">
              <div class="flex items-center justify-between">
                <p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Submitted</p>
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-50 text-blue-500">
                  <i data-lucide="send" class="h-4 w-4"></i>
                </div>
              </div>
              <div class="mt-3">
                <span class="text-3xl font-bold text-slate-900" id="stat-submitted">
                  <span class="skeleton inline-block h-8 w-14"></span>
                </span>
              </div>
            </div>

            <!-- Under Review -->
            <div class="stat-card rounded-2xl border border-slate-100 bg-white p-5 shadow-sm fade-in fade-in-delay-3">
              <div class="flex items-center justify-between">
                <p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Under Review</p>
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-50 text-amber-500">
                  <i data-lucide="eye" class="h-4 w-4"></i>
                </div>
              </div>
              <div class="mt-3">
                <span class="text-3xl font-bold text-amber-600" id="stat-review">
                  <span class="skeleton inline-block h-8 w-16"></span>
                </span>
              </div>
            </div>

            <!-- Approved -->
            <div class="stat-card rounded-2xl border border-slate-100 bg-white p-5 shadow-sm fade-in fade-in-delay-4">
              <div class="flex items-center justify-between">
                <p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Approved</p>
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-green-50 text-green-500">
                  <i data-lucide="check-circle-2" class="h-4 w-4"></i>
                </div>
              </div>
              <div class="mt-3">
                <span class="text-3xl font-bold text-green-600" id="stat-approved">
                  <span class="skeleton inline-block h-8 w-16"></span>
                </span>
              </div>
            </div>

            <!-- Rejected -->
            <div class="stat-card rounded-2xl border border-slate-100 bg-white p-5 shadow-sm fade-in fade-in-delay-5">
              <div class="flex items-center justify-between">
                <p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Rejected</p>
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-red-50 text-red-500">
                  <i data-lucide="x-circle" class="h-4 w-4"></i>
                </div>
              </div>
              <div class="mt-3">
                <span class="text-3xl font-bold text-red-500" id="stat-rejected">
                  <span class="skeleton inline-block h-8 w-12"></span>
                </span>
              </div>
            </div>
          </div>

          <!-- ===== QUICK ACTIONS & PRIORITY REVIEWS ===== -->
          <div class="mb-8 grid gap-6 lg:grid-cols-[340px_1fr]">

            <!-- Quick Actions -->
            <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm fade-in fade-in-delay-3">
              <h2 class="text-lg font-bold text-slate-900">Quick Actions</h2>
              <div class="mt-5 space-y-2">
                <a href="#" id="action-review" class="quick-action flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3.5">
                  <div class="flex items-center gap-3">
                    <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-amber-50 text-amber-600">
                      <i data-lucide="clipboard-check" class="h-4 w-4"></i>
                    </div>
                    <span class="text-sm font-medium text-slate-700">Review Applications</span>
                  </div>
                  <i data-lucide="arrow-right" class="h-4 w-4 text-slate-400"></i>
                </a>
                <a href="#" id="action-notices" class="quick-action flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3.5">
                  <div class="flex items-center gap-3">
                    <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-purple-50 text-purple-600">
                      <i data-lucide="megaphone" class="h-4 w-4"></i>
                    </div>
                    <span class="text-sm font-medium text-slate-700">Manage Notices</span>
                  </div>
                  <i data-lucide="arrow-right" class="h-4 w-4 text-slate-400"></i>
                </a>
                <a href="#" id="action-announcements" class="quick-action flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3.5">
                  <div class="flex items-center gap-3">
                    <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-blue-50 text-blue-600">
                      <i data-lucide="radio" class="h-4 w-4"></i>
                    </div>
                    <span class="text-sm font-medium text-slate-700">Announcements</span>
                  </div>
                  <i data-lucide="arrow-right" class="h-4 w-4 text-slate-400"></i>
                </a>
              </div>
            </div>

            <!-- Priority Reviews -->
            <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm fade-in fade-in-delay-4">
              <div class="flex items-center justify-between">
                <h2 class="text-lg font-bold text-slate-900">Priority Reviews</h2>
                <a href="#" class="text-sm font-semibold text-brand-500 transition hover:text-brand-900">View All</a>
              </div>

              <div class="mt-5 space-y-1" id="priority-reviews">
                <!-- Loaded dynamically; fallback static content -->
                <!-- Review 1 — High Priority -->
                <div class="review-item flex items-center justify-between rounded-xl px-4 py-3.5">
                  <div class="flex items-center gap-4">
                    <span class="h-2.5 w-2.5 rounded-full bg-red-500"></span>
                    <div>
                      <p class="text-sm font-semibold text-slate-800">Building Permit &ndash; Commercial</p>
                      <p class="mt-0.5 text-xs text-slate-400">ID: BLD-2024-0891 &bull; 2 hrs ago</p>
                    </div>
                  </div>
                  <button class="rounded-lg bg-brand-900 px-4 py-1.5 text-xs font-semibold text-white shadow-sm transition hover:bg-brand-800">Review</button>
                </div>

                <!-- Review 2 — High Priority -->
                <div class="review-item flex items-center justify-between rounded-xl px-4 py-3.5">
                  <div class="flex items-center gap-4">
                    <span class="h-2.5 w-2.5 rounded-full bg-red-500"></span>
                    <div>
                      <p class="text-sm font-semibold text-slate-800">Trade License Renewal</p>
                      <p class="mt-0.5 text-xs text-slate-400">ID: TRL-2024-1102 &bull; 4 hrs ago</p>
                    </div>
                  </div>
                  <button class="rounded-lg bg-brand-900 px-4 py-1.5 text-xs font-semibold text-white shadow-sm transition hover:bg-brand-800">Review</button>
                </div>

                <!-- Review 3 — Medium Priority -->
                <div class="review-item flex items-center justify-between rounded-xl px-4 py-3.5">
                  <div class="flex items-center gap-4">
                    <span class="h-2.5 w-2.5 rounded-full bg-amber-500"></span>
                    <div>
                      <p class="text-sm font-semibold text-slate-800">Water Connection Request</p>
                      <p class="mt-0.5 text-xs text-slate-400">ID: WTR-2024-0054 &bull; 1 day ago</p>
                    </div>
                  </div>
                  <button class="rounded-lg bg-brand-900 px-4 py-1.5 text-xs font-semibold text-white shadow-sm transition hover:bg-brand-800">Review</button>
                </div>
              </div>
            </div>
          </div>

          <!-- ===== RECENT ACTIVITY TABLE ===== -->
          <div class="rounded-2xl border border-slate-100 bg-white shadow-sm fade-in fade-in-delay-5">
            <div class="px-6 pt-6 pb-4">
              <h2 class="text-lg font-bold text-slate-900">Recent Activity</h2>
            </div>
            <div class="overflow-x-auto">
              <table class="w-full text-left text-sm" id="activity-table">
                <thead>
                  <tr class="border-t border-b border-slate-100">
                    <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Tracking ID</th>
                    <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Service Type</th>
                    <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Applicant Name</th>
                    <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Date</th>
                    <th class="whitespace-nowrap px-6 py-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">Status</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-slate-50" id="activity-body">
                  <!-- Rows populated by JS; static fallback below -->
                  <tr class="activity-row">
                    <td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#APP-8821</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Birth Certificate</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Rahul Sharma</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-500">Oct 24, 2024</td>
                    <td class="whitespace-nowrap px-6 py-4">
                      <span class="inline-flex rounded-full bg-green-50 px-3 py-1 text-xs font-semibold text-green-700">Approved</span>
                    </td>
                  </tr>
                  <tr class="activity-row">
                    <td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#APP-8820</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Property Tax Payment</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Priya Patel</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-500">Oct 24, 2024</td>
                    <td class="whitespace-nowrap px-6 py-4">
                      <span class="inline-flex rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-700">Processed</span>
                    </td>
                  </tr>
                  <tr class="activity-row">
                    <td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#APP-8819</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Marriage Registration</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Amit & Sneha Singh</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-500">Oct 23, 2024</td>
                    <td class="whitespace-nowrap px-6 py-4">
                      <span class="inline-flex rounded-full bg-amber-50 px-3 py-1 text-xs font-semibold text-amber-700">Under Review</span>
                    </td>
                  </tr>
                  <tr class="activity-row">
                    <td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#APP-8818</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Grievance &ndash; Pothole</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Vikram Reddy</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-500">Oct 23, 2024</td>
                    <td class="whitespace-nowrap px-6 py-4">
                      <span class="inline-flex rounded-full bg-cyan-50 px-3 py-1 text-xs font-semibold text-cyan-700">Assigned</span>
                    </td>
                  </tr>
                  <tr class="activity-row">
                    <td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#APP-8817</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Building Plan Approval</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-600">Modern Builders LLC</td>
                    <td class="whitespace-nowrap px-6 py-4 text-slate-500">Oct 22, 2024</td>
                    <td class="whitespace-nowrap px-6 py-4">
                      <span class="inline-flex rounded-full bg-red-50 px-3 py-1 text-xs font-semibold text-red-600">Rejected</span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

        </main>

        <!-- Footer -->
        <footer class="border-t border-slate-200 bg-white px-8 py-4">
          <div class="flex flex-col gap-3 text-[11px] font-medium text-slate-400 sm:flex-row sm:items-center sm:justify-between">
            <p>&copy; 2024 SARKARSATHI MUNICIPAL AUTHORITY. SYSTEM STATUS: <span class="text-green-500 font-bold">OPERATIONAL</span>. V2.4.1-STABLE</p>
            <div class="flex items-center gap-5">
              <a href="#" class="uppercase tracking-wide transition hover:text-brand-900">Privacy Policy</a>
              <a href="#" class="uppercase tracking-wide transition hover:text-brand-900">Audit Logs</a>
              <a href="#" class="uppercase tracking-wide transition hover:text-brand-900">Support</a>
            </div>
          </div>
        </footer>
      </div>

    </div>

    <script>
      // Initialize Lucide icons
      lucide.createIcons();

      // ── Sidebar navigation — active state toggling ─────────────────────
      document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function(e) {
          e.preventDefault();
          document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
          this.classList.add('active');
        });
      });

      // ── Number formatting helper ──────────────────────────────────────
      function formatNumber(n) {
        return Number(n).toLocaleString('en-US');
      }

      // ── Status badge styling map ──────────────────────────────────────
      const statusStyles = {
        submitted:  { bg: 'bg-blue-50',   text: 'text-blue-700',   label: 'Submitted'    },
        review:     { bg: 'bg-amber-50',  text: 'text-amber-700',  label: 'Under Review'  },
        approved:   { bg: 'bg-green-50',  text: 'text-green-700',  label: 'Approved'      },
        rejected:   { bg: 'bg-red-50',    text: 'text-red-600',    label: 'Rejected'      },
        processed:  { bg: 'bg-blue-50',   text: 'text-blue-700',   label: 'Processed'     },
        assigned:   { bg: 'bg-cyan-50',   text: 'text-cyan-700',   label: 'Assigned'      },
      };

      function statusBadge(status) {
        const s = statusStyles[status] || { bg: 'bg-slate-100', text: 'text-slate-600', label: status };
        return '<span class="inline-flex rounded-full ' + s.bg + ' px-3 py-1 text-xs font-semibold ' + s.text + '">' + s.label + '</span>';
      }

      // ── Date formatting helper ────────────────────────────────────────
      function formatDate(dateStr) {
        if (!dateStr) return '—';
        const d = new Date(dateStr);
        return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
      }

      // ── Fetch dashboard stats from API ────────────────────────────────
      fetch('<%= request.getContextPath() %>/api/dashboard')
        .then(res => res.json())
        .then(data => {
          document.getElementById('stat-total').textContent     = formatNumber(data.totalApplications);
          document.getElementById('stat-submitted').textContent = formatNumber(data.submitted);
          document.getElementById('stat-review').textContent    = formatNumber(data.review);
          document.getElementById('stat-approved').textContent  = formatNumber(data.approved);
          document.getElementById('stat-rejected').textContent  = formatNumber(data.rejected);
          // Re-create icons inside stat cards (the skeleton replaced them)
          lucide.createIcons();
        })
        .catch(() => {
          // API unavailable — show fallback static numbers
          document.getElementById('stat-total').textContent     = '12,450';
          document.getElementById('stat-submitted').textContent = '450';
          document.getElementById('stat-review').textContent    = '1,200';
          document.getElementById('stat-approved').textContent  = '10,500';
          document.getElementById('stat-rejected').textContent  = '300';
        });

      // ── Fetch recent applications from API ────────────────────────────
      fetch('<%= request.getContextPath() %>/api/applications')
        .then(res => res.json())
        .then(applications => {
          if (!Array.isArray(applications) || applications.length === 0) return;

          const tbody = document.getElementById('activity-body');
          tbody.innerHTML = '';

          const recent = applications.slice(-5).reverse();
          recent.forEach(app => {
            const tr = document.createElement('tr');
            tr.className = 'activity-row';
            tr.innerHTML =
              '<td class="whitespace-nowrap px-6 py-4 font-semibold text-brand-900">#' + app.trackingId + '</td>' +
              '<td class="whitespace-nowrap px-6 py-4 text-slate-600">Service #' + app.serviceTypeId + '</td>' +
              '<td class="whitespace-nowrap px-6 py-4 text-slate-600">Citizen #' + app.citizenId + '</td>' +
              '<td class="whitespace-nowrap px-6 py-4 text-slate-500">' + formatDate(app.submittedAt) + '</td>' +
              '<td class="whitespace-nowrap px-6 py-4">' + statusBadge(app.status) + '</td>';
            tbody.appendChild(tr);
          });
        })
        .catch(() => {
          // Keep the static fallback rows as-is
        });

      // ── Search filter on the activity table ───────────────────────────
      document.getElementById('search-input').addEventListener('input', function() {
        const query = this.value.toLowerCase();
        document.querySelectorAll('#activity-body .activity-row').forEach(row => {
          row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
        });
      });
    </script>
  </body>
</html>
