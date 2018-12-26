ifneq ($(filter hikey%, $(TARGET_DEVICE)),)

$(PRODUCT_OUT)/vendor/etc/wifi/wifi.apk:
	curl -s -L http://testdata.validation.linaro.org/apks/wifi/wifi.apk -o $@

droidcore: $(PRODUCT_OUT)/vendor/etc/wifi/wifi.apk

endif
