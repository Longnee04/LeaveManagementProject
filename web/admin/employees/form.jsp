<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.User"%>
<%@page import="models.Department"%>
<%@page import="java.util.List"%>
<%
    User emp = (User) request.getAttribute("employee");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    boolean isEdit = (emp != null);
    String pageTitle = isEdit ? "Cập nhật Nhân viên" : "Thêm Nhân viên mới";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - HRM System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Font Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Global Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/sidebar.jsp"/>
    
    <div class="main-content">
        <jsp:include page="/WEB-INF/includes/header.jsp"/>
        
        <div class="content-wrapper">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1 class="page-title"><%= pageTitle %></h1>
                    <ul class="breadcrumb-custom m-0 p-0 mt-1">
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item-custom"><a href="${pageContext.request.contextPath}/admin/employees"> / Nhân viên</a></li>
                        <li class="breadcrumb-item-custom" style="color: var(--text-secondary);"> / <%= isEdit ? "Cập nhật" : "Thêm mới" %></li>
                    </ul>
                </div>
            </div>

            <!-- Error Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger-custom alert-custom shadow-sm mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <div class="row justify-content-center">
                <div class="col-12 col-lg-8">
                    <div class="form-card">
                        <h4 class="mb-4" style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary);">
                            <i class="fa-solid fa-id-card text-primary me-2"></i> Thông tin tài khoản nhân viên
                        </h4>
                        
                        <form method="post" action="${pageContext.request.contextPath}/admin/employees?action=<%= isEdit ? "edit" : "add" %>" onsubmit="return validateForm()">
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= emp.getUserID() %>">
                            <% } %>

                            <!-- Full Name -->
                            <div class="form-group-custom">
                                <label for="fullName" class="form-label-custom">Họ và Tên <span class="text-danger">*</span></label>
                                <input type="text" id="fullName" name="fullName" class="form-control-custom form-control" 
                                       value="<%= isEdit ? emp.getFullName() : "" %>" required placeholder="Nhập họ và tên đầy đủ">
                                <div class="invalid-feedback">Họ và tên không được để trống.</div>
                            </div>
                            
                            <!-- Email -->
                            <div class="form-group-custom">
                                <label for="email" class="form-label-custom">Địa chỉ Email <span class="text-danger">*</span></label>
                                <input type="email" id="email" name="email" class="form-control-custom form-control" 
                                       value="<%= isEdit ? emp.getEmail() : "" %>" required placeholder="Nhập địa chỉ email công việc">
                                <div class="invalid-feedback">Email không được trống và phải hợp lệ.</div>
                            </div>
                            
                            <!-- Phone -->
                            <div class="form-group-custom">
                                <label for="phone" class="form-label-custom">Số điện thoại</label>
                                <input type="text" id="phone" name="phone" class="form-control-custom form-control" 
                                       value="<%= isEdit && emp.getPhone() != null ? emp.getPhone() : "" %>" placeholder="Nhập số điện thoại liên hệ">
                            </div>

                            <% if (!isEdit) { %>
                                <!-- Password (Only on Add) -->
                                <div class="form-group-custom">
                                    <label for="password" class="form-label-custom">Mật khẩu khởi tạo <span class="text-danger">*</span></label>
                                    <input type="password" id="password" name="password" class="form-control-custom form-control" required placeholder="Nhập mật khẩu cho tài khoản mới">
                                    <div class="invalid-feedback">Mật khẩu bắt buộc nhập đối với tài khoản mới.</div>
                                </div>
                            <% } %>

                            <div class="row">
                                <!-- Role Select -->
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="roleID" class="form-label-custom">Vai trò hệ thống <span class="text-danger">*</span></label>
                                        <select id="roleID" name="roleID" class="form-select form-control" required>
                                            <option value="">-- Chọn vai trò --</option>
                                            <option value="1" <%= isEdit && emp.getRoleID() == 1 ? "selected" : "" %>>Quản trị viên (Admin)</option>
                                            <option value="2" <%= isEdit && emp.getRoleID() == 2 ? "selected" : "" %>>Quản lý bộ phận (Manager)</option>
                                            <option value="3" <%= isEdit && emp.getRoleID() == 3 ? "selected" : "" %>>Nhân viên (Employee)</option>
                                        </select>
                                        <div class="invalid-feedback">Vui lòng chọn vai trò.</div>
                                    </div>
                                </div>
                                
                                <!-- Department Select -->
                                <div class="col-12 col-sm-6">
                                    <div class="form-group-custom">
                                        <label for="departmentID" class="form-label-custom">Phòng ban làm việc</label>
                                        <select id="departmentID" name="departmentID" class="form-select form-control">
                                            <option value="">-- Chọn phòng ban --</option>
                                            <% if (departments != null) { %>
                                                <% for (Department d : departments) { %>
                                                    <option value="<%= d.getDepartmentID() %>" 
                                                        <%= isEdit && emp.getDepartmentID() == d.getDepartmentID() ? "selected" : "" %>>
                                                        <%= d.getDepartmentName() %>
                                                    </option>
                                                <% } %>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Account Status Toggle -->
                            <div class="form-group-custom">
                                <label for="status" class="form-label-custom">Trạng thái hoạt động</label>
                                <select id="status" name="status" class="form-select form-control">
                                    <option value="true" <%= !isEdit || emp.isStatus() ? "selected" : "" %>>Hoạt động bình thường</option>
                                    <option value="false" <%= isEdit && !emp.isStatus() ? "selected" : "" %>>Khóa tài khoản</option>
                                </select>
                            </div>
                            
                            <hr class="my-4" style="border-color: var(--border-color);">
                            
                            <!-- Form Actions -->
                            <div class="d-flex gap-3 justify-content-end">
                                <a href="${pageContext.request.contextPath}/admin/employees" class="btn-custom btn-secondary-custom">
                                    Quay lại danh sách
                                </a>
                                <button type="submit" class="btn-custom btn-primary-custom">
                                    <i class="fa-solid fa-floppy-disk"></i> Lưu thông tin
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/includes/footer.jsp"/>
    </div>

    <script>
        function validateForm() {
            var fullName = document.getElementById("fullName").value.trim();
            var email = document.getElementById("email").value.trim();
            var roleID = document.getElementById("roleID").value;
            var isValid = true;
            
            // Reset validation classes
            document.getElementById("fullName").classList.remove("is-invalid");
            document.getElementById("email").classList.remove("is-invalid");
            document.getElementById("roleID").classList.remove("is-invalid");
            
            if (!isEdit) {
                var password = document.getElementById("password");
                if (password) password.classList.remove("is-invalid");
            }

            if (!fullName) {
                document.getElementById("fullName").classList.add("is-invalid");
                isValid = false;
            }
            if (!email || !email.includes("@")) {
                document.getElementById("email").classList.add("is-invalid");
                isValid = false;
            }
            if (!roleID) {
                document.getElementById("roleID").classList.add("is-invalid");
                isValid = false;
            }
            
            <% if (!isEdit) { %>
                var passwordVal = document.getElementById("password").value;
                if (!passwordVal || passwordVal.length < 6) {
                    document.getElementById("password").classList.add("is-invalid");
                    isValid = false;
                }
            <% } %>
            
            return isValid;
        }
    </script>
</body>
</html>
