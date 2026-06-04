<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Mini HRM System</title>
    <!-- Theme Initialization -->
    <script>
        (function() {
            var savedTheme = localStorage.getItem("hrm-theme-mode") || "light";
            var savedColor = localStorage.getItem("hrm-theme-color") || "blue";
            document.documentElement.setAttribute("data-theme", savedTheme);
            document.documentElement.setAttribute("data-theme-color", savedColor);
        })();
    </script>
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
    </style>
</head>
<body class="login-page-body">
    <div class="login-card-custom" style="max-width: 420px; width: 100%;">
        <div class="login-header-custom">
            <h2>QUÊN MẬT KHẨU</h2>
            <p>Nhập email tài khoản để nhận mã xác thực đặt lại mật khẩu</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="font-size: 0.85rem; border-radius: 8px;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i><%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="padding: 1.05rem;"></button>
            </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/forgot-password" id="forgotForm" onsubmit="return validateForm()">
            <!-- Email Input -->
            <div class="mb-4">
                <label for="email" class="form-label-custom">Địa chỉ Email đã đăng ký</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                    <input type="email" id="email" name="email" class="form-control-custom form-control" required
                           placeholder="vd: user@company.com">
                </div>
                <div class="invalid-feedback" id="emailError">Vui lòng nhập địa chỉ email hợp lệ.</div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-custom btn-primary-custom w-100 py-2.5 mb-3">
                <i class="fa-solid fa-paper-plane me-1"></i> Gửi mã xác thực OTP
            </button>
            
            <!-- Back to Login Link -->
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/login" style="font-size: 0.875rem; text-decoration: none; color: var(--text-secondary); font-weight: 500;">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại trang Đăng nhập
                </a>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validateForm() {
            var email = document.getElementById("email").value.trim();
            var isValid = true;

            document.getElementById("email").classList.remove("is-invalid");

            if (!email || !email.includes("@")) {
                document.getElementById("email").classList.add("is-invalid");
                isValid = false;
            }

            return isValid;
        }
    </script>
</body>
</html>
