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
# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/base/nfc-extras/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml

## overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.usb.default \
    audio_policy.msm8960 \
    audio.primary.msm8960 \
    audio.r_submix.default \
    alsa.msm8960 \
    libalsa-intf \
    libaudioutils \
    aplay \
    amix \
    arec \
    alsaucm_test

#motorola
PRODUCT_PACKAGES += \
	aplogd \
	modemlog \
	batt_health \
	charge_only_mode \
	graphicsd \
	mot_boot_mode \
	recover_userdata \
	libwiperjni.so \
	libxt_native.so \
	wiperiface

#misc
PRODUCT_PACKAGES += \
	WCNSS_qcom_wlan_nv.bin \
    lights.msm8960 \
	tcpdump \
    Torch \
    Stk \
    libxml2

# Charger
PRODUCT_PACKAGES += charger charger_res_images

# QRNGD
PRODUCT_PACKAGES += qrngd

#bluetooth
PRODUCT_PACKAGES += \
            hciconfig \
            hcitool

PRODUCT_COPY_FILES += $(LOCAL_PATH)/modules/bluetooth/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

# HAL
PRODUCT_PACKAGES += \
    copybit.msm8960 \
    gralloc.msm8960 \
    hwcomposer.msm8960 \
    camera.msm8960 \
    power.msm8960

#GPS
PRODUCT_PACKAGES += \
	libloc_adapter \
	libloc_eng \
	libgps.utils \
	gps.msm8960

# NFC Support
# NFCEE access control
ifeq ($(TARGET_BUILD_VARIANT),user)
    NFCEE_ACCESS_PATH := $(LOCAL_PATH)/config/nfcee_access.xml
else
    NFCEE_ACCESS_PATH := $(LOCAL_PATH)/config/nfcee_access_debug.xml
endif

PRODUCT_COPY_FILES += $(NFCEE_ACCESS_PATH):system/etc/nfcee_access.xml

PRODUCT_PACKAGES += \
	nfc.msm8960 \
    libnfc \
    libnfc_jni \
    Nfc \
    Tag \
    com.android.nfc_extras

# Misc
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    HoloSpiralWallpaper \
    VisualizationWallpapers \
    librs_jni

# keylayouts
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/keylayout/atmel_mxt_ts.kl:system/usr/keylayout/atmel_mxt_ts.kl \
	$(LOCAL_PATH)/keylayout/Button_Jack.kl:system/usr/keylayout/Button_Jack.kl \
	$(LOCAL_PATH)/keylayout/cyttsp-i2c.kl:system/usr/keylayout/cyttsp-i2c.kl \
	$(LOCAL_PATH)/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
	$(LOCAL_PATH)/keylayout/keypad_8960.kl:system/usr/keylayout/keypad_8960.kl \
	$(LOCAL_PATH)/keylayout/keypad_8960_liquid.kl:system/usr/keylayout/keypad_8960_liquid.kl \
	$(LOCAL_PATH)/keylayout/philips_remote_ir.kl:system/usr/keylayout/philips_remote_ir.kl \
	$(LOCAL_PATH)/keylayout/samsung_remote_ir.kl:system/usr/keylayout/samsung_remote_ir.kl \
	$(LOCAL_PATH)/keylayout/ue_rf4ce_remote.kl:system/usr/keylayout/ue_rf4ce_remote.kl

# Keychars
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keychars/evfwd.kcm:system/usr/keychars/evfwd.kcm \
    $(LOCAL_PATH)/keychars/kbd_ar_basic.kcm:system/usr/keychars/kbd_ar_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_br_abnt2.kcm:system/usr/keychars/kbd_br_abnt2.kcm \
    $(LOCAL_PATH)/keychars/kbd_ca_fr.kcm:system/usr/keychars/kbd_ca_fr.kcm \
    $(LOCAL_PATH)/keychars/kbd_de_basic.kcm:system/usr/keychars/kbd_de_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_dk_basic.kcm:system/usr/keychars/kbd_dk_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_es_basic.kcm:system/usr/keychars/kbd_es_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_fi_basic.kcm:system/usr/keychars/kbd_fi_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_fr_basic.kcm:system/usr/keychars/kbd_fr_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_gb_basic.kcm:system/usr/keychars/kbd_gb_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_gr_basic.kcm:system/usr/keychars/kbd_gr_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_il_basic.kcm:system/usr/keychars/kbd_il_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_it_basic.kcm:system/usr/keychars/kbd_it_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_latam_basic.kcm:system/usr/keychars/kbd_latam_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_no_basic.kcm:system/usr/keychars/kbd_no_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_pl_basic.kcm:system/usr/keychars/kbd_pl_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_ru_basic.kcm:system/usr/keychars/kbd_ru_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_se_basic.kcm:system/usr/keychars/kbd_se_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_us_basic.kcm:system/usr/keychars/kbd_us_basic.kcm \
    $(LOCAL_PATH)/keychars/kbd_us_intl.kcm:system/usr/keychars/kbd_us_intl.kcm \
    $(LOCAL_PATH)/keychars/usb_keyboard_102_en_us.kcm:system/usr/keychars/usb_keyboard_102_en_us.kcm

