package models;

import java.sql.Date;
import java.sql.Timestamp;

public class Attendance {
    private int attendanceID;
    private int userID;
    private String employeeName;
    private Timestamp checkIn;
    private Timestamp checkOut;
    private double workHours;
    private Date attendanceDate;

    public Attendance() {}

    public int getAttendanceID() { return attendanceID; }
    public void setAttendanceID(int attendanceID) { this.attendanceID = attendanceID; }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public Timestamp getCheckIn() { return checkIn; }
    public void setCheckIn(Timestamp checkIn) { this.checkIn = checkIn; }

    public Timestamp getCheckOut() { return checkOut; }
    public void setCheckOut(Timestamp checkOut) { this.checkOut = checkOut; }

    public double getWorkHours() { return workHours; }
    public void setWorkHours(double workHours) { this.workHours = workHours; }

    public Date getAttendanceDate() { return attendanceDate; }
    public void setAttendanceDate(Date attendanceDate) { this.attendanceDate = attendanceDate; }
}
