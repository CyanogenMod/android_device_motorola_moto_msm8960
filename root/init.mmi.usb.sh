#!/system/bin/sh
# Copyright (c) 2012, Code Aurora Forum. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Code Aurora Forum, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# Allow unique persistent serial numbers for devices connected via usb
# User needs to set unique usb serial number to persist.usb.serialno and
# if persistent serial number is not set then Update USB serial number if
# passed from command line
#
usb_action=`getprop usb.mmi-usb-sh.action`
echo "mmi-usb-sh: action = \"$usb_action\""
sys_usb_config=`getprop sys.usb.config`

tcmd_ctrl_diag ()
{
    ctrl_diag=`getprop tcmd.ctrl_diag`
    echo "mmi-usb-sh: tcmd.ctrl_diag = $ctrl_diag"

    case "$ctrl_diag" in
        "0")
            if [[ "$sys_usb_config" == *diag* ]]
            then
                new_usb_config=${sys_usb_config/diag,/}
                echo "mmi-usb-sh: disabling diag ($new_usb_config)"
                setprop sys.usb.config $new_usb_config
            fi
        ;;
        "1")
            if [[ "$sys_usb_config" != *diag* ]]
            then
                new_usb_config="diag,$sys_usb_config"
                echo "mmi-usb-sh: enabling diag ($new_usb_config)"
                setprop sys.usb.config $new_usb_config
            fi
        ;;
    esac

    exit 0
}

case "$usb_action" in
    "")
    ;;
    "tcmd.ctrl_diag")
        case "$sys_usb_config" in
            "usbnet,adb" | "usbnet" | "usbnet,diag,adb" | "usbnet,diag")
                tcmd_ctrl_diag
            ;;
        esac
    ;;
esac

serialno=`getprop persist.usb.serialno`
case "$serialno" in
    "")
    serialnum=`getprop ro.serialno`
    echo "$serialnum" > /sys/class/android_usb/android0/iSerial
    ;;
    * )
    echo "$serialno" > /sys/class/android_usb/android0/iSerial
esac

chown root.system /sys/devices/platform/msm_hsusb/gadget/wakeup
chmod 220 /sys/devices/platform/msm_hsusb/gadget/wakeup

#
# Allow persistent usb charging disabling
# User needs to set usb charging disabled in persist.usb.chgdisabled
#
target=`getprop ro.board.platform`
usbchgdisabled=`getprop persist.usb.chgdisabled`
case "$usbchgdisabled" in
    "") ;; #Do nothing here
    * )
    case $target in
        "msm8660")
        echo "$usbchgdisabled" > /sys/module/pmic8058_charger/parameters/disabled
        echo "$usbchgdisabled" > /sys/module/smb137b/parameters/disabled
	;;
        "msm8960")
        echo "$usbchgdisabled" > /sys/module/pm8921_charger/parameters/disabled
	;;
    esac
esac

#
# Allow USB enumeration with default PID/VID
#
echo 1  > /sys/class/android_usb/f_mass_storage/lun/nofua
usb_config=`getprop persist.sys.usb.config`
bootmode=`getprop ro.bootmode`
buildtype=`getprop ro.build.type`
case "$bootmode" in
    "bp-tools" )
        setprop persist.sys.usb.config diag,serial_smd,serial_tty,rmnet,usbnet,adb
    ;;
    "factory" )
        setprop persist.sys.usb.config usbnet
    ;;
    "qcom" )
        setprop persist.sys.usb.config diag,serial_smd,serial_tty,rmnet_bam,mass_storage,adb
    ;;
    * )
        case "$usb_config" in
            "ptp,adb" | "mtp,adb" | "mass_storage,adb" | "ptp" | "mtp" | "mass_storage" )
            ;;
            *)
                case "$buildtype" in
                    "user" )
                        setprop persist.sys.usb.config mtp
                    ;;
                    * )
                        setprop persist.sys.usb.config mtp,adb
                    ;;
                esac
            ;;
        esac
    ;;
esac
