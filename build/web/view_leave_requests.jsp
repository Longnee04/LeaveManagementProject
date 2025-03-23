<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"Employee".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> leaveRequests = (List<Map<String, Object>>) request.getAttribute("leaveRequests");
%>

<%
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Leave Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>My Leave Requests</h2>

        <!-- Hi?n th? thông báo -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
        <% } %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger"><%= errorMessage %></div>
        <% } %>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Leave Type</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Manager Note</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (leaveRequests != null && !leaveRequests.isEmpty()) {
                        for (Map<String, Object> leaveRequest : leaveRequests) {
                            int requestID = (int) leaveRequest.get("requestID");
                            String leaveTypeName = (String) leaveRequest.get("leaveTypeName");
                            String startDate = leaveRequest.get("startDate").toString();
                            String endDate = leaveRequest.get("endDate").toString();
                            String reason = (String) leaveRequest.get("reason");
                            String status = (String) leaveRequest.get("status");
                            String managerNote = (String) leaveRequest.get("managerNote");
                %>
                <tr>
                    <td><%= requestID %></td>
                    <td><%= leaveTypeName %></td>
                    <td><%= startDate %></td>
                    <td><%= endDate %></td>
                    <td><%= reason %></td>
                    <td><%= status %></td>
                    <td><%= managerNote != null ? managerNote : "N/A" %></td>
                    <td>
                        <% if ("Inprogress".equals(status)) { %>
                            <a href="edit_leave_request.jsp?requestID=<%= requestID %>" class="btn btn-warning btn-sm">Edit</a>
                        <% } else { %>
                            <span class="text-muted">N/A</span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8" class="text-center">No leave requests found.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>