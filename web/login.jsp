<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Portal - Multi Role Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="CSS/login.css">
</head>
<body>
    <div class="container-fluid login-container">
        <div class="row min-vh-100">
            <!-- Role Selection Panel -->
            <div class="col-md-3 role-panel p-4">
                <h4 class="text-white mb-4">Select Role</h4>
                <div class="d-flex flex-column gap-3">
                    <button class="btn btn-light role-btn active" data-role="admin">
                        <i class="bi bi-shield-lock me-2"></i>Admin Login
                    </button>
                    <button class="btn btn-light role-btn" data-role="manager">
                        <i class="bi bi-briefcase me-2"></i>Manager Login
                    </button>
                    <button class="btn btn-light role-btn" data-role="employee">
                        <i class="bi bi-person me-2"></i>Employee Login
                    </button>
                </div>
            </div>

            <!-- Login Form -->
            <div class="col-md-9 d-flex align-items-center justify-content-center">
                <div class="col-lg-5">
                    <div class="card shadow-lg border-0">
                        <div class="card-body p-4">
                            <div class="text-center mb-4">
                                <img src="https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=100&h=100&fit=crop" alt="Company Logo" class="rounded-circle mb-3" width="80">
                                <h4 class="card-title" id="loginTitle">Admin Login</h4>
                                <p class="text-muted" id="loginSubtitle">Welcome back! Please login to continue.</p>
                            </div>
                            <!-- Hi?n th? thông báo l?i n?u có -->
                            <%
                                String errorMessage = (String) request.getAttribute("errorMessage");
                                if (errorMessage != null) {
                            %>
                                <div class="alert alert-danger" role="alert">
                                    <%= errorMessage %>
                                </div>
                            <%
                                }
                            %>
                            <!-- Form g?i d? li?u ??n Servlet -->
                            <form id="loginForm" action="login" method="post" class="needs-validation" novalidate>
                                <!-- Hidden input ?? l?u role -->
                                <input type="hidden" id="role" name="role" value="admin">
                                <div class="mb-3">
                                    <div class="form-floating">
                                        <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                                        <label for="username">Username</label>
                                        <div class="invalid-feedback">Please enter your username.</div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="form-floating">
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                        <label for="password">Password</label>
                                        <div class="invalid-feedback">Please enter your password.</div>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                                        <label class="form-check-label" for="rememberMe">Remember me</label>
                                    </div>
                                    <a href="#" class="text-decoration-none forgot-password">Forgot Password?</a>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // X? lý thay ??i role khi nh?n nút
        document.querySelectorAll('.role-btn').forEach(button => {
            button.addEventListener('click', () => {
                // B? active kh?i t?t c? các nút
                document.querySelectorAll('.role-btn').forEach(btn => btn.classList.remove('active'));
                // Thêm active vào nút ???c ch?n
                button.classList.add('active');
                // L?y role t? nút ???c ch?n
                const role = button.dataset.role;
                // C?p nh?t tiêu ?? và hidden input
                document.getElementById('loginTitle').textContent = role.charAt(0).toUpperCase() + role.slice(1) + ' Login';
                document.getElementById('role').value = role; // C?p nh?t giá tr? role trong input ?n
            });
        });
    </script>
</body>
</html>