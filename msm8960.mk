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

## overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Audio
PRODUCT_PACKAGES += \
    audio_policy.msm8960 \
    audio.primary.msm8960

# HAL
PRODUCT_PACKAGES += \
    camera.msm8960 \
    copybit.msm8960 \
    gralloc.msm8960 \
    hwcomposer.msm8960 \
    lights.MSM8960 \
    memtrack.msm8960 \
    power.msm8960

# GPS
PRODUCT_PACKAGES += \
    gps.msm8960

# Motorola
PRODUCT_PACKAGES += \
    batt_health \
    charge_only_mode \
    graphicsd \
    mot_boot_mode

# Misc
PRODUCT_PACKAGES += \
    DevicePerformanceSettingsHelper

# Symlinks
PRODUCT_PACKAGES += \
    mbhc.bin \
    wcd9310_anc.bin

# EGL config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/egl.cfg:system/lib/egl/egl.cfg

# GPS configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps/gps.conf:system/etc/gps.conf

# Wifi
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wlan/WCNSS_cfg.dat:system/etc/firmware/wlan/prima/WCNSS_cfg.dat \
    $(LOCAL_PATH)/wlan/WCNSS_qcom_cfg.ini:system/etc/firmware/wlan/prima/WCNSS_qcom_cfg.ini

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.rc \
    init.target.rc \
    ueventd.qcom.rc

# Init scripts
PRODUCT_PACKAGES += \
    init.qcom.post_boot.sh \
    init.qcom.sh

# TWRP
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/twrp.fstab:recovery/root/etc/twrp.fstab

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/config/snd_soc_msm_2x:system/etc/snd_soc_msm/snd_soc_msm_2x

# Media config
ifeq ($(TARGET_USES_MOTOROLA_MSM8960_COMMON_MEDIA_PROFILES),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/media_profiles.xml:system/etc/media_profiles.xml
endif

# Media codecs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/media_codecs.xml:system/etc/media_codecs.xml

# Misc
PRODUCT_PROPERTY_OVERRIDES += \
    ro.usb.mtp=0x2e32 \
    ro.usb.mtp_adb=0x2e33 \
    ro.usb.ptp=0x2e30 \
    ro.usb.ptp_adb=0x2e31 \
    ro.hdmi.enable=true \
    ro.cwm.forbid_format="/fsg,/firmware,/persist,/modem,/boot"

# Opengles version 2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072

# Radio and Telephony
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.ril_class=MotorolaQualcommRIL

# Misc
PRODUCT_PROPERTY_OVERRIDES += \
    persist.fuse_sdcard=true \
    ro.qc.sdk.audio.fluencetype=fluence

# Wifi
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=30

$(call inherit-product, device/motorola/qcom-common/qcom-common.mk)
