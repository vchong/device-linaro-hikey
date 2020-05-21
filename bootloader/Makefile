TOP_ROOT_ABS := $(realpath $(TOP))

LLOADER_DIR=$(TOP_ROOT_ABS)/optee/l-loader
TOOLS_DIR=$(TOP_ROOT_ABS)/optee/tools-images-hikey960

DIST_DIR?=$(TOP_ROOT_ABS)/out/dist
INSTALLER_DIR?=$(TOP_ROOT_ABS)/device/linaro/hikey/installer/$(TARGET_OUT_DIR)

# Note the trailing forward slash!
CLANG_PATH=$(TOP_ROOT_ABS)/$(LLVM_PREBUILTS_PATH)/

# Please use DEBUG=1 (default) in build_uefi.sh due to
# https://bugs.96boards.org/show_bug.cgi?id=806

FIP_BIN1 ?= $(ATF_DIR)/build/$(TARGET_OUT_DIR)/release/fip.bin
FIP_BIN2 ?= $(DIST_DIR)/fip.bin
LLOADER_BIN ?= $(DIST_DIR)/l-loader.bin

all: $(FIP_BIN2) $(LLOADER_BIN)

$(FIP_BIN2):
	cd $(LLOADER_DIR)/../ && \
		CLANG=CLANG_5_0 CLANG_PATH=$(CLANG_PATH) $(LLOADER_DIR)/build_uefi.sh
	cp $(FIP_BIN1) $(DIST_DIR)/

$(LLOADER_BIN): $(FIP_BIN2)
	cd $(LLOADER_DIR) && \
		cp l-loader.bin $(DIST_DIR)/ && \
		cp ptable-*.img $(DIST_DIR)/ && \
		cp ptable-*.img $(INSTALLER_DIR)/
ifneq ($(filter hikey960%, $(TARGET_OUT_DIR)),)
	cd $(LLOADER_DIR) && \
		cp recovery.bin $(INSTALLER_DIR)/ && \
		cp $(TOOLS_DIR)/hikey_idt $(INSTALLER_DIR)/ && \
		cp $(TOOLS_DIR)/hisi*.img $(INSTALLER_DIR)/
endif

clean:
	rm -rf $(FIP_BIN2) $(LLOADER_BIN) $(DIST_DIR)/ptable-*.img
	cd $(LLOADER_DIR)/../ && \
		CLEAN=2 $(LLOADER_DIR)/build_uefi.sh
