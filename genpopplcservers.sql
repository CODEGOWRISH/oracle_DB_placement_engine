set head off
set lines 500
set pages 1000
set echo off
set feed off
set verify off

spool popplcservers.sql

select 'alter session set current_schema=ORAPLC;' from dual;

select 'truncate table plc_servers;' from dual;

select 'insert into plc_servers (SERVER_NAME, CLUSTER_NAME, CLUSTER_TYPE, SERVER_VENDOR, SERVER_CLASS, OS, CPU_CORE_COUNT, CPU_FREQUENCY_MHZ, CPU_VENDOR, CPU_CLASS, MEMORY_GB, MEMORY_FREQUENCY)' || ' values (' ||
'''' || a.host_name || '''' || ',' ||
'''' || b.composite_target_name || '''' || ',' ||
'''' || 'RAC' || '''' || ',' ||
'''' || case when a.system_config like 'Poweredge%' then 'Dell' else 'Non Dell' END || '''' || ',' ||
--'''' || case when a.system_config like '%R710%' then 'R710' when a.system_config like '%R910%' then 'R910' when a.system_config like '%M620%' then 'M620' else 'other' END || '''' || ',' ||
'''' || a.system_config || '''' || ',' ||
'''' || case when a.os_summary like '%5%' then 'RHEL5' when a.os_summary like '%6%' then 'RHEL6' else 'RHEL7' END || '''' || ',' ||
a.cpu_count || ',' ||
a.freq || ',' ||
'''' || rtrim (a.vendor_name, 20) || '''' || ',' ||
'''' || rtrim (a.vendor_name, 20) || '''' || ',' ||
round(a.mem/1024) || ',' ||
0 || ');'
from
mgmt$os_hw_summary a,
mgmt_target_memberships b
where
--a.host_name = 'd-fklr1p1' and
      b.composite_target_type='cluster'
and   b.member_target_type = 'host'
and   b.member_target_name = a.host_name
;

spool off
