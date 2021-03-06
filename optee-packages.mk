OPTEE_PLATFORM ?= hikey
OPTEE_PLATFORM_FLAVOR ?= $(TARGET_DEVICE)
OPTEE_CFG_ARM64_CORE ?= y
OPTEE_TA_TARGETS ?= ta_arm64
OPTEE_OS_DIR ?= optee/optee_os
OPTEE_EXTRA_FLAGS ?= CFG_TEE_CORE_LOG_LEVEL=3 CFG_TEE_TA_LOG_LEVEL=3 DEBUG=1
#OPTEE_EXTRA_FLAGS ?= CFG_TEE_CORE_LOG_LEVEL=3 CFG_TEE_TA_LOG_LEVEL=3
BUILD_OPTEE_MK := $(OPTEE_OS_DIR)/mk/aosp_optee.mk

# OP TEE client library and service
PRODUCT_PACKAGES += libteec \
                    tee-supplicant

# optee_test and TA
PRODUCT_PACKAGES += xtest
# os_test_lib
PRODUCT_PACKAGES += ffd2bded-ab7d-4988-95ee-e4962fff7154.ta
# os_test
PRODUCT_PACKAGES += 5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta
# concurrent_large
PRODUCT_PACKAGES += 5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta
# sha_perf
PRODUCT_PACKAGES += 614789f2-39c0-4ebf-b235-92b32ac107ed.ta
# storage2
PRODUCT_PACKAGES += 731e279e-aafb-4575-a771-38caa6f0cca6.ta
# storage
PRODUCT_PACKAGES += b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta
# create_fail_test
PRODUCT_PACKAGES += c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta
# crypt
PRODUCT_PACKAGES += cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta
# rpc_test
PRODUCT_PACKAGES += d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta
# concurrent
PRODUCT_PACKAGES += e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta
# aes_perf
PRODUCT_PACKAGES += e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta
# sims
PRODUCT_PACKAGES += e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta
# storage_benchmark
PRODUCT_PACKAGES += f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta
# socket
PRODUCT_PACKAGES += 873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta
# sdp-basic
PRODUCT_PACKAGES += 12345678-5b69-11e4-9dbb-101f74f00099.ta
# miss
PRODUCT_PACKAGES += 528938ce-fc59-11e8-8eb2-f2801f1b9fd1.ta
# keepalive
PRODUCT_PACKAGES += a4c04d50-f180-11e8-8eb2-f2801f1b9fd1.ta

# optee examples
PRODUCT_PACKAGES += optee_example_hello_world
PRODUCT_PACKAGES += 8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta
PRODUCT_PACKAGES += optee_example_random
PRODUCT_PACKAGES += b6c53aba-9669-4668-a7f2-205629d00f86.ta
PRODUCT_PACKAGES += optee_example_aes
PRODUCT_PACKAGES += 5dbac793-f574-4871-8ad3-04331ec17f24.ta
PRODUCT_PACKAGES += optee_example_hotp
PRODUCT_PACKAGES += 484d4143-2d53-4841-3120-4a6f636b6542.ta
PRODUCT_PACKAGES += optee_example_acipher
PRODUCT_PACKAGES += a734eed9-d6a1-4244-aa50-7c99719e7b7b.ta
PRODUCT_PACKAGES += optee_example_secure_storage
PRODUCT_PACKAGES += f4e750bb-1437-4fbf-8785-8d3580c34994.ta

# kmgk
PRODUCT_PACKAGES += dba51a17-0563-11e7-93b1-6fa7b0071a51.ta
PRODUCT_PACKAGES += 4d573443-6a56-4272-ac6f-2425af9ef9bb.ta
PRODUCT_PACKAGES += wait_for_keymaster_optee
PRODUCT_PACKAGES += KMGK_gtest
