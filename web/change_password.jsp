<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Change Password</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <style>
            :root {
                --primary: #2563eb;
                --primary-dark: #1d4ed8;
                --secondary: #64748b;
                --light: #f8fafc;
                --dark: #1e293b;
            }

            body {
                background-color: #f1f5f9;
                font-family: 'Inter', sans-serif;
            }

            .profile-container {
                max-width: 900px;
                margin: 2rem auto;
            }

            .profile-header {
                background: linear-gradient(to right, var(--primary), var(--primary-dark));
                color: white;
                padding: 2rem;
                border-radius: 15px;
                margin-bottom: 2rem;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                border: 4px solid rgba(255, 255, 255, 0.3);
                padding: 3px;
                margin-bottom: 1rem;
            }

            .info-card {
                background: white;
                border-radius: 15px;
                padding: 2rem;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .form-label {
                color: var(--secondary);
                font-size: 0.9rem;
                font-weight: 500;
                margin-bottom: 0.5rem;
            }

            .form-control {
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                padding: 0.75rem 1rem;
            }

            .form-control:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.1);
            }

            .btn-back {
                background: var(--primary);
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .btn-back:hover {
                background: var(--primary-dark);
                transform: translateY(-1px);
                color: white;
            }
            .input-group .btn-outline-secondary {
                border-color: #e2e8f0;
                color: var(--secondary);
            }

            .input-group .btn-outline-secondary:hover {
                background-color: #f8fafc;
                color: var(--primary);
                border-color: var(--primary);
            }

            .input-group .form-control {
                border-right: none;
            }

            .input-group .btn {
                border-left: none;
                padding: 0.75rem 1rem;
            }

            .input-group .form-control:focus + .btn {
                border-color: var(--primary);
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark" style="background: var(--primary)">
            <div class="container">
                <a class="navbar-brand" href="#">Employee Dashboard</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="employee_dashboard.jsp">
                                <i class="bi bi-house-door"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="profile">
                                <i class="bi bi-person"></i> My Profile
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="profile-container">
            <!-- Profile Header -->
            <div class="profile-header text-center">
                <img src="https://ui-avatars.com/api/?name=<%= username %>&background=random" 
                     alt="Profile" class="profile-avatar">
                <h2 class="mb-2">Change Password</h2>
                <p class="mb-0">Update your password to keep your account secure</p>
            </div>

            <!-- Change Password Form -->
            <div class="info-card">
                <form action="changePassword" method="post">
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('currentPassword')">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-12 mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('newPassword')">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-12 mb-3">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword')">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-4">
                        <a href="profile" class="btn btn-back me-2">
                            <i class="bi bi-arrow-left"></i> Back to Profile
                        </a>
                        <button type="submit" class="btn btn-back">
                            <i class="bi bi-check-circle"></i> Change Password
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function togglePassword(inputId) {
                const input = document.getElementById(inputId);
                const icon = input.nextElementSibling.querySelector('i');

                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.replace('bi-eye', 'bi-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.replace('bi-eye-slash', 'bi-eye');
                }
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <div class="container mt-3">
            <% 
                String successMessage = (String) request.getAttribute("successMessage");
                String errorMessage = (String) request.getAttribute("errorMessage");
            %>
            <% if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
            <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
        </div>
    </body>
</html>
