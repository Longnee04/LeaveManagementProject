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
            <div class="welcome-banner mb-4">
                <h4 class="mb-2 fw-bold">Chào mừng trở lại, <%= loggedUser.getFullName() %>!</h4>
                <p class="m-0 text-white-50 small">
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
                                <p id="stat-totalEmployees" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-users"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card success">
                            <div class="stat-card-info">
                                <h3>Tổng Đơn nghỉ</h3>
                                <p id="stat-totalLeaveRequests" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-file-invoice"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card warning">
                            <div class="stat-card-info">
                                <h3>Đơn Chờ duyệt</h3>
                                <p id="stat-pendingLeaveCount" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card danger">
                            <div class="stat-card-info">
                                <h3>Đang Nghỉ hôm nay</h3>
                                <p id="stat-todayLeaveCount" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
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
                                <p id="stat-pendingLeaveCount" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-file-circle-question"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card info">
                            <div class="stat-card-info">
                                <h3>Lịch làm chờ duyệt</h3>
                                <p id="stat-pendingScheduleCount" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-calendar-day"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card success">
                            <div class="stat-card-info">
                                <h3>Nhân sự hoạt động</h3>
                                <p id="stat-totalEmployees" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-user-check"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card danger">
                            <div class="stat-card-info">
                                <h3>Đang nghỉ hôm nay</h3>
                                <p id="stat-todayLeaveCount" class="m-0"><span class="spinner-border spinner-border-sm text-secondary" role="status"></span></p>
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
                                <p class="fs-6 fw-bold mt-1 text-primary-custom"><%= loggedUser.getDepartmentName() != null ? loggedUser.getDepartmentName() : "N/A" %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-sitemap"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card success">
                            <div class="stat-card-info">
                                <h3>Chức vụ vai trò</h3>
                                <p class="fs-6 fw-bold mt-1 text-primary-custom"><%= loggedUser.getRoleName() %></p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-id-card"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card info">
                            <div class="stat-card-info">
                                <h3>Chấm công hôm nay</h3>
                                <p class="fs-6 fw-bold mt-1 text-primary-custom">Hồ sơ trực tuyến</p>
                            </div>
                            <div class="stat-card-icon"><i class="fa-solid fa-fingerprint"></i></div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="stat-card danger">
                            <div class="stat-card-info">
                                <h3>Hỗ trợ kỹ thuật</h3>
                                <p class="fs-6 fw-bold mt-1 text-primary-custom">admin@company.com</p>
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
                            <h4 class="m-0 fs-5 fw-bold text-primary-custom">Đơn nghỉ phép gần đây</h4>
                            <% if ("Employee".equals(role)) { %>
                                <a href="${pageContext.request.contextPath}/employee/leave-requests" class="btn-custom btn-outline-custom btn-sm-custom">Xem tất cả</a>
                            <% } else if ("Manager".equals(role)) { %>
                                <a href="${pageContext.request.contextPath}/manager/leave-requests" class="btn-custom btn-outline-custom btn-sm-custom">Duyệt đơn</a>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/admin/leave-requests" class="btn-custom btn-outline-custom btn-sm-custom">Xem tất cả</a>
                            <% } %>
                        </div>
                        
                        <div class="table-responsive">
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
                                <tbody id="recent-leaves-table-body">
                                    <tr id="table-loading-row">
                                        <td colspan="5" class="text-center py-4">
                                            <div class="spinner-border text-primary spinner-border-sm" role="status"></div>
                                            <span class="text-muted small ms-2">Đang tải dữ liệu đơn nghỉ...</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-xl-4">
                    <!-- Quick Links Card -->
                    <div class="form-card mb-4">
                        <h4 class="mb-3 fs-5 fw-bold text-primary-custom">Chức năng nhanh</h4>
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
    
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            fetch("${pageContext.request.contextPath}/api/dashboard/summary")
                .then(response => {
                    if (!response.ok) throw new Error("Network response was not ok");
                    return response.json();
                })
                .then(data => {
                    // Populate stats
                    updateStat("stat-totalEmployees", data.totalEmployees);
                    updateStat("stat-totalLeaveRequests", data.totalLeaveRequests);
                    updateStat("stat-pendingLeaveCount", data.pendingLeaveCount);
                    updateStat("stat-todayLeaveCount", data.todayLeaveCount);
                    updateStat("stat-pendingScheduleCount", data.pendingScheduleCount);
                    
                    // Populate table
                    const tbody = document.getElementById("recent-leaves-table-body");
                    if (!tbody) return;
                    
                    tbody.innerHTML = "";
                    if (!data.recentLeaves || data.recentLeaves.length === 0) {
                        tbody.innerHTML = `
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state-custom">
                                        <i class="fa-solid fa-folder-open"></i>
                                        <p>Không có đơn nghỉ phép nào được ghi nhận gần đây.</p>
                                    </div>
                                </td>
                            </tr>
                        `;
                        return;
                    }
                    
                    data.recentLeaves.forEach(r => {
                        let stClass = "draft";
                        if (r.status === "Pending") stClass = "pending";
                        else if (r.status === "Approved") stClass = "approved";
                        else if (r.status === "Rejected") stClass = "rejected";
                        
                        // Format dates
                        const startStr = formatDate(r.startDate);
                        const endStr = formatDate(r.endDate);
                        const createdStr = formatDateTime(r.createdAt);
                        
                        const row = document.createElement("tr");
                        row.innerHTML = `
                            <td>
                                <div class="fw-semibold">\${r.employeeName}</div>
                                <div class="small text-secondary-custom">\${r.employeeEmail}</div>
                            </td>
                            <td>\${r.leaveTypeName}</td>
                            <td>
                                <div class="small">\${startStr} - \${endStr}</div>
                            </td>
                            <td>
                                <span class="status-badge \${stClass}">\${r.status}</span>
                            </td>
                            <td class="small text-secondary-custom">\${createdStr}</td>
                        `;
                        tbody.appendChild(row);
                    });
                })
                .catch(error => {
                    console.error("Error loading dashboard data:", error);
                    showErrorState();
                });
                
            function updateStat(id, value) {
                const el = document.getElementById(id);
                if (el) {
                    el.innerHTML = value !== undefined ? value : "0";
                }
            }
            
            function formatDate(dateStr) {
                if (!dateStr) return "-";
                const parts = dateStr.split("-");
                if (parts.length === 3) {
                    return `\${parts[2]}/\${parts[1]}/\${parts[0]}`;
                }
                return dateStr;
            }
            
            function formatDateTime(dateTimeStr) {
                if (!dateTimeStr) return "-";
                const tParts = dateTimeStr.split(" ");
                if (tParts.length >= 1) {
                    const dateStr = formatDate(tParts[0]);
                    if (tParts.length >= 2) {
                        const timeParts = tParts[1].split(":");
                        if (timeParts.length >= 2) {
                            return `\${dateStr} \${timeParts[0]}:\${timeParts[1]}`;
                        }
                    }
                    return dateStr;
                }
                return dateTimeStr;
            }
            
            function showErrorState() {
                const tbody = document.getElementById("recent-leaves-table-body");
                if (tbody) {
                    tbody.innerHTML = `
                        <tr>
                            <td colspan="5" class="text-center py-4 text-danger">
                                <i class="fa-solid fa-circle-exclamation fs-3 mb-2"></i>
                                <div>Không thể tải dữ liệu thống kê từ máy chủ.</div>
                            </td>
                        </tr>
                    `;
                }
                // Reset stats loaders to zero or error symbol
                ["stat-totalEmployees", "stat-totalLeaveRequests", "stat-pendingLeaveCount", "stat-todayLeaveCount", "stat-pendingScheduleCount"].forEach(id => {
                    const el = document.getElementById(id);
                    if (el) el.innerHTML = "<span class='text-danger'>!</span>";
                });
            }
        });
    </script>
</body>
</html>
