<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%!
private String esc(Object value) {
    if (value == null) return "";
    return value.toString()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
}

private int statusCode(HttpServletRequest request) {
    Object status = request.getAttribute("jakarta.servlet.error.status_code");
    if (status instanceof Integer) return (Integer) status;
    return 500;
}

private String titleFor(int status) {
    return switch (status) {
        case 400 -> "We could not understand that request";
        case 401 -> "Please sign in to continue";
        case 403 -> "You do not have access to this page";
        case 404 -> "We could not find that page";
        case 405 -> "That action is not available here";
        case 500 -> "Something went wrong on our side";
        default -> "Something did not go as expected";
    };
}

private String messageFor(int status) {
    return switch (status) {
        case 400 -> "Some information in the request was missing or not in the expected format. Please check the details and try again.";
        case 401 -> "Your session may have expired, or this page may require login before it can be viewed.";
        case 403 -> "Your account is signed in, but this section is restricted to a different role or permission level.";
        case 404 -> "The link may be old, typed incorrectly, or the page may have been moved.";
        case 405 -> "The page was reached with an action it does not support. Please go back and try again from the proper button or form.";
        case 500 -> "The system could not complete the request right now. Your data has not been shown here for security reasons.";
        default -> "Please try again. If the problem continues, contact support with the reference details below.";
    };
}

private String nextStepFor(int status) {
    return switch (status) {
        case 401 -> "Go to the login page and sign in again.";
        case 403 -> "Return to your dashboard, or sign in with an account that has permission for this section.";
        case 404 -> "Use the navigation menu or return to the home page.";
        case 500 -> "Wait a moment, then retry the action. If it continues, report the time and page shown below.";
        default -> "Go back to the previous page and try again.";
    };
}
%>
<%
int status = statusCode(request);
String requestUri = esc(request.getAttribute("jakarta.servlet.error.request_uri"));
String contextPath = request.getContextPath();
String role = session == null ? null : (String) session.getAttribute("role");
String dashboardPath = "admin".equals(role) ? "/admin/dashboard" : "citizen".equals(role) ? "/citizen/dashboard" : "/";
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= status %> - SarkarSathi</title>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = { theme: { extend: { fontFamily: { sans: ['Outfit','sans-serif'] }, colors: { brand: { 900:'#0b3d86' }}}}}
        </script>
    </head>
    <body class="m-0 min-h-screen font-sans text-slate-900 bg-[#f7f8fb]">
        <main class="min-h-screen flex items-center justify-center p-5 sm:p-8">
            <section class="w-full max-w-[720px] border border-slate-200 rounded-2xl bg-white shadow-[0_24px_60px_rgba(15,23,42,0.08)] overflow-hidden" aria-labelledby="error-title">
                <div class="px-5 sm:px-8 py-7 border-b border-slate-100">
                    <p class="mb-4 text-lg font-extrabold text-brand-900">SarkarSathi</p>
                    <span class="inline-flex items-center h-[34px] px-3 rounded-full bg-blue-50 text-brand-900 text-[13px] font-bold">Error <%= status %></span>
                    <h1 id="error-title" class="mt-4 mb-2.5 text-[clamp(30px,5vw,46px)] font-extrabold leading-[1.05]"><%= esc(titleFor(status)) %></h1>
                    <p class="text-slate-500 text-[17px] leading-relaxed"><%= esc(messageFor(status)) %></p>
                </div>
                <div class="px-5 sm:px-8 pt-6 pb-8">
                    <div class="grid gap-3 mb-6 p-4 rounded-xl bg-slate-50 border border-slate-100">
                        <div>
                            <span class="block mb-1 text-slate-500 text-xs font-bold uppercase">What to do next</span>
                            <span class="text-slate-800 text-[15px] break-words"><%= esc(nextStepFor(status)) %></span>
                        </div>
                        <% if (!requestUri.isBlank()) { %>
                            <div>
                                <span class="block mb-1 text-slate-500 text-xs font-bold uppercase">Page</span>
                                <span class="text-slate-800 text-[15px] break-words"><%= requestUri %></span>
                            </div>
                        <% } %>
                    </div>
                    <div class="flex flex-col sm:flex-row flex-wrap gap-3">
                        <a class="inline-flex items-center justify-center min-h-[44px] px-5 rounded-xl text-sm font-bold no-underline bg-brand-900 text-white" href="<%= contextPath + dashboardPath %>">Go to <%= dashboardPath.contains("dashboard") ? "Dashboard" : "Home" %></a>
                        <a class="inline-flex items-center justify-center min-h-[44px] px-5 rounded-xl text-sm font-bold no-underline border border-slate-300 text-slate-700 bg-white" href="<%= contextPath %>/announcements">Recent Announcements</a>
                        <a class="inline-flex items-center justify-center min-h-[44px] px-5 rounded-xl text-sm font-bold no-underline border border-slate-300 text-slate-700 bg-white" href="<%= contextPath %>/contact">Support</a>
                    </div>
                </div>
            </section>
        </main>
    </body>
</html>
