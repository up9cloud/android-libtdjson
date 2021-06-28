cmake_minimum_required(VERSION 3.4.1)
project(tdjson)
set(CMAKE_BUILD_TYPE MinSizeRel)

set(root_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../..)

set(openssl_DIR "${root_DIR}/openssl")
set(OPENSSL_FOUND 1)
set(OPENSSL_CRYPTO_LIBRARY "${openssl_DIR}/${ANDROID_ABI}/lib/libcrypto.a")
set(OPENSSL_SSL_LIBRARY "${openssl_DIR}/${ANDROID_ABI}/lib/libssl.a")
set(OPENSSL_INCLUDE_DIR "${openssl_DIR}/include")
set(OPENSSL_LIBRARIES "${OPENSSL_CRYPTO_LIBRARY};${OPENSSL_SSL_LIBRARY}")

set(TD_DIR ${root_DIR}/td)
add_subdirectory(${TD_DIR} td)

if (CMAKE_CROSSCOMPILING)
  # https://www.programmersought.com/article/96492511236/
  string(APPEND CMAKE_CXX_FLAGS " -std=c++14 -fno-omit-frame-pointer -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti")
  string(APPEND CMAKE_SHARED_LINKER_FLAGS " -Wl,--gc-sections -Wl,--exclude-libs,ALL")

  add_library(tdjson_jni SHARED tdjson.cpp)
  set_target_properties(tdjson_jni PROPERTIES OUTPUT_NAME tdjson)

  target_link_libraries(tdjson_jni PRIVATE Td::TdJsonStatic tdcore)
  add_custom_command(TARGET tdjson_jni POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${root_DIR}/jniLibs/${ANDROID_ABI}/lib"
    COMMAND ${CMAKE_STRIP} --strip-sections --strip-unneeded $<TARGET_FILE:tdjson_jni> -o "${root_DIR}/jniLibs/${ANDROID_ABI}/lib/libtdjson.so")
endif()
