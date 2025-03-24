# Leave Management System

## Overview
The Leave Management System is a web application that allows employees to create leave requests and enables managers to view the history of these requests. The application is built using Java Servlets, JSP, and a relational database for data storage.

## Project Structure
```
LeaveManagement
├── src
│   ├── controller
│   │   ├── CreateLeaveRequestServlet.java
│   │   ├── LeaveHistoryServlet.java
│   │   └── UpdateLeaveRequestServlet.java
│   ├── dao
│   │   ├── LeaveRequestDAO.java
│   │   └── UserDAO.java
│   ├── db
│   │   └── DBConnection.java
│   ├── model
│   │   ├── LeaveRequest.java
│   │   └── User.java
├── web
│   ├── CSS
│   │   └── Edashboard.css
│   ├── employee_dashboard.jsp
│   ├── create_leave_request.jsp
│   ├── edit_leave_request.jsp
│   ├── manager_dashboard.jsp
│   ├── view_leave_requests.jsp
│   ├── login.jsp
│   └── LogoutServlet.java
├── WEB-INF
│   ├── web.xml
├── README.md
└── pom.xml
```

## Features
- **Employee Dashboard**: Employees can log in to view their dashboard, create new leave requests, and edit existing requests.
- **Leave Request Creation**: Employees can fill out a form to submit new leave requests, including selecting leave type, start and end dates, and providing a reason.
- **Leave Request History**: Employees can view the history of their leave requests, including status updates and manager notes.
- **Manager Dashboard**: Managers can log in to view all leave requests submitted by their team members.

## Setup Instructions
1. **Clone the Repository**: Clone this repository to your local machine.
2. **Database Setup**: Set up a relational database and configure the connection in `DBConnection.java`.
3. **Build the Project**: Use Maven to build the project. Run `mvn clean install` in the project root directory.
4. **Deploy the Application**: Deploy the application on a servlet container such as Apache Tomcat.
5. **Access the Application**: Open a web browser and navigate to `http://localhost:8080/LeaveManagement`.

## Technologies Used
- Java
- JSP (JavaServer Pages)
- Servlets
- MySQL (or any relational database)
- HTML/CSS
- Bootstrap for responsive design

## Contribution
Feel free to fork the repository and submit pull requests for any improvements or bug fixes.