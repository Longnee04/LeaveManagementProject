<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee - Leave Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/includes/header.jsp"/>
        <main class="dashboard-main">
            <div class="dashboard-card">
                <h2>Trang nhân viên (Employee)</h2>
                <p>Chào mừng bạn đến khu vực tạo và theo dõi đơn nghỉ phép cá nhân.</p>
                <ul class="feature-list">
                    <li class="employee">Tạo đơn xin nghỉ phép mới</li>
                    <li class="employee">Xem trạng thái đơn đã gửi</li>
                    <li class="employee">Theo dõi số ngày phép còn lại</li>
                </ul>
            </div>
        </main>
    </body>
</html>
