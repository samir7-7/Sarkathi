<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
  function toggleMobileMenu() {
    const menu = document.getElementById("mobile-menu");
    const isOpen = !menu.classList.contains("hidden");
    if (isOpen) {
      menu.classList.add("hidden");
    } else {
      menu.classList.remove("hidden");
    }
  }

  function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebar-overlay");
    if (!sidebar) return;

    const isOpen = !sidebar.classList.contains("-translate-x-full");
    if (isOpen) {
      sidebar.classList.add("-translate-x-full");
      overlay && overlay.classList.add("hidden");
    } else {
      sidebar.classList.remove("-translate-x-full");
      overlay && overlay.classList.remove("hidden");
    }
  }

  // Close sidebar when a link is clicked on mobile
  document.addEventListener("DOMContentLoaded", function () {
    const sidebarLinks = document.querySelectorAll("#sidebar a");
    sidebarLinks.forEach((link) => {
      link.addEventListener("click", () => {
        const sidebar = document.getElementById("sidebar");
        const overlay = document.getElementById("sidebar-overlay");
        if (sidebar && !sidebar.classList.contains("-translate-x-full")) {
          sidebar.classList.add("-translate-x-full");
          overlay && overlay.classList.add("hidden");
        }
      });
    });

    // Close sidebar when overlay is clicked
    const overlay = document.getElementById("sidebar-overlay");
    overlay && overlay.addEventListener("click", toggleSidebar);
  });

  // Form validation feedback
  function validateEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
  }

  function showFormValidation(fieldId, isValid, message = "") {
    const field = document.getElementById(fieldId);
    if (!field) return;

    const parent = field.parentElement;
    const hint = parent.querySelector(".form-hint");

    if (isValid) {
      field.classList.remove("error");
      field.classList.add("success");
      if (hint) {
        hint.classList.remove("error");
        hint.classList.add("success");
      }
    } else {
      field.classList.add("error");
      field.classList.remove("success");
      if (hint) {
        hint.classList.add("error");
        hint.textContent = message;
      }
    }
  }
</script>
