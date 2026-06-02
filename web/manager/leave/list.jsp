<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.LeaveRequest"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    List<LeaveRequest> pending = (List<LeaveRequest>) request.getAttribute("pendingRequests");
    List<LeaveRequest> reviewed = (List<LeaveRequest>) request.getAttribute("reviewedRequests");
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt Đơn nghỉ phép - HRM System</title>
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
                    <h1 class="page-title">Duyệt đơn xin nghỉ phép</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Duyệt đơn nghỉ</li>
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

            <!-- Navigation Tabs -->
            <ul class="nav nav-tabs mb-4" id="leaveTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending-content" type="button" role="tab" aria-controls="pending-content" aria-selected="true">
                        <i class="fa-solid fa-hourglass-half me-1 text-warning"></i> Đang chờ duyệt 
                        <span class="badge bg-warning text-dark ms-1"><%= pending != null ? pending.size() : 0 %></span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="reviewed-tab" data-bs-toggle="tab" data-bs-target="#reviewed-content" type="button" role="tab" aria-controls="reviewed-content" aria-selected="false">
                        <i class="fa-solid fa-clipboard-check me-1 text-success"></i> Lịch sử đã xử lý
                        <span class="badge bg-success ms-1"><%= reviewed != null ? reviewed.size() : 0 %></span>
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="leaveTabsContent">
                <!-- PENDING LEAVE TAB -->
                <div class="tab-pane fade show active" id="pending-content" role="tabpanel" aria-labelledby="pending-tab">
                    <div class="form-card">
                        <div class="table-responsive">
                            <% if (pending == null || pending.isEmpty()) { %>
                                <div class="empty-state-custom">
                                    <i class="fa-solid fa-circle-check text-success" style="font-size: 3rem;"></i>
                                    <p class="mt-3">Tuyệt vời! Không có đơn xin nghỉ phép nào đang chờ bạn duyệt.</p>
                                </div>
                            <% } else { %>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Nhân viên</th>
                                            <th>Phòng ban</th>
                                            <th>Loại nghỉ phép</th>
                                            <th>Từ ngày - Đến ngày</th>
                                            <th>Số ngày</th>
                                            <th>Lý do xin nghỉ</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (LeaveRequest r : pending) { %>
                                            <tr>
                                                <td>#<%= r.getRequestID() %></td>
                                                <td>
                                                    <div style="font-weight: 600;"><%= r.getEmployeeName() %></div>
                                                    <div style="font-size: 0.75rem; color: var(--text-secondary);"><%= r.getEmployeeEmail() %></div>
                                                </td>
                                                <td><%= r.getDepartmentName() != null ? r.getDepartmentName() : "-" %></td>
                                                <td style="font-weight: 600;"><%= r.getLeaveTypeName() %></td>
                                                <td><%= df.format(r.getStartDate()) %> - <%= df.format(r.getEndDate()) %></td>
                                                <td>
                                                    <span class="badge bg-light text-dark border" style="font-size: 0.85rem; padding: 5px 12px;">
                                                        <%= r.getTotalDays() %> ngày
                                                    </span>
                                                </td>
                                                <td style="max-width: 200px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;" title="<%= r.getReason() %>">
                                                    <%= r.getReason() != null ? r.getReason() : "-" %>
                                                </td>
                                                <td class="text-end">
                                                    <a class="btn-custom btn-primary-custom btn-sm-custom" 
                                                       href="${pageContext.request.contextPath}/manager/leave-requests/review?id=<%= r.getRequestID() %>">
                                                        <i class="fa-solid fa-file-signature"></i> Xem duyệt
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

                <!-- REVIEWED LEAVE HISTORY TAB -->
                <div class="tab-pane fade" id="reviewed-content" role="tabpanel" aria-labelledby="reviewed-tab">
                    <div class="form-card">
                        <div class="table-responsive">
                            <% if (reviewed == null || reviewed.isEmpty()) { %>
                                <div class="empty-state-custom">
                                    <i class="fa-solid fa-folder-open"></i>
                                    <p>Chưa có đơn nghỉ phép nào được duyệt hoặc từ chối trước đây.</p>
                                </div>
                            <% } else { %>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Nhân viên</th>
                                            <th>Loại nghỉ phép</th>
                                            <th>Thời gian nghỉ</th>
                                            <th>Số ngày</th>
                                            <th>Trạng thái</th>
                                            <th>Ý kiến Quản lý</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (LeaveRequest r : reviewed) { %>
                                            <tr>
                                                <td>#<%= r.getRequestID() %></td>
                                                <td>
                                                    <div style="font-weight: 600;"><%= r.getEmployeeName() %></div>
                                                </td>
                                                <td style="font-weight: 600;"><%= r.getLeaveTypeName() %></td>
                                                <td><%= df.format(r.getStartDate()) %> - <%= df.format(r.getEndDate()) %></td>
                                                <td>
                                                    <span class="badge bg-light text-dark border" style="font-size: 0.85rem; padding: 5px 12px;">
                                                        <%= r.getTotalDays() %> ngày
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
                                                <td>
                                                    <%= r.getManagerComment() != null && !r.getManagerComment().isEmpty() ? r.getManagerComment() : "<span class='text-muted'>Không có ý kiến</span>" %>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>
</body>
</html>
