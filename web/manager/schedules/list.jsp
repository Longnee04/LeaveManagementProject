<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.WorkSchedule"%>
<%@page import="models.User"%>
<%@page import="models.Department"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utils.SessionKeys"%>
<%
    User loggedUser = (User) request.getSession().getAttribute(SessionKeys.USER);
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<WorkSchedule> schedules = (List<WorkSchedule>) request.getAttribute("schedules");
    List<User> employees = (List<User>) request.getAttribute("employees");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    java.sql.Date monday = (java.sql.Date) request.getAttribute("monday");
    java.sql.Date sunday = (java.sql.Date) request.getAttribute("sunday");
    
    Integer weekOffset = (Integer) request.getAttribute("weekOffset");
    if (weekOffset == null) weekOffset = 0;
    
    Integer deptId = (Integer) request.getAttribute("deptId");
    if (deptId == null) deptId = 0;

    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat dayOnlyDf = new SimpleDateFormat("dd/MM");
    SimpleDateFormat dateIsoDf = new SimpleDateFormat("yyyy-MM-dd");
    
    // Calculate 7 days of the week starting from monday
    Calendar cal = Calendar.getInstance();
    cal.setTime(monday);
    java.sql.Date[] weekDays = new java.sql.Date[7];
    for (int i = 0; i < 7; i++) {
        weekDays[i] = new java.sql.Date(cal.getTimeInMillis());
        cal.add(Calendar.DATE, 1);
    }
    
    String[] dayNamesVi = {"Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy", "Chủ Nhật"};
    String[] dayNamesShortVi = {"T2", "T3", "T4", "T5", "T6", "T7", "CN"};
    String todayStr = new java.sql.Date(System.currentTimeMillis()).toString();
