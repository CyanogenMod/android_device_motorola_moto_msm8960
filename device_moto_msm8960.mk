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

$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

LOCAL_PATH := device/motorola/moto_msm8960

# moto_msm8960 specific overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_LOCALES := en_US
PRODUCT_LOCALES += hdpi xhdpi
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml

# Audio
PRODUCT_PACKAGES += \
    audio_policy.msm8960 \
    audio.primary.msm8960

# HAL
PRODUCT_PACKAGES += \
    camera.msm8960 \
    copybit.msm8960 \
    gps.msm8960 \
    gralloc.msm8960 \
    hwcomposer.msm8960 \
    keystore.msm8960 \
    lights.MSM8960 \
    memtrack.msm8960 \
    nfc.msm8960 \
    power.msm8960

# WIFI
PRODUCT_PACKAGES += wcnss_service

# Symlinks
PRODUCT_PACKAGES += \
    mbhc.bin \
    wcd9310_anc.bin \
    WCNSS_qcom_wlan_nv_calibration.bin \
    WCNSS_qcom_wlan_nv_regulatory.bin

# Utilities
PRODUCT_PACKAGES += \
    charge_only_mode \
    mkfs.f2fs \
    fsck.f2fs \
    make_f2fs \
    mkf2fsuserimg.sh

# Misc
PRODUCT_PACKAGES += \
    DevicePerformanceSettingsHelper \
    sqlite3

# EGL config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/egl.cfg:system/lib/egl/egl.cfg

# GPS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/gps/izat.conf:system/etc/izat.conf \
    $(LOCAL_PATH)/gps/sap.conf:system/etc/sap.conf

# Location secuity configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/sec_config:system/etc/sec_config

# Wifi
PRODUCT_COPY_FILES += \
    kernel/motorola/msm8960dt-common/drivers/staging/prima/firmware_bin/WCNSS_cfg.dat:system/etc/firmware/wlan/prima/WCNSS_cfg.dat \
    kernel/motorola/msm8960dt-common/drivers/staging/prima/firmware_bin/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/wlan/cal_files/WCNSS_qcom_wlan_nv_calibration.bin:system/etc/firmware/wlan/prima/cal_files/WCNSS_qcom_wlan_nv_calibration.bin \
    $(LOCAL_PATH)/wlan/cal_files/WCNSS_qcom_wlan_nv_regulatory.bin:system/etc/firmware/wlan/prima/cal_files/WCNSS_qcom_wlan_nv_regulatory.bin

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.rc \
    init.recovery.qcom.rc \
    init.target.rc \
    ueventd.qcom.rc

# Init scripts
PRODUCT_PACKAGES += \
    init.mmi.boot.sh \
    init.mmi.touch.sh \
    init.qcom.post_boot.sh \
    init.qcom.sh \
    init.qcom.wifi.sh

# Scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/mount_pds.sh:system/bin/mount_pds.sh

BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
$(warning "USING F2FS for userdata")

# This ensures the needed build tools are available.
# TODO: make non-linux builds happy with external/f2fs-tool; system/extras/f2fs_utils
ifeq ($(HOST_OS),linux)
TARGET_USERIMAGES_USE_F2FS := true
endif

# TWRP
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/twrp.fstab:recovery/root/etc/twrp.fstab

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/config/snd_soc_msm_2x:system/etc/snd_soc_msm/snd_soc_msm_2x \
    $(LOCAL_PATH)/config/snd_soc_msm_2x_xt92x:system/etc/snd_soc_msm/snd_soc_msm_2x_xt92x

# Charger mode setup
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/moto_com.sh:system/bin/moto_com.sh

# Media config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/config/media_profiles_xt90x.xml:system/etc/media_profiles_xt90x.xml \
    $(LOCAL_PATH)/config/media_codecs.xml:system/etc/media_codecs.xml

# XT90x recovery
PRODUCT_COPY_FILES += \
    device/motorola/qcom-common/idc/atmxt-i2c.idc:recovery/root/vendor/firmware/atmxt-i2c.idc \
    vendor/motorola/moto_msm8960/proprietary/etc/firmware/atmxt-r2.tdat:recovery/root/vendor/firmware/atmxt-r2.tdat

# Include 960x540 boot animation in the zip
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bootanimation/540.zip:system/media/540.zip

# QCOM Display
PRODUCT_PROPERTY_OVERRIDES += \
    hw.trueMirrorSupported=1

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.enable-player=true \
    media.stagefright.enable-http=true \
    media.stagefright.enable-aac=true \
    media.stagefright.enable-qcp=true \
    media.stagefright.enable-fma2dp=true \
    media.stagefright.enable-scan=true \
    media.stagefright.use-awesome=true \
    mmp.enable.3g2=true \
    media.aac_51_output_enabled=true \
    ro.mot.vr_source_dsp=1 \
    af.resampler.quality=255

# Misc
PRODUCT_PROPERTY_OVERRIDES += \
    ro.usb.mtp=0x2e62 \
    ro.usb.mtp_adb=0x2e63 \
    ro.usb.ptp=0x2e64 \
    ro.usb.ptp_adb=0x2e65 \
    ro.usb.bpt=0x2e28 \
    ro.usb.bpt_adb=0x2e29 \
    ro.usb.bpteth=0x2e2a \
    ro.usb.bpteth_adb=0x2e2b \
    ro.qc.sdk.camera.facialproc=true \
    ro.qc.sdk.gestures.camera=false \
    ro.qc.sdk.sensors.gestures=false \
    persist.gps.qmienabled=true \
    persist.fuse_sdcard=true \
    ro.crypto.fuse_sdcard=true \
    ro.qc.sdk.audio.fluencetype=fluence \
    ro.hdmi.enable=true \
    ro.cwm.forbid_format="/fsg,/firmware,/persist,/modem,/boot"

# Opengles version 2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072

# LTE, CDMA, GSM/WCDMA
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_network=10 \
    telephony.lteOnCdmaDevice=1 \
    persist.radio.mode_pref_nv10=1 \
    persist.radio.no_wait_for_card=1 \
    persist.radio.dfr_mode_set=1 \
    persist.rmnet.mux=disabled \
    persist.radio.eons.enabled=1 \
    persist.radio.call_type=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.timed.enable=true

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1

$(call inherit-product, device/motorola/qcom-common/qcom-common.mk)
$(call inherit-product, device/motorola/qcom-common/idc/idc.mk)
$(call inherit-product, device/motorola/qcom-common/keychars/keychars.mk)
$(call inherit-product, device/motorola/qcom-common/keylayout/keylayout.mk)
$(call inherit-product, device/motorola/qcom-common/modules/nfc/nfc.mk)
$(call inherit-product, vendor/motorola/moto_msm8960/moto_msm8960-vendor.mk)
