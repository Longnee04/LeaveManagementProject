<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ - HRM System</title>
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
                    <h1 class="page-title">Chỉnh sửa hồ sơ</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/profile"> / Hồ sơ</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Chỉnh sửa</li>
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
                <div class="col-12 col-lg-8">
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary);">
                            <i class="fa-solid fa-user-pen text-primary me-2"></i> Cập nhật thông tin tài khoản
                        </h4>
                        
                        <form method="post" action="${pageContext.request.contextPath}/profile/edit" onsubmit="return validateForm()">
                            <!-- Full Name -->
                            <div class="form-group-custom">
                                <label for="fullName" class="form-label-custom">Họ và Tên <span class="text-danger">*</span></label>
                                <input type="text" id="fullName" name="fullName" class="form-control-custom form-control" 
                                       value="<%= loggedUser.getFullName() %>" required placeholder="Nhập họ và tên">
                                <div class="invalid-feedback">Họ tên không được để trống.</div>
                            </div>
                            
                            <!-- Email -->
                            <div class="form-group-custom">
                                <label for="email" class="form-label-custom">Địa chỉ Email <span class="text-danger">*</span></label>
                                <input type="email" id="email" name="email" class="form-control-custom form-control" 
                                       value="<%= loggedUser.getEmail() %>" required placeholder="Nhập địa chỉ email">
                                <div class="invalid-feedback">Địa chỉ email không hợp lệ.</div>
                            </div>
                            
                            <!-- Phone -->
                            <div class="form-group-custom">
                                <label for="phone" class="form-label-custom">Số điện thoại</label>
                                <input type="text" id="phone" name="phone" class="form-control-custom form-control" 
                                       value="<%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "" %>" placeholder="Nhập số điện thoại">
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Actions -->
                            <div class="d-flex gap-3 justify-content-end">
                                <a href="${pageContext.request.contextPath}/profile" class="btn-custom btn-secondary-custom">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-custom btn-primary-custom">
                                    <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
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
            var fullName = document.getElementById("fullName").value.trim();
            var email = document.getElementById("email").value.trim();
            var isValid = true;
            
            document.getElementById("fullName").classList.remove("is-invalid");
            document.getElementById("email").classList.remove("is-invalid");
            
            if (!fullName) {
                document.getElementById("fullName").classList.add("is-invalid");
                isValid = false;
            }
            if (!email || !email.includes("@")) {
                document.getElementById("email").classList.add("is-invalid");
                isValid = false;
            }
            
            return isValid;
        }
    </script>
</body>
</html>
