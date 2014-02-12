#
# USE THIS FILE FOR PRODUCT SPECIFIC BOARD AND TARGET SETTINGS
# 
# This can be used for adding Build Variables which are specific to a
# custom "distro's" build system 
# 


####### CYANOGENMOD SPECIFIC BUILD VARIABLES #########
ifeq ($(TARGET_PRODUCT),cm_a80sboard)

# Bootanimation
TARGET_BOOTANIMATION_USE_RGB565 := true
TARGET_BOOTANIMATION_PRELOAD := true

# Disable texture-cache in boot-animation to fix OOM with new animation
TARGET_BOOTANIMATION_TEXTURE_CACHE := false
COMMON_GLOBAL_CFLAGS += -DFORCE_SCREENSHOT_CPU_PATH

# Enable dalvik startup with a low memory footprint
TARGET_ARCH_LOWMEM := true

# Needed for blobs
COMMON_GLOBAL_CFLAGS += -DNEEDS_VECTORIMPL_SYMBOLS

BOARD_HAVE_OLD_ION_API := true

BOARD_CUSTOM_BOOTIMG_MK := device/archos/a80sboard/mkbootimg/cm.mk

endif

####### OMNI SPECIFIC BUILD VARIABLES #########
ifeq ($(TARGET_PRODUCT),omni_a80sboard)

# Bootanimation
#TARGET_BOOTANIMATION_USE_RGB565 := true
#TARGET_BOOTANIMATION_PRELOAD := true

# Disable texture-cache in boot-animation to fix OOM with new animation
#TARGET_BOOTANIMATION_TEXTURE_CACHE := false
#COMMON_GLOBAL_CFLAGS += -DFORCE_SCREENSHOT_CPU_PATH

# Enable dalvik startup with a low memory footprint
#TARGET_ARCH_LOWMEM := true

# Needed for blobs
#COMMON_GLOBAL_CFLAGS += -DNEEDS_VECTORIMPL_SYMBOLS

#BOARD_HAVE_OLD_ION_API := true

BOARD_CUSTOM_BOOTIMG_MK := device/archos/a80sboard/mkbootimg/cm.mk

endif
