<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.LeaveType"%>
<%@page import="models.LeaveRequest"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    String mode = (String) request.getAttribute("mode");
    boolean isEdit = "edit".equals(mode);
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leaveRequest");
    List<LeaveType> leaveTypes = (List<LeaveType>) request.getAttribute("leaveTypes");
    SimpleDateFormat iso = new SimpleDateFormat("yyyy-MM-dd");

    String leaveTypeId = request.getAttribute("leaveTypeId") != null
            ? String.valueOf(request.getAttribute("leaveTypeId"))
            : (lr != null ? String.valueOf(lr.getLeaveTypeID()) : "");
    String startDate = request.getAttribute("startDate") != null
            ? String.valueOf(request.getAttribute("startDate"))
            : (lr != null && lr.getStartDate() != null ? iso.format(lr.getStartDate()) : "");
    String endDate = request.getAttribute("endDate") != null
            ? String.valueOf(request.getAttribute("endDate"))
            : (lr != null && lr.getEndDate() != null ? iso.format(lr.getEndDate()) : "");
    String reason = request.getAttribute("reason") != null
            ? String.valueOf(request.getAttribute("reason"))
            : (lr != null && lr.getReason() != null ? lr.getReason() : "");
            
    String pageTitle = isEdit ? "Chỉnh sửa Đơn nghỉ phép" : "Tạo Đơn nghỉ phép mới";
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
                    <h1 class="page-title"><%= isEdit ? "Chỉnh sửa đơn (Bản nháp)" : "Tạo đơn nghỉ phép mới" %></h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/employee/leave-requests"> / Đơn nghỉ phép</a></li>
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
                            <i class="fa-solid fa-file-signature text-primary me-2"></i> Chi tiết thông tin xin nghỉ phép
                        </h4>
                        
                        <form method="post" action="${pageContext.request.contextPath}/employee/leave-requests/<%= isEdit ? "edit" : "create" %>" onsubmit="return validateForm()">
                            <% if (isEdit && lr != null) { %>
                                <input type="hidden" name="requestId" value="<%= lr.getRequestID() %>">
                            <% } %>

                            <!-- Leave Type -->
                            <div class="form-group-custom">
                                <label for="leaveTypeId" class="form-label-custom">Loại nghỉ phép <span class="text-danger">*</span></label>
                                <select id="leaveTypeId" name="leaveTypeId" class="form-select form-control" required>
                                    <option value="">-- Chọn loại nghỉ --</option>
                                    <% if (leaveTypes != null) {
                                        for (LeaveType t : leaveTypes) {
                                            String selected = String.valueOf(t.getLeaveTypeID()).equals(leaveTypeId) ? "selected" : "";
                                    %>
                                    <option value="<%= t.getLeaveTypeID() %>" <%= selected %> data-max="<%= t.getMaxDays() %>">
                                        <%= t.getLeaveTypeName() %> (tối đa <%= t.getMaxDays() %> ngày)
                                    </option>
                                    <%   }
                                       } %>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn loại nghỉ phép.</div>
                            </div>
                            
                            <!-- Start Date & End Date -->
                            <div class="row">
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="startDate" class="form-label-custom">Ngày bắt đầu <span class="text-danger">*</span></label>
                                        <input type="date" id="startDate" name="startDate" class="form-control-custom form-control" 
                                               value="<%= startDate %>" required>
                                        <div class="invalid-feedback">Ngày bắt đầu không hợp lệ.</div>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="endDate" class="form-label-custom">Ngày kết thúc <span class="text-danger">*</span></label>
                                        <input type="date" id="endDate" name="endDate" class="form-control-custom form-control" 
                                               value="<%= endDate %>" required>
                                        <div class="invalid-feedback" id="endDateFeedback">Ngày kết thúc phải sau ngày bắt đầu.</div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Reason -->
                            <div class="form-group-custom">
                                <label for="reason" class="form-label-custom">Lý do nghỉ phép</label>
                                <textarea id="reason" name="reason" class="form-control-custom form-control" 
                                          style="height: 120px; resize: vertical;" maxlength="500" 
                                          placeholder="Mô tả lý do xin nghỉ phép cụ thể (tối đa 500 ký tự)..."><%= reason %></textarea>
                                <span class="form-hint d-block mt-1" style="font-size: 0.8rem; color: var(--text-secondary);">
                                    <i class="fa-solid fa-circle-info me-1 text-primary"></i>Khuyến nghị điền đầy đủ thông tin để Quản lý dễ dàng xét duyệt.
                                </span>
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Actions -->
                            <div class="d-flex flex-wrap gap-2 justify-content-between">
                                <div>
                                    <% if (isEdit && lr != null) { %>
                                        <button type="submit" name="action" value="delete" class="btn-custom btn-danger-custom"
                                                formaction="${pageContext.request.contextPath}/employee/leave-requests/edit"
                                                onclick="return confirm('Bạn có chắc chắn muốn xóa vĩnh viễn bản nháp này không?');">
                                            <i class="fa-solid fa-trash-can"></i> Xóa bản nháp
                                        </button>
                                    <% } %>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/employee/leave-requests" class="btn-custom btn-secondary-custom">
                                        Quay lại
                                    </a>
                                    <button type="submit" name="action" value="draft" class="btn-custom btn-outline-custom">
                                        <i class="fa-solid fa-file-pen"></i> Lưu nháp (Draft)
                                    </button>
                                    <button type="submit" name="action" value="submit" class="btn-custom btn-success-custom">
                                        <i class="fa-solid fa-paper-plane"></i> Gửi duyệt (Submit)
                                    </button>
                                </div>
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
            document.getElementById("startDate").setAttribute('min', today);
            document.getElementById("endDate").setAttribute('min', today);
        });

        function validateForm() {
            var type = document.getElementById("leaveTypeId").value;
            var startStr = document.getElementById("startDate").value;
            var endStr = document.getElementById("endDate").value;
            var isValid = true;
            
            document.getElementById("leaveTypeId").classList.remove("is-invalid");
            document.getElementById("startDate").classList.remove("is-invalid");
            document.getElementById("endDate").classList.remove("is-invalid");
            
            if (!type) {
                document.getElementById("leaveTypeId").classList.add("is-invalid");
                isValid = false;
            }
            if (!startStr) {
                document.getElementById("startDate").classList.add("is-invalid");
                isValid = false;
            }
            if (!endStr) {
                document.getElementById("endDate").classList.add("is-invalid");
                isValid = false;
            }
            
            if (startStr && endStr) {
                var start = new Date(startStr);
                var end = new Date(endStr);
                
                if (end < start) {
                    document.getElementById("endDate").classList.add("is-invalid");
                    document.getElementById("endDateFeedback").innerText = "Ngày kết thúc không được nhỏ hơn ngày bắt đầu.";
                    isValid = false;
                }
            }
            
            return isValid;
        }
    </script>
</body>
</html>
