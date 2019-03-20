include device/linaro/hikey/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := hikey
TARGET_BOARD_PLATFORM := hikey

TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT := cortex-a53

BOARD_KERNEL_CMDLINE := console=ttyAMA3,115200 androidboot.console=ttyAMA3 androidboot.hardware=hikey firmware_class.path=/vendor/firmware efi=noruntime

# if we dont do this, then need to duplicate ALL permissions allowed
# for userdata_block_device to cache_block_device
# http://androidxref.com/9.0.0_r3/search?q=cache_block_device&defs=&refs=&path=&hist=&project=art&project=bionic&project=bootable&project=build&project=compatibility&project=cts&project=dalvik&project=developers&project=development&project=device&project=external&project=frameworks&project=hardware&project=kernel&project=libcore&project=libnativehelper&project=packages&project=pdk&project=platform_testing&project=prebuilts&project=sdk&project=system&project=test&project=toolchain&project=tools
# http://aosp.opersys.com/xref/android-9.0.0_r30/search?q=userdata_block_device&defs=&refs=&path=&hist=&type=&project=art&project=bionic&project=bootable&project=build&project=compatibility&project=cts&project=dalvik&project=developers&project=development&project=device&project=external&project=frameworks&project=hardware&project=kernel&project=libcore&project=libnativehelper&project=packages&project=pdk&project=platform_testing&project=sdk&project=system&project=test&project=toolchain&project=tools
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

ifneq ($(TARGET_ANDROID_VERITY),)
# Enable dtb fstab for treble, with verity and system-as-root
# NOTE: Disabled by default until b/111829702 is fixed
BOARD_KERNEL_CMDLINE += overlay_mgr.overlay_dt_entry=hardware_cfg_enable_android_fstab_v2
BOARD_KERNEL_CMDLINE += rootwait ro init=/init root=/dev/dm-0
BOARD_KERNEL_CMDLINE += dm=\"system none ro,0 1 android-verity 179:9\"
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
else
# Enable dtb fstab for treble
BOARD_KERNEL_CMDLINE += overlay_mgr.overlay_dt_entry=hardware_cfg_enable_android_fstab
endif

ifneq ($(TARGET_SENSOR_MEZZANINE),)
BOARD_KERNEL_CMDLINE += overlay_mgr.overlay_dt_entry=hardware_cfg_$(TARGET_SENSOR_MEZZANINE)
endif

## printk.devkmsg only has meaning for kernel 4.9 and later
## it would be ignored by kernel 3.18 and kernel 4.4
BOARD_KERNEL_CMDLINE += printk.devkmsg=on

TARGET_NO_DTIMAGE := true

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1610612736
ifeq ($(TARGET_USERDATAIMAGE_4GB), true) # to build for aosp-4g partition table
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1595915776
else
ifeq ($(TARGET_WITH_SWAP), true) # to build for swap-8g partition table
BOARD_USERDATAIMAGE_PARTITION_SIZE := 4246715904
else
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5588893184
endif
endif
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_FLASH_BLOCK_SIZE := 131072

# Vendor partition definitions
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_PARTITION_SIZE := 268435456 # 256MB
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_JOURNAL_SIZE := 0
BOARD_VENDORIMAGE_EXTFS_INODE_COUNT := 2048
