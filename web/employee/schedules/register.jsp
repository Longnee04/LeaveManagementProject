<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%@page import="utils.SessionKeys"%>
<%
    User user = (User) request.getSession().getAttribute(SessionKeys.USER);
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký lịch làm việc theo tuần - HRM System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Font Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Global Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* Custom enhancements for the grid registration page */
        .date-range-selector {
            background: linear-gradient(145deg, #ffffff, #f8fafc);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
        }
        
        .grid-day-card {
            border: 1px solid var(--border-color);
            border-radius: 10px;
            background-color: #ffffff;
            margin-bottom: 12px;
            transition: all 0.2s ease;
        }
        
        .grid-day-card:hover {
            border-color: var(--primary);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.08);
            transform: translateY(-1px);
        }
        
        .grid-day-header {
            background-color: #f8fafc;
            border-bottom: 1px solid var(--border-color);
            padding: 12px 20px;
            border-top-left-radius: 9px;
            border-top-right-radius: 9px;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .grid-day-body {
            padding: 16px 20px;
        }
        
        .shift-pill-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        .shift-checkbox-wrapper {
            position: relative;
            flex: 1;
            min-width: 140px;
        }
        
        .shift-checkbox-wrapper input[type="checkbox"] {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .shift-label-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 12px 10px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            background-color: #ffffff;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--text-secondary);
            transition: all 0.2s ease;
            text-align: center;
            height: 100%;
        }
        
        .shift-label-card i {
            font-size: 1.25rem;
            margin-bottom: 6px;
        }
        
        /* Focus/Hover states */
        .shift-checkbox-wrapper:hover .shift-label-card {
            border-color: #cbd5e1;
            color: var(--text-primary);
            background-color: #f8fafc;
        }
        
        /* Active morning states */
        .shift-checkbox-wrapper input[type="checkbox"]:checked + .shift-label-card.morning {
            border-color: var(--primary);
            background-color: #eff6ff;
            color: var(--primary);
        }
        /* Active afternoon states */
        .shift-checkbox-wrapper input[type="checkbox"]:checked + .shift-label-card.afternoon {
            border-color: var(--success);
            background-color: #ecfdf5;
            color: var(--success);
        }
        /* Active evening states */
        .shift-checkbox-wrapper input[type="checkbox"]:checked + .shift-label-card.evening {
            border-color: #1e293b;
            background-color: #f1f5f9;
            color: #1e293b;
        }
        
        .quick-actions-bar {
            background-color: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 12px 20px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
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
                    <h1 class="page-title">Đăng ký lịch làm việc theo tuần</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/employee/schedules"> / Lịch làm việc</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Đăng ký theo tuần</li>
                    </ul>
                </div>
                <a href="${pageContext.request.contextPath}/employee/schedules" class="btn-custom btn-secondary-custom">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <!-- Error Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger-custom alert-custom shadow-sm mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/employee/schedules" onsubmit="return validateForm()">
                <!-- Date Range Selector -->
                <div class="date-range-selector">
                    <h4 class="mb-3" style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary);">
                        <i class="fa-solid fa-calendar-days text-primary me-2"></i> Chọn khoảng thời gian
                    </h4>
                    <div class="row align-items-end">
                        <div class="col-12 col-md-5 mb-3 mb-md-0">
                            <label for="startDate" class="form-label-custom">Từ ngày <span class="text-danger">*</span></label>
                            <input type="date" id="startDate" name="startDate" class="form-control-custom form-control" required>
                        </div>
                        <div class="col-12 col-md-5 mb-3 mb-md-0">
                            <label for="endDate" class="form-label-custom">Tới ngày <span class="text-danger">*</span></label>
                            <input type="date" id="endDate" name="endDate" class="form-control-custom form-control" required>
                        </div>
                        <div class="col-12 col-md-2 text-md-end">
                            <button type="button" id="btnBuildGrid" class="btn-custom btn-outline-custom w-100 py-2">
                                <i class="fa-solid fa-gears"></i> Tạo bảng
                            </button>
                        </div>
                    </div>
                    <div id="dateValidationError" class="text-danger mt-2" style="font-size: 0.85rem; font-weight: 500; display: none;"></div>
                </div>

                <!-- Grid Form Card -->
                <div id="gridCard" class="form-card" style="display: none;">
                    <!-- Quick actions -->
                    <div class="quick-actions-bar">
                        <span class="text-secondary" style="font-size: 0.875rem; font-weight: 600;">
                            <i class="fa-solid fa-bolt text-warning me-1"></i> Chọn nhanh cho cả giai đoạn:
                        </span>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn-custom btn-secondary-custom btn-sm-custom" onclick="quickSelectAll('Morning')">
                                <i class="fa-solid fa-sun text-primary"></i> Sáng
                            </button>
                            <button type="button" class="btn-custom btn-secondary-custom btn-sm-custom" onclick="quickSelectAll('Afternoon')">
                                <i class="fa-solid fa-cloud-sun text-success"></i> Chiều
                            </button>
                            <button type="button" class="btn-custom btn-secondary-custom btn-sm-custom" onclick="quickSelectAll('Evening')">
                                <i class="fa-solid fa-moon text-dark"></i> Tối
                            </button>
                            <button type="button" class="btn-custom btn-secondary-custom btn-sm-custom" onclick="quickSelectAll('ALL')">
                                Chọn hết
                            </button>
                            <button type="button" class="btn-custom btn-outline-custom btn-sm-custom border-danger text-danger" onclick="quickSelectAll('NONE')">
                                Xóa hết
                            </button>
                        </div>
                    </div>

                    <!-- Dynamic container -->
                    <div id="schedulesGridContainer">
                        <!-- Filled by JavaScript -->
                    </div>

                    <!-- Note alert -->
                    <div class="alert alert-warning-custom alert-custom shadow-sm mb-4 mt-3" style="font-size: 0.85rem;">
                        <i class="fa-solid fa-circle-info"></i>
                        <span>
                            <strong>Lưu ý:</strong> Đăng ký mới này sẽ ghi đè và thay thế hoàn toàn các ca làm đang <strong>Chờ duyệt (Pending)</strong> cũ trong khoảng ngày này. Các ca đã <strong>Đã duyệt (Approved)</strong> sẽ được giữ nguyên để đảm bảo tính lịch sử.
                        </span>
                    </div>

                    <hr class="my-4" style="border-color: var(--border-color);">

                    <!-- Form Actions -->
                    <div class="d-flex gap-3 justify-content-end">
                        <a href="${pageContext.request.contextPath}/employee/schedules" class="btn-custom btn-secondary-custom">
                            Hủy bỏ
                        </a>
                        <button type="submit" class="btn-custom btn-primary-custom">
                            <i class="fa-solid fa-paper-plane"></i> Gửi đăng ký lịch làm
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>

    <!-- Bootstrap JS and dynamic logic -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Set min date to today for both date picker fields
            var today = new Date().toISOString().split('T')[0];
            document.getElementById("startDate").setAttribute('min', today);
            document.getElementById("endDate").setAttribute('min', today);
            
            // Event listeners
            document.getElementById("startDate").addEventListener("change", function() {
                var startVal = this.value;
                document.getElementById("endDate").setAttribute('min', startVal);
            });
            
            document.getElementById("btnBuildGrid").addEventListener("click", buildGrid);
        });
        
        function capitalizeFirstLetter(str) {
            if (!str) return '';
            return str.charAt(0).toUpperCase() + str.slice(1);
        }

        function getVietnameseDayOfWeek(date) {
            var days = ["Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"];
            return days[date.getDay()];
        }
        
        function formatDateVietnamese(dateStr) {
            var date = new Date(dateStr);
            var dd = String(date.getDate()).padStart(2, '0');
            var mm = String(date.getMonth() + 1).padStart(2, '0');
            var yyyy = date.getFullYear();
            var dayName = getVietnameseDayOfWeek(date);
            return dayName + ", " + dd + "/" + mm + "/" + yyyy;
        }

        function buildGrid() {
            var startInput = document.getElementById("startDate");
            var endInput = document.getElementById("endDate");
            var errorDiv = document.getElementById("dateValidationError");
            var gridCard = document.getElementById("gridCard");
            var container = document.getElementById("schedulesGridContainer");
            
            errorDiv.style.display = "none";
            errorDiv.innerText = "";
            
            var startDateVal = startInput.value;
            var endDateVal = endInput.value;
            
            if (!startDateVal || !endDateVal) {
                errorDiv.innerText = "Vui lòng chọn đầy đủ ngày bắt đầu và kết thúc.";
                errorDiv.style.display = "block";
                gridCard.style.display = "none";
                return;
            }
            
            var start = new Date(startDateVal);
            var end = new Date(endDateVal);
            
            if (end < start) {
                errorDiv.innerText = "Ngày kết thúc không thể nhỏ hơn ngày bắt đầu.";
                errorDiv.style.display = "block";
                gridCard.style.display = "none";
                return;
            }
            
            // Limit range to max 31 days
            var diffTime = Math.abs(end - start);
            var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
            
            if (diffDays > 31) {
                errorDiv.innerText = "Không thể đăng ký quá 31 ngày trong một lần. Vui lòng chọn khoảng ngày ngắn hơn.";
                errorDiv.style.display = "block";
                gridCard.style.display = "none";
                return;
            }
            
            // Build the grid
            container.innerHTML = "";
            var loopDate = new Date(start);
            
            while (loopDate <= end) {
                var dateKey = loopDate.toISOString().split('T')[0];
                var dateDisplay = formatDateVietnamese(dateKey);
                
                var dayCardHtml = `
                    <div class="grid-day-card">
                        <div class="grid-day-header">
                            <span><i class="fa-solid fa-calendar-day text-secondary me-2"></i>${dateDisplay}</span>
                            <span class="badge bg-secondary-subtle text-secondary" style="font-size: 0.8rem; border: 1px solid var(--border-color);">${dateKey}</span>
                        </div>
                        <div class="grid-day-body">
                            <div class="row align-items-center">
                                <div class="col-12 col-lg-7 mb-3 mb-lg-0">
                                    <div class="shift-pill-group">
                                        <!-- Morning Shift -->
                                        <div class="shift-checkbox-wrapper">
                                            <input type="checkbox" id="shift_${dateKey}_Morning" name="shift_${dateKey}_Morning" value="Morning">
                                            <label for="shift_${dateKey}_Morning" class="shift-label-card morning">
                                                <i class="fa-solid fa-sun text-warning"></i>
                                                <span>Ca Sáng</span>
                                                <span class="text-muted" style="font-size: 0.75rem; font-weight: 500;">08:00 - 12:00</span>
                                            </label>
                                        </div>
                                        
                                        <!-- Afternoon Shift -->
                                        <div class="shift-checkbox-wrapper">
                                            <input type="checkbox" id="shift_${dateKey}_Afternoon" name="shift_${dateKey}_Afternoon" value="Afternoon">
                                            <label for="shift_${dateKey}_Afternoon" class="shift-label-card afternoon">
                                                <i class="fa-solid fa-cloud-sun text-success"></i>
                                                <span>Ca Chiều</span>
                                                <span class="text-muted" style="font-size: 0.75rem; font-weight: 500;">13:00 - 17:00</span>
                                            </label>
                                        </div>
                                        
                                        <!-- Evening Shift -->
                                        <div class="shift-checkbox-wrapper">
                                            <input type="checkbox" id="shift_${dateKey}_Evening" name="shift_${dateKey}_Evening" value="Evening">
                                            <label for="shift_${dateKey}_Evening" class="shift-label-card evening">
                                                <i class="fa-solid fa-moon text-dark"></i>
                                                <span>Ca Tối</span>
                                                <span class="text-muted" style="font-size: 0.75rem; font-weight: 500;">18:00 - 22:00</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-lg-5">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-secondary" style="border-color: var(--border-color); font-size: 0.9rem;"><i class="fa-solid fa-message"></i></span>
                                        <input type="text" name="note_${dateKey}" class="form-control-custom form-control" placeholder="Ghi chú cho ngày này (VD: Cần đổi ca, đi trễ...)" style="border-top-left-radius: 0; border-bottom-left-radius: 0;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
                
                container.innerHTML += dayCardHtml;
                loopDate.setDate(loopDate.getDate() + 1);
            }
            
            gridCard.style.display = "block";
            
            // Scroll to grid smooth
            gridCard.scrollIntoView({ behavior: 'smooth' });
        }
        
        function quickSelectAll(type) {
            var checkboxes = document.querySelectorAll('#schedulesGridContainer input[type="checkbox"]');
            checkboxes.forEach(function(cb) {
                if (type === 'ALL') {
                    cb.checked = true;
                } else if (type === 'NONE') {
                    cb.checked = false;
                } else {
                    if (cb.id.endsWith('_' + type)) {
                        cb.checked = true;
                    }
                }
            });
        }

        function validateForm() {
            var startDateVal = document.getElementById("startDate").value;
            var endDateVal = document.getElementById("endDate").value;
            var errorDiv = document.getElementById("dateValidationError");
            
            errorDiv.style.display = "none";
            
            if (!startDateVal || !endDateVal) {
                errorDiv.innerText = "Vui lòng nhập khoảng ngày đăng ký.";
                errorDiv.style.display = "block";
                return false;
            }
            
            var start = new Date(startDateVal);
            var end = new Date(endDateVal);
            
            if (end < start) {
                errorDiv.innerText = "Ngày kết thúc không thể trước ngày bắt đầu.";
                errorDiv.style.display = "block";
                return false;
            }
            
            // Ensure at least one checkbox is checked
            var checkedCount = document.querySelectorAll('#schedulesGridContainer input[type="checkbox"]:checked').length;
            if (checkedCount === 0) {
                alert("Vui lòng chọn ít nhất một ca làm việc để gửi đăng ký.");
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>
