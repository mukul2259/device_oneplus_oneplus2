# Copyright 2010 The Android Open Source Project
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

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := rild_socket.c
LOCAL_MODULE := rild_socket
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := atomic.cpp
LOCAL_MODULE := libshim_atomic
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_VENDOR_MODULE := true
LOCAL_HEADER_LIBRARIES := libcutils_headers

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := libaudioclient_shim.cpp
LOCAL_MODULE := libaudioclient_shim
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_SHARED_LIBRARIES := libaudioclient

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := libshim_mediabuffer.cpp

LOCAL_SHARED_LIBRARIES := libstagefright_foundation libui libgui libmedia

LOCAL_MODULE := libshims_ims
LOCAL_MODULE_TAGS := optional
LOCAL_MULTILIB := 64

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := libshims_postproc.cpp
LOCAL_CFLAGS := -Wno-unused-parameter
LOCAL_MODULE := libshims_postproc
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := lib-imsvtshim.cpp
LOCAL_MODULE := lib-imsvtshim
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)
