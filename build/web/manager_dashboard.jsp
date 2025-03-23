<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    String fullName = (String) session.getAttribute("fullName"); // Tên ??y ?? c?a manager

    if (username == null || !"Manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manager Dashboard | Leave Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="CSS/Edashboard.css">
    </head>
    <body>
        <div class="wrapper">
            <!-- Sidebar -->
            <nav class="sidebar">
                <div class="sidebar-header">
                    <img src="https://ui-avatars.com/api/?name=<%= username %>&background=random" alt="Profile">
                    <h4 class="mb-1">Manager Portal</h4>
                    <p class="mb-0 opacity-75">Welcome, <%= fullName != null ? fullName : "Manager" %></p>
                </div>
                <ul class="list-unstyled mt-4">
                    <!-- Dashboard -->
                    <li>
                        <a href="#dashboardSubmenu" data-bs-toggle="collapse">
                            <i class="bi bi-speedometer2"></i>
                            Dashboard
                        </a>
                        <ul class="collapse list-unstyled submenu" id="dashboardSubmenu">
                            <li><a href="manager_dashboard.jsp">
                                    <i class="bi bi-graph-up"></i>Overview
                                </a></li>
                            <li><a href="PendingRequestServlet">
                                    <i class="bi bi-hourglass-split"></i>Pending Requests
                                </a></li>
                        </ul>
                    </li>
                    <!-- My Profile -->
                    <li>
                        <a href="#profileSubmenu" data-bs-toggle="collapse">
                            <i class="bi bi-person-circle"></i>
                            My Profile
                        </a>
                        <ul class="collapse list-unstyled submenu" id="profileSubmenu">
                            <li><a href="profile">
                                    <i class="bi bi-person-vcard"></i>Profile Information
                                </a></li>
                            <li><a href="updateProfile">
                                    <i class="bi bi-pencil-square"></i>Update Profile
                                </a></li>
                            <li><a href="changePassword">
                                    <i class="bi bi-shield-lock"></i>Change Password
                                </a></li>
                        </ul>
                    </li>
                    <!-- Leave Management -->
                    <li>
                        <a href="#leaveSubmenu" data-bs-toggle="collapse">
                            <i class="bi bi-calendar2-check"></i>
                            Leave Management
                        </a>
                        <ul class="collapse list-unstyled submenu" id="leaveSubmenu">
                            <li><a href="createLeaveRequest">
                                    <i class="bi bi-plus-circle"></i>New Leave Request
                                </a></li>
                            <li><a href="LeaveHistoryServlet">
                                    <i class="bi bi-clock-history"></i>Leave History
                                </a></li>
                        </ul>
                    </li>
                    <!-- Employee Management -->
                    <li>
                        <a href="#employeeSubmenu" data-bs-toggle="collapse">
                            <i class="bi bi-people"></i>
                            Employee Management
                        </a>
                        <ul class="collapse list-unstyled submenu" id="employeeSubmenu">
                            <li><a href="addEmployee">
                                    <i class="bi bi-person-plus"></i>Add Employee
                                </a></li>
                            <li><a href="employeeList">
                                    <i class="bi bi-list-task"></i>Employee List
                                </a></li>
                            <li><a href="agenda">
                                    <i class="bi bi-calendar-event"></i>Agenda
                                </a></li>
                        </ul>
                    </li>
                    <!-- Logout -->
                    <li>
                        <a href="LogoutServlet" class="mt-4 text-danger">
                            <i class="bi bi-box-arrow-right"></i>
                            Logout
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Main Content -->
            <div class="main-content" id="mainContent">
                <div class="content-card">
                    <h2>Welcome to Manager Portal</h2>
                    <p>Please select an option from the menu to get started.</p>
                </div>
                <div class="row">
                    <!-- T?ng s? nhân viên -->
                    <div class="col-md-4">
                        <div class="content-card">
                            <h4>Total Employees</h4>
                            <p>Number of employees in your department.</p>
                            <h3>25</h3> <!-- Thay s? này b?ng d? li?u th?c t? -->
                        </div>
                    </div>
                    <!-- T?ng s? ??n ?ang ch? -->
                    <div class="col-md-4">
                        <div class="content-card">
                            <h4>Pending Requests</h4>
                            <p>Number of leave requests waiting for approval.</p>
                            <h3>10</h3> <!-- Thay s? này b?ng d? li?u th?c t? -->
                        </div>
                    </div>
                    <!-- B?ng request ?ang ch? -->
                    <div class="col-md-4">
                        <div class="content-card">
                            <h4>Pending Leave Requests</h4>
                            <p>View and manage pending leave requests.</p>
                            <a href="manager_pending_requests.jsp" class="btn btn-primary">View Requests</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>