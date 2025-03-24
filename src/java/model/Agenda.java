package model;

import java.util.Date;

public class Agenda {
    private int agendaID;
    private int userID;
    private String username;
    private Date workDate;
    private String status;

    // Getters and Setters
    public int getAgendaID() {
        return agendaID;
    }

    public void setAgendaID(int agendaID) {
        this.agendaID = agendaID;
    }

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

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}