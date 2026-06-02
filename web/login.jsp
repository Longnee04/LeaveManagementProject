<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Leave Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body class="login-page">
        <div class="login-card">
            <h1>Leave Management</h1>
            <p class="subtitle">Đăng nhập theo vai trò của bạn</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/login">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required
                           placeholder="vd: admin@company.com"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" required
                           placeholder="Nhập mật khẩu">
                </div>
                <button type="submit" class="btn-primary">Đăng nhập</button>
            </form>

            <div class="demo-accounts">
                <strong>Tài khoản demo</strong>
                <ul>
                    <li>Admin: admin@company.com / admin123</li>
                    <li>Manager: manager@company.com / manager123</li>
                    <li>Employee: employee@company.com / employee123</li>
                </ul>
            </div>
        </div>
    </body>
</html>
