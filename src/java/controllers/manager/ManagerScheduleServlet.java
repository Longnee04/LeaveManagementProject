package controllers.manager;

import dao.WorkScheduleDAO;
import dao.UserDAO;
import dao.DepartmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "ManagerScheduleServlet", urlPatterns = {"/manager/schedules"})
public class ManagerScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedUser = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WorkScheduleDAO dao = new WorkScheduleDAO();
        UserDAO userDAO = new UserDAO();
        DepartmentDAO deptDAO = new DepartmentDAO();

        // 1. Tính toán phòng ban
        int deptId = 0;
        if ("Manager".equals(loggedUser.getRoleName())) {
            deptId = loggedUser.getDepartmentID();
        } else if ("Admin".equals(loggedUser.getRoleName())) {
            String deptStr = request.getParameter("deptId");
            if (deptStr != null && !deptStr.isBlank()) {
                try {
                    deptId = Integer.parseInt(deptStr);
                } catch (NumberFormatException e) {
                    deptId = 0;
                }
            }
        }

        // 2. Tính toán ngày trong tuần
        String offsetStr = request.getParameter("weekOffset");
        int weekOffset = 0;
        if (offsetStr != null && !offsetStr.isBlank()) {
            try {
                weekOffset = Integer.parseInt(offsetStr);
            } catch (NumberFormatException e) {
                weekOffset = 0;
            }
        }

        Calendar cal = Calendar.getInstance();
        cal.setFirstDayOfWeek(Calendar.MONDAY);
        if (weekOffset != 0) {
            cal.add(Calendar.WEEK_OF_YEAR, weekOffset);
        }

        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        Date monday = new Date(cal.getTimeInMillis());

        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        Date sunday = new Date(cal.getTimeInMillis());

        // 3. Lọc danh sách nhân viên cần phân lịch (Manager & Employee, loại bỏ Admin)
        List<User> allUsers = userDAO.findAll();
        final int finalDeptId = deptId;
        List<User> employees = allUsers.stream()
                .filter(u -> u.isStatus()) // Chỉ lấy user đang hoạt động
                .filter(u -> u.getRoleID() != 1) // Loại bỏ Admin
                .filter(u -> finalDeptId == 0 || u.getDepartmentID() == finalDeptId) // Lọc theo phòng ban
                .collect(Collectors.toList());

        // 4. Lấy tất cả lịch đăng ký trong tuần của bộ phận
        request.setAttribute("schedules", dao.findByWeekAndDepartment(deptId, monday, sunday));
        
        request.setAttribute("employees", employees);
        request.setAttribute("departments", deptDAO.findAll());
        request.setAttribute("monday", monday);
        request.setAttribute("sunday", sunday);
        request.setAttribute("weekOffset", weekOffset);
        request.setAttribute("deptId", deptId);

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
        
        String weekOffsetStr = request.getParameter("weekOffset");
        String deptIdStr = request.getParameter("deptId");

        if (action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("Yêu cầu không hợp lệ."));
            return;
        }

        int deptId = 0;
        if (deptIdStr != null && !deptIdStr.isBlank()) {
            try {
                deptId = Integer.parseInt(deptIdStr);
            } catch (NumberFormatException e) {
                deptId = 0;
            }
        }
        if ("Manager".equals(user.getRoleName())) {
            deptId = user.getDepartmentID();
        }

        if ("approveAll".equals(action)) {
            int weekOffset = 0;
            if (weekOffsetStr != null && !weekOffsetStr.isBlank()) {
                try {
                    weekOffset = Integer.parseInt(weekOffsetStr);
                } catch (NumberFormatException e) {
                    weekOffset = 0;
                }
            }
            Calendar cal = Calendar.getInstance();
            cal.setFirstDayOfWeek(Calendar.MONDAY);
            if (weekOffset != 0) {
                cal.add(Calendar.WEEK_OF_YEAR, weekOffset);
            }
            cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            Date monday = new Date(cal.getTimeInMillis());
            cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
            Date sunday = new Date(cal.getTimeInMillis());

            boolean opSuccess = dao.approveAllPending(deptId, monday, sunday);
            String redirectUrl = request.getContextPath() + "/manager/schedules?weekOffset=" + weekOffsetStr + "&deptId=" + deptIdStr;
            if (opSuccess) {
                response.sendRedirect(redirectUrl + "&success=" + encode("Đã duyệt tất cả các ca đang chờ thành công."));
            } else {
                response.sendRedirect(redirectUrl + "&error=" + encode("Lỗi xảy ra trong quá trình cập nhật duyệt hàng loạt."));
            }
            return;
        }

        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("Yêu cầu không hợp lệ."));
            return;
        }

        try {
            int scheduleId = Integer.parseInt(idStr);
            boolean opSuccess = false;
            
            if ("approve".equals(action)) {
                opSuccess = dao.approve(scheduleId);
            } else if ("reject".equals(action)) {
                String rejectNote = request.getParameter("rejectNote");
                if (rejectNote == null || rejectNote.isBlank()) {
                    rejectNote = "Từ chối";
                }
                opSuccess = dao.reject(scheduleId, rejectNote.trim());
            }

            String redirectUrl = request.getContextPath() + "/manager/schedules?weekOffset=" + weekOffsetStr + "&deptId=" + deptIdStr;
            if (opSuccess) {
                response.sendRedirect(redirectUrl + "&success=" + encode("Đã xử lý trạng thái ca làm việc thành công."));
            } else {
                response.sendRedirect(redirectUrl + "&error=" + encode("Lỗi xảy ra trong quá trình cập nhật."));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/schedules?error=" + encode("ID ca làm việc không hợp lệ."));
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
