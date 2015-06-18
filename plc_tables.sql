--
-- plc_tables.sql
--
-- Additional considerations -
--  DB Ver vs o/s version compatibility
--  Shut off some clusters from placement - a child table to plc_clusters
--
--

set echo on

spool plc_tables

connect / as sysdba

alter session set current_schema=ORAODRMGR;

CREATE TABLE PLC_SERVERS
(
SERVER_NAME                     VARCHAR2(20) PRIMARY KEY,
CLUSTER_NAME                    VARCHAR2(20),
CLUSTER_TYPE                    VARCHAR2(20),
SERVER_VENDOR                   VARCHAR2(20),
SERVER_CLASS                    VARCHAR2(50),
OS                              VARCHAR2(20),
CPU_CORE_COUNT                  NUMBER,
CPU_FREQUENCY_MHZ               NUMBER,
CPU_VENDOR                      VARCHAR2(20),
CPU_CLASS                       VARCHAR2(20),
MEMORY_GB                       NUMBER,
MEMORY_FREQUENCY                NUMBER
);

CREATE TABLE PLC_SERVER_CPU_SUM
(
SERVER_NAME                     VARCHAR2(20) PRIMARY KEY,
CPU_AVERAGE_90DAY               NUMBER,
CPU_PEAK_90DAY                  NUMBER,
CPU_MEDIAN_90DAY                NUMBER,
CPU_AVERAGE_60DAY               NUMBER,
CPU_PEAK_60DAY                  NUMBER,
CPU_MEDIAN_60DAY                NUMBER,
CPU_AVERAGE_30DAY               NUMBER,
CPU_PEAK_30DAY                  NUMBER,
CPU_MEDIAN_30DAY                NUMBER,
PEAKSEASON_CPU_AVERAGE          NUMBER,
PEAKSEASON_CPU_PEAK             NUMBER,
PEAKSEASON_CPU_MEDIAN           NUMBER
);

CREATE TABLE PLC_SERVER_MEMORY_SUM
(
SERVER_NAME                     VARCHAR2(20) PRIMARY KEY,
MEMORY_AVERAGE_90DAY            NUMBER,
MEMORY_PEAK_90DAY               NUMBER,
MEMORY_MEDIAN_90DAY             NUMBER,
MEMORY_AVERAGE_60DAY            NUMBER,
MEMORY_PEAK_60DAY               NUMBER,
MEMORY_MEDIAN_60DAY             NUMBER,
MEMORY_AVERAGE_30DAY            NUMBER,
MEMORY_PEAK_30DAY               NUMBER,
MEMORY_MEDIAN_30DAY             NUMBER,
PEAKSEASON_MEMORY_AVERAGE       NUMBER,
PEAKSEASON_MEMORY_PEAK          NUMBER,
PEAKSEASON_MEMORY_MEDIAN        NUMBER
);


CREATE TABLE PLC_CLUSTERS
(
CLUSTER_NAME            VARCHAR2(20) PRIMARY KEY,
CLUSTER_TYPE            VARCHAR2(20),
PROD_OR_NON_PROD        VARCHAR2(20),
CLUSTERWARE_VERSION     VARCHAR2(20)
);

CREATE TABLE PLC_CLUSTERS_EXCLUDED
(
CLUSTER_NAME            VARCHAR2(20) PRIMARY KEY,
EXCLUSION_REASON        VARCHAR2(60)
);


CREATE TABLE PLC_CLUSTER_LICENSES
(
CLUSTER_NAME                    VARCHAR2(20) PRIMARY KEY,
PARTITIONING_LICENSE_YN         CHAR(1),
ACTIVE_DATAGUARD_LICENSE_YN     CHAR(1),
OEM_DATA_MASKING_LICENSE_YN     CHAR(1),
PDB_LICENSE_YN                  CHAR(1),
OEM_CLOUD_PACK_LICENSE_YN       CHAR(1),
OEM_LCM_PACK_LICENSE_YN         CHAR(1)
);

CREATE TABLE PLC_CLUSTER_CONFIG_SUM
(
CLUSTER_NAME                    VARCHAR2(20) PRIMARY KEY,
MEMORY_GB                       NUMBER,
CPU_CORE_COUNT                  NUMBER,
CPU_FREQUENCY_MHZ               NUMBER,
CPU_VENDOR                      VARCHAR2(20),
CPU_CLASS                       VARCHAR2(20),
FLOPS                           NUMBER,
SERVER_CONFIG                   NUMBER
);

