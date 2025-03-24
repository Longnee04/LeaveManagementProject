<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="db.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Integer userID = (Integer) session.getAttribute("userID");

    if (username == null || !"Employee".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> leaveRequests = (List<Map<String, Object>>) request.getAttribute("leaveRequests");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Leave Request History</h2>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Request ID</th>
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
                %>
                <tr>
                    <td><%= leaveRequest.get("requestID") %></td>
                    <td><%= leaveRequest.get("leaveTypeName") %></td>
                    <td><%= leaveRequest.get("startDate") %></td>
                    <td><%= leaveRequest.get("endDate") %></td>
                    <td><%= leaveRequest.get("reason") %></td>
                    <td><%= leaveRequest.get("status") %></td>
                    <td><%= leaveRequest.get("managerNote") %></td>
                    <td>
                        <a href="edit_leave_request.jsp?requestID=<%= leaveRequest.get("requestID") %>" class="btn btn-warning btn-sm">Edit</a>
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
        <a href="employee_dashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
    </div>
</body>
</html>