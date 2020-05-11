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

TOP_ROOT_ABS := $(realpath $(TOP))

LLOADER_DIR=$(TOP_ROOT_ABS)/optee/l-loader

BOOTLOADER_DIR ?= device/linaro/hikey/bootloader

# CLANG is provided as a RO env var by soong
# Note the trailing forward slash!
CLANG_PATH=$(TOP_ROOT_ABS)/$(LLVM_PREBUILTS_PATH)/

# 8.0.9 - android10-dev branch does NOT build!
#CLANG_PATH=$(TOP_ROOT_ABS)/prebuilts/clang/host/linux-x86/clang-r349610b/bin/
# 9.0.1 - android-q-preview-1 branch
#CLANG_PATH=$(TOP_ROOT_ABS)/prebuilts/clang/host/linux-x86/clang-r353983/bin/
# 9.0.2 - android10-dev branch
#CLANG_PATH=$(TOP_ROOT_ABS)/prebuilts/clang/host/linux-x86/clang-r353983b/bin/
# 9.0.3
#CLANG_PATH=$(TOP_ROOT_ABS)/prebuilts/clang/host/linux-x86/clang-r353983c/bin/
# 9.0.8
#CLANG_PATH=$(TOP_ROOT_ABS)/prebuilts/clang/host/linux-x86/clang-r365631c/bin/
# 11.0.1
#CLANG_PATH=$(TOP_ROOT_ABS)/prebuilts/clang/host/linux-x86/clang-r383902/bin/

# Please use DEBUG=1 (default) in build_uefi.sh due to
# https://bugs.96boards.org/show_bug.cgi?id=806

# https://sx.ix5.org/info/post/android-q-compiling-kernels-in-tree
# make target MUST beging with `out/..` and NOT abs path!
FIP_BIN ?= $(OUT_DIR)/dist/fip.bin

HOST_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Do NOT prepend $(TOP_ROOT_ABS) here! Else get error
# make: *** /home/first.last/aosp//home/first.last/aosp/optee/optee_os: No such file or directory.  Stop.
# from optee_os/mk/aosp_optee.mk when building.
OPTEE_OS_DIR=optee/optee_os

# for debugging, add as dep to target, i.e. $(FIP_BIN): out/dist/foo
out/dist/foo:
	find -L $(OPTEE_OS_DIR) | grep -v -e out -e .git
	@#mkdir -p $(OUT_DIR)/dist
	@#touch $(OUT_DIR)/dist/foo

# build_uefi.sh will always clean before build by default

# SHOULD REBUILD WHENEVER ANY fip.bin RELATED SRCS ARE CHANGED, I.E ALSO TF-A, edk2, OpenPlatformPkg, atf-fastboot (620 only)
# rebuild fip.bin whenever optee/optee_os or optee/l-loader is modified
#$(FIP_BIN): $(sort $(shell find -L $(OPTEE_OS_DIR) | grep -v -e out -e .git)) $(sort $(shell find -L $(LLOADER_DIR) | grep -v -e .git))

# force build every time since optee_os/out is always built after the fact?
# not sure if this works, but does NOT work if optee_os remains unchanged for several builds
#$(FIP_BIN): $(sort $(shell find -L $(OPTEE_OS_DIR)))

# rebuild fip.bin whenever optee/optee_os is modified
$(FIP_BIN): out/dist/foo $(sort $(shell find -L $(OPTEE_OS_DIR) | grep -v -e out -e .git))
	echo "## TOP = $(TOP)"
	echo "## TOP_ROOT_ABS = $(TOP_ROOT_ABS)"
	echo "## TARGET_OUT_DIR = $(TARGET_OUT_DIR)"
	echo "## TARGET_OUT = $(TARGET_OUT)"
	echo "## TARGET_OUT_VENDOR = $(TARGET_OUT_VENDOR)"
	mkdir -p $(OUT_DIR)/dist
	@# Should we really rm $(PRODUCT_OUT)/optee built by optee_os/aosp_optee.mk and NOT by this file?
	@#rm -rf $(PRODUCT_OUT)/optee
	@# Does NOT build without '-j1'! build_uefi.sh will build edk2 in parallel though!
	PATH=$(HOST_PATH):$$PATH $(HOST_MAKE) -j1 -C $(BOOTLOADER_DIR) TOP_ROOT_ABS=$(TOP_ROOT_ABS) TARGET_OUT_DIR=$(TARGET_OUT_DIR) CLANG_PATH=$(CLANG_PATH)
	cp $(LLOADER_DIR)/fip.bin $@

droidcore: $(FIP_BIN)
endif #TARGET_BUILD_UEFI

endif #
