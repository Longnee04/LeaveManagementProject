package controllers.admin;

import dao.DepartmentDAO;
import dao.EmployeeLeaveBalanceDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.Department;
import models.EmployeeLeaveBalance;
import models.User;

@WebServlet(name = "AdminEmployeeServlet", urlPatterns = {"/admin/employees"})
public class AdminEmployeeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try (UserDAO userDAO = new UserDAO();
             DepartmentDAO deptDAO = new DepartmentDAO();
             EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {

            if ("add".equals(action)) {
                request.setAttribute("departments", deptDAO.findAll());
                request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                return;
            }

            if ("edit".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    User emp = userDAO.findById(id);
                    if (emp != null) {
                        request.setAttribute("employee", emp);
                        request.setAttribute("departments", deptDAO.findAll());
                        request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/employees?error=" + encode("Không tìm thấy nhân viên."));
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?error=" + encode("ID không hợp lệ."));
                }
                return;
            }

            // Quản lý số dư nghỉ phép của nhân viên
            if ("balances".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    User emp = userDAO.findById(id);
                    if (emp != null) {
                        List<EmployeeLeaveBalance> balances = balanceDAO.findByUserId(id);
                        request.setAttribute("employee", emp);
                        request.setAttribute("balances", balances);
                        request.getRequestDispatcher("/admin/employees/balances.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/employees?error=" + encode("Không tìm thấy nhân viên."));
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?error=" + encode("ID không hợp lệ."));
                }
                return;
            }

            if ("delete".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    if (userDAO.delete(id)) {
                        response.sendRedirect(request.getContextPath() + "/admin/employees?success=" + encode("Đã ngưng hoạt động tài khoản nhân viên."));
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/employees?error=" + encode("Không thể xóa tài khoản này."));
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?error=" + encode("ID không hợp lệ."));
                }
                return;
            }

            // Mặc định: Hiển thị danh sách nhân viên
            String search = request.getParameter("search");
            List<User> list;
            if (search != null && !search.isBlank()) {
                list = userDAO.searchByName(search.trim());
            } else {
                list = userDAO.findAll();
            }

            // Phân trang
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isBlank()) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int recordsPerPage = 10;
            int totalRecords = list.size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            int start = (page - 1) * recordsPerPage;
            int end = Math.min(start + recordsPerPage, totalRecords);

            List<User> pagedList = list.subList(start, end);

            request.setAttribute("employees", pagedList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", search);
            
            request.getRequestDispatcher("/admin/employees/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try (UserDAO userDAO = new UserDAO();
             DepartmentDAO deptDAO = new DepartmentDAO();
             EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {

            // Xử lý điều chỉnh số dư nghỉ phép
            if ("adjustBalance".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int leaveTypeId = Integer.parseInt(request.getParameter("leaveTypeId"));
                double annualQuota = Double.parseDouble(request.getParameter("annualQuota"));
                double usedDays = Double.parseDouble(request.getParameter("usedDays"));

                if (balanceDAO.adjustQuota(userId, leaveTypeId, annualQuota, usedDays)) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?action=balances&id=" + userId + "&success=" + encode("Đã điều chỉnh số dư nghỉ phép thành công."));
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?action=balances&id=" + userId + "&error=" + encode("Lỗi xảy ra khi cập nhật số dư."));
                }
                return;
            }

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String roleIdStr = request.getParameter("roleID");
            String deptIdStr = request.getParameter("departmentID");
            String statusStr = request.getParameter("status");

            if (fullName == null || fullName.isBlank() || email == null || email.isBlank() || roleIdStr == null) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc.");
                request.setAttribute("departments", deptDAO.findAll());
                request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                return;
            }

            int roleID = Integer.parseInt(roleIdStr);
            int departmentID = (deptIdStr == null || deptIdStr.isBlank()) ? 0 : Integer.parseInt(deptIdStr);
            boolean status = "1".equals(statusStr) || "true".equalsIgnoreCase(statusStr);

            if ("add".equals(action)) {
                if (password == null || password.isBlank()) {
                    request.setAttribute("error", "Mật khẩu cho tài khoản mới không được trống.");
                    request.setAttribute("departments", deptDAO.findAll());
                    request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                    return;
                }

                User existing = userDAO.findByEmail(email.trim());
                if (existing != null) {
                    request.setAttribute("error", "Email này đã được sử dụng.");
                    request.setAttribute("departments", deptDAO.findAll());
                    request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                    return;
                }

                User user = new User();
                user.setFullName(fullName.trim());
                user.setEmail(email.trim());
                user.setPhone(phone != null ? phone.trim() : null);
                user.setPassword(password);
                user.setRoleID(roleID);
                user.setDepartmentID(departmentID);
                user.setStatus(status);

                int generatedId = userDAO.insert(user);
                if (generatedId > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?success=" + encode("Đã thêm nhân viên mới thành công."));
                } else {
                    request.setAttribute("error", "Lỗi xảy ra khi lưu nhân viên. Thử lại sau.");
                    request.setAttribute("departments", deptDAO.findAll());
                    request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                }
            } else if ("edit".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr == null || idStr.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?error=" + encode("Yêu cầu không hợp lệ."));
                    return;
                }

                int id = Integer.parseInt(idStr);
                
                User existing = userDAO.findByEmail(email.trim());
                if (existing != null && existing.getUserID() != id) {
                    request.setAttribute("error", "Email này đã được sử dụng bởi một tài khoản khác.");
                    request.setAttribute("employee", userDAO.findById(id));
                    request.setAttribute("departments", deptDAO.findAll());
                    request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                    return;
                }

                User user = new User();
                user.setUserID(id);
                user.setFullName(fullName.trim());
                user.setEmail(email.trim());
                user.setPhone(phone != null ? phone.trim() : null);
                user.setRoleID(roleID);
                user.setDepartmentID(departmentID);
                user.setStatus(status);

                boolean success = userDAO.update(user);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/employees?success=" + encode("Đã cập nhật thông tin nhân viên thành công."));
                } else {
                    request.setAttribute("error", "Lỗi xảy ra khi cập nhật nhân viên.");
                    request.setAttribute("employee", userDAO.findById(id));
                    request.setAttribute("departments", deptDAO.findAll());
                    request.getRequestDispatcher("/admin/employees/form.jsp").forward(request, response);
                }
            }
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
