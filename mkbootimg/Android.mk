ifeq ($(TARGET_DEVICE),a80sboard)
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := mkbootimg.c

LOCAL_MODULE := mkbootimg-a80sboard

LOCAL_CFLAGS := -Wno-maybe-uninitialized

include $(BUILD_HOST_EXECUTABLE)

$(call dist-for-goals,dist_files,$(LOCAL_BUILT_MODULE))
endif
