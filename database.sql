CREATE DATABASE LeaveManagement;
GO

USE LeaveManagement;
GO

-- 1. Departments (Added for better normalization)
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

INSERT INTO Departments (DepartmentName, Description)
VALUES 
(N'Administration', N'Ban Giám đốc và Quản trị hệ thống'),
(N'Human Resources', N'Phòng Nhân sự'),
(N'IT', N'Phòng Công nghệ thông tin'),
(N'Finance', N'Phòng Tài chính Kế toán');

-- 2. Roles
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Roles(RoleName)
VALUES
('Admin'),
('Manager'),
('Employee');

-- 3. Users
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Password VARCHAR(255) NOT NULL,
    RoleID INT NOT NULL,
    DepartmentID INT,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_User_Role FOREIGN KEY(RoleID) REFERENCES Roles(RoleID),
    CONSTRAINT FK_User_Department FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Admin Account
INSERT INTO Users (FullName, Email, Phone, Password, RoleID, DepartmentID)
VALUES (N'Administrator', 'admin@company.com', '0123456789', 'admin123', 1, 1);

-- 4. LeaveTypes
CREATE TABLE LeaveTypes (
    LeaveTypeID INT IDENTITY(1,1) PRIMARY KEY,
    LeaveTypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    MaxDays INT NOT NULL
);

INSERT INTO LeaveTypes (LeaveTypeName, Description, MaxDays)
VALUES
(N'Nghỉ phép năm', N'Nghỉ phép hưởng lương', 12),
(N'Nghỉ bệnh', N'Nghỉ do sức khỏe', 30),
(N'Nghỉ không lương', N'Nghỉ cá nhân', 365);

-- 5. LeaveRequests
CREATE TABLE LeaveRequests (
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LeaveTypeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Reason NVARCHAR(500),
    Status VARCHAR(20) DEFAULT 'Pending',
    ManagerComment NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_LeaveRequests_User FOREIGN KEY(UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_LeaveRequests_LeaveType FOREIGN KEY(LeaveTypeID) REFERENCES LeaveTypes(LeaveTypeID)
);

-- 6. WorkSchedules
CREATE TABLE WorkSchedules (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    WorkDate DATE NOT NULL,
    Shift VARCHAR(20) NOT NULL, -- Morning, Afternoon, Evening
    Status VARCHAR(20) DEFAULT 'Pending',
    Note NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_WorkSchedules_User FOREIGN KEY(UserID) REFERENCES Users(UserID)
);

-- 7. Attendance
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CheckIn DATETIME,
    CheckOut DATETIME,
    WorkHours FLOAT,
    AttendanceDate DATE DEFAULT GETDATE(),

    CONSTRAINT FK_Attendance_User FOREIGN KEY(UserID) REFERENCES Users(UserID)
);

-- 8. Agenda
CREATE TABLE Agenda (
    AgendaID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    StartTime DATETIME,
    EndTime DATETIME,
    CreatedBy INT,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Agenda_User FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
);

-- 9. Notifications
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    Title NVARCHAR(200),
    Message NVARCHAR(MAX),
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Notifications_User FOREIGN KEY(UserID) REFERENCES Users(UserID)
);
