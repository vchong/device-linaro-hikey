#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "Provide the right /dev/ttyUSBX specific to recovery device"
    exit
fi

if [ ! -e "${1}" ]
  then
    echo "device: ${1} does not exist"
    exit
fi
DEVICE_PORT="${1}"
PTABLE=prm_ptable.img

INSTALLER_DIR="`dirname ${0}`"
FIRMWARE_DIR="${INSTALLER_DIR}"

# for cases that don't run "lunch hikey960-userdebug"
if [ -z "${ANDROID_BUILD_TOP}" ]; then
    ANDROID_BUILD_TOP=${INSTALLER_DIR}/../../../../../
    ANDROID_PRODUCT_OUT="${ANDROID_BUILD_TOP}/out/target/product/hikey960"
fi

if [ -z "${DIST_DIR}" ]; then
    DIST_DIR="${ANDROID_BUILD_TOP}"/out/dist
fi

#get out directory path
while [ $# -ne 0 ]; do
    case "${1}" in
        --out) OUT_IMGDIR=${2};shift;;
        --use-compiled-binaries) FIRMWARE_DIR="${DIST_DIR}";shift;;
    esac
    shift
done

if [[ "${FIRMWARE_DIR}" == "${DIST_DIR}" && ! -e "${DIST_DIR}"/fip.bin && ! -e "${DIST_DIR}"/l-loader.bin ]]; then
    echo "No binaries found at ${DIST_DIR}. Please build the bootloader first"
    exit
fi

if [ -z "${OUT_IMGDIR}" ]; then
    if [ ! -z "${ANDROID_PRODUCT_OUT}" ]; then
        OUT_IMGDIR="${ANDROID_PRODUCT_OUT}"
    fi
fi

if [ ! -d "${OUT_IMGDIR}" ]; then
    echo "error in locating out directory, check if it exist"
    exit
fi

echo "android out dir:${OUT_IMGDIR}"

echo "flashing recovery images.. please wait ~10 seconds"
sudo "${INSTALLER_DIR}"/hikey_idt -c config -p "${DEVICE_PORT}"
sleep 10
echo "set a unique serial number"
serialno=`fastboot getvar serialno 2>&1 > /dev/null`
if [ "${serialno:10:6}" == "(null)" ]; then
    fastboot oem serialno
else
    if [ "${serialno:10:15}" == "0123456789abcde" ]; then
        fastboot oem serialno
    fi
fi
echo "flashing all other images"
fastboot flash ptable "${INSTALLER_DIR}"/prm_ptable.img
fastboot flash xloader "${INSTALLER_DIR}"/hisi-sec_xloader.img
fastboot flash fastboot "${INSTALLER_DIR}"/l-loader.bin
fastboot flash fip "${INSTALLER_DIR}"/fip.bin
#fastboot flash nvme "${INSTALLER_DIR}"/hisi-nvme.img
fastboot flash boot "${ANDROID_PRODUCT_OUT}"/boot.img
fastboot flash cache "${ANDROID_PRODUCT_OUT}"/cache.img
fastboot flash system "${ANDROID_PRODUCT_OUT}"/system.img
fastboot flash userdata "${ANDROID_PRODUCT_OUT}"/userdata.img
fastboot flash vendor "${ANDROID_PRODUCT_OUT}"/vendor.img
