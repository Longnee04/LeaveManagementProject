<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    String fullName = (String) session.getAttribute("fullName");

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
                    <li>
                        <a href="view_leave_requests.jsp">
                            <i class="bi bi-calendar2-check"></i>
                            View Leave Requests
                        </a>
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
                    <h2>Welcome to Manager Portal</h2>
                    <p>Please select an option from the menu to get started.</p>
                </div>
                <div class="row">
                    <!-- Total Employees -->
                    <div class="col-md-4">
                        <div class="content-card">
                            <h3>Total Employees</h3>
                            <p>Manage your team effectively.</p>
                        </div>
                    </div>
                    <!-- Total Leave Requests -->
                    <div class="col-md-4">
                        <div class="content-card">
                            <h3>Total Leave Requests</h3>
                            <p>View and manage leave requests.</p>
                        </div>
                    </div>
                    <!-- Pending Requests -->
                    <div class="col-md-4">
                        <div class="content-card">
                            <h3>Pending Requests</h3>
                            <p>Review pending leave requests.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>