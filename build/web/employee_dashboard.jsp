<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"Employee".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Dashboard | Leave Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="CSS/Edashboard.css">
    </head>
    <body>
        <div class="wrapper">
            <!-- Enhanced Sidebar -->
            <nav class="sidebar">
                <div class="sidebar-header">
                    <img src="https://ui-avatars.com/api/?name=<%= username %>&background=random" alt="Profile">
                    <h4 class="mb-1">Employee Portal</h4>
                    <p class="mb-0 opacity-75">Welcome, <%= username %></p>
                </div>
                <ul class="list-unstyled mt-4">
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
                    <li>
                        <a href="#leaveSubmenu" data-bs-toggle="collapse">
                            <i class="bi bi-calendar2-check"></i>
                            Leave Management
                        </a>
                        <ul class="collapse list-unstyled submenu" id="leaveSubmenu">
                            <li><a href="createLeaveRequest" >
                                    <i class="bi bi-plus-circle"></i>New Leave Request
                                </a></li>
                                <li><a href="LeaveHistoryServlet">
                                    <i class="bi bi-clock-history"></i>Leave History
                                </a></li>
                        </ul>
                    </li>
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
                    <h2>Welcome to Employee Portal</h2>
                    <p>Please select an option from the menu to get started.</p>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
    </body>
</html>
