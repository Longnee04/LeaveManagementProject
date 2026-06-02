<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Agenda"%>
<%
    Agenda agenda = (Agenda) request.getAttribute("agenda");
    boolean isEdit = (agenda != null);
    String pageTitle = isEdit ? "Cập nhật Cuộc họp / Sự kiện" : "Tạo Cuộc họp / Sự kiện mới";
    
    // Định dạng thời gian để gán vào input datetime-local
    String startTimeVal = "";
    String endTimeVal = "";
    if (isEdit) {
        java.text.SimpleDateFormat localFormat = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        startTimeVal = localFormat.format(agenda.getStartTime());
        endTimeVal = localFormat.format(agenda.getEndTime());
    }
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
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/agenda"> / Sự kiện</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / <%= isEdit ? "Cập nhật" : "Tạo mới" %></li>
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
                            <i class="fa-solid fa-calendar-check text-primary me-2"></i> Chi tiết cuộc họp hoặc sự kiện
                        </h4>
                        
                        <form method="post" action="${pageContext.request.contextPath}/agenda/<%= isEdit ? "edit" : "add" %>" onsubmit="return validateForm()">
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= agenda.getAgendaID() %>">
                            <% } %>

                            <!-- Title -->
                            <div class="form-group-custom">
                                <label for="title" class="form-label-custom">Chủ đề cuộc họp / Tên sự kiện <span class="text-danger">*</span></label>
                                <input type="text" id="title" name="title" class="form-control-custom form-control" 
                                       value="<%= isEdit ? agenda.getTitle() : "" %>" required placeholder="Nhập chủ đề cuộc họp (ví dụ: Họp team IT hàng tuần)">
                                <div class="invalid-feedback">Chủ đề không được để trống.</div>
                            </div>
                            
                            <!-- Description -->
                            <div class="form-group-custom">
                                <label for="description" class="form-label-custom">Mô tả nội dung chương trình</label>
                                <textarea id="description" name="description" class="form-control-custom form-control" 
                                          style="height: 120px; resize: vertical;" placeholder="Nhập tóm tắt nội dung cuộc họp hoặc ghi chú chuẩn bị..."><%= isEdit && agenda.getDescription() != null ? agenda.getDescription() : "" %></textarea>
                            </div>
                            
                            <div class="row">
                                <!-- Start Time -->
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="startTime" class="form-label-custom">Thời gian bắt đầu <span class="text-danger">*</span></label>
                                        <input type="datetime-local" id="startTime" name="startTime" class="form-control-custom form-control" 
                                               value="<%= startTimeVal %>" required>
                                        <div class="invalid-feedback" id="startTimeFeedback">Thời gian bắt đầu không hợp lệ.</div>
                                    </div>
                                </div>
                                
                                <!-- End Time -->
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="endTime" class="form-label-custom">Thời gian kết thúc <span class="text-danger">*</span></label>
                                        <input type="datetime-local" id="endTime" name="endTime" class="form-control-custom form-control" 
                                               value="<%= endTimeVal %>" required>
                                        <div class="invalid-feedback" id="endTimeFeedback">Thời gian kết thúc phải sau thời gian bắt đầu.</div>
                                    </div>
                                </div>
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Actions -->
                            <div class="d-flex gap-3 justify-content-end">
                                <a href="${pageContext.request.contextPath}/agenda" class="btn-custom btn-secondary-custom">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-custom btn-primary-custom">
                                    <i class="fa-solid fa-floppy-disk"></i> Lưu sự kiện
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
        // Mặc định thiết lập min time cho form tạo mới là thời điểm hiện tại
        document.addEventListener("DOMContentLoaded", function() {
            if (<%= !isEdit %>) {
                var now = new Date();
                now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
                var nowStr = now.toISOString().slice(0, 16);
                document.getElementById("startTime").setAttribute("min", nowStr);
                document.getElementById("endTime").setAttribute("min", nowStr);
            }
        });

        function validateForm() {
            var title = document.getElementById("title").value.trim();
            var startTimeStr = document.getElementById("startTime").value;
            var endTimeStr = document.getElementById("endTime").value;
            var isValid = true;
            
            document.getElementById("title").classList.remove("is-invalid");
            document.getElementById("startTime").classList.remove("is-invalid");
            document.getElementById("endTime").classList.remove("is-invalid");
            
            if (!title) {
                document.getElementById("title").classList.add("is-invalid");
                isValid = false;
            }
            
            if (!startTimeStr) {
                document.getElementById("startTime").classList.add("is-invalid");
                isValid = false;
            }
            
            if (!endTimeStr) {
                document.getElementById("endTime").classList.add("is-invalid");
                isValid = false;
            }
            
            if (startTimeStr && endTimeStr) {
                var start = new Date(startTimeStr);
                var end = new Date(endTimeStr);
                
                if (end <= start) {
                    document.getElementById("endTime").classList.add("is-invalid");
                    document.getElementById("endTimeFeedback").innerText = "Thời gian kết thúc phải sau thời gian bắt đầu.";
                    isValid = false;
                }
            }
            
            return isValid;
        }
    </script>
</body>
</html>
