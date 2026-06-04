<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Mini HRM System</title>
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
    <div class="login-card-custom" style="max-width: 440px; width: 100%;">
        <div class="login-header-custom">
            <h2>ĐẶT LẠI MẬT KHẨU</h2>
            <p>Nhập mã OTP đã được gửi và thiết lập mật khẩu mới</p>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="font-size: 0.825rem; border-radius: 8px;">
                <i class="fa-solid fa-circle-check me-2"></i><%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="padding: 1.05rem;"></button>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="font-size: 0.825rem; border-radius: 8px;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i><%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="padding: 1.05rem;"></button>
            </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/reset-password" id="resetForm" onsubmit="return validateForm()">
            <!-- Email Readonly -->
            <div class="mb-3">
                <label for="email" class="form-label-custom">Email tài khoản</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                    <input type="email" id="email" name="email" class="form-control-custom form-control" readonly required
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (request.getParameter("email") != null ? request.getParameter("email") : "") %>">
                </div>
            </div>

            <!-- OTP Input -->
            <div class="mb-3">
                <label for="otp" class="form-label-custom">Mã xác thực OTP (6 chữ số)</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-shield-halved"></i></span>
                    <input type="text" id="otp" name="otp" class="form-control-custom form-control" required maxlength="6"
                           placeholder="Nhập mã 6 số OTP" pattern="[0-9]{6}">
                </div>
                <div class="invalid-feedback" id="otpError">Vui lòng nhập đúng mã xác thực 6 số.</div>
            </div>

            <!-- New Password -->
            <div class="mb-3">
                <label for="password" class="form-label-custom">Mật khẩu mới</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-key"></i></span>
                    <input type="password" id="password" name="password" class="form-control-custom form-control" required
                           placeholder="Nhập mật khẩu mới">
                    <button class="btn btn-outline-secondary" type="button" id="togglePasswordBtn" style="border-left: none; border-color: var(--border-color); color: var(--text-secondary);">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>
                <div class="invalid-feedback" id="passwordError">Mật khẩu mới không được để trống.</div>
            </div>

            <!-- Confirm Password -->
            <div class="mb-4">
                <label for="confirmPassword" class="form-label-custom">Xác nhận mật khẩu mới</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-key"></i></span>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control-custom form-control" required
                           placeholder="Nhập lại mật khẩu mới">
                </div>
                <div class="invalid-feedback" id="confirmPasswordError">Mật khẩu xác nhận không trùng khớp.</div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-custom btn-primary-custom w-100 py-2.5 mb-3">
                <i class="fa-solid fa-check me-1"></i> Đặt lại mật khẩu
            </button>
            
            <div class="text-center mt-2">
                <a href="${pageContext.request.contextPath}/forgot-password" style="font-size: 0.85rem; text-decoration: none; color: var(--text-secondary); font-weight: 500;">
                    Gửi lại mã OTP
                </a>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle view password
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

        // Validate form client side
        function validateForm() {
            var otp = document.getElementById("otp").value.trim();
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var isValid = true;

            document.getElementById("otp").classList.remove("is-invalid");
            document.getElementById("password").classList.remove("is-invalid");
            document.getElementById("confirmPassword").classList.remove("is-invalid");

            if (!otp || otp.length !== 6 || isNaN(otp)) {
                document.getElementById("otp").classList.add("is-invalid");
                isValid = false;
            }
            if (!password) {
                document.getElementById("password").classList.add("is-invalid");
                isValid = false;
            }
            if (!confirmPassword || password !== confirmPassword) {
                document.getElementById("confirmPassword").classList.add("is-invalid");
                isValid = false;
            }

            return isValid;
        }
    </script>
</body>
</html>
