<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.LeaveRequest"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leaveRequest");
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat dateFmt = new SimpleDateFormat("dd/MM/yyyy");
    if (lr == null) { 
        response.sendRedirect(request.getContextPath() + "/employee/leave-requests"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn nghỉ phép #<%= lr.getRequestID() %> - HRM System</title>
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
                    <h1 class="page-title">Chi tiết đơn nghỉ phép #<%= lr.getRequestID() %></h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/employee/leave-requests"> / Đơn nghỉ phép</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Chi tiết</li>
                    </ul>
                </div>
                <a href="${pageContext.request.contextPath}/employee/leave-requests" class="btn-custom btn-secondary-custom">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <div class="row justify-content-center">
                <div class="col-12 col-lg-8">
                    <!-- Detailed Info Card -->
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary); border-bottom: 2px solid var(--border-color); padding-bottom: 10px;">
                            <i class="fa-solid fa-receipt text-primary me-2"></i> Phiếu thông tin đơn nghỉ phép
                        </h4>
                        
                        <div class="row g-4">
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Trạng thái đơn</label>
                                <%
                                    String stClass = "draft";
                                    String statusVal = lr.getStatus();
                                    if ("Pending".equals(statusVal)) stClass = "pending";
                                    else if ("Approved".equals(statusVal)) stClass = "approved";
                                    else if ("Rejected".equals(statusVal)) stClass = "rejected";
                                %>
                                <span class="status-badge <%= stClass %>" style="font-size: 0.85rem;"><%= statusVal %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Loại nghỉ phép</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= lr.getLeaveTypeName() %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Ngày bắt đầu</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><i class="fa-regular fa-calendar text-primary me-1"></i><%= dateFmt.format(lr.getStartDate()) %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Ngày kết thúc</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><i class="fa-regular fa-calendar text-danger me-1"></i><%= dateFmt.format(lr.getEndDate()) %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Tổng số ngày nghỉ</label>
                                <span class="badge bg-primary" style="font-size: 0.85rem; padding: 6px 12px; border-radius: 12px; font-weight: 600;">
                                    <%= lr.getTotalDays() %> ngày
                                </span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Thời điểm gửi đơn</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;">
                                    <%= lr.getCreatedAt() != null ? df.format(lr.getCreatedAt()) : "-" %>
                                </span>
                            </div>

                            <div class="col-12">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Lý do xin nghỉ</label>
                                <div class="p-3 bg-light" style="border-radius: 8px; font-size: 0.95rem; border: 1px solid var(--border-color);">
                                    <%= lr.getReason() != null && !lr.getReason().isBlank() ? lr.getReason() : "<span class='text-muted'>(Không có lý do chi tiết)</span>" %>
                                </div>
                            </div>

                            <% if (lr.getManagerComment() != null && !lr.getManagerComment().isBlank()) { %>
                                <div class="col-12">
                                    <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Ý kiến phản hồi của Quản lý</label>
                                    <div class="p-3 alert-warning-custom shadow-none" style="border-radius: 8px; font-size: 0.95rem;">
                                        <i class="fa-solid fa-comment-dots me-2 text-warning"></i><strong>Manager phản hồi:</strong>
                                        <div class="mt-2"><%= lr.getManagerComment() %></div>
                                    </div>
                                </div>
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
