use AdventureWorks2019;
go

select db_name();
go

-- all tables in AdventureWorks2019
SELECT *
FROM information_schema.tables;

-- schemas that contained tables in database AdventureWorks2019
select DISTINCT table_schema
FROM information_schema.tables;
go

-- all schemas belong to database AdventureWorks2019
SELECT * FROM sys.schemas;

-- matching procedures to schemas
SELECT b.name as schemaname, a.name as procedure_name, a.object_id, a.schema_id
FROM sys.procedures a 
left join sys.schemas b on a.schema_id = b.schema_id;

-- matching tables to schemas
select b.name as schemaname, a.name as tablename, a.object_id, a.type_desc 
from sys.tables a 
left join sys.schemas b on a.schema_id = b.schema_id;
