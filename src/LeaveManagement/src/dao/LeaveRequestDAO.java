package dao;

import db.DBConnection;
import model.LeaveRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

    public static boolean updateLeaveRequest(LeaveRequest leaveRequest) {
        String sql = "UPDATE LeaveRequests SET LeaveTypeID = ?, StartDate = ?, EndDate = ?, Reason = ? WHERE RequestID = ? AND Status = 'Inprogress'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, leaveRequest.getLeaveTypeID());
            ps.setString(2, leaveRequest.getStartDate());
            ps.setString(3, leaveRequest.getEndDate());
            ps.setString(4, leaveRequest.getReason());
            ps.setInt(5, leaveRequest.getRequestID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<LeaveRequest> getLeaveRequestsByUserID(int userID) {
        List<LeaveRequest> leaveRequests = new ArrayList<>();
        String sql = "SELECT * FROM LeaveRequests WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
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
                    leaveRequests.add(leaveRequest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return leaveRequests;
    }
}