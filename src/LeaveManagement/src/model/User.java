package model;

import java.util.Date;

public class User {
    private int userID;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;
    private String department;
    private String phone;
    private String gender;
    private Date dob;
    private String address;
    private Date createdAt;

    // Default constructor
    public User() {
    }

    // Parameterized constructor
    public User(int userID, String username, String password, String fullName, String email, String role,
                String department, String phone, String gender, Date dob, String address, Date createdAt) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.department = department;
        this.phone = phone;
        this.gender = gender;
        this.dob = dob;
        this.address = address;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // Optional toString method
    @Override
    public String toString() {
        return "User{" +
                "userID=" + userID +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", department='" + department + '\'' +
                ", phone='" + phone + '\'' +
                ", gender='" + gender + '\'' +
                ", dob=" + dob +
                ", address='" + address + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}