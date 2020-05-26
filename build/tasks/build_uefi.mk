ifneq ($(filter hikey%, $(TARGET_DEVICE)),)

ifeq ($(TARGET_BUILD_UEFI), true)

TOP_ROOT_ABS := $(realpath $(TOP))

OPTEE_DIR=$(TOP_ROOT_ABS)/optee
LLOADER_DIR=$(TOP_ROOT_ABS)/optee/l-loader
TOOLS_DIR=$(TOP_ROOT_ABS)/optee/tools-images-hikey960

# https://sx.ix5.org/info/post/android-q-compiling-kernels-in-tree
# make target MUST beging with `out/..` and NOT abs path!
DIST_DIR_PRODUCT?=$(OUT_DIR)/dist

INSTALLER_DIR?=$(TOP_ROOT_ABS)/device/linaro/hikey/installer/$(TARGET_OUT_DIR)

# CLANG is provided as a RO env var by soong
# Note the trailing forward slash!
CLANG_PATH=$(TOP_ROOT_ABS)/$(LLVM_PREBUILTS_PATH)/

# Please use DEBUG=1 (default) in build_uefi.sh due to
# https://bugs.96boards.org/show_bug.cgi?id=806

FIP_BIN ?= $(DIST_DIR_PRODUCT)/fip.bin

# Do NOT prepend $(TOP_ROOT_ABS) here! Else get error
# make: *** /home/first.last/aosp//home/first.last/aosp/optee/optee_os: No such file or directory.  Stop.
# from optee_os/mk/aosp_optee.mk when building.
OPTEE_OS_DIR=optee/optee_os

# rebuild fip.bin whenever optee_os is modified
# build_uefi.sh will always clean before build by default
$(FIP_BIN): $(sort $(shell find -L $(OPTEE_OS_DIR)))
	@# Should we really rm $(PRODUCT_OUT)/optee built by optee_os/aosp_optee.mk and NOT by this file?
	rm -rf $(DIST_DIR_PRODUCT) $(PRODUCT_OUT)/optee
	cd $(OPTEE_DIR) && \
		CLANG=CLANG_5_0 CLANG_PATH=$(CLANG_PATH) $(LLOADER_DIR)/build_uefi.sh && \
		cp fip.bin $(DIST_DIR_PRODUCT)/ && \
		cp fip.bin $(INSTALLER_DIR)/ && \
		cp l-loader.bin $(INSTALLER_DIR)/ && \
		cp ptable-*.img $(INSTALLER_DIR)/
ifneq ($(filter hikey960%, $(TARGET_OUT_DIR)),)
	cp $(LLOADER_DIR)/recovery.bin $(INSTALLER_DIR)/
	cp $(TOOLS_DIR)/hikey_idt $(INSTALLER_DIR)/
	cp $(TOOLS_DIR)/hisi*.img $(INSTALLER_DIR)/
endif

droidcore: $(FIP_BIN)
endif #TARGET_BUILD_UEFI

endif #