%>
<%!
    private List<WorkSchedule> getSchedulesForEmployeeAndDay(List<WorkSchedule> list, int userId, java.sql.Date date) {
        List<WorkSchedule> dayList = new ArrayList<>();
        if (list != null) {
            for (WorkSchedule ws : list) {
                if (ws.getUserID() == userId && ws.getWorkDate().toString().equals(date.toString())) {
                    dayList.add(ws);
                }
            }
        }
        // Order by shift: Morning -> Afternoon -> Evening
        List<WorkSchedule> orderedList = new ArrayList<>();
        String[] shiftOrder = {"Morning", "Afternoon", "Evening"};
        for (String shift : shiftOrder) {
            for (WorkSchedule ws : dayList) {
                if (shift.equalsIgnoreCase(ws.getShift())) {
                    orderedList.add(ws);
                }
            }
        }
        return orderedList;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Phân Lịch Trực Quan - HRM System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Font Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Global Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* Matrix Schedule Board Styles */
        .matrix-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--box-shadow);
            padding: 24px;
            margin-bottom: 30px;
            border: 1px solid var(--border-color);
        }
        
        .matrix-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .matrix-table th {
            background-color: #f8fafc;
            color: var(--text-secondary);
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 12px 10px;
            text-align: center;
            border-bottom: 2px solid var(--border-color);
            border-right: 1px solid var(--border-color);
        }
        
        .matrix-table th:first-child {
            text-align: left;
            padding-left: 20px;
            min-width: 220px;
            position: sticky;
            left: 0;
            background-color: #f8fafc;
            z-index: 2;
        }
        
        .matrix-table td {
            padding: 12px 8px;
            border-bottom: 1px solid var(--border-color);
            border-right: 1px solid var(--border-color);
            vertical-align: middle;
            text-align: center;
            height: 80px;
            min-width: 120px;
            background-color: #ffffff;
        }
        
        .matrix-table td:first-child {
            text-align: left;
            padding-left: 20px;
            position: sticky;
            left: 0;
            background-color: #ffffff;
            z-index: 2;
            box-shadow: 4px 0 8px -4px rgba(0,0,0,0.05);
            font-weight: 600;
        }
        
        .matrix-table tr:hover td {
            background-color: #fafbfc;
        }
        
        .matrix-table tr:hover td:first-child {
            background-color: #fafbfc;
        }
        
        .matrix-day-header.today {
            background-color: #eff6ff !important;
            color: var(--primary) !important;
            border-bottom: 2px solid var(--primary) !important;
        }
        
        .matrix-cell-today {
            background-color: #f8fafc-subtle;
            position: relative;
        }
        
        .matrix-cell-today::after {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            border: 1px dashed var(--primary);
            pointer-events: none;
            opacity: 0.4;
        }
        
        /* Shift Badges in cells */
        .matrix-shift-badge {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.775rem;
            font-weight: 600;
            margin-bottom: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: left;
            border: 1px solid transparent;
        }
        
        .matrix-shift-badge:last-child {
            margin-bottom: 0;
        }
        
        .matrix-shift-badge:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        
        .matrix-shift-badge.pending {
            background-color: #fffbeb;
            color: #b45309;
            border-color: #fef3c7;
        }
        
        .matrix-shift-badge.approved {
            background-color: #ecfdf5;
            color: #047857;
            border-color: #d1fae5;
        }
        
        .matrix-shift-badge.rejected {
            background-color: #fef2f2;
            color: #b91c1c;
            border-color: #fee2e2;
        }
        
        .matrix-shift-icon {
            font-size: 0.85rem;
        }
        
        .empty-matrix-cell {
            color: #cbd5e1;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        /* Navigation Controls */
        .control-nav-bar {
            background-color: var(--card-bg);
            border-radius: 12px;
            padding: 20px 24px;
            box-shadow: var(--box-shadow);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
            border: 1px solid var(--border-color);
        }
        
        .legend-bar-matrix {
            background-color: var(--card-bg);
            border-radius: 8px;
            padding: 12px 20px;
            display: flex;
            justify-content: center;
            gap: 24px;
            box-shadow: var(--box-shadow);
            margin-bottom: 24px;
            flex-wrap: wrap;
            border: 1px solid var(--border-color);
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.825rem;
            font-weight: 600;
            color: var(--text-secondary);
        }
        
        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 3px;
        }
        
        .legend-color.pending { background-color: var(--warning); }
        .legend-color.approved { background-color: var(--success); }
        .legend-color.rejected { background-color: var(--danger); }
        
        /* Modal Custom Style */
        .detail-item {
            margin-bottom: 12px;
            display: flex;
            flex-direction: column;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 10px;
        }
        .detail-label {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--text-secondary);
            margin-bottom: 3px;
        }
        .detail-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/sidebar.jsp"/>
    
    <div class="main-content">
        <jsp:include page="/WEB-INF/includes/header.jsp"/>
        
        <div class="content-wrapper">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1 class="page-title">Bảng phân lịch trực quan toàn bộ bộ phận</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Lịch làm việc</li>
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

            <!-- Control & Filter Bar -->
            <div class="control-nav-bar">
                <!-- Left: Navigation of week -->
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/manager/schedules?weekOffset=<%= weekOffset - 1 %>&deptId=<%= deptId %>" class="btn-custom btn-secondary-custom py-2 px-3" title="Tuần trước">
                        <i class="fa-solid fa-chevron-left"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/schedules?weekOffset=0&deptId=<%= deptId %>" class="btn-custom btn-outline-custom py-2 px-3">
                        Tuần này
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/schedules?weekOffset=<%= weekOffset + 1 %>&deptId=<%= deptId %>" class="btn-custom btn-secondary-custom py-2 px-3" title="Tuần sau">
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div>
                
                <!-- Center: Calendar Info -->
                <div class="text-center">
                    <span class="fs-5 fw-bold text-primary">
                        <i class="fa-solid fa-calendar-days text-primary me-2"></i>
                        Tuần: <%= df.format(monday) %> &mdash; <%= df.format(sunday) %>
                    </span>
                </div>
                
                <!-- Right: Department Filter (Admin-only) -->
                <div>
                    <% if ("Admin".equals(loggedUser.getRoleName())) { %>
                        <form method="get" action="${pageContext.request.contextPath}/manager/schedules" class="d-flex align-items-center gap-2 m-0">
                            <input type="hidden" name="weekOffset" value="<%= weekOffset %>">
                            <span class="text-secondary fw-semibold text-nowrap" style="font-size: 0.85rem;"><i class="fa-solid fa-filter"></i> Lọc phòng ban:</span>
                            <select name="deptId" class="form-select form-control py-1 px-3 border-primary-subtle" onchange="this.form.submit()" style="min-width: 200px; border-radius: 8px;">
                                <option value="0" <%= deptId == 0 ? "selected" : "" %>>Tất cả bộ phận</option>
                                <% for (Department dept : departments) { %>
                                    <option value="<%= dept.getDepartmentID() %>" <%= deptId == dept.getDepartmentID() ? "selected" : "" %>><%= dept.getDepartmentName() %></option>
                                <% } %>
                            </select>
                        </form>
                    <% } else { %>
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 fs-6 rounded-pill">
                            <i class="fa-solid fa-building me-1"></i> Bộ phận: <%= loggedUser.getDepartmentName() %>
                        </span>
                    <% } %>
                </div>
            </div>

            <!-- Legend & Action Bar -->
            <div class="legend-bar-matrix d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div class="d-flex gap-4 flex-wrap">
                    <div class="legend-item"><div class="legend-color approved"></div> Đã phê duyệt (Approved)</div>
                    <div class="legend-item"><div class="legend-color pending"></div> Đang chờ duyệt (Pending)</div>
                    <div class="legend-item"><div class="legend-color rejected"></div> Đã từ chối (Rejected)</div>
                </div>
                <div>
                    <form method="post" action="${pageContext.request.contextPath}/manager/schedules" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn duyệt tất cả các ca đang chờ (Pending) trong tuần này không?')">
                        <input type="hidden" name="action" value="approveAll">
                        <input type="hidden" name="weekOffset" value="<%= weekOffset %>">
                        <input type="hidden" name="deptId" value="<%= deptId %>">
                        <button type="submit" class="btn-custom btn-success-custom py-2 px-3 fw-bold" style="font-size: 0.85rem; border-radius: 8px; box-shadow: 0 4px 10px rgba(16, 185, 129, 0.2);">
                            <i class="fa-solid fa-check-double me-1"></i> Duyệt tất cả ca đang chờ
                        </button>
                    </form>
                </div>
            </div>

            <!-- Matrix Scheduling Board Grid -->
            <div class="matrix-card">
                <div class="table-responsive">
                    <table class="matrix-table">
                        <thead>
                            <tr>
                                <th>Nhân viên</th>
                                <% 
                                    for (int i = 0; i < 7; i++) { 
                                        java.sql.Date day = weekDays[i];
                                        boolean isToday = day.toString().equals(todayStr);
                                %>
                                    <th class="matrix-day-header <%= isToday ? "today" : "" %>">
                                        <%= dayNamesShortVi[i] %><br>
                                        <small class="fw-normal" style="font-size: 0.725rem;"><%= dayOnlyDf.format(day) %></small>
                                    </th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (employees == null || employees.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-users-slash d-block mb-2 fs-2 text-black-50"></i>
                                        Không tìm thấy nhân viên nào phù hợp với bộ phận được chọn.
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (User emp : employees) { %>
                                    <tr>
                                        <td>
                                            <div class="fw-bold" style="font-size: 0.9rem; color: var(--text-primary);"><%= emp.getFullName() %></div>
                                            <div class="d-flex align-items-center gap-1 mt-1">
                                                <span class="role-badge employee text-nowrap" style="font-size: 0.65rem; padding: 1px 6px;"><%= emp.getRoleName() %></span>
                                                <span class="text-muted" style="font-size: 0.7rem;">#<%= emp.getUserID() %></span>
                                            </div>
                                        </td>
                                        <% 
                                            for (int i = 0; i < 7; i++) { 
                                                java.sql.Date day = weekDays[i];
                                                List<WorkSchedule> daySchedules = getSchedulesForEmployeeAndDay(schedules, emp.getUserID(), day);
                                                boolean isToday = day.toString().equals(todayStr);
                                        %>
                                            <td class="<%= isToday ? "matrix-cell-today" : "" %>">
                                                <% if (daySchedules.isEmpty()) { %>
                                                    <span class="empty-matrix-cell">&mdash;</span>
                                                <% } else { %>
                                                    <% 
                                                        for (WorkSchedule ws : daySchedules) {
                                                            String status = ws.getStatus();
                                                            String shift = ws.getShift();
                                                            String statusClass = "pending";
                                                            String shiftIcon = "fa-sun";
                                                            String shiftLabel = "Sáng";
                                                            
                                                            if ("Approved".equalsIgnoreCase(status)) statusClass = "approved";
                                                            else if ("Rejected".equalsIgnoreCase(status)) statusClass = "rejected";
                                                            
                                                            if ("Afternoon".equalsIgnoreCase(shift)) {
                                                                shiftIcon = "fa-cloud-sun";
                                                                shiftLabel = "Chiều";
                                                            } else if ("Evening".equalsIgnoreCase(shift)) {
                                                                shiftIcon = "fa-moon";
                                                                shiftLabel = "Tối";
                                                            }
                                                            
                                                            // Escaped note details to prevent JS errors
                                                            String escapedNote = ws.getNote() != null ? ws.getNote().replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ").replace("\r", " ") : "";
                                                    %>
                                                        <div class="matrix-shift-badge <%= statusClass %>" 
                                                             onclick="openReviewModal('<%= ws.getScheduleID() %>', '<%= emp.getFullName() %>', '<%= df.format(day) %>', '<%= shiftLabel %>', '<%= escapedNote %>', '<%= status %>')"
                                                             title="Click để duyệt nhanh">
                                                            <span><i class="fa-solid <%= shiftIcon %> matrix-shift-icon me-1"></i><%= shiftLabel %></span>
                                                            <% if (ws.getNote() != null && !ws.getNote().isEmpty()) { %>
                                                                <i class="fa-solid fa-comment-dots text-black-50" style="font-size: 0.75rem;"></i>
                                                            <% } %>
                                                        </div>
                                                    <% } %>
                                                <% } %>
                                            </td>
                                        <% } %>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>

    <!-- QUICK REVIEW MODAL -->
    <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reviewModalLabel" style="font-weight: 700;">
                        <i class="fa-solid fa-calendar-check text-primary me-2"></i>Chi tiết & Duyệt Ca Làm
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Request information -->
                    <div class="detail-item">
                        <span class="detail-label">Nhân viên</span>
                        <span class="detail-value text-primary" id="detailEmployee"></span>
                    </div>
                    
                    <div class="row">
                        <div class="col-6">
                            <div class="detail-item">
                                <span class="detail-label">Ngày làm việc</span>
                                <span class="detail-value" id="detailDate"></span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="detail-item">
                                <span class="detail-label">Ca làm đăng ký</span>
                                <span class="detail-value text-success" id="detailShift"></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Trạng thái hiện tại</span>
                        <div>
                            <span class="status-badge" id="detailStatusBadge"></span>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Ghi chú của nhân viên</span>
                        <span class="detail-value fw-normal text-secondary italic" id="detailEmployeeNote" style="font-style: italic;"></span>
                    </div>

                    <!-- Action form (Approve & Reject) -->
                    <div class="mt-4 p-3 bg-light border rounded-3">
                        <h6 class="mb-3 fw-bold" style="font-size: 0.9rem; color: var(--text-primary);">
                            <i class="fa-solid fa-sliders text-primary me-2"></i> Quyết định phê duyệt:
                        </h6>
                        
                        <div class="form-group-custom">
                            <label for="rejectNote" class="form-label-custom">Ghi chú của Quản lý <small class="text-muted fw-normal">(Bắt buộc khi Từ chối)</small></label>
                            <textarea id="rejectNote" name="rejectNote" class="form-control-custom form-control" style="height: 80px; resize: vertical;" placeholder="Nhập lý do từ chối hoặc phản hồi cho nhân viên..."></textarea>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <!-- Separate action forms that trigger post -->
                            <form method="post" id="approveForm" action="${pageContext.request.contextPath}/manager/schedules" class="m-0">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="id" id="approveScheduleId">
                                <input type="hidden" name="weekOffset" value="<%= weekOffset %>">
                                <input type="hidden" name="deptId" value="<%= deptId %>">
                                <button type="submit" class="btn-custom btn-success-custom py-2 px-3">
                                    <i class="fa-solid fa-check"></i> Phê duyệt (Approve)
                                </button>
                            </form>
                            
                            <form method="post" id="rejectForm" action="${pageContext.request.contextPath}/manager/schedules" class="m-0" onsubmit="return validateRejection()">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="id" id="rejectScheduleId">
                                <input type="hidden" name="weekOffset" value="<%= weekOffset %>">
                                <input type="hidden" name="deptId" value="<%= deptId %>">
                                <input type="hidden" name="rejectNote" id="rejectNoteHidden">
                                <button type="submit" class="btn-custom btn-danger-custom py-2 px-3">
                                    <i class="fa-solid fa-xmark"></i> Từ chối (Reject)
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-custom btn-secondary-custom" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle and Modal Script -->
    <script>
        var reviewModal;
        document.addEventListener("DOMContentLoaded", function() {
            reviewModal = new bootstrap.Modal(document.getElementById('reviewModal'));
        });

        function openReviewModal(id, employee, date, shift, note, status) {
            // Set IDs to submit forms
            document.getElementById("approveScheduleId").value = id;
            document.getElementById("rejectScheduleId").value = id;
            
            // Set details
            document.getElementById("detailEmployee").innerText = employee;
            document.getElementById("detailDate").innerText = date;
            document.getElementById("detailShift").innerText = "Ca " + shift;
            document.getElementById("detailEmployeeNote").innerHTML = note ? '"' + note + '"' : '<span class="text-muted italic">(Không có ghi chú)</span>';
            
            // Rejection note field empty
            document.getElementById("rejectNote").value = "";
            
            // Status badge mapping
            var statusBadge = document.getElementById("detailStatusBadge");
            statusBadge.className = "status-badge"; // reset classes
            statusBadge.innerText = status;
            
            if (status.toLowerCase() === 'pending') {
                statusBadge.classList.add('pending');
            } else if (status.toLowerCase() === 'approved') {
                statusBadge.classList.add('approved');
            } else if (status.toLowerCase() === 'rejected') {
                statusBadge.classList.add('rejected');
            }
            
            // Pre-fill manager's response if it is already rejected
            if (status.toLowerCase() === 'rejected' && note) {
                // If rejected, the rejectReason is stored in Note!
                document.getElementById("rejectNote").value = note;
            }
            
            reviewModal.show();
        }
        
        function validateRejection() {
            var rejectNoteVal = document.getElementById("rejectNote").value.trim();
            if (!rejectNoteVal) {
                alert("Vui lòng nhập lý do từ chối ca làm việc!");
                document.getElementById("rejectNote").focus();
                return false;
            }
            
            // Sync visible note value into hidden input for submit
            document.getElementById("rejectNoteHidden").value = rejectNoteVal;
            return true;
        }
    </script>
</body>
</html>
