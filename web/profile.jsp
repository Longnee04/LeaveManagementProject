<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    User user = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
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

        .info-group {
            margin-bottom: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 1rem;
        }

        .info-label {
            color: var(--secondary);
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .info-value {
            color: var(--dark);
            font-size: 1rem;
            font-weight: 500;
        }

        .nav-link {
            color: var(--dark);
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            color: var(--primary);
        }

        .nav-link.active {
            color: var(--primary);
            font-weight: 600;
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
                        <a class="nav-link active" href="profile">
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
            <img src="https://ui-avatars.com/api/?name=<%= user.getFullName() %>&background=random" 
                 alt="Profile" class="profile-avatar">
            <h2 class="mb-2"><%= user.getFullName() %></h2>
            <p class="mb-0"><%= user.getRole() %> - <%= user.getDepartment() %></p>
        </div>

        <!-- Profile Information -->
        <div class="info-card">
            <h3 class="mb-4">Personal Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="info-group">
                        <div class="info-label">Full Name</div>
                        <div class="info-value"><%= user.getFullName() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Username</div>
                        <div class="info-value"><%= user.getUsername() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Email</div>
                        <div class="info-value"><%= user.getEmail() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Phone</div>
                        <div class="info-value"><%= user.getPhone() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Gender</div>
                        <div class="info-value"><%= user.getGender() %></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-group">
                        <div class="info-label">Department</div>
                        <div class="info-value"><%= user.getDepartment() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Role</div>
                        <div class="info-value"><%= user.getRole() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Date of Birth</div>
                        <div class="info-value"><%= user.getDob() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Address</div>
                        <div class="info-value"><%= user.getAddress() %></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Joined Date</div>
                        <div class="info-value"><%= user.getCreatedAt() %></div>
                    </div>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="employee_dashboard.jsp" class="btn btn-back">
                    <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
