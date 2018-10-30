ifneq ($(filter hikey960%, $(TARGET_DEVICE)),)

ifeq ($(TARGET_BUILD_KERNEL), true)
$(PRODUCT_OUT)/hi3660-hikey960.dtb: all_dtbs
	cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/hi3660-hikey960.dtb $(PRODUCT_OUT)/hi3660-hikey960.dtb

endif
endif
