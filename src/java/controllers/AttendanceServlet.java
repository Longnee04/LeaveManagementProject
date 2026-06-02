package controllers;

import dao.AttendanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.Attendance;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "AttendanceServlet", urlPatterns = {"/attendance"})
public class AttendanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AttendanceDAO dao = new AttendanceDAO();
        
        // Lấy thông tin điểm danh hôm nay của nhân viên
        Attendance today = dao.findTodayByUser(user.getUserID());
        request.setAttribute("todayAttendance", today);
        
        // Lấy lịch sử điểm danh đầy đủ
        request.setAttribute("attendanceHistory", dao.findByUserId(user.getUserID()));

        request.getRequestDispatcher("/attendance/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AttendanceDAO dao = new AttendanceDAO();
        String action = request.getParameter("action");

        if (action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/attendance?error=" + encode("Yêu cầu không hợp lệ."));
            return;
        }

        if ("checkin".equals(action)) {
            if (dao.checkIn(user.getUserID())) {
                response.sendRedirect(request.getContextPath() + "/attendance?success=" + encode("Ghi nhận giờ vào làm (Check-in) thành công!"));
            } else {
                response.sendRedirect(request.getContextPath() + "/attendance?error=" + encode("Check-in thất bại hoặc bạn đã check-in hôm nay rồi."));
            }
        } else if ("checkout".equals(action)) {
            // Kiểm tra xem đã check-in chưa
            if (!dao.hasCheckedInToday(user.getUserID())) {
                response.sendRedirect(request.getContextPath() + "/attendance?error=" + encode("Bạn chưa ghi nhận giờ vào làm hôm nay, không thể Check-out."));
                return;
            }
            
            if (dao.checkOut(user.getUserID())) {
                response.sendRedirect(request.getContextPath() + "/attendance?success=" + encode("Ghi nhận giờ ra về (Check-out) thành công!"));
            } else {
                response.sendRedirect(request.getContextPath() + "/attendance?error=" + encode("Check-out thất bại hoặc bạn đã ghi nhận ra về trước đó."));
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/attendance?error=" + encode("Hành động không xác định."));
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
