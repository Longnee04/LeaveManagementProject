<%-- 
    Document   : changePassword
    Created on : May 25, 2025, 11:40:28 PM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
        <meta name="author" content="AdminKit">
        <meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">

        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="img/icons/icon-48x48.png" />

        <title>Change Password</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <style>
            body {
                opacity: 0;
            }
            .h3.mb-3 {
                margin-left: 30px;
            }
        </style>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/admin/AdminSidebar.jsp" />
            <div class="main">
                <jsp:include page="/admin/navbar.jsp" />
                <div class="col-md-9 col-xl-10">
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="password" role="tabpanel">
                            <h1 class="h3 mb-3">Change Password</h1>

                            <div class="row">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <!-- <h5 class="card-title mb-0">Change Password</h5> -->
                                        </div>
                                        <div class="card-body">
                                            <% if (request.getAttribute("error") != null) { %>
                                            <div class="alert alert-danger">
                                                <%= request.getAttribute("error") %>
                                            </div>
                                            <% } %>
                                            <% if (request.getAttribute("success") != null) { %>
                                            <div class="alert alert-success">
                                                <%= request.getAttribute("success") %>
                                            </div>
                                            <% } %>

                                            <form action="${pageContext.request.contextPath}/admin/changePassword" method="POST">
                                                <div class="mb-3">
                                                    <label class="form-label" for="currentPassword">Current Password</label>
                                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label" for="newPassword">New Password</label>
                                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label" for="confirmPassword">Confirm New Password</label>
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                                </div>
                                                <div class="mt-3">
                                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                                    <a href="UserProfile" class="btn btn-secondary">Back</a>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="js/app.js"></script>
</body>
</html>