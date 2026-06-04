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
<script>
    // Theme Initialization (Runs immediately to prevent screen flash of wrong theme)
    (function() {
        var savedTheme = localStorage.getItem("hrm-theme-mode") || "light";
        var savedColor = localStorage.getItem("hrm-theme-color") || "blue";
        document.documentElement.setAttribute("data-theme", savedTheme);
        document.documentElement.setAttribute("data-theme-color", savedColor);
    })();
</script>

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
    
    <div class="navbar-right d-flex align-items-center gap-3">
        <span class="role-badge <%= roleClassHeader %>"><%= currentUserHeader.getRoleName() %></span>
        
        <!-- Theme Switcher Dropdown -->
        <div class="dropdown theme-dropdown">
            <button class="btn-theme-toggle" type="button" id="themeMenuDropdown" data-bs-toggle="dropdown" aria-expanded="false" title="Tùy chỉnh giao diện" style="background: none; border: none; font-size: 1.25rem; color: var(--text-secondary); cursor: pointer; padding: 0; display: flex; align-items: center; justify-content: center; width: 38px; height: 38px; border-radius: 50%; transition: all var(--transition-speed); border: 1px solid var(--border-color);">
                <i class="fa-solid fa-palette"></i>
            </button>
            <div class="dropdown-menu dropdown-menu-end shadow border-0 p-3" aria-labelledby="themeMenuDropdown" style="width: 250px; border-radius: 12px; margin-top: 10px;">
                <h6 class="mb-3 fw-bold d-flex align-items-center" style="font-size: 0.85rem; color: var(--text-primary); text-transform: uppercase; letter-spacing: 0.5px;">
                    <i class="fa-solid fa-sliders text-primary me-2"></i>Tùy chỉnh giao diện
                </h6>
                
                <!-- Dark Mode Toggle -->
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom" style="border-color: var(--border-color) !important;">
                    <span class="fw-semibold text-secondary" style="font-size: 0.825rem;">Chế độ tối (Dark Mode)</span>
                    <div class="form-check form-switch m-0">
                        <input class="form-check-input" type="checkbox" id="darkModeSwitch" style="cursor: pointer;">
                    </div>
                </div>
                
                <!-- Color Theme Accent Selection -->
                <span class="fw-semibold text-secondary d-block mb-2" style="font-size: 0.825rem;">Màu chủ đạo</span>
                <div class="d-flex gap-2 justify-content-between">
                    <button type="button" class="btn-color-dot" data-color="blue" style="background-color: #3b82f6; width: 28px; height: 28px; border-radius: 50%; border: 2px solid transparent; cursor: pointer; transition: transform 0.2s;" onclick="changeThemeColor('blue')" title="Xanh năng động"></button>
                    <button type="button" class="btn-color-dot" data-color="green" style="background-color: #10b981; width: 28px; height: 28px; border-radius: 50%; border: 2px solid transparent; cursor: pointer; transition: transform 0.2s;" onclick="changeThemeColor('green')" title="Xanh lục bảo"></button>
                    <button type="button" class="btn-color-dot" data-color="purple" style="background-color: #8b5cf6; width: 28px; height: 28px; border-radius: 50%; border: 2px solid transparent; cursor: pointer; transition: transform 0.2s;" onclick="changeThemeColor('purple')" title="Tím hoàng gia"></button>
                    <button type="button" class="btn-color-dot" data-color="red" style="background-color: #ef4444; width: 28px; height: 28px; border-radius: 50%; border: 2px solid transparent; cursor: pointer; transition: transform 0.2s;" onclick="changeThemeColor('red')" title="Đỏ đam mê"></button>
                    <button type="button" class="btn-color-dot" data-color="orange" style="background-color: #f97316; width: 28px; height: 28px; border-radius: 50%; border: 2px solid transparent; cursor: pointer; transition: transform 0.2s;" onclick="changeThemeColor('orange')" title="Cam hoàng hôn"></button>
                </div>
            </div>
        </div>
        
        <!-- User Menu Dropdown -->
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

<style>
    /* Styling overrides specifically for the theme switcher components */
    .btn-theme-toggle:hover {
        background-color: var(--body-bg);
        color: var(--primary) !important;
        border-color: var(--primary) !important;
    }
    .btn-color-dot.active {
        border-color: var(--text-primary) !important;
        transform: scale(1.18);
        box-shadow: 0 0 8px rgba(0, 0, 0, 0.15);
    }
</style>

<script>
    // Theme switching logic
    function changeThemeColor(color) {
        document.documentElement.setAttribute("data-theme-color", color);
        localStorage.setItem("hrm-theme-color", color);
        updateColorDotActive(color);
    }
    
    function updateColorDotActive(color) {
        document.querySelectorAll(".btn-color-dot").forEach(function(dot) {
            if (dot.getAttribute("data-color") === color) {
                dot.classList.add("active");
            } else {
                dot.classList.remove("active");
            }
        });
    }

    // Xử lý đóng mở và lưu trạng thái giao diện
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
        
        // Dark Mode Logic
        var modeSwitch = document.getElementById("darkModeSwitch");
        var currentMode = localStorage.getItem("hrm-theme-mode") || "light";
        
        if (modeSwitch) {
            modeSwitch.checked = (currentMode === "dark");
            modeSwitch.addEventListener("change", function() {
                var newMode = this.checked ? "dark" : "light";
                document.documentElement.setAttribute("data-theme", newMode);
                localStorage.setItem("hrm-theme-mode", newMode);
            });
        }
        
        // Accent Color Dots
        var currentColor = localStorage.getItem("hrm-theme-color") || "blue";
        updateColorDotActive(currentColor);
    });
</script>
