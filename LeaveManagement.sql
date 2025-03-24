-- 1. Tạo cơ sở dữ liệu
CREATE DATABASE Assignment;
GO
USE Assignment;

-- 2. Tạo bảng Users (Lưu tài khoản đăng nhập)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL, -- Mật khẩu lưu dạng text (Nên mã hóa trong thực tế)
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Role NVARCHAR(50) NOT NULL, -- VD: Employee, Manager, Admin
    DepartmentID INT NULL, -- Tham chiếu đến bảng Department
    Department NVARCHAR(50) NULL, -- Tên phòng ban
    Phone NVARCHAR(15) NULL,
    Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')) NULL,
    DOB DATE NULL,
    Address NVARCHAR(255) NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3. Tạo bảng Department (Lưu thông tin phòng ban)
CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL UNIQUE,
    ManagerID INT NOT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Users(UserID) ON DELETE NO ACTION
);

-- 4. Thêm khóa ngoại vào bảng Users
ALTER TABLE Users
ADD FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID) ON DELETE SET NULL;

-- 5. Tạo bảng LeaveType
CREATE TABLE LeaveType (
    LeaveTypeID INT IDENTITY(1,1) PRIMARY KEY, -- ID của loại nghỉ phép
    LeaveTypeName NVARCHAR(50) NOT NULL UNIQUE -- Tên loại nghỉ phép (VD: Nghỉ phép năm, Nghỉ không lương, Nghỉ ốm)
);

-- Thêm dữ liệu mẫu vào bảng LeaveType
INSERT INTO LeaveType (LeaveTypeName)
VALUES 
('Nghỉ phép năm'),
('Nghỉ không lương'),
('Nghỉ ốm'),
('Nghỉ thai sản'),
('Nghỉ tang lễ');

-- 6. Tạo bảng LeaveRequests (Lưu đơn xin nghỉ phép)
CREATE TABLE LeaveRequests (
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL, -- Người tạo đơn
    LeaveTypeID INT NOT NULL, -- ID loại nghỉ phép (liên kết với bảng LeaveType)
    StartDate DATE NOT NULL, -- Ngày bắt đầu nghỉ
    EndDate DATE NOT NULL, -- Ngày kết thúc nghỉ
    Reason NVARCHAR(255), -- Lý do xin nghỉ
    Attachment NVARCHAR(255) NULL, -- File đính kèm (Lưu đường dẫn file)
    Status NVARCHAR(20) DEFAULT 'Inprogress' CHECK (Status IN ('Inprogress', 'Approved', 'Rejected')), -- Trạng thái đơn
    ManagerNote NVARCHAR(255) NULL, -- Ghi chú của quản lý (nếu có)
    Created_By INT NULL, -- Người tạo đơn (nếu khác UserID)
    Approved_By INT NULL, -- Người duyệt đơn
    ProcessedAt DATETIME NULL, -- Thời gian xử lý đơn
    CreatedAt DATETIME DEFAULT GETDATE(), -- Thời gian tạo đơn
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LeaveTypeID) REFERENCES LeaveType(LeaveTypeID) ON DELETE NO ACTION,
    FOREIGN KEY (Created_By) REFERENCES Users(UserID) ON DELETE NO ACTION,
    FOREIGN KEY (Approved_By) REFERENCES Users(UserID) ON DELETE NO ACTION
);

-- 7. Tạo bảng Agenda (Lịch làm việc của nhân viên)
CREATE TABLE Agenda (
    AgendaID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Username NVARCHAR(50) NOT NULL,
    WorkDate DATE NOT NULL,
    Status NVARCHAR(20) CHECK (Status IN ('Working', 'On Leave')),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 8. Thêm dữ liệu mẫu vào bảng Users (1 Admin, 3 Manager, 30 Nhân viên)
INSERT INTO Users (Username, Password, FullName, Email, Role)
VALUES 
('admin', 'admin123', 'Admin User', 'admin@example.com', 'Admin'),
('manager1', 'managerpass', 'Manager One', 'manager1@example.com', 'Manager'),
('manager2', 'managerpass', 'Manager Two', 'manager2@example.com', 'Manager'),
('manager3', 'managerpass', 'Manager Three', 'manager3@example.com', 'Manager');

-- 9. Thêm dữ liệu mẫu vào bảng Department
INSERT INTO Department (DepartmentName, ManagerID)
VALUES 
('HR', 2),
('Sales', 3),
('IT', 4);

-- 10. Cập nhật bảng Users với DepartmentID và Department
UPDATE Users SET DepartmentID = 1, Department = 'HR' WHERE UserID = 2;
UPDATE Users SET DepartmentID = 2, Department = 'Sales' WHERE UserID = 3;
UPDATE Users SET DepartmentID = 3, Department = 'IT' WHERE UserID = 4;

DECLARE @i INT = 1;
WHILE @i <= 30
BEGIN
    INSERT INTO Users (Username, Password, FullName, Email, Role, DepartmentID, Department)
    VALUES (
        CONCAT('user', @i), 
        'password123', 
        CONCAT('User ', @i), 
        CONCAT('user', @i, '@example.com'), 
        'Employee', 
        CASE WHEN @i % 3 = 0 THEN 1 WHEN @i % 3 = 1 THEN 2 ELSE 3 END,
        CASE WHEN @i % 3 = 0 THEN 'HR' WHEN @i % 3 = 1 THEN 'Sales' ELSE 'IT' END
    );
    SET @i = @i + 1;
END;

-- 11. Thêm dữ liệu mẫu vào bảng LeaveRequests
INSERT INTO LeaveRequests (UserID, LeaveTypeID, StartDate, EndDate, Reason, Status, Created_By, Approved_By, ProcessedAt)
VALUES
(2, 1, '2025-03-17', '2025-03-20', 'Ông mất', 'Inprogress', NULL, NULL, NULL),
(3, 2, '2025-03-15', '2025-03-20', 'Đi du lịch', 'Inprogress', NULL, NULL, NULL),
(4, 3, '2025-04-01', '2025-04-03', 'Nghỉ cưới', 'Approved', 1, 1, GETDATE());

-- 12. Thêm dữ liệu mẫu vào bảng Agenda
INSERT INTO Agenda (UserID, Username, WorkDate, Status)
SELECT UserID, Username, '2025-03-17', 'Working' FROM Users WHERE Role = 'Employee';
SELECT UserID, Username, '2025-03-18', 'Working' FROM Users WHERE Role = 'Employee';
SELECT UserID, Username, '2025-03-19', 'Working' FROM Users WHERE Role = 'Employee';
SELECT UserID, Username, '2025-03-20', 'Working' FROM Users WHERE Role = 'Employee';
SELECT UserID, Username, '2025-03-21', 'Working' FROM Users WHERE Role = 'Employee';
SELECT UserID, Username, '2025-03-22', 'Working' FROM Users WHERE Role = 'Employee';
SELECT UserID, Username, '2025-03-23', 'Working' FROM Users WHERE Role = 'Employee';

-- 13. Kiểm tra dữ liệu
SELECT * FROM Users;
SELECT * FROM LeaveRequests;
SELECT * FROM Agenda;
SELECT * FROM LeaveType;
SELECT * FROM Department;

SELECT 
    lr.RequestID,
    lr.UserID,
    lt.LeaveTypeName, -- Lấy tên loại nghỉ phép từ bảng LeaveType
    lr.StartDate,
    lr.EndDate,
    lr.Reason,
    lr.Status,
    lr.CreatedAt
FROM LeaveRequests lr
JOIN LeaveType lt ON lr.LeaveTypeID = lt.LeaveTypeID;