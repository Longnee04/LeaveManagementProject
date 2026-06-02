package models;

public class Department {
    private int departmentID;
    private String departmentName;
    private String description;

    public Department() {}

    public Department(int departmentID, String departmentName, String description) {
        this.departmentID = departmentID;
        this.departmentName = departmentName;
        this.description = description;
    }

    public int getDepartmentID() { return departmentID; }
    public void setDepartmentID(int departmentID) { this.departmentID = departmentID; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
