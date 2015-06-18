
spool popplcclusterconfigsum

insert into plc_cluster_config_sum
(
CLUSTER_NAME                    ,
MEMORY_GB                       ,
CPU_CORE_COUNT                  ,
CPU_FREQUENCY_MHZ               ,
CPU_VENDOR                      ,
CPU_CLASS                       ,
FLOPS
)
select
 a.cluster_name,
 sum(a.memory_gb),
 sum(a.cpu_core_count),
 avg(a.cpu_frequency_mhz),
 null,
 null,
 null
from
plc_servers a
group by a.cluster_name;

commit;

spool off


-- CREATE TABLE PLC_CLUSTER_CONFIG_SUM
-- (
-- CLUSTER_NAME                 VARCHAR2(20) PRIMARY KEY,
-- MEMORY_GB                    NUMBER,
-- CPU_CORE_COUNT                       NUMBER,
-- CPU_FREQUENCY_MHZ            NUMBER,
-- CPU_VENDOR                   VARCHAR2(20),
-- CPU_CLASS                    VARCHAR2(20),
-- FLOPS                                NUMBER
-- );
--
-- CREATE TABLE PLC_SERVERS
-- (
-- SERVER_NAME                  VARCHAR2(20) PRIMARY KEY,
-- CLUSTER_NAME                 VARCHAR2(20),
-- CLUSTER_TYPE                 VARCHAR2(20),
-- SERVER_VENDOR                        VARCHAR2(20),
-- SERVER_CLASS                 VARCHAR2(50),
-- OS                           VARCHAR2(20),
-- CPU_CORE_COUNT                       NUMBER,
-- CPU_FREQUENCY_MHZ            NUMBER,
-- CPU_VENDOR                   VARCHAR2(20),
-- CPU_CLASS                    VARCHAR2(20),
-- MEMORY_GB                    NUMBER,
-- MEMORY_FREQUENCY             NUMBER
-- );
