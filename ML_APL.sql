call SAP_PA_APL."sap.pa.apl.base::PING"(?);

set session 'APL_CACHE_SCHEMA' = 'APL_CACHE';

drop type  OZONE_FORECAST_OUT_T;
drop table FUNC_HEADER;
drop view  OZONE_RATE_SORTED;
drop table FORECAST_CONFIG;
drop table VARIABLE_DESC;
drop table VARIABLE_ROLES;
drop table FORECAST_OUT;
drop table OPERATION_LOG;
drop table SUMMARY;
drop table INDICATORS;

create type OZONE_FORECAST_OUT_T as table (
    "Date" DATE,
    "OzoneRate" DOUBLE,
    "kts_1" DOUBLE,
    "kts_1_lowerlimit_95%" DOUBLE,
    "kts_1_upperlimit_95%" DOUBLE
);

create table FUNC_HEADER like "SAP_PA_APL"."sap.pa.apl.base::BASE.T.FUNCTION_HEADER";
insert into FUNC_HEADER values ('Oid', '#42');
insert into FUNC_HEADER values ('LogLevel', '8');

create view OZONE_RATE_SORTED as select "Date", "OzoneRate" from MYDATA."OzoneRate" order by "Date" asc;

create table FORECAST_CONFIG like "SAP_PA_APL"."sap.pa.apl.base::BASE.T.OPERATION_CONFIG_EXTENDED";
insert into FORECAST_CONFIG values ('APL/Horizon', '12',null);
insert into FORECAST_CONFIG values ('APL/TimePointColumnName', 'Date',null);
insert into FORECAST_CONFIG values ('APL/ForcePositiveForecast', 'true',null);
insert into FORECAST_CONFIG values ('APL/ApplyExtraMode','Forecasts and Error Bars', null);

create table VARIABLE_DESC like "SAP_PA_APL"."sap.pa.apl.base::BASE.T.VARIABLE_DESC_OID";

create table VARIABLE_ROLES like "SAP_PA_APL"."sap.pa.apl.base::BASE.T.VARIABLE_ROLES_WITH_COMPOSITES_OID";
insert into VARIABLE_ROLES values ('Date', 'input',NULL,NULL,'#42');
insert into VARIABLE_ROLES values ('OzoneRate', 'target',NULL,NULL,'#42');

create table FORECAST_OUT like OZONE_FORECAST_OUT_T;
create table OPERATION_LOG like "SAP_PA_APL"."sap.pa.apl.base::BASE.T.OPERATION_LOG";
create table SUMMARY like "SAP_PA_APL"."sap.pa.apl.base::BASE.T.SUMMARY";
create table INDICATORS like "SAP_PA_APL"."sap.pa.apl.base::BASE.T.INDICATORS";

DO BEGIN
    header = select * from FUNC_HEADER;
    config = select * from FORECAST_CONFIG;
    var_desc = select * from VARIABLE_DESC;
    var_role = select * from VARIABLE_ROLES;

    "SAP_PA_APL"."sap.pa.apl.base::FORECAST"(:header, :config, :var_desc, :var_role, 'MYUSER', 'OZONE_RATE_SORTED', 'MYUSER', 'FORECAST_OUT', out_log, out_summary, out_indicators);

    insert into OPERATION_LOG select * from :out_log;
    insert into SUMMARY       select * from :out_summary;
    insert into INDICATORS    select * from :out_indicators;
END;

select * from FORECAST_OUT order by "Date" asc;
select * from OPERATION_LOG;
select * from SUMMARY;
select * from INDICATORS;
