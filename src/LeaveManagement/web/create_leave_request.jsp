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

    // Load list of LeaveType from database
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
        }

        .btn-submit:hover {
            background: var(--primary-dark;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header text-center">
            <h2>Create Leave Request</h2>
        </div>

        <div class="info-card">
            <form action="CreateLeaveRequestServlet" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="leaveType" class="form-label">Leave Type</label>
                    <select class="form-select" id="leaveType" name="leaveTypeID" required>
                        <%
                            for (java.util.Map<String, Object> leaveType : leaveTypes) {
                        %>
                        <option value="<%= leaveType.get("id") %>"><%= leaveType.get("name") %></option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" required>
                </div>
                <div class="mb-3">
                    <label for="endDate" class="form-label">End Date</label>
                    <input type="date" class="form-control" id="endDate" name="endDate" required>
                </div>
                <div class="mb-3">
                    <label for="reason" class="form-label">Reason</label>
                    <textarea class="form-control" id="reason" name="reason" rows="4" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="attachment" class="form-label">Attachment (optional)</label>
                    <input type="file" class="form-control" id="attachment" name="attachment">
                </div>
                <button type="submit" class="btn btn-submit">Submit Request</button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>