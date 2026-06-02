<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.LeaveRequest"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leaveRequest");
    SimpleDateFormat dateFmt = new SimpleDateFormat("dd/MM/yyyy");
    if (lr == null) { 
        response.sendRedirect(request.getContextPath() + "/manager/leave-requests"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xét duyệt đơn nghỉ phép #<%= lr.getRequestID() %> - HRM System</title>
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
                    <h1 class="page-title">Xét duyệt Đơn nghỉ phép #<%= lr.getRequestID() %></h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/manager/leave-requests"> / Duyệt đơn nghỉ</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Xét duyệt</li>
                    </ul>
                </div>
                <a href="${pageContext.request.contextPath}/manager/leave-requests" class="btn-custom btn-secondary-custom">
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

            <div class="row justify-content-center">
                <div class="col-12 col-lg-8">
                    <!-- Detail Card -->
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary); border-bottom: 2px solid var(--border-color); padding-bottom: 10px;">
                            <i class="fa-solid fa-receipt text-primary me-2"></i> Phiếu thông tin đơn đề nghị
                        </h4>
                        
                        <div class="row g-4 mb-4">
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Nhân viên đề xuất</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= lr.getEmployeeName() %></span>
                                <span class="d-block text-muted" style="font-size: 0.8rem;"><%= lr.getEmployeeEmail() %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Phòng ban</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= lr.getDepartmentName() != null ? lr.getDepartmentName() : "-" %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Loại nghỉ phép</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><%= lr.getLeaveTypeName() %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Số ngày đăng ký nghỉ</label>
                                <span class="badge bg-primary" style="font-size: 0.85rem; padding: 6px 12px; border-radius: 12px; font-weight: 600;">
                                    <%= lr.getTotalDays() %> ngày
                                </span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Thời gian bắt đầu</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><i class="fa-regular fa-calendar text-primary me-1"></i><%= dateFmt.format(lr.getStartDate()) %></span>
                            </div>
                            
                            <div class="col-12 col-sm-6">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Thời gian kết thúc</label>
                                <span class="d-block font-weight-bold" style="font-size: 1rem; font-weight: 600;"><i class="fa-regular fa-calendar text-danger me-1"></i><%= dateFmt.format(lr.getEndDate()) %></span>
                            </div>
                            
                            <div class="col-12">
                                <label class="d-block text-secondary mb-1" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase;">Lý do của nhân viên</label>
                                <div class="p-3 bg-light" style="border-radius: 8px; font-size: 0.95rem; border: 1px solid var(--border-color);">
                                    <%= lr.getReason() != null && !lr.getReason().isBlank() ? lr.getReason() : "<span class='text-muted'>(Không có lý do chi tiết)</span>" %>
                                </div>
                            </div>
                        </div>

                        <!-- Review Action Form -->
                        <h4 class="mb-4 mt-5" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary); border-top: 2px solid var(--border-color); padding-top: 20px;">
                            <i class="fa-solid fa-square-poll-horizontal text-primary me-2"></i> Ý kiến & Quyết định phê duyệt
                        </h4>

                        <form method="post" action="${pageContext.request.contextPath}/manager/leave-requests/review" id="reviewForm" onsubmit="return validateForm()">
                            <input type="hidden" name="requestId" value="<%= lr.getRequestID() %>">
                            
                            <!-- Comment Textarea -->
                            <div class="form-group-custom">
                                <label for="managerComment" class="form-label-custom">Ý kiến đóng góp / Lý do từ chối <span class="text-danger" id="commentRequiredStar" style="display:none;">*</span></label>
                                <textarea id="managerComment" name="managerComment" class="form-control-custom form-control" 
                                          style="height: 120px; resize: vertical;" maxlength="500" 
                                          placeholder="Nhập ý kiến duyệt hoặc lý do từ chối (bắt buộc nhập nếu Từ chối)..."></textarea>
                                <div class="invalid-feedback">Vui lòng điền lý do từ chối đơn nghỉ phép.</div>
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Buttons -->
                            <div class="d-flex gap-3 justify-content-end">
                                <a href="${pageContext.request.contextPath}/manager/leave-requests" class="btn-custom btn-secondary-custom">
                                    Quay lại
                                </a>
                                <button type="submit" name="decision" value="reject" class="btn-custom btn-danger-custom" onclick="setDecision('reject')">
                                    <i class="fa-solid fa-xmark"></i> Từ chối (Reject)
                                </button>
                                <button type="submit" name="decision" value="approve" class="btn-custom btn-success-custom" onclick="setDecision('approve')">
                                    <i class="fa-solid fa-check"></i> Phê duyệt (Approve)
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
        var currentDecision = "";

        function setDecision(decision) {
            currentDecision = decision;
            var star = document.getElementById("commentRequiredStar");
            if (decision === 'reject') {
                star.style.display = 'inline';
            } else {
                star.style.display = 'none';
            }
        }

        function validateForm() {
            var comment = document.getElementById("managerComment").value.trim();
            document.getElementById("managerComment").classList.remove("is-invalid");
            
            if (currentDecision === 'reject' && !comment) {
                document.getElementById("managerComment").classList.add("is-invalid");
                alert("Vui lòng nhập lý do từ chối đơn nghỉ phép của nhân viên.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
