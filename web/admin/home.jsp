<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - Leave Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/includes/header.jsp"/>
        <main class="dashboard-main">
            <div class="dashboard-card">
                <h2>Trang quản trị (Admin)</h2>
                <p>Chào mừng bạn đến khu vực quản trị hệ thống quản lý nghỉ phép.</p>
                <ul class="feature-list">
                    <li>Quản lý người dùng, phòng ban và vai trò</li>
                    <li>Cấu hình loại nghỉ phép và chính sách</li>
                    <li>Xem báo cáo tổng hợp toàn hệ thống</li>
                </ul>
            </div>
        </main>
    </body>
</html>
