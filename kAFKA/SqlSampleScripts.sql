Create Database KafkaDb
Go

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(100),
    Salary DECIMAL(18, 2)
);

Go

EXEC sys.sp_cdc_enable_db;

EXEC sys.sp_cdc_enable_table 
    @source_schema = N'dbo', 
    @source_name = N'Employees', 
    @role_name = NULL;

select
  name,
  is_cdc_enabled
from sys.databases;

select
  name,
  is_tracked_by_cdc 
from sys.tables;


CREATE TABLE EmployeesDest (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(100),
    Salary DECIMAL(18, 2)
);