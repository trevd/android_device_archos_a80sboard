#
# Copyright 2013 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a9
TARGET_CPU_SMP := true

BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_TI := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/archos/a80sboard/bluetooth

TARGET_BOARD_PLATFORM := omap4
TARGET_BOARD_PLATFORM_VARIANT := archos

TARGET_BOOTLOADER_BOARD_NAME := archosa80sboard
TARGET_BOARD_INFO_FILE := device/archos/a80sboard/board-info.txt
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true


# custom updater functonality for handling the archos device layout
TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_a80sboard

TARGET_RECOVERY_FSTAB = device/archos/a80sboard/fstab.archosa80sboard

# This is the size of /mnt/rawfs/custom which holds the SDE Kernel and Ramdisk
BOARD_BOOTIMAGE_PARTITION_SIZE := 8379728

# Use a custom mkbootimg to create an archos friendly file
BOARD_CUSTOM_MKBOOTIMG := $(HOST_OUT_EXECUTABLES)/mkbootimg-a80sboard$(HOST_EXECUTABLE_SUFFIX)

TARGET_USERIMAGES_USE_EXT4 := true
# System Partition is 800MB ( 838860800 bytes )
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 838860800
BOARD_FLASH_BLOCK_SIZE := 4096


# Cache Partition is 400MB (419430400 bytes)
BOARD_CACHEIMAGE_PARTITION_SIZE := 419430400
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_USES_ALSA_AUDIO := true
BOARD_USE_LEGACY_UI := true

BOARD_EGL_CFG := device/archos/a80sboard/egl.cfg

USE_OPENGL_RENDERER := true

# Connectivity - Wi-Fi
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE := wl12xx_mac80211
BOARD_SOFTAP_DEVICE := wl12xx_mac80211
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_wl12xx
WPA_SUPPLICANT_VERSION := VER_0_8_X


# Use the non-open-source parts, if they're present
-include vendor/archos/a80sboard/BoardConfigVendor.mk

# TWRP Config
DEVICE_RESOLUTION := 1024x768
BOARD_HAS_FLIPPED_SCREEN := true 
TARGET_USERIMAGES_USE_EXT4 := true
TW_BRIGHTNESS_PATH := /sys/devices/platform/omap_pwm_led.0/leds/lcd-backlight/brightness
TW_MAX_BRIGHTNESS := 254

# Limit the language to english
PRODUCT_LOCALES := en_GB en_US

TARGET_RELEASETOOLS_EXTENSIONS := device/archos/a80sboard/