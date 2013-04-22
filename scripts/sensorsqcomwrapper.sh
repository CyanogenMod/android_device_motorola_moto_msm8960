#!/system/bin/sh
umask 000
rm -f /data/app/sensor_ctl_socket
exec /system/bin/sensors.qcom
