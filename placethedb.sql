
--
-- NOTE - TRY DOING A COMBINED SQL
--

spool placethedb

SELECT
A.CLUSTER_NAME
FROM
PLC_CLUSTERS A,
PLC_INTAKE_APP_PROFILES B,
PLC_CLUSTER_LIMITS C
WHERE
-- cluster memory limit - use 30 days as this should be most current (if app pga, sga are unknown, set defaults (TBD))
(A.MEMORY_AVERAGE_30DAY + ((B.SGA_COMPUTED + B.PGA_COMPUTED) * 100 / A.MEMORY_GB)) <= C.MEMORY_LOAD_LIMIT_AVERAGE
-- cluster cpu limit - use 90 days as this can vary (add perceived app cpu load compute formula TBD)
-- (should we check standby side also TBD)
-- (should we check peak season period also TBD)
-- (should we measure by 1/db-max-per-cluster when cpu for app cannot be computed TBD)
AND (A.CPU_AVERAGE_90DAY + (B.CPU_CORE_COMPUTED * 100 / A.CPU_CORE_COUNT)) <= C.CPU_LOAD_LIMIT_AVERAGE
AND A.PROD_OR_NON_PROD = DECODE(B.SCHEMA_PURPOSE, 'PROD', 'PROD', 'NPE')
-- License stuff
AND A.PARTITIONING_LICENSE_YN = B.PARTITIONING_NEEDED_YN
--AND A.ACTIVE_DATAGUARD_LICENSE_YN = B.ACTIVE_DATAGUARD_NEEDED_YN
AND A.OEM_DATA_MASKING_LICENSE_YN = B.DATA_MASKING_SOURCE_YN
--AND A.PDB_LICENSE_YN = B.PDB_YN
AND B.APP_NAME='&&app_name'
AND B.SCHEMA_NAME='&&schema_name'
AND B.SCHEMA_PURPOSE='&&schema_purpose'
;

-- Service affinity among cluster nodes
SELECT
A.SERVER_NAME, min(A.CPU_AVERAGE_90DAY)
FROM
PLC_SERVERS A
WHERE
A.CLUSTER_NAME = '&&cluster_name'
GROUP BY SERVER_NAME
;

spool off
