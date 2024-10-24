#!/vendor/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

################################################################################

# disable thermal bcl hotplug to switch governor
write /sys/module/msm_thermal/core_control/enabled 0
get-set-forall /sys/devices/soc.0/qcom,bcl.*/mode disable
bcl_hotplug_mask=`get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_mask 0`
bcl_hotplug_soc_mask=`get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask 0`

# some files in /sys/devices/system/cpu are created after the restorecon of
# /sys/. These files receive the default label "sysfs".
restorecon -R /sys/devices/system/cpu

# ensure at most one A57 is online when thermal hotplug is disabled
write /sys/devices/system/cpu/cpu4/online 1
write /sys/devices/system/cpu/cpu5/online 0
write /sys/devices/system/cpu/cpu6/online 0
write /sys/devices/system/cpu/cpu7/online 0

# files in /sys/devices/system/cpu4 are created after enabling cpu4.
# These files receive the default label "sysfs".
# Restorecon again to give new files the correct label.
restorecon -R /sys/devices/system/cpu

# some files in /sysmodule/msm_performance/parameters are created after the restorecon of
# /sys/. These files receive the default label "sysfs".
restorecon -R /sys/module/msm_performance/parameters

# Enable CPU retention
write /sys/module/lpm_levels/system/a53/cpu0/retention/idle_enabled 1
write /sys/module/lpm_levels/system/a53/cpu1/retention/idle_enabled 1
write /sys/module/lpm_levels/system/a53/cpu2/retention/idle_enabled 1
write /sys/module/lpm_levels/system/a53/cpu3/retention/idle_enabled 1
write /sys/module/lpm_levels/system/a57/cpu4/retention/idle_enabled 1
write /sys/module/lpm_levels/system/a57/cpu5/retention/idle_enabled 1
write /sys/module/lpm_levels/system/a57/cpu6/retention/idle_enabled 1
write /sys/module/lpm_levels/system/a57/cpu7/retention/idle_enabled 1

# Enable L2 retention
write /sys/module/lpm_levels/system/a53/a53-l2-retention/idle_enabled 1
write /sys/module/lpm_levels/system/a57/a57-l2-retention/idle_enabled 1

# enable LPM
write /sys/module/lpm_levels/parameters/sleep_disabled 0

# configure governor settings for little cluster
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor "schedutil"
restorecon -R /sys/devices/system/cpu # must restore after schedutil
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_load 85
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 5000
write /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 0

# configure governor settings for big cluster
write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor "schedutil"
restorecon -R /sys/devices/system/cpu # must restore after schedutil
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_load 85
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/down_rate_limit_us 5000
write /sys/devices/system/cpu/cpu4/cpufreq/schedutil/up_rate_limit_us 0

# plugin remaining A57s
write /sys/devices/system/cpu/cpu5/online 1
write /sys/devices/system/cpu/cpu6/online 1
write /sys/devices/system/cpu/cpu7/online 1

# Configure core_ctl module parameters
write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 4
write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 2
write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 60
write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 30
write /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms  100
write /sys/devices/system/cpu/cpu4/core_ctl/task_thres 4
write /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 1
write /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 4
write /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 4
write /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres 0
write /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres 0
write /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms 100
write /sys/devices/system/cpu/cpu0/core_ctl/task_thres 4
write /sys/devices/system/cpu/cpu0/core_ctl/not_preferred 1
write /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster 0
chown system:system /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
chown system:system /sys/devices/system/cpu/cpu4/core_ctl/max_cpus

# android background processes are set to nice 10. Never schedule these on the a57s.
write /proc/sys/kernel/sched_upmigrate_min_nice 9

# Enable rps static configuration
write /sys/class/net/rmnet_ipa0/queues/rx-0/rps_cpus 8

# Devfreq
get-set-forall  /sys/class/devfreq/qcom,cpubw*/governor bw_hwmon
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent 20
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/guard_band_mbps 30
restorecon -R /sys/class/devfreq/qcom,cpubw*
get-set-forall  /sys/class/devfreq/qcom,mincpubw.*/governor cpufreq

# Disable sched_boost
write /proc/sys/kernel/sched_boost 0

# change GPU initial power level from 305MHz(level 4) to 180MHz(level 5) for power savings
write /sys/class/kgsl/kgsl-3d0/default_pwrlevel 5

# set GPU default governor to msm-adreno-tz
write /sys/class/devfreq/fdb00000.qcom,kgsl-3d0/governor msm-adreno-tz

# re-enable thermal and BCL hotplug
write /sys/module/msm_thermal/core_control/enabled 1
get-set-forall /sys/devices/soc.0/qcom,bcl.*/low_threshold_ua 50000
get-set-forall /sys/devices/soc.0/qcom,bcl.*/high_threshold_ua 4200000
get-set-forall /sys/devices/soc.0/qcom,bcl.*/vph_low_thresh_uv 3300000
get-set-forall /sys/devices/soc.0/qcom,bcl.*/vph_high_thresh_uv 4300000
get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_mask $bcl_hotplug_mask
get-set-forall /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask $bcl_hotplug_soc_mask
get-set-forall /sys/devices/soc.0/qcom,bcl.*/mode enable
