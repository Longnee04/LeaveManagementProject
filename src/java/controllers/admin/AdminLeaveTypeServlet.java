package controllers.admin;

import dao.LeaveTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.LeaveType;

@WebServlet(name = "AdminLeaveTypeServlet", urlPatterns = {"/admin/leave-types"})
public class AdminLeaveTypeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try (LeaveTypeDAO dao = new LeaveTypeDAO()) {
            if ("add".equals(action)) {
                request.getRequestDispatcher("/admin/leave-types/form.jsp").forward(request, response);
                return;
            }

            if ("edit".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    LeaveType type = dao.findById(id);
                    if (type != null) {
                        request.setAttribute("leaveType", type);
                        request.getRequestDispatcher("/admin/leave-types/form.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=" + encode("Không tìm thấy loại nghỉ phép."));
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=" + encode("ID không hợp lệ."));
                }
                return;
            }

            if ("delete".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    if (dao.delete(id)) {
                        response.sendRedirect(request.getContextPath() + "/admin/leave-types?success=" + encode("Đã xóa loại nghỉ phép thành công."));
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=" + encode("Không thể xóa loại nghỉ phép này (có thể có đơn nghỉ phép đang sử dụng)."));
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=" + encode("ID không hợp lệ."));
                }
                return;
            }

            // Mặc định: Hiển thị danh sách loại nghỉ phép
            request.setAttribute("leaveTypes", dao.findAll());
            request.getRequestDispatcher("/admin/leave-types/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String leaveTypeName = request.getParameter("leaveTypeName");
        String description = request.getParameter("description");
        String maxDaysStr = request.getParameter("maxDays");
        
        // Cấu hình nghiệp vụ nghỉ phép mới
        boolean isWorkingDaysOnly = "1".equals(request.getParameter("isWorkingDaysOnly"));
        boolean newEmployeeRestricted = "1".equals(request.getParameter("newEmployeeRestricted"));
        String minUnit = request.getParameter("minUnit");
        if (minUnit == null || minUnit.isBlank()) {
            minUnit = "Day";
        }

        try (LeaveTypeDAO dao = new LeaveTypeDAO()) {
            if (leaveTypeName == null || leaveTypeName.isBlank() || maxDaysStr == null || maxDaysStr.isBlank()) {
                request.setAttribute("error", "Vui lòng điền tên loại nghỉ phép và số ngày nghỉ tối đa.");
                request.getRequestDispatcher("/admin/leave-types/form.jsp").forward(request, response);
                return;
            }

            int maxDays;
            try {
                maxDays = Integer.parseInt(maxDaysStr);
                if (maxDays <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Số ngày nghỉ tối đa phải là số nguyên dương.");
                if ("edit".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("leaveType", dao.findById(id));
                }
                request.getRequestDispatcher("/admin/leave-types/form.jsp").forward(request, response);
                return;
            }

            if ("add".equals(action)) {
                LeaveType type = new LeaveType();
                type.setLeaveTypeName(leaveTypeName.trim());
                type.setDescription(description != null ? description.trim() : null);
                type.setMaxDays(maxDays);
                type.setIsWorkingDaysOnly(isWorkingDaysOnly);
                type.setNewEmployeeRestricted(newEmployeeRestricted);
                type.setMinUnit(minUnit);

                if (dao.insert(type) > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/leave-types?success=" + encode("Đã thêm loại nghỉ phép mới."));
                } else {
                    request.setAttribute("error", "Lỗi xảy ra trong quá trình lưu dữ liệu.");
                    request.getRequestDispatcher("/admin/leave-types/form.jsp").forward(request, response);
                }
            } else if ("edit".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr == null || idStr.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=" + encode("Yêu cầu không hợp lệ."));
                    return;
                }

                int id = Integer.parseInt(idStr);
                LeaveType type = new LeaveType();
                type.setLeaveTypeID(id);
                type.setLeaveTypeName(leaveTypeName.trim());
                type.setDescription(description != null ? description.trim() : null);
                type.setMaxDays(maxDays);
                type.setIsWorkingDaysOnly(isWorkingDaysOnly);
                type.setNewEmployeeRestricted(newEmployeeRestricted);
                type.setMinUnit(minUnit);

                if (dao.update(type)) {
                    response.sendRedirect(request.getContextPath() + "/admin/leave-types?success=" + encode("Đã cập nhật loại nghỉ phép thành công."));
                } else {
                    request.setAttribute("error", "Lỗi xảy ra khi cập nhật dữ liệu.");
                    request.setAttribute("leaveType", dao.findById(id));
                    request.getRequestDispatcher("/admin/leave-types/form.jsp").forward(request, response);
                }
            }
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
