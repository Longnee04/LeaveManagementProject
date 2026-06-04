<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.LeaveType"%>
<%@page import="models.LeaveRequest"%>
<%@page import="models.EmployeeLeaveBalance"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    String mode = (String) request.getAttribute("mode");
    boolean isEdit = "edit".equals(mode);
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leaveRequest");
    List<LeaveType> leaveTypes = (List<LeaveType>) request.getAttribute("leaveTypes");
    List<EmployeeLeaveBalance> balances = (List<EmployeeLeaveBalance>) request.getAttribute("balances");
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
    String minUnitChosen = request.getAttribute("minUnitChosen") != null
            ? String.valueOf(request.getAttribute("minUnitChosen"))
            : (lr != null && lr.getMinUnitChosen() != null ? lr.getMinUnitChosen() : "Full");
            
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
    <style>
        .balance-info-badge {
            background-color: var(--body-bg);
            border: 1px dashed var(--border-color);
            border-radius: 8px;
            padding: 12px 16px;
            margin-top: 8px;
            display: none;
            transition: all 0.3s ease;
        }
        .balance-info-val {
            font-weight: 700;
            color: var(--primary);
        }
        .duration-preview {
            font-size: 0.9rem;
            color: var(--success);
            font-weight: 600;
            margin-top: 6px;
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
                            <div class="form-group-custom mb-3">
                                <label for="leaveTypeId" class="form-label-custom">Loại nghỉ phép <span class="text-danger">*</span></label>
                                <select id="leaveTypeId" name="leaveTypeId" class="form-select form-control" onchange="onLeaveTypeChange()" required>
                                    <option value="">-- Chọn loại nghỉ --</option>
                                    <% if (leaveTypes != null) {
                                        for (LeaveType t : leaveTypes) {
                                            String selected = String.valueOf(t.getLeaveTypeID()).equals(leaveTypeId) ? "selected" : "";
                                    %>
                                    <option value="<%= t.getLeaveTypeID() %>" <%= selected %> 
                                            data-max="<%= t.getMaxDays() %>"
                                            data-unit="<%= t.getMinUnit() %>"
                                            data-working-only="<%= t.isIsWorkingDaysOnly() ? "1" : "0" %>"
                                            data-restricted="<%= t.isNewEmployeeRestricted() ? "1" : "0" %>">
                                        <%= t.getLeaveTypeName() %>
                                    </option>
                                    <%   }
                                       } %>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn loại nghỉ phép.</div>
                                
                                <!-- Dynamic Balance Badge -->
                                <div id="balanceBadge" class="balance-info-badge">
                                    <div class="row">
                                        <div class="col-6 text-start">
                                            <span style="font-size: 0.85rem; color: var(--text-secondary);">Hạn mức cả năm:</span>
                                            <span id="quotaVal" class="fw-semibold ms-1 text-dark">0 ngày</span>
                                        </div>
                                        <div class="col-6 text-end">
                                            <span style="font-size: 0.85rem; color: var(--text-secondary);">Số dư còn lại:</span>
                                            <span id="remainingVal" class="balance-info-val ms-1">0 ngày</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Start Date & End Date -->
                            <div class="row mb-3">
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="startDate" class="form-label-custom">Ngày bắt đầu <span class="text-danger">*</span></label>
                                        <input type="date" id="startDate" name="startDate" class="form-control-custom form-control" 
                                               value="<%= startDate %>" onchange="onDateChange()" required>
                                        <div class="invalid-feedback">Ngày bắt đầu không hợp lệ.</div>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="endDate" class="form-label-custom">Ngày kết thúc <span class="text-danger">*</span></label>
                                        <input type="date" id="endDate" name="endDate" class="form-control-custom form-control" 
                                               value="<%= endDate %>" onchange="onDateChange()" required>
                                        <div class="invalid-feedback" id="endDateFeedback">Ngày kết thúc phải sau ngày bắt đầu.</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Min Unit Chosen (Half Day selection) -->
                            <div class="form-group-custom mb-3" id="minUnitContainer" style="display: none;">
                                <label for="minUnitChosen" class="form-label-custom">Hình thức nghỉ phép <span class="text-danger">*</span></label>
                                <select id="minUnitChosen" name="minUnitChosen" class="form-select form-control" onchange="calculateDurationDisplay()">
                                    <option value="Full" <%= "Full".equals(minUnitChosen) ? "selected" : "" %>>Cả ngày (1.0 ngày)</option>
                                    <option value="Morning" <%= "Morning".equals(minUnitChosen) ? "selected" : "" %>>Nửa ngày Sáng (0.5 ngày)</option>
                                    <option value="Afternoon" <%= "Afternoon".equals(minUnitChosen) ? "selected" : "" %>>Nửa ngày Chiều (0.5 ngày)</option>
                                </select>
                            </div>

                            <!-- Duration Display -->
                            <div id="durationPreview" class="duration-preview text-primary mb-3" style="display: none;">
                                <i class="fa-solid fa-calculator me-1"></i> Số ngày tính nghỉ: <span id="durationVal">0</span> ngày
                            </div>
                            
                            <!-- Reason -->
                            <div class="form-group-custom mb-3">
                                <label for="reason" class="form-label-custom">Lý do nghỉ phép</label>
                                <textarea id="reason" name="reason" class="form-control-custom form-control" 
                                          style="height: 100px; resize: vertical;" maxlength="500" 
                                          placeholder="Mô tả lý do xin nghỉ phép cụ thể (tối đa 500 ký tự)..."><%= reason %></textarea>
                                <span class="form-hint d-block mt-1" style="font-size: 0.8rem; color: var(--text-secondary);">
                                    <i class="fa-solid fa-circle-info me-1 text-primary"></i>Hệ thống sẽ tự động loại trừ Thứ 7 và Chủ nhật đối với các loại phép năm.
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
                                        <i class="fa-solid fa-file-pen"></i> Lưu nháp
                                    </button>
                                    <button type="submit" name="action" value="submit" class="btn-custom btn-success-custom">
                                        <i class="fa-solid fa-paper-plane"></i> Gửi duyệt
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

    <!-- Client-side Employee Balances Data mapping -->
    <script>
        var userBalances = {
            <% if (balances != null) {
                for (EmployeeLeaveBalance b : balances) { %>
                    "<%= b.getLeaveTypeID() %>": {
                        quota: <%= b.getAnnualQuota() %>,
                        used: <%= b.getUsedDays() %>,
                        remaining: <%= b.getRemainingDays() %>
                    },
            <%  }
               } %>
        };

        // Thiết lập min date cho date picker là ngày hôm nay
        document.addEventListener("DOMContentLoaded", function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("startDate").setAttribute('min', today);
            document.getElementById("endDate").setAttribute('min', today);
            
            // Trigger load ban đầu nếu có dữ liệu sẵn (khi Edit hoặc Validate Error)
            onLeaveTypeChange();
        });

        function onLeaveTypeChange() {
            var select = document.getElementById("leaveTypeId");
            var typeId = select.value;
            var balanceBadge = document.getElementById("balanceBadge");
            
            if (typeId && userBalances[typeId]) {
                var bal = userBalances[typeId];
                document.getElementById("quotaVal").innerText = bal.quota + " ngày";
                document.getElementById("remainingVal").innerText = bal.remaining + " ngày";
                balanceBadge.style.display = "block";
            } else {
                balanceBadge.style.display = "none";
            }
            
            onDateChange(); // Recalculate duration options when leave type changes
        }

        function onDateChange() {
            var startVal = document.getElementById("startDate").value;
            var endVal = document.getElementById("endDate").value;
            var select = document.getElementById("leaveTypeId");
            var option = select.options[select.selectedIndex];
            
            var unitContainer = document.getElementById("minUnitContainer");
            
            if (startVal && endVal && startVal === endVal && option && option.getAttribute("data-unit") === "Half-Day") {
                // Hiển thị lựa chọn nửa ngày nếu ngày bắt đầu trùng ngày kết thúc và loại nghỉ hỗ trợ nửa ngày
                unitContainer.style.display = "block";
            } else {
                unitContainer.style.display = "none";
                document.getElementById("minUnitChosen").value = "Full";
            }
            
            calculateDurationDisplay();
        }

        function calculateDurationDisplay() {
            var startStr = document.getElementById("startDate").value;
            var endStr = document.getElementById("endDate").value;
            var select = document.getElementById("leaveTypeId");
            var option = select.options[select.selectedIndex];
            var minUnitChosen = document.getElementById("minUnitChosen").value;
            
            var preview = document.getElementById("durationPreview");
            
            if (!startStr || !endStr || !option || option.value === "") {
                preview.style.display = "none";
                return;
            }

            var start = new Date(startStr);
            var end = new Date(endStr);
            
            if (end < start) {
                preview.style.display = "none";
                return;
            }

            var duration = 0;
            if (startStr === endStr && minUnitChosen !== "Full") {
                duration = 0.5;
            } else {
                var workingOnly = option.getAttribute("data-working-only") === "1";
                var curr = new Date(start);
                while (curr <= end) {
                    var day = curr.getDay();
                    if (!workingOnly || (day !== 0 && day !== 6)) { // 0 = Chủ nhật, 6 = Thứ bảy
                        duration += 1;
                    }
                    curr.setDate(curr.getDate() + 1);
                }
            }

            document.getElementById("durationVal").innerText = duration;
            preview.style.display = "block";
        }

        function validateForm() {
            var typeSelect = document.getElementById("leaveTypeId");
            var type = typeSelect.value;
            var startStr = document.getElementById("startDate").value;
            var endStr = document.getElementById("endDate").value;
            var isValid = true;
            
            typeSelect.classList.remove("is-invalid");
            document.getElementById("startDate").classList.remove("is-invalid");
            document.getElementById("endDate").classList.remove("is-invalid");
            
            if (!type) {
                typeSelect.classList.add("is-invalid");
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
            
            // Validate client-side leave balance
            if (isValid && type && userBalances[type]) {
                var duration = parseFloat(document.getElementById("durationVal").innerText);
                var remaining = userBalances[type].remaining;
                if (duration > remaining) {
                    alert("Số dư nghỉ phép của bạn không đủ (" + remaining + " ngày còn lại) để thực hiện yêu cầu nghỉ " + duration + " ngày.");
                    isValid = false;
                }
            }
            
            return isValid;
        }
    </script>
</body>
</html>
