package controllers.employee;

import dao.EmployeeLeaveBalanceDAO;
import dao.LeaveRequestDAO;
import dao.LeaveTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.EmployeeLeaveBalance;
import models.LeaveRequest;
import models.LeaveType;
import models.User;
import utils.LeaveRequestValidator;
import utils.LeaveStatus;
import utils.SessionKeys;

@WebServlet(name = "EmployeeLeaveEditServlet", urlPatterns = {"/employee/leave-requests/edit"})
public class EmployeeLeaveEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        int requestId = parseInt(request.getParameter("id"), 0);
        if (requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/employee/leave-requests");
            return;
        }

        LeaveRequest leaveRequest;
        List<LeaveType> leaveTypes;
        List<EmployeeLeaveBalance> balances;
        try (LeaveRequestDAO dao = new LeaveRequestDAO();
             LeaveTypeDAO typeDAO = new LeaveTypeDAO();
             EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {
            leaveRequest = dao.findByIdAndUser(requestId, user.getUserID());
            leaveTypes = typeDAO.findAll();
            balances = balanceDAO.findByUserId(user.getUserID());
        }

        if (leaveRequest == null) {
            response.sendRedirect(request.getContextPath() + "/employee/leave-requests?error="
                    + encode("Không tìm thấy đơn nghỉ phép."));
            return;
        }

        if (!LeaveStatus.isEditable(leaveRequest.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/employee/leave-requests/view?id=" + requestId);
            return;
        }

        request.setAttribute("leaveRequest", leaveRequest);
        request.setAttribute("leaveTypes", leaveTypes);
        request.setAttribute("balances", balances);
        request.setAttribute("mode", "edit");
        request.getRequestDispatcher("/employee/leave/form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        int requestId = parseInt(request.getParameter("requestId"), 0);
        String action = request.getParameter("action");

        if (requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/employee/leave-requests");
            return;
        }

        try (LeaveRequestDAO dao = new LeaveRequestDAO()) {
            LeaveRequest existing = dao.findByIdAndUser(requestId, user.getUserID());
            if (existing == null || !LeaveStatus.isEditable(existing.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/employee/leave-requests?error="
                        + encode("Chỉ có thể chỉnh sửa đơn ở trạng thái Draft."));
                return;
            }

            if ("delete".equalsIgnoreCase(action)) {
                if (dao.deleteDraft(requestId, user.getUserID())) {
                    redirectSuccess(response, request, "Đã xóa bản nháp.");
                } else {
                    redirectError(response, request, "Không thể xóa đơn này.");
                }
                return;
            }

            String leaveTypeIdStr = request.getParameter("leaveTypeId");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String reason = trim(request.getParameter("reason"));
            String minUnitChosen = request.getParameter("minUnitChosen");
            if (minUnitChosen == null || minUnitChosen.isBlank()) {
                minUnitChosen = "Full";
            }

            int leaveTypeId = parseInt(leaveTypeIdStr, 0);
            
            LeaveType leaveType;
            try (LeaveTypeDAO typeDAO = new LeaveTypeDAO()) {
                leaveType = typeDAO.findById(leaveTypeId);
            }

            String error = LeaveRequestValidator.validate(leaveTypeId, startDate, endDate, reason, leaveType, user, minUnitChosen);
            if (error != null) {
                List<LeaveType> leaveTypes;
                List<EmployeeLeaveBalance> balances;
                try (LeaveTypeDAO typeDAO = new LeaveTypeDAO();
                     EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {
                    leaveTypes = typeDAO.findAll();
                    balances = balanceDAO.findByUserId(user.getUserID());
                }
                
                request.setAttribute("error", error);
                request.setAttribute("leaveRequest", existing);
                request.setAttribute("leaveTypes", leaveTypes);
                request.setAttribute("balances", balances);
                request.setAttribute("mode", "edit");
                request.setAttribute("leaveTypeId", leaveTypeIdStr);
                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("reason", reason);
                request.setAttribute("minUnitChosen", minUnitChosen);
                request.getRequestDispatcher("/employee/leave/form.jsp").forward(request, response);
                return;
            }

            double duration = LeaveRequestValidator.calculateDuration(startDate, endDate, leaveType, minUnitChosen);
            String status = "submit".equalsIgnoreCase(action) ? LeaveStatus.PENDING : LeaveStatus.DRAFT;
            
            LeaveRequest updated = new LeaveRequest();
            updated.setRequestID(requestId);
            updated.setUserID(user.getUserID());
            updated.setLeaveTypeID(leaveTypeId);
            updated.setStartDate(LeaveRequestValidator.toSqlDate(startDate));
            updated.setEndDate(LeaveRequestValidator.toSqlDate(endDate));
            updated.setReason(reason);
            updated.setStatus(status);
            updated.setDuration(duration);
            updated.setMinUnitChosen(minUnitChosen);

            if (!dao.updateDraft(updated)) {
                redirectError(response, request, "Không thể cập nhật đơn. Vui lòng thử lại.");
                return;
            }

            String msg = LeaveStatus.PENDING.equals(status)
                    ? "Đã gửi đơn nghỉ phép thành công."
                    : "Đã cập nhật bản nháp.";
            redirectSuccess(response, request, msg);
        }
    }

    private void redirectSuccess(HttpServletResponse response, HttpServletRequest request, String msg)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/employee/leave-requests?success=" + encode(msg));
    }

    private void redirectError(HttpServletResponse response, HttpServletRequest request, String msg)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/employee/leave-requests?error=" + encode(msg));
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
