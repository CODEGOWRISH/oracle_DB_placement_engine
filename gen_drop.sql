set echo off
set head off
spool drop.sql

select 'drop table ' || owner || '.' || table_name || ';'
from dba_tables
where table_name like 'PLC%';

spool off
set echo on
set head on
