<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>

<%
    User currentUser = (User) session.getAttribute("user");
    
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Inventory Staff Dashboard">
        <meta name="author" content="Warehouse Management System">
        <title>Inventory Manager Dashboard</title>

        <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

        <style>
            .stats-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 15px;
                padding: 1.5rem;
                margin-bottom: 1rem;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .stats-card.warning {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }

            .stats-card.success {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .stats-card.info {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            }

            .stats-number {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .stats-label {
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .alert-item {
                border-left: 4px solid #dc3545;
                background: #fff5f5;
                padding: 1rem;
                margin-bottom: 0.5rem;
                border-radius: 0 8px 8px 0;
            }

            .alert-item.warning {
                border-left-color: #ffc107;
                background: #fffbf0;
            }

            .alert-item.info {
                border-left-color: #17a2b8;
                background: #f0f9ff;
            }

            .inventory-item {
                padding: 1rem;
                border-bottom: 1px solid #eee;
                transition: background-color 0.2s;
            }

            .inventory-item:hover {
                background-color: #f8f9fa;
            }

            .welcome-banner {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem;
                border-radius: 15px;
                margin-bottom: 2rem;
            }
        </style>
    </head>

    <body>
        <div class="wrapper">
            <!-- Include Sidebar -->
            <jsp:include page="/manager/ManagerSidebar.jsp" />

            <div class="main">
                <!-- Include Navbar -->
                <jsp:include page="/manager/navbar.jsp" />

                <main class="content">
                    <div class="container-fluid p-0">

                        <!-- Welcome Banner -->
                        <div class="welcome-banner">
                            <h1 class="h3 mb-2">Welcome back, ${currentUser.firstName} ${currentUser.lastName}!</h1>
                            <p class="mb-0">Inventory Staff Dashboard - Manage your warehouse operations efficiently</p>
                        </div>

                        <!-- Error Display -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i data-feather="alert-circle" class="align-middle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
<script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
<script>
    // Initialize Feather icons
    feather.replace();

    // Auto-dismiss alerts after 5 seconds
    setTimeout(function () {
        $('.alert').alert('close');
    }, 5000);
</script>
</body>
</html>
