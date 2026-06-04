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
    Password VARCHAR(255) NOT NULL, -- Stored as SHA-256 uppercase hex string (64 characters)
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
    MaxDays INT NOT NULL,
    IsWorkingDaysOnly BIT DEFAULT 1,
    NewEmployeeRestricted BIT DEFAULT 0,
    MinUnit VARCHAR(20) DEFAULT 'Day' -- Day, Half-Day
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
    Duration FLOAT DEFAULT 1.0,
    MinUnitChosen VARCHAR(20) DEFAULT 'Full', -- Full, Morning, Afternoon
    CONSTRAINT FK_LeaveRequests_User FOREIGN KEY(UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_LeaveRequests_LeaveType FOREIGN KEY(LeaveTypeID) REFERENCES LeaveTypes(LeaveTypeID)
);

-- 6. EmployeeLeaveBalances
CREATE TABLE EmployeeLeaveBalances (
    UserID INT NOT NULL,
    LeaveTypeID INT NOT NULL,
    AnnualQuota FLOAT NOT NULL,
    UsedDays FLOAT NOT NULL DEFAULT 0.0,
    RemainingDays FLOAT NOT NULL,
    PRIMARY KEY (UserID, LeaveTypeID),
    CONSTRAINT FK_ELB_User FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_ELB_LeaveType FOREIGN KEY (LeaveTypeID) REFERENCES LeaveTypes(LeaveTypeID)
);

-- 7. WorkSchedules
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

-- 8. Attendance
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CheckIn DATETIME,
    CheckOut DATETIME,
    WorkHours FLOAT,
    AttendanceDate DATE DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT FK_Attendance_User FOREIGN KEY(UserID) REFERENCES Users(UserID)
);

-- 9. Agenda
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

-- 10. Notifications
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

-- Users (passwords hashed using SHA-256 uppercase)
-- admin123 -> 240BE518FABD2724DDB6F04EEB1DA5967448D7E831C08C8FA822809F74C720A9
-- manager123 -> 866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5
-- employee123 -> 5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF
INSERT INTO Users (FullName, Email, Phone, Password, RoleID, DepartmentID) VALUES
-- Department 1: Administration (Only 1 Admin account)
(N'Administrator', 'admin@company.com', '0123456789', '240BE518FABD2724DDB6F04EEB1DA5967448D7E831C08C8FA822809F74C720A9', 1, 1),

-- Department 2: Human Resources (1 Manager, 8 Employees = 9 members)
(N'Nguyễn Văn Quản Lý', 'manager@company.com', '0987654321', '866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5', 2, 2),
(N'Đỗ Hoàng Long', 'hr.staff1@company.com', '0911222333', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),
(N'Lê Thu Thủy', 'hr.staff2@company.com', '0912233444', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),
(N'Phạm Ngọc Hải', 'hr.staff3@company.com', '0913344555', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),
(N'Trần Minh Quân', 'hr.staff4@company.com', '0914455666', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),
(N'Nguyễn Khánh Ly', 'hr.staff5@company.com', '0915566777', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),
(N'Hoàng Thùy Linh', 'hr.staff6@company.com', '0916677888', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),
(N'Vũ Đức Trí', 'hr.staff7@company.com', '0917788999', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),
(N'Phan Thị Ngọc', 'hr.staff8@company.com', '0918899000', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 2),

-- Department 3: IT (1 Manager, 8 Employees = 9 members)
(N'Vũ Thị Lan', 'lan.vu@company.com', '0934567890', '866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5', 2, 3),
(N'Trần Thị Nhân Viên', 'employee@company.com', '0912345678', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),
(N'Lê Hoàng Minh', 'minh.le@company.com', '0901234567', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),
(N'Nguyễn Quang Hải', 'it.staff1@company.com', '0922333444', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),
(N'Trần Đình Trọng', 'it.staff2@company.com', '0923444555', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),
(N'Phan Văn Đức', 'it.staff3@company.com', '0924555666', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),
(N'Nguyễn Công Phượng', 'it.staff4@company.com', '0925666777', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),
(N'Lương Xuân Trường', 'it.staff5@company.com', '0926777888', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),
(N'Đỗ Hùng Dũng', 'it.staff6@company.com', '0927888999', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 3),

-- Department 4: Finance (1 Manager, 8 Employees = 9 members)
(N'Trần Văn Kế Toán', 'manager.finance@company.com', '0904445555', '866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5', 2, 4),
(N'Phạm Thị Hoa', 'hoa.pham@company.com', '0918765432', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),
(N'Nguyễn Thị Mai', 'fin.staff1@company.com', '0931222333', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),
(N'Đặng Hoàng Anh', 'fin.staff2@company.com', '0932233444', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),
(N'Lê Minh Triết', 'fin.staff3@company.com', '0933344555', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),
(N'Bùi Thị Tuyết', 'fin.staff4@company.com', '0934455666', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),
(N'Phùng Quang Thanh', 'fin.staff5@company.com', '0935566777', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),
(N'Đỗ Thị Quỳnh', 'fin.staff6@company.com', '0936677888', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),
(N'Ngô Gia Bảo', 'fin.staff7@company.com', '0937788999', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 4),

