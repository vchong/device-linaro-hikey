TOP_ROOT_ABS := $(realpath $(TOP))
AARCH64_TOOLCHAIN=GCC5
EDK2_DIR=$(TOP_ROOT_ABS)/optee/edk2
UEFI_TOOLS_DIR=$(TOP_ROOT_ABS)/optee/uefi-tools
ATF_DIR=$(TOP_ROOT_ABS)/optee/arm-trusted-firmware
OPTEE_OS_DIR=$(TOP_ROOT_ABS)/optee/optee_os
TOOLS_DIR=$(TOP_ROOT_ABS)/optee/tools-images-hikey960
PRODUCT_OUT?=out/target/product/hikey960
DIST_DIR?=$(TOP_ROOT_ABS)/out/dist
INSTALLER_DIR?=$(TOP_ROOT_ABS)/device/linaro/hikey/installer/hikey960
UEFI_BUILD_EXTRA_ARGS =
CROSS_COMPILE_32 ?= $(TOP_ROOT_ABS)/optee/aarch32/bin/arm-linux-gnueabihf-
CROSS_COMPILE_64 ?= $(TOP_ROOT_ABS)/optee/aarch64/bin/aarch64-linux-gnu-
DEBUG=1

ifdef DEBUG
	TARGET = DEBUG
else
	TARGET = RELEASE
endif

FIP_BIN1 ?= $(ATF_DIR)/build/hikey960/release/fip.bin
FIP_BIN2 ?= $(EDK2_DIR)/Build/HiKey960/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/fip.bin

CMD_RM_OPTEE_OS_OUT = true
CMD_RM_FIP_BIN = true
ifeq ($(TARGET_TEE_IS_OPTEE), true)
       UEFI_BUILD_EXTRA_ARGS+=-s $(OPTEE_OS_DIR)
       CMD_RM_OPTEE_OS_OUT = rm -fr $(OPTEE_OS_DIR)/out
       CMD_RM_FIP_BIN = rm -f $(FIP_BIN1) $(FIP_BIN2) $(DIST_DIR)/fip.bin
endif

all: $(DIST_DIR)/fip.bin $(DIST_DIR)/l-loader.bin

$(DIST_DIR)/fip.bin:
	cd $(EDK2_DIR) && \
	rm -rf Conf/tools_def.txt Conf/BuildEnv.sh  Conf/build_rule.txt Conf/target.txt  Conf/tools_def.txt && \
	export CROSS_COMPILE_32=$(CROSS_COMPILE_32) && \
	export CROSS_COMPILE_64=$(CROSS_COMPILE_64) && \
	rm -rf OpenPlatformPkg && \
	ln -sf  $(EDK2_DIR)/../OpenPlatformPkg OpenPlatformPkg && \
	rm -rf $(EDK2_DIR)/Build/  && \
	$(CMD_RM_OPTEE_OS_OUT) && \
	$(CMD_RM_FIP_BIN) && \
	mkdir -p $(EDK2_DIR)/Build/ && \
	mkdir -p $(DIST_DIR) && \
	mkdir -p $(TOP_ROOT_ABS)/$(PRODUCT_OUT)/obj/uefi && \
	ln -sf $(TOP_ROOT_ABS)/$(PRODUCT_OUT)/obj/uefi $(EDK2_DIR)/Build/HiKey960 && \
	$(UEFI_TOOLS_DIR)/uefi-build.sh -b $(TARGET) -D EDK2_OUT_DIR=$(TOP_ROOT_ABS)/$(PRODUCT_OUT)/obj/uefi -a $(ATF_DIR) $(UEFI_BUILD_EXTRA_ARGS) hikey960 && \
	cp $(FIP_BIN2) $(DIST_DIR)/

$(DIST_DIR)/l-loader.bin: $(DIST_DIR)/fip.bin
	cd $(TOP_ROOT_ABS)/optee/l-loader && \
	ln -sf $(EDK2_DIR)/Build/HiKey960/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV//bl1.bin && \
	ln -sf $(EDK2_DIR)/Build/HiKey960/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV//bl2.bin && \
	ln -sf $(EDK2_DIR)/Build/HiKey960/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV//BL33_AP_UEFI.fd && \
	$(MAKE) hikey960 PTABLE_LST=aosp-32g && \
	cp l-loader.bin $(DIST_DIR)/ && \
	cp recovery.bin $(INSTALLER_DIR) && \
	cp prm_ptable.img $(INSTALLER_DIR) && \
	cp $(TOOLS_DIR)/hikey_idt $(INSTALLER_DIR) && \
	cp $(TOOLS_DIR)/hisi*.img $(INSTALLER_DIR)

clean:
	rm -rf $(DIST_DIR)/fip.bin $(DIST_DIR)/l-loader.bin $(TOP_ROOT_ABS)/$(PRODUCT_OUT)/obj/uefi $(EDK2_DIR)/Build/HiKey960
	cd $(EDK2_DIR)/BaseTools && $(MAKE) clean
