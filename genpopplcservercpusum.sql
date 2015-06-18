set head off
set lines 500
set pages 1000
set echo off
set feed off
set verify off

spool popplcservercpusum.sql

select 'alter session set current_schema=ORAODRMGR;' from dual;

select 'truncate table PLC_SERVER_CPU_SUM;' from dual;

select 'insert into PLC_SERVER_CPU_SUM values (' ||
'''' || a.member_target_name || '''' || ',' ||
round(avg(b.average)) || ',' ||
round(avg(b.maximum)) || ',' ||
round(avg(b.average)) || ',' ||
'0,0,0,0,0,0,0,0,0);'
from   mgmt_target_memberships a,
       mgmt$metric_daily b
where a.composite_target_type='cluster'
and   a.member_target_type = 'host'
and   a.member_target_name = b.target_name
and   b.metric_name = 'Load'
and   b.metric_column = 'cpuUtil'
and   b.rollup_timestamp <= sysdate-90
group by a.member_target_name
;

select 'commit;' from dual;

spool off

