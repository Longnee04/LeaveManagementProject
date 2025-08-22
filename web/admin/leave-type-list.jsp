<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Type Management - Admin</title>

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

    <style>
        .filter-search-section { background: #ffffff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border: 1px solid #e2e8f0; padding: 16px; margin-bottom: 16px; }
        .filter-search-section .form-label { font-size: 13px; color: #64748b; margin-bottom: 6px; }
        .filter-search-section .form-select, .filter-search-section .form-control { border: 1.5px solid #e2e8f0; }
        .filter-search-section .form-control:focus, .filter-search-section .form-select:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
        .results-footer { gap: 12px; }
        .results-footer .pagination { margin-bottom: 0; }
    </style>
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
                        <h1 class="h3 mb-0">Leave Type Management</h1>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="${pageContext.request.contextPath}/admin/leave-types?action=add" 
                           class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add New Leave Type
                        </a>
                    </div>
                </div>

                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <c:choose>
                            <c:when test="${param.success == 'added'}">Leave type added successfully!</c:when>
                            <c:when test="${param.success == 'updated'}">Leave type updated successfully!</c:when>
                            <c:when test="${param.success == 'deleted'}">Leave type deleted successfully!</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <c:choose>
                            <c:when test="${param.error == 'notfound'}">Leave type not found!</c:when>
                            <c:when test="${param.error == 'deletefailed'}">Failed to delete leave type!</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="card border-0 shadow-sm">
                    <div class="card-header d-flex align-items-center justify-content-between">
                        <h5 class="card-title mb-0">Leave Types</h5>
                    </div>
                    <div class="card-body">
                        <div class="filter-search-section">
                            <div class="row g-2 align-items-end">
                                <div class="col-md-5">
                                    <label for="searchInput" class="form-label">Search</label>
                                    <div class="position-relative">
                                        <input id="searchInput" type="text" class="form-control" placeholder="Search name or description...">
                                        <i class="fa fa-search position-absolute top-50 end-0 translate-middle-y me-3 text-muted"></i>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label for="statusFilter" class="form-label">Status</label>
                                    <select id="statusFilter" class="form-select">
                                        <option value="all">All</option>
                                        <option value="active">Active</option>
                                        <option value="inactive">Inactive</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label for="pageSize" class="form-label">Per page</label>
                                    <select id="pageSize" class="form-select">
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="20">20</option>
                                        <option value="50">50</option>
                                    </select>
                                </div>
                                <div class="col-md-2 text-md-end small text-muted" id="resultsInfo"></div>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                <tr>
                                    <th class="text-muted">ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th style="width: 180px;" class="text-nowrap">Created At</th>
                                    <th style="width: 180px;" class="text-nowrap">Last Updated</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                                </thead>
                                <tbody id="leaveTypeTableBody">
                                <c:forEach items="${leaveTypes}" var="leaveType">
                                    <tr data-status="${leaveType.isActive ? 'active' : 'inactive'}">
                                        <td class="text-muted">${leaveType.leaveTypeId}</td>
                                        <td class="fw-semibold">${leaveType.leaveTypeName}</td>
                                        <td>${leaveType.description}</td>
                                        <td>
                                            <span class="badge ${leaveType.isActive ? 'bg-success' : 'bg-secondary'}">
                                                ${leaveType.isActive ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td class="text-nowrap small">
                                            <fmt:formatDate value="${leaveType.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                                        </td>
                                        <td class="text-nowrap small">
                                            <fmt:formatDate value="${leaveType.lastUpdated}" pattern="HH:mm dd/MM/yyyy"/>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/leave-types?action=edit&id=${leaveType.leaveTypeId}" 
                                               class="btn btn-sm btn-warning">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button type="button" class="btn btn-sm btn-danger" 
                                                    data-id="${leaveType.leaveTypeId}"
                                                    onclick="confirmDeleteFromButton(this)">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-flex justify-content-between align-items-center results-footer mt-2">
                            <div id="resultsInfoBottom" class="text-muted small"></div>
                            <nav>
                                <ul class="pagination pagination-sm" id="pagination"></ul>
                            </nav>
                        </div>
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

        // Search/Filter/Pagination
        const tbody = document.getElementById('leaveTypeTableBody');
        const allRows = Array.from(tbody.querySelectorAll('tr'));
        const searchInput = document.getElementById('searchInput');
        const statusFilter = document.getElementById('statusFilter');
        const pageSizeSelect = document.getElementById('pageSize');
        const pagination = document.getElementById('pagination');
        const resultsTop = document.getElementById('resultsInfo');
        const resultsBottom = document.getElementById('resultsInfoBottom');
        let currentPage = 1;

        function getFilteredRows() {
            const term = (searchInput.value || '').trim().toLowerCase();
            const status = statusFilter.value;
            return allRows.filter(row => {
                const matchesStatus = status === 'all' || row.dataset.status === status;
                const matchesSearch = term === '' || row.textContent.toLowerCase().includes(term);
                return matchesStatus && matchesSearch;
            });
        }

        function renderPagination(totalPages, current) {
            pagination.innerHTML = '';
            const addItem = (label, page, disabled, active) => {
                const li = document.createElement('li');
                li.className = 'page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '');
                const a = document.createElement('a');
                a.className = 'page-link';
                a.href = '#';
                a.textContent = label;
                a.addEventListener('click', (e) => {
                    e.preventDefault();
                    if (disabled || active) return;
                    currentPage = page;
                    applyFilters(false);
                });
                li.appendChild(a);
                pagination.appendChild(li);
            };
            addItem('«', Math.max(1, current - 1), current === 1, false);
            for (let p = 1; p <= totalPages; p++) {
                addItem(String(p), p, false, p === current);
            }
            addItem('»', Math.min(totalPages, current + 1), current === totalPages, false);
        }

        function updateResultsInfo(total, from, to) {
            const text = total === 0 ? 'No results' : `Showing ${from}-${to} of ${total}`;
            resultsTop.textContent = text;
            resultsBottom.textContent = text;
        }

        function applyFilters(resetPage = true) {
            const pageSize = parseInt(pageSizeSelect.value, 10) || 10;
            const filtered = getFilteredRows();
            if (resetPage) currentPage = 1;
            const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
            if (currentPage > totalPages) currentPage = totalPages;

            // Hide all, then show the current page slice
            allRows.forEach(r => r.style.display = 'none');
            const start = (currentPage - 1) * pageSize;
            const slice = filtered.slice(start, start + pageSize);
            slice.forEach(r => r.style.display = '');

            renderPagination(totalPages, currentPage);
            updateResultsInfo(filtered.length, filtered.length === 0 ? 0 : start + 1, start + slice.length);
        }

        searchInput.addEventListener('input', () => applyFilters());
        statusFilter.addEventListener('change', () => applyFilters());
        pageSizeSelect.addEventListener('change', () => applyFilters());

        applyFilters();
    });

    function confirmDeleteFromButton(buttonEl) {
        const id = buttonEl.getAttribute('data-id');
        const row = buttonEl.closest('tr');
        const nameCell = row ? row.querySelector('td:nth-child(2)') : null;
        const name = nameCell ? nameCell.textContent.trim() : '';
        document.getElementById('deleteLeaveTypeName').textContent = name;
        document.getElementById('confirmDeleteBtn').href = 
            '${pageContext.request.contextPath}/admin/leave-types?action=delete&id=' + id;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }
</script>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete <strong id="deleteLeaveTypeName"></strong>?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
