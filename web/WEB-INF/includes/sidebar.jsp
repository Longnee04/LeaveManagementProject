<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%
    User currentUser = (User) session.getAttribute("loggedUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = currentUser.getRoleName();
%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-brand">
            <i class="fa-solid fa-hotel"></i>
            <span>HRM System</span>
        </a>
    </div>
    <div class="sidebar-menu-wrapper" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; overflow-y: auto;">
        <ul class="sidebar-menu" style="flex: 1; padding: 24px 16px; list-style: none; margin-bottom: 0;">
            <!-- Dashboard (Shared) -->
            <li class="sidebar-menu-item" data-href="/dashboard">
                <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-menu-link">
                    <i class="fa-solid fa-gauge-high"></i>
                    <span>Dashboard</span>
                </a>
            </li>

            <% if ("Admin".equals(role)) { %>
                <!-- Admin Menu -->
                <li class="sidebar-menu-item" data-href="/admin/employees">
                    <a href="${pageContext.request.contextPath}/admin/employees" class="sidebar-menu-link">
                        <i class="fa-solid fa-users"></i>
                        <span>Quản lý Nhân viên</span>
                    </a>
                </li>
                <li class="sidebar-menu-item" data-href="/admin/leave-types">
                    <a href="${pageContext.request.contextPath}/admin/leave-types" class="sidebar-menu-link">
                        <i class="fa-solid fa-list-check"></i>
                        <span>Loại nghỉ phép</span>
                    </a>
                </li>
                <li class="sidebar-menu-item" data-href="/admin/leave-requests">
                    <a href="${pageContext.request.contextPath}/admin/leave-requests" class="sidebar-menu-link">
                        <i class="fa-solid fa-file-lines"></i>
                        <span>Tất cả đơn nghỉ</span>
                    </a>
                </li>
            <% } %>

            <% if ("Manager".equals(role)) { %>
                <!-- Manager Menu -->
                <li class="sidebar-menu-item" data-href="/manager/leave-requests">
                    <a href="${pageContext.request.contextPath}/manager/leave-requests" class="sidebar-menu-link">
                        <i class="fa-solid fa-file-circle-check"></i>
                        <span>Duyệt đơn nghỉ</span>
                    </a>
                </li>
                <li class="sidebar-menu-item" data-href="/manager/schedules">
                    <a href="${pageContext.request.contextPath}/manager/schedules" class="sidebar-menu-link">
                        <i class="fa-solid fa-calendar-check"></i>
                        <span>Duyệt lịch làm</span>
                    </a>
                </li>
            <% } %>

            <% if ("Employee".equals(role)) { %>
                <!-- Employee Menu -->
                <li class="sidebar-menu-item" data-href="/employee/leave-requests">
                    <a href="${pageContext.request.contextPath}/employee/leave-requests" class="sidebar-menu-link">
                        <i class="fa-solid fa-file-lines"></i>
                        <span>Đơn nghỉ phép</span>
                    </a>
                </li>
                <li class="sidebar-menu-item" data-href="/employee/schedules">
                    <a href="${pageContext.request.contextPath}/employee/schedules" class="sidebar-menu-link">
                        <i class="fa-solid fa-calendar-plus"></i>
                        <span>Đăng ký lịch làm</span>
                    </a>
                </li>
            <% } %>

            <!-- Shared Menu Elements -->
            <li class="sidebar-menu-item" data-href="/agenda">
                <a href="${pageContext.request.contextPath}/agenda" class="sidebar-menu-link">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Lịch họp & Sự kiện</span>
                </a>
            </li>
            <li class="sidebar-menu-item" data-href="/attendance">
                <a href="${pageContext.request.contextPath}/attendance" class="sidebar-menu-link">
                    <i class="fa-solid fa-clock"></i>
                    <span>Chấm công</span>
                </a>
            </li>
            <li class="sidebar-menu-item" data-href="/profile">
                <a href="${pageContext.request.contextPath}/profile" class="sidebar-menu-link">
                    <i class="fa-solid fa-user"></i>
                    <span>Hồ sơ cá nhân</span>
                </a>
            </li>
        </ul>
        
        <div class="sidebar-footer" style="padding: 16px; border-top: 1px solid var(--border-color); margin-top: auto;">
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Đăng xuất</span>
            </a>
        </div>
    </div>
</aside>

<script>
    // Tự động active sidebar menu item dựa trên URL hiện tại
    document.addEventListener("DOMContentLoaded", function() {
        var path = window.location.pathname;
        var contextPath = "${pageContext.request.contextPath}";
        var relativePath = path.substring(contextPath.length);
        
        var menuItems = document.querySelectorAll(".sidebar-menu-item");
        menuItems.forEach(function(item) {
            var dataHref = item.getAttribute("data-href");
            if (relativePath === dataHref || relativePath.startsWith(dataHref + "/")) {
                item.classList.add("active");
            } else {
                item.classList.remove("active");
            }
        });
    });
</script>
