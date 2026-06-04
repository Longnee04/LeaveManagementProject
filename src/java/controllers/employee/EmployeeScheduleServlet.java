package controllers.employee;

import dao.WorkScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.Calendar;
import models.User;
import models.WorkSchedule;
import utils.SessionKeys;

@WebServlet(name = "EmployeeScheduleServlet", urlPatterns = {"/employee/schedules"})
public class EmployeeScheduleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        WorkScheduleDAO dao = new WorkScheduleDAO();
        
        if ("register".equals(action)) {
            request.getRequestDispatcher("/employee/schedules/register.jsp").forward(request, response);
            return;
        }

        // Default action: Xem bảng lịch cá nhân dạng grid tuần
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
        
        // Apply offset
        if (weekOffset != 0) {
            cal.add(Calendar.WEEK_OF_YEAR, weekOffset);
        }

        // Tìm ngày Thứ Hai đầu tuần
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        Date monday = new Date(cal.getTimeInMillis());

        // Tìm ngày Chủ Nhật cuối tuần
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        Date sunday = new Date(cal.getTimeInMillis());

        request.setAttribute("schedules", dao.findByWeekAndUser(user.getUserID(), monday, sunday));
        request.setAttribute("monday", monday);
        request.setAttribute("sunday", sunday);
        request.setAttribute("weekOffset", weekOffset);
        
        request.getRequestDispatcher("/employee/schedules/list.jsp").forward(request, response);
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
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        if (startDateStr == null || startDateStr.isBlank() || endDateStr == null || endDateStr.isBlank()) {
            request.setAttribute("error", "Vui lòng chọn khoảng ngày bắt đầu và kết thúc.");
            request.getRequestDispatcher("/employee/schedules/register.jsp").forward(request, response);
            return;
        }

        Date startDate;
        Date endDate;
        try {
            startDate = Date.valueOf(startDateStr);
            endDate = Date.valueOf(endDateStr);
            
            if (endDate.before(startDate)) {
                request.setAttribute("error", "Ngày kết thúc không được nhỏ hơn ngày bắt đầu.");
                request.getRequestDispatcher("/employee/schedules/register.jsp").forward(request, response);
                return;
            }

            // Khóa không cho đăng ký trong quá khứ
            Date today = new Date(System.currentTimeMillis());
            if (startDate.before(today) && !startDate.toString().equals(today.toString())) {
                request.setAttribute("error", "Không thể đăng ký lịch làm cho các ngày trong quá khứ.");
                request.getRequestDispatcher("/employee/schedules/register.jsp").forward(request, response);
                return;
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng ngày chọn không hợp lệ.");
            request.getRequestDispatcher("/employee/schedules/register.jsp").forward(request, response);
            return;
        }

        // Hủy toàn bộ các ca đang chờ duyệt (Pending) cũ trong khoảng ngày để ghi đè ca mới
        dao.deletePendingByDateRange(user.getUserID(), startDate, endDate);

        // Lặp qua từng ngày trong khoảng đã chọn
        Calendar loopCal = Calendar.getInstance();
        loopCal.setTime(startDate);

        boolean hasInserted = false;

        while (!loopCal.getTime().after(endDate)) {
            Date currentDate = new Date(loopCal.getTimeInMillis());
            String dateKey = currentDate.toString();

            // Đọc trạng thái checkboxes
            String morning = request.getParameter("shift_" + dateKey + "_Morning");
            String afternoon = request.getParameter("shift_" + dateKey + "_Afternoon");
            String evening = request.getParameter("shift_" + dateKey + "_Evening");
            String dailyNote = request.getParameter("note_" + dateKey);

            if (morning != null) {
                WorkSchedule ws = new WorkSchedule();
                ws.setUserID(user.getUserID());
                ws.setWorkDate(currentDate);
                ws.setShift("Morning");
                ws.setStatus("Pending");
                ws.setNote(dailyNote != null ? dailyNote.trim() : null);
                dao.insert(ws);
                hasInserted = true;
            }
            if (afternoon != null) {
                WorkSchedule ws = new WorkSchedule();
                ws.setUserID(user.getUserID());
                ws.setWorkDate(currentDate);
                ws.setShift("Afternoon");
                ws.setStatus("Pending");
                ws.setNote(dailyNote != null ? dailyNote.trim() : null);
                dao.insert(ws);
                hasInserted = true;
            }
            if (evening != null) {
                WorkSchedule ws = new WorkSchedule();
                ws.setUserID(user.getUserID());
                ws.setWorkDate(currentDate);
                ws.setShift("Evening");
                ws.setStatus("Pending");
                ws.setNote(dailyNote != null ? dailyNote.trim() : null);
                dao.insert(ws);
                hasInserted = true;
            }

            loopCal.add(Calendar.DATE, 1);
        }

        if (hasInserted) {
            response.sendRedirect(request.getContextPath() + "/employee/schedules?success=" + encode("Đã đăng ký ca làm việc thành công cho khoảng ngày từ " + startDateStr + " đến " + endDateStr + ". Vui lòng chờ quản lý duyệt."));
        } else {
            response.sendRedirect(request.getContextPath() + "/employee/schedules?success=" + encode("Đã lưu. Không có ca nào được đăng ký thêm trong khoảng ngày này."));
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
