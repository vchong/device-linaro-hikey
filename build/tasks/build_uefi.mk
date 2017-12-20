ifneq ($(filter hikey960%, $(TARGET_DEVICE)),)

ifeq ($(TARGET_BUILD_UEFI), true)

BOOTLOADER_DIR ?= $(ANDROID_BUILD_TOP)/device/linaro/hikey/bootloader
DIST_DIR_PRODUCT ?= $(ANDROID_BUILD_TOP)/out/dist
TARGET_TEE_IS_OPTEE ?= true

.phony: printdir
printdir:
	echo "ANDROID_BUILD_TOP = $(ANDROID_BUILD_TOP)"
	echo "BOOTLOADER_DIR = $(BOOTLOADER_DIR)"
	echo "DIST_DIR_PRODUCT = $(DIST_DIR_PRODUCT)"
	echo "OUT_DIR = $(OUT_DIR)"
	echo "HOST_OUT = $(HOST_OUT)"
	echo "PRODUCT_OUT = $(PRODUCT_OUT)"
	echo "TOP = $(TOP)"
	ls -l $(TOP)/

$(DIST_DIR_PRODUCT)/fip.bin: printdir $(BOOTLOADER_DIR)/Makefile
	$(MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) all
	@#cp $@ $(ANDROID_BUILD_TOP)/device/linaro/hikey/installer/hikey960

#$(DIST_DIR_PRODUCT)/l-loader.bin: $(DIST_DIR_PRODUCT)/fip.bin
#	cp $@ $(ANDROID_BUILD_TOP)/device/linaro/hikey/installer/hikey960

#$(DIST_DIR_PRODUCT)/prm_ptable.img:
#	cp $@ $(ANDROID_BUILD_TOP)/device/linaro/hikey/installer/hikey960/

droidcore: $(DIST_DIR_PRODUCT)/fip.bin
#droidcore: $(DIST_DIR_PRODUCT)/fip.bin $(DIST_DIR_PRODUCT)/l-loader.bin $(DIST_DIR_PRODUCT)/prm_ptable.img
endif

endif
