#
# Copyright (C) 2013 The CyanogenMod Project
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

LOCAL_PATH := device/motorola/msm8960-common

BOARD_VENDOR := motorola-msm8960

# Platform
TARGET_BOARD_PLATFORM := msm8960
TARGET_BOARD_PLATFORM_GPU := qcom-adreno200

# Bootloader
TARGET_NO_BOOTLOADER := true
TARGET_BOOTLOADER_BOARD_NAME := MSM8960

TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_CPU := cortex-a9
TARGET_CPU_VARIANT := krait
TARGET_CPU_SMP := true
COMMON_GLOBAL_CFLAGS += -D__ARM_USE_PLD -D__ARM_CACHE_LINE_SIZE=64
TARGET_GLOBAL_CFLAGS += -mfpu=neon-vfpv4 -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon-vfpv4 -mfloat-abi=softfp

# Krait optimizations
TARGET_USE_KRAIT_BIONIC_OPTIMIZATION := true
TARGET_USE_KRAIT_PLD_SET := true
TARGET_KRAIT_BIONIC_PLDOFFS := 10
TARGET_KRAIT_BIONIC_PLDTHRESH := 10
TARGET_KRAIT_BIONIC_BBTHRESH := 64
TARGET_KRAIT_BIONIC_PLDSIZE := 64

# Wifi related defines
BOARD_HAS_QCOM_WLAN := true
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_NAME := "wlan"
BOARD_WLAN_DEVICE := qcwcn
BOARD_NO_APSME_ATTR:=true

#storage
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true
BOARD_VOLD_MAX_PARTITIONS := 40
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/platform/msm_hsusb/gadget/lun%d/file
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x00A00000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x00A00000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1560281088
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_HAS_LARGE_FILESYSTEM := true

# Inline kernel building
TARGET_KERNEL_SOURCE := kernel/motorola/msm8960-common
TARGET_KERNEL_CONFIG := msm8960_mmi_defconfig
TARGET_KERNEL_SELINUX_CONFIG := msm8960_mmi_selinux_defconfig
BOARD_KERNEL_CMDLINE := console=/dev/null androidboot.hardware=qcom user_debug=31 loglevel=1 zcache
BOARD_KERNEL_BASE := 0x80200000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01600000
#backwards compat for 4.1 (making recoveries)
#BOARD_FORCE_RAMDISK_ADDRESS := 0x81600000

# Enable WEBGL in WebKit
ENABLE_WEBGL := true
TARGET_FORCE_CPU_UPLOAD := true

# Global flags
COMMON_GLOBAL_CFLAGS += -DQCOM_HARDWARE -DMOTOROLA_UIDS

TARGET_USES_MOTOROLA_LOG := true

BOARD_HAS_NO_SELECT_BUTTON := true

# QCOM hardware
BOARD_USES_QCOM_HARDWARE := true

TARGET_PROVIDES_LIBLIGHT := true

# QCOM enhanced A/V
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

# Graphics
TARGET_QCOM_DISPLAY_VARIANT := caf
USE_OPENGL_RENDERER := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_ION := true
BOARD_EGL_CFG := $(LOCAL_PATH)/config/egl.cfg
# Use retire fence from MDP driver
TARGET_DISPLAY_USE_RETIRE_FENCE := true

# Telephony
BOARD_PROVIDES_LIBRIL := true
BOARD_RIL_CLASS := ../../../$(LOCAL_PATH)/modules/ril/MotorolaQualcommRIL.java
BOARD_RIL_NO_CELLINFOLIST:=true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true

# GPS
BOARD_HAVE_NEW_QC_GPS := true

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_FLUENCE_INCALL := true
BOARD_USES_SEPERATED_AUDIO_INPUT := true
TARGET_QCOM_AUDIO_VARIANT := caf
TARGET_USES_QCOM_COMPRESSED_AUDIO := true

# Camera
TARGET_PROVIDES_CAMERA_HAL := true
COMMON_GLOBAL_CFLAGS += -DMR0_CAMERA_BLOB -DCAMERA_POWERMODE -DQCOM_BSP_CAMERA_ABI_HACK -DDISABLE_HW_ID_MATCH_CHECK
#camera abi compatiblily
TARGET_DISPLAY_INSECURE_MM_HEAP := true

# Power
TARGET_PROVIDES_POWERHAL := true

# Number of supplementary service groups allowed by init
TARGET_NR_SVC_SUPP_GIDS := 28
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := false

# assert
TARGET_OTA_ASSERT_DEVICE := xt925,xt926,xt907,vanquish_u,vanquish,scorpion_mini,mb886,qinara,asanti,asanti_c,xt897,xt897c

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "RGBA_8888"
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
BOARD_SUPPRESS_EMMC_WIPE := true
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/etc/fstab.qcom
TARGET_USERIMAGES_USE_EXT4 := true
RECOVERY_FSTAB_VERSION := 2

#TWRP
RECOVERY_GRAPHICS_USE_LINELENGTH := true
TW_NO_USB_STORAGE := true
TW_INTERNAL_STORAGE_PATH := "/data/media"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_INITRC := $(LOCAL_PATH)/init.recovery.rc

# SELinux
BOARD_SEPOLICY_DIRS += \
	device/motorola/msm8960-common/sepolicy

BOARD_SEPOLICY_UNION += \
	adbd.te \
	file_contexts \
	property_contexts \
	te_macros \
	bluetooth_loader.te \
	bridge.te \
	camera.te \
	conn_init.te \
	device.te \
	dhcp.te \
	dnsmasq.te \
	domain.te \
	drmserver.te \
	file.te \
	hostapd.te \
	init.te \
	libqc-opt.te \
	mediaserver.te \
	mpdecision.te \
	netd.te \
	netmgrd.te \
	nfc.te \
	property.te \
	qcom.te \
	qmux.te \
	radio.te \
	rild.te \
	rmt.te \
	sdcardd.te \
	sensors.te \
	surfaceflinger.te \
	system.te \
	tee.te \
	thermald.te \
	ueventd.te \
	vold.te \
	wpa_supplicant.te \
	zygote.te
