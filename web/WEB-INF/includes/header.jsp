<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%
    User currentUser = (User) session.getAttribute("loggedUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String roleClass = currentUser.getRoleName() != null
            ? currentUser.getRoleName().toLowerCase()
            : "";
%>
<header class="layout-header">
    <div class="brand">Leave Management</div>
    <div class="user-info">
        <span><%= currentUser.getFullName() %> (<%= currentUser.getEmail() %>)</span>
        <span class="role-badge <%= roleClass %>"><%= currentUser.getRoleName() %></span>
        <a class="btn-logout" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
    </div>
</header>
