-- =============================================
-- Mini HRM System - Database Script
-- Database: Assignment
-- =============================================

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Assignment')
    DROP DATABASE Assignment;
GO

CREATE DATABASE Assignment;
GO

USE Assignment;
GO

-- 1. Departments
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

-- 2. Roles
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);

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

-- 4. LeaveTypes
CREATE TABLE LeaveTypes (
    LeaveTypeID INT IDENTITY(1,1) PRIMARY KEY,
    LeaveTypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    MaxDays INT NOT NULL
);

-- 5. LeaveRequests
CREATE TABLE LeaveRequests (
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LeaveTypeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Reason NVARCHAR(500),
    Status VARCHAR(20) DEFAULT 'Pending', -- Draft, Pending, Approved, Rejected
    ManagerComment NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    CONSTRAINT FK_LeaveRequests_User FOREIGN KEY(UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_LeaveRequests_LeaveType FOREIGN KEY(LeaveTypeID) REFERENCES LeaveTypes(LeaveTypeID)
);

-- 6. WorkSchedules
CREATE TABLE WorkSchedules (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    WorkDate DATE NOT NULL,
    Shift VARCHAR(20) NOT NULL, -- Morning, Afternoon, Evening
    Status VARCHAR(20) DEFAULT 'Pending', -- Pending, Approved, Rejected
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
    AttendanceDate DATE DEFAULT CAST(GETDATE() AS DATE),
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

-- =============================================
-- SAMPLE DATA
-- =============================================

-- Departments
INSERT INTO Departments (DepartmentName, Description) VALUES
(N'Administration', N'Ban Giám đốc và Quản trị hệ thống'),
(N'Human Resources', N'Phòng Nhân sự'),
(N'IT', N'Phòng Công nghệ thông tin'),
(N'Finance', N'Phòng Tài chính Kế toán'),
(N'Marketing', N'Phòng Marketing'),
(N'Sales', N'Phòng Kinh doanh');

-- Roles
INSERT INTO Roles(RoleName) VALUES ('Admin'), ('Manager'), ('Employee');

-- Users (password plain text for development)
INSERT INTO Users (FullName, Email, Phone, Password, RoleID, DepartmentID) VALUES
(N'Administrator', 'admin@company.com', '0123456789', 'admin123', 1, 1),
(N'Nguyễn Văn Quản Lý', 'manager@company.com', '0987654321', 'manager123', 2, 2),
(N'Trần Thị Nhân Viên', 'employee@company.com', '0912345678', 'employee123', 3, 3),
(N'Lê Hoàng Minh', 'minh.le@company.com', '0901234567', 'employee123', 3, 3),
(N'Phạm Thị Hoa', 'hoa.pham@company.com', '0918765432', 'employee123', 3, 4),
(N'Đặng Văn Nam', 'nam.dang@company.com', '0923456789', 'employee123', 3, 5),
(N'Vũ Thị Lan', 'lan.vu@company.com', '0934567890', 'manager123', 2, 3),
(N'Hoàng Minh Tuấn', 'tuan.hoang@company.com', '0945678901', 'employee123', 3, 6);

-- LeaveTypes
INSERT INTO LeaveTypes (LeaveTypeName, Description, MaxDays) VALUES
(N'Nghỉ phép năm', N'Nghỉ phép hưởng lương theo quy định', 12),
(N'Nghỉ bệnh', N'Nghỉ do sức khỏe, có giấy xác nhận', 30),
(N'Nghỉ không lương', N'Nghỉ việc cá nhân không hưởng lương', 365),
(N'Nghỉ thai sản', N'Nghỉ thai sản theo luật lao động', 180),
(N'Nghỉ cưới', N'Nghỉ phép kết hôn', 3);

-- Sample LeaveRequests
INSERT INTO LeaveRequests (UserID, LeaveTypeID, StartDate, EndDate, Reason, Status, CreatedAt) VALUES
(3, 1, '2026-06-05', '2026-06-06', N'Nghỉ phép đi du lịch cùng gia đình', 'Pending', GETDATE()),
(4, 2, '2026-06-03', '2026-06-04', N'Bị cảm cúm, cần nghỉ ngơi', 'Approved', GETDATE()),
(5, 1, '2026-06-10', '2026-06-12', N'Về quê thăm gia đình', 'Pending', GETDATE()),
(3, 3, '2026-07-01', '2026-07-03', N'Nghỉ việc riêng', 'Draft', GETDATE()),
(6, 1, '2026-06-15', '2026-06-16', N'Nghỉ phép cá nhân', 'Rejected', GETDATE());

-- Sample WorkSchedules
INSERT INTO WorkSchedules (UserID, WorkDate, Shift, Status, Note) VALUES
(3, '2026-06-02', 'Morning', 'Approved', N'Ca sáng bình thường'),
(3, '2026-06-03', 'Afternoon', 'Pending', N'Đổi ca chiều'),
(4, '2026-06-02', 'Morning', 'Approved', NULL),
(5, '2026-06-02', 'Evening', 'Pending', N'Đăng ký ca tối'),
(6, '2026-06-04', 'Morning', 'Approved', NULL);

-- Sample Attendance
INSERT INTO Attendance (UserID, CheckIn, CheckOut, WorkHours, AttendanceDate) VALUES
(3, '2026-06-02 08:00:00', '2026-06-02 17:00:00', 9.0, '2026-06-02'),
(4, '2026-06-02 08:15:00', '2026-06-02 17:30:00', 9.25, '2026-06-02'),
(5, '2026-06-02 07:50:00', NULL, NULL, '2026-06-02');

-- Sample Agenda
INSERT INTO Agenda (Title, Description, StartTime, EndTime, CreatedBy) VALUES
(N'Họp team IT hàng tuần', N'Review tiến độ dự án và phân công công việc mới', '2026-06-03 09:00:00', '2026-06-03 10:00:00', 1),
(N'Training nhân viên mới', N'Đào tạo quy trình làm việc cho nhân viên mới', '2026-06-04 14:00:00', '2026-06-04 16:00:00', 2),
(N'Họp review quý 2', N'Đánh giá kết quả kinh doanh quý 2/2026', '2026-06-06 08:30:00', '2026-06-06 11:30:00', 1);

PRINT 'Database Assignment created successfully!';
