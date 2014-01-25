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
# Get the long list of APNs
PRODUCT_COPY_FILES := device/sample/etc/apns-full-conf.xml:system/etc/apns-conf.xml

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

PRODUCT_NAME := full_a80sboard
PRODUCT_DEVICE := a80sboard
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on a80sboard
PRODUCT_MANUFACTURER := Archos

$(call inherit-product, device/archos/a80sboard/device.mk)
$(call inherit-product-if-exists, vendor/archos/a80sboard/device-vendor.mk)


# Get a list of languages.
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_small.mk)

# The PRODUCT_PACKAGES_FILTER is implemented by 
# vendor/archos/build/tasks/filter-packages.mk
# Add the packages you want to remove from the build list
PRODUCT_PACKAGES_FILTER := \
        LatinIME \
        OpenWnn \
        PinyinIME \
        libWnnEngDic \
        libWnnJpnDic \
        libwnndict
