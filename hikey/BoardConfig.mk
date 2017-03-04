include device/linaro/hikey/BoardConfigCommon.mk

TARGET_BOARD_PLATFORM := hikey
ifeq ($(TARGET_KERNEL_USE), 4.1)
BOARD_KERNEL_CMDLINE := console=ttyAMA3,115200 androidboot.console=ttyAMA3 androidboot.hardware=hikey firmware_class.path=/system/etc/firmware efi=noruntime androidboot.selinux=permissive
else
BOARD_KERNEL_CMDLINE := console=ttyFIQ0 androidboot.console=ttyFIQ0 androidboot.hardware=hikey firmware_class.path=/system/etc/firmware efi=noruntime printk.devkmsg=on
endif

## printk.devkmsg only has meaning for kernel 4.9 and later
## it would be ignored by kernel 4.1 and kernel 4.4
BOARD_KERNEL_CMDLINE += printk.devkmsg=on

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1610612736
ifeq ($(TARGET_USERDATAIMAGE_4GB), true)
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1595915776
else
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5588893184
endif
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_FLASH_BLOCK_SIZE := 131072

#Force FAT images for now
#Currently, OP-TEE depends on a version of EDK2 that doesn't support
#the abootimg-format boot images.  To make this work, force the build
#to use the old format.  This can be fixed when these patches are
#merged into the EDK2 version used by OP-TEE.
TARGET_BOOTIMAGE_USE_FAT ?= true
TARGET_TEE_IS_OPTEE ?= true
