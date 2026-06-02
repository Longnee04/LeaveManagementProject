<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.WorkSchedule"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    List<WorkSchedule> list = (List<WorkSchedule>) request.getAttribute("schedules");
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch làm việc của tôi - HRM System</title>
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
                    <h1 class="page-title">Lịch làm việc của tôi</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Lịch làm việc</li>
                    </ul>
                </div>
                <a href="${pageContext.request.contextPath}/employee/schedules?action=register" class="btn-custom btn-primary-custom">
                    <i class="fa-solid fa-calendar-plus"></i> Đăng ký lịch làm
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
                            <i class="fa-solid fa-calendar-days"></i>
                            <p>Bạn chưa đăng ký lịch làm việc nào.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Ngày làm việc</th>
                                    <th>Ca làm</th>
                                    <th>Trạng thái</th>
                                    <th>Ghi chú</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    int count = 1;
                                    for (WorkSchedule ws : list) { 
                                %>
                                    <tr>
                                        <td><%= count++ %></td>
                                        <td style="font-weight: 600;"><%= df.format(ws.getWorkDate()) %></td>
                                        <td>
                                            <%
                                                String shiftClass = "bg-primary";
                                                String shiftVal = ws.getShift();
                                                if ("Afternoon".equalsIgnoreCase(shiftVal)) shiftClass = "bg-success";
                                                else if ("Evening".equalsIgnoreCase(shiftVal)) shiftClass = "bg-dark";
                                            %>
                                            <span class="badge <%= shiftClass %>" style="padding: 5px 12px; border-radius: 12px; font-weight: 500;">
                                                <%= shiftVal %>
                                            </span>
                                        </td>
                                        <td>
                                            <%
                                                String stClass = "draft";
                                                String statusVal = ws.getStatus();
                                                if ("Pending".equals(statusVal)) stClass = "pending";
                                                else if ("Approved".equals(statusVal)) stClass = "approved";
                                                else if ("Rejected".equals(statusVal)) stClass = "rejected";
                                            %>
                                            <span class="status-badge <%= stClass %>"><%= statusVal %></span>
                                        </td>
                                        <td>
                                            <%= ws.getNote() != null && !ws.getNote().isEmpty() ? ws.getNote() : "<span class='text-muted'>Không có</span>" %>
                                        </td>
                                        <td class="text-end">
                                            <% if ("Pending".equals(ws.getStatus())) { %>
                                                <a href="${pageContext.request.contextPath}/employee/schedules?action=edit&id=<%= ws.getScheduleID() %>" 
                                                   class="btn-custom btn-outline-custom btn-sm-custom py-1 px-2" title="Chỉnh sửa">
                                                    <i class="fa-solid fa-pen-to-square"></i> Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/employee/schedules?action=delete&id=<%= ws.getScheduleID() %>" 
                                                   class="btn-custom btn-danger-custom btn-sm-custom py-1 px-2 ms-1" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa lịch đăng ký ca này không?')" title="Xóa">
                                                    <i class="fa-solid fa-trash"></i> Xóa
                                                </a>
                                            <% } else { %>
                                                <span class="text-muted" style="font-size: 0.85rem;"><i class="fa-solid fa-lock me-1"></i>Đã khóa</span>
                                            <% } %>
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
