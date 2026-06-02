<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.WorkSchedule"%>
<%
    WorkSchedule ws = (WorkSchedule) request.getAttribute("schedule");
    boolean isEdit = (ws != null);
    String pageTitle = isEdit ? "Chỉnh sửa Lịch làm việc" : "Đăng ký Lịch làm việc";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - HRM System</title>
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
                    <h1 class="page-title"><%= pageTitle %></h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/employee/schedules"> / Lịch làm việc</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / <%= isEdit ? "Chỉnh sửa" : "Đăng ký mới" %></li>
                    </ul>
                </div>
            </div>

            <!-- Error Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger-custom alert-custom shadow-sm mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <div class="row justify-content-center">
                <div class="col-12 col-lg-8">
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary);">
                            <i class="fa-solid fa-calendar-days text-primary me-2"></i> Thông tin ca đăng ký làm việc
                        </h4>
                        
                        <form method="post" action="${pageContext.request.contextPath}/employee/schedules" onsubmit="return validateForm()">
                            <% if (isEdit) { %>
                                <input type="hidden" name="scheduleId" value="<%= ws.getScheduleID() %>">
                            <% } %>

                            <!-- Work Date -->
                            <div class="form-group-custom">
                                <label for="workDate" class="form-label-custom">Ngày làm việc <span class="text-danger">*</span></label>
                                <input type="date" id="workDate" name="workDate" class="form-control-custom form-control" 
                                       value="<%= isEdit ? ws.getWorkDate().toString() : "" %>" required>
                                <div class="invalid-feedback">Ngày làm việc không hợp lệ hoặc đã qua.</div>
                            </div>
                            
                            <!-- Shift Select -->
                            <div class="form-group-custom">
                                <label for="shift" class="form-label-custom">Ca làm đăng ký <span class="text-danger">*</span></label>
                                <select id="shift" name="shift" class="form-select form-control" required>
                                    <option value="">-- Chọn ca làm --</option>
                                    <option value="Morning" <%= isEdit && "Morning".equals(ws.getShift()) ? "selected" : "" %>>Ca Sáng (08:00 - 12:00)</option>
                                    <option value="Afternoon" <%= isEdit && "Afternoon".equals(ws.getShift()) ? "selected" : "" %>>Ca Chiều (13:00 - 17:00)</option>
                                    <option value="Evening" <%= isEdit && "Evening".equals(ws.getShift()) ? "selected" : "" %>>Ca Tối (18:00 - 22:00)</option>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn ca làm việc.</div>
                            </div>
                            
                            <!-- Note -->
                            <div class="form-group-custom">
                                <label for="note" class="form-label-custom">Ghi chú gửi Quản lý</label>
                                <textarea id="note" name="note" class="form-control-custom form-control" 
                                          style="height: 100px; resize: vertical;" placeholder="Nhập lý do đổi ca hoặc ghi chú bổ sung..."><%= isEdit && ws.getNote() != null ? ws.getNote() : "" %></textarea>
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Actions -->
                            <div class="d-flex gap-3 justify-content-end">
                                <a href="${pageContext.request.contextPath}/employee/schedules" class="btn-custom btn-secondary-custom">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-custom btn-primary-custom">
                                    <i class="fa-solid fa-circle-check"></i> <%= isEdit ? "Lưu cập nhật" : "Gửi đăng ký" %>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>

    <script>
        // Thiết lập min date cho date picker là ngày hôm nay
        document.addEventListener("DOMContentLoaded", function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("workDate").setAttribute('min', today);
        });

        function validateForm() {
            var workDateStr = document.getElementById("workDate").value;
            var shift = document.getElementById("shift").value;
            var isValid = true;
            
            document.getElementById("workDate").classList.remove("is-invalid");
            document.getElementById("shift").classList.remove("is-invalid");
            
            if (!workDateStr) {
                document.getElementById("workDate").classList.add("is-invalid");
                isValid = false;
            } else {
                var workDate = new Date(workDateStr);
                var today = new Date();
                today.setHours(0,0,0,0);
                if (workDate < today) {
                    document.getElementById("workDate").classList.add("is-invalid");
                    isValid = false;
                }
            }
            
            if (!shift) {
                document.getElementById("shift").classList.add("is-invalid");
                isValid = false;
            }
            
            return isValid;
        }
    </script>
</body>
</html>
