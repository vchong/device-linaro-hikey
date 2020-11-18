ifneq ($(TARGET_BUILD_KERNEL), true)
ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE=4.19
endif

HIKEY_USE_DRM_HWCOMPOSER := false

TARGET_PREBUILT_KERNEL := device/linaro/hikey-kernel/hikey/$(TARGET_KERNEL_USE)/Image.gz-dtb
TARGET_PREBUILT_DTB := device/linaro/hikey-kernel/hikey/$(TARGET_KERNEL_USE)/hi6220-hikey.dtb

PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

ifeq ($(TARGET_KERNEL_USE), 4.4)
  HIKEY_USE_LEGACY_TI_BLUETOOTH := true
else
  HIKEY_USE_LEGACY_TI_BLUETOOTH := false
  HIKEY_USE_DRM_HWCOMPOSER := true
endif
TARGET_FSTAB := fstab.hikey

else # TARGET_BUILD_KERNEL == true for following
TARGET_PREBUILT_KERNEL :=
TARGET_PREBUILT_DTB :=
TARGET_FSTAB := fstab.hikey
endif # end of TARGET_BUILD_KERNEL


$(call inherit-product, device/linaro/hikey/hikey/device-hikey.mk)
$(call inherit-product, device/linaro/hikey/device-common.mk)
