<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Breadcrumb Navigation Component -->
<nav class="px-4 py-3 lg:px-12 bg-white border-b border-slate-200">
  <div class="mx-auto max-w-7xl">
    <ol class="flex items-center gap-2 text-sm">
      <li>
        <a
          href="<%= request.getContextPath() %>/"
          class="text-slate-600 hover:text-brand-900 transition-colors flex items-center gap-1"
        >
          <i data-lucide="home" class="h-4 w-4"></i>
          <span class="hidden sm:inline">Home</span>
        </a>
      </li>
      <% String currentPath = request.getServletPath(); String[] segments =
      currentPath.split("/"); String breadcrumbPath = ""; for(int i = 1; i <
      segments.length; i++)
      {if(segments[i].isEmpty() || segments[i].equals("pages") || segments[i].equals("admin") || segments[i].equals("citizen")) continue;
                    
                    breadcrumbPath += "/" + segments[i];
                    String label = segments[i].replaceAll("-", " ");
                    label = label.substring(0,
        1).toUpperCase() + label.substring(1);
                    
                    if(i == segments.length - 1) {
          // Last segment - not a link %>
          <li class="flex items-center gap-2">
            <span class="text-slate-400">/</span>
            <span class="text-slate-900 font-medium"><%= label %></span>
          </li>
          <%
        }
        else {
          // Intermediate segment %>
          <li class="flex items-center gap-2">
            <span class="text-slate-400">/</span>
            <a
              href="<%= request.getContextPath() %><%= breadcrumbPath %>"
              class="text-slate-600 hover:text-brand-900 transition-colors"
            >
              <%= label %>
            </a>
          </li>
          <%
        }
      }
      %>
    </ol>
  </div>
</nav>
