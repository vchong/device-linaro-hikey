ifneq ($(filter hikey%, $(TARGET_DEVICE)),)

ifeq ($(TARGET_BUILD_UEFI), true)

BOOTLOADER_DIR ?= device/linaro/hikey/bootloader
DIST_DIR_PRODUCT ?= out/dist
TARGET_TEE_IS_OPTEE ?= false

TOP_ROOT_ABS := $(realpath $(TOP))
CROSS_COMPILE64 := $(TOP_ROOT_ABS)/$(TARGET_TOOLS_PREFIX)
ifneq ($(strip $($(combo_2nd_arch_prefix)TARGET_TOOLS_PREFIX)),)
CROSS_COMPILE32 := $(TOP_ROOT_ABS)/$($(combo_2nd_arch_prefix)TARGET_TOOLS_PREFIX)
endif

HOST_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# does NOT work - donno y
# cos OPTEE_OS_BIN is NOT a real make tgt unlike OPTEE_BIN in
# optee_os/mk/aosp_optee.mk?
#OPTEE_OS_DIR=$(TOP_ROOT_ABS)/optee/optee_os
#OPTEE_OS_BIN := $(OPTEE_OS_DIR)/out/arm-plat-hikey/core/tee.bin
#$(OPTEE_OS_BIN) : $(sort $(shell find -L $(OPTEE_OS_DIR)))
#$(DIST_DIR_PRODUCT)/fip.bin: $(BOOTLOADER_DIR)/Makefile $(OPTEE_OS_BIN)

# this seems to work
# BUT unlike bootloader/Makefile, do NOT append $(TOP_ROOT_ABS)
# else get
# make: *** /home/victor.chong/work/swg/aosp/wv//home/victor.chong/work/swg/aosp/wv/optee/optee_os: No such file or directory.  Stop.
# from optee_os/mk/aosp_optee.mk when making all
OPTEE_OS_DIR=optee/optee_os

$(DIST_DIR_PRODUCT)/fip.bin: $(BOOTLOADER_DIR)/Makefile $(sort $(shell find -L $(OPTEE_OS_DIR)))
	rm -fr $(DIST_DIR_PRODUCT) $(OPTEE_OS_DIR)/out $(PRODUCT_OUT)/obj/optee
	PATH=$(HOST_PATH):$$PATH CROSS_COMPILE_32=$(CROSS_COMPILE32) CROSS_COMPILE_64=$(CROSS_COMPILE64) $(MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(CURDIR)/$(DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) -j1 clean
	PATH=$(HOST_PATH):$$PATH CROSS_COMPILE_32=$(CROSS_COMPILE32) CROSS_COMPILE_64=$(CROSS_COMPILE64) $(MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(CURDIR)/$(DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) all
	cp $@ device/linaro/hikey/installer/hikey

$(DIST_DIR_PRODUCT)/l-loader.bin: $(DIST_DIR_PRODUCT)/fip.bin
	cp $@ device/linaro/hikey/installer/hikey

droidcore: $(DIST_DIR_PRODUCT)/fip.bin $(DIST_DIR_PRODUCT)/l-loader.bin
endif

endif
