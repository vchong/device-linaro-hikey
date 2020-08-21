# TOP is NOT set here when build_uefi.mk calls in
#TOP_ROOT_ABS := $(realpath $(TOP))

OPTEE_DIR=$(TOP_ROOT_ABS)/optee
LLOADER_DIR=$(TOP_ROOT_ABS)/optee/l-loader
TOOLS_DIR=$(TOP_ROOT_ABS)/optee/tools-images-hikey960

INSTALLER_DIR ?= $(TOP_ROOT_ABS)/device/linaro/hikey/installer/$(TARGET_OUT_DIR)

# CLANG is provided as a RO env var by soong
# Note the trailing forward slash!
#CLANG_PATH=$(TOP_ROOT_ABS)/$(LLVM_PREBUILTS_PATH)/

# Please use DEBUG=1 (default) in build_uefi.sh due to
# https://bugs.96boards.org/show_bug.cgi?id=806

# Do NOT double quote SCRIPT_ARGS, i.e. "CLANG=CLANG_5_0 CLANG_PATH=$(CLANG_PATH)"
# else get build error below
# /bin/sh: line 1: CLANG=CLANG_5_0 CLANG_PATH=/home/victor.chong/work/swg/aosp/master/prebuilts/clang/host/linux-x86/clang-r383902/bin/: No such file or directory
SCRIPT_ARGS ?= CLANG=CLANG_5_0 CLANG_PATH=$(CLANG_PATH)

ifeq ($(TARGET_TEE_IS_OPTEE),false)
	SCRIPT_ARGS+=OPTEE=0
endif

# atf-fastboot (recovery.bin, l-loader.bin) fails to boot to fastboot in DEBUG build!
#INFO:    cpacr_el1:0x300000
#INFO:    Entry point address = 0xf9828000
#INFO:    SPSR = 0x3c5
#ASSERT: File lib/aarch64/misc_helpers.S Line 00115
#SCRIPT_ARGS+=BUILD_OPTION=RELEASE

OPTEE_EXTRA_ARGS ?= CFG_CORE_HEAP_SIZE=196608

# https://docs.google.com/document/d/1YhXpsmefaMhWE4dIwPViG0lzfCKVkf1WqjvknyPh7Pw
# core crash (alignment fault) when looking up early TAs (memcmp on UUIDs)
# https://github.com/OP-TEE/optee_os/issues/3903
OPTEE_EXTRA_ARGS += CFG_SCTLR_ALIGNMENT_CHECK=n

# Force DEBUG=0 for now else boot will hang (https://pastebin.ubuntu.com/p/jX3yfQ2xYV/)
# This is fixed by increasing STACK_TMP_SIZE in optee_os to 4096
# Set it anyway cos saw clang 11 segfault without it
OPTEE_EXTRA_ARGS += DEBUG=0

#FIP_BIN ?= $(OUT_DIR)/dist/fip.bin

#all: $(FIP_BIN)

# build_uefi.sh will always clean before build by default
#$(FIP_BIN):
all:
	echo "TOP = $(TOP)"
	echo "OUT_DIR = $(OUT_DIR)"
	echo "TOP_ROOT_ABS = $(TOP_ROOT_ABS)"
	echo "TARGET_OUT = $(TARGET_OUT)"
	echo "TARGET_OUT_VENDOR = $(TARGET_OUT_VENDOR)"
	echo "TARGET_OUT_DIR = $(TARGET_OUT_DIR)"
	echo "SCRIPT_ARGS = $(SCRIPT_ARGS)"
	cd $(OPTEE_DIR) && \
		$(SCRIPT_ARGS) OPTEE_EXTRA_ARGS="${OPTEE_EXTRA_ARGS}" $(LLOADER_DIR)/build_uefi.sh $(TARGET_OUT_DIR) && \
		cp $(LLOADER_DIR)/fip.bin $(INSTALLER_DIR)/ && \
		cp $(LLOADER_DIR)/l-loader.bin $(INSTALLER_DIR)/ && \
		cp $(LLOADER_DIR)/recovery.bin $(INSTALLER_DIR)/ && \
		cp $(LLOADER_DIR)/ptable-*.img $(INSTALLER_DIR)/
ifneq ($(filter hikey960%, $(TARGET_OUT_DIR)),)
	cp $(TOOLS_DIR)/hikey_idt $(INSTALLER_DIR)/
	cp $(TOOLS_DIR)/hisi*.img $(INSTALLER_DIR)/
endif

clean:
	cd $(OPTEE_DIR) && \
		CLEAN=2 $(LLOADER_DIR)/build_uefi.sh
