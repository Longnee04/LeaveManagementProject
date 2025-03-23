<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    // Kiểm tra session
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Lấy thông tin user
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("profile");
        return;
    }
    
    // Lấy thông báo nếu có
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
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
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                outline: none;
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

            .btn-update {
                background: var(--primary);
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-update:hover {
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

            <!-- Messages -->
            <% if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
            <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <!-- Update Form -->
            <div class="info-card">
                <h3 class="mb-4">Update Profile Information</h3>
                <form action="updateProfile" method="post" class="needs-validation" novalidate>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="fullName" 
                                       value="<%= user.getFullName() %>" required>
                                <div class="invalid-feedback">Please enter your full name.</div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" 
                                       value="<%= user.getEmail() %>" required>
                                <div class="invalid-feedback">Please enter a valid email.</div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" name="phone" 
                                       value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Gender</label>
                                <select class="form-control" name="gender">
                                    <option value="Male" <%= "Male".equals(user.getGender()) ? "selected" : "" %>>Male</option>
                                    <option value="Female" <%= "Female".equals(user.getGender()) ? "selected" : "" %>>Female</option>
                                    <option value="Other" <%= "Other".equals(user.getGender()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" name="dob" 
                                       value="<%= user.getDob() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getDob()) : "" %>">
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <textarea class="form-control" name="address" rows="4"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="department" class="form-label">Department</label>
                        <select class="form-control" id="department" name="department" required>
                            <option value="HR" <%= user.getDepartment().equals("HR") ? "selected" : "" %>>HR</option>
                            <option value="IT" <%= user.getDepartment().equals("IT") ? "selected" : "" %>>IT</option>
                            <option value="Finance" <%= user.getDepartment().equals("Finance") ? "selected" : "" %>>Finance</option>
                            <option value="Marketing" <%= user.getDepartment().equals("Marketing") ? "selected" : "" %>>Marketing</option>
                        </select>
                    </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <a href="profile" class="btn btn-back me-2">
                <i class="bi bi-arrow-left me-2"></i>Back to Profile
            </a>
            <button type="submit" class="btn btn-update">
                <i class="bi bi-check2-circle me-2"></i>Update Profile
            </button>
        </div>
    </form>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Form validation
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()
</script>
</body>
</html>
