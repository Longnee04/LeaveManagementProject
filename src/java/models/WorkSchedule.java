package models;

import java.sql.Date;
import java.sql.Timestamp;

public class WorkSchedule {
    private int scheduleID;
    private int userID;
    private String employeeName;
    private Date workDate;
    private String shift;
    private String status;
    private String note;
    private Timestamp createdAt;

    public WorkSchedule() {}

    public int getScheduleID() { return scheduleID; }
    public void setScheduleID(int scheduleID) { this.scheduleID = scheduleID; }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public Date getWorkDate() { return workDate; }
    public void setWorkDate(Date workDate) { this.workDate = workDate; }

    public String getShift() { return shift; }
    public void setShift(String shift) { this.shift = shift; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
