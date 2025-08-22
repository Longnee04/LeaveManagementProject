package model;

import java.sql.Timestamp;

public class LeaveType {
    private int leaveTypeId;
    private String leaveTypeName;
    private String description;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp lastUpdated;
    
    public LeaveType() {
    }
    
    public LeaveType(int leaveTypeId, String leaveTypeName, String description, boolean isActive) {
        this.leaveTypeId = leaveTypeId;
        this.leaveTypeName = leaveTypeName;
        this.description = description;
        this.isActive = isActive;
    }
    
    public LeaveType(String leaveTypeName, String description, boolean isActive) {
        this.leaveTypeName = leaveTypeName;
        this.description = description;
        this.isActive = isActive;
    }

    public LeaveType(int leaveTypeId, String leaveTypeName, String description, boolean isActive, Timestamp createdAt, Timestamp lastUpdated) {
        this.leaveTypeId = leaveTypeId;
        this.leaveTypeName = leaveTypeName;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.lastUpdated = lastUpdated;
    }
    
    public int getLeaveTypeId() {
        return leaveTypeId;
    }
    
    public void setLeaveTypeId(int leaveTypeId) {
        this.leaveTypeId = leaveTypeId;
    }
    
    public String getLeaveTypeName() {
        return leaveTypeName;
    }
    
    public void setLeaveTypeName(String leaveTypeName) {
        this.leaveTypeName = leaveTypeName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    @Override
    public String toString() {
        return "LeaveType{" +
                "leaveTypeId=" + leaveTypeId +
                ", leaveTypeName='" + leaveTypeName + '\'' +
                ", description='" + description + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                ", lastUpdated=" + lastUpdated +
                '}';
    }
}