#scripts
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/scripts/init.goldfish.sh:system/etc/init.goldfish.sh \
	$(LOCAL_PATH)/scripts/init.qcom.bt.sh:system/etc/init.qcom.bt.sh \
	$(LOCAL_PATH)/scripts/init.qcom.coex.sh:system/etc/init.qcom.coex.sh \
	$(LOCAL_PATH)/scripts/init.qcom.fm.sh:system/etc/init.qcom.fm.sh \
	$(LOCAL_PATH)/scripts/init.qcom.mdm_links.sh:system/etc/init.qcom.mdm_links.sh \
	$(LOCAL_PATH)/scripts/init.qcom.modem_links.sh:system/etc/init.qcom.modem_links.sh \
	$(LOCAL_PATH)/scripts/init.qcom.post_boot.sh:system/etc/init.qcom.post_boot.sh \
	$(LOCAL_PATH)/scripts/qcamerasrvwrapper.sh:system/bin/qcamerasrvwrapper.sh \
	$(LOCAL_PATH)/scripts/sensorsqcomwrapper.sh:system/bin/sensorsqcomwrapper.sh \
	$(LOCAL_PATH)/scripts/mount_pds.sh:system/bin/mount_pds.sh

# We have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# QCOM Display
PRODUCT_PACKAGES += \
    libgenlock \
    libmemalloc \
    liboverlay \
    libqdutils \
    libtilerenderer \
    libI420colorconvert

# Omx
PRODUCT_PACKAGES += \
    libdivxdrmdecrypt \
    libmm-omxcore \
    libOmxCore \
    libstagefrighthw \
    libOmxVdec \
    libOmxVenc \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxEvrcEnc \
    libOmxQcelp13Enc

# Filesystem management tools
PRODUCT_PACKAGES += \
    make_ext4fs \
    e2fsck \
    setup_fs

#wifi
PRODUCT_PACKAGES += \
	libnetcmdiface

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/system/lib/libqc-opt.so

# QCOM
PRODUCT_PROPERTY_OVERRIDES += \
    com.qc.hardware=true

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.audio.fluence.mode=endfire \
    persist.audio.vr.enable=false \
    persist.audio.handset.mic=digital \
    ro.qc.sdk.audio.fluencetype=fluence \
    ro.qc.sdk.audio.ssr=false

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.hfp.ver=1.6 \
    ro.qualcomm.bluetooth.sap=true \
    ro.qualcomm.bt.hci_transport=smd \
    ro.bluetooth.request.master=true \
    ro.bluetooth.remote.autoconnect=true

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    lpa.decode=false \
    lpa.use-stagefright=true \
    media.stagefright.enable-player=true \
    media.stagefright.enable-http=true \
    media.stagefright.enable-aac=true \
    media.stagefright.enable-qcp=true \
    media.stagefright.enable-fma2dp=true \
    media.stagefright.enable-scan=true \
    mmp.enable.3g2=true \
    af.resampler.quality=255 \
    ro.opengles.version=131072 \
    mpq.audio.decode=true

#cne
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.UseCne=vendor \
    persist.cne.UseSwim=false \
    persist.cne.bat.range.low.med=30 \
    persist.cne.bat.range.med.high=60 \
    persist.cne.loc.policy.op=/system/etc/OperatorPolicy.xml \
    persist.cne.loc.policy.user=/system/etc/UserPolicy.xml \
    persist.cne.bwbased.rat.sel=false \
    persist.cne.snsr.based.rat.mgt=false \
    persist.cne.bat.based.rat.mgt=false \
    persist.cne.rat.acq.time.out=30000 \
    persist.cne.rat.acq.retry.tout=0 \
    persist.cne.nsrm.mode=false

# Wifi
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=30

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
