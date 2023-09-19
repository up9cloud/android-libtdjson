//
// Copyright Aliaksei Levin (levlam@telegram.org), Arseny Smirnov (arseny30@gmail.com) 2014-2020
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
#include <td/telegram/td_json_client.h>
#include <td/tl/tl_jni_object.h>

#include <jni.h>

extern "C" {

JNIEXPORT jint JNICALL Java_io_github_up9cloud_td_JsonClient_td_1create_1client_1id(JNIEnv *env, jclass clazz) {
  return (jint)td_create_client_id();
}

JNIEXPORT void JNICALL Java_io_github_up9cloud_td_JsonClient_td_1send(JNIEnv *env, jclass clazz, jint client_id, jstring request) {
  td_send(client_id, td::jni::from_jstring(env, request).c_str());
}

JNIEXPORT jstring JNICALL Java_io_github_up9cloud_td_JsonClient_td_1receive(JNIEnv *env, jclass clazz, jdouble timeout) {
  auto result = td_receive(timeout);
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

JNIEXPORT jstring JNICALL Java_io_github_up9cloud_td_JsonClient_td_1execute(JNIEnv *env, jclass clazz, jstring request) {
  auto result = td_execute(td::jni::from_jstring(env, request).c_str());
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

// see https://github.com/tdlib/td/blob/master/example/java/td_jni.cpp
static constexpr jint JAVA_VERSION = JNI_VERSION_1_6;
static JavaVM *java_vm;
static jobject log_message_handler;
static void on_log_message(int verbosity_level, const char *log_message) {
  auto env = td::jni::get_jni_env(java_vm, JAVA_VERSION);
  if (env == nullptr) {
    return;
  }

  jobject handler = env->NewLocalRef(log_message_handler);
  if (!handler) {
    return;
  }

  jclass handler_class = env->GetObjectClass(handler);
  if (handler_class) {
    jmethodID on_log_message_method = env->GetMethodID(handler_class, "call", "(ILjava/lang/String;)V");
    if (on_log_message_method) {
      jstring log_message_str = td::jni::to_jstring(env.get(), log_message);
      if (log_message_str) {
        env->CallVoidMethod(handler, on_log_message_method, static_cast<jint>(verbosity_level), log_message_str);
        env->DeleteLocalRef((jobject)log_message_str);
      }
    }
    env->DeleteLocalRef((jobject)handler_class);
  }

  env->DeleteLocalRef(handler);
}
JNIEXPORT void JNICALL Java_io_github_up9cloud_td_JsonClient_td_td_1set_1log_1message_1callback(JNIEnv *env, jclass clazz, jint max_verbosity_level, jobject new_log_message_handler) {
  if (log_message_handler) {
    td_set_log_message_callback(0, nullptr);
    jobject old_log_message_handler = log_message_handler;
    log_message_handler = jobject();
    env->DeleteGlobalRef(old_log_message_handler);
  }

  if (new_log_message_handler) {
    log_message_handler = env->NewGlobalRef(new_log_message_handler);
    if (!log_message_handler) {
      // out of memory
      return;
    }

    td_set_log_message_callback(static_cast<int>(max_verbosity_level), on_log_message);
  }
}

// following will be removed in TDLib 2.0.0.

JNIEXPORT jlong JNICALL Java_io_github_up9cloud_td_JsonClient_td_1json_1client_1create(JNIEnv *env, jclass clazz) {
  return reinterpret_cast<jlong>(td_json_client_create());
}

JNIEXPORT void JNICALL Java_io_github_up9cloud_td_JsonClient_td_1json_1client_1send(JNIEnv *env, jclass clazz, jlong client, jstring request) {
  td_json_client_send(reinterpret_cast<void *>(client), td::jni::from_jstring(env, request).c_str());
}

JNIEXPORT jstring JNICALL Java_io_github_up9cloud_td_JsonClient_td_1json_1client_1receive(JNIEnv *env, jclass clazz, jlong client, jdouble timeout) {
  auto result = td_json_client_receive(reinterpret_cast<void *>(client), timeout);
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

JNIEXPORT jstring JNICALL Java_io_github_up9cloud_td_JsonClient_td_1json_1client_1execute(JNIEnv *env, jclass clazz, jlong client, jstring request) {
  auto result = td_json_client_execute(reinterpret_cast<void *>(client), td::jni::from_jstring(env, request).c_str());
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

JNIEXPORT void JNICALL Java_io_github_up9cloud_td_JsonClient_td_1json_1client_1destroy(JNIEnv *env, jclass clazz, jlong client) {
  td_json_client_destroy(reinterpret_cast<void *>(client));
}

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved) {
  java_vm = vm;
  return JAVA_VERSION;
}

}