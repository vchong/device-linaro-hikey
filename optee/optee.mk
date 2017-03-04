# OP-TEE OS
OPTEE_OS_DIR 		?= device/linaro/bootloader/optee_os
OPTEE_PLATFORM 		?= hikey
OPTEE_CFG_ARM64_CORE 	?= y
OPTEE_TA_TARGETS 	?= ta_arm64

# The main OP-TEE AOSP makefile
BUILD_OPTEE_MK 		:= $(OPTEE_OS_DIR)/mk/aosp_optee.mk

# The Makefiles etc used to build Trusted Applications
TA_DEV_KIT_DIR 		:= $(OPTEE_OS_DIR)/out/arm-plat-hikey/export-ta_arm64

# Init files related to OP-TEE
PRODUCT_COPY_FILES	+= device/linaro/hikey/optee/init.optee.rc:root/init.hikey.optee.rc

# OP-TEE Normal World components
PRODUCT_PACKAGES += libteec \
	tee-supplicant \
	tee_helloworld \
	xtest

# Trusted Applications
# create_fail_test
PRODUCT_PACKAGES += c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta
# crypt
PRODUCT_PACKAGES += cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta
# sha_perf
PRODUCT_PACKAGES += 614789f2-39c0-4ebf-b235-92b32ac107ed.ta
# storage
PRODUCT_PACKAGES += b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta
# concurrent
PRODUCT_PACKAGES += e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta
# concurrent_large
PRODUCT_PACKAGES += 5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta
# os_test
PRODUCT_PACKAGES += 5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta
# rpc_test
PRODUCT_PACKAGES += d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta
# sims
PRODUCT_PACKAGES += e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta
# aes_perf
PRODUCT_PACKAGES += e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta
# storage2
PRODUCT_PACKAGES += 731e279e-aafb-4575-a771-38caa6f0cca6.ta
# storage_benchmark
PRODUCT_PACKAGES += f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta
# socket
PRODUCT_PACKAGES += 873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta

# Hello world
PRODUCT_PACKAGES += 8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta
