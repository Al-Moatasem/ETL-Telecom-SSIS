use EO_Telecom_GrgEdu
go

-- Drop foregin Keys if exists
IF EXISTS (
	SELECT *
	FROM   sys.foreign_keys
	WHERE  NAME = 'fk_fact_transaction_dim_audit'
		AND parent_object_id = Object_id('fact_transaction')
	)
  ALTER TABLE fact_transaction
    DROP CONSTRAINT fk_fact_transaction_dim_audit;

-- drop the table if exists
if exists (select * from sys.tables where name = 'dim_audit' and type = 'U')
drop table dim_audit
go

create table dim_audit (
	id int identity(1,1) not null primary key,
	batch_id int,
	package_name nvarchar(255) not null,
	file_name nvarchar(255) not null,
	rows_extracted int, -- rows in the source file
	rows_inserted int,
	--rows_updated int,
	rows_rejected int,
	created_at datetime default(getdate()),
	updated_at datetime default(getdate()),
	SuccessfulProcessingInd nchar(1) not null default 'N'
)
go

-- Create Foreign Keys
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'fact_transaction'
                  AND type = 'u')
  ALTER TABLE fact_transaction
    ADD CONSTRAINT fk_fact_transaction_dim_audit foreign  key (audit_id) references dim_audit(id)
go

-- insert UNKNOWN record

SET IDENTITY_INSERT dim_audit ON

insert into dim_audit (id, batch_id, package_name, file_name, rows_extracted, rows_inserted, rows_rejected)
values (-1,0, 'Unknown','Unknown',null,null,null)

SET IDENTITY_INSERT dim_audit off

-- add audit id filed to error tables
alter table [dbo].[err_source_output] add audit_id int not null default(-1);
alter table [dbo].[err_destination_output] add audit_id int not null default(-1);



-- additional metadata to be added to the dim audit table

/*
-- will be mapped to system variable StartTime in SSIS
alter table dim_audit add Exec_StartDT datetime default(getdate());

-- update this value after the data flow - getdate()
alter table dim_audit add Exec_StopDT datetime default(getdate());

alter table dim_audit add Table_Name nvarchar(255) not null default 'Unknown';

-- run a [select count(*) as row_cnt from ...] the target table in Execute SQL Task BEFORE inserting to dim audit
alter table dim_audit add Table_Initial_RowCnt int;

-- run a [select count(*) as row_cnt from ...] the target table in Execute SQL Task BEFORE updating to dim audit
alter table dim_audit add Table_Final_RowCnt int;

-- run a [select max(xx_id) as max_srg from ...] the target table in Execute SQL Task BEFORE updating to dim audit
alter table dim_audit add Table_Max_SurrogateKey int;

-- a flag (Y/N), 
alter table dim_audit add SuccessfulProcessingInd nchar(1) not null default 'N';
*/