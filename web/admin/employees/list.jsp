<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%@page import="java.util.List"%>
<%
    List<User> list = (List<User>) request.getAttribute("employees");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (searchQuery == null) searchQuery = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Nhân viên - HRM System</title>
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
                    <h1 class="page-title">Quản lý Nhân viên</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Nhân viên</li>
                    </ul>
                </div>
                <a href="${pageContext.request.contextPath}/admin/employees?action=add" class="btn-custom btn-primary-custom">
                    <i class="fa-solid fa-user-plus"></i> Thêm Nhân viên mới
                </a>
            </div>

            <!-- Alerts -->
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success-custom alert-custom shadow-sm mb-4">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= request.getParameter("success") %></span>
                </div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger-custom alert-custom shadow-sm mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span><%= request.getParameter("error") %></span>
                </div>
            <% } %>

            <!-- Search Bar Card -->
            <div class="form-card mb-4" style="padding: 20px;">
                <form method="get" action="${pageContext.request.contextPath}/admin/employees" class="row g-3">
                    <div class="col-12 col-md-10">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0" style="color: var(--text-secondary);">
                                <i class="fa-solid fa-magnifying-glass"></i>
                            </span>
                            <input type="text" name="search" class="form-control" placeholder="Tìm kiếm theo họ tên nhân viên..." 
                                   value="<%= searchQuery %>" style="border-left: none;">
                        </div>
                    </div>
                    <div class="col-12 col-md-2 d-grid">
                        <button type="submit" class="btn-custom btn-secondary-custom">
                            Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>

            <!-- Table Card -->
            <div class="form-card">
                <div class="table-responsive">
                    <% if (list == null || list.isEmpty()) { %>
                        <div class="empty-state-custom">
                            <i class="fa-solid fa-users-slash"></i>
                            <p>Không tìm thấy nhân viên nào phù hợp.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Họ và tên</th>
                                    <th>Liên hệ</th>
                                    <th>Phòng ban</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User emp : list) { %>
                                    <tr>
                                        <td><%= emp.getUserID() %></td>
                                        <td>
                                            <div style="font-weight: 600;"><%= emp.getFullName() %></div>
                                        </td>
                                        <td>
                                            <div><i class="fa-solid fa-envelope text-secondary me-1" style="font-size: 0.8rem;"></i><%= emp.getEmail() %></div>
                                            <% if (emp.getPhone() != null && !emp.getPhone().isEmpty()) { %>
                                                <div style="font-size: 0.8rem; color: var(--text-secondary);"><i class="fa-solid fa-phone text-secondary me-1" style="font-size: 0.75rem;"></i><%= emp.getPhone() %></div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "<span class='text-muted'>Chưa phân bổ</span>" %>
                                        </td>
                                        <td>
                                            <%
                                                String rClass = "employee";
                                                if ("Admin".equals(emp.getRoleName())) rClass = "admin";
                                                else if ("Manager".equals(emp.getRoleName())) rClass = "manager";
                                            %>
                                            <span class="role-badge <%= rClass %>"><%= emp.getRoleName() %></span>
                                        </td>
                                        <td>
                                            <% if (emp.isStatus()) { %>
                                                <span class="status-badge approved">Hoạt động</span>
                                            <% } else { %>
                                                <span class="status-badge rejected">Đã khóa</span>
                                            <% } %>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/employees?action=edit&id=<%= emp.getUserID() %>" 
                                               class="btn-custom btn-outline-custom btn-sm-custom py-1 px-2" title="Chỉnh sửa">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </a>
                                            <% if (emp.isStatus()) { %>
                                                <a href="${pageContext.request.contextPath}/admin/employees?action=delete&id=<%= emp.getUserID() %>" 
                                                   class="btn-custom btn-danger-custom btn-sm-custom py-1 px-2 ms-1" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn ngưng hoạt động tài khoản này không?')" title="Khóa tài khoản">
                                                    <i class="fa-solid fa-user-xmark"></i> Khóa
                                                </a>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <% if (totalPages > 1) { %>
                            <nav class="d-flex justify-content-center mt-4">
                                <ul class="pagination pagination-sm m-0">
                                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/employees?search=<%= searchQuery %>&page=<%= currentPage - 1 %>">
                                            <i class="fa-solid fa-chevron-left"></i> Trượt
                                        </a>
                                    </li>
                                    <% for (int p = 1; p <= totalPages; p++) { %>
                                        <li class="page-item <%= p == currentPage ? "active" : "" %>">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/employees?search=<%= searchQuery %>&page=<%= p %>"><%= p %></a>
                                        </li>
                                    <% } %>
                                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/employees?search=<%= searchQuery %>&page=<%= currentPage + 1 %>">
                                            Tiếp <i class="fa-solid fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>
</body>
</html>
