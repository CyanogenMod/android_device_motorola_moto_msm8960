ifneq ($(filter msm8960 msm8660 msm7x30,$(TARGET_BOARD_PLATFORM)),)
ifneq ($(TARGET_QCOM_DISPLAY_VARIANT),legacy)
ifeq ($(TARGET_QCOM_MEDIA_VARIANT),moto)

include $(call all-subdir-makefiles)

endif
endif
endif
