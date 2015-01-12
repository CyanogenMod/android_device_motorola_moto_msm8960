# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Enhanced NFC
$(call inherit-product, vendor/cm/config/nfc_enhanced.mk)

DEVICE_PACKAGE_OVERLAYS += device/motorola/qcom-common/overlay-cm

# Boot animation
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1280

# Include 960x540 boot animation in the zip
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bootanimation/540.zip:system/media/540.zip

# Media
PRODUCT_COPY_FILES += \
    device/motorola/moto_msm8960/config/media_codecs.xml:system/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_ffmpeg.xml:system/etc/media_codecs_ffmpeg.xml

# Release name
PRODUCT_NAME := cm_moto_msm8960

PRODUCT_PROPERTY_OVERRIDES += ro.build.product=moto_msm8960

$(call inherit-product, device/motorola/moto_msm8960/full_moto_msm8960.mk)
