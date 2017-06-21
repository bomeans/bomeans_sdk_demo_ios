# Copyright (C) 2009 The Android Open Source Project
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

LOCAL_PATH := $(call my-dir)

	include $(CLEAR_VARS)

	LOCAL_MODULE    := car
	LOCAL_SRC_FILES := com_clover_car_TaskThread.cpp \
						common/_itoa.cpp \
						common/Base64.cpp \
						common/buffer_encoder.cpp \
						common/buffer_encoder_noswap.cpp \
						common/ClientSocket.cpp \
						common/ConfigReader.cpp \
						common/FileUtil.cpp \
						common/SDThread.cpp \
						common/SDThreadPool.cpp \
						common/SeqNOGenerator.cpp \
						common/Utility.cpp \
						server/EpollEventServer.cpp \
						server/InterCmdHandler.cpp \
						server/InterCmdManager.cpp \
						server/PollEventServer.cpp \
						server/server.cpp \
						server/Session.cpp \
						server/SessionManager.cpp \
						json/json_reader.cpp \
						json/json_value.cpp \
						json/json_writer.cpp \
												 						
	LOCAL_LDLIBS += -L$(SYSROOT)/usr/lib -llog

	LOCAL_C_INCLUDES := $(LOCAL_PATH)/common \
						$(LOCAL_PATH)/server \
						$(LOCAL_PATH)/json \
						$(LOCAL_PATH)
						

   include $(BUILD_SHARED_LIBRARY)