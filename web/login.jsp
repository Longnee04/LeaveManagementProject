<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Mini HRM System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Font Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Global Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .input-group-text {
            background-color: transparent;
            border-right: none;
            color: var(--text-secondary);
        }
        .form-control-custom {
            border-left: none;
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
        }
        .demo-card {
            background-color: #f8fafc;
            border: 1px dashed var(--border-color);
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
        }
        .demo-item {
            cursor: pointer;
            padding: 5px 8px;
            border-radius: 4px;
            transition: background var(--transition-speed);
        }
        .demo-item:hover {
            background-color: #e2e8f0;
        }
    </style>
</head>
<body class="login-page-body">
    <div class="login-card-custom">
        <div class="login-header-custom">
            <h2>MINI HRM SYSTEM</h2>
            <p>Hệ thống Quản trị Nhân sự & Nghỉ phép Nội bộ</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="font-size: 0.85rem; border-radius: 8px;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i><%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="padding: 1.05rem;"></button>
            </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm" onsubmit="return validateForm()">
            <!-- Email Input -->
            <div class="mb-3">
                <label for="email" class="form-label-custom">Địa chỉ Email</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                    <input type="email" id="email" name="email" class="form-control-custom form-control" required
                           placeholder="vd: admin@company.com"
                           value="<%= request.getAttribute("rememberEmail") != null ? request.getAttribute("rememberEmail") : "" %>">
                </div>
                <div class="invalid-feedback" id="emailError">Vui lòng nhập địa chỉ email hợp lệ.</div>
            </div>

            <!-- Password Input -->
            <div class="mb-3">
                <label for="password" class="form-label-custom">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" id="password" name="password" class="form-control-custom form-control" required
                           placeholder="Nhập mật khẩu">
                    <button class="btn btn-outline-secondary" type="button" id="togglePasswordBtn" style="border-left: none; border-color: var(--border-color); color: var(--text-secondary);">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>
                <div class="invalid-feedback" id="passwordError">Vui lòng nhập mật khẩu.</div>
            </div>

            <!-- Remember Me & Forgot Password -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="form-check m-0">
                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe"
                           <%= request.getAttribute("rememberMeChecked") != null && (boolean)request.getAttribute("rememberMeChecked") ? "checked" : "" %>>
                    <label class="form-check-label" for="rememberMe" style="font-size: 0.85rem; color: var(--text-secondary); cursor: pointer;">Ghi nhớ đăng nhập</label>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-custom btn-primary-custom w-100 py-2.5">
                <i class="fa-solid fa-right-to-bracket"></i> Đăng nhập
            </button>
        </form>

        <!-- Demo Accounts Section -->
        <div class="demo-card">
            <strong style="font-size: 0.825rem; color: var(--text-primary); display: block; margin-bottom: 8px;">
                <i class="fa-solid fa-circle-info text-primary me-1"></i> Tài khoản Demo (Click để điền nhanh)
            </strong>
            <div style="font-size: 0.75rem;">
                <div class="demo-item d-flex justify-content-between align-items-center" onclick="fillAccount('admin@company.com', 'admin123')">
                    <span><i class="fa-solid fa-user-shield text-danger me-1"></i> Quản trị viên (Admin)</span>
                    <strong class="text-primary">admin123</strong>
                </div>
                <div class="demo-item d-flex justify-content-between align-items-center" onclick="fillAccount('manager@company.com', 'manager123')">
                    <span><i class="fa-solid fa-user-tie text-warning me-1"></i> Quản lý (Manager)</span>
                    <strong class="text-primary">manager123</strong>
                </div>
                <div class="demo-item d-flex justify-content-between align-items-center" onclick="fillAccount('employee@company.com', 'employee123')">
                    <span><i class="fa-solid fa-user text-success me-1"></i> Nhân viên (Employee)</span>
                    <strong class="text-primary">employee123</strong>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm tự động điền tài khoản nhanh khi click
        function fillAccount(email, password) {
            document.getElementById("email").value = email;
            document.getElementById("password").value = password;
        }

        // Hiện/ẩn mật khẩu
        var togglePasswordBtn = document.getElementById("togglePasswordBtn");
        var passwordInput = document.getElementById("password");
        if (togglePasswordBtn && passwordInput) {
            togglePasswordBtn.addEventListener("click", function() {
                var type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
                passwordInput.setAttribute("type", type);
                
                var icon = this.querySelector("i");
                if (type === "text") {
                    icon.classList.remove("fa-eye");
                    icon.classList.add("fa-eye-slash");
                } else {
                    icon.classList.remove("fa-eye-slash");
                    icon.classList.add("fa-eye");
                }
            });
        }

        // Validate phía client trước khi submit
        function validateForm() {
            var email = document.getElementById("email").value.trim();
            var password = document.getElementById("password").value;
            var isValid = true;

            // Reset errors
            document.getElementById("email").classList.remove("is-invalid");
            document.getElementById("password").classList.remove("is-invalid");

            if (!email || !email.includes("@")) {
                document.getElementById("email").classList.add("is-invalid");
                isValid = false;
            }
            if (!password) {
                document.getElementById("password").classList.add("is-invalid");
                isValid = false;
            }

            return isValid;
        }
    </script>
</body>
</html>
