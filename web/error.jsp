<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Có lỗi xảy ra - HRM System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Font Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Global Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="login-page-body">
    <div class="login-card-custom text-center" style="max-width: 500px;">
        <div class="mb-4">
            <i class="fa-solid fa-triangle-exclamation text-warning" style="font-size: 5rem;"></i>
        </div>
        
        <h2 class="mb-3" style="font-weight: 700; color: #1e3a8a;">Ồ! Có lỗi xảy ra...</h2>
        
        <p class="text-secondary mb-4" style="font-size: 0.95rem;">
            Đường dẫn bạn yêu cầu không tồn tại, hoặc hệ thống vừa xảy ra một lỗi bất ngờ. Vui lòng quay lại trang chủ.
        </p>

        <a href="${pageContext.request.contextPath}/dashboard" class="btn-custom btn-primary-custom w-100 py-2.5">
            <i class="fa-solid fa-house"></i> Quay lại Trang chủ Dashboard
        </a>
        
        <div class="mt-4 pt-3 border-top text-start" style="font-size: 0.8rem; color: var(--text-secondary);">
            <strong>Thông tin kỹ thuật:</strong>
            <ul class="m-0 mt-1 ps-3">
                <li>Phản hồi: HTTP Status <%= response.getStatus() %></li>
                <li>Hệ thống: Tomcat Container & Servlet Engine</li>
            </ul>
        </div>
    </div>
</body>
</html>
