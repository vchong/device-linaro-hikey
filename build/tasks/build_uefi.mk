ifneq ($(filter hikey%, $(TARGET_DEVICE)),)

ifeq ($(TARGET_BUILD_UEFI), true)

# setting value for PREBUILT_MAKE to specify which value to use
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

# CLANG is provided as a RO env var by soong
# and CANNOT be overwritten
TOP_ROOT_ABS := $(realpath $(TOP))

# WARNING: MUST HAVE / AT THE END!
CLANG_PATH := $(TOP_ROOT_ABS)/$(LLVM_PREBUILTS_PATH)/

#CROSS_COMPILERS := COMPILER=clang
CROSS_COMPILERS += CROSS_COMPILE64=aarch64-linux-android-
CROSS_COMPILERS += CROSS_COMPILE32=arm-linux-androideabi-

HOST_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Do NOT prepend $(TOP_ROOT_ABS) here! Else get error
# make: *** /home/first.last/aosp//home/first.last/aosp/optee/optee_os: No such file or directory.  Stop.
# from optee_os/mk/aosp_optee.mk when building.
OPTEE_OS_DIR=optee/optee_os

# rebuild fip.bin whenever optee_os is modified
$(DIST_DIR_PRODUCT)/fip.bin: $(BOOTLOADER_DIR)/Makefile $(sort $(shell find -L $(OPTEE_OS_DIR)))
	rm -fr $(DIST_DIR_PRODUCT) $(OPTEE_OS_DIR)/out $(PRODUCT_OUT)/obj/optee
	PATH=$(HOST_PATH):$$PATH $(CROSS_COMPILERS) $(HOST_MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(ABS_DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) -j1 clean
	PATH=$(HOST_PATH):$$PATH $(CROSS_COMPILERS) $(HOST_MAKE) -C $(BOOTLOADER_DIR) DIST_DIR=$(ABS_DIST_DIR_PRODUCT) TARGET_TEE_IS_OPTEE=$(TARGET_TEE_IS_OPTEE) all
	cp $@ device/linaro/hikey/installer/$(TARGET_DEVICE)/

$(DIST_DIR_PRODUCT)/l-loader.bin: $(DIST_DIR_PRODUCT)/fip.bin
	cp $@ device/linaro/hikey/installer/$(TARGET_DEVICE)/

$(DIST_DIR_PRODUCT)/prm_ptable.img: $(DIST_DIR_PRODUCT)/l-loader.bin
	cp $@ device/linaro/hikey/installer/$(TARGET_DEVICE)/

droidcore: $(DIST_DIR_PRODUCT)/fip.bin $(DIST_DIR_PRODUCT)/l-loader.bin $(DIST_DIR_PRODUCT)/prm_ptable.img
endif

endif
