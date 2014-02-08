ifeq ($(TARGET_DEVICE),a80sboard)
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := mkbootimg.c

LOCAL_MODULE := mkbootimg-a80sboard

LOCAL_CFLAGS := -Wno-maybe-uninitialized

# Use a custom mkbootimg to create an archos friendly file
$(info "BOARD_CUSTOM_MKBOOTIMG $(BOARD_CUSTOM_MKBOOTIMG)")
BOARD_CUSTOM_MKBOOTIMG := $(HOST_OUT_EXECUTABLES)/mkbootimg-a80sboard$(HOST_EXECUTABLE_SUFFIX)

ifeq ($(TARGET_PRODUCT),cm_a80sboard)
BOARD_CUSTOM_BOOTIMG_MK := $(LOCAL_PATH)/cm.mk 
endif

include $(BUILD_HOST_EXECUTABLE)

$(call dist-for-goals,dist_files,$(LOCAL_BUILT_MODULE))
endif
