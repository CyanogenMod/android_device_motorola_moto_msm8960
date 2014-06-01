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

# Inline kernel building
TARGET_KERNEL_SOURCE := kernel/motorola/msm8960-common
TARGET_KERNEL_CONFIG := msm8960_mmi_defconfig
TARGET_KERNEL_SELINUX_CONFIG := msm8960_mmi_selinux_defconfig
BOARD_KERNEL_CMDLINE := console=/dev/null androidboot.hardware=qcom user_debug=31 loglevel=1 zcache androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x80200000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01600000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12884901888

# QCOM BSP
TARGET_USES_QCOM_BSP := true
COMMON_GLOBAL_CFLAGS += -DQCOM_BSP

# Telephony
BOARD_RIL_CLASS := ../../../$(LOCAL_PATH)/ril/MotorolaQualcommRIL.java
BOARD_RIL_NO_CELLINFOLIST := true

# Audio
BOARD_USES_LEGACY_ALSA_AUDIO := true
BOARD_USES_MOTOROLA_EMU_AUDIO := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth

# Camera
TARGET_PROVIDES_CAMERA_HAL := true
COMMON_GLOBAL_CFLAGS += -DMR0_CAMERA_BLOB -DQCOM_BSP_CAMERA_ABI_HACK -DDISABLE_HW_ID_MATCH_CHECK -DNEEDS_VECTORIMPL_SYMBOLS -DUSE_COPYBIT_COMPOSITION_FALLBACK

# Graphics
TARGET_QCOM_DISPLAY_VARIANT := caf
BOARD_EGL_CFG := $(LOCAL_PATH)/config/egl.cfg

# Custom relese tools for unified devices
TARGET_RELEASETOOLS_EXTENSIONS := device/motorola/moto_msm8960

# Assert
TARGET_OTA_ASSERT_DEVICE := moto_msm8960,xt901,solstice,xt905,smq_u,scorpion_mini_u,xt907,scorpion_mini,xt925,vanquish_u,xt926,vanquish,mb886,qinara,xt897,asanti,xt897c,asanti_c

# Recovery
TARGET_RECOVERY_NO_MSM_BSP := true
BOARD_CUSTOM_GRAPHICS := ../../../$(LOCAL_PATH)/graphics.c
TARGET_RECOVERY_PIXEL_FORMAT := "RGBA_8888"
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/etc/fstab.qcom
BOARD_RECOVERY_SWIPE := true

# TWRP
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
TARGET_USERIMAGES_USE_EXT4 := true
# Needs to be changed for M
DEVICE_RESOLUTION := 720x1280
#DEVICE_RESOLUTION := 540x960
