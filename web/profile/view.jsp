<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String firstChar = loggedUser.getFullName() != null && !loggedUser.getFullName().isEmpty()
            ? loggedUser.getFullName().substring(0, 1).toUpperCase()
            : "U";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ của tôi - HRM System</title>
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
                    <h1 class="page-title">Hồ sơ cá nhân</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Hồ sơ</li>
                    </ul>
                </div>
            </div>

            <!-- Success Messages -->
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success-custom alert-custom shadow-sm">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= request.getParameter("success") %></span>
                </div>
            <% } %>

            <div class="row">
                <div class="col-12 col-md-4">
                    <!-- Profile Card -->
                    <div class="form-card text-center">
                        <div class="mx-auto d-flex align-items-center justify-content-center" 
                             style="width: 100px; height: 100px; border-radius: 50%; background-color: var(--primary); color: white; font-size: 3rem; font-weight: 700;">
                            <%= firstChar %>
                        </div>
                        <h4 class="mt-3 mb-1" style="font-weight: 700;"><%= loggedUser.getFullName() %></h4>
                        <p class="text-secondary mb-3" style="font-size: 0.9rem;"><%= loggedUser.getEmail() %></p>
                        
                        <div class="mb-4">
                            <%
                                String rClass = "employee";
                                if ("Admin".equals(loggedUser.getRoleName())) rClass = "admin";
                                else if ("Manager".equals(loggedUser.getRoleName())) rClass = "manager";
                            %>
                            <span class="role-badge <%= rClass %>"><%= loggedUser.getRoleName() %></span>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/profile/edit" class="btn-custom btn-primary-custom">
                                <i class="fa-solid fa-user-pen"></i> Chỉnh sửa thông tin
                            </a>
                            <a href="${pageContext.request.contextPath}/profile/change-password" class="btn-custom btn-outline-custom">
                                <i class="fa-solid fa-key"></i> Đổi mật khẩu
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="col-12 col-md-8">
                    <!-- Detailed Info Card -->
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary); border-bottom: 2px solid var(--border-color); padding-bottom: 10px;">
                            <i class="fa-solid fa-circle-info text-primary me-2"></i> Thông tin chi tiết
                        </h4>
                        
                        <div class="row g-4">
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Họ và Tên</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= loggedUser.getFullName() %></span>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Địa chỉ Email</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= loggedUser.getEmail() %></span>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Số điện thoại</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= loggedUser.getPhone() != null && !loggedUser.getPhone().isEmpty() ? loggedUser.getPhone() : "Chưa cập nhật" %></span>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Phòng ban</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= loggedUser.getDepartmentName() != null ? loggedUser.getDepartmentName() : "Ban Giám đốc" %></span>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Trạng thái tài khoản</label>
                                <span class="badge bg-success" style="font-size: 0.85rem; padding: 5px 12px; border-radius: 12px;">Đang hoạt động</span>
                            </div>
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Ngày tạo tài khoản</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;">
                                    <%= loggedUser.getCreatedAt() != null ? df.format(loggedUser.getCreatedAt()) : "Hệ thống ban đầu" %>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>
</body>
</html>
