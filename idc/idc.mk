ifeq ($(TARGET_USES_MOTOROLA_MSM8960_COMMON_IDC),true)
LOCAL_PATH := device/motorola/msm8960-common
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/idc/melfas-ts.idc:system/usr/idc/melfas-ts.idc \
    $(LOCAL_PATH)/idc/evfwd.idc:system/usr/idc/evfwd.idc
endif
