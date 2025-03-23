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

    int requestID = Integer.parseInt(request.getParameter("requestID"));
    String sql = "SELECT LeaveTypeID, StartDate, EndDate, Reason FROM LeaveRequests WHERE RequestID = ? AND UserID = ?";
    java.util.Map<String, Object> leaveRequest = new java.util.HashMap<>();

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, requestID);
        ps.setInt(2, userID);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                leaveRequest.put("leaveTypeID", rs.getInt("LeaveTypeID"));
                leaveRequest.put("startDate", rs.getDate("StartDate").toString());
                leaveRequest.put("endDate", rs.getDate("EndDate").toString());
                leaveRequest.put("reason", rs.getString("Reason"));
            }
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
    <title>Edit Leave Request</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Edit Leave Request</h2>
        <form action="UpdateLeaveRequestServlet" method="post">
            <input type="hidden" name="requestID" value="<%= requestID %>">
            <div class="mb-3">
                <label for="leaveType" class="form-label">Leave Type</label>
                <select class="form-select" id="leaveType" name="leaveTypeID" required>
                    <%
                        String leaveTypeSql = "SELECT LeaveTypeID, LeaveTypeName FROM LeaveType";
                        try (Connection conn = DBConnection.getConnection();
                             PreparedStatement ps = conn.prepareStatement(leaveTypeSql);
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                int leaveTypeID = rs.getInt("LeaveTypeID");
                                String leaveTypeName = rs.getString("LeaveTypeName");
                    %>
                    <option value="<%= leaveTypeID %>" <%= leaveTypeID == (int) leaveRequest.get("leaveTypeID") ? "selected" : "" %>>
                        <%= leaveTypeName %>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
            <div class="mb-3">
                <label for="startDate" class="form-label">Start Date</label>
                <input type="date" class="form-control" id="startDate" name="startDate" value="<%= leaveRequest.get("startDate") %>" required>
            </div>
            <div class="mb-3">
                <label for="endDate" class="form-label">End Date</label>
                <input type="date" class="form-control" id="endDate" name="endDate" value="<%= leaveRequest.get("endDate") %>" required>
            </div>
            <div class="mb-3">
                <label for="reason" class="form-label">Reason</label>
                <textarea class="form-control" id="reason" name="reason" rows="4" required><%= leaveRequest.get("reason") %></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Update</button>
        </form>
    </div>
</body>
</html>