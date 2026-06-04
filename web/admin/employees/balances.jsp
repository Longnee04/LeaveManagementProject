<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%@page import="models.EmployeeLeaveBalance"%>
<%@page import="java.util.List"%>
<%
    User emp = (User) request.getAttribute("employee");
    List<EmployeeLeaveBalance> balances = (List<EmployeeLeaveBalance>) request.getAttribute("balances");
    String employeeName = emp != null ? emp.getFullName() : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Số dư nghỉ phép - <%= employeeName %> - HRM System</title>
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
                    <h1 class="page-title">Quản lý Số dư Nghỉ phép</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/admin/employees"> / Nhân viên</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Số dư nghỉ phép: <%= employeeName %></li>
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

            <div class="row justify-content-center">
                <div class="col-12 col-lg-10">
                    <!-- Employee Details Card -->
                    <div class="form-card mb-4" style="padding: 24px;">
                        <div class="d-flex align-items-center gap-3">
                            <div class="user-avatar text-white bg-primary fs-4" style="width: 50px; height: 50px;">
                                <%= employeeName.length() > 0 ? employeeName.substring(0,1).toUpperCase() : "U" %>
                            </div>
                            <div>
                                <h4 class="m-0 fw-bold" style="color: var(--text-primary);"><%= employeeName %></h4>
                                <p class="m-0 text-muted small">
                                    <i class="fa-solid fa-envelope me-1"></i><%= emp != null ? emp.getEmail() : "" %> &nbsp;|&nbsp;
                                    <i class="fa-solid fa-building me-1"></i><%= (emp != null && emp.getDepartmentName() != null) ? emp.getDepartmentName() : "Chưa có phòng ban" %>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Quota Adjustment Card -->
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary);">
                            <i class="fa-solid fa-scale-balanced text-primary me-2"></i> Điều chỉnh hạn mức nghỉ phép
                        </h4>
                        
                        <div class="d-none d-md-flex row fw-bold text-muted border-bottom pb-2 mb-3">
                            <div class="col-md-3">Loại nghỉ phép</div>
                            <div class="col-md-3">Hạn mức (Ngày)</div>
                            <div class="col-md-3">Đã dùng (Ngày)</div>
                            <div class="col-md-3 text-end">Thao tác</div>
                        </div>

                        <% if (balances == null || balances.isEmpty()) { %>
                            <div class="empty-state-custom py-4">
                                <i class="fa-solid fa-scale-unbalanced-flip"></i>
                                <p>Không tìm thấy thông tin số dư nghỉ phép nào cho nhân viên này.</p>
                            </div>
                        <% } else { %>
                            <% for (EmployeeLeaveBalance b : balances) { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/employees?action=adjustBalance" class="row align-items-center g-3 m-0 py-3 border-bottom">
                                    <input type="hidden" name="userId" value="<%= emp.getUserID() %>">
                                    <input type="hidden" name="leaveTypeId" value="<%= b.getLeaveTypeID() %>">
                                    
                                    <div class="col-12 col-md-3">
                                        <span class="fw-semibold text-primary"><%= b.getLeaveTypeName() %></span>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="input-group">
                                            <input type="number" step="0.5" name="annualQuota" class="form-control form-control-sm" value="<%= b.getAnnualQuota() %>" required min="0">
                                            <span class="input-group-text bg-light text-muted small">ngày</span>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="input-group">
                                            <input type="number" step="0.5" name="usedDays" class="form-control form-control-sm" value="<%= b.getUsedDays() %>" required min="0">
                                            <span class="input-group-text bg-light text-muted small">ngày</span>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-3 text-md-end d-flex align-items-center justify-content-between justify-content-md-end gap-2">
                                        <span class="badge bg-light text-dark border py-2 px-2 small">Còn lại: <%= b.getRemainingDays() %> ngày</span>
                                        <button type="submit" class="btn-custom btn-primary-custom btn-sm-custom py-1 px-3">
                                            <i class="fa-solid fa-floppy-disk"></i> Lưu
                                        </button>
                                    </div>
                                </form>
                            <% } %>
                        <% } %>
                        
                        <div class="d-flex justify-content-between align-items-center mt-4 pt-3">
                            <span class="text-muted small">* Lưu ý: Số ngày còn lại tự động tính bằng: Hạn mức - Đã dùng.</span>
                            <a href="${pageContext.request.contextPath}/admin/employees" class="btn-custom btn-secondary-custom btn-sm-custom">
                                Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>
</body>
</html>
