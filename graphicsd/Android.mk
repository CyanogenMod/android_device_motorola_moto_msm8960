#===================================================================================================
# graphicsd - Graphics Daemon
#===================================================================================================
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES:= graphicsd.c
LOCAL_MODULE:= graphicsd
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)
