package models;

import java.sql.Timestamp;

public class User {
    private int userID;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private int roleID;
    private String roleName;
    private int departmentID;
    private String departmentName;
    private boolean status;
    private Timestamp createdAt;

    public User() {
    }

    public User(int userID, String fullName, String email, String phone, String password, int roleID, int departmentID, boolean status) {
        this.userID = userID;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.roleID = roleID;
        this.departmentID = departmentID;
        this.status = status;
    }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public int getRoleID() { return roleID; }
    public void setRoleID(int roleID) { this.roleID = roleID; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public int getDepartmentID() { return departmentID; }
    public void setDepartmentID(int departmentID) { this.departmentID = departmentID; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
