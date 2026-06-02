package controllers.manager;

import dao.WorkScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "ManagerScheduleServlet", urlPatterns = {"/manager/schedules"})
public class ManagerScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WorkScheduleDAO dao = new WorkScheduleDAO();
        request.setAttribute("pendingSchedules", dao.findPendingForReview());
        request.setAttribute("approvedSchedules", dao.findApproved());
        
        request.getRequestDispatcher("/manager/schedules/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WorkScheduleDAO dao = new WorkScheduleDAO();
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isBlank() || action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("Yêu cầu không hợp lệ."));
            return;
        }

        try {
            int scheduleId = Integer.parseInt(idStr);
            if ("approve".equals(action)) {
                if (dao.approve(scheduleId)) {
                    response.sendRedirect(request.getContextPath() + "/manager/schedules?success=" + encode("Đã phê duyệt ca làm việc."));
                } else {
                    response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("Lỗi xảy ra khi duyệt ca làm."));
                }
            } else if ("reject".equals(action)) {
                String rejectNote = request.getParameter("rejectNote");
                if (rejectNote == null || rejectNote.isBlank()) {
                    rejectNote = "Bị từ chối bởi Quản lý";
                }
                if (dao.reject(scheduleId, rejectNote.trim())) {
                    response.sendRedirect(request.getContextPath() + "/manager/schedules?success=" + encode("Đã từ chối ca làm việc."));
                } else {
                    response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("Lỗi xảy ra khi từ chối ca làm."));
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("Hành động không hợp lệ."));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("ID ca làm không hợp lệ."));
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
