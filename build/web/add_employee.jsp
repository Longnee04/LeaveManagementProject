<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Integer userID = (Integer) session.getAttribute("userID");

    if (username == null || !"Manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");

    String sql = "SELECT DepartmentName FROM Department";
    java.util.List<String> departments = new java.util.ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            departments.add(rs.getString("DepartmentName"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Employee</title>
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

        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.75rem 1rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.1);
        }

        .btn-submit {
            background: var(--primary);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            color: white;
        }

        .btn-back {
            background: #64748b;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: #475569;
            transform: translateY(-1px);
            color: white;
        }

        .required-field::after {
            content: '*';
            color: #ef4444;
            margin-left: 4px;
        }

        .form-text {
            color: var(--secondary);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: var(--primary)">
        <div class="container">
            <a class="navbar-brand" href="#">Dashboard</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="manager_dashboard.jsp">
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
        <!-- Header -->
        <div class="profile-header text-center">
            <h2 class="mb-2">Add New Employee</h2>
            <p class="mb-0">Add a new employee to your department</p>
        </div>

        <!-- Display Messages -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success" role="alert">
                <%= successMessage %>
            </div>
        <% } %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= errorMessage %>
            </div>
        <% } %>

        <!-- Add Employee Form -->
        <div class="info-card">
            <form action="addEmployee" method="post" id="addEmployeeForm">
                <div class="row g-4">
                    <!-- Username -->
                    <div class="col-md-6">
                        <label class="form-label required-field">Username</label>
                        <input type="text" class="form-control" name="username" required>
                    </div>

                    <!-- Password -->
                    <div class="col-md-6">
                        <label class="form-label required-field">Password</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>

                    <!-- Full Name -->
                    <div class="col-md-6">
                        <label class="form-label required-field">Full Name</label>
                        <input type="text" class="form-control" name="fullName" required>
                    </div>

                    <!-- Email -->
                    <div class="col-md-6">
                        <label class="form-label required-field">Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>

                    <!-- Department -->
                    <div class="col-md-6">
                        <label class="form-label required-field">Department</label>
                        <select class="form-select" name="department" required>
                            <option value="">Select Department</option>
                            <% for (String department : departments) { %>
                                <option value="<%= department %>">
                                    <%= department %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Phone -->
                    <div class="col-md-6">
                        <label class="form-label">Phone</label>
                        <input type="text" class="form-control" name="phone">
                    </div>

                    <!-- Gender -->
                    <div class="col-md-6">
                        <label class="form-label">Gender</label>
                        <select class="form-select" name="gender">
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <!-- Date of Birth -->
                    <div class="col-md-6">
                        <label class="form-label">Date of Birth</label>
                        <input type="date" class="form-control" name="dob">
                    </div>

                    <!-- Address -->
                    <div class="col-12">
                        <label class="form-label">Address</label>
                        <textarea class="form-control" name="address" rows="2"></textarea>
                    </div>

                    <!-- Buttons -->
                    <div class="col-12 text-center mt-4">
                        <a href="manager_dashboard.jsp" class="btn btn-back me-2">
                            <i class="bi bi-arrow-left"></i> Back to Dashboard
                        </a>
                        <button type="submit" class="btn btn-submit">
                            <i class="bi bi-send"></i> Add Employee
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>