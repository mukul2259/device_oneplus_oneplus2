#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=oneplus2
VENDOR=oneplus

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
    vendor/lib/libmmcamera2_stats_algorithm.so)
        patchelf --add-needed "libshim_atomic.so" "${2}"
    ;;
    vendor/lib/mediadrm/libwvdrmengine.so)
        "${PATCHELF}" --add-needed "libcrypto_shim.so" "${2}"
        patchelf --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-v28.so" "${2}"
    ;;
    vendor/lib64/libsettings.so)
        patchelf --replace-needed "libprotobuf-cpp-full.so" "libprotobuf-cpp-full-v28.so" "${2}"
    ;;
    vendor/bin/pm-service)
        grep -q libutils-v33.so "${2}" || "${PATCHELF}" --add-needed "libutils-v33.so" "${2}"
    ;;
    vendor/lib64/com.quicinc.cne.api@1.0.so)
        patchelf --replace-needed "libhidlbase.so" "libhidlbase-v32.so" "${2}"
    ;;
    vendor/lib64/libcrypto_keystore.so)
       "${PATCHELF}" --add-needed "libcrypto_shim.so" "${2}"
    ;;
    vendor/lib64/lib-imsvt.so)
        patchelf --add-needed "libshims_ims.so" "${2}"
    ;;
    vendor/lib64/libmm-abl.so)
        patchelf --add-needed "libshims_postproc.so" "${2}"
    ;;
    vendor/lib64/libril-qc-qmi-1.so)
        patchelf --add-needed "libaudioclient_shim.so" "${2}"
        patchelf --add-needed "rild_socket.so" "${2}"
    ;;
    vendor/lib64/libimsmedia_jni.so)
        patchelf --add-needed "lib-imsvtshim.so" "${2}"
    ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"$MY_DIR"/setup-makefiles.sh
