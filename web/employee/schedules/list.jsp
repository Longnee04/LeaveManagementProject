<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.WorkSchedule"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%
    List<WorkSchedule> list = (List<WorkSchedule>) request.getAttribute("schedules");
    java.sql.Date monday = (java.sql.Date) request.getAttribute("monday");
    java.sql.Date sunday = (java.sql.Date) request.getAttribute("sunday");
    Integer weekOffset = (Integer) request.getAttribute("weekOffset");
    if (weekOffset == null) weekOffset = 0;

    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat dayOnlyDf = new SimpleDateFormat("dd/MM");
    
    // Calculate 7 days of the week starting from monday
    Calendar cal = Calendar.getInstance();
    cal.setTime(monday);
    java.sql.Date[] weekDays = new java.sql.Date[7];
    for (int i = 0; i < 7; i++) {
        weekDays[i] = new java.sql.Date(cal.getTimeInMillis());
        cal.add(Calendar.DATE, 1);
    }
    
    String[] dayNamesVi = {"Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy", "Chủ Nhật"};
    
    // Check which date is today to highlight
    String todayStr = new java.sql.Date(System.currentTimeMillis()).toString();
%>
<%!
    private List<WorkSchedule> getSchedulesForDay(List<WorkSchedule> list, java.sql.Date date) {
        List<WorkSchedule> dayList = new ArrayList<>();
        if (list != null) {
            for (WorkSchedule ws : list) {
                if (ws.getWorkDate().toString().equals(date.toString())) {
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
    <title>Lịch làm việc của tôi - HRM System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Font Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Global Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* Personal Calendar Styles */
        .calendar-nav-bar {
            background-color: var(--card-bg);
            border-radius: 12px;
            padding: 16px 24px;
            box-shadow: var(--box-shadow);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 30px;
        }
        
        .calendar-day-col {
            background-color: var(--card-bg);
            border-radius: 10px;
            border: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            min-height: 450px;
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .calendar-day-col.today {
            border-color: var(--primary);
            box-shadow: 0 0 0 1px var(--primary), var(--box-shadow);
        }
        
        .calendar-day-header {
            padding: 12px 10px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
            background-color: #f8fafc;
        }
        
        .calendar-day-col.today .calendar-day-header {
            background-color: #eff6ff;
            color: var(--primary);
        }
        
        .day-name {
            font-size: 0.85rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
        }
        
        .day-date {
            font-size: 1.1rem;
            font-weight: 700;
            margin-top: 2px;
            display: block;
        }
        
        .calendar-day-body {
            padding: 10px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 8px;
            background-color: #fafbfc;
        }
        
        /* Shift Cards */
        .shift-card {
            background-color: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 10px 12px;
            display: flex;
            flex-direction: column;
            position: relative;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            transition: all 0.2s ease;
        }
        
        .shift-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.06);
        }
        
        .shift-card.pending {
            border-left: 4px solid var(--warning);
        }
        
        .shift-card.approved {
            border-left: 4px solid var(--success);
        }
        
        .shift-card.rejected {
            border-left: 4px solid var(--danger);
        }
        
        .shift-title {
            font-size: 0.85rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--text-primary);
        }
        
        .shift-time {
            font-size: 0.725rem;
            color: var(--text-secondary);
            font-weight: 500;
            margin-top: 2px;
        }
        
        .shift-status-info {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px dashed var(--border-color);
        }
        
        .shift-badge-text {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            padding: 2px 6px;
            border-radius: 4px;
        }
        
        .shift-badge-text.pending { background-color: #fffbeb; color: #d97706; }
        .shift-badge-text.approved { background-color: #ecfdf5; color: #059669; }
        .shift-badge-text.rejected { background-color: #fef2f2; color: #dc2626; }
        
        .btn-shift-delete {
            background: none;
            border: none;
            color: var(--text-secondary);
            font-size: 0.8rem;
            cursor: pointer;
            padding: 2px 4px;
            border-radius: 4px;
            transition: all 0.2s;
        }
        
        .btn-shift-delete:hover {
            color: var(--danger);
            background-color: #fee2e2;
        }
        
        .shift-note-indicator {
            cursor: pointer;
            color: var(--text-secondary);
            font-size: 0.8rem;
        }
        
        .legend-bar {
            background-color: var(--card-bg);
            border-radius: 8px;
            padding: 12px 20px;
            display: flex;
            justify-content: center;
            gap: 24px;
            box-shadow: var(--box-shadow);
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
        }
        
        .legend-color {
            width: 14px;
            height: 14px;
            border-radius: 3px;
        }
        
        .legend-color.pending { background-color: var(--warning); }
        .legend-color.approved { background-color: var(--success); }
        .legend-color.rejected { background-color: var(--danger); }
        
        /* Mobile styles */
        @media (max-width: 991px) {
            .calendar-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            .calendar-day-col {
                min-height: auto;
            }
            .calendar-day-body {
                min-height: 80px;
            }
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
                    <h1 class="page-title">Lịch làm việc của tôi</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Lịch làm việc</li>
                    </ul>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/employee/schedules?action=register" class="btn-custom btn-primary-custom">
                        <i class="fa-solid fa-calendar-plus"></i> Đăng ký theo tuần
                    </a>
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

            <!-- Weekly Navigation Bar -->
            <div class="calendar-nav-bar">
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/employee/schedules?weekOffset=<%= weekOffset - 1 %>" class="btn-custom btn-secondary-custom py-2 px-3" title="Tuần trước">
                        <i class="fa-solid fa-chevron-left"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/employee/schedules?weekOffset=0" class="btn-custom btn-outline-custom py-2 px-3">
                        Tuần này
                    </a>
                    <a href="${pageContext.request.contextPath}/employee/schedules?weekOffset=<%= weekOffset + 1 %>" class="btn-custom btn-secondary-custom py-2 px-3" title="Tuần sau">
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div>
                
                <div class="text-center">
                    <span class="fs-5 fw-bold text-primary">
                        <i class="fa-solid fa-calendar text-primary me-2"></i>
                        Tuần: <%= df.format(monday) %> &mdash; <%= df.format(sunday) %>
                    </span>
                </div>
                
                <div style="min-width: 100px;" class="text-end">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 fs-6 rounded-pill">
                        <%= (weekOffset == 0) ? "Tuần hiện tại" : (weekOffset > 0 ? "Sau " + weekOffset + " tuần" : "Trước " + Math.abs(weekOffset) + " tuần") %>
                    </span>
                </div>
            </div>

            <!-- Legend Bar -->
            <div class="legend-bar">
                <div class="legend-item"><div class="legend-color approved"></div> Đã phê duyệt (Approved)</div>
                <div class="legend-item"><div class="legend-color pending"></div> Đang chờ duyệt (Pending)</div>
                <div class="legend-item"><div class="legend-color rejected"></div> Đã từ chối (Rejected)</div>
            </div>

            <!-- Calendar Weekly Grid -->
            <div class="calendar-grid">
                <% 
                    for (int i = 0; i < 7; i++) { 
                        java.sql.Date currentDay = weekDays[i];
                        String currentDayStr = currentDay.toString();
                        boolean isToday = currentDayStr.equals(todayStr);
                        List<WorkSchedule> daySchedules = getSchedulesForDay(list, currentDay);
                %>
                    <div class="calendar-day-col <%= isToday ? "today" : "" %>">
                        <div class="calendar-day-header">
                            <span class="day-name"><%= dayNamesVi[i] %></span>
                            <span class="day-date"><%= dayOnlyDf.format(currentDay) %></span>
                        </div>
                        <div class="calendar-day-body">
                            <% if (daySchedules.isEmpty()) { %>
                                <div class="text-center text-muted py-4" style="font-size: 0.75rem;">
                                    <i class="fa-regular fa-calendar-minus d-block mb-1 fs-5 text-black-50"></i>
                                    Trống
                                </div>
                            <% } else { %>
                                <% 
                                    for (WorkSchedule ws : daySchedules) { 
                                        String shiftName = ws.getShift();
                                        String status = ws.getStatus();
                                        
                                        String statusClass = "pending";
                                        if ("Approved".equalsIgnoreCase(status)) statusClass = "approved";
                                        else if ("Rejected".equalsIgnoreCase(status)) statusClass = "rejected";
                                        
                                        String shiftIcon = "fa-sun text-warning";
                                        String shiftLabel = "Ca Sáng";
                                        String shiftTime = "08:00 - 12:00";
                                        
                                        if ("Afternoon".equalsIgnoreCase(shiftName)) {
                                            shiftIcon = "fa-cloud-sun text-success";
                                            shiftLabel = "Ca Chiều";
                                            shiftTime = "13:00 - 17:00";
                                        } else if ("Evening".equalsIgnoreCase(shiftName)) {
                                            shiftIcon = "fa-moon text-dark";
                                            shiftLabel = "Ca Tối";
                                            shiftTime = "18:00 - 22:00";
                                        }
                                %>
                                    <div class="shift-card <%= statusClass %>">
                                        <div class="shift-title">
                                            <i class="fa-solid <%= shiftIcon %>"></i>
                                            <%= shiftLabel %>
                                        </div>
                                        <div class="shift-time"><%= shiftTime %></div>
                                        
                                        <div class="shift-status-info">
                                            <span class="shift-badge-text <%= statusClass %>"><%= status %></span>
                                            
                                            <div class="d-flex align-items-center gap-1">
                                                <!-- Note Tooltip/Display -->
                                                <% if (ws.getNote() != null && !ws.getNote().isEmpty()) { %>
                                                    <span class="shift-note-indicator" data-bs-toggle="tooltip" data-bs-placement="top" title="<%= ws.getNote() %>">
                                                        <i class="fa-solid fa-comment-dots text-primary" style="font-size: 0.95rem;"></i>
                                                    </span>
                                                <% } %>
                                                
                                                <!-- Delete button for Pending shifts -->
                                                <% if ("Pending".equalsIgnoreCase(status)) { %>
                                                    <a href="${pageContext.request.contextPath}/employee/schedules?action=delete&id=<%= ws.getScheduleID() %>" 
                                                       class="btn-shift-delete" 
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa ca làm này không?')"
                                                       title="Xóa ca đăng ký">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </a>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>

    <!-- Bootstrap JS Bundle for tooltips -->
    <script>
        // Initialize tooltips for notes
        document.addEventListener("DOMContentLoaded", function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>
