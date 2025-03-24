<%@ page session="true" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.User" %>
<%
    String errorMessage = null;
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String role = UserDAO.authenticateUser(username, password);
        if (role != null) {
            User user = UserDAO.getUserByUsername(username);
            session.setAttribute("username", username);
            session.setAttribute("role", role);
            session.setAttribute("userID", user.getUserID());
            session.setAttribute("fullName", user.getFullName());

            if ("Employee".equals(role)) {
                response.sendRedirect("employee_dashboard.jsp");
            } else if ("Manager".equals(role)) {
                response.sendRedirect("manager_dashboard.jsp");
            }
            return;
        } else {
            errorMessage = "Invalid username or password.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Login</h2>
        <form action="login.jsp" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="mb-3">
                <button type="submit" class="btn btn-primary">Login</button>
            </div>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>