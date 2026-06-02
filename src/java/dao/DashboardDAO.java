package dao;

import models.LeaveRequest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO extends DBContext {

    // Đếm số lượng nhân viên hoạt động
    public int getTotalEmployees() {
        String sql = "SELECT COUNT(*) FROM Users WHERE Status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in DashboardDAO.getTotalEmployees: " + e.getMessage());
        }
        return 0;
    }

    // Đếm tổng số đơn nghỉ phép
    public int getTotalLeaveRequests() {
        String sql = "SELECT COUNT(*) FROM LeaveRequests";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in DashboardDAO.getTotalLeaveRequests: " + e.getMessage());
        }
        return 0;
    }

    // Đếm số đơn nghỉ phép chờ duyệt
    public int getPendingLeaveCount() {
        String sql = "SELECT COUNT(*) FROM LeaveRequests WHERE Status = 'Pending'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in DashboardDAO.getPendingLeaveCount: " + e.getMessage());
        }
        return 0;
    }

    // Đếm số nhân viên nghỉ phép ngày hôm nay
    public int getTodayLeaveCount() {
        String sql = "SELECT COUNT(*) FROM LeaveRequests WHERE CAST(GETDATE() AS DATE) BETWEEN StartDate AND EndDate AND Status = 'Approved'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in DashboardDAO.getTodayLeaveCount: " + e.getMessage());
        }
        return 0;
    }

    // Đếm số đăng ký lịch làm việc đang chờ duyệt
    public int getPendingScheduleCount() {
        String sql = "SELECT COUNT(*) FROM WorkSchedules WHERE Status = 'Pending'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in DashboardDAO.getPendingScheduleCount: " + e.getMessage());
        }
        return 0;
    }

    // Lấy danh sách các đơn nghỉ phép gần đây nhất
    public List<LeaveRequest> getRecentLeaveRequests(int limit) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = """
            SELECT TOP (?) lr.RequestID, lr.UserID, lr.LeaveTypeID, lr.StartDate, lr.EndDate,
                   lr.Reason, lr.Status, lr.ManagerComment, lr.CreatedAt, lr.UpdatedAt,
                   u.FullName AS EmployeeName, u.Email AS EmployeeEmail, lt.LeaveTypeName
            FROM LeaveRequests lr
            INNER JOIN Users u ON lr.UserID = u.UserID
            INNER JOIN LeaveTypes lt ON lr.LeaveTypeID = lt.LeaveTypeID
            ORDER BY lr.CreatedAt DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    LeaveRequest req = new LeaveRequest();
                    req.setRequestID(rs.getInt("RequestID"));
                    req.setUserID(rs.getInt("UserID"));
                    req.setLeaveTypeID(rs.getInt("LeaveTypeID"));
                    req.setStartDate(rs.getDate("StartDate"));
                    req.setEndDate(rs.getDate("EndDate"));
                    req.setReason(rs.getString("Reason"));
                    req.setStatus(rs.getString("Status"));
                    req.setManagerComment(rs.getString("ManagerComment"));
                    req.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    req.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    req.setEmployeeName(rs.getString("EmployeeName"));
                    req.setEmployeeEmail(rs.getString("EmployeeEmail"));
                    req.setLeaveTypeName(rs.getString("LeaveTypeName"));
                    list.add(req);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in DashboardDAO.getRecentLeaveRequests: " + e.getMessage());
        }
        return list;
    }
}