CREATE TABLE PLC_CLUSTER_CPU_SUM
(
CLUSTER_NAME                    VARCHAR2(20) PRIMARY KEY,
CPU_AVERAGE_90DAY               NUMBER,
CPU_PEAK_90DAY                  NUMBER,
CPU_MEDIAN_90DAY                NUMBER,
CPU_AVERAGE_60DAY               NUMBER,
CPU_PEAK_60DAY                  NUMBER,
CPU_MEDIAN_60DAY                NUMBER,
CPU_AVERAGE_30DAY               NUMBER,
CPU_PEAK_30DAY                  NUMBER,
CPU_MEDIAN_30DAY                NUMBER,
PEAKSEASON_CPU_AVERAGE          NUMBER,
PEAKSEASON_CPU_PEAK             NUMBER,
PEAKSEASON_CPU_MEDIAN           NUMBER
);

CREATE TABLE PLC_CLUSTER_MEMORY_SUM
(
CLUSTER_NAME                    VARCHAR2(20) PRIMARY KEY,
MEMORY_AVERAGE_90DAY            NUMBER,
MEMORY_PEAK_90DAY               NUMBER,
MEMORY_MEDIAN_90DAY             NUMBER,
MEMORY_AVERAGE_60DAY            NUMBER,
MEMORY_PEAK_60DAY               NUMBER,
MEMORY_MEDIAN_60DAY             NUMBER,
MEMORY_AVERAGE_30DAY            NUMBER,
MEMORY_PEAK_30DAY               NUMBER,
MEMORY_MEDIAN_30DAY             NUMBER,
PEAKSEASON_MEMORY_AVERAGE       NUMBER,
PEAKSEASON_MEMORY_PEAK          NUMBER,
PEAKSEASON_MEMORY_MEDIAN        NUMBER
);

CREATE TABLE PLC_CLUSTER_COMPAT_DB_VER
(
CLUSTERWARE_VERSION             VARCHAR2(20),
COMPATIBLE_DB_VERSION           VARCHAR2(20)
);


CREATE TABLE PLC_OS_COMPAT_DB_VER
(
OS_VERSION                      VARCHAR2(20),
COMPATIBLE_DB_VERSION           VARCHAR2(20)
);
alter table PLC_OS_COMPAT_DB_VER add primary key (OS_VERSION, COMPATIBLE_DB_VERSION);

CREATE TABLE PLC_DATABASES
(
DB_NAME                         VARCHAR2(20) PRIMARY KEY,
PROD_OR_NON_PROD                VARCHAR2(20),
SHARED_OR_DEDICATED             VARCHAR2(20),
ORACLE_VERSION                  VARCHAR2(20),
CLUSTER_NAME_PRIMARY            VARCHAR2(20),
CLUSTER_NAME_STANDBY            VARCHAR2(20),
SGA_TARGET                      NUMBER,
SGA_MAX_SIZE                    NUMBER,
PGA_TARGET                      NUMBER,
PGA_MAX_SIZE                    NUMBER,
MEMORY_TARGET                   NUMBER,
MEMORY_MAX_SIZE                 NUMBER,
PARTITIONING_YN                 CHAR(1),
DATA_MASKING_SOURCE_YN          CHAR(1),
PDB_YN                          CHAR(1)
);

CREATE TABLE PLC_DB_INSTANCES
(
DB_NAME                         VARCHAR2(20),
INSTANCE_NAME                   VARCHAR2(20),
CLUSTER_NAME_PRIMARY            VARCHAR2(20),
CLUSTER_NAME_STANDBY            VARCHAR2(20),
NODE_SERVER_NAME_PRIMARY        VARCHAR2(20),
NODE_SERVER_NAME_STANDBY        VARCHAR2(20),
SGA_TARGET                      NUMBER,
SGA_MAX_SIZE                    NUMBER,
PGA_TARGET                      NUMBER,
PGA_MAX_SIZE                    NUMBER,
MEMORY_TARGET                   NUMBER,
MEMORY_MAX_SIZE                 NUMBER
);
ALTER TABLE PLC_DB_INSTANCES ADD PRIMARY KEY (DB_NAME, INSTANCE_NAME);

-- Intake fills part of this and others computed
CREATE TABLE PLC_DB_SCHEMAS
(
DB_NAME                         VARCHAR2(20),
SCHEMA_NAME                     VARCHAR2(20),
SCHEMA_PURPOSE                  VARCHAR2(20),
APP_NAME                        VARCHAR2(20),
APP_ACRONYM                     VARCHAR2(20),
SERVICE_NAME                    VARCHAR2(20),
CONCURRENT_USERS                NUMBER,
TRANSACTIONS_PER_SEC            NUMBER,
LOAD_PROFILE                    VARCHAR2(20),
IOPS_MAX                        NUMBER,
STORAGE_NEED_INITIAL_GB         NUMBER,
STORAGE_NEED_5YEAR_GB           NUMBER,
ACTIVE_DATAGUARD_NEEDED_YN      CHAR(1),
PARTITIONING_NEEDED_YN          CHAR(1),
DATA_MASKING_SOURCE_YN          CHAR(1),
PDB_YN                          CHAR(1),
COEXIST_NEEDED_WITH_APP         VARCHAR2(20),
PREFERRED_EXISTING_DB           VARCHAR2(20),
PREFERRED_EXISTING_CLUSTER      VARCHAR2(20),
PREFERRED_REASON_FOR            VARCHAR2(200),
IOPS_COMPUTED                   NUMBER,
SGA_COMPUTED                    NUMBER,
PGA_COMPUTED                    NUMBER,
MEMORY_COMPUTED                 NUMBER,
CPU_FLOPS_COMPUTED              NUMBER
);
ALTER TABLE PLC_DB_SCHEMAS ADD PRIMARY KEY (DB_NAME, SCHEMA_NAME);



