<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - HRM System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Font Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Global Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/sidebar.jsp"/>
    
    <div class="main-content">
        <jsp:include page="/WEB-INF/includes/header.jsp"/>
        
        <div class="content-wrapper">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1 class="page-title">Đổi mật khẩu</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/profile"> / Hồ sơ</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Đổi mật khẩu</li>
                    </ul>
                </div>
            </div>

            <!-- Error Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger-custom alert-custom shadow-sm mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <div class="row justify-content-center">
                <div class="col-12 col-lg-6">
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary);">
                            <i class="fa-solid fa-key text-primary me-2"></i> Thiết lập mật khẩu mới
                        </h4>
                        
                        <form method="post" action="${pageContext.request.contextPath}/profile/change-password" onsubmit="return validateForm()">
                            <!-- Old Password -->
                            <div class="form-group-custom">
                                <label for="oldPassword" class="form-label-custom">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                                <input type="password" id="oldPassword" name="oldPassword" class="form-control-custom form-control" required placeholder="Nhập mật khẩu hiện tại">
                                <div class="invalid-feedback">Vui lòng nhập mật khẩu hiện tại.</div>
                            </div>
                            
                            <!-- New Password -->
                            <div class="form-group-custom">
                                <label for="newPassword" class="form-label-custom">Mật khẩu mới <span class="text-danger">*</span></label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control-custom form-control" required placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)">
                                <div class="invalid-feedback" id="newPasswordFeedback">Mật khẩu mới phải từ 6 ký tự trở lên.</div>
                            </div>
                            
                            <!-- Confirm Password -->
                            <div class="form-group-custom">
                                <label for="confirmPassword" class="form-label-custom">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control-custom form-control" required placeholder="Xác nhận mật khẩu mới">
                                <div class="invalid-feedback">Xác nhận mật khẩu không trùng khớp với mật khẩu mới.</div>
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Actions -->
                            <div class="d-flex gap-3 justify-content-end">
                                <a href="${pageContext.request.contextPath}/profile" class="btn-custom btn-secondary-custom">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-custom btn-primary-custom">
                                    <i class="fa-solid fa-check"></i> Đổi mật khẩu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>

    <script>
        function validateForm() {
            var oldPassword = document.getElementById("oldPassword").value;
            var newPassword = document.getElementById("newPassword").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var isValid = true;
            
            // Reset validation states
            document.getElementById("oldPassword").classList.remove("is-invalid");
            document.getElementById("newPassword").classList.remove("is-invalid");
            document.getElementById("confirmPassword").classList.remove("is-invalid");
            
            if (!oldPassword) {
                document.getElementById("oldPassword").classList.add("is-invalid");
                isValid = false;
            }
            
            if (!newPassword || newPassword.length < 6) {
                document.getElementById("newPasswordFeedback").innerText = "Mật khẩu mới phải từ 6 ký tự trở lên.";
                document.getElementById("newPassword").classList.add("is-invalid");
                isValid = false;
            }
            
            if (newPassword && newPassword === oldPassword) {
                document.getElementById("newPasswordFeedback").innerText = "Mật khẩu mới không được trùng với mật khẩu cũ.";
                document.getElementById("newPassword").classList.add("is-invalid");
                isValid = false;
            }
            
            if (newPassword && newPassword !== confirmPassword) {
                document.getElementById("confirmPassword").classList.add("is-invalid");
                isValid = false;
            }
            
            return isValid;
        }
    </script>
</body>
</html>
