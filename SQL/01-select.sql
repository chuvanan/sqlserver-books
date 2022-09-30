

-- Check the database server version
select @@version;


-- Check the database name
select db_name();


-- Check username
select ORIGINAL_LOGIN() orginal_user, CURRENT_USER as [current-user], SYSTEM_USER as sys_user;


-- Listing available tables
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

SELECT *
FROM master.dbo.spt_values;


-- Testing for existence
SELECT 1
WHERE exists (
    select * from INFORMATION_SCHEMA.tables where TABLE_NAME = 'spt_values'
);


-- caution: one value in the in-list is null, then result is always UNKNOWN
SELECT *
FROM INFORMATION_SCHEMA.TABLES
where TABLE_NAME not in ('spt_values', null)


-- Specifying the case-sensitivity of a sort by adding COLLATE
SELECT *
FROM fn_helpcollations()
where name like 'Vietnam%';

SELECT *
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_NAME collate latin1_General_BIN asc;
GO


-- Forcing unusual sort order
SELECT *
FROM master.dbo.spt_values
where name is not null
ORDER by case name when 'dist' then null else name end; -- spt_values = 'dist' then rank it first
GO

use AdventureWorks2019;
go

-- Sampling a subset of rows with tablesample()
SELECT *
FROM HumanResources.Employee
tablesample(10 PERCENT);


SELECT *
FROM HumanResources.Employee
tablesample(100 rows);

