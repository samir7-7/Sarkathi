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
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                min-height: 100vh;
                font-family: "Outfit", Arial, sans-serif;
                color: #0f172a;
                background: #f7f8fb;
            }
            .page {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 32px 18px;
            }
            .panel {
                width: min(720px, 100%);
                border: 1px solid #e2e8f0;
                border-radius: 18px;
                background: #ffffff;
                box-shadow: 0 24px 60px rgba(15, 23, 42, 0.08);
                overflow: hidden;
            }
            .top {
                padding: 28px 30px;
                border-bottom: 1px solid #eef2f7;
            }
            .brand {
                margin: 0 0 18px;
                font-size: 18px;
                font-weight: 800;
                color: #0b3d86;
            }
            .code {
                display: inline-flex;
                align-items: center;
                height: 34px;
                padding: 0 12px;
                border-radius: 999px;
                background: #eef5ff;
                color: #154a91;
                font-size: 13px;
                font-weight: 700;
            }
            h1 {
                margin: 18px 0 10px;
                font-size: clamp(30px, 5vw, 46px);
                line-height: 1.05;
                letter-spacing: 0;
            }
            .message {
                margin: 0;
                color: #475569;
                font-size: 17px;
                line-height: 1.6;
            }
            .body {
                padding: 24px 30px 30px;
            }
            .info {
                display: grid;
                gap: 12px;
                margin: 0 0 24px;
                padding: 18px;
                border-radius: 14px;
                background: #f8fafc;
                border: 1px solid #e8edf4;
            }
            .label {
                display: block;
                margin-bottom: 4px;
                color: #64748b;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
            }
            .value {
                color: #1e293b;
                font-size: 15px;
                word-break: break-word;
            }
            .actions {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
            }
            .button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 44px;
                padding: 0 18px;
                border-radius: 12px;
                font-size: 14px;
                font-weight: 700;
                text-decoration: none;
            }
            .primary {
                background: #0b3d86;
                color: #ffffff;
            }
            .secondary {
                border: 1px solid #cbd5e1;
                color: #334155;
                background: #ffffff;
            }
            @media (max-width: 560px) {
                .top, .body { padding-left: 20px; padding-right: 20px; }
                .actions { flex-direction: column; }
                .button { width: 100%; }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <section class="panel" aria-labelledby="error-title">
                <div class="top">
                    <p class="brand">SarkarSathi</p>
                    <span class="code">Error <%= status %></span>
                    <h1 id="error-title"><%= esc(titleFor(status)) %></h1>
                    <p class="message"><%= esc(messageFor(status)) %></p>
                </div>
                <div class="body">
                    <div class="info">
                        <div>
                            <span class="label">What to do next</span>
                            <span class="value"><%= esc(nextStepFor(status)) %></span>
                        </div>
                        <% if (!requestUri.isBlank()) { %>
                            <div>
                                <span class="label">Page</span>
                                <span class="value"><%= requestUri %></span>
                            </div>
                        <% } %>
                    </div>
                    <div class="actions">
                        <a class="button primary" style="background: #0b3d86;" href="<%= contextPath + dashboardPath %>">Go to <%= dashboardPath.contains("dashboard") ? "Dashboard" : "Home" %></a>
                        <a class="button secondary" href="<%= contextPath %>/announcements">Recent Announcements</a>
                        <a class="button secondary" href="<%= contextPath %>/contact">Support</a>
                    </div>
                </div>
            </section>
        </main>

    </body>
</html>
