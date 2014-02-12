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

# Properties - 
# PRODUCT_PROPERTY_OVERRIDES will be added to /system/build.prop
# ADDITIONAL_DEFAULT_PROPERTIES will be added to /default.pop


# Audio Configuration
#PRODUCT_PROPERTY_OVERRIDES += \
#	persist.audio.handset.mic=dmic \
#	persist.audio.fluence.mode=endfire \
#	persist.audio.lowlatency.rec=false \
#	af.resampler.quality=4

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Dalvik Heap Sizes
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=5m \
    dalvik.vm.heapgrowthlimit=48m \
    dalvik.vm.heapsize=256m

# Dalvik vm
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.execution-mode=int:fast \
    ro.kernel.android.checkjni=false \
    dalvik.vm.checkjni=false \

# wifi settings
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=150
    
# Tablet Mode
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=160

# LowRam Settings for 512MB
PRODUCT_PROPERTY_OVERRIDES += \
	ro.config.low_ram=true \
	
	
# OpenGLES 3.0 Magic Number
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196608 \
    browser.tioptimization=true \
    com.ti.omap_enhancement=true \
    com.ti.omap_enhancement_s3d=true \
    com.ti.blueti_enhancement=true \
    com.ti.ant_ble_wbs_switch=true \
    com.ti.wbs_enabled=false \
    tv.hdmi.uicloning.enable=true \
    ro.bq.gpu_to_cpu_unsupported=1 \
    ro.board.has_gps=yes \
    
PRODUCT_PROPERTY_OVERRIDES += \
    telephony.lteOnCdmaDevice=0

PRODUCT_PROPERTY_OVERRIDES += \
	hwui.render_dirty_regions=false

# relax the security 
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    ro.secure=0 \
    service.adb.root=1 \
    persist.sys.root_access=3 \
	
