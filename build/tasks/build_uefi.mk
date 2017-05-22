ifneq ($(filter hikey960%, $(TARGET_DEVICE)),)

ifeq ($(TARGET_BUILD_UEFI), true)

# setting value for PREBUILT_MAKE to sepecify which vaule to use
PREBUILT_MAKE ?= prebuilts/build-tools/linux-x86/bin/make
ifneq (,$(wildcard $(PREBUILT_MAKE)))
HOST_MAKE := $(PREBUILT_MAKE)
ifneq (,$(filter -j%, $(MAKE)))
HOST_MAKE += $(filter -j%, $(MAKE))
endif
else
HOST_MAKE := $(MAKE)
endif

BOOTLOADER_DIR ?= device/linaro/hikey/bootloader
DIST_DIR_PRODUCT ?= $(OUT_DIR)/dist
ABS_DIST_DIR_PRODUCT ?= $(realpath $(OUT_DIR))/dist
TARGET_TEE_IS_OPTEE ?= false

TOP_ROOT_ABS := $(realpath $(TOP))
CROSS_COMPILE64 := $(TOP_ROOT_ABS)/optee/aarch64/bin/aarch64-linux-gnu-
ifneq ($(strip $($(combo_2nd_arch_prefix)TARGET_TOOLS_PREFIX)),)
CROSS_COMPILE32 := $(TOP_ROOT_ABS)/optee/aarch32/bin/arm-linux-gnueabihf-
endif

HOST_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

$(DIST_DIR_PRODUCT)/fip.bin: $(BOOTLOADER_DIR)/Makefile
	rm -fr $(DIST_DIR_PRODUCT) $(OPTEE_OS_DIR)/out $(PRODUCT_OUT)/obj/optee
	PATH=$(HOST_PATH):$$PATH CROSS_COMPILE_32=$(CROSS_COMPILE32) CROSS_COMPILE_64=$(CROSS_COMPILE64) $(HOST_MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(ABS_DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) -j1 clean
	PATH=$(HOST_PATH):$$PATH CROSS_COMPILE_32=$(CROSS_COMPILE32) CROSS_COMPILE_64=$(CROSS_COMPILE64) $(HOST_MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(ABS_DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) all
	cp $@ device/linaro/hikey/installer/hikey960

$(DIST_DIR_PRODUCT)/l-loader.bin: $(DIST_DIR_PRODUCT)/fip.bin
	cp $@ device/linaro/hikey/installer/hikey960

droidcore: $(DIST_DIR_PRODUCT)/fip.bin $(DIST_DIR_PRODUCT)/l-loader.bin
endif

endif
