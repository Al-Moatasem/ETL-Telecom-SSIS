use EO_Telecom_GrgEdu
go

CREATE TABLE err_destination_output (
    [id] int,
    [imsi] varchar(15),
    [imei] varchar(15),
    [cell] varchar(4),
    [lac] varchar(2),
    [event_type] varchar(2),
    [event_ts] datetime,
    [tac] varchar(8),
    [snr] varchar(8),
    [ErrorCode] int,
    [ErrorColumn] int
)
go

alter table err_destination_output add audit_id int;