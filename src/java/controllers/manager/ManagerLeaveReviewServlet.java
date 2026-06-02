package controllers.manager;

import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.LeaveRequest;
import utils.LeaveStatus;

@WebServlet(name = "ManagerLeaveReviewServlet", urlPatterns = {"/manager/leave-requests/review"})
public class ManagerLeaveReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = parseInt(request.getParameter("id"), 0);
        if (requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests");
            return;
        }

        LeaveRequest leaveRequest = new LeaveRequestDAO().findById(requestId);
        if (leaveRequest == null || !LeaveStatus.PENDING.equals(leaveRequest.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests?error="
                    + encode("Đơn không tồn tại hoặc đã được xử lý."));
            return;
        }

        request.setAttribute("leaveRequest", leaveRequest);
        request.getRequestDispatcher("/manager/leave/review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = parseInt(request.getParameter("requestId"), 0);
        String decision = request.getParameter("decision");
        String managerComment = trim(request.getParameter("managerComment"));

        if (requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/manager/leave-requests");
            return;
        }

        LeaveRequestDAO dao = new LeaveRequestDAO();
        LeaveRequest existing = dao.findById(requestId);
        if (existing == null || !LeaveStatus.PENDING.equals(existing.getStatus())) {
            redirectError(response, request, "Đơn không tồn tại hoặc đã được xử lý.");
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

        if (!dao.review(requestId, newStatus, managerComment)) {
            redirectError(response, request, "Không thể cập nhật đơn. Vui lòng thử lại.");
            return;
        }

        String msg = LeaveStatus.APPROVED.equals(newStatus)
                ? "Đã duyệt đơn nghỉ phép."
                : "Đã từ chối đơn nghỉ phép.";
        response.sendRedirect(request.getContextPath() + "/manager/leave-requests?success=" + encode(msg));
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
