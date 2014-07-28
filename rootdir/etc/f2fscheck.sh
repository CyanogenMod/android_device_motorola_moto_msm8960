#!/sbin/bbx sh
#
# Check if userdata is f2fs and copy in the right fstab
#

FSTYPE=`/sbin/bbx blkid /dev/block/platform/msm_sdcc.1/by-name/userdata | /sbin/bbx cut -d ' ' -f3 | /sbin/bbx cut -d '"' -f2`

if [ "$FSTYPE" == "ext4" ]
then
  /sbin/bbx rm /f2fs-fstab.qcom
else
  /sbin/bbx cp -f /f2fs-fstab.qcom /etc/recovery.fstab
  /sbin/bbx mv -f /f2fs-fstab.qcom /fstab.qcom
fi
