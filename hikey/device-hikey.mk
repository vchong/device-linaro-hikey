#
# Copyright (C) 2011 The Android Open-Source Project
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

#Point default kernel to compiled one
#By default, use the kernel built by the script in the
#optee_android_tools project.
ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/linaro/hikey-kernel/Image-dtb
LOCAL_DTB := device/linaro/hikey-kernel/hi6220-hikey.dtb
LOCAL_FSTAB := fstab.hikey
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
LOCAL_DTB := $(TARGET_PREBUILT_DTB)
LOCAL_FSTAB := $(TARGET_FSTAB)
endif

PRODUCT_COPY_FILES +=   $(LOCAL_KERNEL):kernel \
                        $(LOCAL_DTB):hi6220-hikey.dtb \
			$(LOCAL_PATH)/$(LOCAL_FSTAB):root/fstab.hikey \
			device/linaro/hikey/init.common.rc:root/init.hikey.rc \
			device/linaro/hikey/init.common.usb.rc:root/init.hikey.usb.rc \
			device/linaro/hikey/ueventd.common.rc:root/ueventd.hikey.rc \
			device/linaro/hikey/common.kl:system/usr/keylayout/hikey.kl

# Build HiKey HDMI audio HAL
PRODUCT_PACKAGES += audio.primary.hikey

# Include USB speed switch App
PRODUCT_PACKAGES += UsbSpeedSwitch

# Build libion
PRODUCT_PACKAGES += libion

# Build gralloc for hikey
PRODUCT_PACKAGES += gralloc.hikey

# update to use aosp_optee.mk in optee_os
OPTEE_PLATFORM ?= hikey
OPTEE_CFG_ARM64_CORE ?= y
OPTEE_TA_TARGETS ?= ta_arm64
OPTEE_OS_DIR ?= device/linaro/bootloader/optee_os
BUILD_OPTEE_MK := $(OPTEE_OS_DIR)/mk/aosp_optee.mk

PRODUCT_PACKAGES += libteec \
					tee-supplicant \
					tee_helloworld \
					xtest

# OP TEE Hello world TA
PRODUCT_PACKAGES += 8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta
PRODUCT_PACKAGES += e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta
PRODUCT_PACKAGES += 5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta
PRODUCT_PACKAGES += c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta
PRODUCT_PACKAGES += cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta
PRODUCT_PACKAGES += 5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta
PRODUCT_PACKAGES += d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta
PRODUCT_PACKAGES += e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta
PRODUCT_PACKAGES += b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta
PRODUCT_PACKAGES += f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta
PRODUCT_PACKAGES += 614789f2-39c0-4ebf-b235-92b32ac107ed.ta
PRODUCT_PACKAGES += e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta
PRODUCT_PACKAGES += 731e279e-aafb-4575-a771-38caa6f0cca6.ta

# PowerHAL
PRODUCT_PACKAGES += power.hikey

# Include vendor binaries
$(call inherit-product-if-exists, vendor/linaro/hikey/device-vendor.mk)

# Set so that OP-TEE clients can find the installed dev-kit, which
# depends on platform and word-size.
TA_DEV_KIT_DIR := $(OPTEE_OS_DIR)/out/arm-plat-hikey/export-ta_arm64
