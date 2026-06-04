package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.EmployeeLeaveBalance;

public class EmployeeLeaveBalanceDAO extends DBContext {

    // Lấy toàn bộ số dư nghỉ phép của 1 nhân viên
    public List<EmployeeLeaveBalance> findByUserId(int userId) {
        List<EmployeeLeaveBalance> list = new ArrayList<>();
        String sql = """
            SELECT elb.UserID, elb.LeaveTypeID, lt.LeaveTypeName, 
                   elb.AnnualQuota, elb.UsedDays, elb.RemainingDays
            FROM EmployeeLeaveBalances elb
            INNER JOIN LeaveTypes lt ON elb.LeaveTypeID = lt.LeaveTypeID
            WHERE elb.UserID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    EmployeeLeaveBalance elb = new EmployeeLeaveBalance();
                    elb.setUserID(rs.getInt("UserID"));
                    elb.setLeaveTypeID(rs.getInt("LeaveTypeID"));
                    elb.setLeaveTypeName(rs.getString("LeaveTypeName"));
                    elb.setAnnualQuota(rs.getDouble("AnnualQuota"));
                    elb.setUsedDays(rs.getDouble("UsedDays"));
                    elb.setRemainingDays(rs.getDouble("RemainingDays"));
                    list.add(elb);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in findByUserId: " + e.getMessage());
        }
        return list;
    }

    // Lấy số dư nghỉ phép cụ thể của 1 loại phép cho 1 nhân viên
    public EmployeeLeaveBalance findByUserAndLeaveType(int userId, int leaveTypeId) {
        String sql = """
            SELECT elb.UserID, elb.LeaveTypeID, lt.LeaveTypeName, 
                   elb.AnnualQuota, elb.UsedDays, elb.RemainingDays
            FROM EmployeeLeaveBalances elb
            INNER JOIN LeaveTypes lt ON elb.LeaveTypeID = lt.LeaveTypeID
            WHERE elb.UserID = ? AND elb.LeaveTypeID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, leaveTypeId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    EmployeeLeaveBalance elb = new EmployeeLeaveBalance();
                    elb.setUserID(rs.getInt("UserID"));
                    elb.setLeaveTypeID(rs.getInt("LeaveTypeID"));
                    elb.setLeaveTypeName(rs.getString("LeaveTypeName"));
                    elb.setAnnualQuota(rs.getDouble("AnnualQuota"));
                    elb.setUsedDays(rs.getDouble("UsedDays"));
                    elb.setRemainingDays(rs.getDouble("RemainingDays"));
                    return elb;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in findByUserAndLeaveType: " + e.getMessage());
        }
        return null;
    }

    // Cập nhật số ngày đã nghỉ và số ngày còn lại (khi đơn được duyệt)
    public boolean updateBalance(int userId, int leaveTypeId, double durationChange) {
        String sql = """
            UPDATE EmployeeLeaveBalances
            SET UsedDays = UsedDays + ?,
                RemainingDays = RemainingDays - ?
            WHERE UserID = ? AND LeaveTypeID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDouble(1, durationChange);
            st.setDouble(2, durationChange);
            st.setInt(3, userId);
            st.setInt(4, leaveTypeId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateBalance: " + e.getMessage());
        }
        return false;
    }

    // Khởi tạo bảng số dư cho 1 nhân viên mới dựa trên các loại nghỉ phép hiện có
    public boolean initBalancesForUser(int userId) {
        String sql = """
            INSERT INTO EmployeeLeaveBalances (UserID, LeaveTypeID, AnnualQuota, UsedDays, RemainingDays)
            SELECT ?, LeaveTypeID, CAST(MaxDays AS FLOAT), 0.0, CAST(MaxDays AS FLOAT)
            FROM LeaveTypes
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in initBalancesForUser: " + e.getMessage());
        }
        return false;
    }

    // Admin điều chỉnh hạn mức số dư nghỉ phép
    public boolean adjustQuota(int userId, int leaveTypeId, double newQuota, double newUsed) {
        String sql = """
            UPDATE EmployeeLeaveBalances
            SET AnnualQuota = ?,
                UsedDays = ?,
                RemainingDays = ? - ?
            WHERE UserID = ? AND LeaveTypeID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDouble(1, newQuota);
            st.setDouble(2, newUsed);
            st.setDouble(3, newQuota);
            st.setDouble(4, newUsed);
            st.setInt(5, userId);
            st.setInt(6, leaveTypeId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in adjustQuota: " + e.getMessage());
        }
        return false;
    }
}
