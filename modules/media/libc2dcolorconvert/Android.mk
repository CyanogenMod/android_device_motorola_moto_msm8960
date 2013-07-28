LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ifeq ($(TARGET_QCOM_DISPLAY_VARIANT),moto)
DISPLAY := display-caf
else
DISPLAY := display
endif

LOCAL_SRC_FILES := \
        C2DColorConverter.cpp

LOCAL_C_INCLUDES := \
    $(TOP)/frameworks/av/include/media/stagefright \
    $(TOP)/frameworks/native/include/media/openmax \
    $(TOP)/device/motorola/msm8960-common/modules/$(DISPLAY)/libcopybit

LOCAL_COPY_HEADERS_TO   := linux

LOCAL_COPY_HEADERS      := ../../../../../../kernel/motorola/msm8960-common/include/linux/msm_kgsl.h

LOCAL_SHARED_LIBRARIES := liblog libdl

LOCAL_MODULE_TAGS := optional

LOCAL_MODULE := libc2dcolorconvert

include $(BUILD_SHARED_LIBRARY)
