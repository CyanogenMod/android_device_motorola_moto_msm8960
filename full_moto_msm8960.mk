#
# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This file is the build configuration for a full Android
# build for moto_msm8960 hardware. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps). Except for a few implementation
# details, it only fundamentally contains two inherit-product
# lines, full and moto_msm8960, hence its name.
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
# Inherit from moto_msm8960 device
$(call inherit-product, device/motorola_moto/msm8960/device_moto_msm8960.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := moto_msm8960
PRODUCT_NAME := full_moto_msm8960
PRODUCT_BRAND := motorola
PRODUCT_MODEL := MOTOROLA MSM8960
PRODUCT_MANUFACTURER := motorola
