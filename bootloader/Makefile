AARCH64_TOOLCHAIN=GCC5
DL_DIR=$(ANDROID_BUILD_TOP)/device/linaro
EDK2_DIR=$(ANDROID_BUILD_TOP)/device/linaro/edk2
UEFI_TOOLS_DIR=$(ANDROID_BUILD_TOP)/device/linaro/uefi-tools
INSTALLER_DIR=$(ANDROID_BUILD_TOP)/device/linaro/hikey/installer/hikey960
ATF_DIR=$(ANDROID_BUILD_TOP)/device/linaro/arm-trusted-firmware
OPTEE_OS_DIR=$(ANDROID_BUILD_TOP)/optee/optee_os
PRODUCT_OUT?=out/target/product/hikey960
DIST_DIR?=$(ANDROID_BUILD_TOP)/out/dist
UEFI_BUILD_EXTRA_ARGS =
ifdef DEBUG
	TARGET = DEBUG
else
	TARGET = RELEASE
endif

CMD_RM_OPTEE_OS_OUT = true
CMD_RM_FIP_BIN = true
ifeq ($(TARGET_TEE_IS_OPTEE), true)
	UEFI_BUILD_EXTRA_ARGS+=-s $(OPTEE_OS_DIR)
	CMD_RM_OPTEE_OS_OUT = rm -fr $(OPTEE_OS_DIR)/out
	CMD_RM_FIP_BIN = rm -f $(EDK2_DIR)/Build/HiKey960/$(TARGET)_GCC5/FV/fip.bin $(DIST_DIR)/fip.bin
endif

all: $(DIST_DIR)/fip.bin $(DIST_DIR)/l-loader.bin $(DIST_DIR)/prm_ptable.img

TC64_URL=http://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/aarch64-linux-gnu/gcc-linaro-7.1.1-2017.08-x86_64_aarch64-linux-gnu.tar.xz
TC64 ?= gcc-linaro-7.1.1-2017.08-x86_64_aarch64-linux-gnu
TC32_URL=http://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/arm-linux-gnueabihf/gcc-linaro-7.1.1-2017.08-x86_64_arm-linux-gnueabihf.tar.xz
TC32 ?= gcc-linaro-7.1.1-2017.08-x86_64_arm-linux-gnueabihf

$(DL_DIR)/$(TC64):
ifeq ("$(wildcard $@)","")
	cd $(DL_DIR) && \
	wget $(TC64_URL) && \
	tar xf $(TC64).tar.xz
endif

$(DL_DIR)/$(TC32):
ifeq ("$(wildcard $@)","")
	cd $(DL_DIR) && \
	wget $(TC32_URL) && \
	tar xf $(TC32).tar.xz
endif

# @ build root
# make -j24 TARGET_BUILD_UEFI=true TARGET_TEE_IS_OPTEE=true fip.bin

$(DIST_DIR)/fip.bin: $(DL_DIR)/$(TC64) $(DL_DIR)/$(TC32)
	cd $(EDK2_DIR) && \
	rm -rf Conf/tools_def.txt Conf/BuildEnv.sh  Conf/build_rule.txt Conf/target.txt  Conf/tools_def.txt && \
	export CROSS_COMPILE_32=$(DL_DIR)/$(TC32)/bin/arm-linux-gnueabihf- && \
	export CROSS_COMPILE_64=$(DL_DIR)/$(TC64)/bin/aarch64-linux-gnu- && \
	rm -rf OpenPlatformPkg && \
	ln -sf  $(EDK2_DIR)/../OpenPlatformPkg OpenPlatformPkg && \
	rm -rf $(EDK2_DIR)/Build/  && \
	$(CMD_RM_OPTEE_OS_OUT) && \
	$(CMD_RM_FIP_BIN) && \
	mkdir -p $(EDK2_DIR)/Build/ && \
	mkdir -p $(DIST_DIR) && \
	mkdir -p $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/obj/uefi && \
	ln -sf $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/obj/uefi $(EDK2_DIR)/Build/HiKey960 && \
	$(UEFI_TOOLS_DIR)/uefi-build.sh -b $(TARGET) -D EDK2_OUT_DIR=$(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/obj/uefi -a $(ATF_DIR) $(UEFI_BUILD_EXTRA_ARGS) hikey960 && \
	cp $(EDK2_DIR)/Build/HiKey960/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/fip.bin $(DIST_DIR)/ && \
	cp $(EDK2_DIR)/Build/HiKey960/$(TARGET)_$(AARCH64_TOOLCHAIN)/FV/fip.bin $(INSTALLER_DIR)/

tst_fipbin_bld: $(DIST_DIR)/fip.bin

tst_all: all

$(DIST_DIR)/l-loader.bin: $(DIST_DIR)/fip.bin
	cd $(ANDROID_BUILD_TOP)/device/linaro/l-loader && \
	ln -sf $(EDK2_DIR)/Build/HiKey960/$(TARGET)_GCC5/FV/bl1.bin && \
	ln -sf $(EDK2_DIR)/Build/HiKey960/$(TARGET)_GCC5/FV/BL33_AP_UEFI.fd && \
	make CROSS_COMPILE=arm-linux-androideabi- hikey960 && \
	cp l-loader.bin $(DIST_DIR)/ && \
	cp l-loader.bin $(INSTALLER_DIR)/

$(DIST_DIR)/prm_ptable.img:
	cd $(ANDROID_BUILD_TOP)/device/linaro/l-loader && \
	PTABLE=linux-32g SECTOR_SIZE=4096 SGDISK=./sgdisk bash -x generate_ptable.sh && \
	cp prm_ptable.img $(DIST_DIR)/ && \
	cp prm_ptable.img $(INSTALLER_DIR)/

clean:
	rm -rf $(DIST_DIR)/fip.bin $(INSTALLER_DIR)/fip.bin $(DIST_DIR)/l-loader.bin $(INSTALLER_DIR)/l-loader.bin $(DIST_DIR)/prm_ptable.img $(INSTALLER_DIR)/prm_ptable.img $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/obj/uefi $(EDK2_DIR)/Build/HiKey960
	cd $(EDK2_DIR)/BaseTools && make clean
