<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.LeaveType"%>
<%@page import="java.util.List"%>
<%
    List<LeaveType> list = (List<LeaveType>) request.getAttribute("leaveTypes");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Loại nghỉ phép - HRM System</title>
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
                    <h1 class="page-title">Cấu hình Loại nghỉ phép</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Loại nghỉ phép</li>
                    </ul>
                </div>
                <a href="${pageContext.request.contextPath}/admin/leave-types?action=add" class="btn-custom btn-primary-custom">
                    <i class="fa-solid fa-folder-plus"></i> Thêm loại nghỉ phép
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

            <!-- Table Card -->
            <div class="form-card">
                <div class="table-responsive">
                    <% if (list == null || list.isEmpty()) { %>
                        <div class="empty-state-custom">
                            <i class="fa-solid fa-folder-open"></i>
                            <p>Chưa cấu hình loại nghỉ phép nào trong hệ thống.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên loại nghỉ phép</th>
                                    <th>Mô tả chi tiết</th>
                                    <th>Quy tắc & Giới hạn</th>
                                    <th>Tối đa / năm</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (LeaveType type : list) { %>
                                    <tr>
                                        <td><%= type.getLeaveTypeID() %></td>
                                        <td>
                                            <div style="font-weight: 600;"><%= type.getLeaveTypeName() %></div>
                                        </td>
                                        <td>
                                            <%= type.getDescription() != null && !type.getDescription().isEmpty() ? type.getDescription() : "<span class='text-muted'>Không có mô tả</span>" %>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-wrap gap-1">
                                                <% if (type.isIsWorkingDaysOnly()) { %>
                                                    <span class="badge bg-light text-success border border-success px-2 py-1" style="font-size: 0.75rem;">
                                                        <i class="fa-solid fa-briefcase me-1"></i> Ngày làm việc
                                                    </span>
                                                <% } else { %>
                                                    <span class="badge bg-light text-secondary border border-secondary px-2 py-1" style="font-size: 0.75rem;">
                                                        <i class="fa-solid fa-calendar-days me-1"></i> Ngày lịch
                                                    </span>
                                                <% } %>
                                                
                                                <% if (type.isNewEmployeeRestricted()) { %>
                                                    <span class="badge bg-light text-danger border border-danger px-2 py-1" style="font-size: 0.75rem;">
                                                        <i class="fa-solid fa-user-clock me-1"></i> Khóa thử việc
                                                    </span>
                                                <% } %>
                                                
                                                <span class="badge bg-light text-info border border-info px-2 py-1" style="font-size: 0.75rem;">
                                                    Đơn vị: <%= "Half-Day".equalsIgnoreCase(type.getMinUnit()) ? "0.5 ngày" : "1 ngày" %>
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary" style="font-size: 0.85rem; padding: 6px 12px; border-radius: 12px;">
                                                <%= type.getMaxDays() %> ngày
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/leave-types?action=edit&id=<%= type.getLeaveTypeID() %>" 
                                               class="btn-custom btn-outline-custom btn-sm-custom py-1 px-2" title="Chỉnh sửa">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/leave-types?action=delete&id=<%= type.getLeaveTypeID() %>" 
                                               class="btn-custom btn-danger-custom btn-sm-custom py-1 px-2 ms-1" 
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa loại nghỉ phép này không?')" title="Xóa">
                                                <i class="fa-solid fa-trash"></i> Xóa
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>
</body>
</html>
