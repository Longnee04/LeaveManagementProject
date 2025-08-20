package dao;

import model.Role;
import dao.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {
    private DBConnect dbConnect;
    
    public RoleDAO() {
        dbConnect = new DBConnect();
    }
    
    public List<Role> getAllRoles() {
        List<Role> roleList = new ArrayList<>();
        String sql = "SELECT * FROM Role";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                
                roleList.add(role);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all roles: " + e.getMessage());
        }
        
        return roleList;
    }
    
    public Role getRoleById(int roleId) {
        String sql = "SELECT * FROM Role WHERE role_id = ?";
        
        try (PreparedStatement ps = dbConnect.connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    
                    return role;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting role by ID: " + e.getMessage());
        }
        
        return null;
    }
}