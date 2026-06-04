<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.LeaveRequest"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    List<LeaveRequest> requests = (List<LeaveRequest>) request.getAttribute("requests");
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tất cả đơn nghỉ phép - HRM System</title>
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
                    <h1 class="page-title">Tất cả đơn nghỉ phép toàn công ty</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Tất cả đơn nghỉ</li>
                    </ul>
                </div>
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
                    <% if (requests == null || requests.isEmpty()) { %>
                        <div class="empty-state-custom">
                            <i class="fa-solid fa-file-invoice"></i>
                            <p>Không có đơn nghỉ phép nào trong hệ thống.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Nhân viên</th>
                                    <th>Phòng ban</th>
                                    <th>Loại phép</th>
                                    <th>Thời gian nghỉ</th>
                                    <th>Số ngày</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày gửi</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (LeaveRequest r : requests) { %>
                                    <tr>
                                        <td>#<%= r.getRequestID() %></td>
                                        <td>
                                            <div style="font-weight: 600;"><%= r.getEmployeeName() %></div>
                                            <div style="font-size: 0.75rem; color: var(--text-secondary);"><%= r.getEmployeeEmail() %></div>
                                        </td>
                                        <td><%= r.getDepartmentName() != null ? r.getDepartmentName() : "<span class='text-muted'>Chưa phân bổ</span>" %></td>
                                        <td style="font-weight: 600;"><%= r.getLeaveTypeName() %></td>
                                        <td><%= df.format(r.getStartDate()) %> - <%= df.format(r.getEndDate()) %></td>
                                        <td>
                                            <span class="badge bg-light text-dark border" style="font-size: 0.85rem; padding: 5px 12px; border-radius: 12px;">
                                                <%= r.getDuration() %> ngày
                                            </span>
                                        </td>
                                        <td>
                                            <%
                                                String stClass = "draft";
                                                String statusVal = r.getStatus();
                                                if ("Pending".equals(statusVal)) stClass = "pending";
                                                else if ("Approved".equals(statusVal)) stClass = "approved";
                                                else if ("Rejected".equals(statusVal)) stClass = "rejected";
                                            %>
                                            <span class="status-badge <%= stClass %>"><%= statusVal %></span>
                                        </td>
                                        <td style="font-size: 0.825rem; color: var(--text-secondary);">
                                            <%= r.getCreatedAt() != null ? df.format(r.getCreatedAt()) : "-" %>
                                        </td>
                                        <td class="text-end">
                                            <a class="btn-custom btn-secondary-custom btn-sm-custom py-1 px-2" href="${pageContext.request.contextPath}/admin/leave-requests/view?id=<%= r.getRequestID() %>">
                                                <i class="fa-solid fa-eye"></i> Chi tiết
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
