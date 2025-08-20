<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Get cookies if exist
    String cEmail = "";
    String cPassword = "";
    boolean rememberChecked = false;

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("cEmail".equals(c.getName())) {
                cEmail = c.getValue();
            }
            if ("cPassword".equals(c.getName())) {
                cPassword = c.getValue();
            }
        }
    }

    // Check if both email and password cookies exist then check remember checkbox
    if (!cEmail.isEmpty() && !cPassword.isEmpty()) {
        rememberChecked = true;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Login</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" />

        <!-- Google Fonts & FontAwesome -->
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&family=Segoe+UI:wght@400;500;700&display=swap" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />

        <style>
            
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Heebo', 'Segoe UI', sans-serif;
            }
            body {
                background: #f4f7fa;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #333;
            }
            .login-container {
                width: 100%;
                max-width: 1000px;
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin: 2rem;
            }
            .illustration-side {
                background: #e0e7ff;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                padding: 2rem;
            }
            .illustration-side img {
                max-width: 100%;
                height: auto;
                border-radius: 15px;
                transition: transform 0.3s ease;
            }
            .illustration-side img:hover {
                transform: scale(1.05);
            }
            .form-side {
                padding: 3rem 2rem;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            .form-side h2 {
                font-size: 2rem;
                font-weight: 700;
                color: #1e3a8a;
                margin-bottom: 1.5rem;
            }
            .form-group {
                margin-bottom: 1.5rem;
                position: relative;
            }
            .form-group label {
                display: block;
                font-size: 0.95rem;
                color: #6b7280;
                margin-bottom: 0.5rem;
            }
            .form-group input {
                width: 100%;
                padding: 0.8rem 2.5rem 0.8rem 1rem;
                border: 2px solid #e5e7eb;
                border-radius: 10px;
                font-size: 1rem;
                transition: border-color 0.3s, box-shadow 0.3s;
            }
            .form-group input:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                outline: none;
            }
            .form-group i {
                position: absolute;
                bottom: 0.8rem;
                right: 1rem;
                color: #6b7280;
                font-size: 1.2rem;
                pointer-events: none;
            }
            .form-options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
            }
            .form-options .form-check {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }
            .form-options .form-check-input {
                width: 1.2rem;
                height: 1.2rem;
                cursor: pointer;
            }
            .form-options .form-check-label {
                font-size: 0.9rem;
                color: #4b5563;
                user-select: none;
            }
            .form-options a {
                font-size: 0.9rem;
                color: #3b82f6;
                text-decoration: none;
            }
            .form-options a:hover {
                text-decoration: underline;
                color: #1e3a8a;
            }
            .btn-signin {
                background: linear-gradient(135deg, #3b82f6, #1e3a8a);
                color: white;
                border: none;
                border-radius: 10px;
                padding: 0.8rem;
                font-size: 1.1rem;
                font-weight: 600;
                width: 100%;
                cursor: pointer;
                transition: transform 0.3s, box-shadow 0.3s;
                margin-bottom: 1rem;
            }
            .btn-signin:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
            }
            .signup-link {
                text-align: center;
                font-size: 0.9rem;
                color: #6b7280;
                margin-top: 1rem;
            }
            .signup-link a {
                color: #facc15;
                text-decoration: none;
                font-weight: 600;
            }
            .signup-link a:hover {
                text-decoration: underline;
            }
            @media (max-width: 768px) {
                .login-container {
                    margin: 1rem;
                }
                .illustration-side {
                    padding: 1rem;
                    min-height: 200px;
                }
                .form-side {
                    padding: 2rem 1.5rem;
                }
                .form-side h2 {
                    font-size: 1.5rem;
                }
                .btn-signin {
                    padding: 0.6rem;
                    font-size: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="row w-100 m-0">
                <!-- Illustration Side -->
                <div class="col-md-6 illustration-side">
                    <img src="admin/img/photos/test.jpg" alt="Warehouse Management Illustration" />
                </div>
                <!-- Form Side -->
                <div class="col-md-6 form-side">
                    <h2>Welcome back!</h2>

                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <form action="login" method="post" autocomplete="off">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input
                                type="text"
                                id="username"
                                name="username"
                                placeholder="Enter username"
                                value="<%= cEmail %>"
                                required
                                />
                            <i class="fas fa-user"></i>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Enter password"
                                value="<%= cPassword %>"
                                required
                                />
                            <i class="fas fa-lock"></i>
                        </div>

                        <div class="form-options">
                            <div class="form-check">
                                <input
                                    type="checkbox"
                                    class="form-check-input"
                                    id="rememberMe"
                                    name="remember"
                                    <%= rememberChecked ? "checked" : "" %>
                                    />
                                <label class="form-check-label" for="rememberMe">Remember me</label>
                            </div>
                            <a href="${pageContext.request.contextPath}/forgotpass">Forgot password?</a>
                        </div>

                        <button type="submit" class="btn-signin">Login</button>

                    </form>
                </div>
            </div>
        </div>
    </body>
</html>