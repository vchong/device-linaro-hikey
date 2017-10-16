#!/system/bin/sh
# performance
# ondemand
# sched
governor=${1}
if [ -z ${governor} ]; then
    governor="sched"
fi

for f in  $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor); do
    echo "${governor}" > $f
    if [ $? -ne 0 ]; then
        exit 1
    fi
done
