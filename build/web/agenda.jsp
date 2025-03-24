<!-- filepath: d:\PRJ302\LeaveManagement\web\agenda.jsp -->
<%@ page session="true" %>
<%@ page import="model.Agenda" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"Manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Agenda> agendaList = (List<Agenda>) request.getAttribute("agendaList");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    Date startDate = (Date) request.getAttribute("startDate");
    Date endDate = (Date) request.getAttribute("endDate");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Agenda</title>
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
            <h2 class="mb-2">Employee Agenda</h2>
            <p class="mb-0">View and manage the attendance of your employees</p>
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

        <!-- Employee Agenda -->
        <div class="info-card">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Employee Name</th>
                        <th>Work Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (agendaList != null) { %>
                        <% for (Agenda agenda : agendaList) { %>
                            <tr>
                                <td><%= agenda.getUsername() %></td>
                                <td><%= agenda.getWorkDate() %></td>
                                <td><%= agenda.getStatus() %></td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="3" class="text-center">No agenda found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Pagination Controls -->
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="agenda?page=<%= currentPage - 1 %>&week=<%= sdf.format(startDate) %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                <% } %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="agenda?page=<%= i %>&week=<%= sdf.format(startDate) %>"><%= i %></a>
                    </li>
                <% } %>
                <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="agenda?page=<%= currentPage + 1 %>&week=<%= sdf.format(startDate) %>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                <% } %>
            </ul>
        </nav>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>