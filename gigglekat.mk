# Inherit some common Giggly stuff.
$(call inherit-product, vendor/gigglekat/config/common.mk)

# Enhanced NFC
$(call inherit-product, vendor/gigglekat/config/nfc_enhanced.mk)

# Boot animation
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1280

# Release name
PRODUCT_NAME := gigglekat_moto_msm8960

$(call inherit-product, device/motorola/moto_msm8960/full_moto_msm8960.mk)
