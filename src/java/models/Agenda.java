package models;

import java.sql.Timestamp;

public class Agenda {
    private int agendaID;
    private String title;
    private String description;
    private Timestamp startTime;
    private Timestamp endTime;
    private int createdBy;
    private String creatorName;
    private Timestamp createdAt;

    public Agenda() {}

    public int getAgendaID() { return agendaID; }
    public void setAgendaID(int agendaID) { this.agendaID = agendaID; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }

    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public String getCreatorName() { return creatorName; }
    public void setCreatorName(String creatorName) { this.creatorName = creatorName; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
