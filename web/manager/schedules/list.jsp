<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.WorkSchedule"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    List<WorkSchedule> pending = (List<WorkSchedule>) request.getAttribute("pendingSchedules");
    List<WorkSchedule> approved = (List<WorkSchedule>) request.getAttribute("approvedSchedules");
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt Lịch làm việc - HRM System</title>
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
                    <h1 class="page-title">Duyệt Đăng ký Lịch làm việc</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Duyệt lịch làm</li>
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

            <!-- Navigation Tabs -->
            <ul class="nav nav-tabs mb-4" id="scheduleTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending-content" type="button" role="tab" aria-controls="pending-content" aria-selected="true">
                        <i class="fa-solid fa-clock-rotate-left me-1"></i> Chờ phê duyệt 
                        <span class="badge bg-warning text-dark ms-1"><%= pending != null ? pending.size() : 0 %></span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="approved-tab" data-bs-toggle="tab" data-bs-target="#approved-content" type="button" role="tab" aria-controls="approved-content" aria-selected="false">
                        <i class="fa-solid fa-calendar-check me-1"></i> Đã phê duyệt
                        <span class="badge bg-success ms-1"><%= approved != null ? approved.size() : 0 %></span>
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="scheduleTabsContent">
                <!-- PENDING SCHEDULES TAB -->
                <div class="tab-pane fade show active" id="pending-content" role="tabpanel" aria-labelledby="pending-tab">
                    <div class="form-card">
                        <div class="table-responsive">
                            <% if (pending == null || pending.isEmpty()) { %>
                                <div class="empty-state-custom">
                                    <i class="fa-solid fa-circle-check text-success" style="font-size: 3rem;"></i>
                                    <p class="mt-3">Tuyệt vời! Không có lịch làm việc nào đang chờ duyệt.</p>
                                </div>
                            <% } else { %>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Nhân viên</th>
                                            <th>Ngày làm việc</th>
                                            <th>Ca làm</th>
                                            <th>Ghi chú đăng ký</th>
                                            <th class="text-end">Phê duyệt</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (WorkSchedule ws : pending) { %>
                                            <tr>
                                                <td>
                                                    <div style="font-weight: 600;"><%= ws.getEmployeeName() %></div>
                                                    <div style="font-size: 0.75rem; color: var(--text-secondary);">ID: #<%= ws.getUserID() %></div>
                                                </td>
                                                <td style="font-weight: 600;"><%= df.format(ws.getWorkDate()) %></td>
                                                <td>
                                                    <%
                                                        String shiftClass = "bg-primary";
                                                        String shiftVal = ws.getShift();
                                                        if ("Afternoon".equalsIgnoreCase(shiftVal)) shiftClass = "bg-success";
                                                        else if ("Evening".equalsIgnoreCase(shiftVal)) shiftClass = "bg-dark";
                                                    %>
                                                    <span class="badge <%= shiftClass %>" style="padding: 5px 12px; border-radius: 12px;">
                                                        <%= shiftVal %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <%= ws.getNote() != null && !ws.getNote().isEmpty() ? ws.getNote() : "<span class='text-muted'>Không có</span>" %>
                                                </td>
                                                <td class="text-end">
                                                    <form method="post" action="${pageContext.request.contextPath}/manager/schedules" style="display:inline-block;">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="id" value="<%= ws.getScheduleID() %>">
                                                        <button type="submit" class="btn-custom btn-success-custom btn-sm-custom">
                                                            <i class="fa-solid fa-check"></i> Duyệt
                                                        </button>
                                                    </form>
                                                    <button type="button" class="btn-custom btn-danger-custom btn-sm-custom ms-1" 
                                                            onclick="openRejectModal(<%= ws.getScheduleID() %>, '<%= ws.getEmployeeName() %>')">
                                                        <i class="fa-solid fa-xmark"></i> Từ chối
                                                    </button>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- APPROVED SCHEDULES TAB -->
                <div class="tab-pane fade" id="approved-content" role="tabpanel" aria-labelledby="approved-tab">
                    <div class="form-card">
                        <div class="table-responsive">
                            <% if (approved == null || approved.isEmpty()) { %>
                                <div class="empty-state-custom">
                                    <i class="fa-solid fa-folder-open"></i>
                                    <p>Không tìm thấy lịch sử duyệt ca làm nào.</p>
                                </div>
                            <% } else { %>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Nhân viên</th>
                                            <th>Ngày làm việc</th>
                                            <th>Ca làm</th>
                                            <th>Trạng thái</th>
                                            <th>Chi tiết ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (WorkSchedule ws : approved) { %>
                                            <tr>
                                                <td>
                                                    <div style="font-weight: 600;"><%= ws.getEmployeeName() %></div>
                                                </td>
                                                <td style="font-weight: 600;"><%= df.format(ws.getWorkDate()) %></td>
                                                <td>
                                                    <%
                                                        String shiftClass = "bg-primary";
                                                        String shiftVal = ws.getShift();
                                                        if ("Afternoon".equalsIgnoreCase(shiftVal)) shiftClass = "bg-success";
                                                        else if ("Evening".equalsIgnoreCase(shiftVal)) shiftClass = "bg-dark";
                                                    %>
                                                    <span class="badge <%= shiftClass %>" style="padding: 5px 12px; border-radius: 12px;">
                                                        <%= shiftVal %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="status-badge approved">Đã duyệt</span>
                                                </td>
                                                <td style="font-size: 0.9rem;">
                                                    <%= ws.getNote() != null && !ws.getNote().isEmpty() ? ws.getNote() : "<span class='text-muted'>Không có</span>" %>
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

    <!-- REJECT MODAL -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form method="post" action="${pageContext.request.contextPath}/manager/schedules">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="id" id="rejectScheduleId">
                
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="rejectModalLabel" style="font-weight: 700;">Từ chối Đăng ký ca làm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Từ chối yêu cầu đăng ký ca của nhân viên: <strong id="rejectEmployeeName" class="text-primary"></strong></p>
                        
                        <div class="form-group-custom">
                            <label for="rejectNote" class="form-label-custom">Lý do từ chối <span class="text-danger">*</span></label>
                            <textarea id="rejectNote" name="rejectNote" class="form-control-custom form-control" style="height: 100px; resize: vertical;" required placeholder="Nhập lý do hoặc phản hồi cho nhân viên..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-custom btn-secondary-custom" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn-custom btn-danger-custom">Xác nhận Từ chối</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS Bundle and Modal Script -->
    <script>
        var rejectModal;
        document.addEventListener("DOMContentLoaded", function() {
            rejectModal = new bootstrap.Modal(document.getElementById('rejectModal'));
        });

        function openRejectModal(id, name) {
            document.getElementById("rejectScheduleId").value = id;
            document.getElementById("rejectEmployeeName").innerText = name;
            document.getElementById("rejectNote").value = "";
            rejectModal.show();
        }
    </script>
</body>
</html>
