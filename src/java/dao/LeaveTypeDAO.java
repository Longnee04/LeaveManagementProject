package dao;

import model.LeaveType;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LeaveTypeDAO {
    private Connection connection;
    
    public LeaveTypeDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Create a new leave type
    public boolean createLeaveType(LeaveType leaveType) {
        String sql = "INSERT INTO Leave_Type (leave_type_name, description, is_active, created_at, last_updated) VALUES (?, ?, ?, GETDATE(), GETDATE()); SELECT SCOPE_IDENTITY();";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setNString(1, leaveType.getLeaveTypeName());
            stmt.setNString(2, leaveType.getDescription());
            stmt.setBoolean(3, leaveType.getIsActive());
            
            boolean hasResultSet = stmt.execute();
            if (hasResultSet) {
                try (ResultSet rs = stmt.getResultSet()) {
                    if (rs.next()) {
                        leaveType.setLeaveTypeId(rs.getInt(1));
                        return true;
                    }
                }
            } else {
                // Fallback in case driver treats it as update count first
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs != null && rs.next()) {
                        leaveType.setLeaveTypeId(rs.getInt(1));
                        return true;
                    }
                } catch (SQLException ignore) {}
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get all leave types
    public List<LeaveType> getAllLeaveTypes() {
        List<LeaveType> leaveTypes = new ArrayList<>();
        String sql = "SELECT leave_type_id, leave_type_name, description, is_active, created_at, last_updated FROM Leave_Type ORDER BY leave_type_id";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                LeaveType leaveType = new LeaveType();
                leaveType.setLeaveTypeId(rs.getInt("leave_type_id"));
                leaveType.setLeaveTypeName(rs.getNString("leave_type_name"));
                leaveType.setDescription(rs.getNString("description"));
                leaveType.setIsActive(rs.getBoolean("is_active"));
                leaveType.setCreatedAt(rs.getTimestamp("created_at"));
                leaveType.setLastUpdated(rs.getTimestamp("last_updated"));
                
                leaveTypes.add(leaveType);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return leaveTypes;
    }
    
    // Get leave type by ID
    public LeaveType getLeaveTypeById(int leaveTypeId) {
        String sql = "SELECT leave_type_id, leave_type_name, description, is_active, created_at, last_updated FROM Leave_Type WHERE leave_type_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, leaveTypeId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    LeaveType leaveType = new LeaveType();
                    leaveType.setLeaveTypeId(rs.getInt("leave_type_id"));
                    leaveType.setLeaveTypeName(rs.getNString("leave_type_name"));
                    leaveType.setDescription(rs.getNString("description"));
                    leaveType.setIsActive(rs.getBoolean("is_active"));
                    leaveType.setCreatedAt(rs.getTimestamp("created_at"));
                    leaveType.setLastUpdated(rs.getTimestamp("last_updated"));
                    
                    return leaveType;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Update leave type
    public boolean updateLeaveType(LeaveType leaveType) {
        String sql = "UPDATE Leave_Type SET leave_type_name = ?, description = ?, is_active = ?, last_updated = GETDATE() WHERE leave_type_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setNString(1, leaveType.getLeaveTypeName());
            stmt.setNString(2, leaveType.getDescription());
            stmt.setBoolean(3, leaveType.getIsActive());
            stmt.setInt(4, leaveType.getLeaveTypeId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Delete leave type
    public boolean deleteLeaveType(int leaveTypeId) {
        String sql = "DELETE FROM Leave_Type WHERE leave_type_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, leaveTypeId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Check if leave type name already exists
    public boolean isLeaveTypeNameExists(String leaveTypeName) {
        String sql = "SELECT COUNT(*) FROM Leave_Type WHERE leave_type_name = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setNString(1, leaveTypeName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // Dashboard helpers
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Leave_Type";
        try (Statement st = connection.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countActive() {
        String sql = "SELECT COUNT(*) FROM Leave_Type WHERE is_active = 1";
        try (Statement st = connection.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<LeaveType> getLatest(int limit) {
        List<LeaveType> list = new ArrayList<>();
        String sql = "SELECT TOP " + Math.max(1, limit) + " leave_type_id, leave_type_name, description, is_active, created_at, last_updated FROM Leave_Type ORDER BY last_updated DESC, created_at DESC";
        try (Statement st = connection.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                LeaveType lt = new LeaveType();
                lt.setLeaveTypeId(rs.getInt("leave_type_id"));
                lt.setLeaveTypeName(rs.getNString("leave_type_name"));
                lt.setDescription(rs.getNString("description"));
                lt.setIsActive(rs.getBoolean("is_active"));
                lt.setCreatedAt(rs.getTimestamp("created_at"));
                lt.setLastUpdated(rs.getTimestamp("last_updated"));
                list.add(lt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
