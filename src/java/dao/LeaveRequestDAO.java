đpackage dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.LeaveRequest;

public class LeaveRequestDAO extends DBConnect {
    public LeaveRequestDAO() {
        super(); // Call the parent constructor to initialize the connection
    }

    // Method to get all leave requests for a specific employee
    public List<LeaveRequest> getLeaveRequestsByEmployeeId(int employeeId) {
        List<LeaveRequest> leaveRequests = new ArrayList<>();
        String sql = "SELECT lr.*, lt.leave_type_name " +
                     "FROM Leave_Request lr " +
                     "JOIN Leave_Type lt ON lr.leave_type_id = lt.leave_type_id " +
                     "WHERE lr.employee_id = ? ORDER BY lr.created_at DESC";

        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LeaveRequest lr = new LeaveRequest();
                    lr.setRequestId(rs.getInt("request_id"));
                    lr.setRequestCode(rs.getString("request_code"));
                    lr.setEmployeeId(rs.getInt("employee_id"));
                    lr.setWarehouseId(rs.getInt("warehouse_id"));
                    lr.setLeaveTypeId(rs.getInt("leave_type_id"));
                    lr.setStartDate(rs.getDate("start_date"));
                    lr.setEndDate(rs.getDate("end_date"));
                    lr.setReason(rs.getString("reason"));
                    lr.setCreatedAt(rs.getTimestamp("created_at"));
                    lr.setUpdatedAt(rs.getTimestamp("updated_at"));
                    lr.setStatus(rs.getString("status"));
                    lr.setApprovedBy(rs.getInt("approved_by"));
                    lr.setApprovedAt(rs.getTimestamp("approved_at"));
                    lr.setManagerNotes(rs.getString("manager_notes"));
                    lr.setLeaveTypeName(rs.getString("leave_type_name"));
                    leaveRequests.add(lr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return leaveRequests;
    }

    // Method to get a single leave request by its ID
    public LeaveRequest getLeaveRequestById(int requestId) {
        LeaveRequest lr = null;
        String sql = "SELECT * FROM Leave_Request WHERE request_id = ?";

        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    lr = new LeaveRequest();
                    lr.setRequestId(rs.getInt("request_id"));
                    lr.setRequestCode(rs.getString("request_code"));
                    lr.setEmployeeId(rs.getInt("employee_id"));
                    lr.setWarehouseId(rs.getInt("warehouse_id"));
                    lr.setLeaveTypeId(rs.getInt("leave_type_id"));
                    lr.setStartDate(rs.getDate("start_date"));
                    lr.setEndDate(rs.getDate("end_date"));
                    lr.setReason(rs.getString("reason"));
                    lr.setCreatedAt(rs.getTimestamp("created_at"));
                    lr.setUpdatedAt(rs.getTimestamp("updated_at"));
                    lr.setStatus(rs.getString("status"));
                    lr.setApprovedBy(rs.getInt("approved_by"));
                    lr.setApprovedAt(rs.getTimestamp("approved_at"));
                    lr.setManagerNotes(rs.getString("manager_notes"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lr;
    }

    // Method to add a new leave request
    public boolean addLeaveRequest(LeaveRequest request) {
        String sql = "INSERT INTO Leave_Request (employee_id, warehouse_id, leave_type_id, start_date, end_date, reason, status, request_code) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'draft', ?)";
        
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, request.getEmployeeId());
            ps.setInt(2, request.getWarehouseId());
            ps.setInt(3, request.getLeaveTypeId());
            ps.setDate(4, request.getStartDate());
            ps.setDate(5, request.getEndDate());
            ps.setString(6, request.getReason());
            ps.setString(7, "LR" + System.currentTimeMillis());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to update an existing leave request
    public boolean updateLeaveRequest(LeaveRequest request) {
        String sql = "UPDATE Leave_Request SET leave_type_id = ?, start_date = ?, end_date = ?, reason = ?, updated_at = GETDATE() " +
                     "WHERE request_id = ? AND status = 'draft'";
        
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, request.getLeaveTypeId());
            ps.setDate(2, request.getStartDate());
            ps.setDate(3, request.getEndDate());
            ps.setString(4, request.getReason());
            ps.setInt(5, request.getRequestId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to delete a leave request
    public boolean deleteLeaveRequest(int requestId) {
        String sql = "DELETE FROM Leave_Request WHERE request_id = ? AND status = 'draft'";
        
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
