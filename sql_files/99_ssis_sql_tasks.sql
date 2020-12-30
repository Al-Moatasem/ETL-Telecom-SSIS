-- used queries in Execute SQL task

-- get the next batch id
select max(batch_id) + 1 as batch_id from dim_audit
go

-- Insert into dim audit, to be used inside SSIS / OLEDB Connection
/*
insert into dim_audit ( batch_id, package_name, file_name, rows_extracted, rows_inserted, rows_rejected, SuccessfulProcessingInd)
output inserted.id as audit_id
values (
	?, -- 0 batch id
	?, -- 1 package name
	?, -- 2 file_name
	NULL, -- 3 rows_extracted
	NULL, -- 4 rows_inserted
	NULL, -- 5 rows_rejected
	'N'
	)
go
*/
-- update dim audit, to be used inside SSIS / OLEDB Connection
/*
update dim_audit
set 
    [rows_extracted] = ? + ?, -- 0  extracted processed + 1 extracted error
    [rows_inserted] = ? - ?, -- 2 pre insert -  3 dest error
    [rows_rejected] = ? + ?, -- 4 extracted error  +  5 dest error
	SuccessfulProcessingInd = 'Y',
	updated_at = getdate()
where id = ? -- 6 audit_id
*/