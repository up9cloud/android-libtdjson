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

  add_library(tdjson_android SHARED td_json_jni.cpp ${root_DIR}/td/td/telegram/td_json_client.cpp)
  target_link_libraries(tdjson_android PRIVATE Td::TdJsonStatic tdcore)
  set_target_properties(tdjson_android PROPERTIES
    OUTPUT_NAME tdjson
    # LIBRARY_OUTPUT_DIRECTORY ${root_DIR}/jniLibs/${ANDROID_ABI}
  )
  add_custom_command(TARGET tdjson_android POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${root_DIR}/jniLibs/${ANDROID_ABI}"
    # Options should be same as ./strip.sh
    # Don't use "--strip-sections", it will cause error:
    # E/linker  ... /lib/x86_64/libtdjson.so" has unsupported e_shentsize: 0x0 (expected 0x40)
    COMMAND ${CMAKE_STRIP} --strip-debug --strip-unneeded $<TARGET_FILE:tdjson_android> -o "${root_DIR}/jniLibs/${ANDROID_ABI}/libtdjson.so"
  )
  # TODO: don't know how to assgin target of sub folder, so strip in build.sh instead here.
  # add_custom_command(TARGET ??? POST_BUILD
  #   COMMAND ${CMAKE_COMMAND} -E rename $<TARGET_FILE:tdjson_android> $<TARGET_FILE:tdjson_android>.debug
  #   COMMAND ${CMAKE_COMMAND} -E make_directory "${root_DIR}/libs/${ANDROID_ABI}"
  #   COMMAND ${CMAKE_STRIP} --strip-debug --strip-unneeded $<TARGET_FILE_DIR:tdjson_android>/td/libtdjson.so -o "${root_DIR}/libs/${ANDROID_ABI}/libtdjson.so"
  # )
endif()
