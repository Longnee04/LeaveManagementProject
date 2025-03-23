package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import db.DBConnection;

@WebServlet("/LeaveHistoryServlet")
public class LeaveHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");

        // Kiểm tra xem người dùng đã đăng nhập chưa
        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông báo từ query parameters
        String successMessage = request.getParameter("success");
        String errorMessage = request.getParameter("error");

        // Lấy danh sách các đơn nghỉ phép của nhân viên
        List<Map<String, Object>> leaveRequests = new ArrayList<>();
        String sql = "SELECT lr.RequestID, lr.LeaveTypeID, lt.LeaveTypeName, lr.StartDate, lr.EndDate, lr.Reason, lr.Status, lr.ManagerNote " +
                     "FROM LeaveRequests lr " +
                     "JOIN LeaveType lt ON lr.LeaveTypeID = lt.LeaveTypeID " +
                     "WHERE lr.UserID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> leaveRequest = new HashMap<>();
                    leaveRequest.put("requestID", rs.getInt("RequestID"));
                    leaveRequest.put("leaveTypeID", rs.getInt("LeaveTypeID"));
                    leaveRequest.put("leaveTypeName", rs.getString("LeaveTypeName"));
                    leaveRequest.put("startDate", rs.getDate("StartDate"));
                    leaveRequest.put("endDate", rs.getDate("EndDate"));
                    leaveRequest.put("reason", rs.getString("Reason"));
                    leaveRequest.put("status", rs.getString("Status"));
                    leaveRequest.put("managerNote", rs.getString("ManagerNote"));
                    leaveRequests.add(leaveRequest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Gửi danh sách đơn nghỉ phép và thông báo đến JSP
        request.setAttribute("leaveRequests", leaveRequests);
        request.setAttribute("successMessage", successMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("view_leave_requests.jsp").forward(request, response);
    }
}