LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := eng
LOCAL_C_INCLUDES += bootable/recovery \
					bootable/recovery/mtdutils \
                    external/libparted/include

LOCAL_SRC_FILES := recovery_updater.c
LOCAL_STATIC_LIBRARIES := libparted_static

# should match TARGET_RECOVERY_UPDATER_LIBS set in BoardConfig.mk
LOCAL_MODULE := librecovery_updater_a80sboard

include $(BUILD_STATIC_LIBRARY)
