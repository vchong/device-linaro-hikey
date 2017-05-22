ifneq ($(filter hikey%, $(TARGET_DEVICE)),)

ifeq ($(TARGET_BUILD_UEFI), true)

BOOTLOADER_DIR ?= $(ANDROID_BUILD_TOP)/device/linaro/hikey/bootloader
DIST_DIR_PRODUCT ?= $(ANDROID_BUILD_TOP)/out/dist
TARGET_TEE_IS_OPTEE ?= false

$(DIST_DIR_PRODUCT)/fip.bin: $(BOOTLOADER_DIR)/Makefile
	$(MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) all
	cp $@ $(ANDROID_BUILD_TOP)/device/linaro/hikey/installer/hikey

$(DIST_DIR_PRODUCT)/l-loader.bin: $(DIST_DIR_PRODUCT)/fip.bin
	cp $@ $(ANDROID_BUILD_TOP)/device/linaro/hikey/installer/hikey

droidcore: $(DIST_DIR_PRODUCT)/fip.bin $(DIST_DIR_PRODUCT)/l-loader.bin
endif

endif