CREATE TABLE PLC_INTAKE_APP_PROFILES
(
SCHEMA_NAME                     VARCHAR2(20),
SCHEMA_PURPOSE                  VARCHAR2(20),
APP_ACRONYM                     VARCHAR2(20),
APP_NAME                        VARCHAR2(20),
CONCURRENT_USERS                NUMBER,
TRANSACTIONS_PER_SEC            NUMBER,
LOAD_PROFILE                    VARCHAR2(20),
IOPS_MAX                        NUMBER,
STORAGE_NEED_INITIAL_GB         NUMBER,
STORAGE_NEED_5YEAR_GB           NUMBER,
ACTIVE_DATAGUARD_NEEDED_YN      CHAR(1),
PARTITIONING_NEEDED_YN          CHAR(1),
DATA_MASKING_SOURCE_YN          CHAR(1),
PDB_YN                          CHAR(1),
COEXIST_NEEDED_WITH_APP         VARCHAR2(20),
PREFERRED_EXISTING_DB           VARCHAR2(20),
PREFERRED_EXISTING_CLUSTER      VARCHAR2(20),
PREFERRED_REASON_FOR            VARCHAR2(200),
IOPS_COMPUTED                   NUMBER,
SGA_COMPUTED                    NUMBER,
PGA_COMPUTED                    NUMBER,
MEMORY_COMPUTED                 NUMBER,
CPU_CORE_COMPUTED               NUMBER,
FLOPS_COMPUTED          NUMBER
);
--ALTER TABLE PLC_INTAKE_APP_PROFILES ADD PRIMARY KEY (SCHEMA_NAME, SCHEMA_PURPOSE, APP_NAME);

CREATE TABLE PLC_SERVER_CLASS_CONFIG
(
SERVER_CONFIG                   VARCHAR2(20) PRIMARY KEY,
SERVER_VENDOR                   VARCHAR2(20),
SERVER_CLASS                    VARCHAR2(50),
CPU_CORE_COUNT                  NUMBER,
CPU_FREQUENCY_MHZ               NUMBER,
CPU_VENDOR                      VARCHAR2(20),
CPU_CLASS                       VARCHAR2(20),
MEMORY_GB                       NUMBER,
MEMORY_FREQUENCY                NUMBER,
FLOPS                           NUMBER
);

CREATE TABLE PLC_CLUSTER_LIMITS
(
SERVER_CONFIG                   VARCHAR2(20),
PROD_OR_NON_PROD                VARCHAR2(20),
CLUSTER_TYPE                    VARCHAR2(20),
NODE_COUNT                      NUMBER,
SHARED_DB_PER_CLUSTER           NUMBER,
SHARED_SCHEMA_PER_CLUSTER       NUMBER,
DEDICATED_DB_PER_CLUSTER        NUMBER,
TOTAL_DB_PER_CLUSTER            NUMBER,
TOTAL_SCHEMA_PER_CLUSTER        NUMBER,
TOTAL_STORAGE_PER_CLUSTER       NUMBER,
CPU_LOAD_LIMIT_AVERAGE          NUMBER,
CPU_LOAD_LIMIT_MEDIAN           NUMBER,
CPU_LOAD_LIMIT_MAX              NUMBER,
MEMORY_LOAD_LIMIT_AVERAGE       NUMBER,
MEMORY_LOAD_LIMIT_MEDIAN        NUMBER,
MEMORY_LOAD_LIMIT_MAX           NUMBER
);

alter table PLC_CLUSTER_LIMITS add primary key (SERVER_CONFIG, PROD_OR_NON_PROD, CLUSTER_TYPE, NODE_COUNT);

CREATE TABLE PLC_SHARED_DB_LIMITS
(
SERVER_CONFIG                   VARCHAR2(20),
PROD_OR_NON_PROD                VARCHAR2(20),
CLUSTER_TYPE                    VARCHAR2(20),
SGA_DB_MIN                      NUMBER,
SGA_DB_MAX                      NUMBER,
SGA_INSTANCE_MIN                NUMBER,
SGA_INSTANCE_MAX                NUMBER,
SCHEMA_PER_DB_MAX               NUMBER
);
alter table PLC_SHARED_DB_LIMITS add primary key (SERVER_CONFIG, PROD_OR_NON_PROD, CLUSTER_TYPE);


spool off

set echo off