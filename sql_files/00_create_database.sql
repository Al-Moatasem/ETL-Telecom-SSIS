USE master
go

if exists (select * from sys.databases where name = 'EO_Telecom_GrgEdu')
drop database EO_Telecom_GrgEdu
go

create database EO_Telecom_GrgEdu
go