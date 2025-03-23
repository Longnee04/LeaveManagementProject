<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"Admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" type="text/css" href="CSS/Adashboard.css">
</head>
<body>
    <div class="wrapper">
        <nav id="sidebar" class="sidebar">
            <div class="sidebar-header">
                <img src="https://images.unsplash.com/photo-1599305445671-ac291c95aaa9" alt="Company Logo" class="logo">
                <h3>HR Management</h3>
            </div>

            <ul class="list-unstyled components">
                <li class="active">
                    <a href="#"><i class="bi bi-speedometer2"></i> Dashboard</a>
                </li>
                <li>
                    <a href="#profileSubmenu" data-bs-toggle="collapse" class="arrow-indicator">
                        <i class="bi bi-person"></i> My Profile
                    </a>
                    <ul class="collapse list-unstyled" id="profileSubmenu">
                        <li><a href="#">Profile Information</a></li>
                        <li><a href="#">Update Profile</a></li>
                        <li><a href="#">Change Password</a></li>
                    </ul>
                </li>
                <li>
                    <a href="#leaveSubmenu" data-bs-toggle="collapse" class="arrow-indicator">
                        <i class="bi bi-calendar-check"></i> Leave Management
                    </a>
                    <ul class="collapse list-unstyled" id="leaveSubmenu">
                        <li><a href="#">Create Leave Request</a></li>
                        <li><a href="#">Pending Requests</a></li>
                        <li><a href="#">Leave History</a></li>
                    </ul>
                </li>
                <li>
                    <a href="#employeeSubmenu" data-bs-toggle="collapse" class="arrow-indicator">
                        <i class="bi bi-people"></i> Employee Management
                    </a>
                    <ul class="collapse list-unstyled" id="employeeSubmenu">
                        <li><a href="#">Add Employee</a></li>
                        <li><a href="#">Employee List</a></li>
                        <li><a href="#">Department Management</a></li>
                    </ul>
                </li>
                <li>
                    <a href="#attendanceSubmenu" data-bs-toggle="collapse" class="arrow-indicator">
                        <i class="bi bi-clock-history"></i> Attendance
                    </a>
                    <ul class="collapse list-unstyled" id="attendanceSubmenu">
                        <li><a href="#">Mark Attendance</a></li>
                        <li><a href="#">Attendance Records</a></li>
                    </ul>
                </li>
                <li>
                    <a href="#leaveTypeSubmenu" data-bs-toggle="collapse" class="arrow-indicator">
                        <i class="bi bi-gear"></i> Leave Types
                    </a>
                    <ul class="collapse list-unstyled" id="leaveTypeSubmenu">
                        <li><a href="#">Create Leave Type</a></li>
                        <li><a href="#">Manage Leave Types</a></li>
                    </ul>
                </li>
                <li>
                    <a href="#" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </li>
            </ul>
        </nav>

        <div id="content" class="flex-grow-1">
            <nav class="navbar navbar-expand-lg">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn">
                        <i class="bi bi-list"></i>
                    </button>
                    
                    <div class="d-flex align-items-center">
                        <div class="search-box me-3">
                            <input type="text" class="form-control" placeholder="Search...">
                        </div>
                        <div class="notifications me-3">
                            <i class="bi bi-bell"></i>
                            <span class="badge">5</span>
                        </div>
                        <div class="profile-section">
                            <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde" alt="Admin Profile" class="rounded-circle">
                        </div>
                    </div>
                </div>
            </nav>

            <div class="container-fluid dashboard-content h-100">
                <div class="welcome-section mb-4">
                    <h2>Welcome, John Admin!</h2>
                    <p>Here's your HR management overview</p>
                </div>

                <div class="row stats-cards g-4">
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="card">
                            <div class="card-body">
                                <h5>Total Employees</h5>
                                <div class="d-flex justify-content-between align-items-center">
                                    <h2>156</h2>
                                    <i class="bi bi-people-fill"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="card">
                            <div class="card-body">
                                <h5>Pending Requests</h5>
                                <div class="d-flex justify-content-between align-items-center">
                                    <h2>23</h2>
                                    <i class="bi bi-hourglass-split"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="card">
                            <div class="card-body">
                                <h5>On Leave Today</h5>
                                <div class="d-flex justify-content-between align-items-center">
                                    <h2>12</h2>
                                    <i class="bi bi-calendar-check"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mb-4 mt-4 leave-requests-card">
                    <div class="card-header d-flex justify-content-between align-items-center bg-white py-3">
                        <h5 class="mb-0 fw-semibold">Pending Leave Requests</h5>
                        <button class="btn btn-primary btn-sm px-3 rounded-pill">View All</button>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 custom-table">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">Employee</th>
                                        <th>Role</th>
                                        <th>Leave Type</th>
                                        <th>Duration</th>
                                        <th>Reason</th>
                                        <th>Status</th>
                                        <th class="pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e" alt="Employee" class="rounded-circle me-3" style="width: 40px; height: 40px; object-fit: cover;">
                                                <div>
                                                    <div class="fw-semibold">John Doe</div>
                                                    <small class="text-muted">ID: EMP001</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="role-badge developer">Software Developer</span></td>
                                        <td><span class="leave-type-badge sick">Sick Leave</span></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-calendar2-week me-2 text-muted"></i>
                                                Jan 15 - Jan 16, 2024
                                            </div>
                                        </td>
                                        <td>Medical Appointment</td>
                                        <td><span class="status-badge pending">Pending</span></td>
                                        <td class="pe-4">
                                            <div class="action-buttons">
                                                <button class="btn btn-soft-success btn-sm me-1" data-bs-toggle="tooltip" title="Approve"><i class="bi bi-check-lg"></i></button>
                                                <button class="btn btn-soft-danger btn-sm me-1" data-bs-toggle="tooltip" title="Reject"><i class="bi bi-x-lg"></i></button>
                                                <button class="btn btn-soft-info btn-sm" data-bs-toggle="tooltip" title="View Details"><i class="bi bi-eye"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330" alt="Employee" class="rounded-circle me-3" style="width: 40px; height: 40px; object-fit: cover;">
                                                <div>
                                                    <div class="fw-semibold">Jane Smith</div>
                                                    <small class="text-muted">ID: EMP002</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="role-badge manager">Project Manager</span></td>
                                        <td><span class="leave-type-badge vacation">Vacation</span></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-calendar2-week me-2 text-muted"></i>
                                                Jan 20 - Jan 25, 2024
                                            </div>
                                        </td>
                                        <td>Annual Leave</td>
                                        <td><span class="status-badge pending">Pending</span></td>
                                        <td class="pe-4">
                                            <div class="action-buttons">
                                                <button class="btn btn-soft-success btn-sm me-1" data-bs-toggle="tooltip" title="Approve"><i class="bi bi-check-lg"></i></button>
                                                <button class="btn btn-soft-danger btn-sm me-1" data-bs-toggle="tooltip" title="Reject"><i class="bi bi-x-lg"></i></button>
                                                <button class="btn btn-soft-info btn-sm" data-bs-toggle="tooltip" title="View Details"><i class="bi bi-eye"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        })

        document.getElementById('sidebarCollapse').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('active');
        });
    </script>
</body>
</html>