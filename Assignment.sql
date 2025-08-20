USE master;
GO

-- Drop database if exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Assignment')
BEGIN
    ALTER DATABASE Assignment SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Assignment;
END
GO

-- Create database
CREATE DATABASE Assignment;
GO
USE Assignment;
GO

-- 1. Role
CREATE TABLE [Role] (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

-- 2. Warehouse
CREATE TABLE Warehouse (
    warehouse_id INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_name NVARCHAR(100) UNIQUE NOT NULL,
    address NVARCHAR(255),
    region NVARCHAR(50),
    manager_id INT, -- FK to [User], added later
    status VARCHAR(50),
    created_at DATETIME DEFAULT GETDATE()
);

-- 3. User
CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    role_id INT NOT NULL,
    gender VARCHAR(10),
    address VARCHAR(255),
    email VARCHAR(100),
    date_of_birth DATE,
    profile_pic VARCHAR(255),
    status VARCHAR(10) NOT NULL DEFAULT 'Active',
    warehouse_id INT NULL,
    CONSTRAINT FK_User_Role FOREIGN KEY (role_id) REFERENCES [Role](role_id),
    CONSTRAINT CK_User_Status CHECK (status IN ('Active', 'Deactive'))
);

CREATE INDEX IX_User_Status ON [User](status);
CREATE INDEX IX_User_Username_Status ON [User](username, status);

-- Add FK to Warehouse.manager_id after User exists
ALTER TABLE Warehouse
ADD CONSTRAINT FK_Warehouse_Manager FOREIGN KEY (manager_id) REFERENCES [User](user_id);

-- Add FK from User to Warehouse
ALTER TABLE [User]
ADD CONSTRAINT FK_User_Warehouse FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id);


-- 1. Role
INSERT INTO [Role] (role_name) VALUES
(N'Admin'),
(N'Warehouse Manager'),
(N'Warehouse Staff');

-- 2. Warehouse (Fixed: Added manager_id for all rows)
SET IDENTITY_INSERT Warehouse ON;
INSERT INTO Warehouse (warehouse_id, warehouse_name, address, region, manager_id, status, created_at) VALUES
(1, N'Kho Hà Nội', N'123 Đường Láng, Đống Đa, Hà Nội', N'Miền Bắc', NULL, 'Active', GETDATE()),
(2, N'Kho Hồ Chí Minh', N'456 Cách Mạng Tháng 8, Quận 3, TP.HCM', N'Miền Nam', NULL, 'Active', GETDATE()),
(3, N'Kho Đà Nẵng', N'789 Trần Phú, Hải Châu, Đà Nẵng', N'Miền Trung', NULL, 'Active', GETDATE()),
(4, N'Kho Cần Thơ', N'101 Mậu Thân, Ninh Kiều, Cần Thơ', N'Miền Nam', NULL, 'Active', GETDATE()),
(5, N'Kho Hải Phòng', N'202 Lê Hồng Phong, Ngô Quyền, Hải Phòng', N'Miền Bắc', NULL, 'Active', GETDATE());
SET IDENTITY_INSERT Warehouse OFF;

-- 3. User
INSERT INTO [User] (username, password, first_name, last_name, role_id, gender, address, email, date_of_birth, profile_pic, status, warehouse_id) VALUES
--Kho Hà Nội warehouse id = 1
('managerHN1', '123456', N'Nguyễn Văn', N'Quang', 2, 'Male', N'123 Đường Láng, Hà Nội', 'managerHN1@example.com', '1990-01-01', 'manager.png', 'Active', 1),
('staffHN1', '123456', N'Lê Thị', N'Lan', 3, 'Female', N'101 Đường Láng, Hà Nội', 'staffHN1@example.com', '1997-04-10', 'staff.png', 'Active', 1),
--Kho Hồ Chí Minh warehouse id = 2
('managerHCM1', '123456', N'Ngô Văn', N'Hoàng', 2, 'Male', N'123 CMT8, TP.HCM', 'managerHCM1@example.com', '1991-05-05', 'manager.png', 'Active', 2),
('staffHCM1', '123456', N'Phan Thị', N'Bích', 3, 'Female', N'101 CMT8, TP.HCM', 'staffHCM1@example.com', '1996-08-25', 'staff.png', 'Active', 2),
--Kho Đà Nẵng warehouse id = 3
('managerDN1', '123456', N'Hoàng Văn', N'Phúc', 2, 'Male', N'123 Trần Phú, Đà Nẵng', 'managerDN1@example.com', '1990-09-01', 'manager.png', 'Active', 3),
('staffDN1', '123456', N'Bùi Thị', N'Nhung', 3, 'Female', N'101 Trần Phú, Đà Nẵng', 'staffDN1@example.com', '1997-12-10', 'staff.png', 'Active', 3),
--Kho Cần Thơ warehouse id = 4
('managerCT1', '123456', N'Phạm Văn', N'Kiên', 2, 'Male', N'123 Mậu Thân, Cần Thơ', 'managerCT1@example.com', '1991-01-05', 'manager.png', 'Active', 4),
('staffCT1', '123456', N'Trần Thị', N'Vân', 3, 'Female', N'101 Mậu Thân, Cần Thơ', 'staffCT1@example.com', '1996-04-25', 'staff.png', 'Active', 4),
--Kho Hải Phòng warehouse id = 5
('managerHP1', '123456', N'Đặng Văn', N'Bình', 2, 'Male', N'123 Lê Hồng Phong, Hải Phòng', 'managerHP1@example.com', '1990-05-01', 'manager.png', 'Active', 5),
('staffHP1', '123456', N'Lê Thị', N'Thảo', 3, 'Female', N'101 Lê Hồng Phong, Hải Phòng', 'staffHP1@example.com', '1997-08-10', 'staff.png', 'Active', 5),
('admin01', 'admin123', N'Nguyễn Văn', N'Admin', 1, 'Male', N'123 Admin St, Hanoi', 'admin@example.com', '1990-01-01', 'admin.png', 'Active', NULL);

-- Update manager_id for Warehouse
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHN1') WHERE warehouse_id = 1;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHCM1') WHERE warehouse_id = 2;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerDN1') WHERE warehouse_id = 3;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerCT1') WHERE warehouse_id = 4;
UPDATE Warehouse
SET manager_id = (SELECT user_id FROM [User] WHERE username = 'managerHP1') WHERE warehouse_id = 5;
