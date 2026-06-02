<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manager - Leave Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/includes/header.jsp"/>
        <main class="dashboard-main">
            <div class="dashboard-card">
                <h2>Trang quản lý (Manager)</h2>
                <p>Chào mừng bạn đến khu vực quản lý nhóm và duyệt đơn nghỉ phép.</p>
                <ul class="feature-list">
                    <li class="manager">Duyệt / từ chối đơn nghỉ phép của nhân viên</li>
                    <li class="manager">Xem lịch làm việc và chấm công nhóm</li>
                    <li class="manager">Theo dõi tình trạng nghỉ phép phòng ban</li>
                </ul>
            </div>
        </main>
    </body>
</html>
