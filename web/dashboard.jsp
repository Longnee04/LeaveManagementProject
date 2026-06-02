<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%@page import="models.LeaveRequest"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = loggedUser.getRoleName();
    
    // Đọc các thông số thống kê từ request attributes
    int totalEmployees = request.getAttribute("totalEmployees") != null ? (int) request.getAttribute("totalEmployees") : 0;
    int totalLeaveRequests = request.getAttribute("totalLeaveRequests") != null ? (int) request.getAttribute("totalLeaveRequests") : 0;
    int pendingLeaveCount = request.getAttribute("pendingLeaveCount") != null ? (int) request.getAttribute("pendingLeaveCount") : 0;
    int todayLeaveCount = request.getAttribute("todayLeaveCount") != null ? (int) request.getAttribute("todayLeaveCount") : 0;
    int pendingScheduleCount = request.getAttribute("pendingScheduleCount") != null ? (int) request.getAttribute("pendingScheduleCount") : 0;
    List<LeaveRequest> recentLeaves = (List<LeaveRequest>) request.getAttribute("recentLeaves");
    
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat dateOnlyFmt = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - HRM System</title>
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
                    <h1 class="page-title">Hệ thống HRM Dashboard</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="#">HRM System</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Dashboard</li>
                    </ul>
                </div>
            </div>

            <!-- Welcome Banner -->
            <div class="form-card mb-4" style="background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white;">
                <h4 class="mb-2" style="font-weight: 700;">Chào mừng trở lại, <%= loggedUser.getFullName() %>!</h4>
                <p class="m-0 text-white-50" style="font-size: 0.9rem;">
                    Hôm nay là ngày <%= dateOnlyFmt.format(new java.util.Date()) %>. Chúc bạn một ngày làm việc hiệu quả và tràn đầy năng lượng!
                </p>
            </div>

            <!-- Statistics Cards -->
            <div class="row g-4 mb-4">
                <% if ("Admin".equals(role)) { %>
                    <!-- Admin Statistics -->
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card primary">
                            <div class="stat-card-info">
                                <h3>Tổng Nhân sự</h3>
                                <p><%= totalEmployees %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-users"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card success">
                            <div class="stat-card-info">
                                <h3>Tổng Đơn nghỉ</h3>
                                <p><%= totalLeaveRequests %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-file-invoice"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card warning">
                            <div class="stat-card-info">
                                <h3>Đơn Chờ duyệt</h3>
                                <p><%= pendingLeaveCount %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card danger">
                            <div class="stat-card-info">
                                <h3>Đang Nghỉ hôm nay</h3>
                                <p><%= todayLeaveCount %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-user-slash"></i></div>
                        </div>
                    </div>
                <% } else if ("Manager".equals(role)) { %>
                    <!-- Manager Statistics -->
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card warning">
                            <div class="stat-card-info">
                                <h3>Đơn nghỉ chờ duyệt</h3>
                                <p><%= pendingLeaveCount %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-file-circle-question"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card info">
                            <div class="stat-card-info">
                                <h3>Lịch làm chờ duyệt</h3>
                                <p><%= pendingScheduleCount %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-calendar-day"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card success">
                            <div class="stat-card-info">
                                <h3>Nhân sự hoạt động</h3>
                                <p><%= totalEmployees %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-user-check"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card danger">
                            <div class="stat-card-info">
                                <h3>Đang nghỉ hôm nay</h3>
                                <p><%= todayLeaveCount %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-user-xmark"></i></div>
                        </div>
                    </div>
                <% } else { %>
                    <!-- Employee Statistics -->
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card primary">
                            <div class="stat-card-info">
                                <h3>Bộ phận của tôi</h3>
                                <p style="font-size: 1.15rem; font-weight: 700; margin-top: 5px;"><%= loggedUser.getDepartmentName() != null ? loggedUser.getDepartmentName() : "N/A" %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-sitemap"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card success">
                            <div class="stat-card-info">
                                <h3>Chức vụ vai trò</h3>
                                <p style="font-size: 1.15rem; font-weight: 700; margin-top: 5px;"><%= loggedUser.getRoleName() %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-id-card"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card info">
                            <div class="stat-card-info">
                                <h3>Chấm công hôm nay</h3>
                                <p style="font-size: 1.15rem; font-weight: 700; margin-top: 5px;">Hồ sơ trực tuyến</p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-fingerprint"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card danger">
                            <div class="stat-card-info">
                                <h3>Hỗ trợ kỹ thuật</h3>
                                <p style="font-size: 1.15rem; font-weight: 700; margin-top: 5px;">admin@company.com</p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-headset"></i></div>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Recent Activity Tables -->
            <div class="row">
                <div class="col-12 col-xl-8">
                    <div class="form-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="m-0" style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary);">Đơn nghỉ phép gần đây</h4>
                            <% if ("Employee".equals(role)) { %>
                                <a href="${pageContext.request.contextPath}/employee/leave-requests" class="btn-custom btn-outline-custom btn-sm-custom">Xem tất cả</a>
                            <% } else if ("Manager".equals(role)) { %>
                                <a href="${pageContext.request.contextPath}/manager/leave-requests" class="btn-custom btn-outline-custom btn-sm-custom">Duyệt đơn</a>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/admin/leave-requests" class="btn-custom btn-outline-custom btn-sm-custom">Xem tất cả</a>
                            <% } %>
                        </div>
                        
                        <div class="table-responsive">
                            <% if (recentLeaves == null || recentLeaves.isEmpty()) { %>
                                <div class="empty-state-custom">
                                    <i class="fa-solid fa-folder-open"></i>
                                    <p>Không có đơn nghỉ phép nào được ghi nhận gần đây.</p>
                                </div>
                            <% } else { %>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Nhân viên</th>
                                            <th>Loại nghỉ</th>
                                            <th>Thời gian</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày gửi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (LeaveRequest r : recentLeaves) { %>
                                            <tr>
                                                <td>
                                                    <div class="font-weight-bold" style="font-weight: 600;"><%= r.getEmployeeName() %></div>
                                                    <div style="font-size: 0.75rem; color: var(--text-secondary);"><%= r.getEmployeeEmail() %></div>
                                                </td>
                                                <td><%= r.getLeaveTypeName() %></td>
                                                <td>
                                                    <div style="font-size: 0.85rem;"><%= dateOnlyFmt.format(r.getStartDate()) %> - <%= dateOnlyFmt.format(r.getEndDate()) %></div>
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
                                                <td style="font-size: 0.8rem; color: var(--text-secondary);">
                                                    <%= r.getCreatedAt() != null ? df.format(r.getCreatedAt()) : "-" %>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-xl-4">
                    <!-- Quick Links Card -->
                    <div class="form-card mb-4">
                        <h4 class="mb-3" style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary);">Chức năng nhanh</h4>
                        <div class="d-grid gap-2">
                            <% if ("Admin".equals(role)) { %>
                                <a href="${pageContext.request.contextPath}/admin/employees?action=add" class="btn-custom btn-primary-custom w-100"><i class="fa-solid fa-user-plus"></i> Thêm Nhân viên</a>
                                <a href="${pageContext.request.contextPath}/admin/leave-types?action=add" class="btn-custom btn-outline-custom w-100"><i class="fa-solid fa-folder-plus"></i> Tạo loại nghỉ phép</a>
                            <% } else if ("Manager".equals(role)) { %>
                                <a href="${pageContext.request.contextPath}/manager/leave-requests" class="btn-custom btn-primary-custom w-100"><i class="fa-solid fa-file-circle-check"></i> Xem đơn nghỉ cần duyệt</a>
                                <a href="${pageContext.request.contextPath}/manager/schedules" class="btn-custom btn-outline-custom w-100"><i class="fa-solid fa-calendar-check"></i> Xem lịch làm cần duyệt</a>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/employee/leave-requests?action=create" class="btn-custom btn-primary-custom w-100"><i class="fa-solid fa-file-circle-plus"></i> Tạo đơn nghỉ phép</a>
                                <a href="${pageContext.request.contextPath}/employee/schedules?action=register" class="btn-custom btn-outline-custom w-100"><i class="fa-solid fa-calendar-plus"></i> Đăng ký lịch làm việc</a>
                            <% } %>
                            <a href="${pageContext.request.contextPath}/attendance" class="btn-custom btn-secondary-custom w-100"><i class="fa-solid fa-fingerprint"></i> Thực hiện chấm công</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>
</body>
</html>
