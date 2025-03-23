package dao;

import db.DBConnection;
import model.LeaveRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LeaveRequestDAO {
    public static boolean createLeaveRequest(LeaveRequest leaveRequest) {
        String sql = "INSERT INTO LeaveRequests (UserID, LeaveTypeID, StartDate, EndDate, Reason, Attachment, Status, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'Inprogress', GETDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, leaveRequest.getUserID());
            ps.setInt(2, leaveRequest.getLeaveTypeID());
            ps.setString(3, leaveRequest.getStartDate());
            ps.setString(4, leaveRequest.getEndDate());
            ps.setString(5, leaveRequest.getReason());
            ps.setString(6, leaveRequest.getAttachment());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy danh sách các đơn chờ của nhân viên trong ban
    public static List<LeaveRequest> getPendingRequestsByDepartment(String department) {
        List<LeaveRequest> pendingRequests = new ArrayList<>();
        String sql = "SELECT lr.RequestID, lr.UserID, lr.LeaveTypeID, lt.LeaveTypeName, lr.StartDate, lr.EndDate, lr.Reason, lr.Status " +
                     "FROM LeaveRequests lr " +
                     "JOIN Users u ON lr.UserID = u.UserID " +
                     "JOIN LeaveType lt ON lr.LeaveTypeID = lt.LeaveTypeID " +
                     "WHERE u.Department = ? AND lr.Status = 'Inprogress'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LeaveRequest leaveRequest = new LeaveRequest();
                    leaveRequest.setRequestID(rs.getInt("RequestID"));
                    leaveRequest.setUserID(rs.getInt("UserID"));
                    leaveRequest.setLeaveTypeID(rs.getInt("LeaveTypeID"));
                    leaveRequest.setLeaveTypeName(rs.getString("LeaveTypeName"));
                    leaveRequest.setStartDate(rs.getString("StartDate"));
                    leaveRequest.setEndDate(rs.getString("EndDate"));
                    leaveRequest.setReason(rs.getString("Reason"));
                    leaveRequest.setStatus(rs.getString("Status"));
                    pendingRequests.add(leaveRequest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pendingRequests;
    }
}
