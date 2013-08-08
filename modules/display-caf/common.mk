QCOM_PATH:= $(TOP)/device/motorola/msm8960-common/modules

#Common headers
common_includes := $(QCOM_PATH)/display-caf/libgralloc
common_includes += $(QCOM_PATH)/display-caf/libgenlock
common_includes += $(QCOM_PATH)/display-caf/liboverlay
common_includes += $(QCOM_PATH)/display-caf/libcopybit
common_includes += $(QCOM_PATH)/display-caf/libqdutils
common_includes += $(QCOM_PATH)/display-caf/libhwcomposer
common_includes += $(QCOM_PATH)/display-caf/libexternal
common_includes += $(QCOM_PATH)/display-caf/libqservice

common_header_export_path := qcom/display

#Common libraries external to display-caf HAL
common_libs := liblog libutils libcutils libhardware

#Common C flags
common_flags := -DDEBUG_CALC_FPS -Wno-missing-field-initializers
# TEMP HACK: removing -Werror here as it floats into other code (namely audio-caf/libalsa-intf) and breaks the build
#common_flags += -Werror

ifeq ($(ARCH_ARM_HAVE_NEON),true)
    common_flags += -D__ARM_HAVE_NEON
endif

ifneq ($(filter msm8974 msm8x74 msm8226 msm8x26,$(TARGET_BOARD_PLATFORM)),)
    # TODO: This define makes us pick a few inline functions
    # from the kernel header media/msm_media_info.h. However,
    # the bionic clean_headers utility scrubs them out.
    # Figure out a way to import those macros correctly
    # common_flags += -DVENUS_COLOR_FORMAT
    common_flags += -DMDSS_TARGET
endif

# Executed only on QCOM BSPs
ifeq ($(TARGET_USES_QCOM_BSP),true)
# This flag is used to compile out any features that depend on framework changes
    common_flags += -DQCOM_BSP
endif

ifeq ($(call is-vendor-board-platform,QCOM),true)
common_deps += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
kernel_includes += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
endif

ifeq ($(TARGET_DISPLAY_USE_RETIRE_FENCE),true)
    common_flags += -DUSE_RETIRE_FENCE
endif
