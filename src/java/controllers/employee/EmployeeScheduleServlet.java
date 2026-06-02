package controllers.employee;

import dao.WorkScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import models.User;
import models.WorkSchedule;
import utils.SessionKeys;

@WebServlet(name = "EmployeeScheduleServlet", urlPatterns = {"/employee/schedules"})
public class EmployeeScheduleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        String action = request.getParameter("action");
        WorkScheduleDAO dao = new WorkScheduleDAO();
        
        if ("register".equals(action)) {
            request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
            return;
        }
        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                WorkSchedule schedule = dao.findById(id);
                if (schedule != null && schedule.getUserID() == user.getUserID() && "Pending".equals(schedule.getStatus())) {
                    request.setAttribute("schedule", schedule);
                    request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/employee/schedules?error=" + encode("Không thể chỉnh sửa lịch này. Lịch có thể đã được duyệt hoặc không phải của bạn."));
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/employee/schedules?error=" + encode("ID không hợp lệ."));
            }
            return;
        }
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (dao.delete(id, user.getUserID())) {
                    response.sendRedirect(request.getContextPath() + "/employee/schedules?success=" + encode("Đã xóa lịch làm việc thành công."));
                } else {
                    response.sendRedirect(request.getContextPath() + "/employee/schedules?error=" + encode("Không thể xóa lịch này. Lịch có thể đã được duyệt."));
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/employee/schedules?error=" + encode("ID không hợp lệ."));
            }
            return;
        }
        
        request.setAttribute("schedules", dao.findByUserId(user.getUserID()));
        request.getRequestDispatcher("/employee/schedules/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        WorkScheduleDAO dao = new WorkScheduleDAO();
        
        String scheduleIdStr = request.getParameter("scheduleId");
        String workDateStr = request.getParameter("workDate");
        String shift = request.getParameter("shift");
        String note = request.getParameter("note");
        
        if (workDateStr == null || workDateStr.isBlank() || shift == null || shift.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
            return;
        }
        
        Date workDate;
        try {
            workDate = Date.valueOf(workDateStr);
            // Kiểm tra xem ngày đăng ký có phải trong quá khứ không
            Date today = new Date(System.currentTimeMillis());
            if (workDate.before(today) && !workDate.toString().equals(today.toString())) {
                request.setAttribute("error", "Không thể đăng ký lịch làm việc cho các ngày trong quá khứ.");
                if (scheduleIdStr != null && !scheduleIdStr.isBlank()) {
                    int scheduleId = Integer.parseInt(scheduleIdStr);
                    request.setAttribute("schedule", dao.findById(scheduleId));
                }
                request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
                return;
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng ngày không hợp lệ.");
            request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
            return;
        }
        
        if (scheduleIdStr != null && !scheduleIdStr.isBlank()) {
            // Edit mode
            int scheduleId = Integer.parseInt(scheduleIdStr);
            WorkSchedule schedule = new WorkSchedule();
            schedule.setScheduleID(scheduleId);
            schedule.setUserID(user.getUserID());
            schedule.setWorkDate(workDate);
            schedule.setShift(shift);
            schedule.setNote(note != null ? note.trim() : null);
            
            // Duplicate check (except itself)
            WorkSchedule current = dao.findById(scheduleId);
            if (current != null && (!current.getWorkDate().toString().equals(workDate.toString()) || !current.getShift().equals(shift))) {
                if (dao.isDuplicate(user.getUserID(), workDate, shift)) {
                    request.setAttribute("error", "Bạn đã đăng ký ca này vào ngày này rồi.");
                    request.setAttribute("schedule", current);
                    request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
                    return;
                }
            }

            if (dao.update(schedule)) {
                response.sendRedirect(request.getContextPath() + "/employee/schedules?success=" + encode("Đã cập nhật lịch làm việc thành công."));
            } else {
                response.sendRedirect(request.getContextPath() + "/employee/schedules?error=" + encode("Không thể cập nhật lịch làm việc."));
            }
        } else {
            // Create mode - check duplicate
            if (dao.isDuplicate(user.getUserID(), workDate, shift)) {
                request.setAttribute("error", "Bạn đã đăng ký ca này vào ngày này rồi.");
                request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
                return;
            }
            
            WorkSchedule schedule = new WorkSchedule();
            schedule.setUserID(user.getUserID());
            schedule.setWorkDate(workDate);
            schedule.setShift(shift);
            schedule.setNote(note != null ? note.trim() : null);
            schedule.setStatus("Pending");
            
            if (dao.insert(schedule) > 0) {
                response.sendRedirect(request.getContextPath() + "/employee/schedules?success=" + encode("Đã đăng ký lịch làm việc thành công. Vui lòng chờ quản lý duyệt."));
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu lịch làm việc.");
                request.getRequestDispatcher("/employee/schedules/form.jsp").forward(request, response);
            }
        }
    }
    
    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
