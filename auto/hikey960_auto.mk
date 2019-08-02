$(call inherit-product, device/linaro/hikey/hikey960.mk)
$(call inherit-product, device/linaro/hikey/auto/device.mk)
$(call inherit-product, device/generic/car/common/car.mk)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)

PRODUCT_NAME := hikey960_auto
PRODUCT_DEVICE := hikey960
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP Auto on HiKey960
PRODUCT_MANUFACTURER := Hisilicon
