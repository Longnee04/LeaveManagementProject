package dao;

import db.DBConnection;
import model.LeaveRequest;

import java.sql.*;
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

    public static List<LeaveRequest> getPendingRequestsByManager(int managerID) {
        List<LeaveRequest> leaveRequests = new ArrayList<>();
        String sql = "SELECT lr.RequestID, lr.UserID, lr.LeaveTypeID, lr.StartDate, lr.EndDate, lr.Reason, lr.Attachment, lr.Status, lr.CreatedAt, u.FullName, lt.LeaveTypeName " +
                     "FROM LeaveRequests lr " +
                     "JOIN Users u ON lr.UserID = u.UserID " +
                     "JOIN LeaveType lt ON lr.LeaveTypeID = lt.LeaveTypeID " +
                     "JOIN Department d ON u.DepartmentID = d.DepartmentID " +
                     "WHERE lr.Status = 'Inprogress' AND d.ManagerID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LeaveRequest leaveRequest = new LeaveRequest();
                    leaveRequest.setRequestID(rs.getInt("RequestID"));
                    leaveRequest.setUserID(rs.getInt("UserID"));
                    leaveRequest.setLeaveTypeID(rs.getInt("LeaveTypeID"));
                    leaveRequest.setStartDate(rs.getString("StartDate"));
                    leaveRequest.setEndDate(rs.getString("EndDate"));
                    leaveRequest.setReason(rs.getString("Reason"));
                    leaveRequest.setAttachment(rs.getString("Attachment"));
                    leaveRequest.setStatus(rs.getString("Status"));
                    leaveRequest.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    leaveRequest.setUserName(rs.getString("FullName"));
                    leaveRequest.setLeaveTypeName(rs.getString("LeaveTypeName"));
                    leaveRequests.add(leaveRequest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leaveRequests;
    }

    public static boolean updateLeaveRequestStatus(int requestID, String status, int managerID) {
        String sql = "UPDATE LeaveRequests SET Status = ?, Approved_By = ?, ProcessedAt = GETDATE() WHERE RequestID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, managerID);
            ps.setInt(3, requestID);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}