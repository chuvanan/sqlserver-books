
select db_name();
-- AdventureWorks2019

-- Assign values to variables

DECLARE @AddressLine1 NVARCHAR(100);
DECLARE @AddressLine2 NVARCHAR(100);
SELECT @AddressLine1 = AddressLine1, @AddressLine2 = AddressLine2
FROM Person.Address
WHERE AddressID = 66; -- make sure to write query that returns at most one row

SELECT @AddressLine1 as Address1, @AddressLine2 as Address2;
GO



-- Writing expressions

DECLARE @AddressLine1 NVARCHAR(100);
DECLARE @AddressLine2 NVARCHAR(100);
DECLARE @OneLine NVARCHAR(100);

SELECT @AddressLine1 = AddressLine1, @AddressLine2 = AddressLine2
FROM Person.Address
WHERE AddressID = 66;

SET @OneLine = @AddressLine1 + ';' + @AddressLine2;
SELECT @OneLine OneLineAddress;
GO


-- Detecting whether rows exist

if exists (
    SELECT * from Production.Product
    where color = 'Brown'
)
BEGIN
    SELECT top 3 *
    from Production.Product
    where Color = 'Silver'
END

ELSE

BEGIN
    SELECT top 3 * 
    from Production.Product
    where Color = 'Black'
END;
GO


-- Go to a label in a T-SQL batch

GOTO skipselect;
select top 10 * 
from Production.Product;

skipselect: 
BEGIN
PRINT 'Goto top 5 Culture'
SELECT top 5 * from Production.Culture;
end;
GO


-- Returning from the current execution scope

-- 1) exit without return value
if not exists (
    SELECT ProductID
    from Production.Product
    where Color = 'Pink'
)
begin 
    return;
end;
go 



-- 2) exit and provide value
-- Create a new stored procedure called 'StoredProcedureName' in schema 'dbo'
-- Drop the stored procedure if it already exists
create PROCEDURE ReportPink as
if not exists (
    select ProductID
    from Production.Product
    where Color = 'Pink'
)
begin
    return 100;
end;


declare @ResultStatus int;
exec @ResultStatus = ReportPink;
print 'Status of ReportPink:' + cast(@ResultStatus as VARCHAR(10));
go 3


-- Repeatedly executing a section of code
exec sp_spaceused 'Production.Product';
go 

exec sp_spaceused 'Sales.Customer';
go 


declare @AWTables table (SchemaTable varchar(100));
declare @Tablename VARCHAR(100);

insert @AWTables (SchemaTable)
select TABLE_SCHEMA + '.' + TABLE_NAME
from INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE'
order by TABLE_SCHEMA + '.' + TABLE_NAME;

while (select count(*) from @AWTables) > 0
begin
    select top 1 @Tablename = SchemaTable -- assign value inside select statement (very flexible syntax of T-SQL)
    from @AWTables
    order by SchemaTable

    exec sp_spaceused @Tablename;
    print '* Delete table: ' + @Tablename + 'from @AWTables;'
    DELETE @AWTables
    where SchemaTable = @Tablename;
end;
go


-- Pausing execution for a period of time

waitfor delay '00:00:10';
begin
    select TransactionID, Quantity
    from Production.TransactionHistory;
end;
go


waitfor time '14:23:30';
begin
    select COUNT(1)
    from Production.TransactionHistory;
end;
go


-- Looping with cursor
set NOCOUNT on;
declare @session_id smallint;

declare session_cursor cursor forward_only read_only for -- (1)
select session_id
from sys.dm_exec_requests
where [status] in ('runnable', 'sleeping', 'running');

open session_cursor; -- (2)
fetch next 
    from session_cursor
    into @session_id;
while @@FETCH_STATUS = 0 -- 0:success
begin
    print 'Spid #:' + str(@session_id);
    exec ('sp_who ' + @session_id);

    fetch next
        from session_cursor
        into @session_id;
end;

close session_cursor; -- (3)
DEALLOCATE session_cursor; -- (4)
go