<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Toast Notification Component - for system messages and feedback
     Usage:
     1. Add data attributes to page: toastMessage, toastType (success/error/warning/info)
     2. Include this component where you want toasts to appear
-->
<%
    String toastMessage = (String) request.getAttribute("toastMessage");
    String toastType = (String) request.getAttribute("toastType");
    if (toastType == null) toastType = "info";
%>

<style>
    .toast-container {
        position: fixed;
        top: 1rem;
        right: 1rem;
        z-index: 9999;
        max-width: 28rem;
    }

    .toast {
        animation: slideIn 0.3s ease-out forwards;
        margin-bottom: 0.5rem;
    }

    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(100%);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    @keyframes slideOut {
        to {
            opacity: 0;
            transform: translateX(100%);
        }
    }

    .toast.exit {
        animation: slideOut 0.3s ease-out forwards;
    }

    .toast-success {
        background: #f0fdf4;
        border: 1px solid #dcfce7;
        color: #166534;
    }

    .toast-error {
        background: #fef2f2;
        border: 1px solid #fee2e2;
        color: #991b1b;
    }

    .toast-warning {
        background: #fffbeb;
        border: 1px solid #fef3c7;
        color: #92400e;
    }

    .toast-info {
        background: #f0f9ff;
        border: 1px solid #e0f2fe;
        color: #0c4a6e;
    }
</style>

<% if (toastMessage != null && !toastMessage.isEmpty()) { %>
    <div class="toast-container" id="toast-container">
        <div class="toast toast-<%= toastType %> rounded-lg px-4 py-3 border shadow-md flex items-start gap-3">
            <div class="pt-0.5">
                <% if ("success".equals(toastType)) { %>
                    <i data-lucide="check-circle" class="h-5 w-5"></i>
                <% } else if ("error".equals(toastType)) { %>
                    <i data-lucide="alert-circle" class="h-5 w-5"></i>
                <% } else if ("warning".equals(toastType)) { %>
                    <i data-lucide="alert-triangle" class="h-5 w-5"></i>
                <% } else { %>
                    <i data-lucide="info" class="h-5 w-5"></i>
                <% } %>
            </div>
            <div class="flex-1">
                <p class="text-sm font-semibold"><%= toastMessage %></p>
            </div>
            <button class="text-lg leading-none opacity-50 hover:opacity-100 transition-opacity" onclick="this.parentElement.classList.add('exit'); setTimeout(() => this.parentElement.parentElement.remove(), 300);">
                ×
            </button>
        </div>
    </div>

    <script>
        // Auto-dismiss toast after 5 seconds
        setTimeout(() => {
            const toast = document.querySelector('.toast');
            if (toast) {
                toast.classList.add('exit');
                setTimeout(() => toast.parentElement.remove(), 300);
            }
        }, 5000);
    </script>
<% } %>
