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

TARGET_PREBUILT_KERNEL := device/archos/a80sboard/kernel

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/archos/a80sboard/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

# Kernel
PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel

PRODUCT_COPY_FILES += \
    device/archos/a80sboard/init.storage.rc:root/init.storage.rc \
    device/archos/a80sboard/init.superuser.rc:root/init.superuser.rc \
    device/archos/a80sboard/init.archosa80sboard.usb.rc:root/init.archosa80sboard.usb.rc \
    device/archos/a80sboard/init.archosa80sboard.rc:root/init.archosa80sboard.rc \
    device/archos/a80sboard/init.recovery.archosa80sboard.rc:root/init.recovery.archosa80sboard.rc \
    device/archos/a80sboard/fstab.archosa80sboard:root/fstab.archosa80sboard \
    device/archos/a80sboard/ueventd.archosa80sboard.rc:root/ueventd.archosa80sboard.rc \


# Prebuilt input device calibration files
PRODUCT_COPY_FILES += \
	device/archos/a80sboard/cpt_i2c_tsp.idc:system/usr/idc/cpt_i2c_tsp.idc \
	device/archos/a80sboard/cypress-tma340.idc:system/usr/idc/cypress-tma340.idc

PRODUCT_COPY_FILES += \
	device/archos/a80sboard/twl6030_pwrbutton.kcm:system/usr/keychars/twl6030_pwrbutton.kcm \
	device/archos/a80sboard/gpio-keys.kcm:system/usr/keychars/gpio-keys.kcm \
	device/archos/a80sboard/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
	device/archos/a80sboard/twl6030_pwrbutton.kl:system/usr/keylayout/twl6030_pwrbutton.kl

PRODUCT_COPY_FILES += \
	device/archos/a80sboard/ducati-m3.bin:system/etc/firmware/ducati-m3.bin
 
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
	frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
	frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth.xml \

# Camera Permissions
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml
	

PRODUCT_COPY_FILES += \
	device/archos/a80sboard/audio_policy.conf:system/etc/audio_policy.conf \
	device/archos/a80sboard/mixer_paths.xml:system/etc/mixer_paths.xml

    
PRODUCT_COPY_FILES += \
	device/archos/a80sboard/media_codecs.xml:system/etc/media_codecs.xml \
	device/archos/a80sboard/media_profiles.xml:system/etc/media_profiles.xml

# GPS configuration
PRODUCT_COPY_FILES += \
    device/archos/a80sboard/gps.conf:system/etc/gps.conf

    
# Set product characteristic to tablet, needed for some ui elements
PRODUCT_CHARACTERISTICS := tablet
    
# The SGS series is hdpi however with new development going toward xhdpi we need to inherit xhdpi or we will lose those pngs
PRODUCT_AAPT_CONFIG := large mdpi hdpi xhdpi nodpi tvdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi

# use phone-hdpi-512-dalvik-heap.mk as the device only has
# 512MB of RAM
include frameworks/native/build/phone-hdpi-512-dalvik-heap.mk

DEVICE_PACKAGE_OVERLAYS := \
    device/archos/a80sboard/overlay

PRODUCT_PACKAGES += \
	libtiaudioutils \
	libbaudioroute \
	libaudio-resampler \
	audio_policy.omap4 \
	audio.primary.omap4 \
	audio.hdmi.omap4 \
	audio.a2dp.default \
	audio.usb.default \
	audio.r_submix.default \

PRODUCT_PACKAGES += \
	mkbootimg-a80sboard

# WI-Fi
PRODUCT_PACKAGES += \
	dhcpcd.conf \
	hostapd.conf \
	lib_driver_cmd_wl12xx \
	wpa_supplicant.conf \
	wpa_supplicant \
	hostapd
	
	
# Device specific hal implementation
PRODUCT_PACKAGES += \
	lights.omap4 \
	power.omap4
	
# Cyanogenmod Imports 
PRODUCT_PACKAGES += \
	CMFileManager \
	Superuser \
	su \

# Linaro Imports
PRODUCT_PACKAGES += \
	PCKeyboard \
	ZeroXBenchmark \
	AndroidTerm

$(call inherit-product, device/archos/a80sboard/properties.mk)
$(call inherit-product, device/archos/a80sboard/tests.mk)
$(call inherit-product-if-exists, vendor/archos/a80sboard/device-vendor.mk)

$(call inherit-product-if-exists, hardware/ti/omap4xxx-archos/omap4.mk)
$(call inherit-product-if-exists, hardware/ti/wpan/ti-wpan-products.mk)

# Limit the language to english
PRODUCT_LOCALES := en_GB en_US 