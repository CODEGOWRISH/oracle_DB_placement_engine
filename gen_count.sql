set echo off
set head off
spool count.sql

prompt spool count.lst

select 'select count(*) from ' || owner || '.' || table_name || ';'
from all_tables
where table_name like 'PLC%';

prompt spool off

spool off
set echo on
set head on
