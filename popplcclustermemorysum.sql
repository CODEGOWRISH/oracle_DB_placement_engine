spool popplcclustermemorysum

insert into plc_cluster_memory_sum
(
    CLUSTER_NAME                              ,
    MEMORY_AVERAGE_90DAY                                  ,
    MEMORY_PEAK_90DAY                                     ,
    MEMORY_MEDIAN_90DAY                                   ,
    MEMORY_AVERAGE_60DAY                                  ,
    MEMORY_PEAK_60DAY                                     ,
    MEMORY_MEDIAN_60DAY                                   ,
    MEMORY_AVERAGE_30DAY                                  ,
    MEMORY_PEAK_30DAY                                     ,
    MEMORY_MEDIAN_30DAY                                   ,
    PEAKSEASON_MEMORY_AVERAGE                             ,
    PEAKSEASON_MEMORY_PEAK                                ,
    PEAKSEASON_MEMORY_MEDIAN
)
select
 b.cluster_name,
 sum(a.MEMORY_AVERAGE_90DAY), sum(a.MEMORY_PEAK_90DAY), sum(a.MEMORY_MEDIAN_90DAY),
 sum(a.MEMORY_AVERAGE_60DAY), sum(a.MEMORY_PEAK_60DAY), sum(a.MEMORY_MEDIAN_60DAY),
 sum(a.MEMORY_AVERAGE_30DAY), sum(a.MEMORY_PEAK_30DAY), sum(a.MEMORY_MEDIAN_30DAY),
 sum(a.PEAKSEASON_MEMORY_AVERAGE), sum(a.PEAKSEASON_MEMORY_PEAK), sum(a.PEAKSEASON_MEMORY_MEDIAN)
from
plc_server_MEMORY_sum a,
plc_servers b
where a.server_name = b.server_name
group by b.cluster_name;

spool off

