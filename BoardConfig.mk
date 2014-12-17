#
# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# QCOM SELinux policy
include device/qcom/sepolicy/sepolicy.mk

# inherit from the proprietary version
-include vendor/motorola/moto_msm8960/BoardConfigVendor.mk

BOARD_VENDOR := motorola-qcom

# Platform
TARGET_BOARD_PLATFORM_GPU := qcom-adreno200
TARGET_BOARD_PLATFORM := msm8960
TARGET_BOOTLOADER_BOARD_NAME := MSM8960
TARGET_CPU_VARIANT := krait

-include device/motorola/qcom-common/BoardConfigCommon.mk

LOCAL_PATH := device/motorola/moto_msm8960

TARGET_SPECIFIC_HEADER_PATH += $(LOCAL_PATH)/include

# Vendor Init
TARGET_UNIFIED_DEVICE := true
TARGET_INIT_VENDOR_LIB := libinit_msm
TARGET_LIBINIT_DEFINES_FILE := device/motorola/moto_msm8960/init/init_moto_msm8960.c

TARGET_USES_WCNSS_CTRL := true

BOARD_USES_LEGACY_MMAP := true

# Inline kernel building
TARGET_KERNEL_SOURCE := kernel/motorola/msm8960dt-common
TARGET_KERNEL_CONFIG := msm8960_mmi_defconfig
TARGET_KERNEL_SELINUX_CONFIG := msm8960_mmi_selinux_defconfig
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 maxcpus=2 vmalloc=400M androidboot.write_protect=0 zcache
BOARD_KERNEL_BASE := 0x80200000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x02200000 --dt $(LOCAL_PATH)/dt.img
#BOARD_USERDATAIMAGE_PARTITION_SIZE := 12884901888

WLAN_MODULES:
	mkdir -p $(KERNEL_MODULES_OUT)/prima
	mv $(KERNEL_MODULES_OUT)/wlan.ko $(KERNEL_MODULES_OUT)/prima/prima_wlan.ko
	ln -sf /system/lib/modules/prima/prima_wlan.ko $(TARGET_OUT)/lib/modules/wlan.ko

TARGET_KERNEL_MODULES += WLAN_MODULES

# QCOM BSP
TARGET_USES_QCOM_BSP := true

# Audio
BOARD_USES_LEGACY_ALSA_AUDIO := true
BOARD_USES_MOTOROLA_EMU_AUDIO := true
QCOM_ANC_HEADSET_ENABLED := false
QCOM_FLUENCE_ENABLED := false

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth

# Camera
TARGET_PROVIDES_CAMERA_HAL := true

# Graphics
BOARD_EGL_CFG := $(LOCAL_PATH)/config/egl.cfg

# Media
TARGET_NO_ADAPTIVE_PLAYBACK := true

# Custom relese tools for unified devices
TARGET_RELEASETOOLS_EXTENSIONS := device/motorola/moto_msm8960

# Assert
TARGET_OTA_ASSERT_DEVICE := moto_msm8960,xt907,scorpion_mini,smq,xt926,vanquish

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "RGBA_8888"
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/etc/fstab.qcom
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_RECOVERY_FSTYPE_MOUNT_OPTIONS := ext4=max_batch_time=0,commit=1,data=ordered,barrier=1,errors=panic,nodelalloc|f2fs=errors=recover

# TWRP
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
# Needs to be changed for M
DEVICE_RESOLUTION := 720x1280
#DEVICE_RESOLUTION := 540x960

# SELinux
BOARD_SEPOLICY_DIRS += \
    device/motorola/moto_msm8960/sepolicy

BOARD_SEPOLICY_UNION += \
    atvc.te \
    atvc_core.te \
    batt_health.te \
    bootmodem.te \
    device.te \
    file.te \
    file_contexts \
    hw_revs.te \
    keystore.te \
    location.te \
    mmi-boot-sh.te \
    mmi-touch-sh.te \
    mm-pp-daemon.te \
    mm-qcamerad.te \
    mpdecision.te \
    netd.te \
    platform_app.te \
    property_contexts \
    property.te \
    qdumpd.te \
    rmt_storage.te \
    sensors.te \
    surfaceflinger.te \
    thermal-engine.te \
    ueventd.te \
    whisperd.te
