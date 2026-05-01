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
    const isOpen = sidebar.style.transform === "translateX(0px)";
    if (isOpen) {
      sidebar.style.transform = "translateX(-100%)";
    } else {
      sidebar.style.transform = "translateX(0)";
    }
  }
</script>
