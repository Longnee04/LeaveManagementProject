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

@WebServlet("/DeleteLeaveRequestServlet")
public class DeleteLeaveRequestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));

        String sql = "DELETE FROM LeaveRequests WHERE RequestID = ? AND Status = 'Inprogress'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestID);

            int rowsDeleted = ps.executeUpdate();
            if (rowsDeleted > 0) {
                response.sendRedirect("LeaveHistoryServlet?success=Leave%20request%20deleted%20successfully!");
            } else {
                response.sendRedirect("LeaveHistoryServlet?error=Failed%20to%20delete%20leave%20request.%20Please%20try%20again.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("LeaveHistoryServlet?error=An%20error%20occurred%20while%20deleting%20the%20leave%20request.");
        }
    }
}