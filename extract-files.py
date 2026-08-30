#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/oneplus/oneplus2',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/lib/libmmcamera2_stats_algorithm.so': blob_fixup()
        .add_needed('libshim_atomic.so'),
    'vendor/lib/mediadrm/libwvdrmengine.so': blob_fixup()
        .add_needed('libcrypto_shim.so')
        .replace_needed('libprotobuf-cpp-lite.so', 'libprotobuf-cpp-lite-v28.so'),
    'vendor/lib64/libsettings.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-full.so', 'libprotobuf-cpp-full-v28.so'),
    'vendor/bin/pm-service': blob_fixup()
        .add_needed('libutils-v33.so'),
    'vendor/lib64/com.quicinc.cne.api@1.0.so': blob_fixup()
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so'),
    'vendor/lib64/libcrypto_keystore.so': blob_fixup()
        .add_needed('libcrypto_shim.so'),
    'vendor/lib64/lib-imsvt.so': blob_fixup()
        .add_needed('libshims_ims.so'),
    'vendor/lib64/libmm-abl.so': blob_fixup()
        .add_needed('libshims_postproc.so'),
    'vendor/lib64/libril-qc-qmi-1.so': blob_fixup()
        .add_needed('libaudioclient_shim.msm8994.so')
        .add_needed('rild_socket.so'),
    'vendor/lib64/libcneapiclient.so': blob_fixup()
        .replace_needed('libhidltransport.so', 'libhidlbase.so')
        .remove_needed('libhwbinder.so'),
    'vendor/lib64/libimsmedia_jni.so': blob_fixup()
        .add_needed('lib-imsvtshim.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'oneplus2',
    'oneplus',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

module.add_proprietary_file('proprietary-files.txt')

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()