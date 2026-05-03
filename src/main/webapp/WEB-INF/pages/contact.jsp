<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contact Us - SarkarSathi</title>
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
      <div class="mx-auto max-w-7xl">
        <div class="grid lg:grid-cols-2 gap-16 items-start">
          <div>
            <h1
              class="text-4xl lg:text-6xl font-black tracking-tighter text-slate-900 mb-8"
            >
              Get in <span class="text-brand-900">Touch.</span>
            </h1>
            <p class="text-lg text-slate-500 font-medium mb-12">
              Have questions or need assistance? Our team is here to help you
              navigate through our digital services.
            </p>

            <div class="space-y-8">
              <div class="flex items-start gap-6">
                <div
                  class="h-12 w-12 rounded-2xl bg-brand-50 text-brand-900 flex items-center justify-center shrink-0"
                >
                  <i data-lucide="mail" class="h-6 w-6"></i>
                </div>
                <div>
                  <h3
                    class="font-black uppercase tracking-widest text-xs text-slate-400 mb-1"
                  >
                    Email Support
                  </h3>
                  <p class="text-slate-900 font-bold">
                    support@sarkarsathi.gov.np
                  </p>
                </div>
              </div>
              <div class="flex items-start gap-6">
                <div
                  class="h-12 w-12 rounded-2xl bg-brand-50 text-brand-900 flex items-center justify-center shrink-0"
                >
                  <i data-lucide="phone" class="h-6 w-6"></i>
                </div>
                <div>
                  <h3
                    class="font-black uppercase tracking-widest text-xs text-slate-400 mb-1"
                  >
                    Emergency Helpdesk
                  </h3>
                  <p class="text-slate-900 font-bold">+977-1-4XXXXXX</p>
                </div>
              </div>
              <div class="flex items-start gap-6">
                <div
                  class="h-12 w-12 rounded-2xl bg-brand-50 text-brand-900 flex items-center justify-center shrink-0"
                >
                  <i data-lucide="map-pin" class="h-6 w-6"></i>
                </div>
                <div>
                  <h3
                    class="font-black uppercase tracking-widest text-xs text-slate-400 mb-1"
                  >
                    Headquarters
                  </h3>
                  <p class="text-slate-900 font-bold">
                    Palika Administration Center, Ward No. 7<br />Lalitpur,
                    Nepal
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div
            class="bg-white rounded-[2rem] p-8 lg:p-12 border border-slate-100 shadow-2xl shadow-brand-900/5"
          >
            <form class="space-y-6">
              <div class="grid sm:grid-cols-2 gap-6">
                <div class="space-y-2">
                  <label
                    class="text-[10px] font-black uppercase tracking-widest text-slate-400"
                    >Full Name</label
                  >
                  <input
                    type="text"
                    class="w-full h-14 rounded-2xl border-2 border-slate-50 bg-slate-50 px-6 font-bold text-slate-900 outline-none focus:border-brand-900 focus:bg-white transition-all"
                    placeholder="John Doe"
                  />
                </div>
                <div class="space-y-2">
                  <label
                    class="text-[10px] font-black uppercase tracking-widest text-slate-400"
                    >Citizenship ID (Optional)</label
                  >
                  <input
                    type="text"
                    class="w-full h-14 rounded-2xl border-2 border-slate-50 bg-slate-50 px-6 font-bold text-slate-900 outline-none focus:border-brand-900 focus:bg-white transition-all"
                    placeholder="XX-XX-XX-XXXXX"
                  />
                </div>
              </div>
              <div class="space-y-2">
                <label
                  class="text-[10px] font-black uppercase tracking-widest text-slate-400"
                  >Topic</label
                >
                <select
                  class="w-full h-14 rounded-2xl border-2 border-slate-50 bg-slate-50 px-6 font-bold text-slate-900 outline-none focus:border-brand-900 focus:bg-white transition-all appearance-none"
                >
                  <option>General Inquiry</option>
                  <option>Technical Issue</option>
                  <option>Feature Request</option>
                  <option>Agriculture Support</option>
                </select>
              </div>
              <div class="space-y-2">
                <label
                  class="text-[10px] font-black uppercase tracking-widest text-slate-400"
                  >Statement</label
                >
                <textarea
                  class="w-full min-h-[160px] rounded-2xl border-2 border-slate-50 bg-slate-50 p-6 font-bold text-slate-900 outline-none focus:border-brand-900 focus:bg-white transition-all resize-none"
                  placeholder="How can we assist you today?"
                ></textarea>
              </div>
              <button
                type="submit"
                class="w-full rounded-2xl bg-brand-900 py-5 text-sm font-black uppercase tracking-widest text-white shadow-xl shadow-brand-900/20 active:scale-95 transition-all"
              >
                Submit Inquiry
              </button>
            </form>
          </div>
        </div>
      </div>
    </main>

    <footer
      class="hidden lg:block border-t border-slate-100 bg-white py-12 mt-20"
    >
      <div
        class="mx-auto max-w-7xl px-6 lg:px-12 flex items-center justify-between"
      >
        <p class="text-xs font-black uppercase tracking-widest text-slate-400">
          &copy; 2026 SarkarSathi Ecosystem. Digital Nepal Initiative.
        </p>
        <div class="flex gap-8">
          <a
            href="#"
            class="text-xs font-black uppercase tracking-widest text-slate-400 hover:text-brand-900"
            >Privacy</a
          >
          <a
            href="#"
            class="text-xs font-black uppercase tracking-widest text-slate-400 hover:text-brand-900"
            >Stability Status</a
          >
        </div>
      </div>
    </footer>
  </body>
</html>
