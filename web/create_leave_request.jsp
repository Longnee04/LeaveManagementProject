<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Integer userID = (Integer) session.getAttribute("userID");

    if (username == null || !"Employee".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // L?y danh sách LeaveType t? database
    String sql = "SELECT LeaveTypeID, LeaveTypeName FROM LeaveType";
    java.util.List<java.util.Map<String, Object>> leaveTypes = new java.util.ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            java.util.Map<String, Object> type = new java.util.HashMap<>();
            type.put("id", rs.getInt("LeaveTypeID"));
            type.put("name", rs.getString("LeaveTypeName"));
            leaveTypes.add(type);
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
    <title>Create Leave Request</title>
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
        <!-- Header -->
        <div class="profile-header text-center">
            <h2 class="mb-2">Create Leave Request</h2>
            <p class="mb-0">Submit your leave request for approval</p>
        </div>

        <!-- Leave Request Form -->
        <div class="info-card">
            <form action="createLeaveRequest" method="post" id="leaveRequestForm" enctype="multipart/form-data">
                <div class="row g-4">
                    <!-- Leave Type -->
                    <div class="col-md-6">
                        <label class="form-label required-field">Leave Type</label>
                        <select class="form-select" name="leaveTypeID" required>
                            <option value="">Select Leave Type</option>
                            <% for (java.util.Map<String, Object> type : leaveTypes) { %>
                                <option value="<%= type.get("id") %>">
                                    <%= type.get("name") %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Start Date -->
                    <div class="col-md-6">
                        <label class="form-label required-field">Start Date</label>
                        <input type="date" class="form-control" name="startDate" required 
                               min="<%= java.time.LocalDate.now() %>">
                    </div>

                    <!-- End Date -->
                    <div class="col-md-6">
                        <label class="form-label required-field">End Date</label>
                        <input type="date" class="form-control" name="endDate" required 
                               min="<%= java.time.LocalDate.now() %>">
                    </div>

                    <!-- Reason -->
                    <div class="col-12">
                        <label class="form-label required-field">Reason for Leave</label>
                        <textarea class="form-control" name="reason" rows="4" required></textarea>
                    </div>

                    <!-- Attachment -->
                    <div class="col-12">
                        <label class="form-label">Supporting Documents</label>
                        <input type="file" class="form-control" name="attachment">
                        <div class="form-text">Upload any relevant documents (optional)</div>
                    </div>

                    <!-- Hidden Fields -->
                    <input type="hidden" name="userID" value="<%= userID %>">
                    <input type="hidden" name="status" value="Inprogress">
                    <input type="hidden" name="createdAt" value="<%= new java.sql.Timestamp(System.currentTimeMillis()) %>">

                    <!-- Buttons -->
                    <div class="col-12 text-center mt-4">
                        <a href="employee_dashboard.jsp" class="btn btn-back me-2">
                            <i class="bi bi-arrow-left"></i> Back to Dashboard
                        </a>
                        <button type="submit" class="btn btn-submit">
                            <i class="bi bi-send"></i> Submit Request
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('leaveRequestForm').addEventListener('submit', function(e) {
            const startDate = new Date(this.startDate.value);
            const endDate = new Date(this.endDate.value);
            
            if (endDate < startDate) {
                e.preventDefault();
                alert('End date must be after start date');
                return false;
            }

            // File validation
            const attachment = this.attachment.files[0];
            if (attachment) {
                const maxSize = 5 * 1024 * 1024; // 5MB
                const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
                
                if (attachment.size > maxSize) {
                    e.preventDefault();
                    alert('File size must be less than 5MB');
                    return false;
                }
                
                if (!allowedTypes.includes(attachment.type)) {
                    e.preventDefault();
                    alert('Only JPG, PNG and PDF files are allowed');
                    return false;
                }
            }
        });
    </script>
</body>
</html>
