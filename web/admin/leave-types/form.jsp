<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.LeaveType"%>
<%
    LeaveType type = (LeaveType) request.getAttribute("leaveType");
    boolean isEdit = (type != null);
    String pageTitle = isEdit ? "Cập nhật Loại nghỉ phép" : "Thêm Loại nghỉ phép mới";
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
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/admin/leave-types"> / Loại nghỉ phép</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / <%= isEdit ? "Cập nhật" : "Thêm mới" %></li>
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
                            <i class="fa-solid fa-gear text-primary me-2"></i> Thông tin loại nghỉ phép
                        </h4>
                        
                        <form method="post" action="${pageContext.request.contextPath}/admin/leave-types?action=<%= isEdit ? "edit" : "add" %>" onsubmit="return validateForm()">
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= type.getLeaveTypeID() %>">
                            <% } %>

                            <!-- Leave Type Name -->
                            <div class="form-group-custom">
                                <label for="leaveTypeName" class="form-label-custom">Tên loại nghỉ phép <span class="text-danger">*</span></label>
                                <input type="text" id="leaveTypeName" name="leaveTypeName" class="form-control-custom form-control" 
                                       value="<%= isEdit ? type.getLeaveTypeName() : "" %>" required placeholder="Nhập tên loại nghỉ phép (ví dụ: Nghỉ phép năm)">
                                <div class="invalid-feedback">Tên loại nghỉ phép không được để trống.</div>
                            </div>
                            
                            <!-- Description -->
                            <div class="form-group-custom">
                                <label for="description" class="form-label-custom">Mô tả quy định</label>
                                <textarea id="description" name="description" class="form-control-custom form-control" 
                                          style="height: 100px; resize: vertical;" placeholder="Nhập mô tả hoặc điều kiện hưởng nghỉ phép..."><%= isEdit && type.getDescription() != null ? type.getDescription() : "" %></textarea>
                            </div>
                            
                            <!-- Max Days -->
                            <div class="form-group-custom">
                                <label for="maxDays" class="form-label-custom">Số ngày nghỉ phép tối đa / năm <span class="text-danger">*</span></label>
                                <input type="number" id="maxDays" name="maxDays" class="form-control-custom form-control" 
                                       value="<%= isEdit ? type.getMaxDays() : "12" %>" required min="1" placeholder="Nhập số ngày phép tối đa (ví dụ: 12)">
                                <div class="invalid-feedback">Số ngày nghỉ tối đa phải lớn hơn 0.</div>
                            </div>

                            <!-- Min Unit selection -->
                            <div class="form-group-custom">
                                <label for="minUnit" class="form-label-custom">Đơn vị nghỉ tối thiểu <span class="text-danger">*</span></label>
                                <select id="minUnit" name="minUnit" class="form-select form-control" required>
                                    <option value="Day" <%= isEdit && "Day".equalsIgnoreCase(type.getMinUnit()) ? "selected" : "" %>>Theo ngày (Full Day)</option>
                                    <option value="Half-Day" <%= isEdit && "Half-Day".equalsIgnoreCase(type.getMinUnit()) ? "selected" : "" %>>Theo nửa ngày (Half-Day - 0.5 ngày)</option>
                                </select>
                                <div class="form-text text-muted small mt-1">Quyết định xem nhân viên có được đăng ký nghỉ nửa ngày (Morning/Afternoon) đối với loại phép này không.</div>
                            </div>

                            <!-- Is Working Days Only Toggle -->
                            <div class="form-group-custom mt-3">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isWorkingDaysOnly" name="isWorkingDaysOnly" value="1" 
                                           <%= isEdit && type.isIsWorkingDaysOnly() ? "checked" : "" %>>
                                    <label class="form-check-label fw-semibold" for="isWorkingDaysOnly" style="color: var(--text-primary);">
                                        Chỉ tính ngày làm việc (Loại bỏ Thứ 7 & Chủ Nhật)
                                    </label>
                                </div>
                                <div class="form-text text-muted small mt-1">Khi được bật, đơn nghỉ phép đi qua cuối tuần sẽ không bị tính số ngày nghỉ cho thứ 7 và chủ nhật.</div>
                            </div>

                            <!-- New Employee Probation Restricted Toggle -->
                            <div class="form-group-custom mt-3">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="newEmployeeRestricted" name="newEmployeeRestricted" value="1" 
                                           <%= isEdit && type.isNewEmployeeRestricted() ? "checked" : "" %>>
                                    <label class="form-check-label fw-semibold" for="newEmployeeRestricted" style="color: var(--text-primary);">
                                        Giới hạn nhân viên mới thử việc
                                    </label>
                                </div>
                                <div class="form-text text-muted small mt-1">Nhân viên mới làm việc dưới 30 ngày sẽ không được đăng ký loại nghỉ phép này.</div>
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Actions -->
                            <div class="d-flex gap-3 justify-content-end">
                                <a href="${pageContext.request.contextPath}/admin/leave-types" class="btn-custom btn-secondary-custom">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-custom btn-primary-custom">
                                    <i class="fa-solid fa-floppy-disk"></i> Lưu thông tin
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
        function validateForm() {
            var name = document.getElementById("leaveTypeName").value.trim();
            var maxDays = parseInt(document.getElementById("maxDays").value);
            var isValid = true;
            
            document.getElementById("leaveTypeName").classList.remove("is-invalid");
            document.getElementById("maxDays").classList.remove("is-invalid");
            
            if (!name) {
                document.getElementById("leaveTypeName").classList.add("is-invalid");
                isValid = false;
            }
            if (isNaN(maxDays) || maxDays <= 0) {
                document.getElementById("maxDays").classList.add("is-invalid");
                isValid = false;
            }
            
            return isValid;
        }
    </script>
</body>
</html>
