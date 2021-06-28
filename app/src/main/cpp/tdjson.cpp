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

JNIEXPORT jlong JNICALL Java_org_drinkless_tdlib_JsonClient_td_1json_1client_1create(JNIEnv *env, jclass clazz) {
  return reinterpret_cast<jlong>(td_json_client_create());
}

JNIEXPORT void JNICALL Java_org_drinkless_tdlib_JsonClient_td_1json_1client_1send(JNIEnv *env, jclass clazz, jlong client, jstring request) {
  td_json_client_send(reinterpret_cast<void *>(client), td::jni::from_jstring(env, request).c_str());
}

JNIEXPORT jstring JNICALL Java_org_drinkless_tdlib_JsonClient_td_1json_1client_1receive(JNIEnv *env, jclass clazz, jlong client, jdouble timeout) {
  auto result = td_json_client_receive(reinterpret_cast<void *>(client), timeout);
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

JNIEXPORT jstring JNICALL Java_org_drinkless_tdlib_JsonClient_td_1json_1client_1execute(JNIEnv *env, jclass clazz, jlong client, jstring request) {
  auto result = td_json_client_execute(reinterpret_cast<void *>(client), td::jni::from_jstring(env, request).c_str());
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

JNIEXPORT void JNICALL Java_org_drinkless_tdlib_JsonClient_td_1json_1client_1destroy(JNIEnv *env, jclass clazz, jlong client) {
  td_json_client_destroy(reinterpret_cast<void *>(client));
}

JNIEXPORT jint JNICALL Java_org_drinkless_tdlib_JsonClient_td_1create_1client_1id(JNIEnv *env, jclass clazz) {
  return (jint)td_create_client_id();
}

JNIEXPORT void JNICALL Java_org_drinkless_tdlib_JsonClient_td_1send(JNIEnv *env, jclass clazz, jint client_id, jstring request) {
  td_send(client_id, td::jni::from_jstring(env, request).c_str());
}

JNIEXPORT jstring JNICALL Java_org_drinkless_tdlib_JsonClient_td_1receive(JNIEnv *env, jclass clazz, jdouble timeout) {
  auto result = td_receive(timeout);
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

JNIEXPORT jstring JNICALL Java_org_drinkless_tdlib_JsonClient_td_1execute(JNIEnv *env, jclass clazz, jstring request) {
  auto result = td_execute(td::jni::from_jstring(env, request).c_str());
  if (result == nullptr) {
    return nullptr;
  }
  return td::jni::to_jstring(env, result);
}

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved) {
  return JNI_VERSION_1_6;
}

}