-- Department 5: Marketing (1 Manager, 8 Employees = 9 members)
(N'Phạm Văn Quảng Cáo', 'manager.marketing@company.com', '0905557777', '866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5', 2, 5),
(N'Đặng Văn Nam', 'nam.dang@company.com', '0923456789', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),
(N'Hoàng Minh Huy', 'mkt.staff1@company.com', '0941222333', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),
(N'Nguyễn Hà My', 'mkt.staff2@company.com', '0942233444', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),
(N'Trần Phương Thảo', 'mkt.staff3@company.com', '0943344555', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),
(N'Vũ Minh Anh', 'mkt.staff4@company.com', '0944455666', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),
(N'Phạm Hữu Đạt', 'mkt.staff5@company.com', '0945566777', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),
(N'Lê Thảo Nguyên', 'mkt.staff6@company.com', '0946677888', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),
(N'Trần Huy Hoàng', 'mkt.staff7@company.com', '0947788999', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 5),

-- Department 6: Sales (1 Manager, 8 Employees = 9 members)
(N'Lê Văn Bán Hàng', 'manager.sales@company.com', '0906668888', '866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5', 2, 6),
(N'Hoàng Minh Tuấn', 'tuan.hoang@company.com', '0945678901', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6),
(N'Nguyễn Hoài Thương', 'sales.staff1@company.com', '0951222333', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6),
(N'Bùi Xuân Huấn', 'sales.staff2@company.com', '0952233444', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6),
(N'Phạm Kim Chi', 'sales.staff3@company.com', '0953344555', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6),
(N'Trịnh Văn Quyết', 'sales.staff4@company.com', '0954455666', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6),
(N'Lê Thanh Thản', 'sales.staff5@company.com', '0955566777', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6),
(N'Nguyễn Đức An', 'sales.staff6@company.com', '0956677888', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6),
(N'Trần Thu Trang', 'sales.staff7@company.com', '0957788999', '5B2F8E27E2E5B4081C03CE70B288C87BD1263140CBD1BD9AE078123509B7CAFF', 3, 6);

-- LeaveTypes
-- Nghỉ phép năm: Working days only (1), restricted for new employees (1)
-- Nghỉ bệnh: Calendar days (0), not restricted (0)
-- Nghỉ không lương: Calendar days (0), not restricted (0)
-- Nghỉ thai sản: Calendar days (0), not restricted (0)
-- Nghỉ cưới: Calendar days (0), not restricted (0)
INSERT INTO LeaveTypes (LeaveTypeName, Description, MaxDays, IsWorkingDaysOnly, NewEmployeeRestricted, MinUnit) VALUES
(N'Nghỉ phép năm', N'Nghỉ phép hưởng lương theo quy định', 12, 1, 1, 'Day'),
(N'Nghỉ bệnh', N'Nghỉ do sức khỏe, có giấy xác nhận', 30, 0, 0, 'Day'),
(N'Nghỉ không lương', N'Nghỉ việc cá nhân không hưởng lương', 365, 0, 0, 'Day'),
(N'Nghỉ thai sản', N'Nghỉ thai sản theo luật lao động', 180, 0, 0, 'Day'),
(N'Nghỉ cưới', N'Nghỉ phép kết hôn', 3, 0, 0, 'Day');

-- Populate initial balances for sample data users
INSERT INTO EmployeeLeaveBalances (UserID, LeaveTypeID, AnnualQuota, UsedDays, RemainingDays)
SELECT u.UserID, lt.LeaveTypeID, CAST(lt.MaxDays AS FLOAT), 0.0, CAST(lt.MaxDays AS FLOAT)
FROM Users u
CROSS JOIN LeaveTypes lt
WHERE u.Status = 1;

-- Sample LeaveRequests
INSERT INTO LeaveRequests (UserID, LeaveTypeID, StartDate, EndDate, Reason, Status, CreatedAt, Duration, MinUnitChosen) VALUES
(3, 1, '2026-06-05', '2026-06-06', N'Nghỉ phép đi du lịch cùng gia đình', 'Pending', GETDATE(), 2.0, 'Full'),
(4, 2, '2026-06-03', '2026-06-04', N'Bị cảm cúm, cần nghỉ ngơi', 'Approved', GETDATE(), 2.0, 'Full'),
(5, 1, '2026-06-10', '2026-06-12', N'Về quê thăm gia đình', 'Pending', GETDATE(), 3.0, 'Full'),
(3, 3, '2026-07-01', '2026-07-03', N'Nghỉ việc riêng', 'Draft', GETDATE(), 3.0, 'Full'),
(6, 1, '2026-06-15', '2026-06-16', N'Nghỉ phép cá nhân', 'Rejected', GETDATE(), 2.0, 'Full');

-- Update Used/Remaining leave balances based on Approved sample leave requests (Request with ID corresponding to User 4 is Approved)
UPDATE EmployeeLeaveBalances
SET UsedDays = 2.0, RemainingDays = RemainingDays - 2.0
WHERE UserID = 4 AND LeaveTypeID = 2;

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
