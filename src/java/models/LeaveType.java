package models;

public class LeaveType {
    private int leaveTypeID;
    private String leaveTypeName;
    private String description;
    private int maxDays;

    public int getLeaveTypeID() { return leaveTypeID; }
    public void setLeaveTypeID(int leaveTypeID) { this.leaveTypeID = leaveTypeID; }

    public String getLeaveTypeName() { return leaveTypeName; }
    public void setLeaveTypeName(String leaveTypeName) { this.leaveTypeName = leaveTypeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getMaxDays() { return maxDays; }
    public void setMaxDays(int maxDays) { this.maxDays = maxDays; }
}
