<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Agenda"%>
<%@page import="models.User"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    List<Agenda> list = (List<Agenda>) request.getAttribute("agendas");
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch họp & Sự kiện - HRM System</title>
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
                    <h1 class="page-title">Lịch họp & Sự kiện công ty</h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / Lịch họp & Sự kiện</li>
                    </ul>
                </div>
                <% if ("Admin".equals(loggedUser.getRoleName()) || "Manager".equals(loggedUser.getRoleName())) { %>
                    <a href="${pageContext.request.contextPath}/agenda/add" class="btn-custom btn-primary-custom">
                        <i class="fa-solid fa-calendar-plus"></i> Tạo cuộc họp/sự kiện
                    </a>
                <% } %>
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

            <!-- Table Card -->
            <div class="form-card">
                <div class="table-responsive">
                    <% if (list == null || list.isEmpty()) { %>
                        <div class="empty-state-custom">
                            <i class="fa-solid fa-calendar-xmark"></i>
                            <p>Không có cuộc họp hoặc sự kiện nào sắp diễn ra.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Chủ đề cuộc họp / Sự kiện</th>
                                    <th>Thời gian bắt đầu</th>
                                    <th>Thời gian kết thúc</th>
                                    <th>Mô tả chi tiết</th>
                                    <th>Người tạo</th>
                                    <% if ("Admin".equals(loggedUser.getRoleName()) || "Manager".equals(loggedUser.getRoleName())) { %>
                                        <th class="text-end">Thao tác</th>
                                    <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Agenda a : list) { %>
                                    <tr>
                                        <td>
                                            <div style="font-weight: 600; color: #1e3a8a;"><%= a.getTitle() %></div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500;"><i class="fa-regular fa-clock text-primary me-1"></i><%= df.format(a.getStartTime()) %></div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500;"><i class="fa-regular fa-clock text-secondary me-1"></i><%= df.format(a.getEndTime()) %></div>
                                        </td>
                                        <td style="max-width: 300px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                            <%= a.getDescription() != null && !a.getDescription().isEmpty() ? a.getDescription() : "<span class='text-muted'>Không có mô tả</span>" %>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border"><%= a.getCreatorName() %></span>
                                        </td>
                                        <% if ("Admin".equals(loggedUser.getRoleName()) || "Manager".equals(loggedUser.getRoleName())) { %>
                                            <td class="text-end">
                                                <% if (a.getCreatedBy() == loggedUser.getUserID() || "Admin".equals(loggedUser.getRoleName())) { %>
                                                    <a href="${pageContext.request.contextPath}/agenda/edit?id=<%= a.getAgendaID() %>" 
                                                       class="btn-custom btn-outline-custom btn-sm-custom py-1 px-2" title="Chỉnh sửa">
                                                        <i class="fa-solid fa-pen-to-square"></i> Sửa
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/agenda/delete?id=<%= a.getAgendaID() %>" 
                                                       class="btn-custom btn-danger-custom btn-sm-custom py-1 px-2 ms-1" 
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa sự kiện này không?')" title="Xóa">
                                                        <i class="fa-solid fa-trash"></i> Xóa
                                                    </a>
                                                <% } else { %>
                                                    <span class="text-muted" style="font-size: 0.85rem;"><i class="fa-solid fa-lock me-1"></i>Xem</span>
                                                <% } %>
                                            </td>
                                        <% } %>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>
</body>
</html>
