package controllers.employee;

import dao.LeaveRequestDAO;
import dao.LeaveTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.LeaveRequest;
import models.LeaveType;
import models.User;
import utils.LeaveRequestValidator;
import utils.LeaveStatus;
import utils.SessionKeys;

@WebServlet(name = "EmployeeLeaveFormServlet", urlPatterns = {"/employee/leave-requests/create"})
public class EmployeeLeaveFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("leaveTypes", new LeaveTypeDAO().findAll());
        request.setAttribute("mode", "create");
        request.getRequestDispatcher("/employee/leave/form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        String action = request.getParameter("action");
        String leaveTypeIdStr = request.getParameter("leaveTypeId");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String reason = trim(request.getParameter("reason"));

        int leaveTypeId = parseInt(leaveTypeIdStr, 0);
        LeaveTypeDAO typeDAO = new LeaveTypeDAO();
        LeaveType leaveType = typeDAO.findById(leaveTypeId);

        String error = LeaveRequestValidator.validate(leaveTypeId, startDate, endDate, reason, leaveType);
        if (error != null) {
            forwardWithError(request, response, error, leaveTypeIdStr, startDate, endDate, reason);
            return;
        }

        String status = "submit".equalsIgnoreCase(action) ? LeaveStatus.PENDING : LeaveStatus.DRAFT;
        LeaveRequest leaveRequest = buildRequest(user.getUserID(), leaveTypeId, startDate, endDate, reason, status);

        LeaveRequestDAO dao = new LeaveRequestDAO();
        int id = dao.insert(leaveRequest);
        if (id <= 0) {
            forwardWithError(request, response, "Không thể tạo đơn. Vui lòng thử lại.", leaveTypeIdStr, startDate, endDate, reason);
            return;
        }

        String msg = LeaveStatus.PENDING.equals(status)
                ? "Đã gửi đơn nghỉ phép thành công."
                : "Đã lưu bản nháp đơn nghỉ phép.";
        redirectWithMessage(response, request, msg);
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
            String error, String leaveTypeId, String startDate, String endDate, String reason)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("leaveTypes", new LeaveTypeDAO().findAll());
        request.setAttribute("mode", "create");
        request.setAttribute("leaveTypeId", leaveTypeId);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("reason", reason);
        request.getRequestDispatcher("/employee/leave/form.jsp").forward(request, response);
    }

    private void redirectWithMessage(HttpServletResponse response, HttpServletRequest request, String msg)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/employee/leave-requests?success="
                + java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
    }

    private LeaveRequest buildRequest(int userId, int leaveTypeId, String startDate, String endDate,
            String reason, String status) {
        LeaveRequest req = new LeaveRequest();
        req.setUserID(userId);
        req.setLeaveTypeID(leaveTypeId);
        req.setStartDate(LeaveRequestValidator.toSqlDate(startDate));
        req.setEndDate(LeaveRequestValidator.toSqlDate(endDate));
        req.setReason(reason);
        req.setStatus(status);
        return req;
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
