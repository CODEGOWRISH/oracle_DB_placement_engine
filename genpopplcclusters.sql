set head off
set lines 500
set pages 1000
set echo off
set feed off
set verify off

spool popplcclusters.sql

select 'alter session set current_schema=ORAODRMGR;' from dual;

select distinct 'insert into plc_clusters (CLUSTER_NAME, CLUSTER_TYPE, PROD_OR_NON_PROD, CLUSTERWARE_VERSION)' || ' values (' ||
'''' || a.composite_target_name || '''' || ',' ||
'''' || 'RAC' || '''' || ',' ||
'''' || case when upper(a.composite_target_name) like 'RCLP%' then 'Prod' else 'Non Prod' END || '''' || ',' ||
'''' || '11.2.0.4' || '''' || ');'
from
mgmt_target_memberships a
where
      a.composite_target_type='cluster'
;

spool off
