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

all: $(FIP_BIN)

# build_uefi.sh will always clean before build by default
$(FIP_BIN):
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

clean:
	rm -rf $(DIST_DIR_PRODUCT)
	cd $(OPTEE_DIR) && \
		CLEAN=2 $(LLOADER_DIR)/build_uefi.sh
