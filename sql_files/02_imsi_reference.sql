use EO_Telecom_GrgEdu
go

if exists (select * from sys.tables where name = 'dim_imsi_reference' and type = 'U')
drop table dim_imsi_reference
go

create table dim_imsi_reference (
	id int identity(1,1),
	imsi varchar(15),
	subscriber_id int,

	constraint pk_dim_imsi_reference_id primary key (id)
)
go

insert into dim_imsi_reference 
values 
	(310120265624299,12345),
	(310120265624298,54321)