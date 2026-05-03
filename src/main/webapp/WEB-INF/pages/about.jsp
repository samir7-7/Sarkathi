<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About Us - SarkarSathi</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap"
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
                400: "#60a5fa",
                500: "#3b82f6",
                800: "#154a91",
                900: "#0b3d86",
              },
            },
          },
        },
      };
    </script>
    <%@ include file="../includes/responsive-scripts.jsp" %>
    <style>
      body {
        font-family: "Outfit", sans-serif;
        -webkit-tap-highlight-color: transparent;
      }
      .glass-morphism {
        background: rgba(255, 255, 255, 0.2);
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
      }
    </style>
    <%@ include file="../includes/lucide-icons.jsp" %>
  </head>
  <body
    class="bg-[#f8fafc] text-slate-900 antialiased selection:bg-brand-100 selection:text-brand-900 pb-16 lg:pb-0 overflow-x-hidden"
  >
    <% String displayName = (String) session.getAttribute("displayName");
    boolean loggedIn = displayName != null && !displayName.isBlank(); %> <%@
    include file="../includes/navbar-public.jsp" %>

    <main class="px-6 py-12 lg:px-12">
      <div class="mx-auto max-w-4xl">
        <div class="text-center mb-16">
          <h1
            class="text-4xl lg:text-6xl font-black tracking-tighter text-slate-900 mb-6"
          >
            Empowering Citizens through
            <span class="text-brand-900">Digital Governance.</span>
          </h1>
          <p class="text-lg text-slate-600 leading-relaxed font-medium">
            SarkarSathi is more than just a platform; it's a commitment to
            transparency, efficiency, and accessibility in public
            administration.
          </p>
        </div>

        <div class="grid md:grid-cols-2 gap-12 items-center mb-20">
          <div>
            <h2
              class="text-2xl font-black text-brand-900 uppercase tracking-widest mb-4"
            >
              Our Vision
            </h2>
            <p class="text-slate-600 leading-relaxed">
              To create a seamless digital bridge between the government and its
              citizens, ensuring that every service is just a click away. We
              believe in a future where governance is decentralized,
              accountable, and citizen-centric.
            </p>
          </div>
          <div class="bg-brand-50 rounded-3xl p-8 border border-brand-100">
            <div class="flex items-center gap-4 mb-4">
              <div
                class="h-12 w-12 rounded-xl bg-brand-900 text-white flex items-center justify-center"
              >
                <i data-lucide="target" class="h-6 w-6"></i>
              </div>
              <h3 class="font-bold text-brand-900">Citizen-First Design</h3>
            </div>
            <p class="text-sm text-slate-600">
              Every feature in SarkarSathi is built with the user in mind, from
              easy application tracking to localized agriculture advisories.
            </p>
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-20">
          <div
            class="text-center p-6 border border-slate-100 rounded-3xl bg-white shadow-sm"
          >
            <p class="text-4xl font-black text-brand-900 mb-2">10k+</p>
            <p
              class="text-xs font-black uppercase tracking-widest text-slate-400"
            >
              Active Users
            </p>
          </div>
          <div
            class="text-center p-6 border border-slate-100 rounded-3xl bg-white shadow-sm"
          >
            <p class="text-4xl font-black text-brand-900 mb-2">50+</p>
            <p
              class="text-xs font-black uppercase tracking-widest text-slate-400"
            >
              Services
            </p>
          </div>
          <div
            class="text-center p-6 border border-slate-100 rounded-3xl bg-white shadow-sm"
          >
            <p class="text-4xl font-black text-brand-900 mb-2">100%</p>
            <p
              class="text-xs font-black uppercase tracking-widest text-slate-400"
            >
              Transparency
            </p>
          </div>
        </div>
      </div>
    </main>
  </body>
</html>
