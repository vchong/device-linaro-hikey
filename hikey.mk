ifneq ($(TARGET_BUILD_KERNEL), true)
# TARGET_PREBUILT_KERNEL defined here!
ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE=4.9
endif
TARGET_PREBUILT_KERNEL := device/linaro/hikey-kernel/Image-dtb-$(TARGET_KERNEL_USE)
TARGET_PREBUILT_DTB := device/linaro/hikey-kernel/hi6220-hikey.dtb-$(TARGET_KERNEL_USE)
ifeq ($(TARGET_KERNEL_USE), 4.1)
TARGET_FSTAB := fstab.hikey-$(TARGET_KERNEL_USE)
else
TARGET_FSTAB := fstab.hikey
endif
else
TARGET_PREBUILT_KERNEL :=
TARGET_PREBUILT_DTB :=
TARGET_FSTAB := fstab.hikey
endif

ifeq ($(TARGET_BUILD_FOR_TV), true)
PRODUCT_CHARACTERISTICS := tv
$(call inherit-product, device/google/atv/products/atv_base.mk)
endif

#
# Inherit the full_base and device configurations
$(call inherit-product, device/linaro/hikey/hikey/device-hikey.mk)
$(call inherit-product, device/linaro/hikey/device-common.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

#
# Overrides
PRODUCT_NAME := hikey
PRODUCT_DEVICE := hikey
PRODUCT_BRAND := Android
