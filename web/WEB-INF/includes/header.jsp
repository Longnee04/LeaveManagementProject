<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%
    User currentUserHeader = (User) session.getAttribute("loggedUser");
    if (currentUserHeader == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String roleClassHeader = currentUserHeader.getRoleName() != null
            ? currentUserHeader.getRoleName().toLowerCase()
            : "";
    // Lấy ký tự đầu tiên của tên để làm avatar
    String firstCharName = currentUserHeader.getFullName() != null && !currentUserHeader.getFullName().isEmpty()
            ? currentUserHeader.getFullName().substring(0, 1).toUpperCase()
            : "U";
%>
<header class="top-navbar">
    <div class="navbar-left">
        <button class="menu-toggle" id="menuToggleBtn">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="d-none d-sm-block">
            <h5 class="m-0 font-weight-bold" style="font-size: 1rem; color: var(--text-secondary);">
                Xin chào, <strong style="color: var(--text-primary);"><%= currentUserHeader.getFullName() %></strong>
            </h5>
        </div>
    </div>
    
    <div class="navbar-right">
        <span class="role-badge <%= roleClassHeader %>"><%= currentUserHeader.getRoleName() %></span>
        
        <div class="dropdown user-dropdown">
            <button class="user-dropdown-toggle dropdown-toggle" type="button" id="userMenuDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="user-avatar"><%= firstCharName %></div>
                <span class="d-none d-md-inline"><%= currentUserHeader.getFullName() %></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0" aria-labelledby="userMenuDropdown" style="margin-top: 10px; border-radius: 8px;">
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile" style="font-size: 0.9rem; padding: 10px 20px;">
                        <i class="fa-solid fa-user-circle me-2" style="color: var(--text-secondary);"></i>Hồ sơ của tôi
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile/change-password" style="font-size: 0.9rem; padding: 10px 20px;">
                        <i class="fa-solid fa-key me-2" style="color: var(--text-secondary);"></i>Đổi mật khẩu
                    </a>
                </li>
                <li><hr class="dropdown-divider" style="margin: 5px 0; border-color: var(--border-color);"></li>
                <li>
                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout" style="font-size: 0.9rem; padding: 10px 20px; font-weight: 600;">
                        <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>

<script>
    // Xử lý đóng mở sidebar trên thiết bị di động
    document.addEventListener("DOMContentLoaded", function() {
        var toggleBtn = document.getElementById("menuToggleBtn");
        var sidebar = document.getElementById("sidebar");
        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener("click", function(e) {
                e.stopPropagation();
                sidebar.classList.toggle("open");
            });
            document.addEventListener("click", function(e) {
                if (sidebar.classList.contains("open") && !sidebar.contains(e.target) && e.target !== toggleBtn) {
                    sidebar.classList.remove("open");
                }
            });
        }
    });
</script>
