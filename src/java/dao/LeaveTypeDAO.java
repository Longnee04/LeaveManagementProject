package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.LeaveType;

public class LeaveTypeDAO extends DBContext {

    public List<LeaveType> findAll() {
        List<LeaveType> list = new ArrayList<>();
        String sql = "SELECT LeaveTypeID, LeaveTypeName, Description, MaxDays, IsWorkingDaysOnly, NewEmployeeRestricted, MinUnit FROM LeaveTypes ORDER BY LeaveTypeName";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in findAll: " + e.getMessage());
        }
        return list;
    }

    public LeaveType findById(int id) {
        String sql = "SELECT LeaveTypeID, LeaveTypeName, Description, MaxDays, IsWorkingDaysOnly, NewEmployeeRestricted, MinUnit FROM LeaveTypes WHERE LeaveTypeID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in findById: " + e.getMessage());
        }
        return null;
    }

    // Thêm loại nghỉ phép mới
    public int insert(LeaveType type) {
        String sql = "INSERT INTO LeaveTypes (LeaveTypeName, Description, MaxDays, IsWorkingDaysOnly, NewEmployeeRestricted, MinUnit) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, type.getLeaveTypeName());
            st.setString(2, type.getDescription());
            st.setInt(3, type.getMaxDays());
            st.setBoolean(4, type.isIsWorkingDaysOnly());
            st.setBoolean(5, type.isNewEmployeeRestricted());
            st.setString(6, type.getMinUnit());
            
            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in insert: " + e.getMessage());
        }
        return -1;
    }

    // Cập nhật loại nghỉ phép
    public boolean update(LeaveType type) {
        String sql = "UPDATE LeaveTypes SET LeaveTypeName = ?, Description = ?, MaxDays = ?, IsWorkingDaysOnly = ?, NewEmployeeRestricted = ?, MinUnit = ? WHERE LeaveTypeID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, type.getLeaveTypeName());
            st.setString(2, type.getDescription());
            st.setInt(3, type.getMaxDays());
            st.setBoolean(4, type.isIsWorkingDaysOnly());
            st.setBoolean(5, type.isNewEmployeeRestricted());
            st.setString(6, type.getMinUnit());
            st.setInt(7, type.getLeaveTypeID());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in update: " + e.getMessage());
        }
        return false;
    }

    // Xóa loại nghỉ phép
    public boolean delete(int id) {
        String sql = "DELETE FROM LeaveTypes WHERE LeaveTypeID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in delete: " + e.getMessage());
        }
        return false;
    }

    private LeaveType mapRow(ResultSet rs) throws SQLException {
        LeaveType type = new LeaveType();
        type.setLeaveTypeID(rs.getInt("LeaveTypeID"));
        type.setLeaveTypeName(rs.getString("LeaveTypeName"));
        type.setDescription(rs.getString("Description"));
        type.setMaxDays(rs.getInt("MaxDays"));
        type.setIsWorkingDaysOnly(rs.getBoolean("IsWorkingDaysOnly"));
        type.setNewEmployeeRestricted(rs.getBoolean("NewEmployeeRestricted"));
        type.setMinUnit(rs.getString("MinUnit"));
        return type;
    }
}
