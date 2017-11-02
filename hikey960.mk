ifneq ($(TARGET_BUILD_KERNEL), true)
ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE=4.9
endif
TARGET_PREBUILT_KERNEL := device/linaro/hikey-kernel/Image.gz-dtb-hikey960-$(TARGET_KERNEL_USE)
TARGET_PREBUILT_DTB := device/linaro/hikey-kernel/hi3660-hikey960.dtb-$(TARGET_KERNEL_USE)

ifeq ($(TARGET_KERNEL_USE), 4.4)
  HIKEY_USE_DRM_HWCOMPOSER := false
  HIKEY_USE_LEGACY_TI_BLUETOOTH := true
else
  ifeq ($(TARGET_KERNEL_USE), 4.9)
    HIKEY_USE_DRM_HWCOMPOSER := false
  else
    HIKEY_USE_DRM_HWCOMPOSER := true
  endif
  HIKEY_USE_LEGACY_TI_BLUETOOTH := false
endif

else # TARGET_BUILD_KERNEL == true for following
TARGET_PREBUILT_KERNEL :=
TARGET_PREBUILT_DTB :=
TARGET_FSTAB := fstab.hikey
endif # end of TARGET_BUILD_KERNEL
#
# Inherit the full_base and device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/linaro/hikey/hikey960/device-hikey960.mk)
$(call inherit-product, device/linaro/hikey/device-common.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

#
# Overrides
PRODUCT_NAME := hikey960
PRODUCT_DEVICE := hikey960
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on hikey960
