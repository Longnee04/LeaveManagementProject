package models;

public class EmployeeLeaveBalance {
    private int userID;
    private int leaveTypeID;
    private String leaveTypeName; // Optional for display
    private double annualQuota;
    private double usedDays;
    private double remainingDays;

    public EmployeeLeaveBalance() {
    }

    public EmployeeLeaveBalance(int userID, int leaveTypeID, double annualQuota, double usedDays, double remainingDays) {
        this.userID = userID;
        this.leaveTypeID = leaveTypeID;
        this.annualQuota = annualQuota;
        this.usedDays = usedDays;
        this.remainingDays = remainingDays;
    }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public int getLeaveTypeID() { return leaveTypeID; }
    public void setLeaveTypeID(int leaveTypeID) { this.leaveTypeID = leaveTypeID; }

    public String getLeaveTypeName() { return leaveTypeName; }
    public void setLeaveTypeName(String leaveTypeName) { this.leaveTypeName = leaveTypeName; }

    public double getAnnualQuota() { return annualQuota; }
    public void setAnnualQuota(double annualQuota) { this.annualQuota = annualQuota; }

    public double getUsedDays() { return usedDays; }
    public void setUsedDays(double usedDays) { this.usedDays = usedDays; }

    public double getRemainingDays() { return remainingDays; }
    public void setRemainingDays(double remainingDays) { this.remainingDays = remainingDays; }
}
