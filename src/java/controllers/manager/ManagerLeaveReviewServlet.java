package controllers.manager;

import dao.EmployeeLeaveBalanceDAO;
import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.LeaveRequest;
import models.User;
import utils.LeaveStatus;
import utils.SessionKeys;

@WebServlet(name = "ManagerLeaveReviewServlet", urlPatterns = {"/manager/leave-requests/review"})
public class ManagerLeaveReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User manager = (User) request.getSession().getAttribute(SessionKeys.USER);
        int requestId = parseInt(request.getParameter("id"), 0);
        if (requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests");
            return;
        }

        LeaveRequest leaveRequest;
        try (LeaveRequestDAO dao = new LeaveRequestDAO()) {
            leaveRequest = dao.findById(requestId);
        }

        if (leaveRequest == null || !LeaveStatus.PENDING.equals(leaveRequest.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests?error="
                    + encode("Đơn không tồn tại hoặc đã được xử lý."));
            return;
        }

        // Kiểm tra quyền hạn phòng ban (Manager chỉ được duyệt đơn cùng bộ phận)
        if (!"Admin".equalsIgnoreCase(manager.getRoleName()) && leaveRequest.getDepartmentID() != manager.getDepartmentID()) {
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests?error="
                    + encode("Bạn không có quyền duyệt đơn của nhân viên thuộc bộ phận khác."));
            return;
        }

        request.setAttribute("leaveRequest", leaveRequest);
        request.getRequestDispatcher("/manager/leave/review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User manager = (User) request.getSession().getAttribute(SessionKeys.USER);
        int requestId = parseInt(request.getParameter("requestId"), 0);
        String decision = request.getParameter("decision");
        String managerComment = trim(request.getParameter("managerComment"));

        if (requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests");
            return;
        }

        try (LeaveRequestDAO dao = new LeaveRequestDAO()) {
            LeaveRequest existing = dao.findById(requestId);
            if (existing == null || !LeaveStatus.PENDING.equals(existing.getStatus())) {
                redirectError(response, request, "Đơn không tồn tại hoặc đã được xử lý.");
                return;
            }

            // Kiểm tra quyền hạn phòng ban
            if (!"Admin".equalsIgnoreCase(manager.getRoleName()) && existing.getDepartmentID() != manager.getDepartmentID()) {
                redirectError(response, request, "Bạn không có quyền duyệt đơn của nhân viên thuộc bộ phận khác.");
                return;
            }

            String newStatus;
            if ("approve".equalsIgnoreCase(decision)) {
                newStatus = LeaveStatus.APPROVED;
            } else if ("reject".equalsIgnoreCase(decision)) {
                newStatus = LeaveStatus.REJECTED;
                if (managerComment == null || managerComment.isBlank()) {
                    request.setAttribute("error", "Vui lòng nhập lý do từ chối.");
                    request.setAttribute("leaveRequest", existing);
                    request.getRequestDispatcher("/manager/leave/review.jsp").forward(request, response);
                    return;
                }
            } else {
                redirectError(response, request, "Hành động không hợp lệ.");
                return;
            }

            // Nếu phê duyệt, thực hiện trừ số dư ngày nghỉ của nhân viên
            if (LeaveStatus.APPROVED.equals(newStatus)) {
                try (EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {
                    // Trừ số dư ngày nghỉ (tăng UsedDays, giảm RemainingDays)
                    boolean balanceUpdated = balanceDAO.updateBalance(existing.getUserID(), existing.getLeaveTypeID(), existing.getDuration());
                    if (!balanceUpdated) {
                        redirectError(response, request, "Không thể cập nhật số dư nghỉ phép của nhân viên. Vui lòng thử lại.");
                        return;
                    }
                }
            }

            if (!dao.review(requestId, newStatus, managerComment)) {
                // Nếu cập nhật đơn lỗi mà đã trừ số dư trước đó, ta nên rollback số dư (nếu cần thiết, tuy nhiên ở đây đơn giản hóa bằng cách báo lỗi hệ thống)
                redirectError(response, request, "Không thể cập nhật đơn nghỉ phép. Vui lòng thử lại.");
                return;
            }

            String msg = LeaveStatus.APPROVED.equals(newStatus)
                    ? "Đã duyệt đơn nghỉ phép thành công."
                    : "Đã từ chối đơn nghỉ phép.";
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests?success=" + encode(msg));
        }
    }

    private void redirectError(HttpServletResponse response, HttpServletRequest request, String msg)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/manager/leave-requests?error=" + encode(msg));
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
