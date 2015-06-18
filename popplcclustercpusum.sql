spool popplcclustercpusum

insert into plc_cluster_cpu_sum
(
    CLUSTER_NAME                              ,
    CPU_AVERAGE_90DAY                                  ,
    CPU_PEAK_90DAY                                     ,
    CPU_MEDIAN_90DAY                                   ,
    CPU_AVERAGE_60DAY                                  ,
    CPU_PEAK_60DAY                                     ,
    CPU_MEDIAN_60DAY                                   ,
    CPU_AVERAGE_30DAY                                  ,
    CPU_PEAK_30DAY                                     ,
    CPU_MEDIAN_30DAY                                   ,
    PEAKSEASON_CPU_AVERAGE                             ,
    PEAKSEASON_CPU_PEAK                                ,
    PEAKSEASON_CPU_MEDIAN
)
select
 b.cluster_name,
 sum(a.CPU_AVERAGE_90DAY), sum(a.CPU_PEAK_90DAY), sum(a.CPU_MEDIAN_90DAY),
 sum(a.CPU_AVERAGE_60DAY), sum(a.CPU_PEAK_60DAY), sum(a.CPU_MEDIAN_60DAY),
 sum(a.CPU_AVERAGE_30DAY), sum(a.CPU_PEAK_30DAY), sum(a.CPU_MEDIAN_30DAY),
 sum(a.PEAKSEASON_CPU_AVERAGE), sum(a.PEAKSEASON_CPU_PEAK), sum(a.PEAKSEASON_CPU_MEDIAN)
from
plc_server_cpu_sum a,
plc_servers b
where a.server_name = b.server_name
group by b.cluster_name;

spool off
