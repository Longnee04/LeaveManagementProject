package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import db.DBConnection;

@WebServlet("/UpdateLeaveRequestServlet")
public class UpdateLeaveRequestServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        int leaveTypeID = Integer.parseInt(request.getParameter("leaveTypeID"));
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String reason = request.getParameter("reason");

        String sql = "UPDATE LeaveRequests SET LeaveTypeID = ?, StartDate = ?, EndDate = ?, Reason = ? WHERE RequestID = ? AND Status = 'Inprogress'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, leaveTypeID);
            ps.setString(2, startDate);
            ps.setString(3, endDate);
            ps.setString(4, reason);
            ps.setInt(5, requestID);

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                // Chuyển hướng đến LeaveHistoryServlet để tải lại danh sách
                response.sendRedirect("LeaveHistoryServlet?success=Leave%20request%20updated%20successfully!");
            } else {
                response.sendRedirect("LeaveHistoryServlet?error=Failed%20to%20update%20leave%20request.%20Please%20try%20again.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("LeaveHistoryServlet?error=An%20error%20occurred%20while%20updating%20the%20leave%20request.");
        }
    }
}