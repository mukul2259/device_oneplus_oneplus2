# Copyright (C) 2015 The CyanogenMod Project
# Copyright (C) 2017-2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

SELINUX_IGNORE_NEVERALLOWS := true

BUILD_BROKEN_PREBUILT_ELF_FILES := true

BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

RELAX_USES_LIBRARY_CHECK=true

TARGET_OTA_ASSERT_DEVICE := OnePlus2,oneplus2

PLATFORM_PATH := device/oneplus/oneplus2

BOARD_VENDOR := oneplus

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8994
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := msm8994

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# Kernel
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom ehci-hcd.park=3 lpm_levels.sleep_disabled=1 boot_cpus=0-3 loop.max_part=7 androidboot.init_fatal_reboot_target=recovery
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/oneplus/msm8994
TARGET_KERNEL_CONFIG := oneplus2_defconfig
TARGET_KERNEL_CLANG_COMPILE := false

# Audio
AUDIO_FEATURE_ENABLED_ACDB_LICENSE := true
AUDIO_FEATURE_ENABLED_COMPRESS_CAPTURE := true
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := true
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := false
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_FLAC_OFFLOAD := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_HFP := true
AUDIO_FEATURE_ENABLED_INCALL_MUSIC := false
AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD_24 := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true

AUDIO_USE_LL_AS_PRIMARY_OUTPUT := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true

# Bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
QCOM_BT_USE_BTNV := true

# Board
TARGET_BOARD_INFO_FILE ?= $(PLATFORM_PATH)/board-info.txt

# Camera
MALLOC_SVELTE_FOR_LIBC32 := true
TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
    /system/vendor/bin/mm-qcamera-daemon=22

# Display
TARGET_SCREEN_DENSITY := 480

# Filesystem
TARGET_FS_CONFIG_GEN := $(PLATFORM_PATH)/config.fs

# Graphics
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x02000000U
TARGET_USES_ION := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_HWC2 := true
TARGET_DISABLE_POSTRENDER_CLEANUP := true

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(PLATFORM_PATH)/framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix_legacy.xml \
    vendor/lineage/config/device_framework_matrix.xml

DEVICE_MANIFEST_FILE := $(PLATFORM_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(PLATFORM_PATH)/compatibility_matrix.xml

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(PLATFORM_PATH)/include

# Init
TARGET_INIT_VENDOR_LIB := //$(PLATFORM_PATH):libinit_oneplus2
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# IPA
USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR := true

# Keystore
TARGET_PROVIDES_KEYMASTER := true

# Lineage Health
TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_BYPASS := false

# Legacy memfd
TARGET_HAS_MEMFD_BACKPORT := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_ROOT_EXTRA_FOLDERS := firmware bt_firmware persist
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_USERDATAIMAGE_PARTITION_SIZE := 59047394304
BOARD_FLASH_BLOCK_SIZE := 262144
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Power
TARGET_TAP_TO_WAKE_NODE := "/proc/touchpanel/double_tap"

# QCOM hardware
BOARD_USES_QCOM_HARDWARE := true

# Releasetools
TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_oneplus2
TARGET_RELEASETOOLS_EXTENSIONS := $(PLATFORM_PATH)

# SELinux
include device/qcom/sepolicy-legacy/sepolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/private

# Shims
TARGET_LD_SHIM_LIBS := \
    /system/vendor/lib64/lib-imsvt.so|libshims_ims.so \
    /system/vendor/lib64/lib-imsdpl.so|libshims_boringssl.so \
    /system/vendor/lib/libmmcamera2_stats_algorithm.so|libshim_atomic.so \
    /system/vendor/lib64/libril-qc-qmi-1.so|libaudioclient_shim.so \
    /system/vendor/lib64/libril-qc-qmi-1.so|rild_socket.so \
    /system/vendor/lib64/libmm-abl.so|libshims_postproc.so \
    /system/vendor/lib64/libimsmedia_jni.so|lib-imsvtshim.so

# Wifi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
TARGET_USES_WCNSS_CTRL := true
TARGET_USES_QCOM_WCNSS_QMI := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WIFI_AVOID_IFACE_RESET_MAC_CHANGE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Recovery
TARGET_RECOVERY_FSTAB := $(PLATFORM_PATH)/rootdir/etc/fstab.qcom

# inherit from the proprietary version
include vendor/oneplus/oneplus2/BoardConfigVendor.mk
