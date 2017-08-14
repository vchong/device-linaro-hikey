TOP_ROOT_ABS := $(realpath $(TOP))
ifneq ($(filter hikey960%, $(TARGET_OUT_DIR)),)
	AARCH64_TOOLCHAIN=GCC5
	EDK2_DIR=$(TOP_ROOT_ABS)/optee/edk2
	EDK2_BUILD_DIR=$(EDK2_DIR)/Build/HiKey960
	UEFI_TOOLS_DIR=$(TOP_ROOT_ABS)/optee/uefi-tools
	ATF_DIR=$(TOP_ROOT_ABS)/optee/arm-trusted-firmware
	LLOADER_DIR=$(TOP_ROOT_ABS)/optee/l-loader
	PTABLE_LST=aosp-32g
	CROSS_COMPILE_32 ?= $(TOP_ROOT_ABS)/optee/aarch32/bin/arm-linux-gnueabihf-
	CROSS_COMPILE_64 ?= $(TOP_ROOT_ABS)/optee/aarch64/bin/aarch64-linux-gnu-
	TOOLS_DIR=$(TOP_ROOT_ABS)/optee/tools-images-hikey960
else
	# assume hikey
	AARCH64_TOOLCHAIN=GCC49
	EDK2_DIR=$(TOP_ROOT_ABS)/device/linaro/bootloader/edk2
	EDK2_BUILD_DIR=$(EDK2_DIR)/Build/HiKey
	UEFI_TOOLS_DIR=$(TOP_ROOT_ABS)/device/linaro/hikey/uefi-tools
	ATF_DIR=$(TOP_ROOT_ABS)/device/linaro/bootloader/arm-trusted-firmware
	LLOADER_DIR=$(TOP_ROOT_ABS)/device/linaro/hikey/l-loader
	PTABLE_LST="aosp-4g aosp-8g"
	CROSS_COMPILE_32 ?= arm-linux-androideabi-
	CROSS_COMPILE_64 ?= aarch64-linux-android-
endif
OPTEE_OS_DIR=$(TOP_ROOT_ABS)/optee/optee_os
PRODUCT_OUT?=out/target/product/$(TARGET_OUT_DIR)
DIST_DIR?=$(TOP_ROOT_ABS)/out/dist
INSTALLER_DIR?=$(TOP_ROOT_ABS)/device/linaro/hikey/installer/$(TARGET_OUT_DIR)
UEFI_BUILD_EXTRA_ARGS =

# https://bugs.96boards.org/show_bug.cgi?id=806
DEBUG=1
ifdef DEBUG
	TARGET = DEBUG
else
	TARGET = RELEASE
endif

#FIP_BIN1 ?= $(ATF_DIR)/build/$(TARGET_OUT_DIR)/release/fip.bin
FIP_BIN2 ?= $(EDK2_BUILD_DIR)/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/fip.bin
FIP_BIN3 ?= $(DIST_DIR)/fip.bin

CMD_RM_OPTEE_OS_OUT = true
CMD_RM_FIP_BIN = true
ifeq ($(TARGET_TEE_IS_OPTEE), true)
       UEFI_BUILD_EXTRA_ARGS+=-s $(OPTEE_OS_DIR)
# these are not needed anymore now that we made $(DIST_DIR_PRODUCT)/fip.bin
# dependent on optee_os changes in build/tasks/build_uefi.mk
#       CMD_RM_OPTEE_OS_OUT = rm -fr $(OPTEE_OS_DIR)/out
#       CMD_RM_FIP_BIN = rm -f $(FIP_BIN1) $(FIP_BIN2) $(FIP_BIN3)
endif

all: $(FIP_BIN3) $(DIST_DIR)/l-loader.bin

$(FIP_BIN3):
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
	ln -sf $(TOP_ROOT_ABS)/$(PRODUCT_OUT)/obj/uefi $(EDK2_BUILD_DIR) && \
	$(UEFI_TOOLS_DIR)/uefi-build.sh -b $(TARGET) -D EDK2_OUT_DIR=$(TOP_ROOT_ABS)/$(PRODUCT_OUT)/obj/uefi -a $(ATF_DIR) $(UEFI_BUILD_EXTRA_ARGS) $(TARGET_OUT_DIR) && \
	cp $(FIP_BIN2) $(DIST_DIR)/

$(DIST_DIR)/l-loader.bin: $(FIP_BIN3)
ifneq ($(filter hikey960%, $(TARGET_OUT_DIR)),)
	cd $(LLOADER_DIR) && \
	ln -sf $(EDK2_BUILD_DIR)/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/bl1.bin && \
	ln -sf $(EDK2_BUILD_DIR)/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/bl2.bin && \
	ln -sf $(EDK2_BUILD_DIR)/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/BL33_AP_UEFI.fd && \
	$(MAKE) $(TARGET_OUT_DIR) PTABLE_LST=$(PTABLE_LST) && \
	cp l-loader.bin $(DIST_DIR)/ && \
	cp prm_ptable.img $(DIST_DIR) && \
	cp ptable-*.img $(INSTALLER_DIR) && \
	cp recovery.bin $(INSTALLER_DIR) && \
	cp $(TOOLS_DIR)/hikey_idt $(INSTALLER_DIR) && \
	cp $(TOOLS_DIR)/hisi*.img $(INSTALLER_DIR)
else
	# assume hikey
	cd $(LLOADER_DIR) && \
	ln -sf $(EDK2_BUILD_DIR)/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/bl1.bin && \
	$(MAKE) CROSS_COMPILE=$(CROSS_COMPILE_32) $(TARGET_OUT_DIR) PTABLE_LST=$(PTABLE_LST) && \
	cp l-loader.bin $(DIST_DIR)/ && \
	cp prm_ptable.img $(DIST_DIR)/ && \
	cp ptable-*.img $(INSTALLER_DIR)
endif

clean:
	rm -rf $(FIP_BIN3) $(DIST_DIR)/l-loader.bin $(DIST_DIR)/prm_ptable.img $(TOP_ROOT_ABS)/$(PRODUCT_OUT)/obj/uefi $(EDK2_BUILD_DIR)
	cd $(EDK2_DIR)/BaseTools && $(MAKE) clean
