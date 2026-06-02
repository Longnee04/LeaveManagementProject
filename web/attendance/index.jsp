<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Attendance"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    Attendance today = (Attendance) request.getAttribute("todayAttendance");
    List<Attendance> history = (List<Attendance>) request.getAttribute("attendanceHistory");
    
    SimpleDateFormat timeFmt = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat dateFmt = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chấm công trực tuyến - HRM System</title>
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
                    <h1 class="page-title">Chấm công trực tuyến</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Điểm danh Chấm công</li>
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

            <div class="row g-4 mb-4">
                <div class="col-12 col-md-5">
                    <!-- Today's Attendance Card -->
                    <div class="form-card text-center" style="height: 100%;">
                        <h4 class="mb-3" style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary);">
                            <i class="fa-solid fa-clock-pulse text-primary me-2"></i> Trạng thái Hôm nay
                        </h4>
                        
                        <div class="mb-4 text-secondary" style="font-size: 0.9rem;">
                            <%= dateFmt.format(new java.util.Date()) %>
                        </div>
                        
                        <!-- Real-time Clock display -->
                        <div class="h2 font-weight-bold mb-4" id="liveClock" style="font-weight: 700; font-family: monospace; color: #1e3a8a;">
                            00:00:00
                        </div>

                        <div class="form-card p-3 mb-4 bg-light border-0 shadow-none text-start" style="border-radius: 8px;">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-secondary" style="font-size: 0.85rem;">Giờ vào làm (Check-In):</span>
                                <strong class="text-primary" style="font-size: 0.925rem;">
                                    <%= today != null && today.getCheckIn() != null ? timeFmt.format(today.getCheckIn()) : "--:--:--" %>
                                </strong>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-secondary" style="font-size: 0.85rem;">Giờ ra về (Check-Out):</span>
                                <strong class="text-danger" style="font-size: 0.925rem;">
                                    <%= today != null && today.getCheckOut() != null ? timeFmt.format(today.getCheckOut()) : "--:--:--" %>
                                </strong>
                            </div>
                            <div class="d-flex justify-content-between pt-2 border-top">
                                <span class="text-secondary" style="font-size: 0.85rem; font-weight: 600;">Tổng giờ làm hôm nay:</span>
                                <strong class="text-success" style="font-size: 0.925rem; font-weight: 700;">
                                    <%= today != null && today.getCheckOut() != null ? today.getWorkHours() + " giờ" : "Chưa hoàn tất" %>
                                </strong>
                            </div>
                        </div>

                        <!-- Check-in / Check-out Forms -->
                        <div class="row g-2">
                            <div class="col-6">
                                <form method="post" action="${pageContext.request.contextPath}/attendance">
                                    <input type="hidden" name="action" value="checkin">
                                    <button type="submit" class="btn-custom btn-primary-custom w-100 py-2.5" 
                                            <%= today != null ? "disabled" : "" %>>
                                        <i class="fa-solid fa-right-to-bracket"></i> Check-In
                                    </button>
                                </form>
                            </div>
                            <div class="col-6">
                                <form method="post" action="${pageContext.request.contextPath}/attendance">
                                    <input type="hidden" name="action" value="checkout">
                                    <button type="submit" class="btn-custom btn-danger-custom w-100 py-2.5" 
                                            <%= today == null || (today != null && today.getCheckOut() != null) ? "disabled" : "" %>>
                                        <i class="fa-solid fa-right-from-bracket"></i> Check-Out
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-md-7">
                    <!-- History Logs Card -->
                    <div class="form-card" style="height: 100%;">
                        <h4 class="mb-3" style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary);">
                            <i class="fa-solid fa-list-check text-primary me-2"></i> Nhật ký chấm công gần đây
                        </h4>
                        
                        <div class="table-responsive">
                            <% if (history == null || history.isEmpty()) { %>
                                <div class="empty-state-custom">
                                    <i class="fa-solid fa-history"></i>
                                    <p>Không có bản ghi điểm danh nào được ghi nhận trước đây.</p>
                                </div>
                            <% } else { %>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Ngày làm</th>
                                            <th>Vào làm (In)</th>
                                            <th>Ra về (Out)</th>
                                            <th>Tổng giờ làm</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Attendance att : history) { %>
                                            <tr>
                                                <td style="font-weight: 600;"><%= dateFmt.format(att.getAttendanceDate()) %></td>
                                                <td style="font-weight: 500; color: var(--primary);">
                                                    <%= att.getCheckIn() != null ? timeFmt.format(att.getCheckIn()) : "--:--:--" %>
                                                </td>
                                                <td style="font-weight: 500; color: var(--danger);">
                                                    <%= att.getCheckOut() != null ? timeFmt.format(att.getCheckOut()) : "--:--:--" %>
                                                </td>
                                                <td>
                                                    <% if (att.getCheckOut() != null) { %>
                                                        <span class="badge bg-success" style="font-size: 0.85rem; padding: 5px 12px; border-radius: 12px;">
                                                            <%= att.getWorkHours() %> giờ
                                                        </span>
                                                    <% } else { %>
                                                        <span class="badge bg-warning text-dark" style="font-size: 0.85rem; padding: 5px 12px; border-radius: 12px;">
                                                            Đang trực
                                                        </span>
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
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>

    <!-- Live clock script -->
    <script>
        function updateLiveClock() {
            var now = new Date();
            var hours = now.getHours().toString().padStart(2, '0');
            var minutes = now.getMinutes().toString().padStart(2, '0');
            var seconds = now.getSeconds().toString().padStart(2, '0');
            var clockEl = document.getElementById("liveClock");
            if (clockEl) {
                clockEl.textContent = hours + ":" + minutes + ":" + seconds;
            }
        }
        
        document.addEventListener("DOMContentLoaded", function() {
            updateLiveClock();
            setInterval(updateLiveClock, 1000);
        });
    </script>
</body>
</html>
