<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Leave Type - Admin</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Feather Icons -->
    <script src="https://unpkg.com/feather-icons"></script>

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/admin/css/light.css" rel="stylesheet">
</head>
<body>
<div class="wrapper">
    <jsp:include page="/admin/AdminSidebar.jsp" />
    <div class="main">
        <jsp:include page="/admin/navbar.jsp" />

        <main class="content">
            <div class="container-fluid p-0">
                <div class="row mb-2">
                    <div class="col-md-6">
                        <h1 class="h3 mb-0">Edit Leave Type</h1>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="${pageContext.request.contextPath}/admin/leave-types" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="card border-0 shadow-sm">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Update Leave Type Details</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/leave-types" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="leaveTypeId" value="${leaveType.leaveTypeId}">

                            <div class="mb-3">
                                <label for="leaveTypeName" class="form-label">Leave Type Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="leaveTypeName" name="leaveTypeName"
                                       value="${leaveType.leaveTypeName}" required maxlength="100"
                                       placeholder="e.g., Annual Leave, Sick Leave">
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description"
                                          rows="3" maxlength="500"
                                          placeholder="Describe the leave type...">${leaveType.description}</textarea>
                            </div>

                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="isActive"
                                           value="true" ${leaveType.isActive ? 'checked' : ''}>
                                    <label class="form-check-label" for="isActive">
                                        Active
                                    </label>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Created At</label>
                                    <input type="text" class="form-control form-control-sm text-nowrap"
                                           value="<fmt:formatDate value='${leaveType.createdAt}' pattern='HH:mm dd/MM/yyyy'/>" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Last Updated</label>
                                    <input type="text" class="form-control form-control-sm text-nowrap"
                                           value="<fmt:formatDate value='${leaveType.lastUpdated}' pattern='HH:mm dd/MM/yyyy'/>" readonly>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Update Leave Type
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/leave-types" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <footer class="footer">
            <div class="container-fluid">
                <div class="row text-muted">
                    <div class="col-6 text-start">
                        <p class="mb-0">
                            <a href="#" class="text-muted"><strong>Warehouse Management System</strong></a> &copy;
                        </p>
                    </div>
                    <div class="col-6 text-end">
                        <ul class="list-inline">
                            <li class="list-inline-item">
                                <a class="text-muted" href="#">Support</a>
                            </li>
                            <li class="list-inline-item">
                                <a class="text-muted" href="#">Help Center</a>
                            </li>
                            <li class="list-inline-item">
                                <a class="text-muted" href="#">Privacy</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();

        // Sidebar dropdown toggle behavior
        document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(element) {
            element.addEventListener('click', function(e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('data-bs-target'));
                const arrow = this.querySelector('.sidebar-arrow');
                if (target) {
                    if (target.classList.contains('show')) {
                        target.classList.remove('show');
                        if (arrow) arrow.style.transform = 'rotate(0deg)';
                    } else {
                        document.querySelectorAll('.sidebar-dropdown.show').forEach(function(dropdown) {
                            if (dropdown !== target) {
                                dropdown.classList.remove('show');
                                const otherArrow = document.querySelector(`[data-bs-target="#${dropdown.id}"] .sidebar-arrow`);
                                if (otherArrow) otherArrow.style.transform = 'rotate(0deg)';
                            }
                        });
                        target.classList.add('show');
                        if (arrow) arrow.style.transform = 'rotate(90deg)';
                    }
                }
            });
        });

        // Mobile sidebar toggle
        window.toggleSidebar = function() {
            document.getElementById('sidebar').classList.toggle('sidebar-mobile-show');
        };
    });
</script>
</body>
</html>
