<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.AgricultureNotice" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%!
private String esc(Object value) {
    if (value == null) {
        return "";
    }
    return value.toString()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
}

private String categoryClass(String category) {
    if ("subsidy".equals(category)) {
        return "tag subsidy";
    }
    if ("training".equals(category)) {
        return "tag training";
    }
    if ("scheme".equals(category)) {
        return "tag scheme";
    }
    return "tag";
}
%>
<%
Integer adminId = (Integer) request.getAttribute("adminId");
String adminName = (String) request.getAttribute("adminName");
String adminRole = (String) request.getAttribute("adminRole");
String loadError = (String) request.getAttribute("noticeError");
String formError = request.getParameter("error");
List<AgricultureNotice> notices = (List<AgricultureNotice>) request.getAttribute("notices");
DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
if (adminName == null) adminName = "Admin";
if (adminRole == null) adminRole = "admin";
if (notices == null) notices = List.of();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Manage Agriculture Notices - SarkarSathi Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box}body{margin:0;background:#fafafc;color:#1e293b;font-family:'Outfit',Arial,sans-serif}.layout{display:flex;min-height:100vh}.sidebar{position:fixed;inset:0 auto 0 0;width:220px;background:#fff;border-right:1px solid #e2e8f0;display:flex;flex-direction:column}.brand{padding:20px 20px 8px;font-size:21px;font-weight:800}.brand a{color:#0b3d86;text-decoration:none}.brand span{color:#3b82f6}.admin-card{margin:12px 20px;padding:14px;border-radius:14px;background:#f0f5fc}.admin-card strong{display:block;color:#0b3d86}.admin-card small{color:#64748b;text-transform:capitalize}.nav{margin-top:16px;padding:0 12px;display:grid;gap:4px}.nav a,.logout{display:flex;gap:10px;align-items:center;padding:11px 12px;border-radius:10px;color:#475569;text-decoration:none;font-size:14px}.nav a:hover,.nav a.active,.logout:hover{background:#f0f5fc;color:#0b3d86;font-weight:700}.logout-wrap{margin-top:auto;border-top:1px solid #f1f5f9;padding:12px}.logout{color:#dc2626}.content{margin-left:220px;min-height:100vh;width:calc(100% - 220px)}header{position:sticky;top:0;z-index:2;background:rgba(255,255,255,.92);border-bottom:1px solid #e2e8f0;padding:18px 32px}h1{margin:0;font-size:21px;color:#0f172a}main{padding:32px}.panel,.notice,.empty{background:#fff;border:1px solid #f1f5f9;border-radius:16px;box-shadow:0 1px 3px rgba(15,23,42,.04)}.panel{padding:24px;margin-bottom:28px}.panel h2{margin:0 0 18px;font-size:17px;color:#0f172a}.form-grid{display:grid;gap:16px}label{display:block;margin-bottom:6px;color:#334155;font-size:12px;font-weight:800;letter-spacing:.04em;text-transform:uppercase}input,textarea,select{width:100%;border:1px solid #cbd5e1;border-radius:12px;background:#f8fafc;padding:12px 14px;color:#0f172a;font:inherit}textarea{resize:vertical}.actions{display:flex;justify-content:flex-end}.btn{border:0;border-radius:12px;background:#0b3d86;color:#fff;padding:12px 20px;font:inherit;font-size:14px;font-weight:800;cursor:pointer}.btn:hover{background:#082f69}.btn-danger{border:1px solid #fecaca;background:#fff;color:#dc2626;padding:8px 12px}.btn-danger:hover{background:#fef2f2}.notice-list{display:grid;gap:16px}.notice{padding:22px}.notice-head{display:flex;justify-content:space-between;gap:18px;align-items:flex-start}.notice-title{display:flex;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:8px}.notice h3{margin:0;color:#0f172a;font-size:17px}.notice p{margin:0;color:#475569;line-height:1.55}.date{margin-top:12px;color:#94a3b8;font-size:12px}.tag{display:inline-block;border-radius:999px;background:#f8fafc;color:#475569;padding:5px 10px;font-size:11px;font-weight:800;text-transform:uppercase;letter-spacing:.05em}.tag.subsidy{background:#ecfdf5;color:#047857}.tag.training{background:#f5f3ff;color:#6d28d9}.tag.scheme{background:#eff6ff;color:#1d4ed8}.empty{padding:40px;text-align:center;color:#64748b}.alert{border-radius:12px;margin-bottom:18px;padding:12px 14px;background:#fef2f2;color:#b91c1c;border:1px solid #fecaca;font-size:14px}@media(max-width:760px){.sidebar{position:static;width:100%;min-height:auto}.layout{display:block}.content{margin-left:0;width:100%}main,header{padding:20px}.notice-head{display:block}.btn-danger{margin-top:14px}}
</style>
</head>
<body>
<div class="layout">
<aside class="sidebar">
    <div class="brand"><a href="<%= request.getContextPath() %>/">SarkarSathi</a> <span>Admin</span></div>
    <div class="admin-card">
        <strong><%= esc(adminName) %></strong>
        <small><%= esc(adminRole) %></small>
    </div>
    <nav class="nav">
        <a href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/admin/applications">Applications</a>
        <a href="<%= request.getContextPath() %>/admin/announcements">Announcements</a>
        <a href="<%= request.getContextPath() %>/admin/notices" class="active">Agri Notices</a>
        <a href="<%= request.getContextPath() %>/admin/budgets">Budgets</a>
    </nav>
    <div class="logout-wrap"><a class="logout" href="<%= request.getContextPath() %>/logout">Logout</a></div>
</aside>
<div class="content">
    <header><h1>Manage Agriculture Notices</h1></header>
    <main>
        <% if (loadError != null || formError != null) { %>
            <div class="alert"><%= esc(loadError != null ? loadError : formError) %></div>
        <% } %>
        <section class="panel">
            <h2>Create Agriculture Notice</h2>
            <form class="form-grid" method="post" action="<%= request.getContextPath() %>/api/agriculture-notices">
                <input type="hidden" name="redirectTo" value="/admin/notices">
                <input type="hidden" name="adminId" value="<%= adminId == null ? "" : adminId %>">
                <div>
                    <label for="title">Title</label>
                    <input id="title" name="title" type="text" required>
                </div>
                <div>
                    <label for="content">Content</label>
                    <textarea id="content" name="content" rows="4" required></textarea>
                </div>
                <div>
                    <label for="category">Category</label>
                    <select id="category" name="category" required>
                        <option value="subsidy">Subsidy</option>
                        <option value="training">Training</option>
                        <option value="scheme">Scheme</option>
                    </select>
                </div>
                <div class="actions"><button class="btn" type="submit">Publish Notice</button></div>
            </form>
        </section>
        <% if (notices.isEmpty()) { %>
            <div class="empty">No notices</div>
        <% } else { %>
            <section class="notice-list">
            <% for (AgricultureNotice notice : notices) { %>
                <article class="notice">
                    <div class="notice-head">
                        <div>
                            <div class="notice-title">
                                <h3><%= esc(notice.getTitle()) %></h3>
                                <span class="<%= categoryClass(notice.getCategory()) %>"><%= esc(notice.getCategory()) %></span>
                            </div>
                            <p><%= esc(notice.getContent()) %></p>
                            <% if (notice.getPublishedAt() != null) { %>
                                <div class="date"><%= esc(notice.getPublishedAt().format(dateFormatter)) %></div>
                            <% } %>
                        </div>
                        <form method="post" action="<%= request.getContextPath() %>/api/agriculture-notices">
                            <input type="hidden" name="redirectTo" value="/admin/notices">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="noticeId" value="<%= notice.getNoticeId() %>">
                            <button class="btn btn-danger" type="submit">Delete</button>
                        </form>
                    </div>
                </article>
            <% } %>
            </section>
        <% } %>
    </main>
</div>
</div>
</body>
</html>
