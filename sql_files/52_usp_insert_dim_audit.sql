use EO_Telecom_GrgEdu
go

if exists (
	select * from sys.procedures as p 
		inner join sys.schemas as s on s.schema_id = p.schema_id 
	where s.name = 'dbo' and p.name = 'usp_insert_dim_audit'
	)
drop procedure dbo.usp_insert_dim_audit 
go

create procedure dbo.usp_insert_dim_audit 
	-- @batch_id int = -1,
	@package_name nvarchar(255),
	@file_name nvarchar(255),
	@rows_input_rejected int = -1,
	@rows_processed int = -1,
	@rows_output_rejected int = -1
as
begin
INSERT INTO [dbo].[dim_audit] (
           [package_name],
           [file_name],
           [rows_extracted],
           [rows_inserted],
           [rows_rejected]
		)
     VALUES (
		   @package_name, 
		   @file_name,
		   -- extracted records
		   @rows_input_rejected + @rows_processed,
		   -- inserted records
		   @rows_processed - @rows_output_rejected,
		   @rows_output_rejected
	)
end
GO
/*
exec dbo.insert_dim_audit 
		   @package_name = 'pkg_name', 
		   @file_name = 'src_file_name', 
		   @rows_input_rejected = 25,
		   @rows_processed = 100,
		   @rows_output_rejected = 15
go
*/

-- select max(batch_id)+1 as batch_id from dim_audit
