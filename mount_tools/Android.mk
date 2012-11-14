LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= recover_userdata.c
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE:= recover_userdata
LOCAL_C_INCLUDES := system/vold system/extras/ext4_utils
ifneq ($(BOARD_USERIMAGE_BLOCK_SIZE),)
  LOCAL_CFLAGS += -DBOARD_USERIMAGE_BLOCK_SIZE=$(BOARD_USERIMAGE_BLOCK_SIZE)
endif
LOCAL_SHARED_LIBRARIES := liblog libcutils libext4_utils
include $(BUILD_EXECUTABLE)
