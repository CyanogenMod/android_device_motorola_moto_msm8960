# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
TARGET_CPU_VARIANT := cortex-a9
TARGET_CPU_SMP := true
COMMON_GLOBAL_CFLAGS += -D__ARM_USE_PLD -D__ARM_CACHE_LINE_SIZE=64
TARGET_GLOBAL_CFLAGS += -mfpu=neon-vfpv4 -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon-vfpv4 -mfloat-abi=softfp
BOARD_USES_QCOM_HARDWARE := true

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

# Enable WEBGL in WebKit
ENABLE_WEBGL := true
TARGET_FORCE_CPU_UPLOAD := true

# Global flags
COMMON_GLOBAL_CFLAGS += -DQCOM_HARDWARE -DMOTOROLA_UIDS -DCAMERA_POWERMODE

TARGET_USES_MOTOROLA_LOG := true

BOARD_HAS_NO_SELECT_BUTTON := true

# QCOM hardware
BOARD_USES_QCOM_HARDWARE := true

TARGET_PROVIDES_LIBLIGHT := true

# Graphics
USE_OPENGL_RENDERER := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_ION := true
BOARD_EGL_CFG := $(LOCAL_PATH)/config/egl.cfg

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUEDROID_VENDOR_CONF := $(LOCAL_PATH)/modules/bluetooth/vnd_moto.txt
BOARD_BLUETOOTH_USES_HCIATTACH_PROPERTY := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true

# GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_FLUENCE_INCALL := true
BOARD_USES_SEPERATED_AUDIO_INPUT := true
TARGET_QCOM_AUDIO_VARIANT:=caf

# Camera
BOARD_CAMERA_USE_MM_HEAP := true
TARGET_PROVIDES_CAMERA_HAL := true
#BOARD_NEEDS_MEMORYHEAPPMEM := true

# Power
TARGET_PROVIDES_POWERHAL := true

#use old ion
BOARD_HAVE_OLD_ION_API := true

# Number of supplementary service groups allowed by init
TARGET_NR_SVC_SUPP_GIDS := 28
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := false

# assert
TARGET_OTA_ASSERT_DEVICE := xt925,xt926,xt907,vanquish_u,vanquish,scorpion_mini,mb886,qinara,asanti,asanti_c,xt897

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "RGBA_8888"
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
BOARD_SUPPRESS_EMMC_WIPE := true
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/recovery.fstab
TARGET_USERIMAGES_USE_EXT4 := true
